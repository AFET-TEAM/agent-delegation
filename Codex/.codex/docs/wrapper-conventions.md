# Wrapper Conventions

## Purpose

Explain how teams can operationalize this package with lightweight wrappers without pretending the runtime is magical.

## Canonical Wrapper Goals

A wrapper should help with:
- preflight reminders
- optional hook execution
- risk visibility
- post-task artifact reminders
- command normalization for repeatable team usage

## Recommended Wrapper Flow

### Preflight
- detect whether `/pcd` should be suggested
- detect whether `/context-mode` should be suggested for wide tasks
- run selected blocking/advisory hooks
- print a concise operator reminder if git-consent or context rules matter

### In-Task
- preserve the user prompt
- do not rewrite away slash-command intent
- annotate whether hooks ran in blocking or advisory mode

### Postflight
- remind the operator to update session artifacts for serious sessions
- surface fallback events
- surface stale graph warnings
- suggest `/review` if implementation occurred without an explicit review pass

## Example Team Policy

- blocking: git safety, secret checks, critical security hooks
- advisory: context mode guard, graphify audit, leaderboard update, pattern collection
- required postflight reminder for multi-agent sessions

## Important Constraint

Wrappers reinforce discipline; they do not replace direct evidence, review chain behavior, or explicit git consent.
