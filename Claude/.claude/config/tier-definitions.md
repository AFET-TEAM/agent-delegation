# Tier Definitions — Single Source of Truth

> All tier-to-model mappings and token budgets are defined here.
> `model-registry.md` and `context-budget.md` reference this file.

## Tier Model Mapping

| Tier | Role (TR) | Model | Agent Tool Param |
|------|-----------|-------|-----------------|
| Orchestrator | Teknik Koordinatör | opus (env: sonnet-4-6 fallback) | — |
| T1 Principal | Baş Yazılım Mimarı | opus (claude-opus-4-6+) | `model: "opus"` |
| T2 Staff Engineer | Kıdemli Yazılım Mühendisi | sonnet (claude-sonnet-4-6+) | `model: "sonnet"` |
| T3 MidCoder | Yazılım Geliştirici | sonnet (claude-sonnet-4-6+) | `model: "sonnet"` |
| T4 Lead Analyst | Kıdemli Sistem Analisti | haiku (claude-haiku-4-5+) | `model: "haiku"` |
| T5 Analyst | Sistem Analisti | haiku (claude-haiku-4-5+) | `model: "haiku"` |

## Tier Token Budget

| Tier | Max Active Skills | Max Context Files | PCD Files | PCD Tokens | Edit Permission |
|------|-------------------|-------------------|-----------|------------|-----------------|
| T1 Principal | 5 | 10 | 5 | 8K | Full |
| T2 Staff Engineer | 5 | 8 | 4 | 6K | Full |
| T3 MidCoder | 4 | 6 | 3 | 4K* | Full |
| T4 Lead Analyst | 3 | 5 | 5 | 5K | Scoped (.claude/analysis/consolidated/) |
| T5 Analyst | 2 | 6 | 3 | 3K | Scoped (.claude/analysis/raw/) |

## Capability Summary

| Tier | Can Spawn Agents | Can Edit Rules | Can Review |
|------|-----------------|----------------|------------|
| Orchestrator | Yes | No | Consolidation only |
| T1 Principal | No | No | T2 outputs |
| T2 Staff Engineer | No | No | T3 outputs |
| T3 MidCoder | No | No | — |
| T4 Lead Analyst | No | No | T5 outputs |
| T5 Analyst | No | No | — |

> **x10 distribution**: T1:2 + T2:2 + T3:2 + T4:2 + T5:2 = 10 (T4 bottleneck resolved by 2 parallel Lead Analysts)

> **T3 Note**: `max_tokens_per_task` in `context-budget.json` is 5000 (5K). The "4K*" column above represents PCD (Project Context Document) file token budget — a separate constraint. For task overflow checks, the binding value is the JSON `max_tokens_per_task`.
