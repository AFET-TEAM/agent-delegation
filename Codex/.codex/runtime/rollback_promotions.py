#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from datetime import datetime, timezone
from pathlib import Path


def load_manifest(run_root: Path) -> list:
    manifest = run_root / 'rollback-manifest.json'
    if not manifest.exists():
        return []
    return json.loads(manifest.read_text(encoding='utf-8'))


def rollback_targets(root: Path, run_root: Path, targets: set[str] | None) -> list[dict]:
    manifest = load_manifest(run_root)
    results = []
    for item in manifest:
        target = item['target']
        if targets is not None and target not in targets:
            continue
        snapshot = run_root / item['snapshot']
        target_path = root / target
        if not snapshot.exists():
            results.append({'target': target, 'rolled_back': False, 'reason': 'snapshot missing'})
            continue
        target_path.parent.mkdir(parents=True, exist_ok=True)
        target_path.write_text(snapshot.read_text(encoding='utf-8'), encoding='utf-8')
        results.append({'target': target, 'rolled_back': True, 'reason': 'restored from rollback snapshot'})
    ts = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
    (run_root / 'rollback-summary.md').write_text(render_summary(ts, results), encoding='utf-8')
    (run_root / 'rollback-log.json').write_text(json.dumps({'timestamp': ts, 'results': results}, indent=2), encoding='utf-8')
    return results


def render_summary(ts: str, results: list[dict]) -> str:
    lines = ['# Rollback Summary', '', f'- timestamp: {ts}', '']
    if not results:
        lines.append('- no rollback targets selected')
    else:
        for item in results:
            lines.append(f"- target: {item['target']} | rolled_back: {'yes' if item['rolled_back'] else 'no'} | reason: {item['reason']}")
    return '\n'.join(lines) + '\n'


def main() -> int:
    parser = argparse.ArgumentParser(description='Rollback applied promotion targets from rollback snapshots.')
    parser.add_argument('run_id')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--all', action='store_true')
    group.add_argument('--target', action='append', default=[])
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[2]
    run_root = root / '.codex' / 'runtime' / 'runs' / args.run_id
    if not run_root.exists():
        raise SystemExit(f'Run not found: {run_root}')
    targets = None if args.all else set(args.target)
    results = rollback_targets(root, run_root, targets)
    print(render_summary(datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'), results))
    return 0 if all(item['rolled_back'] for item in results) else 1


if __name__ == '__main__':
    raise SystemExit(main())
