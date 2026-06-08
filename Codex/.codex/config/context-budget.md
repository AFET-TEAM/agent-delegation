# Context Budget

## Per-Tier Budget

| Tier | Max Skills | Max Context Files | Notes |
|---|---:|---:|---|
| Orchestrator | flexible | flexible | coordination only; still prefer concise loading |
| T1 | 5 | 10 | architecture/review-heavy |
| T2 | 5 | 8 | implementation/review balance |
| T3 | 4 | 6 | bounded coding only |
| T4 | 3 | 5 | consolidation-focused |
| T5 | 3 | 6 | discovery-focused |

## Soft/Hard Limits

- soft warning: around 12K active task tokens
- hard split threshold: around 15K estimated task tokens
- large repo discovery should route through PCD + graph/topology heuristics

## Loading Rules

- search before read
- section before file
- summary before escalation
- phase-load commit/PR skills only when needed
