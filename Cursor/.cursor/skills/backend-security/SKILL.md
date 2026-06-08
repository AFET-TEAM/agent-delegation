---
name: Backend Security
description: >
  Security baseline skill for untrusted input handling, auth/session concerns, secrets hygiene,
  and common backend exploit classes.
estimated-tokens: 3000
used-by: [T1, T2]
tiers:
  T1: mandatory
  T2: mandatory
---

# Backend Security Skill

## Purpose

Provide a minimum secure-thinking layer for backend changes.

## Security Checklist

- untrusted input entry points known?
- validation/sanitization path exists?
- output encoding/rendering safe?
- auth assumptions explicit?
- secret handling safe?

## Common Risks To Check

- SQL injection
- XSS via unsafe rendering or templating
- path traversal
- wildcard CORS
- missing authz or session hardening
- hardcoded credentials

## Validation Step

Before sign-off, ask: what attacker-controlled input reaches this code path and what blocks abuse?

## Example Finding

- Missing validation before file-path join on user-supplied input -> path traversal risk.
