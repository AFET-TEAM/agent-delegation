#!/usr/bin/env python3
from collections import Counter, defaultdict
from pathlib import Path

log = Path('.codex/logs/wrapper-usage.log')
if not log.exists():
    print('No wrapper usage log found.')
    raise SystemExit(0)

by_day = defaultdict(list)
for line in log.read_text(encoding='utf-8').splitlines():
    parts = line.split('|')
    if not parts:
        continue
    day = parts[0][:10]
    mode = None
    for p in parts[1:]:
        if p.startswith('mode='):
            mode = p.split('=',1)[1]
    if mode:
        by_day[day].append(mode)

print('# Wrapper Flow Completeness Report')
print()
for day in sorted(by_day):
    seq = by_day[day]
    counts = Counter(seq)
    print(f'## {day}')
    print(f'- sequence: {", ".join(seq)}')
    if counts.get('pcd', 0) == 0 and (counts.get('context', 0) > 0 or counts.get('graphify', 0) > 0):
        print('- anomaly: context/graphify activity without visible PCD start')
    if counts.get('delegate', 0) > 0 and counts.get('review', 0) == 0:
        print('- anomaly: delegate activity without review follow-through')
    if counts.get('caveman', 0) > 0 and counts.get('review', 0) == 0:
        print('- note: caveman usage exists without review pairing')
    if counts.get('pcd', 0) > 0 and counts.get('delegate', 0) > 0 and counts.get('review', 0) > 0:
        print('- healthy: PCD -> delegate -> review chain visible')
    print()
