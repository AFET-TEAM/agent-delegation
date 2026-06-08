# Context Mode Wrapper

## Purpose

Provide a team-facing wrapper so context discipline remains consistently active.

## Default Behavior

Context discipline is now considered default-on unless explicitly disabled.

## Why Use The Wrapper Anyway?

Even with default-on behavior, the wrapper still gives repeatable preflight checks:
- warn on large-output patterns
- block sensitive/exfiltration-prone commands
- surface Graphify staleness warnings
- keep git-safety expectations visible

## Script

- `.codex/wrappers/context-mode-wrapper.sh`
