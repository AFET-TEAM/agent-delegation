#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
from pathlib import Path

if __package__ in {None, ''}:
    import sys as _sys
    _sys.path.append(str(Path(__file__).resolve().parents[1]))
    from runtime.worker_lib import build_outcome
else:
    from .worker_lib import build_outcome


def render_report(packet: dict, run_root: Path, revision_round: int) -> str:
    repo_root = run_root.parents[3]
    outcome = build_outcome(repo_root, run_root, packet, revision_round=revision_round)
    files = ', '.join(outcome.files) or 'none'
    return '\n'.join([
        f'## {packet["display_name"]} — Task Report',
        '',
        f'**Task**: {packet["task_summary"]}',
        f'**Status**: {outcome.status}',
        f'**Files**: {files}',
        f'**Model**: {packet["expected_model"]} -> {packet["expected_model"]}',
        f'**Confidence**: {outcome.confidence}',
        '',
        '### Details',
        *[f'- {d}' for d in outcome.details],
        '',
        '### Validation',
        *[f'- {d}' for d in outcome.validation],
        '- Local worker runtime executed successfully.',
        '',
        '### Notes',
        *[f'- {d}' for d in outcome.notes],
        f'- Agent ID: {packet["agent_id"]}',
        f'- Review target: {packet["review_target"] or "orchestrator"}',
    ])


def main() -> int:
    if len(sys.argv) != 5:
        print('Usage: agent_worker.py <packet.json> <output.md> <run_root> <revision_round>', file=sys.stderr)
        return 2
    packet_path = Path(sys.argv[1])
    output_path = Path(sys.argv[2])
    run_root = Path(sys.argv[3])
    revision_round = int(sys.argv[4])
    packet = json.loads(packet_path.read_text(encoding='utf-8'))
    output_path.write_text(render_report(packet, run_root, revision_round) + '\n', encoding='utf-8')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
