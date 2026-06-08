---
name: Backend Development
description: >
  Backend implementation skill covering service boundaries, contracts, validation, failure handling,
  and side-effect control.
estimated-tokens: 3100
used-by: [T1, T2, T3]
tiers:
  T1: optional
  T2: mandatory when backend
  T3: mandatory when backend
---

# Backend Development Skill

## Purpose

Keeps server-side code layered, explicit, and safe to evolve.

## Core Rules

- controllers/handlers remain thin
- services/use-cases own business logic
- repositories/adapters hide persistence details
- contracts explicit, not inferred from internals

## Failure Handling

- define expected failure modes
- avoid generic catch-and-hide behavior
- preserve meaningful error semantics upward

## Side-Effect Discipline

- make external calls obvious
- avoid hidden writes or state changes
- keep transactional assumptions explicit

## Example Review Prompt

```text
Check whether this service owns business logic cleanly and whether persistence details leak into the API boundary.
```
