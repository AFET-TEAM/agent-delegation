---
name: Code Architecture
description: >
  Architecture skill covering module boundaries, layering, dependency direction, tradeoff analysis,
  and ADR-grade decision framing.
estimated-tokens: 3000
used-by: [T1, T2]
tiers:
  T1: mandatory
  T2: awareness
---

# Code Architecture Skill

## Purpose

Used when the task involves structure, not just syntax. This skill helps decide where code should live, how modules interact, and when a solution is too invasive for the task.

## Core Questions

- what is the correct ownership boundary?
- which layer should own this logic?
- is the dependency direction still coherent?
- does this change create accidental coupling?

## When T1 Must Be Involved

- new pattern introduction
- cross-cutting refactor
- module boundary movement
- new shared abstraction
- contract evolution affecting multiple features

## Decision Criteria

- clarity of ownership
- blast radius
- future maintenance cost
- reversibility
- compatibility with current architecture

## Anti-Patterns

- shared folder as a dumping ground
- using global state to bypass design
- pushing domain decisions into UI or infra layers
- over-general abstractions added without multiple consumers
