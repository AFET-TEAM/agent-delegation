#!/usr/bin/env python3
from collections import Counter
from pathlib import Path

log = Path('.cursor/logs/wrapper-usage.log')
if not log.exists():
    print('No wrapper usage log found.')
    raise SystemExit(0)

modes = Counter()
prompts = []
for line in log.read_text(encoding='utf-8').splitlines():
    parts = line.split('|')
    mode = None
    prompt = None
    for p in parts[1:]:
        if p.startswith('mode='):
            mode = p.split('=',1)[1]
        elif p.startswith('prompt='):
            prompt = p.split('=',1)[1]
    if mode:
        modes[mode] += 1
    if prompt:
        prompts.append(prompt)

print('# Wrapper Usage Summary')
print()
print('## Mode Counts')
for mode, count in sorted(modes.items()):
    print(f'- {mode}: {count}')
print()
print(f'Total entries: {sum(modes.values())}')
