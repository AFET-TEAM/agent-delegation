# Caveman Mode — Optional Concise-Response Style

Inspired by the Caveman response-style convention (https://github.com/JuliusBrussee/caveman; concept only, no copied code). All technical substance preserved. Only filler removed.

## When Active

Default mode is **NORMAL**. Caveman mode activates on two triggers, detected at Step 1 (Prompt Analysis) after stripping code fences (triple-backtick and `~~~` blocks) from the user prompt:

| Trigger | Condition |
|---------|-----------|
| `/caveman` slash command | Appears at any position in the user message (unambiguous; takes precedence) |
| Keyword `caveman` | Case-insensitive, whole-word boundary match in prompt body; not inside a code fence |

**Trigger detection rule:** `(?i)(^|\s|[^\w])caveman(?:\s|[^\w]|$)` applied after code-fence scan. Substrings like `uncavemanned` or `caveman_parser` do not match.

Scope: Orchestrator-to-user prose only. All other output (agent prompts, code, tables, paths) unaffected.

## Style Rules

| Rule | Verbose (Normal) | Concise (Caveman) |
|------|-----------------|-------------------|
| Drop articles | "The approach is…" | "Approach:" |
| Drop filler openers | "Let me walk you through…" | (omit entirely) |
| Drop softening | "I should mention that…" | (omit entirely) |
| Use fragments | "I will now run the test suite." | "Running tests." |
| Short synonyms | "In order to achieve…" | "To…" |
| Jump to answer | Preamble + answer | Answer only |
| Setup/closure text | "I'll take care of that for you." | "Done." |
| Reasoning steps | "Here is my thinking: first…" | Omit when result is self-evident |

Precision is never traded for brevity. File paths, command syntax, error codes, and version strings are always exact.

## What Stays Verbatim

These artifacts are never compressed, shortened, or paraphrased under any circumstances:

| Category | Examples |
|----------|----------|
| Fenced code blocks | ```` ```typescript\nconst x = 42;\n``` ```` |
| Inline code | `` `getUserById` ``, `` `src/features/user/index.ts` `` |
| File paths and identifiers | `/Users/dev/project/src/auth.ts`, `UserRepository`, `CLAUDE.md:37` |
| URLs | `https://github.com/org/repo` |
| Shell commands | `git commit -m "feat(auth): add JWT rotation"` |
| SQL queries | `SELECT * FROM users WHERE id = ?` |
| Regex patterns | `^[a-z][a-zA-Z0-9]+$`, `\d{3}-\d{2}-\d{4}` |
| Error messages copied from logs | `Error: ENOENT: no such file or directory, open '/tmp/config.json'` |
| Version strings and hashes | `node v18.16.0`, `sha256: abc123def456` |
| Security warnings | `WARNING: This operation is irreversible. Continue?` |
| Destructive-action confirmations | `Would you like me to commit these changes?` |
| Git consent text | All phrases in git-safety.md "What Counts as Consent" table |
| Escalation seed prompts | "Previous Output", "Review Findings" sections (CLAUDE.md escalation format) |
| Performance Report tables | Agent Performance, Token Usage — structure and data rows unchanged |

## Auto-Clarity Exceptions

Mode temporarily suspends compression when any of the following apply:

| Situation | Reason |
|-----------|--------|
| Security vulnerability alert or warning | Ambiguity = breach or data loss risk |
| Destructive-action confirmation (delete, reset, force-push) | Explicit consent required; cannot afford misread |
| Git consent dialog | git-safety.md demands unambiguous, explicit phrasing |
| Multi-step conditional requiring user decision | Compression → wrong branch taken |
| Escalation seed context (agent handoff) | Agent needs full context; truncation = repeated failure |
| Plan body (task descriptions, dependency list) | Compressed plan = unactionable instructions |
| Technical ambiguity resolution (file:line, flag meaning) | Diagnostic precision required |
| Transparency disclosures | "Spawning T2 Staff Engineer (sonnet) for task X" — users must know who acts |

When an exception applies, the Orchestrator writes that specific output in full before resuming compressed mode for the remainder of the response.

## Disengage

| User Phrase | Effect |
|-------------|--------|
| "stop caveman" | Disables mode; resumes normal verbose output |
| "normal mode" | Same |
| "deactivate caveman" | Same |
| Any explicit request for verbose/detailed output | Same |

Mode is **per-session**. It does not persist across sessions and is not saved to memory files.

## Examples

**Prompt:** "Can you run the linter and fix any issues?"

NORMAL:
> I'll go ahead and run the linter on the project now to identify any violations. Once the scan completes, I'll fix each issue I find and let you know what was changed.

CAVEMAN:
> Running linter. Fixing violations. Will report changes.

**Prompt with preserved code (both modes identical):**

> File: `src/features/auth/auth-service.ts:45`
> Error: `ValidationError: field 'email', constraint 'must be a valid email address'`

Code blocks, paths, and error messages are byte-for-exact in both modes.

## Interaction with Multi-Agent Mode

Caveman mode is orthogonal to the xN parameter. Both can be active simultaneously.

| Component | Caveman Effect |
|-----------|---------------|
| Orchestrator-to-user prose | Compressed |
| Agent prompts (T1–T5 templates) | No change — agents need full instructions |
| Performance Report tables | No change — structure preserved; `update-leaderboard.sh` parses these |
| Performance Report narrative wrapper | Compressed |
| xN task distribution logic | No change — caveman controls output verbosity only |
| Hook outputs | No change — hooks are system-generated, not user-facing |

**Rule:** The Orchestrator never compresses outbound agent spawn prompts. Templates in `.claude/agents/{role}.md` are always read and forwarded verbatim. Only the final Orchestrator-to-user message compresses.
