---
name: Caveman
description: >
  Optional response compression skill that shortens prose while preserving code, commands, paths,
  identifiers, and safety-critical wording exactly.
estimated-tokens: 2200
used-by: [Orchestrator]
tiers:
  Orchestrator: optional
---

# Caveman Skill

## Purpose

Reduce output verbosity without reducing correctness.

## Activation

- `/caveman`
- `/caveman lite`
- `/caveman full`
- `/caveman ultra`
- keyword activation only when clearly intended as mode request

## Compression Modes

- lite -> concise professional
- full -> short fragments allowed
- ultra -> highly compressed telegraph style

## Strict Output Contract

When `/caveman full` is active:
- default to very short answers
- do not add explanatory padding unless safety-critical
- prefer bullets over paragraphs
- prefer direct answer first
- avoid repeating the question
- avoid “nice to know” context unless requested

When `/caveman ultra` is active:
- use fragment-heavy telegraph style
- minimize connective phrasing
- keep only decision-useful content

## Preservation Rules

Never compress code, paths, commands, errors, warnings, or irreversible action language.

## Good Usage

Use caveman for summaries and status, not for risky consent language.
