#!/usr/bin/env python3
from collections import Counter, defaultdict
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
        by_day[ts[:10]][mode] += 1

print('# Wrapper Trend / Anomaly Report')
print()
for day in sorted(by_day):
    counts = by_day[day]
    print(f'## {day}')
    for mode, count in sorted(counts.items()):
        print(f'- {mode}: {count}')
    if counts.get('delegate', 0) > 0 and counts.get('review', 0) == 0:
        print('- anomaly: delegate used without review on this day')
    if counts.get('context', 0) + counts.get('graphify', 0) > 0 and counts.get('pcd', 0) == 0:
        print('- anomaly: context/graphify used without visible PCD usage on this day')
    if counts.get('graphify', 0) > 0 and counts.get('context', 0) == 0:
        print('- anomaly: graphify used without explicit context mode entrypoint')
    if counts.get('caveman', 0) > counts.get('review', 0) and counts.get('review', 0) == 0:
        print('- anomaly: caveman-heavy usage with no visible review activity')
    if counts.get('pcd', 0) > 0 and counts.get('delegate', 0) == 0 and counts.get('review', 0) == 0:
        print('- note: discovery-heavy day with no visible implementation/review follow-through')
    print()
