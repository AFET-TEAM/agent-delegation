#!/usr/bin/env python3
from collections import Counter, defaultdict
from datetime import datetime, UTC
from pathlib import Path
import shutil

log = Path('.codex/logs/wrapper-usage.log')
out = Path('.codex/logs/wrapper-usage-report.md')
archive_dir = Path('.codex/logs/archive')
archive_dir.mkdir(parents=True, exist_ok=True)

if not log.exists():
    print('No wrapper usage log found.')
    raise SystemExit(0)

if out.exists():
    ts = datetime.now(UTC).strftime('%Y%m%dT%H%M%SZ')
    shutil.copy2(out, archive_dir / f'wrapper-usage-report-{ts}.md')

modes = Counter()
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
        modes[mode] += 1
        by_day[ts[:10]][mode] += 1

lines = []
lines.append('# Wrapper Usage Report')
lines.append('')
lines.append('## Mode Summary')
lines.append('')
lines.append('| Mode | Count |')
lines.append('|---|---:|')
for mode, count in sorted(modes.items()):
    lines.append(f'| {mode} | {count} |')
lines.append('')
lines.append('## Daily Breakdown')
lines.append('')
for day in sorted(by_day):
    lines.append(f'### {day}')
    lines.append('')
    lines.append('| Mode | Count |')
    lines.append('|---|---:|')
    for mode, count in sorted(by_day[day].items()):
        lines.append(f'| {mode} | {count} |')
    lines.append('')
lines.append('## Anomaly Hints')
lines.append('')
if not modes:
    lines.append('- no usage recorded')
else:
    top_mode, top_count = modes.most_common(1)[0]
    lines.append(f'- highest usage mode: {top_mode} ({top_count})')
    if modes.get('delegate', 0) > 0 and modes.get('review', 0) == 0:
        lines.append('- possible gap: delegate activity exists without review activity')
    if modes.get('graphify', 0) > modes.get('pcd', 0):
        lines.append('- check whether graphify-heavy usage is being paired with sufficient discovery discipline')
    if modes.get('context', 0) + modes.get('graphify', 0) > 0 and modes.get('pcd', 0) == 0:
        lines.append('- context/graphify usage appears without visible PCD usage')
    if modes.get('caveman', 0) > 0 and modes.get('review', 0) == 0:
        lines.append('- caveman usage exists without visible review activity; check whether summaries are replacing review loops')

out.write_text('\n'.join(lines), encoding='utf-8')
print(f'Wrote {out}')
