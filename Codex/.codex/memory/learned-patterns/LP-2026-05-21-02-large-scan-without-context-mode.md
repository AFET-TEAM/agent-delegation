---
pattern-id: LP-2026-05-21-02-large-scan-without-context-mode
category: general
hit-count: 1
last-triggered: 2026-05-21T12:10:00Z
sessions-since-hit: 0
created: 2026-05-21
source: codex-parity-pass
---

# Learned Pattern

## Error
Large repository scan attempted without narrowing or context-mode discipline.

## Fix
Use query-first search and graph/topology methods before broad file reads.

## Rule
Large repos require deliberate context budgeting.

## Context
Applies to T4/T5 and Orchestrator discovery phases.
