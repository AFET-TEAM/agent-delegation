# Task Assignment Matrix

## Task Type to Tier Mapping

| Task Type | Assigned Tier | Model | Rationale |
|-----------|---------------|-------|-----------|
| Architecture design | T1 Principal | opus | Critical decision, high-level knowledge |
| Final code review | T1 Principal | opus | Quality gate, final authority |
| Complex feature implementation | T2 Staff Engineer | sonnet | Primary coding agent |
| Complex algorithm | T2 Staff Engineer | sonnet | High accuracy coding |
| Spring Boot service implementation | T2 Staff Engineer | sonnet | Complex domain logic |
| API endpoint implementation | T3 MidCoder | sonnet | Templated work, medium complexity |
| Utility function | T3 MidCoder | sonnet | Simple, repetitive |
| Component scaffolding | T3 MidCoder | sonnet | Boilerplate generation |
| Spring Boot entity/DTO creation | T3 MidCoder | sonnet | Boilerplate-heavy |
| Frontend-backend contract alignment | T3 MidCoder | sonnet | Templated, documented |
| Java quality gate setup | T3 MidCoder | sonnet | Maven plugin config |
| Analyst output review/consolidation | T4 Lead Analyst | haiku | Analysis quality gate |
| Dependency analysis | T5 Analyst | haiku | Research task |
| Codebase mapping | T5 Analyst | haiku | Analysis task |
| Knowledge graph analysis (graphify query) | T5 Analyst | haiku | graphify query is read-only and fits T5 scope |
| Codebase topology mapping (graphify build) | T5 Analyst | haiku | Run /graphify . --local-only before analysis |
| God node identification | T5 Analyst | haiku | Use jq + graph.json per graphify-usage.md |
| Community detection analysis | T4 Lead Analyst | haiku | T4 consolidates graph community data into findings |
| Document reading/summarizing | T5 Analyst | haiku | Low complexity |
| Test scenario generation | T5 Analyst | haiku | Analysis-based |
| Performance profiling | T5 Analyst | haiku | Research |
| Backend security audit | T5 Analyst | haiku | Analysis, raw report |

## Review Assignment Matrix

| Code Author Tier | Reviewer Tier | Reviewer Model |
|------------------|---------------|----------------|
| T3 MidCoder | T2 Staff Engineer | sonnet |
| T2 Staff Engineer | T1 Principal | opus |
| T5 Analyst | T4 Lead Analyst | haiku |
| T1 Principal | Self-verified | -- |

> **Review chain authority**: See `CLAUDE.md` Step 5 for escalation rules (max 2 revision rounds; Rejected → upper tier takes over with context seed).

## Optimal Task Sizing

- Each sub-task: single deliverable (one file, one module, one report)
- Max 3 files per sub-task; split further if more
- Analysis tasks: scope to one concern
- If estimated > 15K tokens: Orchestrator must split before assigning
