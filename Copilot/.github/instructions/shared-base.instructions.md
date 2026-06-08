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

## Mandatory Skills (All Coding Agents: T1, T2, T3)

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

## Analyst Agents — Scoped Write Access (T4 Lead Analyst, T5 Analyst)

> **Hook enforced**: `safety-guard.json` allows T4/T5 edit operations targeting `.github/analysis/` paths and logs+warns when they attempt edits outside this directory. Primary enforcement is the YAML `tools` field (platform-level) combined with instruction-based scoping.

- **T5 Analyst** (AnalystAlpha, AnalystBeta, AnalystGamma): May write to `.github/analysis/raw/` only.
- **T4 Lead Analyst** (LeadAnalyst): May write to `.github/analysis/consolidated/` only.
- **All other directories**: Read-only. Present findings in report format — let upper tiers implement changes.
- Available tools: `read`, `search`, `fetch`, `edit` (scoped).

### Analysis Output Pipeline

```
T5 writes raw report → .github/analysis/raw/{agent-name}-{topic}.md
T4 reads raw/, consolidates → .github/analysis/consolidated/{topic}-consolidated.md
Coding agents read consolidated/ as input for implementation tasks
```

## Orchestrator — Read-Only Coordinator (VarolMaksutoglu)

> The Orchestrator (VarolMaksutoglu) is read-only — it delegates and coordinates but never edits files directly. Tools: `agent`, `read`, `search` (no `edit`, no `fetch`).

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
**Agent**: StaffEngineerAlpha [Display Name]
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

## Context Efficiency Protocol (Always Active)

All agents MUST follow these context-protection principles in every task. These are not optional — they represent fundamental efficiency standards.

### Think-in-Code (Mandatory)

When analyzing, counting, filtering, or transforming data: **write a script** and report only the result. Do NOT read raw data into context for manual processing.

- Data > 5 KB → process via script, never read raw
- More than 3 files for one analysis → batch script
- Raw HTTP/API/log output → NEVER inline in context

### Output Routing (Mandatory)

- Artifacts > 20 lines → write to file, report path + 1-line summary inline
- Build/test results → report pass/fail + count only (full output on failure)
- Large diffs → write to file, summarize key changes inline

### Query-First (Mandatory)

Before reading a file, ask: "Can grep/search answer this?" Prefer:
1. Targeted grep for symbols
2. view_range for specific functions
3. Full file read only as last resort

### Confidence Tagging (Mandatory for Analysis)

Every analysis finding carries a confidence tag:
- 🟢 EXTRACTED — directly found in source
- 🟡 INFERRED (0.55-0.95) — reasonable deduction from evidence
- 🔴 AMBIGUOUS — uncertain, needs verification

### Context Budget Awareness

- Parallel tool calls in one response (never sequential when independent)
- Suppress verbose output (--quiet, --no-pager, pipe to head/grep)
- Progressive disclosure: shape → interface → logic → detail (stop at sufficient level)

> Full protocol: `.github/skills/context-efficiency/SKILL.md` and `.github/skills/knowledge-graph/SKILL.md`

---

## Context Mode (Optional — Intensified Efficiency)

Context mode is an **optional** intensification of the Context Efficiency Protocol. When activated, agents apply aggressive context-saving strategies beyond the baseline rules above.

### Detection

Context mode activates when the user prompt contains:

1. The `/context-mode` command (starts the intensified mode)
2. The phrase `context mode` or `context-mode` in the prompt as a mode request (case-insensitive)

If neither trigger is present, only the baseline Context Efficiency Protocol (above) applies.

### When Active (Intensified)

- Load `.github/skills/context-efficiency/SKILL.md` in full (core + extended sections)
- Load `.github/skills/knowledge-graph/SKILL.md` in full (core + extended sections)
- Apply strict output budgets: status updates ≤200 tokens, reports ≤1000 tokens
- Enforce maximum 2 KB inline output per tool call (everything else to file)
- Use batch operations aggressively (combine all independent calls)
- Report context savings at end of each major operation

### When NOT Active (Default)

- Baseline Context Efficiency Protocol still applies (Think-in-Code, Output Routing, Query-First)
- Extended budgets and reporting rules do not apply
- Skills loaded only when relevant to task type per normal context-loading rules

### Deactivation

- "stop context-mode" / "context-mode off" / "normal mode" deactivates intensified mode
- Baseline protocol remains active (it is always on)

---

## Caveman Mode (Optional Token Efficiency)

Caveman mode is an **optional** response style modifier that compresses agent text output by ~65% while preserving technical accuracy. It is NEVER active by default.

### Detection

Caveman mode activates when the user prompt contains:

1. The `/caveman` command (with optional level: `/caveman lite`, `/caveman full`, `/caveman ultra`)
2. The word `caveman` in the prompt as a mode request (case-insensitive). Does NOT trigger on negation ("stop caveman"), file paths, or feature discussion.

If neither trigger is present, agents respond in their normal verbose mode exactly as they do today. No behavior change occurs.

### When Active

- Load and apply `.github/skills/caveman/SKILL.md`
- Compress all text output (explanations, reports, analysis findings)
- Keep code blocks, commit messages, review severity tags, and security warnings unchanged
- Mode persists for the session until "stop caveman" / "normal mode" / "caveman off"

### When NOT Active (Default)

- All agents operate exactly as before this feature was added
- No output modification, no skill loading, no behavioral change
- This is the default state for every session
