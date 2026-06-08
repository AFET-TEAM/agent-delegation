#!/usr/bin/env python3
from collections import Counter, defaultdict
from datetime import datetime
from pathlib import Path

log = Path('.codex/logs/wrapper-usage.log')
if not log.exists():
    print('No wrapper usage log found.')
    raise SystemExit(0)

by_day = defaultdict(Counter)
for line in log.read_text(encoding='utf-8').splitlines():
    parts = line.split('|')
    if not parts:
        continue
    ts = parts[0]
    mode = None
    for p in parts[1:]:
        if p.startswith('mode='):
            mode = p.split('=',1)[1]
    if mode:
        day = ts[:10]
        by_day[day][mode] += 1

print('# Weekly Wrapper Usage Analysis')
print()
for day in sorted(by_day):
    print(f'## {day}')
    for mode, count in sorted(by_day[day].items()):
        print(f'- {mode}: {count}')
    print()
