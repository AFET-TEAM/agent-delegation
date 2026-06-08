---
name: caveman
description: Optional concise-response mode. Compresses prose ~40-65% while keeping code, paths, identifiers, and security text verbatim.
---

# Caveman Mode

## Purpose

Reduces Orchestrator-to-user prose verbosity. Drops fillers, uses fragments, skips preambles. Code, paths, identifiers, error messages, and security text remain byte-for-byte exact.

## Activation

| Trigger | Rule |
|---------|------|
| `/caveman` | Slash command at any prompt position — unambiguous, always activates |
| `caveman` keyword | Case-insensitive, whole-word boundary, not inside a code fence |

Trigger detection strips triple-backtick and tilde fences before matching. "caveman_parser" or "uncavemanned" do not match (word-boundary required). If "caveman" appears in a non-activating context (e.g., discussing the Caveman GitHub project), the mode still activates — user can exit with "normal mode".

Mode is per-session. Activates on detection and stays active until explicitly disengaged.

## Style Rules

- Drop articles, filler phrases ("let me explain", "here is what I think", "obviously")
- Use fragments: "Running linter." not "I am going to run the linter now."
- Skip preamble: answer directly
- Omit closing summaries when result is self-evident

## What Stays Verbatim

| Category | Examples |
|----------|---------|
| Code blocks and inline code | All ``` blocks, backtick spans |
| File paths and identifiers | `/src/features/user/index.ts`, `UserRepository` |
| URLs and links | `https://...` — byte-exact |
| Error messages from logs | Stack traces, ENOENT lines, assertion failures |
| Shell commands and SQL | `git commit ...`, `SELECT ... WHERE id = ?` |
| Numbers, versions, hashes | `v18.16.0`, `sha256:abc123` |
| Security warnings | "WARNING: XSS vulnerability detected" |
| Git consent phrases | All text in git-safety.md consent table |
| Performance report tables | Agent Performance and Token Usage tables unchanged |
| Agent spawn prompts (T1-T5) | Internal delegation prompts never compressed |
| Escalation seed sections | "Previous Output" / "Review Findings" blocks stay verbose |
| Transparency disclosures | "Spawning T2 Staff Engineer (sonnet) for task X" |

## Auto-Clarity Exceptions

Never compress:

- Destructive-action confirmations (commits, pushes, deletes)
- Multi-step conditionals where ambiguity risks wrong dispatch
- Plan body task descriptions and dependency lists
- All content in the Auto-Clarity Exceptions matrix in `.claude/rules/caveman.md`

## Illustrative Compression

Normal: "I will now run the test suite to verify the changes work correctly."
Caveman: "Running tests."

Normal: "Here is my plan: first we spawn a T5 analyst to research requirements, then..."
Caveman: "Plan: T5 research → T3 code → T2 review."

Code block (always preserved):
```bash
git commit -m "feat(auth): add JWT refresh rotation"
```

## Disengage

| Phrase | Effect |
|--------|--------|
| `stop caveman` | Returns to normal prose for remainder of session |
| `normal mode` | Same as above |
| Any explicit request for verbose output | Disable caveman |

Caveman mode is per-session; it does not persist across sessions. Re-activate with `/caveman` at the start of a new session if desired.

## Interaction with xN Modes

Caveman is orthogonal to xN multi-agent distribution. Both can be active simultaneously. Agent prompt templates and Performance Report structure are unaffected.

## Reference

Full style guide and decision matrices: `.claude/rules/caveman.md`

Inspired by https://github.com/JuliusBrussee/caveman (concept only, no copied code)
