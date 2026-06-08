from __future__ import annotations

from pathlib import Path
import json
import subprocess
from datetime import datetime, timezone
from typing import Iterable


def _run(root: Path, *args: str) -> dict:
    completed = subprocess.run(['git', *args], cwd=root, capture_output=True, text=True)
    return {'code': completed.returncode, 'stdout': completed.stdout, 'stderr': completed.stderr}


def _validate_target(t: str) -> str:
    if not isinstance(t, str) or not t:
        raise ValueError(f'Invalid target: {t!r}')
    if t.startswith('-'):
        raise ValueError(f"Target cannot start with '-' (flag injection): {t!r}")
    if '\x00' in t or '\n' in t:
        raise ValueError(f'Target contains illegal char: {t!r}')
    return t


def _validate_targets(targets: Iterable[str]) -> list[str]:
    return [_validate_target(target) for target in targets]


def _validate_message(message: str) -> str:
    if not isinstance(message, str):
        raise ValueError(f'Invalid commit message: {message!r}')
    if not message or len(message) > 2000:
        raise ValueError('Commit message must be between 1 and 2000 characters')
    return message


def stage_targets(root: Path, run_root: Path, targets: Iterable[str]) -> dict:
    validated_targets = _validate_targets(targets)
    result = _run(root, 'add', '--', *validated_targets)
    payload = {'timestamp': _ts(), 'targets': validated_targets, 'git_add': result}
    (run_root / 'stage-report.json').write_text(json.dumps(payload, indent=2), encoding='utf-8')
    (run_root / 'stage-report.md').write_text(render_stage_report(payload), encoding='utf-8')
    return payload


def commit_targets(root: Path, run_root: Path, message: str, targets: Iterable[str] | None = None) -> dict:
    validated_message = _validate_message(message)
    validated_targets = _validate_targets(targets or [])
    args = ['commit', '-m', validated_message]
    if validated_targets:
        args += ['--', *validated_targets]
    result = _run(root, *args)
    payload = {'timestamp': _ts(), 'message': validated_message, 'targets': validated_targets, 'git_commit': result}
    (run_root / 'commit-report.json').write_text(json.dumps(payload, indent=2), encoding='utf-8')
    (run_root / 'commit-report.md').write_text(render_commit_report(payload), encoding='utf-8')
    return payload


def create_pr(root: Path, run_root: Path, title: str, body: str, base: str | None = None, head: str | None = None, dry_run: bool = True) -> dict:
    args = ['gh', 'pr', 'create', '--title', title, '--body', body]
    if base:
        args += ['--base', base]
    if head:
        args += ['--head', head]
    if dry_run:
        args += ['--dry-run']
    completed = subprocess.run(args, cwd=root, capture_output=True, text=True)
    payload = {
        'timestamp': _ts(),
        'title': title,
        'body': body,
        'base': base,
        'head': head,
        'dry_run': dry_run,
        'gh_pr_create': {'code': completed.returncode, 'stdout': completed.stdout, 'stderr': completed.stderr},
    }
    (run_root / 'pr-report.json').write_text(json.dumps(payload, indent=2), encoding='utf-8')
    (run_root / 'pr-report.md').write_text(render_pr_report(payload), encoding='utf-8')
    return payload


def render_stage_report(payload: dict) -> str:
    return '\n'.join(['# Stage Report','',f"- timestamp: {payload['timestamp']}",f"- targets: {', '.join(payload['targets'])}",'', '```text', payload['git_add']['stdout'].rstrip() or payload['git_add']['stderr'].rstrip() or 'git add completed without output', '```']) + '\n'


def render_commit_report(payload: dict) -> str:
    return '\n'.join(['# Commit Report','',f"- timestamp: {payload['timestamp']}",f"- message: {payload['message']}",'', '```text', payload['git_commit']['stdout'].rstrip() or payload['git_commit']['stderr'].rstrip() or 'git commit completed without output', '```']) + '\n'


def render_pr_report(payload: dict) -> str:
    return '\n'.join(['# PR Report','',f"- timestamp: {payload['timestamp']}",f"- title: {payload['title']}",f"- dry_run: {'yes' if payload['dry_run'] else 'no'}",'', '```text', payload['gh_pr_create']['stdout'].rstrip() or payload['gh_pr_create']['stderr'].rstrip() or 'gh pr create completed without output', '```']) + '\n'


def _ts() -> str:
    return datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
