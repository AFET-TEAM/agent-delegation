---
name: Code Review
description: >
  Review skill for severity-based evaluation of correctness, security, architecture alignment,
  maintainability, and testing sufficiency.
estimated-tokens: 2600
used-by: [T1, T2, T3, T4]
tiers:
  T1: mandatory
  T2: mandatory
  T3: self-review
  T4: mandatory
---

# Code Review Skill

## Purpose

Standardizes what “review” means so approval is meaningful and not ceremonial.

## Severity Model

- Critical -> correctness/security/data-loss
- Major -> architectural drift, broken contract, missing validation
- Minor -> clarity, naming, consistency

## Review Workflow

1. confirm task intent
2. inspect changed surface
3. check hidden impacts
4. validate tests/evidence
5. assign severity and recommendation

## Strong Finding Example

- Severity: Major
- File: `src/auth/service.ts:42`
- Issue: refresh path does not invalidate previous token
- Why: replay/session consistency risk
- Recommendation: add invalidation or explicit rotation semantics

## Anti-Pattern

Approving because code “looks okay” without checking risks or validation is not a real review.
