#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import logging
import os
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List, Tuple

if __package__ in {None, ''}:
    import sys as _sys
    _sys.path.append(str(Path(__file__).resolve().parents[1]))
    from runtime.artifacts import ensure_run_dirs, utc_now_stamp, write_json, write_packets, write_text
    from runtime.file_locks import release_all_for_owner
    from runtime.metrics_auto import update_metrics, write_session_updates
    from runtime.promotion import collect_promotion_candidates, render_approval_summary
    from runtime.review_chain import generate_review, persist_review
    from runtime.task_packets import create_packets
    from runtime.tiers import WAVES, parse_mode
else:
    from .artifacts import ensure_run_dirs, utc_now_stamp, write_json, write_packets, write_text
    from .file_locks import release_all_for_owner
    from .metrics_auto import update_metrics, write_session_updates
    from .promotion import collect_promotion_candidates, render_approval_summary
    from .review_chain import generate_review, persist_review
    from .task_packets import create_packets
    from .tiers import WAVES, parse_mode

MAX_REVISION_ROUNDS = 2
DEFAULT_WORKER_TIMEOUT = 300
LOGGER = logging.getLogger(__name__)


def _worker_timeout_seconds() -> int:
    raw_timeout = os.environ.get('CODEX_WORKER_TIMEOUT', str(DEFAULT_WORKER_TIMEOUT))
    try:
        timeout = int(raw_timeout)
    except (TypeError, ValueError):
        return DEFAULT_WORKER_TIMEOUT
    return timeout if timeout > 0 else DEFAULT_WORKER_TIMEOUT


def run_worker(worker_script: Path, packet_path: Path, output_path: Path, run_root: Path, revision_round: int) -> Dict[str, str]:
    timeout = _worker_timeout_seconds()
    process = subprocess.Popen([
        sys.executable,
        str(worker_script),
        str(packet_path),
        str(output_path),
        str(run_root),
        str(revision_round),
    ], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    try:
        stdout, stderr = process.communicate(timeout=timeout)
        return {
            'packet': packet_path.name,
            'output': str(output_path),
            'returncode': str(process.returncode),
            'stdout': stdout,
            'stderr': stderr,
            'revision_round': str(revision_round),
        }
    except subprocess.TimeoutExpired:
        process.kill()
        stdout, stderr = process.communicate()
        timeout_message = f'Worker timed out after {timeout}s'
        LOGGER.error('%s: %s', timeout_message, packet_path.name)
        return {
            'packet': packet_path.name,
            'output': str(output_path),
            'returncode': '124',
            'stdout': stdout,
            'stderr': '\n'.join(part for part in [stderr.rstrip(), timeout_message] if part),
            'revision_round': str(revision_round),
            'status': 'timeout',
            'timeout_seconds': str(timeout),
        }


def orchestrate(root: Path, prompt: str) -> int:
    mode = parse_mode(prompt)
    run_id = utc_now_stamp()
    paths = ensure_run_dirs(root, run_id)
    packets = create_packets(root, prompt, mode)
    write_packets(paths, packets)
    worker_script = root / '.codex' / 'runtime' / 'agent_worker.py'
    execution_log: List[Dict[str, str]] = []
    review_results: List[str] = []
    fallback_rows: List[str] = []

    for wave_name, tiers in WAVES:
        if wave_name == 'wave6-consolidation':
            continue
        wave_packets = [p for p in packets if p.tier in tiers]
        if not wave_packets:
            continue
        pending = wave_packets
        revision_round = 0
        while pending and revision_round <= MAX_REVISION_ROUNDS:
            round_results = execute_wave(worker_script, paths, pending, revision_round)
            execution_log.extend(round_results)
            next_pending = []
            for packet in pending:
                report_path = paths['agents'] / f'{packet.agent_id}.md'
                report_body = report_path.read_text(encoding='utf-8') if report_path.exists() else 'Status: Failed'
                if packet.review_target and packet.review_target != packet.tier:
                    review = generate_review(
                        review_id=f'{packet.review_target}-review-{packet.agent_id}-r{revision_round}',
                        reviewer_tier=packet.review_target,
                        item_under_review=packet.agent_id,
                        body=report_body,
                    )
                    review_path = paths['reviews'] / f'{packet.review_target}-review-{packet.agent_id}-r{revision_round}.md'
                    persist_review(review_path, review, prompt)
                    review_results.append(f'{review.review_id}:{review.decision}')
                    if review.decision == 'Revision Required' and revision_round < MAX_REVISION_ROUNDS:
                        next_pending.append(packet)
                    elif review.decision == 'Revision Required':
                        fallback_rows.append(make_fallback_row(packet['agent_id'] if isinstance(packet, dict) else packet.agent_id, packet.tier if hasattr(packet, 'tier') else packet['tier'], packet.expected_model if hasattr(packet, 'expected_model') else packet['expected_model']))
            pending = next_pending
            revision_round += 1

    for packet in packets:
        release_all_for_owner(root, paths['run_root'], packet.agent_id)
    write_json(paths['logs'] / 'execution-log.json', execution_log)
    promotion_candidates = collect_promotion_candidates(root, paths['run_root'])
    approval_summary = render_approval_summary(promotion_candidates)
    write_text(paths['run_root'] / 'promotion-summary.md', approval_summary)
    final_summary = render_final_summary(run_id, mode, prompt, packets, execution_log, paths, review_results, fallback_rows, approval_summary)
    write_text(paths['run_root'] / 'final-summary.md', final_summary)
    update_metrics(root, run_id, prompt, [p.to_dict() for p in packets], review_results, fallback_rows)
    write_session_updates(root, run_id, prompt, mode, fallback_rows)
    print(final_summary)
    return 0 if all(x['returncode'] == '0' for x in execution_log) else 1


def execute_wave(worker_script: Path, paths: Dict[str, Path], wave_packets: List, revision_round: int) -> List[Dict[str, str]]:
    results: List[Dict[str, str]] = []
    with ThreadPoolExecutor(max_workers=len(wave_packets)) as pool:
        futures = []
        for packet in wave_packets:
            packet_path = paths['packets'] / f'{packet.agent_id}.json'
            output_path = paths['agents'] / f'{packet.agent_id}.md'
            futures.append(pool.submit(run_worker, worker_script, packet_path, output_path, paths['run_root'], revision_round))
        for future in as_completed(futures):
            results.append(future.result())
    return results


def render_final_summary(run_id: str, mode: str, prompt: str, packets: List, execution_log: List[Dict[str, str]], paths: Dict[str, Path], review_results: List[str], fallback_rows: List[str], approval_summary: str) -> str:
    completed = len([p for p in packets if (paths['agents'] / f'{p.agent_id}.md').exists()])
    failed = len(packets) - completed
    lines = [
        '# Local Multi-Agent Run Summary',
        '',
        f'- run_id: {run_id}',
        f'- prompt: {prompt}',
        f'- mode: {mode}',
        f'- packet_count: {len(packets)}',
        f'- completed_workers: {completed}',
        f'- failed_workers: {failed}',
        f'- artifacts: {paths["run_root"]}',
        f'- fallback_count: {len(fallback_rows)}',
        '',
        '## Wave Coverage',
    ]
    for wave_name, tiers in WAVES:
        if wave_name == 'wave6-consolidation':
            lines.append(f'- {wave_name}: orchestrator final summary emitted')
        else:
            count = len([p for p in packets if p.tier in tiers])
            lines.append(f'- {wave_name}: {count} worker(s)')
    lines += [
        '',
        '## Review Decisions',
        *([f'- {item}' for item in review_results] if review_results else ['- none']),
        '',
        '## Fallback Rows',
        *([f'- {item}' for item in fallback_rows] if fallback_rows else ['- none']),
        '',
        '## Artifacts',
        f'- manifest: {paths["run_root"] / "manifest.json"}',
        f'- packets: {paths["packets"]}',
        f'- agents: {paths["agents"]}',
        f'- reviews: {paths["reviews"]}',
        f'- execution-log: {paths["logs"] / "execution-log.json"}',
        f'- promotion-summary: {paths["run_root"] / "promotion-summary.md"}',
        '',
        '## Approval Gate',
        *[f'- {line}' for line in approval_summary.splitlines() if line and not line.startswith('#')],
        '',
        '## Notes',
        '- Safe file-writing is enforced by tier-scoped write policy.',
        '- Revision Required results can retry up to 2 rounds before escalation/fallback logging.',
        '- Metrics, session summary, resume, and active plan are auto-updated after the run.',
        '- This remains a local orchestration runtime, not a hosted remote LLM mesh.',
    ]
    return '\n'.join(lines)


def make_fallback_row(agent_id: str, tier: str, expected_model: str) -> str:
    ts = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
    return f'| {ts} | {agent_id} | {tier} | {expected_model} | {expected_model} | revision loop exhausted | runtime escalation required |'


def main() -> int:
    parser = argparse.ArgumentParser(description='Run local multi-agent orchestration for delegate mode.')
    parser.add_argument('prompt', nargs='+', help='Task prompt including xN mode')
    args = parser.parse_args()
    prompt = ' '.join(args.prompt).strip()
    root = Path(__file__).resolve().parents[2]
    return orchestrate(root, prompt)


if __name__ == '__main__':
    raise SystemExit(main())
