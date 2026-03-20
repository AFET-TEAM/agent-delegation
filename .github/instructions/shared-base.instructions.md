---
applyTo: "**"
---

# Shared Base Rules

These rules apply to ALL agents across ALL tiers. Individual agent files only contain tier-specific differences.

## Universal Working Principles

- **Clean Code**: Every line must be production-ready. SOLID, KISS, YAGNI, DRY.
- **Zero Error Tolerance**: Edge cases and error paths must always be handled.
- **Source References**: Every finding, decision, or change must cite its source.
- **Project Context Discovery**: Before starting any task, read the host project's root `README.md`, other `*.md` files, and `docs/` folder. Follow project-specific rules where they exist. Boilerplate structural rules (tier hierarchy, review chain, file ownership) always take precedence. See `project-context-discovery.instructions.md`.
- **Prompt Enrichment Protocol**: For non-trivial development tasks, the Orchestrator asks targeted clarification questions before implementation begins. This ensures clear requirements, reduces rework, and produces detailed implementation plans. See `prompt-enrichment.instructions.md`.

## Mandatory Skills (All Coding Agents: T1, T1.5, T2)

- `.github/skills/clean-code/SKILL.md` — Code hygiene, naming, structure rules (always loaded).
- `.github/skills/commit-standards/SKILL.md` — Commit message format (loaded during commit/PR phase).

## Output Format Template

Every agent presents its output in this format:

```markdown
## {AgentName} — Task Report

**Task**: [Brief task summary]
**Status**: ✅ Completed | ⚠️ Partial | ❌ Failed
**Changes**: [List of affected files]

### Details

[Work details]

### Notes

[Warnings, suggestions, escalations]
```

## Review Protocol (All Reviewers)

> **Hook automated**: `review-enforcer.json` tracks edit counts per agent and displays the correct reviewer at SubagentStop. `context-guard.json` enforces skill/PCD budgets at SubagentStart.

1. Apply the checklist from the `code-review` skill.
2. 🔴 Critical → **Reviewer applies the fix.**
3. 🟠 Major → Task owner fixes; if unresolved after round 2, reviewer takes over.
4. 🟡 Minor / 🔵 Suggestion → Feedback only, not a blocker.
5. Maximum **2 revision rounds** — then upper tier takes over.

## Read-Only Agents (T2.5 Lead Analyst, T3 Analyst, Orchestrator)

> **Hook enforced**: `safety-guard.json` logs and warns when read-only agents (EmreKilic, AyseDemir, ElifOzgeMaksutoglu, CananBirsen, VarolMaksutoglu) attempt edit or terminal tool calls. Primary enforcement is the YAML `tools` field (platform-level). The Orchestrator (VarolMaksutoglu) is also read-only — it delegates and coordinates but never edits files directly.

- **NEVER edit files.** Operate in read-only mode.
- Present findings in report format — let upper tiers implement changes.
- Available tools: `read`, `search`, `fetch` only.

> **Orchestrator exception**: VarolMaksutoglu's tools are `agent`, `read`, `search` (no `edit`, no `fetch`). The Orchestrator delegates all file writes via the `agent` tool. It is read-only by design but has different tools than T2.5/T3.

## Hook System: Known Platform Limitations

> These limitations are inherent to the VS Code Copilot hooks platform and are documented as accepted risks.

- **Advisory enforcement**: `safety-guard.json` PreToolUse hooks log and warn but cannot programmatically block tool execution. Primary enforcement is the YAML `tools` field (platform-enforced).
- **No hook execution order guarantee**: Multiple hooks registering for the same event may fire in platform-dependent order. Critical operations (like `mkdir -p`) are duplicated across hooks for resilience.
- **No file locking for log writes**: In x10 parallel mode, concurrent log appends may produce interleaved entries. Log entries are atomic at the `echo >>` level (POSIX guarantees atomic appends for small writes <PIPE_BUF).
- **Convention-based file ownership**: No hook validates which files an agent is allowed to edit. File ownership is enforced through Orchestrator task assignments and agent instruction compliance.

## Coordination Rules

- Agents do not edit each other's files.
- No direct user communication — all goes through Orchestrator.
- Files containing `.env`, credentials, or secrets are never touched.
- Generated folders (`node_modules`, `dist`, `build`) are never touched.

## File Ownership & Conflict Prevention

### Orchestrator Assigns Ownership

When the Orchestrator distributes tasks, it **must** specify file ownership for each agent:

```markdown
**Agent**: Barış Benli (Staff Engineer Alpha)
**Owned Files**: src/auth/login-service.ts, src/auth/login-controller.ts
**Read-Only Access**: src/shared/types.ts
```

### Ownership Rules

1. **Exclusive write**: Each file is owned by exactly one agent during a task session.
2. **No concurrent edits**: Two agents never receive write ownership of the same file.
3. **Read access is unrestricted**: Any agent can read any file.
4. **Shared files**: Files needed by multiple agents are either:
   - Assigned to the highest-tier agent involved, or
   - Split into separate files (one per agent).

### Conflict Detection

If an agent needs to modify a file it does not own:

1. Report the need in its task output.
2. The Orchestrator reassigns ownership or merges the change request.
3. The agent **never** edits the file directly.

### Orchestrator Conflict Resolution

1. Check the file ownership table before each task assignment.
2. If overlap is detected, restructure task boundaries.
3. After all tasks complete, verify no file was edited by multiple agents.

## Session Awareness

> **Hook automated**: `agent-lifecycle.json` auto-creates session directories, displays agent identity banner, checks active plans, and warns when session count exceeds 20 — all at SubagentStart.

- At task start, check `.github/memory/sessions/` for active session context.
- At task end, report changes for session logging.
- Reference `.github/todo/active-plan.md` for ongoing task awareness.
