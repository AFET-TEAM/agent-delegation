---
name: Context Efficiency
description: >
  Deep token-efficiency skill covering dynamic context loading, query-first analysis, progressive disclosure,
  and context-budget enforcement.
estimated-tokens: 3400
used-by: [Orchestrator, T1, T2, T3, T4, T5]
tiers:
  Orchestrator: mandatory
  T1: optional
  T2: optional
  T3: optional
  T4: mandatory
  T5: mandatory
---

# Context Efficiency Skill

## Purpose

Reduce context waste without reducing solution quality. This is the operational token discipline layer for the whole system.

## Baseline Rules

- query first, read second
- read sections before full files
- load only task-relevant skills
- summarize before escalating upward
- split large tasks before they exceed budget

## Budgeting Workflow

1. identify task type
2. load minimum relevant skills
3. inspect anchor files only
4. expand if uncertainty remains
5. summarize and hand off compactly

## Warning Signs

- too many files read before target known
- docs loaded broadly without task relevance
- raw output copied upward instead of summarized
