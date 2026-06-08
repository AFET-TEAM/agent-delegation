# Review Chain Reference

## Purpose

Define how work moves upward through the quality chain and how review artifacts should be recorded.

## Canonical Flow

- T5 output reviewed by T4
- T3 output reviewed by T2
- T2 output reviewed by T1
- Orchestrator consolidates and reports

## Review Stage Definitions

### T4 Review
- evidence quality
- confidence correctness
- consolidation usefulness

### T2 Review
- implementation correctness
- missing validation
- hidden assumptions
- rule compliance

### T1 Review
- architecture alignment
- contract impact
- maintainability
- security/failure behavior

## Outcome Logic

- Approved -> move upward
- Revision Required -> same tier revises
- Rejected -> upper tier may take over

## Required Review Artifact

Use `.codex/contracts/review-report.md` for structured review output.

Minimum fields:
- item under review
- reviewer tier
- decision
- severity-grouped findings
- required fixes
- residual risks
- validation notes

## Revision Loop

- maximum 2 revision rounds by default
- if round 2 still fails, escalate to the upper tier or orchestrator
- review summaries must preserve unresolved concerns instead of collapsing them into “looks good” language

## Example Review Progression

1. T3 submits implementation
2. T2 records review report
3. if revision required, T3 updates and resubmits
4. T2 approves or escalates
5. T1 reviews T2-owned outputs or final integrated package
