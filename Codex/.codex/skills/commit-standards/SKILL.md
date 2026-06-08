---
name: Commit Standards
description: >
  Conventional commit and atomic change discipline skill.
estimated-tokens: 1600
used-by: [T1, T2, T3]
tiers:
  T1: optional
  T2: optional
  T3: optional
---

# Commit Standards Skill

## Purpose

Ensure that when git actions are explicitly approved, commit history remains usable and review-friendly.

## Rules

- no commit without explicit git-specific user approval
- use conventional commit format
- keep message scoped to actual logical change
- avoid mixed-purpose commits

## Example

```text
feat(auth): add refresh-token rotation handling
fix(notification): guard empty preference state
```

## Bad Pattern

Do not hide multiple unrelated changes behind a vague commit title.
