# Dynamic Context Loading

## Purpose

Load only the skills and context actually needed for the current task.

## Ordered Discovery Strategy

1. identify task type
2. load only the minimum required skill set
3. inspect a few anchor files
4. expand only if uncertainty remains
5. summarize before escalating

## Task-Type Loading Rules

| Task Type | Required Skills | Skip | Phase-Loaded Later |
|---|---|---|---|
| Frontend UI | clean-code, frontend-development, implementation | backend-development, analysis | code-review, testing-standards, commit-standards, pr-standards |
| Backend API | clean-code, backend-development, implementation, api-integration | frontend-development, analysis | code-review, testing-standards, commit-standards, pr-standards |
| Architecture | clean-code, code-architecture, code-review | implementation-heavy feature skills | commit-standards, pr-standards |
| Analysis | analysis, context-efficiency, knowledge-graph | feature implementation skills | — |
| Review | code-review, clean-code | unrelated domain skills | commit-standards, pr-standards |
| Testing | testing-standards, clean-code, implementation | architecture unless needed | — |

## Budget Rules

Respect tier budgets from `context-budget.md`.
If needed context exceeds budget:
- stop loading more
- report what is missing
- request task split or tier elevation

## Stop Conditions

Stop reading more context when:
- the target file/module is clearly identified
- a confident plan exists
- additional reading no longer changes decisions
