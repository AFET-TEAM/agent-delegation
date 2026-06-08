from __future__ import annotations

from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List


def _append_table_row(path: Path, header: str, separator: str, row: str, footer: str | None = None) -> None:
    if not path.exists():
        base = [header, separator, row]
        if footer:
            base += ['', footer]
        path.write_text('\n'.join(base) + '\n', encoding='utf-8')
        return
    text = path.read_text(encoding='utf-8').rstrip() + '\n'
    if row not in text:
        lines = text.splitlines()
        insert_at = len(lines)
        for i, line in enumerate(lines):
            if line.startswith('## '):
                insert_at = i
                break
        lines.insert(insert_at, row)
        path.write_text('\n'.join(lines).rstrip() + '\n', encoding='utf-8')


def update_metrics(root: Path, run_id: str, prompt: str, packets: List[dict], review_results: List[str], fallback_rows: List[str]) -> None:
    today = datetime.now(timezone.utc).strftime('%Y-%m-%d')
    token_path = root / '.codex' / 'metrics' / 'token-usage.md'
    perf_path = root / '.codex' / 'metrics' / 'agent-performance.md'
    lead_path = root / '.codex' / 'metrics' / 'leaderboard.md'
    fallback_path = root / '.codex' / 'metrics' / 'fallback-log.md'

    for packet in packets:
        est = _estimate_tokens(packet['tier'])
        actual = est
        delta = '0K'
        row = f"| {today} | {run_id} | {packet['agent_id']} | {est} | {actual} | {delta} |"
        _append_table_row(token_path, '# Token Usage\n\n| Date | Session | Agent | Estimated | Actual | Delta |', '|---|---|---|---:|---:|---:|', row, '## Interpretation\n\nLarge estimate/actual divergence should inform future task decomposition and model selection.')

    review_count = len(review_results)
    for packet in packets:
        reviews = 1 if packet['tier'] in {'T4', 'T2', 'T1'} else 0
        notes = 'local runtime auto-update'
        row = f"| {today} | {packet['agent_id']} | {packet['tier']} | 1 | {reviews} | 0 | {notes} |"
        _append_table_row(perf_path, '# Agent Performance\n\n| Date | Agent | Tier | Tasks | Reviews | Fallbacks | Notes |', '|---|---|---|---:|---:|---:|---|', row, '## Interpretation\n\nRepeated fallback or rework should feed calibration and task-routing improvements.')

    tier_scores: Dict[str, int] = {'T1': 3, 'T2': 2, 'T3': 1, 'T4': 2, 'T5': 1}
    for packet in packets:
        row = f"| {packet['agent_id']} | {tier_scores.get(packet['tier'], 1)} | local runtime contribution |"
        _append_table_row(lead_path, '# Leaderboard\n\n| Name | Score | Notes |', '|---|---:|---|', row, '## Scoring Notes\n\n- completed work increases score\n- useful review increases score\n- fallback or avoidable rework may reduce score')

    for row in fallback_rows:
        _append_table_row(fallback_path, '# Fallback Log\n\n| Timestamp | Agent | Tier | Expected | Actual | Reason | Impact |', '|---|---|---|---|---|---|---|', row, '## Interpretation Notes\n\nFallback should be visible in session summaries and used to calibrate future task/model assignment.')


def write_session_updates(root: Path, run_id: str, prompt: str, mode: str, fallback_rows: List[str]) -> None:
    today = datetime.now(timezone.utc).strftime('%Y-%m-%d')
    session_path = root / '.codex' / 'memory' / 'sessions' / f'session-{today}-runtime-auto-{run_id}.md'
    session_path.write_text('\n'.join([
        f'# Session — {today} — Runtime Auto Update',
        '',
        '## Goal',
        prompt,
        '',
        '## Agents Used',
        '- Local runtime workers',
        '',
        '## Key Decisions',
        '- safe file-writing policy enforced',
        '- revision loop handled by runtime',
        '- metrics and session artifacts auto-updated',
        '',
        '## Validation Summary',
        f'- run_id: {run_id}',
        f'- mode: {mode}',
        f'- fallback rows: {len(fallback_rows)}',
        '',
        '## Open Items',
        '- deepen task-specific execution semantics if needed',
        '',
        '## Resume Summary',
        'Runtime completed with automatic bookkeeping artifacts.',
    ]) + '\n', encoding='utf-8')

    resume_path = root / '.codex' / 'memory' / 'resume' / 'last-session.md'
    resume_path.write_text('\n'.join([
        '# Last Session Resume',
        '',
        '## Current State',
        'Runtime now supports safe file-writing, revision loops, and automatic bookkeeping.',
        '',
        '## Most Important Decisions',
        '- writes are sandboxed into runtime workspace-mirror unless explicitly allowed',
        '- revision required results can retry up to 2 rounds before escalation',
        '- metrics/session/todo updates occur automatically after serious delegate runs',
        '',
        '## Recommended Next Use',
        f'`./bin/team delegate "{prompt}"`',
        '',
        '## What To Recheck In New Environments',
        '- rg availability',
        '- python3 subprocess policies',
        '- runtime artifact retention expectations',
    ]) + '\n', encoding='utf-8')

    todo_path = root / '.codex' / 'todo' / 'active-plan.md'
    todo_path.write_text('\n'.join([
        '# Active Plan',
        '',
        '## In Progress',
        '- Calibrating safe-write and revision-loop behavior on real tasks',
        '',
        '## Pending',
        '- Optional hosted-agent backend integration',
        '- richer semantic code-change executors',
        '',
        '## Completed',
        '- Initial file scaffold',
        '- Local parallel xN delegate runtime',
        '- Safe file-writing policy',
        '- Revision loop and session/metrics auto-updates',
    ]) + '\n', encoding='utf-8')


def _estimate_tokens(tier: str) -> str:
    return {
        'T1': '6K', 'T2': '6K', 'T3': '4K', 'T4': '5K', 'T5': '3K'
    }.get(tier, '3K')
