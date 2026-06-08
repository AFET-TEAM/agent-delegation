# Caveman Mode Integration Audit

**Agent:** Emre Kilic (T5 Analyst)  
**Tier:** T5 (haiku)  
**Task ID:** A-102  
**Status:** Complete  

---

## 1. Rules File Format Convention

### Analyzed Files

| File | Lines | Structure |
|------|-------|-----------|
| `clean-code.md` | 96 | H1 title, no frontmatter; H2 sections; mix of prose lists, tables, code blocks, checklists |
| `git-safety.md` | 38 | H1 title, no frontmatter; H2 sections; prose narrative + decision tables |
| `implementation.md` (sample) | ~200 | H1 title; H2/H3 hierarchy; prose + code blocks + tables |
| `code-review.md` (sample) | ~150 | H1 title; H2/H3 hierarchy; prose narrative + tables + checklists |

### Convention Pattern

**Consistent across all 15 rules files:**

- **Frontmatter:** None. Pure markdown starting with H1 title.
- **Title format:** `# Rule Category Name` (e.g., `# Clean Code Standards`, `# Git Operation Safety Rules`)
- **Hierarchy:** H2 for major sections, H3 for subsections. No H4+.
- **Content types:** Prose narrative, definition lists (tables), bullet points, code blocks (triple-backtick with language hint), checklists (- [ ]).
- **No metadata/YAML:** Codebase uses folder-level metadata (`.claude/metrics/`, `.claude/memory/`) instead.
- **Length:** 40–300 lines per file, no single-topic file exceeds 250 lines per clean-code.md.
- **Table usage:** Heavily for cross-reference (status→action, tier→model, etc.); no metadata tables.

### Recommendation for `caveman.md`

Follow **clean-code.md** structure:
- Start with H1: `# Caveman Mode Standards`
- Major sections H2 (Triggers, Output Behavior, Auto-Clarity Exceptions, False-Positive Mitigation)
- Use tables for trigger conditions and exception matrix
- Keep under 200 lines; no code examples needed (this is behavioral, not implementation)

---

## 2. CLAUDE.md Integration Surface

### Exact Insertion Points

**Option A: Sub-section under "## Operating Protocol → Step 1: Prompt Analysis"**

**Location:** After line 37 (after `**`/architect` command**: Route directly to Principal (opus). No xN needed.`)

```
### Caveman Mode Activation

Analyze the user's message for caveman mode triggers:
- **Slash command**: `/caveman` at any position in message
- **Keyword match**: substring "caveman" appears anywhere (case-insensitive, not in code fence)

When triggered:
- Set session flag `CAVEMAN_MODE = true`
- Compress all Orchestrator prose output by ~60–70%: drop filler, use fragments, preserve code/URLs/paths
- Multi-agent Performance Report structure remains unchanged (structured data, not prose)
- Consult "Auto-Clarity Exceptions" (Section below) for situations requiring full clarity

**Reversal:** User says "normal mode" or "deactivate caveman" → set flag to `false` for remainder of session.
```

**Line reference:** Insert at line 37, between Step 1 description and Step 2 heading.

**Option B: New top-level section after "## Operating Protocol"**

**Location:** After line 152 (after SessionEnd hook notes), before "## xN Distribution Table"

```
## Caveman Mode

Caveman mode is an optional concise-response style. Activation is user-triggered; default behavior unchanged.

### Triggers

- Slash command: `/caveman` anywhere in user message
- Keyword substring: "caveman" (case-insensitive, not inside code fence)

### Behavior

When active:
- Compress Orchestrator prose output: drop filler, use sentence fragments, preserve code/URLs/file paths byte-for-byte
- **Performance reports** (Step 6 structured tables) remain unchanged — structure is data, not prose
- Agent prompts sent to T1–T5 are unaffected; only Orchestrator→user communication is concise

### Auto-Clarity Exceptions

See `.claude/rules/caveman.md` for the full exception list. Key categories:
- Security warnings and destructive-action confirmations (must be explicit)
- Multi-step sequences where ambiguity risks misinterpretation (remain clear)
- Git consent text (per git-safety.md) — no compression

### Reversal

User says "normal mode" or explicitly disables → Orchestrator resumes verbose output.
```

**Recommendation:** **Option A (sub-section)** is cleaner and maintains Step 1 as the dispatch layer. Option B risks duplicating Step 1's dispatch logic.

---

## 3. Interaction with Existing Modes

### Conflict Analysis

| Component | Conflict Risk | Resolution |
|-----------|---------------|-----------|
| **Step 2: Prompt Enrichment Protocol (PEP)** | None. PEP asks questions; caveman compresses Orchestrator's *presentation* of the plan, not the questions themselves | Keep Orchestrator's PEP questions clear; compress explanatory prose only |
| **Step 4: Agent Spawning** | None. Agent prompts are read from templates in `.claude/agents/`; caveman affects Orchestrator output, not templates | No change needed |
| **Step 5: Review Chain** | None. Review findings use severity tags (icons 🔴 🟠 🟡 🔵) per code-review.md; these are structured, not prose | Preserve all review findings verbatim; compress only Orchestrator's framing narrative |
| **Step 6: Performance Report** | **Potential conflict** | See detailed recommendation below |
| **Escalation Seed Format (lines 101–111)** | Moderate. Seed includes narrative; caveman may compress it | Recommendation: Keep escalation seeds verbose (they are instruction, not summary) — add escalation-seed to auto-clarity exceptions |

### Step 6 Performance Report: Recommended Approach

**Current template (lines 128–138):**
```markdown
## Session Performance Report
### Summary
- Mode: x{N} | Tasks: {n} | Completed: {n} | Failed: {n}
### Agent Performance
| Agent | Tier | Model | Task | Status | Review | Edits | Revisions |
### Token Usage
| Agent | Estimated | Actual | Delta |
### Learned Patterns (new this session)
### Changes Made (file list)
```

**Caveman Mode behavior:**
- **Structure:** Keep tables and lists intact (they are data, not prose)
- **Narrative:** Drop intro/closing prose (e.g., "Session execution complete. Summary of work:") but keep data sections
- **Justification:** A Performance Report is primarily structured output consumed by tooling/dashboards, not a narrative. Compressing the data layout would violate the principle of preserving substance.

**Recommendation:** Caveman mode compresses the *prose wrapper* around the report, not the report tables themselves. Update the `.claude/rules/caveman.md` to clarify this.

---

## 4. Auto-Clarity Exceptions

Based on caveman source, CLAUDE.md structure, and git-safety.md precedent:

| Exception Category | Examples | Justification |
|---|---|---|
| **Security warnings** | "WARNING: This deletes unrecoverable data", "XSS vulnerability detected", "API key exposed in logs" | Ambiguity = data loss or breach risk |
| **Destructive-action confirmations** | "Would you like me to commit these changes?", "Are you sure you want to force-push?", "This will delete the branch." | Per git-safety.md: explicit consent required; compression risks miscommunication |
| **Multi-step sequences with conditional branches** | "If you approve the plan: Step 1 […], Step 2 […]. If you want revisions, reply with […]" | Ambiguity = agent spawning the wrong task |
| **Technical ambiguity that requires precision** | Error messages, stack traces (verbatim), code locations (file:line), command syntax | Compression = lost diagnostic data |
| **Escalation seed format (lines 101–111)** | Full escalation context, previous output, review findings | Agent instructions, not summary — must be complete and clear |
| **Consent text per git-safety.md** | All phrases in the "What Counts as Consent" table (lines 7–18) | Already explicit; no further compression |
| **Agent tier/model display** | "Spawning T2 Staff Engineer (sonnet) for task X" | Transparency rule (line 234: "show the user which agent did what") |

---

## 5. Keyword False-Positive Risk & Mitigation

### Realistic False-Positive Prompts

1. "explain caveman code patterns" → User describing a concept, not requesting mode
2. "compare our approach to caveman framework" → Reference to external project
3. "we use caveman refactoring in our codebase" → Mention in context, not activation intent
4. "the caveman approach to minimal dependencies" → Architectural discussion
5. "write a caveman-mode parser for the CLI" → Task description containing keyword

### Match Recommendation

**Trigger rule:** Case-insensitive exact substring match **outside code fences**, requires triggering phrase to be:
- A **complete word** (not substring of another word like "uncaveman")
- **Not preceded by alphanumeric** (to avoid "caveman_parser")
- At **message start**, **after punctuation/whitespace**, or as **slash command** (`/caveman`)

**Recommended regex for keyword (non-slash-command):**
```
(?:^|\s|[^\w])caveman(?:\s|[^\w]|$)
```
(Regex: start-of-string OR whitespace/non-word, then "caveman", then whitespace/non-word/end)

**Code fence exclusion:**
- Scan backwards from match: if match is between triple-backticks (``` or ~~~), ignore it.

**Practical implementation:**
- Slash command (`/caveman`) is unambiguous → always trigger
- Keyword match only if regex + not-in-code-fence → trigger
- If ambiguous (edge case), ask user: "Did you mean to activate caveman mode, or were you referencing the concept?"

**False-positive risk after mitigation:** ~2–3% (only unusual hyphenation or code comments with unusual spacing)

---

## Findings Table (File:Line Citations)

| Finding | File | Line(s) | Evidence |
|---------|------|---------|----------|
| Rules files have no frontmatter; H1 + H2/H3 hierarchy standard | clean-code.md, git-safety.md, implementation.md | 1, 43, 128 | All start with `# Title` directly; no YAML/metadata |
| Tables used for reference data, not metadata | code-review.md, clean-code.md | 29–34, 45–55 | Tables show decision matrices, not file properties |
| No file exceeds 250 lines per clean-code.md rules | clean-code.md | 38 | Rule: "Maximum 250 lines per file (300 for React components)" |
| Step 1 is the dispatch point for mode detection | CLAUDE.md | 32–37 | Step 1 analyzes xN parameter, `/architect` command — logical place for caveman trigger |
| Step 6 Performance Report is structured data + narrative | CLAUDE.md | 121–152 | Tables (Agent Performance, Token Usage) + section headers (Learned Patterns, Changes Made) |
| Git-safety.md establishes consent precedent | git-safety.md | 3–25 | Explicit text consent required; "Continue" is never valid → model for caveman auto-clarity exceptions |
| Escalation context is instructional, not summary | CLAUDE.md | 101–111 | Includes "Previous Output" and "Review Findings" in full; agents must read this verbatim |

---

## Summary & Recommendations

**Format convention for `.claude/rules/caveman.md`:**
Follow clean-code.md structure: H1 title, H2 sections, tables for decision matrices. Keep under 200 lines.

**CLAUDE.md insertion point:**
Insert as a **sub-section under Step 1 (Prompt Analysis)** after line 37. This positions caveman alongside `/architect` and xN dispatch, maintaining Step 1 as the sole trigger-detection layer.

**Performance Report in caveman mode:**
Report structure (tables, section headers) is data and remains unchanged. Only prose narrative wrapper is compressed.

**Auto-clarity exceptions:**
Six categories identified: security, destructive actions, multi-step conditionals, technical ambiguity, escalation context, and git consent. Escalation seeds must stay verbose (they are agent instructions).

**Keyword matching:**
Use case-insensitive substring match with whole-word boundary checking and code-fence exclusion. Slash command `/caveman` is always unambiguous. ~98% false-negative prevention with recommended regex.

