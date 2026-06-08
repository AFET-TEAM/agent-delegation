# Slash Commands Reference

## Purpose

Normalize how command-like modifiers affect orchestration behavior.

## Default Active Modes[^mode-overrides]

Unless explicitly turned off by the operator, the following modes are treated as default-active:
- `/caveman`
- `/context-mode`
- `/graphify`

This means:
- compressed output is the baseline
- context discipline is the baseline
- topology-first narrowing is preferred when useful

## Commands and Effects

- `/delegate` -> multi-agent decomposition
- `/review` -> review-first pass
- `/status` -> state summary
- `/architect` -> architecture-first routing
- `/resume` -> continue prior context
- `/history` -> summarize prior decisions
- `/context-mode` -> strict context discipline (default-active[^mode-overrides])
- `/caveman` -> compressed output (default-active[^mode-overrides])
- `/graphify` -> topology-first exploration (default-active[^mode-overrides])
- `/pcd` -> project context discovery
- `/fallback-status` -> report fallback events

## Caveman Severity

- default baseline -> concise output
- `/caveman lite` -> lightly compressed
- `/caveman full` -> aggressively compressed by default
- `/caveman ultra` -> telegraph-style where safe

## xN Interaction

- `xN` controls agent scale
- inside Codex CLI sessions, a plain prompt containing `xN` should imply `/delegate` automatically
- default modes remain active unless explicitly disabled
- typical shortest operator form inside Codex CLI can now be just:
  - `task x5`
  - `task x10`

Operational interpretation:
- `task x5` => `/context-mode /graphify /caveman /delegate task x5`
- `task x10` => `/context-mode /graphify /caveman /delegate task x10`

## Examples

- `Auth feature x5`
- `Large refactor x10`
- `/delegate Auth feature x5`
- `Auth feature x5`
- `/review recent changes`

[^mode-overrides]: Note: Persistent opt-out support via `.codex/config/mode-overrides.md` (introduced v7.4.3-consolidated; runtime integration in progress). For now, slash `/X off` controls per-prompt only.
