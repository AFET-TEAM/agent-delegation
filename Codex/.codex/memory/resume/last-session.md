# Last Session Resume

## Current State
Runtime now supports safe file-writing, revision loops, and automatic bookkeeping.

## Most Important Decisions
- writes are sandboxed into runtime workspace-mirror unless explicitly allowed
- revision required results can retry up to 2 rounds before escalation
- metrics/session/todo updates occur automatically after serious delegate runs

## Recommended Next Use
`./bin/team delegate "review path with spaces.md x2"`

## What To Recheck In New Environments
- rg availability
- python3 subprocess policies
- runtime artifact retention expectations
