# Delegation Rules Reference

## Purpose

Provide a canonical operational interpretation of `xN` mode and tier routing so all agents behave consistently.

## Canonical Source

Primary source of truth:
- `.cursor/config/delegation-rules.md`
- `.cursor/config/task-assignment-matrix.md`

## Fixed xN Modes

| Mode | Typical Use | Notes |
|---|---|---|
| x2 | quick discovery + senior gate | low cost, short chain |
| x3 | small feature | minimal implementation split |
| x4 | medium feature | adds T3 implementation lane |
| x5 | standard production work | full basic chain |
| x7 | parallel feature/test/analysis | strong default for serious work |
| x10 | large migration/audit/refactor | max coordination overhead |

## Delegation Heuristics

- split by boundary, not by arbitrary file count alone
- avoid overlapping write ownership
- prefer analysis-first waves before complex coding
- reserve T1 for decisions, not generic implementation labor

## Conflict Prevention

- one owned file surface per active writing agent
- if conflict appears, re-split or elevate the decision
- do not parallelize tightly coupled edits without a clear merge plan
