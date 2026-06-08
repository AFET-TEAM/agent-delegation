#!/usr/bin/env python3
import re
import sys
from pathlib import Path

prompt = ' '.join(sys.argv[1:]).strip()
if not prompt:
    print('Usage: python3 .codex/scripts/delegation_plan.py "<task> xN"')
    raise SystemExit(2)

m = re.search(r'\bx(2|3|4|5|7|10)\b', prompt)
mode = f"x{m.group(1)}" if m else 'x1'

dists = {
    'x1': {'T1':0,'T2':0,'T3':0,'T4':0,'T5':0,'total':1},
    'x2': {'T1':1,'T2':0,'T3':0,'T4':0,'T5':1,'total':2},
    'x3': {'T1':1,'T2':1,'T3':0,'T4':0,'T5':1,'total':3},
    'x4': {'T1':1,'T2':1,'T3':1,'T4':0,'T5':1,'total':4},
    'x5': {'T1':1,'T2':1,'T3':1,'T4':1,'T5':1,'total':5},
    'x7': {'T1':1,'T2':2,'T3':1,'T4':1,'T5':2,'total':7},
    'x10': {'T1':2,'T2':2,'T3':2,'T4':2,'T5':2,'total':10},
}

waves = [
    'Wave 1: T5 research / discovery',
    'Wave 2: T4 consolidation',
    'Wave 3: T3/T2 implementation',
    'Wave 4: T2/T1 review',
    'Wave 5: orchestrator consolidation',
]

d = dists[mode]
print('# Delegation Plan')
print()
print(f'- prompt: {prompt}')
print(f'- mode: {mode}')
print(f'- total_agents: {d["total"]}')
print('- default_modes: /caveman /context-mode /graphify')
print()
print('## Tier Distribution')
for tier in ['T1','T2','T3','T4','T5']:
    print(f'- {tier}: {d[tier]}')
print()
print('## Execution Waves')
for w in waves:
    print(f'- {w}')

print()
print('## Runtime Capability')
print('- delegate mode can launch real local parallel worker processes via .codex/runtime/orchestrate.py')
print('- workers emit per-agent task reports and per-reviewer review artifacts under .codex/runtime/runs/<timestamp>/')
