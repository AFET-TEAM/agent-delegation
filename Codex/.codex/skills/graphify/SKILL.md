---
name: Graphify
description: >
  Dedicated graph/topology exploration skill for large repositories. Focuses on hotspot detection,
  coupling analysis, and topology-first narrowing.
estimated-tokens: 2600
used-by: [Orchestrator, T4, T5]
tiers:
  Orchestrator: optional
  T4: optional
  T5: optional
---

# Graphify Skill

## Purpose

Use graph/topology artifacts to replace brute-force exploration when repo size or dependency complexity is high.

## Workflow

1. check graph freshness
2. query hotspots/boundaries
3. read narrowed target files
4. report EXTRACTED / INFERRED / AMBIGUOUS findings

## Example Use

- identify god nodes before refactor
- narrow auth-related boundaries before deep reading

## Caution

Graph outputs guide reading; they do not replace direct confirmation in critical areas.
