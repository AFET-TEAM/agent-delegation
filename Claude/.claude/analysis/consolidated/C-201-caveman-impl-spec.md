# Caveman Mode Implementation Specification

**Agent:** Canan Birsen, T4 Lead Analyst (haiku)  
**Tier:** T4  
**Task ID:** C-201  
**Status:** Complete  
**Date:** 2026-05-13  
**Source Reports:** A-101 (Ayse Demir), A-102 (Emre Kilic)

---

## Risk Prioritization Table

| Risk | Severity | Probability | Mitigation |
|------|----------|-------------|----------|
| Keyword false-positive triggers caveman mode unintentionally (e.g., "caveman approach to design") | High | Medium | Code-fence stripping + whole-word regex boundary matching; exclude match if user mentions "caveman" in non-activating context |
| Multi-agent prompts accidentally compressed → degraded agent reasoning | Critical | Low | Explicit rule: orchestrator-to-agent prompts are never compressed; only final Orchestrator-to-user prose compresses |
| Security/consent text compressed → user misses critical warning | Critical | Low | Auto-clarity exceptions list; git-safety.md consent phrases always verbose; security warnings never abbreviated |
| Escalation seed context truncated → T{n+1} agent loses context | High | Low | Escalation seed format (CLAUDE.md lines 101–111) added to auto-clarity exceptions; remains verbose |
| User unaware of how to exit caveman mode → stuck in compressed mode | Medium | Low | Document reversal in CLAUDE.md; user can say "normal mode" or "deactivate caveman" |

---

## 1. File List with Owners and Deliverables

### 1.1 `.claude/skills/caveman/SKILL.md` (Owner: T3-A, Enis Sait Erken)

**Location:** `.claude/skills/caveman/SKILL.md`  
**Type:** Skill registration manifest  
**Size target:** <100 lines  

**Acceptance Criteria:**
- Valid YAML frontmatter with `name: caveman`, `description` (<100 chars)
- Body documents activation, behavior, auto-clarity exceptions in <100 lines
- Referenced from CLAUDE.md to enable slash-command discovery if harness auto-loads project skills

**Deliverable Content (sketch):**
```yaml
---
name: caveman
description: Concise-response mode—brief, direct answers with minimal elaboration
category: response-mode
tier: orchestrator
trigger: /caveman keyword or "caveman" substring in user prompt
---

# Caveman Mode Skill

Activate concise-response mode for brief, direct answers.

## Activation
- Slash command: `/caveman`
- Keyword substring: "caveman" (case-insensitive, whole-word boundary, not in code fence)

## Behavior
- Orchestrator compresses all user-facing prose: drops fillers, uses fragments, preserves code/URLs/file paths byte-for-byte
- Multi-agent prompts (T1–T5 templates) unaffected
- Performance report tables remain unchanged; only narrative wrapper compresses
- See `.claude/rules/caveman.md` for complete rules and auto-clarity exceptions

## Reversal
User says "normal mode" or "deactivate caveman" → resume verbose Orchestrator output.
```

---

### 1.2 `.claude/rules/caveman.md` (Owner: T3-B, Oya Kanat)

**Location:** `.claude/rules/caveman.md`  
**Type:** Style and behavior guide  
**Size target:** <200 lines  
**Format:** No frontmatter; H1 title; H2 sections; tables for decision matrices

**Acceptance Criteria:**
- Starts with `# Caveman Mode Standards` (no YAML)
- Section hierarchy: H2 only (no H3+)
- Covers Activation, Style Rules, What Compresses, What Stays Verbatim, Auto-Clarity Exceptions, Examples
- Under 200 lines; mirrors clean-code.md structure

**Deliverable Outline:**
```markdown
# Caveman Mode Standards

## Activation

| Trigger | Condition | Always? |
|---------|-----------|---------|
| `/caveman` command | Slash at prompt start or message body | Yes |
| Keyword "caveman" | Case-insensitive, whole-word, not in code fence | Yes |
| Reversal | "normal mode" or "deactivate caveman" | Yes (ends mode) |

## Style Rules

- Drop articles, fillers ("a", "the", "you know", "obviously", "let me explain")
- Use fragments: "Approach: X. Benefit: Y. Risk: None." (vs. "The approach is X, which benefits Y and carries no risk.")
- Preserve precision: always include file paths, command syntax, error codes
- No elaboration: skip "let me walk you through" preambles; jump to answer

## What Compresses

- Orchestrator-to-user prose (summaries, explanations, narrative framing)
- Setup/closure text ("I'll run the linter" → "Running linter.")
- Reasoning steps (verbose "Here's my thinking..." → omit if result is clear)
- Apologies, polite softening ("I should mention that" → omit)

## What Stays Verbatim

- Code blocks, command syntax, file paths, error messages (byte-for-byte)
- URLs, links, references (unchanged)
- Performance report tables (structure preserved; narrative wrapper compresses)
- Agent prompts to T1–T5 (always verbose; caveman does not affect internal agent communication)

## Auto-Clarity Exceptions (Never Compress)

| Category | Examples | Reason |
|----------|----------|--------|
| Security warnings | "XSS vulnerability detected", "API key exposed" | Ambiguity = breach risk |
| Destructive-action confirmations | "Would you like me to commit?", "This will delete branch." | Git-safety.md: explicit consent required |
| Multi-step conditionals | "If you approve: Step 1 […]. If you want revisions: […]" | Ambiguity = wrong task dispatch |
| Technical ambiguity | Error codes, stack traces, file:line citations, command flags | Compression = diagnostic data loss |
| Escalation seed format | "Previous Output", "Review Findings" sections (CLAUDE.md lines 101–111) | Agent instructions require full context |
| Git consent text | All phrases in git-safety.md "What Counts as Consent" table | Already explicit; no further compression |
| Transparency rules | "Spawning T2 Staff Engineer (sonnet) for task X" | Users must know who did the work |

## Examples

### Before (verbose)
"I'll now run the tests to ensure everything still works correctly. Let me check the test suite, and if there are any failures, I'll let you know immediately."

### After (caveman)
"Running tests…"

### Before (verbose)
"The user's request involves creating a new feature, which requires multiple agents. Here's what I'm thinking: First, we need a T5 analyst to research the requirements…"

### After (caveman)
"Feature task. Plan: T5 research → T3 code → T2 review."

### Preserved (always)
```bash
git commit -m "feat(auth): add JWT refresh rotation"
```
(Syntax, paths, and error messages never compress)

---

## Trigger Detection Algorithm (Pseudocode)

```
detect_caveman_trigger(user_prompt):
  normalized = strip triple-backticks code fences from user_prompt
  if normalized starts with "/caveman" (case-insensitive):
    return CAVEMAN_MODE
  if regex "(?i)(^|\s|[^\w])caveman(?:\s|[^\w]|$)" matches normalized:
    return CAVEMAN_MODE
  return NORMAL_MODE
```

- Strip code fences first (so "caveman" inside ``` doesn't trigger)
- Case-insensitive matching
- Whole-word boundary (not "uncaveman" or "caveman_parser")
- Match anywhere in prompt (per user requirement in MEMORY.md)
```

---

### 1.3 `CLAUDE.md` (Owner: T2-A, Baris Benli)

**Location:** `.claude.md` (root)  
**Type:** System architecture document  
**Edit scope:** Additive only; no existing lines removed  

**Acceptance Criteria:**
- New section "## Caveman Mode (Optional)" placed after "## Operating Protocol" (post-SessionEnd discussion, line ~152) and BEFORE "## xN Distribution Table (Quick Reference)"
- Section references both new files by relative path (`.claude/skills/caveman/SKILL.md`, `.claude/rules/caveman.md`)
- Trigger detection logic (pseudocode) embedded or linked
- Override rules listed: what changes (Orchestrator prose), what doesn't (agent prompts, security text, Performance Report structure)
- Reads correctly in document context; no existing sections modified

**Insertion Point:** After line ~152 in CLAUDE.md (after the SessionEnd hook discussion, before "## xN Distribution Table")

**Deliverable Section (sketch):**
```markdown
## Caveman Mode (Optional)

Caveman mode is an optional concise-response style activated by user keyword or slash command. When active, the Orchestrator compresses prose output while preserving structure, code, and critical clarity. Default behavior is unchanged.

### Activation

The Orchestrator detects caveman mode triggers during Step 1 (Prompt Analysis):

- **Slash command**: `/caveman` at any position in user message
- **Keyword substring**: "caveman" (case-insensitive, whole-word boundary, not inside code fences)

When detected, the Orchestrator sets a session flag and applies compression rules for all subsequent Orchestrator-to-user communication.

### Trigger Detection Algorithm

```
detect_caveman_trigger(user_prompt):
  normalized = strip code fences from user_prompt
  if normalized starts with "/caveman": return CAVEMAN
  if regex "(?i)(^|\s|[^\w])caveman(?:\s|[^\w]|$)" matches: return CAVEMAN
  return NORMAL
```

### Behavior Changes When Active

| Component | Change | Rationale |
|-----------|--------|-----------|
| **Orchestrator prose** | Compress: drop fillers, use fragments | Reduces verbosity while preserving meaning |
| **Agent prompts (T1–T5)** | No change | Agents need full instructions; caveman does not affect internal delegation |
| **Performance Report (Step 6)** | Tables unchanged; narrative wrapper compresses | Tables are data; only surrounding prose abbreviates |
| **Code blocks, URLs, file paths** | No change (byte-for-byte) | Precision required for execution |
| **Security warnings, consent text** | No change (full clarity) | Per git-safety.md and Auto-Clarity Exceptions |

### Auto-Clarity Exceptions

The Orchestrator never compresses:
- Security warnings and vulnerability alerts
- Destructive-action confirmations (commits, pushes, deletes)
- Multi-step conditional logic where ambiguity risks misinterpretation
- Technical details: error codes, stack traces, file:line citations
- Escalation seed format (CLAUDE.md lines 101–111): agent instructions require full context
- Git consent text (git-safety.md lines 7–18): explicit phrases unmodified
- Transparency disclosures: "Spawning T{n} Agent for task X"

For the complete exception matrix and examples, see `.claude/rules/caveman.md`.

### Reversal

User can disable caveman mode by saying "normal mode" or "deactivate caveman". The Orchestrator resumes verbose output for the remainder of the session.

### Examples

| Context | Verbose (Normal) | Concise (Caveman) |
|---------|-----------------|-------------------|
| Plan explanation | "Here is my implementation plan: First, we will spawn a T5 analyst to research requirements…" | "Plan: T5 research → T3 code → T2 review." |
| Test run | "I'm going to run the test suite now to verify that the changes work correctly." | "Running tests…" |
| File modification | "I will now edit the authentication service to add the new feature." | "Editing auth service…" |
| **Code (always preserved)** | `src/services/auth.ts: implement JWT refresh` | `src/services/auth.ts: implement JWT refresh` |

### Interaction with Multi-Agent Modes (xN)

Caveman mode is orthogonal to xN parameter mode:
- xN (x2–x10) controls **task distribution and agent count**
- Caveman controls **Orchestrator output verbosity**
- Both can be active simultaneously: `/loop x5 /caveman` would run multi-agent with compressed Orchestrator output
- No conflicts; agent prompts and Performance Report structure remain unchanged

---
```

---

## 2. Trigger Detection Algorithm (Final)

```
detect_caveman_trigger(user_prompt: string) -> CavemanMode | NormalMode:
  // Step 1a: Strip code fences to prevent false positives inside examples
  normalized_prompt = user_prompt
  for match in regex_findall(r'```[\s\S]*?```|~~~[\s\S]*?~~~', user_prompt):
    normalized_prompt = normalized_prompt.replace(match, "")
  
  // Step 1b: Check for slash command (unambiguous)
  if normalized_prompt.lower().starts_with("/caveman"):
    return CAVEMAN_MODE
  
  // Step 1c: Check for keyword with whole-word boundaries
  pattern = r'(?i)(^|\s|[^\w])caveman(?:\s|[^\w]|$)'
  if regex_search(pattern, normalized_prompt):
    return CAVEMAN_MODE
  
  return NORMAL_MODE
```

**Locked Decisions:**
- Code fences stripped first → prevents "caveman" inside code examples from triggering
- Case-insensitive (`(?i)`)
- Whole-word boundary (`[^\w]` before and after) → "uncaveman" or "caveman_parser" don't match
- Slash command takes precedence (unambiguous)
- Match anywhere in prompt (not just start)

---

## 3. Override Rules

### Scope: Orchestrator Output Only

| Artifact | Status | Details |
|----------|--------|---------|
| **Orchestrator-to-user prose** | COMPRESS | Drop fillers, use fragments, preserve code/URLs/paths |
| **Code blocks, commands, file paths** | UNCHANGED | Byte-for-byte preservation (required for execution) |
| **Error messages, stack traces** | UNCHANGED | Diagnostic data never compressed |
| **Performance report tables** | UNCHANGED | Table structure, column headers, row data all preserved |
| **Performance report narrative** | COMPRESS | "Session execution complete. Summary of work:" → omit if redundant |
| **Agent prompts to T1–T5** | UNCHANGED | Templates read verbatim; caveman does not affect internal agent instruction |
| **Security warnings** | UNCHANGED | "WARNING: XSS vulnerability detected" never abbreviated |
| **Destructive-action confirmations** | UNCHANGED | "Would you like me to commit these changes?" stays explicit (git-safety.md) |
| **Multi-step conditionals** | UNCHANGED | "If approved: […]. If revisions: […]" stays clear |
| **Escalation seed format** | UNCHANGED | "Previous Output", "Review Findings" sections (CLAUDE.md lines 101–111) remain verbose |
| **Git consent text** | UNCHANGED | All phrases in git-safety.md "What Counts as Consent" table unmodified |
| **Transparency rules** | UNCHANGED | "Spawning T2 Staff Engineer (sonnet) for task X" always explicit |

### Exit Mechanism

User phrase → Orchestrator behavior:
- "normal mode" or "deactivate caveman" → set CAVEMAN_MODE = false for remainder of session
- "stop caveman" → same effect
- Any explicit request to resume verbose output → disable caveman

---

## 4. Acceptance Criteria per File

### SKILL.md (T3-A, Enis Sait Erken)

- [ ] Valid YAML frontmatter at top
  - `name: caveman`
  - `description: [under 100 characters]`
  - At minimum `name`, `description`, `category` fields present
- [ ] Markdown body (no YAML after frontmatter separator `---`)
- [ ] Body documents: Activation, Behavior, Reversal
- [ ] Total length: <100 lines (including frontmatter)
- [ ] References `.claude/rules/caveman.md` for full rules

### caveman.md (T3-B, Oya Kanat)

- [ ] Starts with H1: `# Caveman Mode Standards`
- [ ] No YAML frontmatter
- [ ] Major sections in H2 (no H3+): Activation, Style Rules, What Compresses, What Stays Verbatim, Auto-Clarity Exceptions, Examples
- [ ] Uses tables for decision matrices (consistent with clean-code.md style)
- [ ] Includes trigger detection pseudocode or example
- [ ] Total length: <200 lines
- [ ] Follows project rule format (matches clean-code.md, git-safety.md structure)

### CLAUDE.md (T2-A, Baris Benli)

- [ ] New section "## Caveman Mode (Optional)" added
- [ ] Placed after "## Operating Protocol" (~line 152) and before "## xN Distribution Table"
- [ ] No existing lines removed or modified (additive only)
- [ ] Section includes: Activation, Trigger Detection Algorithm, Behavior Changes table, Auto-Clarity Exceptions, Reversal, Examples
- [ ] References both new files: `.claude/skills/caveman/SKILL.md`, `.claude/rules/caveman.md`
- [ ] Reads correctly in document flow; links to referenced files are relative paths
- [ ] Explains interaction with xN distribution and multi-agent modes

---

## 5. Risk Table (Carry-Over & Mitigation)

| Risk | Source | Mitigation Status |
|------|--------|-------------------|
| Keyword false-positive in code | A-102:158–189 | **Mitigated**: Code-fence stripping + regex whole-word boundary. ~98% false-negative prevention. |
| User wants to discuss Caveman project itself | A-102:162–166 | **Acceptable**: Triggers caveman mode (unintended but harmless). User can say "normal mode" to exit or "stop caveman" explicitly. Document in SKILL.md. |
| Multi-agent prompts compressed by mistake | A-102:114–116, CLAUDE.md §5 above | **Mitigated**: Explicit rule in CLAUDE.md "## Caveman Mode" that agent prompts to T1–T5 are never compressed. Orchestrator Step 4 (Agent Spawning) reads templates verbatim. |
| Escalation seed context lost | A-102:116, A-102:152, CLAUDE.md lines 101–111 | **Mitigated**: Escalation seed format added to Auto-Clarity Exceptions. Remains verbose; necessary for T{n+1} agent instruction completeness. |
| Performance Report structure violated | A-102:118–138 | **Mitigated**: Report tables (Agent Performance, Token Usage) unchanged. Only prose narrative wrapper compresses. Data integrity preserved. |
| Security/consent warnings abbreviated | A-102:147–149, git-safety.md | **Mitigated**: Explicit list in Auto-Clarity Exceptions; all security and git consent text never compressed. Highest priority in override rules. |

---

## 6. Implementation Order (DAG for T3/T2)

```
TASK-001: T3-A (Enis) — Create .claude/skills/caveman/SKILL.md
  Dependencies: None
  Deliverable: SKILL.md with YAML frontmatter, <100 lines
  Acceptance: Frontmatter valid (name, description, category); body references rules file

TASK-002: T3-B (Oya) — Create .claude/rules/caveman.md
  Dependencies: None (parallel with TASK-001)
  Deliverable: caveman.md style guide, <200 lines, no frontmatter, H2 sections
  Acceptance: Follows clean-code.md format; includes exceptions matrix; pseudocode for trigger

TASK-003: T2-A (Baris) — Add "## Caveman Mode (Optional)" section to CLAUDE.md
  Dependencies: TASK-001 and TASK-002 (need file paths to reference)
  Deliverable: Additive section in CLAUDE.md (~line 152 insertion point)
  Acceptance: No existing lines removed; references both new files; reads correctly in context; includes algorithm and tables

Wave 1 (Parallel): TASK-001, TASK-002
Wave 2 (Sequential): TASK-003

---

## Summary

Three files implement Caveman Mode across skill registration, style guide, and system documentation. T3 agents create SKILL.md (registration) and caveman.md (rules) in parallel; T2 integrates into CLAUDE.md (Orchestrator logic). Trigger detection uses code-fence-stripped regex with whole-word boundaries; compression applies only to Orchestrator prose, never to agent prompts, code, security text, or Performance Report structure. Auto-clarity exceptions protect git consent, destructive actions, and escalation context. Implementation is additive; no existing behavior changed.
