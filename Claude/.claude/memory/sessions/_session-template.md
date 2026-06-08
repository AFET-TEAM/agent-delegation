---
session-id: <YYYY-MM-DD-cycle-N>
created: <timestamp-UTC>
mode: <xN>
tasks-total: <int>
tasks-completed: <int>
tasks-failed: <int>
duration-minutes: <int>
---

# Session Performance Report

## Summary

- Mode: x{N}
- Tasks: {n}
- Completed: {n}
- Failed: {n}
- Duration: {n} minutes
- Orchestrator model: {model-id}

## Agent Performance

| Name | Tier | Model | Task | Status | Review | Edits | Revisions |
|------|------|-------|------|--------|--------|-------|-----------|
| <agent-name> | T{tier} | {model} | {task-id} | completed\|failed | first-pass\|second-pass\|3+-rounds | {n} | {n} |

## Token Usage

| Name | Estimated | Actual | Delta |
|------|-----------|--------|-------|
| <agent-name> | {k}K | {k}K | {+/-}K |

## Learned Patterns (new this session)

- Pattern ID: <id> — <brief description>

## Changes Made

- <file-path> — <summary of change>

## Leaderboard Update

(Populated automatically by update-leaderboard.sh SessionEnd hook.)

## Notes

<Orchestrator-level observations, decisions, or deferred items>
