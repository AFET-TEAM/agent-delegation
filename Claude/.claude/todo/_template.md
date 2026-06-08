---
plan-id: PLAN-{YYYYMMDD-HHMMSS}
created: {ISO-8601}
status: {planning|active|paused|completed}
total-tasks: {N}
completed-tasks: {N}
estimated-remaining-tokens: {N}K
---

# {Plan Title}

## Objective
{What this plan achieves}

## Task List

- [ ] TASK-001 (T{tier}, ~{N}K) — {description}
- [ ] TASK-002 (T{tier}, ~{N}K) — {description}

## Dependency Graph

```
TASK-001 → [no dependencies]
TASK-002 → depends on: TASK-001
```

## Execution Waves

| Wave | Tasks | Mode | Gate |
|------|-------|------|------|
| 1 | TASK-001 | Parallel | — |
| 2 | TASK-002 | Sequential | Wave 1 |

## Agent Assignments

| Task | Agent Tier | Model | Display Name | Skills |
|------|-----------|-------|-------------|--------|

## Resume Point

Last completed: {TASK-ID}
Next up: {TASK-ID}
Context: {brief description of where we left off}
