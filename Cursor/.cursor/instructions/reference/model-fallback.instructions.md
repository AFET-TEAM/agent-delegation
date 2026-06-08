# Model Fallback Reference

## Purpose

Standardize what happens when a preferred model is unavailable or inappropriate.

## Canonical Sources

- `.cursor/config/tier-definitions.md`
- `.cursor/config/model-registry.md`
- `.cursor/docs/model-fallback.md`

## Rules

- fallback never happens silently
- fallback does not change tier permissions
- fallback must be logged in `.cursor/metrics/fallback-log.md`
- user-facing session summary should mention quality/cost impact when material

## Effort Rules

- principal/orchestrator work remains high effort even after fallback if the substitute model supports it
- low-risk T3 tasks may remain medium effort
