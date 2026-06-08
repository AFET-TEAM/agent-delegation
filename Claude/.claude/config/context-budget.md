> See `.claude/config/tier-definitions.md` for the authoritative tier-model mapping.

# Context Budget

## Per-Tier Budget

> Authoritative tier budget table is in `.claude/config/tier-definitions.md` — Tier Token Budget section.

Summary:
- **T1 Principal**: Up to 8K PCD tokens, 10 context files
- **T2 Staff Engineer**: Up to 6K PCD tokens, 8 context files
- **T3 MidCoder**: Up to 5K task tokens (`max_tokens_per_task` in context-budget.json), 4K PCD tokens, 6 context files
- **T4 Lead Analyst**: Up to 5K PCD tokens, 5 context files (scoped: `.claude/analysis/consolidated/`)
- **T5 Analyst**: Up to 3K PCD tokens, 6 context files (scoped: `.claude/analysis/raw/`)

## Token Cost Estimation Matrix

| Task Type | Estimated Tokens | Confidence |
|-----------|-----------------|------------|
| Codebase analysis | 3-6K | High |
| Simple coding task | 5-10K | Medium |
| Component scaffolding | 8-15K | Medium |
| Complex feature | 15-30K | Medium |
| Architecture design | 10-20K | Medium |
| Code review | 3-8K | High |
| Test writing | 5-12K | Medium |
| Backend API endpoint | 5-12K | Medium |
| Dependency analysis | 2-5K | High |
| Documentation | 3-8K | High |

## Phase-Loaded Skills

These skills load only during commit/PR phase, not during active development:
- commit-standards
- pr-standards

These count against the budget only when loaded.

## Budget Exceeded Protocol

1. STOP immediately
2. Report conflict to Orchestrator
3. Orchestrator reassigns or elevates to higher tier

## Progressive Loading Order

1. Always: shared base rules (clean-code, git-safety)
2. Then: PCD context (project documentation)
3. Then: tier-specific skills per task type
4. Finally: phase skills (commit/PR) when needed
