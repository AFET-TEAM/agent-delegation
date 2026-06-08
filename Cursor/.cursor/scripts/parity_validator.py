#!/usr/bin/env python3
from __future__ import annotations

import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[3]
CURSOR = REPO / 'Cursor' / '.cursor'
CLAUDE = REPO / 'Claude' / '.claude'
CODEX = REPO / 'Codex' / '.codex'


def count_hooks(base: Path) -> int:
    hooks = base / 'hooks'
    return len(list(hooks.glob('*.sh'))) if hooks.exists() else 0


def count_skills(base: Path) -> int:
    skills = base / 'skills'
    return len(list(skills.glob('*/SKILL.md'))) if skills.exists() else 0


def count_md(base: Path, sub: str) -> int:
    folder = base / sub
    return len(list(folder.glob('*.md'))) if folder.exists() else 0


def main() -> int:
    print('# Three-Package Parity Report')
    print()
    issues = 0
    rows = [
        ('hooks', count_hooks(CURSOR), count_hooks(CLAUDE), count_hooks(CODEX), 18),
        ('skills', count_skills(CURSOR), count_skills(CLAUDE), count_skills(CODEX), 20),
        ('rules', count_md(CURSOR, 'rules'), count_md(CLAUDE, 'rules'), count_md(CODEX, 'rules'), 15),
        ('agents', count_md(CURSOR, 'agents'), count_md(CLAUDE, 'agents'), count_md(CODEX, 'agents'), 6),
        ('config', count_md(CURSOR, 'config'), count_md(CLAUDE, 'config'), count_md(CODEX, 'config'), 5),
    ]
    for name, cur, cla, cod, minimum in rows:
        status = 'OK' if cur >= minimum else 'LOW'
        if cur < minimum:
            issues += 1
        print(f'- {name}: Cursor={cur} Claude={cla} Codex={cod} [{status}]')
    extras = [
        ('runtime/orchestrate.py', (CURSOR / 'runtime' / 'orchestrate.py').exists()),
        ('runtime/spawn_packets.py', (CURSOR / 'runtime' / 'spawn_packets.py').exists()),
        ('hooks.json', (CURSOR / 'hooks.json').exists() or (REPO / '.cursor' / 'hooks.json').exists()),
    ]
    for label, ok in extras:
        print(f'- {label}: {"OK" if ok else "MISSING"}')
        if not ok:
            issues += 1
    print()
    print(f'issues: {issues}')
    return 0 if issues == 0 else 1


if __name__ == '__main__':
    raise SystemExit(main())
