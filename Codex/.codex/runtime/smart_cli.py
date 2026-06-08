#!/usr/bin/env python3
from __future__ import annotations

import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
BIN = ROOT / 'bin'

KEYWORD_TO_MODE = {
    'pcd': 'pcd',
    'context': 'context',
    'graphify': 'graphify',
    'caveman': 'caveman',
    'review': 'review',
    'delegate': 'delegate',
}


def main() -> int:
    args = sys.argv[1:]
    if not args:
        print_usage()
        return 2

    first = args[0].lower()
    if first in {'apply', 'team-apply'}:
        return exec_cmd([str(BIN / 'team-apply'), *args[1:]])
    if first in {'rollback', 'team-rollback'}:
        return exec_cmd([str(BIN / 'team-rollback'), *args[1:]])
    if first in {'git', 'team-git'}:
        return exec_cmd([str(BIN / 'team-git'), *args[1:]])
    if first in {'report', 'team-report'}:
        return exec_cmd([str(BIN / 'team-report'), *args[1:]])

    mode, prompt = infer_mode_and_prompt(args)
    return exec_cmd([str(BIN / 'team'), mode, prompt])


def infer_mode_and_prompt(args: list[str]) -> tuple[str, str]:
    first = args[0].lower()
    if first in KEYWORD_TO_MODE:
        return KEYWORD_TO_MODE[first], ' '.join(args[1:]).strip()

    prompt = ' '.join(args).strip()
    if re.search(r'\bx(2|3|4|5|7|10)\b', prompt):
        return 'delegate', prompt
    return 'context', prompt


def exec_cmd(cmd: list[str]) -> int:
    proc = subprocess.run(cmd)
    return proc.returncode


def print_usage() -> None:
    print('''Usage examples:
  codex pcd <prompt>
  codex context <prompt>
  codex graphify <prompt>
  codex caveman <prompt>
  codex review <prompt>
  codex <task with xN>            # auto-routes to delegate
  codex apply <run_id> --approve-all
  codex rollback <run_id> --all
  codex git stage <run_id> README.md
''')


if __name__ == '__main__':
    raise SystemExit(main())
