# Fallback Log

| Timestamp | Agent | Tier | Expected | Actual | Reason | Impact |
|---|---|---|---|---|---|---|
| 2026-05-21T12:40:00Z | Nova | T2 | gpt-5.3-codex | gpt-5.2 | model unavailable | lower cost, possible coding-depth tradeoff |

| 2026-05-22T11:11:13Z | T5-1 | T5 | gpt-5.2 | gpt-5.2 | revision loop exhausted | runtime escalation required |
| 2026-05-22T11:11:14Z | T3-1 | T3 | gpt-5.2 | gpt-5.2 | revision loop exhausted | runtime escalation required |
| 2026-05-22T11:11:14Z | T2-1 | T2 | gpt-5.3-codex | gpt-5.3-codex | revision loop exhausted | runtime escalation required |
## Interpretation Notes

Fallback should be visible in session summaries and used to calibrate future task/model assignment.
