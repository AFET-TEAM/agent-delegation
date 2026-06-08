---
name: Knowledge Graph
description: >
  Graph-assisted codebase navigation skill for large repositories, hotspot detection, coupling analysis,
  and topology-first discovery.
estimated-tokens: 3300
used-by: [Orchestrator, T4, T5]
tiers:
  Orchestrator: optional
  T4: mandatory on large repos
  T5: mandatory on large repos
---

# Knowledge Graph Skill

## Purpose

Replace brute-force codebase reading with topology-aware exploration when repo size or complexity makes naive reading wasteful.

## When To Use

- many modules/files involved
- boundaries unclear
- hotspot or god-node analysis needed
- coupling or impact radius unknown

## Expected Outputs

- module topology
- hotspot candidates
- likely architectural seams
- high-risk dependency paths

## Workflow

1. check graph freshness
2. query for hotspots and boundaries
3. use graph results to narrow file reads
4. consolidate findings into high-signal summary

## Security Rule

Prefer local-only graph building for private codebases.
