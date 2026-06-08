---
name: Implementation
description: >
  Delivery-oriented skill for turning requirements into bounded, testable, production-appropriate changes.
estimated-tokens: 2800
used-by: [T1, T2, T3]
tiers:
  T1: optional
  T2: mandatory
  T3: mandatory
---

# Implementation Skill

## Purpose

Helps coding tiers ship the smallest correct slice with clear validation and minimal blast radius.

## Workflow

1. restate scope
2. inspect local context
3. identify affected contracts
4. implement bounded change
5. validate
6. prepare reviewable report

## Verification Gates

- intended behavior complete?
- failure path considered?
- reviewable evidence available?
- hidden scope growth avoided?

## Escalation Trigger

If the work stops being bounded, stop and escalate rather than silently widening scope.
