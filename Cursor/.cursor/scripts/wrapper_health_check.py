#!/usr/bin/env python3
from collections import Counter
from pathlib import Path

log = Path('.cursor/logs/wrapper-usage.log')
if not log.exists():
    print('No wrapper usage log found.')
    raise SystemExit(0)

counts = Counter()
for line in log.read_text(encoding='utf-8').splitlines():
    for part in line.split('|')[1:]:
        if part.startswith('mode='):
            counts[part.split('=',1)[1]] += 1

delegate = counts.get('delegate', 0)
review = counts.get('review', 0)
ratio = review / delegate if delegate else 0

print('# Wrapper Health Check')
print()
print(f'- delegate_count: {delegate}')
print(f'- review_count: {review}')
print(f'- review_to_delegate_ratio: {ratio:.2f}')
if delegate > 0 and ratio < 0.5:
    print('- warning: review coverage is low relative to delegate activity')
else:
    print('- healthy: review coverage is acceptable relative to delegate activity')
