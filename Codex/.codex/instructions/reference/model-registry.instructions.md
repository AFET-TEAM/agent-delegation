# Model Registry Reference

## Purpose

Provide a stable quick-reference layer so tier/model decisions remain consistent with the config registry.

## Canonical Source

- `.codex/config/tier-definitions.md`

## Current Default Mapping

- Orchestrator/T1 -> `gpt-5.4`
- T2 -> `gpt-5.3-codex`
- T3/T4/T5 -> `gpt-5.2`

## Selection Criteria

- choose strongest model for architecture/final review
- choose coding-specialized model for serious implementation work
- choose lighter model for bounded or analysis-heavy tasks

## Reasoning Effort

- Orchestrator/T1/T2/T4/T5 -> high
- T3 -> medium unless risk warrants high

## Fallback Relationship

- if top-tier model unavailable, preserve role semantics and log the substitution
- if lighter tier model is insufficient, escalate rather than silently under-solving
