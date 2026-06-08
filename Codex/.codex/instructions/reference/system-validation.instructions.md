# System Validation Instructions

## Purpose

Check that the Codex boilerplate remains structurally coherent after modifications.

## Validation Phases

### Structural
- required files exist
- references resolve
- hooks and skills are present

### Configuration
- model registry aligns with tier definitions
- settings JSON is valid
- no stale placeholders remain

### Operational
- review chain is documented
- fallback log path exists
- memory and metrics artifacts exist
- templates and demos exist

## Acceptance Criteria

The package passes if:
- no required artifact is missing
- no critical internal references are broken
- no contradictory model mapping remains
