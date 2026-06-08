---
name: Clean Code
description: >
  Comprehensive code hygiene skill. Defines naming, decomposition, readability, SOLID alignment,
  prohibition rules, and review heuristics for maintainable production code.
estimated-tokens: 4200
used-by: [T1, T2, T3, T4, T5]
tiers:
  T1: mandatory
  T2: mandatory
  T3: mandatory
  T4: awareness
  T5: awareness
---

# Clean Code Skill

## Purpose

This skill provides the universal coding hygiene layer for all implementation and review work. It complements `clean-code.md` by explaining how to apply the rules in day-to-day tasks.

## Core Philosophy

- readable beats clever
- local reasoning beats hidden indirection
- simple structure beats premature abstraction
- honest naming beats shorthand familiarity
- structural decisions should respect SOLID where the task actually needs it

## SOLID In Practice

### SRP
A class or module should not accumulate unrelated responsibilities just because it is already nearby.

### OCP
Stable flows should not require repetitive invasive edits for each new variation.

### LSP
If one implementation replaces another, callers should not need hidden behavioral exceptions.

### ISP
Small consumer-specific surfaces beat one giant interface nobody truly needs.

### DIP
High-level behavior should not be tightly coupled to unstable details when a clean seam is warranted.

## Mandatory Practices

### Function Design
- one function, one job
- use early returns to flatten logic
- keep branching readable
- extract only when the extraction clarifies intent

### File Design
- each file should communicate a single main concept
- co-locate related types/tests/helpers when it improves discoverability
- split giant files before they become review-hostile

### Naming
- names should tell truth about behavior and side effects
- prefer verbs for actions, nouns for data structures, adjectives/predicates for booleans
- avoid overloaded generic words like `process`, `manager`, `handler` unless scoped clearly

## Absolute Prohibitions

- no debug artifacts
- no `any`
- no hidden TODO debt
- no misleading comments that explain broken or unclear code instead of fixing it

## Review Heuristics

Ask:
- can a new team member understand this in one pass?
- does this function hide more than one reason to change?
- does this file blend unrelated concerns?
- are names carrying the mental load or forcing file reading?
- is SOLID being used to clarify design or being abused to over-engineer?

## Good Examples

- explicit options object instead of 6 positional params
- small validation helper instead of nested condition tree
- value-object style names for concept-heavy primitives
- extracting a narrow port/seam when infrastructure coupling is hurting clarity

## Failure Patterns

- abstraction created after first duplication
- utility dumping ground
- generic names causing mistaken reuse
- long methods with many boolean branches
- “SOLID theater”: adding interfaces and layers with no actual design pressure
