# Model Registry — Cursor Runtime

Kanonik tier eşlemesi: `tier-definitions.md`. Cursor Task aracı modeli doğrudan zorlamaz; tier prompt'larında aşağıdaki **hint** kullanılır.

## Cursor Model Hints

| Tier | Primary Hint | Fallback Hints |
|------|--------------|----------------|
| Orchestrator / T1 | claude-4.6-opus | claude-4.5-opus, claude-4.6-sonnet |
| T2 | claude-4.6-sonnet | gpt-5.3-codex, composer-2.5-fast |
| T3 | composer-2.5-fast | gpt-5.3-codex, claude-4.6-sonnet |
| T4 / T5 | gemini-3-flash / gemini-3.1-pro | claude-haiku-4.5, explore subagent |

## Subagent Type Mapping

| Tier | subagent_type | readonly |
|------|---------------|----------|
| T5, T4 | explore | true |
| T3, T2, T1 | generalPurpose | false |

## Fallback Visibility

Any model fallback must be recorded in `.cursor/metrics/fallback-log.md` and session summary.
