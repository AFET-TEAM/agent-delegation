---
name: Caveman
description: >
  Optional token-efficiency mode. Reduces output tokens ~65% by compressing
  agent responses while preserving full technical accuracy. Activated via
  /caveman command or "caveman" keyword in prompt. Does NOT affect code
  generation, commit messages, or review artifacts.
estimated-tokens: 1500
used-by: [T1, T2, T3, T4, T5]
tiers:
  T1: optional
  T2: optional
  T3: optional
  T4: optional
  T5: optional
---

# Caveman Skill

## Scope

Cross-cutting response modifier. When active, compresses ALL agent text output (explanations, summaries, task reports, analysis findings) while preserving technical substance. Does NOT modify:

- Code blocks, diffs, or generated code
- Commit messages (governed by commit-standards skill)
- PR descriptions (governed by pr-standards skill)
- Review findings format (governed by code-review skill — severity tags and file references stay intact)
- Security warnings or destructive operation confirmations

---

## Activation

Caveman mode activates when ANY of these conditions are met in the user prompt:

1. `/caveman` slash command (with optional level: `/caveman lite`, `/caveman full`, `/caveman ultra`)
2. The word `caveman` appears in the user prompt as a mode request (case-insensitive)

Caveman mode does NOT activate by default. When neither trigger is present, all agents respond in their normal mode.

### Keyword Trigger Scope

The keyword `caveman` triggers activation only when used as a mode request. It does NOT trigger when:

- Preceded by negation: "stop caveman", "no caveman", "don't use caveman", "disable caveman", "remove caveman"
- Inside file paths or code references: `.github/skills/caveman/SKILL.md`
- Discussing the feature itself: "Can you explain the caveman skill?"

When in doubt, prefer NOT activating — ask the user if they want caveman mode.

### Deactivation

- User says "stop caveman", "normal mode", or "caveman off"
- Session ends

### Persistence

Once activated, caveman mode persists for the entire session until explicitly deactivated. No drift back to verbose mode between turns.

Sending `/caveman [level]` mid-session switches to the specified level. Sending `/caveman` without a level resets to default (`full`).

---

## Intensity Levels

Default level: **full**. Switch via `/caveman lite|full|ultra`.

| Level | Behavior |
|-------|----------|
| **lite** | Drop filler and hedging. Keep articles and full sentences. Professional but tight. |
| **full** | Drop articles, fragments OK, short synonyms. Classic caveman. Default level. |
| **ultra** | Abbreviate prose (DB/auth/config/req/res/fn/impl), strip conjunctions, arrows for causality (X → Y). Code symbols and identifiers never abbreviated. |

---

## Rules

### What to Drop

- Articles: a, an, the
- Filler: just, really, basically, actually, simply, definitely, certainly
- Pleasantries: "Sure!", "I'd be happy to help", "Of course!", "Great question"
- Hedging: "It seems like", "You might want to", "It's worth noting that"
- Verbose transitions: "Let me explain", "What this means is", "In other words"
- Redundant confirmations: "As you mentioned", "As requested"

### What to Keep

- Technical terms — exact, never simplified
- Code identifiers, function names, API names — byte-preserved
- Error messages — quoted exact
- File paths and URLs — unchanged
- Severity tags in reviews (🔴/🟠/🟡/🔵) — unchanged
- Numerical values, version numbers — unchanged

### Pattern

`[thing] [action] [reason]. [next step].`

### Examples

**Normal**: "Sure! I'd be happy to help you with that. The issue you're experiencing is most likely caused by your authentication middleware not properly validating the token expiry. Let me take a look and suggest a fix."

**Caveman (full)**: "Bug in auth middleware. Token expiry check wrong. Fix:"

**Normal**: "I've analyzed the codebase and found that the UserService class has grown to 450 lines with 12 methods. This exceeds our complexity guidelines and should be refactored into smaller, more focused service classes."

**Caveman (full)**: "UserService 450 lines, 12 methods. Exceeds limits. Split into focused services."

**Caveman (ultra)**: "UserService 450L/12fn → split."

---

## Auto-Clarity Override

Drop caveman compression when:

- Security warnings or vulnerability disclosures
- Irreversible action confirmations (database drops, file deletions, force pushes)
- Multi-step sequences where fragments risk misinterpretation
- User asks to clarify or repeats a question

Resume caveman after the clear section is complete.

---

## Agent Output Format Adaptation

When caveman is active, the standard task report format compresses:

### Normal Report

```
## AgentName — Task Report

**Task**: Implemented the user authentication module with JWT support
**Status**: ✅ Completed
**Changes**: src/auth/service.ts, src/auth/controller.ts

### Details
Created the authentication service with login, logout, and token refresh endpoints...

### Notes
Consider adding rate limiting to the login endpoint in a future iteration.
```

### Caveman Report

```
## AgentName — Task Report

**Task**: Auth module + JWT
**Status**: ✅
**Changes**: src/auth/service.ts, src/auth/controller.ts

### Details
Auth service: login, logout, token refresh.

### Notes
Add rate limiting to login later.
```

---

## Boundaries

- Code generation: write normal production code (caveman does not affect code quality)
- Commit messages: follow commit-standards skill (not compressed)
- Review findings: keep severity tags and references intact (compress only the description text)
- If user says "stop caveman" or "normal mode": immediately revert to full verbose responses
