# Model Registry

> **Single Source of Truth**: Tier-to-model mapping is defined in `.claude/config/tier-definitions.md`. This file provides usage context for each model.

## Canonical Model Table

> See `.claude/config/tier-definitions.md` — Tier Model Mapping section for the authoritative tier-to-model table.

This file provides usage context and cost guidance for each model tier.

## Agent Tool Invocation

When spawning agents via the Agent tool, use the `model` parameter:

| Tier | Agent Tool Parameter |
|------|---------------------|
| T1 Principal | model: "opus" |
| T2 Staff Engineer | model: "sonnet" |
| T3 MidCoder | model: "sonnet" |
| T4 Lead Analyst | model: "haiku" |
| T5 Analyst | model: "haiku" |

## Fallback Rules

1. If primary model unavailable, fall to next tier's model
2. Never fallback upward (cost boundary protection)
3. Report all fallbacks in session performance report
4. T1 opus --> sonnet fallback marks -1 score for the agent name

## Fallback Chain

When a preferred model is unavailable, fall back in this order:

| Tier | Primary | Fallback 1 | Fallback 2 | Action If All Unavailable |
|------|---------|-----------|-----------|---------------------------|
| Orchestrator | opus | sonnet | haiku | Pause and alert user |
| T1 | opus | sonnet | — | Pause, alert Orchestrator |
| T2 | sonnet | haiku | — | Escalate to T1 |
| T3 | sonnet | haiku | — | Escalate to T2 |
| T4 | haiku | — | — | Pause, alert Orchestrator |
| T5 | haiku | — | — | Pause, alert Orchestrator |

**Scoring Impact**: Each fallback deducts -1 from the agent's score (per name-pool.md Scoring Rules). Never fallback upward (haiku → sonnet → opus) unless escalating to next tier.

**Escalation Log Format**: When fallback occurs, log to `.claude/metrics/fallback-log.md` with: timestamp, tier, primary, fallback-used, reason.

## Relative Cost Comparison

| Model | Relative Cost | Typical Use |
|-------|--------------|-------------|
| opus | $$$$$ | Architecture, final review, coordination |
| sonnet | $$$ | All coding tasks, implementation |
| haiku | $ | Analysis, research, consolidation |
