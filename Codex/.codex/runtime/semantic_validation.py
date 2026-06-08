from __future__ import annotations

from pathlib import Path
import ast
import json
import os
import shutil
import subprocess
import sys
import tempfile
from typing import Iterable

_MAX_PYTHON_IMPORT_BYTES = 200_000
_MARKDOWNLINT_CONFIG_FILES = (
    '.markdownlint-cli2.jsonc',
    '.markdownlint-cli2.json',
    '.markdownlint.jsonc',
    '.markdownlint.json',
    '.markdownlint.yaml',
    '.markdownlint.yml',
)


def _append_check(base: dict, name: str, status: str, detail: str | None = None, *, fail: bool = False) -> None:
    entry = f'{name}:{status}'
    if detail:
        compact = ' '.join(str(detail).split())
        if compact:
            entry = f'{entry}:{compact}'
    base['checks'].append(entry)
    if fail:
        base['semantic_status'] = 'failed'


def _run_command(command: list[str], cwd: Path | None = None) -> subprocess.CompletedProcess[str] | None:
    try:
        return subprocess.run(command, capture_output=True, text=True, cwd=str(cwd) if cwd else None)
    except OSError as exc:
        return subprocess.CompletedProcess(command, 127, '', str(exc))


def _find_repo_root(path: Path) -> Path:
    for candidate in (path if path.is_dir() else path.parent, *(path if path.is_dir() else path.parent).parents):
        if (candidate / '.git').exists() or (candidate / '.codex').exists():
            return candidate
    return path.parent if path.is_file() else path


def _detect_markdownlint(repo_root: Path) -> list[str] | None:
    local_bin = repo_root / 'node_modules' / '.bin' / 'markdownlint-cli2'
    if local_bin.exists():
        return [str(local_bin)]
    for name in ('markdownlint-cli2',):
        resolved = shutil.which(name)
        if resolved:
            return [resolved]
    npx = shutil.which('npx')
    if npx:
        return [npx, '--yes', 'markdownlint-cli2']
    return None


def _markdownlint_config_args(repo_root: Path) -> list[str]:
    for filename in _MARKDOWNLINT_CONFIG_FILES:
        candidate = repo_root / filename
        if candidate.exists():
            return ['--config', str(candidate)]
    return []


def _validate_json(base: dict, text: str) -> None:
    try:
        payload = json.loads(text)
        _append_check(base, 'json-parse', 'passed')
        _append_check(base, 'json-type', type(payload).__name__)
    except Exception as exc:
        _append_check(base, 'json-parse', 'failed', exc, fail=True)


def _python_import_safe(path: Path, text: str) -> tuple[bool, str]:
    if len(text.encode('utf-8')) > _MAX_PYTHON_IMPORT_BYTES:
        return False, 'file-too-large'
    try:
        tree = ast.parse(text, filename=str(path))
    except SyntaxError as exc:
        return False, f'ast-parse-failed:{exc}'

    allowed_nodes: tuple[type[ast.AST], ...] = (
        ast.Module,
        ast.Import,
        ast.ImportFrom,
        ast.Assign,
        ast.AnnAssign,
        ast.Expr,
        ast.Constant,
        ast.Name,
        ast.Load,
        ast.Store,
        ast.Tuple,
        ast.List,
        ast.Set,
        ast.Dict,
        ast.keyword,
        ast.alias,
        ast.BinOp,
        ast.UnaryOp,
        ast.BoolOp,
        ast.Compare,
        ast.IfExp,
        ast.JoinedStr,
        ast.FormattedValue,
        ast.Subscript,
        ast.Slice,
        ast.Attribute,
        ast.Call,
        ast.ListComp,
        ast.SetComp,
        ast.DictComp,
        ast.GeneratorExp,
        ast.comprehension,
        ast.NamedExpr,
        ast.Lambda,
        ast.arguments,
        ast.arg,
    )
    blocked_top_level = (ast.FunctionDef, ast.AsyncFunctionDef, ast.ClassDef, ast.For, ast.AsyncFor, ast.While, ast.With, ast.AsyncWith, ast.Try, ast.Match)
    for node in tree.body:
        if isinstance(node, blocked_top_level):
            return False, f'top-level-{node.__class__.__name__.lower()}'
        if isinstance(node, ast.Expr) and isinstance(node.value, ast.Call):
            return False, 'top-level-call'
    for node in ast.walk(tree):
        if isinstance(node, (ast.Global, ast.Nonlocal, ast.Delete, ast.Raise, ast.Assert, ast.Return, ast.Yield, ast.YieldFrom, ast.Await)):
            return False, f'unsupported-{node.__class__.__name__.lower()}'
        if not isinstance(node, allowed_nodes + blocked_top_level):
            return False, f'unsupported-{node.__class__.__name__.lower()}'
    return True, 'safe'


def _validate_python(base: dict, path: Path, text: str) -> None:
    completed = _run_command([sys.executable, '-m', 'py_compile', str(path.resolve())], cwd=path.parent)
    if completed and completed.returncode == 0:
        _append_check(base, 'python-compile', 'passed')
    else:
        detail = (completed.stderr or completed.stdout).strip() if completed else 'runner-unavailable'
        _append_check(base, 'python-compile', 'failed', detail, fail=True)
        return

    safe_to_import, reason = _python_import_safe(path, text)
    if not safe_to_import:
        _append_check(base, 'python-import-smoke', 'skipped', reason)
        return

    with tempfile.TemporaryDirectory(prefix='codex-semantic-validation-') as tmpdir:
        runner = Path(tmpdir) / 'import_smoke.py'
        runner.write_text(
            'import importlib.util\n'
            'import pathlib\n'
            'import sys\n'
            'target = pathlib.Path(sys.argv[1]).resolve()\n'
            "spec = importlib.util.spec_from_file_location('codex_validation_target', target)\n"
            'if spec is None or spec.loader is None:\n'
            "    raise RuntimeError(f'Could not create import spec for {target}')\n"
            'module = importlib.util.module_from_spec(spec)\n'
            'spec.loader.exec_module(module)\n',
            encoding='utf-8',
        )
        env = os.environ.copy()
        env['PYTHONDONTWRITEBYTECODE'] = '1'
        repo_root = _find_repo_root(path)
        existing = env.get('PYTHONPATH', '')
        env['PYTHONPATH'] = str(repo_root) if not existing else f"{repo_root}{os.pathsep}{existing}"
        try:
            smoke = subprocess.run([sys.executable, str(runner), str(path)], capture_output=True, text=True, cwd=str(path.parent), env=env)
        except OSError as exc:
            _append_check(base, 'python-import-smoke', 'skipped', exc)
            return
    if smoke.returncode == 0:
        _append_check(base, 'python-import-smoke', 'passed')
    else:
        _append_check(base, 'python-import-smoke', 'failed', (smoke.stderr or smoke.stdout).strip(), fail=True)


def _validate_shell(base: dict, path: Path) -> None:
    completed = _run_command(['bash', '-n', str(path.resolve())], cwd=path.parent)
    if completed and completed.returncode == 0:
        _append_check(base, 'shell-syntax', 'passed')
    else:
        detail = (completed.stderr or completed.stdout).strip() if completed else 'runner-unavailable'
        _append_check(base, 'shell-syntax', 'failed', detail, fail=True)

    shellcheck = shutil.which('shellcheck')
    if not shellcheck:
        _append_check(base, 'shellcheck', 'skipped', 'unavailable')
        return
    sc = _run_command([shellcheck, '--format=gcc', str(path.resolve())], cwd=path.parent)
    if sc and sc.returncode == 0:
        _append_check(base, 'shellcheck', 'passed')
    else:
        detail = (sc.stdout or sc.stderr).strip() if sc else 'runner-unavailable'
        _append_check(base, 'shellcheck', 'failed', detail, fail=True)


def _validate_markdown(base: dict, path: Path, text: str) -> None:
    if text.strip():
        _append_check(base, 'markdown-nonempty', 'passed')
    else:
        _append_check(base, 'markdown-nonempty', 'failed', fail=True)

    if text.startswith('---\n') or text.startswith('#'):
        _append_check(base, 'markdown-structure', 'passed')
    else:
        _append_check(base, 'markdown-structure', 'advisory')

    repo_root = _find_repo_root(path)
    markdownlint_cmd = _detect_markdownlint(repo_root)
    if not markdownlint_cmd:
        _append_check(base, 'markdownlint-cli2', 'skipped', 'unavailable')
        return
    command = [*markdownlint_cmd, *_markdownlint_config_args(repo_root), str(path.resolve())]
    lint = _run_command(command, cwd=repo_root)
    if lint and lint.returncode == 0:
        _append_check(base, 'markdownlint-cli2', 'passed')
    else:
        detail = (lint.stdout or lint.stderr).strip() if lint else 'runner-unavailable'
        _append_check(base, 'markdownlint-cli2', 'failed', detail, fail=True)


def validate_file(path: Path) -> dict:
    suffix = path.suffix.lower()
    exists = path.exists()
    text = path.read_text(encoding='utf-8') if exists else ''
    base = {
        'path': str(path),
        'suffix': suffix,
        'exists': exists,
        'size': len(text),
        'semantic_status': 'passed',
        'checks': [],
    }
    if not exists:
        _append_check(base, 'file-exists', 'failed', 'missing', fail=True)
        return base

    if suffix == '.json':
        _validate_json(base, text)
    elif suffix == '.py':
        _validate_python(base, path, text)
    elif suffix == '.sh':
        _validate_shell(base, path)
    elif suffix == '.md':
        _validate_markdown(base, path, text)
    else:
        _append_check(base, 'generic-existence', 'passed')
    return base
