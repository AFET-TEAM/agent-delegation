# Task Assignment Matrix

| Task Type | Owner Tier | Reviewer Tier | Notes |
|---|---|---|---|
| Repo/document discovery | T5 | T4 | raw report expected |
| Consolidated analysis | T4 | Orchestrator/T2 depending on task | implementation-ready brief |
| Architecture decision | T1 | Self / Orchestrator | ADR if major |
| Complex feature | T2 | T1 | tests expected |
| Scoped feature / boilerplate | T3 | T2 | bounded scope |
| Review pass | T2/T1 | upper tier | severity-based |
| Test scenario generation | T5 | T4 | include edge/failure cases |
| Migration / major refactor | T2 or T1 | T1 | split by boundary |

## Routing Notes

- if contract risk is high, prefer T2/T1 ownership
- if the work is mostly discovery, keep it in T5/T4 first
- avoid giving cross-module architectural work directly to T3
