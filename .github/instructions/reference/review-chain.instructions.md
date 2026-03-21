# Review Chain Instructions

## Review Flow

```
Tier 3 (Analyst) → Tier 2.5 (Lead Analyst) reviews
Tier 2.5 (Lead Analyst) consolidated report → Available to coding agents
Tier 2 (MidCoder) → Tier 1.5 (Staff Engineer) reviews
Tier 1.5 (Staff Engineer) → Tier 1 (Principal) reviews
Tier 1 (Principal) → Submits final report to Orchestrator
```

## Review Rules

### General

1. Each review uses the checklist and format from the `code-review` skill.
2. Review result is one of three states: ✅ Approved | ⚠️ Revision Required | ❌ Rejected.
3. For **Critical** findings, the reviewer applies the fix themselves (or requests it from a higher tier).
4. For **Major** findings, a fix is requested — the task owner agent makes the correction.
5. **Minor** and **Suggestion** findings are noted but are not blockers.

### Lead Analyst → Analyst Review

- Does the analysis report format conform to standards?
- Are findings backed by source references?
- Is the confidence level specified?
- Are recommendations actionable?
- Is there missing coverage — is the analyzed scope sufficient?
- Lead Analyst consolidates multiple Analyst reports into a single coherent output.

### Staff Engineer → MidCoder Review

- Does the code compile / run?
- Are SOLID principles applied?
- Is error handling sufficient?
- Is naming convention consistent?
- Are complexity levels acceptable?
- Are there security vulnerabilities?

### Principal → Staff Engineer Review

- Is the architecture decision sound?
- Does the code meet production-quality standards?
- Are edge cases and error paths handled?
- Is the overall design consistent with project patterns?
- Are commit and PR standards followed?

### Escalation

- If there is a disagreement during review, the higher tier makes the final decision.
- Analyst can never override Lead Analyst's decision.
- Lead Analyst can never override MidCoder's or Staff Engineer's decision.
- MidCoder can never override Staff Engineer's decision.
- Staff Engineer can never override Principal's decision.
- Orchestrator mediates in disputes between tiers.

## Feedback Loop

```
1. Agent completes task → Produces output
2. Reviewer examines output → Provides feedback
3a. ✅ Approved → Output goes to Orchestrator
3b. ⚠️ Revision → Orchestrator routes feedback to agent → Agent corrects → Re-review
3c. ❌ Rejected → Orchestrator mediates reassignment or higher tier takes over
```

- A maximum of **2 revision rounds** are applied.
- If still not approved after 2 rounds, the higher tier takes over the task.

## Chain Integrity Rules

1. **No skip-level reviews**: A Tier 3 output cannot go directly to Tier 1 for review — it must pass through Tier 2.5 first. In reduced-mode configurations where a tier is absent, the next available **higher** tier assumes that review responsibility (see Reduced Mode Review Rules).
2. **No self-review substitution**: An agent cannot review its own output. The review must always be performed by a different agent.
3. **Review before merge**: No agent output is included in the final Orchestrator report without passing through at least one review.
4. **Cascading rejection**: If a reviewer rejects an output (❌), all dependent outputs that built on it are invalidated and must be re-evaluated.
5. **Review scope limitation**: A reviewer only reviews the output assigned to them — they do not modify the scope or requirements of the original task.

## Reduced Mode Review Rules

In configurations with fewer agents, the standard review chain adapts:

### x3 Mode (1 Principal + 1 Staff Engineer + 1 Analyst)

- No Lead Analyst available — Analyst output is reviewed by Staff Engineer instead.
- Staff Engineer output is reviewed by Principal (standard).
- Review chain: `T3 → T1.5 → T1 → Orchestrator`

### x4 Mode (1 Principal + 1 Staff Eng + 1 MidCoder + 1 Analyst)

- No Lead Analyst available — Analyst output is reviewed by Staff Engineer (next higher tier with review capability).
- MidCoder output is reviewed by Staff Engineer (standard).
- Review chain: `T3 → T1.5, T2 → T1.5 → T1 → Orchestrator`

### x2 Mode (1 Principal + 1 Analyst)

- Analyst output is reviewed directly by Principal.
- Principal applies the Lead Analyst review checklist (format compliance, source references, confidence levels, actionability) in addition to standard review criteria.
- Review chain: `T3 → T1 → Orchestrator`

> **Rule**: When a reviewer tier is absent from the configuration, the next available higher tier assumes that review responsibility. The substitute reviewer should apply the absent tier's review checklist from the `code-review` skill.

### x5+ Modes (x5, x7, x10)

All tiers are present — the full standard review chain from the "Review Flow" section applies without adaptation.

---

## Parallel Review Protocol

When multiple agents at the same tier produce independent outputs, their reviews can run in parallel to reduce total review time.

### When to Parallelize

- **x7+ modes**: Multiple Staff Engineers or Analysts produce outputs that are independently reviewable.
- **Module-isolated tasks**: Outputs that affect different modules/files with no shared dependencies.
- **Same-tier, different-reviewer not required**: Two T3 outputs can be reviewed by the single T2.5 (Lead Analyst) sequentially, but two T2 outputs can be reviewed by two different T1.5 agents in parallel.

### Parallel Review Rules

1. **Independent outputs only**: Two outputs can be reviewed in parallel only if they do not reference or depend on each other.
2. **Reviewer availability**: A single reviewer cannot review two outputs simultaneously. Parallel review requires multiple reviewers at the reviewing tier, or outputs queued for sequential review by the same reviewer.
3. **Conflict detection**: If parallel reviews produce conflicting feedback (e.g., two reviewers suggest incompatible patterns), the Orchestrator escalates to the next higher tier for resolution.

### Parallel Review Matrix

| Mode | T3 Outputs | T3 Reviewer (T2.5) | T2 Outputs | T2 Reviewer (T1.5) | T1.5 Outputs | T1.5 Reviewer (T1) |
|------|-----------|--------------------|-----------|--------------------|-------------|-------------------|
| x5   | 1         | 1 (sequential)     | 1         | 1 (sequential)     | 1           | 1 (sequential)    |
| x7   | 2         | 1 (sequential)     | 1         | 1 of 2 (parallel-capable) | 2     | 1 (sequential)    |
| x10  | 3         | 1 (sequential)     | 2         | 2 (parallel)       | 2           | 2 (parallel)      |

### Review Batching

When a single reviewer must handle multiple outputs sequentially:

1. **Priority ordering**: Review outputs in dependency order (outputs that others depend on are reviewed first).
2. **Batch feedback**: If multiple outputs share the same issue, the reviewer notes it once and references it in subsequent reviews.
3. **Time budget**: Each review should target 3K-8K tokens. If a review exceeds this, the reviewer should flag it as unusually complex.
