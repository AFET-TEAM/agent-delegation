#!/usr/bin/env python3
from collections import Counter, defaultdict
from pathlib import Path

log = Path('.cursor/logs/wrapper-usage.log')
out = Path('.cursor/logs/wrapper-dashboard.md')
if not log.exists():
    print('No wrapper usage log found.')
    raise SystemExit(0)

counts = Counter()
by_day = defaultdict(Counter)
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
        counts[mode] += 1
        by_day[day][mode] += 1

lines = []
lines.append('# Wrapper Dashboard')
lines.append('')
lines.append('## Mode Totals')
lines.append('')
lines.append('| Mode | Count |')
lines.append('|---|---:|')
for mode, count in sorted(counts.items()):
    lines.append(f'| {mode} | {count} |')
lines.append('')
lines.append('## Daily Activity')
lines.append('')
for day in sorted(by_day):
    lines.append(f'### {day}')
    lines.append('')
    lines.append('| Mode | Count |')
    lines.append('|---|---:|')
    for mode, count in sorted(by_day[day].items()):
        lines.append(f'| {mode} | {count} |')
    lines.append('')
out.write_text('\n'.join(lines), encoding='utf-8')
print(f'Wrote {out}')
