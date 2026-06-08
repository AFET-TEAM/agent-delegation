# Caveman Rule

## Purpose

Allow compressed operator-facing output without losing correctness.

## Rule

- if `/caveman` is present, reduce verbosity
- if `/caveman full` is present, answer with aggressive brevity by default
- if `/caveman ultra` is present, use telegraph-style compression where safe
- do not let helpfulness expand the answer beyond the selected compression mode unless safety requires it

## Must Preserve

- commands
- code
- file paths
- errors
- warnings
- approval/consent language
- irreversible action wording

## Anti-Pattern

Do not say caveman mode is active and then still answer in normal long-form style.
