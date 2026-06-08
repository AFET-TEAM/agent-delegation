---
pattern-id: LP-2026-05-21-01-fallback-must-be-visible
category: rules
hit-count: 2
last-triggered: 2026-05-21T12:00:00Z
sessions-since-hit: 0
created: 2026-05-21
source: codex-parity-pass
---

# Learned Pattern

## Error
Fallback event occurred but was not clearly surfaced in the user-facing summary.

## Fix
Always record fallback in `.codex/metrics/fallback-log.md` and mention it in the session summary.

## Rule
Fallback is an operationally important event. Never hide it.

## Context
Applies to all tier model substitutions.
