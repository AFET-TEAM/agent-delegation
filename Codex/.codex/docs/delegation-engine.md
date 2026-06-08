# Delegation Engine

## Purpose

Make `xN` operationally visible instead of leaving it as documentation-only convention.

## Script

- `.codex/scripts/delegation_plan.py`

## What It Does

Given a task prompt with `xN`, it produces:
- resolved mode
- tier distribution
- execution wave plan
- default-active mode reminder

## Example

```bash
python3 .codex/scripts/delegation_plan.py "Auth feature x5"
```

## Important Truth

This is a planning and visibility engine.
It does not itself spawn real external agent processes.
It makes the multi-agent routing plan explicit and testable.
