---
name: Security Check
description: >
  Quick security audit skill for scanning common high-risk patterns and producing triage-oriented findings.
estimated-tokens: 2200
used-by: [T1, T2, T4, T5]
tiers:
  T1: optional
  T2: optional
  T4: optional
  T5: optional
---

# Security Check Skill

## Purpose

Run a focused security-oriented pass over changed or targeted areas.

## Checklist

- auth/authz
- secrets
- injection risks
- unsafe rendering/output
- file/path handling
- logging/audit gaps

## Output Style

Prioritize findings by impact and exploitability, not by cosmetic severity alone.
