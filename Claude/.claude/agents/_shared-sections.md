# Shared Agent Sections

> This file contains common boilerplate used across agent templates.
> Agent templates reference specific sections from here rather than duplicating.

## Self-Learning Protocol

At the start of every task, read `.claude/memory/learned-patterns/` (max 10 most recent files).
Apply all patterns relevant to your task category as "Dikkat Edilecek Noktalar" (points of attention).
If you encounter a new error pattern during your task, note it for the Orchestrator to save.

## Authority Limits Template

Agent tools are restricted by tier. Check your specific agent template for the exact permitted/prohibited tool list.
General rule: Higher tiers have broader access; lower tiers are scoped to their output directories.

## Revision Protocol

| Round | Action |
|-------|--------|
| Round 1 | Address all reviewer feedback, re-verify sources |
| Round 2 | Final revision; resolve all remaining issues |

Maximum 2 revision rounds. If issues remain after Round 2, escalate to upper tier.

## File Ownership Rule

Each file is owned by exactly one agent per session. Do not edit files assigned to another agent.
Check `.claude/todo/active-plan.md` for file ownership assignments before editing.

---

## Standard Skills to Load (T1–T3)

Load in phases — do NOT load all rule files at once:

- **Phase 1** (always): `clean-code.md`
- **Phase 2** (if PCD needed): `task-assignment-matrix.md` (T1/T2 only; T3 skips Phase 2)
- **Phase 3** (task-specific, max 1 file): Load ONLY what the task explicitly requires:
  - Frontend task → `react-patterns.md`
  - Backend task → `backend-development.md`
  - Security task → `backend-security.md`
  - Test task → `testing.md`
  - SCSS task (T2 only) → `scss-standards.md`
- **Phase 4** (on commit only): `commit-standards.md` + `git-safety.md`

---

## Standard Progressive Loading Order (T1–T3)

```
Session start → Phase 1 (always) → [CONTEXT GATE]
Simple task? STOP after Phase 1.

PCD needed? → Phase 2 → [CONTEXT GATE]
Most tasks STOP here.

Domain rule required? → Phase 3 (max 1 file) → [CONTEXT GATE]
Complex tasks only.

Committing? → Phase 4 (commit standards only)
```

## Context Gate
Load in phases — do NOT load all rule files at once.
- Stop after Phase 1 for simple tasks.
- Stop after Phase 2 for most implementation tasks.
- Phase 3: load ONE domain file maximum. Verify: total loaded files ≤ context-budget.md limit.
- Phase 4: commit-related files only, on commit.

---

## Default File Ownership (T1–T3)

| Directory | Access |
|-----------|--------|
| `src/` | Full read/write (assigned files only) |
| `tests/` | Full read/write (related tests only) |
| `.claude/` | Read-only (except Orchestrator) |
| `public/` | Read-only |
| Other project files | Read-only unless explicitly assigned |

Each file is owned by exactly one agent per session. Check `.claude/todo/active-plan.md` for ownership. Do not edit another agent's assigned files.

---

## Escalation Protocol

If you see `## Escalation Context` at the top of your task prompt, it means you are receiving a task that was previously assigned to a lower-tier agent and either rejected (❌) or failed revision twice (2× ⚠️). The escalation prompt includes:

- **Previous Output**: The failing agent's last output
- **Review Findings**: All reviewer comments with severity tags
- **Your Task**: The original task description

Read all three sections carefully before implementing. Do not repeat the previous agent's mistakes. Reference CLAUDE.md:99-109 for the full escalation seed format.

---

## Learned Patterns from Prior Sessions

<!-- INSERT_LEARNED_PATTERNS_HERE: Orchestrator replaces this marker with content loaded from .claude/memory/learned-patterns/*.md at spawn time. If no patterns exist or are relevant, this section is empty. -->

The Orchestrator loads learned patterns (max 10, most recent) and injects them here. Use these as "Dikkat Edilecek Noktalar" (points to be careful about) — they are rules derived from past errors. If none are present, proceed with standard discipline.
