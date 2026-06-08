from __future__ import annotations

from pathlib import Path
from typing import Callable, Iterable, List, Tuple, TypeVar
import fcntl
import json
import os
import tempfile


T = TypeVar('T')


def repo_lock_path(root: Path) -> Path:
    """Return the repo-wide lock registry used by both write staging and live apply.

    The file lives under .codex/runtime so concurrent runs coordinate through a single
    shared registry instead of creating one lock file per run.
    """
    return root / '.codex' / 'runtime' / 'global-locks.json'


def _atomic_write_json(path: Path, data: dict) -> None:
    directory = path.parent
    directory.mkdir(parents=True, exist_ok=True)
    fd, tmp = tempfile.mkstemp(prefix='.lock_', dir=directory)
    try:
        with os.fdopen(fd, 'w', encoding='utf-8') as handle:
            json.dump(data, handle, indent=2, sort_keys=True)
        os.replace(tmp, path)
    except Exception:
        try:
            os.unlink(tmp)
        except OSError:
            pass
        raise


def _with_lock(path: Path, fn: Callable[[], T]) -> T:
    lock_path = path.with_name(path.name + '.lock')
    lock_path.parent.mkdir(parents=True, exist_ok=True)
    with lock_path.open('w', encoding='utf-8') as lock_file:
        fcntl.flock(lock_file.fileno(), fcntl.LOCK_EX)
        try:
            return fn()
        finally:
            fcntl.flock(lock_file.fileno(), fcntl.LOCK_UN)


def run_lock_path(run_root: Path) -> Path:
    """Keep writing a run-local snapshot for diagnostics/backward compatibility."""
    return run_root / 'locks.json'


def load_locks(root: Path) -> dict:
    path = repo_lock_path(root)
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding='utf-8'))


def save_locks(root: Path, locks: dict) -> None:
    _atomic_write_json(repo_lock_path(root), locks)


def save_run_snapshot(run_root: Path, locks: dict) -> None:
    """Mirror the shared state into the run folder so old tooling still has context."""
    _atomic_write_json(run_lock_path(run_root), locks)


def reserve_targets(root: Path, run_root: Path, owner: str, targets: Iterable[str]) -> Tuple[List[str], List[str]]:
    def op() -> Tuple[List[str], List[str]]:
        locks = load_locks(root)
        acquired: List[str] = []
        blocked: List[str] = []
        for target in targets:
            holder = locks.get(target)
            if holder is None or holder == owner:
                locks[target] = owner
                acquired.append(target)
            else:
                blocked.append(target)
        save_locks(root, locks)
        save_run_snapshot(run_root, locks)
        return acquired, blocked

    return _with_lock(repo_lock_path(root), op)


def release_targets(root: Path, run_root: Path, owner: str, targets: Iterable[str]) -> list[str]:
    def op() -> list[str]:
        locks = load_locks(root)
        released: list[str] = []
        for target in targets:
            if locks.get(target) == owner:
                locks.pop(target, None)
                released.append(target)
        save_locks(root, locks)
        save_run_snapshot(run_root, locks)
        return released

    return _with_lock(repo_lock_path(root), op)


def release_all_for_owner(root: Path, run_root: Path, owner: str) -> list[str]:
    def op() -> list[str]:
        locks = load_locks(root)
        released = [target for target, holder in list(locks.items()) if holder == owner]
        for target in released:
            locks.pop(target, None)
        save_locks(root, locks)
        save_run_snapshot(run_root, locks)
        return released

    return _with_lock(repo_lock_path(root), op)
