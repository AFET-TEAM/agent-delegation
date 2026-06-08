---
name: Analysis
description: >
  Deep analysis and research skill for codebase exploration, document reading, dependency mapping,
  risk assessment, hotspot discovery, and test scenario generation.
estimated-tokens: 3300
used-by: [T4, T5]
tiers:
  T4: mandatory
  T5: mandatory
---

# Analysis Skill

## Purpose

Transforms unstructured codebase or documentation input into evidence-based findings that upper tiers can act on.

## Output Discipline

Every useful report includes:
- scope
- summary
- findings
- recommendations
- risks
- sources
- confidence annotations

## Scoped Write Constraint

- T5 writes only to `.codex/analysis/raw/`
- T4 writes only to `.codex/analysis/consolidated/`
- application code is read-only for analysis tiers

## Analysis Types

### Codebase Mapping
- entrypoints
- module boundaries
- ownership hints
- hotspots
- risky shared utilities

### Dependency Analysis
- direct dependencies
- coupling and layering issues
- circularity risks
- framework/version implications

### Risk Assessment
- operational risk
- security risk
- maintainability risk
- migration/refactor risk

### Test Scenario Generation
- happy path
- edge path
- failure path
- regression path

## Evidence Rules

- cite path and line when possible
- separate verified findings from assumptions
- unsupported intuition must not be presented as fact

## Handoff Guidance

T5 output should make T4 consolidation easier by grouping findings and avoiding raw noise.
