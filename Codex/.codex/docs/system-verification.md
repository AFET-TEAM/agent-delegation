# System Verification

## Functional Verification Checklist

- agent files exist and reference real rules/instructions
- model registry aligns with tier definitions
- required skills exist
- required hooks exist
- runtime settings files exist
- sample analysis/memory/metrics artifacts exist
- internal `.codex/` path references resolve
- canonical English root docs exist for the required operator set
- review-report contract exists and is referenced by review instructions

## Behavioral Verification Checklist

- fallback has a log destination
- review chain has explicit routing
- review outputs have a structured contract
- PCD has a documented flow
- context mode and graphify have documented workflows
- templates exist for major project types
- hook scripts fail safely when persistence is unavailable
- Graphify degrades gracefully when graph artifacts are missing or stale
- root docs remain internally consistent after operational changes

## Current Known Runtime Caveat

In read-only or partially restricted environments, advisory persistence hooks may skip writing and emit advisory messages instead of failing the whole workflow.
