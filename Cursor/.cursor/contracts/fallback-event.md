# Fallback Event Contract

Every fallback event record should include:
- timestamp
- agent
- tier
- expected model
- actual model
- reason
- impact on cost/quality/latency if relevant

Canonical storage: `.cursor/metrics/fallback-log.md`

## Example

```markdown
| 2026-05-21T12:40:00Z | Nova | T2 | gpt-5.3-codex | gpt-5.2 | transient model unavailability | lower cost, possible coding-depth tradeoff |
```
