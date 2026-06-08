# Delegation Rules

## xN Parameter Distribution Table

The xN parameter at the end of the user's prompt determines agent count and tier distribution.

### Fixed Distributions

| Parameter | Total | T1 Principal (opus) | T2 Staff Eng (sonnet) | T3 MidCoder (sonnet) | T4 Lead Analyst (haiku) | T5 Analyst (haiku) |
|-----------|-------|---------------------|--------------------------|----------------------|---------------------------|---------------------|
| x2 | 2 | 1 | 0 | 0 | 0 | 1 |
| x3 | 3 | 1 | 1 | 0 | 0 | 1 |
| x4 | 4 | 1 | 1 | 1 | 0 | 1 |
| x5 | 5 | 1 | 1 | 1 | 1 | 1 |
| x7 | 7 | 1 | 2 | 1 | 1 | 2 |
| x10 | 10 | 2 | 2 | 2 | 2 | 2 |
**Note**: T4 bottleneck fix — T4:2 allows parallel consolidation of T5 outputs.

### Dynamic Distribution Formula (for non-standard values)

T1 = max(1, round(N * 0.15))
T2 = max(1, round(N * 0.20))
T3 = N >= 5 ? max(1, round(N * 0.20)) : 0
T4 = N >= 5 ? 1 : 0
T5 = N - T1 - T2 - T3 - T4

Assertion: T1 + T2 + T3 + T4 + T5 == N

### Boundary Constraints

| Tier | Minimum | Maximum |
|------|---------|---------|
| T1 Principal | 1 | round(max(1, N * 0.20)) |
| T2 Staff Eng | 1 | round(max(1, N * 0.25)) |
| T3 MidCoder | 0 (N<5) / 1 (N>=5) | round(max(1, N * 0.25)) |
| T4 Lead Analyst | 0 (N<5) / 1 (N>=5) | 1 |
| T5 Analyst | 1 | remainder |

### Edge Cases

| Input | Resolution |
|-------|-----------|
| x1 | Single agent mode -- no multi-agent |
| x0 / N<0 | Ignore -- treat as no parameter |
| N > 10 | Cap at x10, warn user |
| No parameter | Single agent mode (default model) |

### Without Parameter

If no xN parameter, multi-agent mode is NOT activated. Standard single-agent operation.

## Cost Optimization Principles

1. Analysis/research/documentation --> Tier 5 (haiku, cheapest)
2. Simple coding/boilerplate/utility --> Tier 3 (sonnet)
3. Complex features/algorithms --> Tier 2 (sonnet)
4. Architecture/final review --> Tier 1 (opus, most expensive)
5. Analysis consolidation --> Tier 4 (haiku)
6. Repetitive multi-file generation --> Tier 3/5

## Execution Waves (DAG-Based)

Wave 1: All root nodes (no dependencies) -- parallel
Wave 2: Tasks whose deps completed in Wave 1 -- parallel
Wave 3+: Continue until all tasks dispatched

Typical pattern:
- Wave 1: T5 Analyst research (haiku)
- Wave 2: T4 Lead Analyst consolidation (haiku)
- Wave 3: T3/T2 Coding agents (sonnet) -- parallel
- Wave 4: Review agents -- sequential up the chain

When T5_count > 1 AND T4_count >= 2: Split T5 outputs evenly between T4 agents for parallel consolidation.

## Review Chain Reference

See `CLAUDE.md` Step 5 for the canonical review chain definition.

| Mode | Reduced Chain Summary |
|------|----------------------|
| x2 | T1 acts as Lead Analyst; reviews T5 directly |
| x3 | T2→T5, T1→T2 |
| x4 | T2→T5+T3, T1→T2 |
| x5+ | Full: T4→T5, T2→T3, T1→T2 |
