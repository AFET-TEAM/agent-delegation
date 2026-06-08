---
name: Context Mode
description: >
  Dedicated context-discipline skill for large tasks. Encodes activation criteria, summary-first workflows,
  and artifact-safe handoff behavior.
estimated-tokens: 2600
used-by: [Orchestrator, T4, T5]
tiers:
  Orchestrator: optional
  T4: optional
  T5: optional
---

# Context Mode Skill

## Activation

Use when:
- repo is large
- task scope is broad
- docs/code volume is high
- user explicitly requests `/context-mode`

## Workflow

1. narrow with search
2. read relevant sections only
3. summarize findings
4. hand off compactly

## Output Discipline

- do not forward raw large outputs
- keep summaries decision-oriented
- note what was intentionally not read yet

## Example

A good context-mode pass identifies the next 2-3 files to inspect instead of reading 20 files in full.
