from __future__ import annotations

from pathlib import Path
import json
import subprocess


def capture_git_report(root: Path, run_root: Path) -> dict:
    def run(*args: str) -> tuple[int, str, str]:
        completed = subprocess.run(['git', *args], cwd=root, capture_output=True, text=True)
        return completed.returncode, completed.stdout, completed.stderr

    status_code, status_out, status_err = run('status', '--short')
    diff_code, diff_out, diff_err = run('diff', '--', 'README.md', 'AGENTS.md', '.codex')
    staged_code, staged_out, staged_err = run('diff', '--cached')
    payload = {
        'status': {'code': status_code, 'stdout': status_out, 'stderr': status_err},
        'diff': {'code': diff_code, 'stdout': diff_out[:20000], 'stderr': diff_err},
        'staged': {'code': staged_code, 'stdout': staged_out[:20000], 'stderr': staged_err},
    }
    (run_root / 'git-report.json').write_text(json.dumps(payload, indent=2), encoding='utf-8')
    (run_root / 'git-report.md').write_text(render_git_report(payload), encoding='utf-8')
    return payload


def render_git_report(payload: dict) -> str:
    lines = ['# Git Report', '']
    lines += ['## Status', '```text', payload['status']['stdout'].rstrip(), '```', '']
    lines += ['## Diff', '```diff', payload['diff']['stdout'].rstrip(), '```', '']
    lines += ['## Staged Diff', '```diff', payload['staged']['stdout'].rstrip(), '```', '']
    return '\n'.join(lines) + '\n'
