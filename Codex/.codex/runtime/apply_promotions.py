#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import List

if __package__ in {None, ''}:
    import sys as _sys
    _sys.path.append(str(Path(__file__).resolve().parents[1]))
    from runtime.file_locks import release_targets, reserve_targets
    from runtime.git_reporting import capture_git_report
    from runtime.promotion import PromotionCandidate
    from runtime.semantic_validation import validate_file
else:
    from .file_locks import release_targets, reserve_targets
    from .git_reporting import capture_git_report
    from .promotion import PromotionCandidate
    from .semantic_validation import validate_file


@dataclass
class ApplyResult:
    target: str
    mirror: str
    applied: bool
    reason: str
    validation: str
    rollback_snapshot: str | None


def load_candidates(run_root: Path) -> List[PromotionCandidate]:
    manifest_path = run_root / 'promotion-candidates.json'
    if not manifest_path.exists():
        return []
    raw = json.loads(manifest_path.read_text(encoding='utf-8'))
    return [PromotionCandidate(**item) for item in raw]


def select_candidates(candidates: List[PromotionCandidate], approve_all: bool, targets: List[str]) -> List[PromotionCandidate]:
    if approve_all:
        return candidates
    wanted = set(targets)
    return [c for c in candidates if c.relative_target in wanted]


def apply_candidates(root: Path, run_root: Path, selected: List[PromotionCandidate]) -> tuple[List[ApplyResult], dict]:
    results: List[ApplyResult] = []
    apply_root = run_root / 'apply-logs'
    rollback_root = run_root / 'rollback'
    validation_root = run_root / 'validation'
    apply_root.mkdir(parents=True, exist_ok=True)
    rollback_root.mkdir(parents=True, exist_ok=True)
    validation_root.mkdir(parents=True, exist_ok=True)

    acquired, _blocked = reserve_targets(root, run_root, 'apply-phase', [c.relative_target for c in selected])
    reserved_targets = set(acquired)
    rollback_manifest = []
    try:
        for candidate in selected:
            if candidate.relative_target not in reserved_targets:
                results.append(ApplyResult(candidate.relative_target, candidate.mirror_path, False, 'blocked by global lock', 'failed', None))
                continue
            mirror_path = run_root / candidate.mirror_path
            target_path = root / candidate.relative_target
            if not mirror_path.exists():
                results.append(ApplyResult(candidate.relative_target, candidate.mirror_path, False, 'mirror file missing', 'failed', None))
                continue

            snapshot_path = rollback_root / candidate.relative_target
            snapshot_path.parent.mkdir(parents=True, exist_ok=True)
            snapshot_payload = target_path.read_text(encoding='utf-8') if target_path.exists() else ''
            snapshot_path.write_text(snapshot_payload, encoding='utf-8')

            target_path.parent.mkdir(parents=True, exist_ok=True)
            new_payload = mirror_path.read_text(encoding='utf-8')
            target_path.write_text(new_payload, encoding='utf-8')

            validation_result = validate_apply(target_path, mirror_path)
            validation_file = validation_root / (candidate.relative_target.replace('/', '__') + '.json')
            validation_file.write_text(json.dumps(validation_result, indent=2), encoding='utf-8')

            if validation_result['status'] != 'passed':
                target_path.write_text(snapshot_payload, encoding='utf-8')
                results.append(ApplyResult(candidate.relative_target, candidate.mirror_path, False, 'rolled back after validation failure', validation_result['status'], str(snapshot_path.relative_to(run_root))))
                continue

            rollback_manifest.append({
                'target': candidate.relative_target,
                'snapshot': str(snapshot_path.relative_to(run_root)),
                'validation': str(validation_file.relative_to(run_root)),
            })
            results.append(ApplyResult(candidate.relative_target, candidate.mirror_path, True, 'applied from approved mirror', validation_result['status'], str(snapshot_path.relative_to(run_root))))
    finally:
        release_targets(root, run_root, 'apply-phase', reserved_targets)

    ts = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
    payload = {'timestamp': ts, 'results': [r.__dict__ for r in results]}
    (apply_root / f'apply-{ts.replace(":", "-")}.json').write_text(json.dumps(payload, indent=2), encoding='utf-8')
    (run_root / 'rollback-manifest.json').write_text(json.dumps(rollback_manifest, indent=2), encoding='utf-8')
    git_payload = capture_git_report(root, run_root)
    (run_root / 'apply-summary.md').write_text(render_summary(results, ts, git_payload), encoding='utf-8')
    return results, git_payload


def validate_apply(target_path: Path, mirror_path: Path) -> dict:
    target_text = target_path.read_text(encoding='utf-8') if target_path.exists() else ''
    mirror_text = mirror_path.read_text(encoding='utf-8') if mirror_path.exists() else ''
    exact_status = 'passed' if target_text == mirror_text else 'mismatch'
    semantic = validate_file(target_path)
    status = 'passed' if exact_status == 'passed' and semantic['semantic_status'] == 'passed' else 'failed'
    return {
        'target': str(target_path),
        'mirror': str(mirror_path),
        'status': status,
        'exact_status': exact_status,
        'target_size': len(target_text),
        'mirror_size': len(mirror_text),
        'semantic': semantic,
    }


def render_summary(results: List[ApplyResult], ts: str, git_payload: dict | None = None) -> str:
    lines = ['# Apply Summary', '', f'- timestamp: {ts}', '']
    if not results:
        lines.append('- no approved candidates applied')
    else:
        for r in results:
            lines.append(f'- target: {r.target} | mirror: {r.mirror} | applied: {"yes" if r.applied else "no"} | reason: {r.reason} | validation: {r.validation} | rollback_snapshot: {r.rollback_snapshot or "none"}')
    if git_payload is not None:
        lines += ['', '## Git Status Snapshot', '```text', git_payload['status']['stdout'].rstrip(), '```']
    return '\n'.join(lines) + '\n'


def main() -> int:
    parser = argparse.ArgumentParser(description='Apply approved promotion candidates from a runtime run.')
    parser.add_argument('run_id', help='Run id under .codex/runtime/runs/')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--approve-all', action='store_true', help='Apply all promotion candidates')
    group.add_argument('--approve', action='append', default=[], help='Approve a specific target path; repeatable')
    args = parser.parse_args()

    root = Path(__file__).resolve().parents[2]
    run_root = root / '.codex' / 'runtime' / 'runs' / args.run_id
    if not run_root.exists():
        raise SystemExit(f'Run not found: {run_root}')

    candidates = load_candidates(run_root)
    if not candidates:
        raise SystemExit('No promotion candidates found for run.')

    selected = select_candidates(candidates, args.approve_all, args.approve)
    if not selected:
        raise SystemExit('No candidates matched the requested approvals.')

    results, git_payload = apply_candidates(root, run_root, selected)
    print(render_summary(results, datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'), git_payload))
    return 0 if all(r.applied and r.validation == 'passed' for r in results) else 1


if __name__ == '__main__':
    raise SystemExit(main())
