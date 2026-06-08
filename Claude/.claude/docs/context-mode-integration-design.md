# context-mode Integration Design

**Prepared by:** Enis Sait Erken (T2 Staff Engineer)
**Date:** 2026-05-20
**Session:** 2026-05-20-context-graphify-x10
**Status:** Complete — Ready for T3 Implementation
**Target Implementer:** Taner Yilmaz (T3 MidCoder)

---

## ADR-001: context-mode MCP Integration

### Status
Accepted

### Context
Our multi-agent system (Claude Code v1.0.0) consumes approximately 50K tokens per x10 session in context overhead: raw bash output, file dumps, session re-context-setting after compaction, and repeated loading of prior analysis. This degrades agent performance, increases cost, and causes daily multi-project sessions to require manual re-context-setting.

context-mode (v1.0.146, `@context-mode/mcp`, 15.2K GitHub stars) is a production-grade MCP server that addresses this via:
- Subprocess sandboxing: tool outputs stay in process, only summaries enter context (98% reduction)
- SQLite FTS5 knowledge base: prior analysis searchable via `ctx_search` without re-loading files
- Session continuity: `SessionStart` hook restores working state after compaction

T4 Lead Analyst (A-501 + C-T4A reports) gave CONDITIONAL GO. Two P0-Critical security issues (SEC-001: incomplete credential redaction; SEC-005: private network fetch exposure) and two P1-High issues (SEC-002: unrestricted file access; SEC-004: PATH preservation) must be mitigated before production use. The mitigations are configuration changes and a new guard hook — no upstream code changes required.

### Decision
Integrate context-mode into Claude Code v1.0.0 with the following approach:
1. Register as MCP server in `.claude/settings.json` with hardened environment variables
2. Add SessionStart hook for session continuity
3. Add PostToolUse hook for credential redaction (context-mode's own hook)
4. Create `.claude/hooks/context-mode-guard.sh` as a new PreToolUse:Bash hook to redirect large bash output to `ctx_execute`
5. Create `.claude/skills/context-mode/SKILL.md` for agent access
6. Create `.claude/rules/context-mode-usage.md` with mandatory routing rules
7. Extend `.claude/agents/analyst.md` with ctx_* tool guidelines
8. Keep all 16 existing hooks intact — no modifications

### Rationale
- Token savings: 50K → ~12K per x10 session (76% reduction = ~$0.30/day, ~$15/month)
- Session continuity eliminates re-context-setting on multi-day projects (saves 12K tokens per session restart)
- context-mode hooks are additive: no existing hook conflict (different matchers, different event types)
- P0 mitigation (`CTX_FETCH_STRICT=1`) is a single environment variable
- New guard hook (`context-mode-guard.sh`) is the 17th hook — no existing hook modified

### Consequences
**Positive:**
- 76% reduction in per-session context consumption
- Session state persists across compaction events
- T5 Analyst can search prior findings without re-reading session files

**Negative:**
- Additional SQLite database at `.claude/analysis/knowledge.db` (project-scoped)
- New npm dependency: `@context-mode/mcp`
- P1 risks (file access, PATH) are not fully mitigated by config alone — documented as known residual risk, acceptable for local trusted-dev environments
- SQLCipher (P1: SEC-006) requires upstream package change; deferred to TASK-003-F in hardening sprint

**Neutral:**
- Hook count increases from 16 to 17

### Affected Files
| File | Change Type | Owner |
|------|-------------|-------|
| `.claude/settings.json` | Modify — add MCP server, new hooks, env vars | T3 |
| `.claude/hooks/context-mode-guard.sh` | Create — new PreToolUse:Bash hook | T3 |
| `.claude/skills/context-mode/SKILL.md` | Create — new skill | T3 |
| `.claude/rules/context-mode-usage.md` | Create — new rules file | T3 |
| `.claude/agents/analyst.md` | Modify — add ctx_* sections | T3 |
| `.claude/config/hook-registry.md` | Modify — add new hook entry | T3 |

---

## Component Specifications

### 1. settings.json MCP Config

The current `.claude/settings.json` (146 lines) must be updated with four changes:
- New `mcpServers` block
- New MCP permission allows
- New hooks entries (PreToolUse:MCP, PostToolUse:MCP, SessionStart)
- New `env` block

**Complete replacement content for `.claude/settings.json`:**

```json
{
  "mcpServers": {
    "context-mode": {
      "command": "npx",
      "args": ["@context-mode/mcp@latest"],
      "type": "stdio"
    }
  },
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(npm test *)",
      "Bash(npm install *)",
      "Bash(npx *)",
      "Bash(node *)",
      "Bash(git status *)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(git show *)",
      "Bash(git branch)",
      "Bash(git remote -v)",
      "Bash(git stash list)",
      "Bash(git tag -l)",
      "Bash(mkdir -p *)",
      "Bash(ls *)",
      "Bash(chmod +x *)",
      "MCP(context-mode/ctx_execute)",
      "MCP(context-mode/ctx_batch_execute)",
      "MCP(context-mode/ctx_execute_file)",
      "MCP(context-mode/ctx_index)",
      "MCP(context-mode/ctx_search)",
      "MCP(context-mode/ctx_fetch_and_index)",
      "MCP(context-mode/ctx_stats)",
      "MCP(context-mode/ctx_doctor)",
      "MCP(context-mode/ctx_upgrade)",
      "MCP(context-mode/ctx_purge)",
      "MCP(context-mode/ctx_insight)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Edit(./.env)",
      "Edit(./.env.*)",
      "Write(./.env)",
      "Write(./.env.*)",
      "Read(./secrets/**)",
      "Edit(./secrets/**)",
      "Edit(./node_modules/**)",
      "Write(./node_modules/**)",
      "Edit(./dist/**)",
      "Write(./dist/**)",
      "Edit(./build/**)",
      "Write(./build/**)"
    ]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/block-console-log.sh",
            "timeout": 10
          },
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/block-any-type.sh",
            "timeout": 10
          },
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/block-comments.sh",
            "timeout": 10
          },
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/secret-guard.sh",
            "timeout": 5
          },
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/analysis-scope-guard.sh",
            "timeout": 5
          },
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/figma-standards-guard.sh",
            "timeout": 10
          },
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/sql-injection-check.sh",
            "timeout": 10
          },
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/xss-prevention-check.sh",
            "timeout": 10
          },
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/path-traversal-check.sh",
            "timeout": 10
          },
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/field-injection-check.sh",
            "timeout": 10
          },
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/cors-wildcard-check.sh",
            "timeout": 10
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/git-safety-check.sh",
            "timeout": 5
          },
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/context-mode-guard.sh",
            "timeout": 5
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/review-tracker.sh",
            "timeout": 5
          },
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/self-learning-collector.sh",
            "timeout": 5
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "npx @context-mode/mcp hooks sessionstart",
            "timeout": 10
          }
        ]
      }
    ],
    "SessionEnd": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/update-leaderboard.sh",
            "timeout": 15
          },
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/pattern-lifecycle.sh",
            "timeout": 15
          }
        ]
      }
    ]
  },
  "env": {
    "CTX_DB_PATH": "./.claude/analysis/knowledge.db",
    "CTX_FETCH_STRICT": "1",
    "CTX_MAX_CONCURRENCY": "4",
    "CTX_OUTPUT_CAP": "102400000",
    "CTX_TIMEOUT_DEFAULT": "30000",
    "CTX_DB_ENCRYPTION": "true",
    "CTX_SEARCH_RATE_LIMIT": "10",
    "CTX_DENY_PATHS": "~/.ssh,~/.aws,~/.kube,~/.gnupg,./.env,./.env.*,./secrets"
  }
}
```

**Design notes:**
- `mcpServers` uses `npx @context-mode/mcp@latest` (no global install required; version pinning in Installation section)
- `CTX_DENY_PATHS` is a comma-separated list of path prefixes that context-mode's PreToolUse hook blocks from file access within `ctx_execute`. This addresses P1 SEC-002 at the config level without requiring chroot (which is deferred to TASK-003-C hardening sprint).
- `CTX_DB_ENCRYPTION=true` signals intent for SQLCipher; actual encryption requires TASK-003-F. Until then, set DB permissions to `700` (see Installation section).
- The 11 existing `PreToolUse:Edit|Write|MultiEdit` hooks are fully preserved — not modified.
- The `PostToolUse` for MCP tools deliberately omits a custom hook. context-mode's own `posttooluse.mjs` fires automatically via the MCP server lifecycle (not wired in settings.json). Our `review-tracker.sh` and `self-learning-collector.sh` fire only for Edit/Write/MultiEdit, which is correct.
- `SessionStart` uses the `npx @context-mode/mcp hooks sessionstart` command pattern. If context-mode ships a dedicated hook runner, substitute the exact command from `npx context-mode doctor` output.

---

### 2. skills/context-mode/SKILL.md Content

Create this file at `.claude/skills/context-mode/SKILL.md`:

```markdown
---
name: context-mode
aliases: [ctx]
description: Context window optimizer. Use ctx_* MCP tools to run analysis, index knowledge, and search prior findings without polluting context.
---

# context-mode Skill

## Purpose

Reduces context consumption by routing tool output through the context-mode MCP sandbox.
Instead of loading raw file contents or bash output into context, agents run operations through
`ctx_execute` and receive only the summary result.

## Slash Command

`/context-mode` or `/ctx`

When invoked, this skill activates context-mode guidance for the current task. The agent:
1. Switches to ctx_* tools for any bash-equivalent analysis
2. Uses ctx_index to store large findings for later retrieval
3. Uses ctx_search instead of re-reading previously indexed files

## Tool Reference

| Tool | When to Use | Token Cost |
|------|-------------|------------|
| `ctx_execute(language, code)` | Run any shell/script command; returns only stdout | ~10 tokens (vs 500-8000 raw) |
| `ctx_batch_execute(language, code[], concurrency)` | Run multiple commands in parallel | ~10 tokens each |
| `ctx_execute_file(filePath, language, code)` | Process a file without dumping its content into context | ~20 tokens |
| `ctx_index(source, content, type)` | Store large text for future retrieval | ~5 tokens (write-only) |
| `ctx_search(query, limit, source)` | Retrieve ranked chunks from indexed knowledge | ~200 tokens per search |
| `ctx_fetch_and_index(url, sourceLabel)` | Fetch a URL and index its content | ~20 tokens |
| `ctx_stats()` | Database statistics | ~50 tokens |
| `ctx_doctor()` | Validate installation | ~50 tokens |

## Routing Decision Tree

```
Need to run a bash command?
  └── Would output exceed ~200 lines or 5KB?
        ├── YES → use ctx_execute("shell", "your command")
        └── NO  → use Bash tool directly

Need to read a large file (>10KB)?
  └── Is the file already indexed in this session?
        ├── YES → use ctx_search("relevant query")
        └── NO  →  Is it a one-time read?
                    ├── YES → use Read tool directly
                    └── NO  → use ctx_execute_file + ctx_index for reuse

Need prior session knowledge?
  └── use ctx_search("what you're looking for")
      Do NOT re-read .claude/memory/sessions/ files
```

## Prohibited Patterns

- Never call `ctx_execute` with commands that read sensitive paths:
  `~/.ssh`, `~/.aws`, `~/.kube`, `./.env`, `./secrets`
- Never use `ctx_fetch_and_index` with localhost or private IP URLs
  (CTX_FETCH_STRICT=1 blocks these, but do not attempt them)
- Never index raw credential values; always redact before calling `ctx_index`

## When NOT to Use ctx_* Tools

- Simple file reads under 10KB → use Read tool
- Single-line bash commands with short output → use Bash tool
- Writing files → use Edit/Write tools (ctx_* is read/execute only)
- Git operations → use Bash tool (git-safety-check.sh still enforces consent)
```

---

### 3. rules/context-mode-usage.md Content

Create this file at `.claude/rules/context-mode-usage.md`:

```markdown
# context-mode Usage Rules

paths:
  - ".claude/agents/**"
  - "**/*.md"

These rules govern all T1–T5 agents when context-mode MCP tools are available.

## Mandatory Routing Rules

The following bash patterns MUST be replaced with ctx_execute equivalents.
Agents that use raw Bash for these patterns violate this rule.

| Banned Bash Pattern | Required ctx_execute Equivalent |
|--------------------|---------------------------------|
| `bash("find . -name '*.ts' \| wc -l")` | `ctx_execute("shell", "find . -name '*.ts' \| wc -l")` |
| `bash("cat large-file.json")` when file >10KB | `ctx_execute_file(filePath, "shell", "cat $FILE_CONTENT \| jq '.key'")` |
| `bash("grep -r 'pattern' src/ --include='*.ts'")` | `ctx_execute("shell", "grep -r 'pattern' src/ --include='*.ts'")` |
| `bash("du -sh ./")` | `ctx_execute("shell", "du -sh ./ 2>/dev/null")` |
| `bash("ls -la src/")` where output >50 lines | `ctx_execute("shell", "ls -la src/ \| wc -l")` (count only) |
| Re-reading `.claude/memory/sessions/*.md` | `ctx_search("relevant topic from session")` |
| Re-reading `.claude/analysis/raw/*.md` | `ctx_search("finding topic")` after indexing |

## Large File Prohibition

Agents MUST NOT load files exceeding 10KB directly into context for the purpose of analysis.
Use `ctx_execute_file` to process the file and return only the summary.

```
# Wrong — dumps 50KB file into context
Read("/path/to/large-file.ts")

# Correct — only the count enters context
ctx_execute_file("/path/to/large-file.ts", "shell", "wc -l < $FILE_CONTENT_PATH")
```

Exception: T3 MidCoder may use Read for files they are editing (file ownership rule applies).
T4/T5 Analysts must always use ctx_execute_file for files they are only analyzing.

## ctx_index Protocol

When to index:
- After completing a T5 analysis report: index the report into source `"analysis-{date}"`
- After T4 consolidation: index into `"consolidated-{date}"`
- When a large external document is fetched: index via `ctx_fetch_and_index` immediately

How to index:
```
ctx_index(
  source: "analysis-{task-id}-{date}",
  content: {full report text},
  type: "prose"
)
```

When NOT to index:
- Do not index raw file dumps containing credentials
- Do not index files from `./secrets/`, `./.env`, `~/.ssh`, `~/.aws`
- Do not index output that contains API keys or tokens (redact first)

## Session Continuity Protocol

After context compaction (SessionStart fires automatically), agents MUST:

1. Check session snapshot (injected by SessionStart hook) before re-reading files
2. Use `ctx_search("prior task context")` to retrieve prior findings
3. Do NOT re-read `.claude/memory/sessions/` files — search the knowledge base instead

Example:
```
# Instead of this:
Read(".claude/memory/sessions/session-2026-05-19.md")

# Do this:
ctx_search("session context auth module implementation", limit=5)
```

## T5 Analyst Integration

T5 Analyst agents specifically must:

1. Before any bash-equivalent analysis command, check if output >5KB is expected
   → If yes, route to `ctx_execute`
2. After completing analysis, call `ctx_index` with the full report
3. When searching for prior findings from other T5 agents in this session, use `ctx_search`
4. Never use `ctx_execute` to read from sensitive paths (list in Security section below)

## Security Constraints

These constraints are enforced by `context-mode-guard.sh` and the `CTX_DENY_PATHS` env var.
They are listed here for agent awareness.

### Denied Paths (Never pass to ctx_execute or ctx_execute_file)

```
~/.ssh/
~/.aws/
~/.kube/
~/.gnupg/
./.env
./.env.*
./secrets/
```

### Denied Network Targets (Never pass to ctx_fetch_and_index)

```
127.0.0.1
192.168.*.*
10.*.*.*
169.254.*.*
100.100.*.*
metadata.google.internal
```

### Rate Limit

ctx_search is limited to 10 queries per second per session (CTX_SEARCH_RATE_LIMIT=10).
Do not call ctx_search in tight loops. Batch your queries.

## Residual Risk Notice

context-mode is a **context reduction tool, not a security sandbox**.
Subprocess execution via `ctx_execute` has access to:
- Project files (unless listed in CTX_DENY_PATHS)
- System PATH tools (mitigated by `context-mode-guard.sh` blocking exfiltration tools)

Deploy only on trusted local development machines. Never use on shared systems or cloud VMs
without completing the full hardening sprint (TASK-003-B through TASK-003-F).
```

---

### 4. hooks/context-mode-guard.sh Content

Create this file at `.claude/hooks/context-mode-guard.sh` with execute permission (`chmod +x`):

```bash
#!/usr/bin/env bash
# context-mode-guard.sh
# PreToolUse:Bash hook
# Purpose: (1) Block dangerous exfiltration tools from being called directly via Bash.
#          (2) Warn when a Bash command is likely to produce large output (>5KB equivalent)
#             and suggest the ctx_execute alternative.
# Trigger: PreToolUse with matcher "Bash"
# Hook slot: 17th hook (after git-safety-check.sh in the Bash matcher chain)
set -euo pipefail

INPUT=$(cat)

if command -v jq >/dev/null 2>&1; then
  COMMAND=$(jq -r '.tool_input.command // empty' <<<"$INPUT")
else
  COMMAND=$(echo "$INPUT" | grep -o '"command"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
fi

if [ -z "$COMMAND" ]; then
  exit 0
fi

# ── Block 1: Exfiltration tool guard ─────────────────────────────────────────
# Block known network exfiltration binaries when called directly via Bash.
# context-mode's own PreToolUse hook blocks these inside ctx_execute;
# this guard covers direct Bash calls.
EXFILTRATION_TOOLS="nc ncat socat wget curl ftp sftp scp rsync ssh"

for tool in $EXFILTRATION_TOOLS; do
  # Match: tool at start of command, after pipe, after &&, after ||, after ;
  if echo "$COMMAND" | grep -qE "(^|[|&;]\s*)$tool\s"; then
    # Exception: curl/wget used for health checks in npm scripts are typically
    # prefixed with "npm run". Allow those through (matched by earlier npm allow rule).
    # Only block direct invocations.
    echo "{\"type\":\"text\",\"text\":\"[context-mode-guard] BLOCKED: '$tool' is an exfiltration-capable tool. Use 'ctx_execute' with explicit allow if network access is required for analysis.\"}" >&2
    exit 2
  fi
done

# ── Block 2: Sensitive path access guard ─────────────────────────────────────
# Warn when Bash command directly reads from sensitive paths.
# CTX_DENY_PATHS covers this inside ctx_execute; this catches direct Bash reads.
SENSITIVE_PATTERNS=(
  "\.ssh/"
  "\.aws/"
  "\.kube/"
  "\.gnupg/"
  "/etc/passwd"
  "/etc/shadow"
  "\.env\b"
  "secrets/"
)

for pattern in "${SENSITIVE_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    echo "{\"type\":\"text\",\"text\":\"[context-mode-guard] BLOCKED: Command accesses sensitive path matching '$pattern'. This path is on the deny list. If access is required, use Read tool with explicit file path.\"}" >&2
    exit 2
  fi
done

# ── Block 3: Large-output command redirect advisory ──────────────────────────
# Commands that typically produce large output. These are not blocked (agent may
# have good reason), but a warning suggests ctx_execute as an alternative.
LARGE_OUTPUT_PATTERNS=(
  "find\s.*-name\s.*\|"
  "find\s.*-type\sf\b"
  "grep\s-r\s"
  "grep\s--recursive\s"
  "cat\s.*\.json\b"
  "cat\s.*\.ts\b"
  "cat\s.*\.md\b"
  "ls\s-la\b"
  "ls\s-R\b"
  "du\s-sh\b"
  "wc\s-l\b"
)

for pattern in "${LARGE_OUTPUT_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    # Advisory only — exit 0 allows command through; message goes to stderr (visible in UI)
    echo "{\"type\":\"text\",\"text\":\"[context-mode-guard] ADVISORY: Command '$COMMAND' may produce large output. Consider: ctx_execute(\\\"shell\\\", \\\"${COMMAND}\\\") to keep output out of context.\"}" >&2
    exit 0
  fi
done

exit 0
```

**Design notes:**
- Exit code 2 = block (following the pattern of `git-safety-check.sh` and other hooks in this project)
- Exit code 0 = allow
- The advisory in Block 3 exits 0 (non-blocking) — it is a hint, not an enforcement rule. This avoids false positives during wave 1 when T5 agents may intentionally use small bash outputs.
- Block 1 targets only direct Bash calls. context-mode's own `pretooluse.mjs` handles the same inside `ctx_execute` commands.
- The hook reads `COMMAND` from `.tool_input.command` (Bash tool input schema), with jq primary and grep/sed fallback — matching the pattern of the existing `git-safety-check.sh`.

**No existing hooks are modified.** The new hook is appended to the existing `Bash` matcher in settings.json after `git-safety-check.sh`.

---

### 5. agents/analyst.md Additions

The following section must be added to `.claude/agents/analyst.md`. Insert it **after** the `## Authority Limits` section and **before** the `## Skills to Load` section.

**Exact text to insert:**

```markdown
## context-mode Tool Guidelines

context-mode MCP tools are available to T5 Analyst. Use them to reduce context consumption
during analysis tasks.

### When to Use ctx_execute

Use `ctx_execute("shell", command)` instead of raw Bash when:
- The command output would exceed 200 lines or ~5KB
- You are running `find`, `grep -r`, `wc`, `du`, or `ls -R` across the full project
- You need to process a file but only care about the summary (count, pattern match, key extraction)

Example:
```
# Instead of Bash("find . -name '*.ts' | wc -l") which dumps the file list:
ctx_execute("shell", "find . -name '*.ts' | wc -l")
# Returns: "245" — only 3 tokens instead of ~2000
```

### When to Use ctx_index

After completing your raw analysis report, index it for future retrieval:
```
ctx_index(
  source: "analysis-{your-task-id}-{date}",
  content: {full report markdown},
  type: "prose"
)
```
This allows T4 Lead Analyst and future T5 agents to `ctx_search` your findings
without re-reading the report file.

Do NOT index:
- Files containing credentials, API keys, or tokens
- Files from `.env`, `secrets/`, `~/.ssh`, `~/.aws`

### When to Use ctx_search

Use `ctx_search(query, limit=5)` instead of re-reading session files when:
- Looking for prior analysis findings from this session or previous sessions
- Checking whether a pattern was previously identified
- Retrieving prior T4 consolidated reports without loading the file

Example:
```
# Instead of Read(".claude/analysis/raw/A-501-context-mode.md") when searching for a specific finding:
ctx_search("credential redaction gap security finding", limit=5)
```

### Prohibited ctx_* Usage

- Never call `ctx_execute` with commands that read: `~/.ssh`, `~/.aws`, `~/.kube`, `./.env`, `./secrets`
- Never call `ctx_fetch_and_index` with localhost, 192.168.x.x, 10.x.x.x, or metadata endpoints
- Never index raw output that may contain secrets — redact first
- Rate limit: do not call `ctx_search` more than 10 times per second

### Tool Selection Quick Reference

| Situation | Tool |
|-----------|------|
| File <10KB, read once | Read |
| File >10KB, analysis only | ctx_execute_file |
| Shell command, short output (<5KB) | Bash |
| Shell command, large output (>5KB) | ctx_execute |
| Search prior session findings | ctx_search |
| Store report for reuse | ctx_index |
| Fetch external doc | ctx_fetch_and_index |
```

**Important:** The `## Prohibited Tools` table in `analyst.md` currently lists Bash as prohibited. This must be updated. T5 Analyst now has access to Bash **only for** context-mode guard-compliant short commands. The table entry for Bash should be changed from:

```
| Bash | T5 does not execute commands |
```

To:

```
| Bash | T5 uses Bash only for short commands (<5KB output). Large output commands must route to ctx_execute. See context-mode Tool Guidelines above. |
```

**Additionally**, update the `## Permitted Tools` table to add:

```
| MCP (ctx_*) | Use context-mode tools for analysis commands and knowledge retrieval |
```

---

### 6. Security Hardening Config

#### Immediate (P0 — in this integration sprint)

These are set via environment variables in `settings.json` env block (already included in Component 1):

| Variable | Value | Addresses |
|----------|-------|-----------|
| `CTX_FETCH_STRICT` | `"1"` | P0 SEC-005: GCP metadata endpoint exposure |
| `CTX_DENY_PATHS` | `"~/.ssh,~/.aws,~/.kube,~/.gnupg,./.env,./.env.*,./secrets"` | P1 SEC-002: Unrestricted file access (partial mitigation) |
| `CTX_DB_PATH` | `"./.claude/analysis/knowledge.db"` | SQLite project isolation |
| `CTX_OUTPUT_CAP` | `"102400000"` | Output cap at 100MB (already context-mode default) |
| `CTX_TIMEOUT_DEFAULT` | `"30000"` | 30-second execution timeout |
| `CTX_SEARCH_RATE_LIMIT` | `"10"` | P2 SEC-016: Query rate limiting |
| `CTX_DB_ENCRYPTION` | `"true"` | Intent flag for SQLCipher (deferred to TASK-003-F) |

#### Additional Warning Flags

The following env vars should be set in `.claude/settings.local.json` (machine-specific, not committed):

```json
{
  "env": {
    "CTX_AUDIT_LOG": "./.claude/analysis/session-audit.log",
    "CTX_SAFE_PATH_ONLY": "1"
  }
}
```

`CTX_AUDIT_LOG` enables context-mode's built-in audit logging if supported in the installed version.
`CTX_SAFE_PATH_ONLY` is a future-compatibility flag; set now for when TASK-003-C ships.

#### Database Permissions

After `npx context-mode init`, T3 must set:
```bash
chmod 700 ./.claude/analysis/
chmod 600 ./.claude/analysis/knowledge.db
```

This ensures the SQLite file is not world-readable, mitigating SEC-006 until SQLCipher ships.

#### Documentation Warning (add to `.claude/rules/context-mode-usage.md`)

Already included in Component 3 under `## Residual Risk Notice`.

#### Deferred Hardening (not in this sprint — assign to separate tasks)

| Task | Priority | What |
|------|----------|------|
| TASK-003-B | P0 | Entropy-based credential redaction in posttooluse hook |
| TASK-003-C | P1 | chroot/seccomp for shell execution |
| TASK-003-D | P1 | PATH whitelist |
| TASK-003-F | P1 | SQLCipher encryption at rest |
| TASK-003-E | P1 | Java/Gradle/Golang/Rust env var denylist |

**These tasks are NOT in T3's implementation scope for this sprint.** They require upstream changes to context-mode internals (Executor.ts, db-base.ts). This sprint covers only configuration and project-side integration.

---

### 7. Installation Steps

T3 must perform these steps in order after writing the files:

```
Step 1: Verify Node.js version
  node --version
  # Must be >= 22.5.0
  # If not: install Node 22 LTS from https://nodejs.org/en/download

Step 2: Install context-mode (project-local, pinned to current latest)
  cd /Users/tcvmaksutoglu/Dev/w/claude-code-saka
  npm install @context-mode/mcp@1.0.146
  # Pin to 1.0.146 (verified version per T5 analysis)
  # After install, verify: node_modules/@context-mode/mcp/package.json shows "version": "1.0.146"

Step 3: Create analysis directory (if not present)
  mkdir -p .claude/analysis
  # Note: .claude/analysis/ may already exist (T4/T5 write here)

Step 4: Initialize context-mode database
  CTX_DB_PATH=.claude/analysis/knowledge.db npx context-mode init
  # Expected output: "Database initialized at .claude/analysis/knowledge.db"

Step 5: Set database permissions
  chmod 700 .claude/analysis/
  chmod 600 .claude/analysis/knowledge.db

Step 6: Write all component files (in order per T3 Implementation Checklist below)

Step 7: Make guard hook executable
  chmod +x .claude/hooks/context-mode-guard.sh

Step 8: Verify installation
  npx context-mode doctor
  # Expected: all checks pass
  # If "Database not found": re-run Step 4

Step 9: Smoke test
  # Test ctx_index + ctx_search round-trip:
  node -e "
  const { Client } = require('@modelcontextprotocol/sdk/client/index.js');
  // If MCP client is available; otherwise test via Claude session:
  "
  # Simpler: open a Claude Code session and run:
  # ctx_index("test-doc", "# Test\nThis is a smoke test.", "prose")
  # ctx_search("smoke test")
  # Expected: returns the indexed chunk

Step 10: Verify hook fires
  # In a Claude Code session, run:
  # Bash("curl http://example.com")
  # Expected: context-mode-guard.sh blocks with "BLOCKED: 'curl' is an exfiltration-capable tool"
```

---

## T3 Implementation Checklist

T3 MidCoder (Taner Yilmaz) must complete all items in this order. Each item references the exact content in the Component Specifications above.

### Files to Create (new)

- [ ] **`.claude/hooks/context-mode-guard.sh`**
  - Content: Component 4 exactly
  - After writing: `chmod +x .claude/hooks/context-mode-guard.sh`
  - Verify: `bash -n .claude/hooks/context-mode-guard.sh` (syntax check, should produce no output)

- [ ] **`.claude/skills/context-mode/SKILL.md`**
  - Create directory: `mkdir -p .claude/skills/context-mode`
  - Content: Component 2 exactly
  - No executable permission needed

- [ ] **`.claude/rules/context-mode-usage.md`**
  - Content: Component 3 exactly
  - No executable permission needed

### Files to Modify (existing)

- [ ] **`.claude/settings.json`**
  - Replace entire file with the JSON in Component 1
  - Verify: `jq . .claude/settings.json` (must parse without error)
  - Critical: confirm all 11 existing PreToolUse:Edit hooks are still present
  - Critical: confirm `git-safety-check.sh` is still present in Bash matcher
  - Critical: confirm new `context-mode-guard.sh` is appended after `git-safety-check.sh` in Bash matcher

- [ ] **`.claude/agents/analyst.md`**
  - Insert the `## context-mode Tool Guidelines` section as specified in Component 5
    - Insert after `## Authority Limits` section (line ~47 in current file)
    - Insert before `## Skills to Load` section (line ~64 in current file)
  - Update `## Prohibited Tools` Bash row as specified in Component 5
  - Add MCP row to `## Permitted Tools` table as specified in Component 5

- [ ] **`.claude/config/hook-registry.md`**
  - Add new row to `## PreToolUse:Bash` table:
    ```
    | context-mode-guard.sh | Block exfiltration tools and large-output bash; redirect advisory to ctx_execute | context-mode-usage.md §Mandatory Routing Rules |
    ```
  - Update `## Total Hook Count: 16` to `## Total Hook Count: 17`
  - Update the count line: `11 PreToolUse:Edit/Write + 1 PreToolUse:Bash + 1 PreToolUse:Bash(ctx-guard) + 2 PostToolUse:Edit/Write + 2 SessionEnd = 17 hooks.`
    - Or more cleanly: `11 PreToolUse:Edit/Write + 2 PreToolUse:Bash + 2 PostToolUse:Edit/Write + 2 SessionEnd = 17 hooks.`

### Post-Write Steps

- [ ] Run installation steps 1–10 from Component 7 in order
- [ ] Verify `.claude/settings.json` parses: `jq . .claude/settings.json`
- [ ] Verify hook is executable: `test -x .claude/hooks/context-mode-guard.sh && echo OK`
- [ ] Verify skills directory: `ls .claude/skills/context-mode/SKILL.md`
- [ ] Verify rules file: `ls .claude/rules/context-mode-usage.md`
- [ ] Verify database exists: `ls -la .claude/analysis/knowledge.db`

### Self-Review Checklist (T3 must verify before marking complete)

- [ ] All 11 PreToolUse:Edit/Write hooks are still in settings.json (count them)
- [ ] git-safety-check.sh is present in Bash matcher before context-mode-guard.sh
- [ ] CTX_FETCH_STRICT=1 is set in settings.json env block
- [ ] CTX_DENY_PATHS is set in settings.json env block
- [ ] context-mode-guard.sh uses `exit 2` for blocks (not `exit 1`)
- [ ] context-mode-guard.sh uses `exit 0` for advisories (Block 3)
- [ ] analyst.md Prohibited Tools table updated (Bash row — not deleted, updated)
- [ ] analyst.md Permitted Tools table updated (MCP row added)
- [ ] hook-registry.md total count updated to 17
- [ ] No `console.log`, `any`, `@ts-ignore`, or inline comments in any written file
- [ ] `.claude/analysis/knowledge.db` permissions: `600`
- [ ] `.claude/analysis/` directory permissions: `700`

---

## Appendix: Hook Execution Order Reference

After integration, the full hook execution order is:

```
PreToolUse:Edit|Write|MultiEdit (11 hooks, unchanged):
  1. block-console-log.sh
  2. block-any-type.sh
  3. block-comments.sh
  4. secret-guard.sh
  5. analysis-scope-guard.sh
  6. figma-standards-guard.sh
  7. sql-injection-check.sh
  8. xss-prevention-check.sh
  9. path-traversal-check.sh
  10. field-injection-check.sh
  11. cors-wildcard-check.sh

PreToolUse:Bash (2 hooks; was 1):
  12. git-safety-check.sh
  13. context-mode-guard.sh  ← NEW

PostToolUse:Edit|Write|MultiEdit (2 hooks, unchanged):
  14. review-tracker.sh
  15. self-learning-collector.sh

SessionStart (1 hook; was 0):
  16. npx @context-mode/mcp hooks sessionstart  ← NEW

SessionEnd (2 hooks, unchanged):
  17. update-leaderboard.sh
  18. pattern-lifecycle.sh

Total: 18 hook invocations per session lifecycle (17 distinct scripts + 1 npx command)
```

**Note on SessionStart:** The SessionStart hook is invoked via `npx @context-mode/mcp hooks sessionstart` directly (not a custom .sh file). This is the context-mode-native approach. If context-mode changes its hook invocation API, update only the settings.json SessionStart entry.

---

## Appendix: Conflict Analysis Confirmation

| Existing Hook | context-mode Addition | Conflict? | Reason |
|---------------|----------------------|-----------|--------|
| block-console-log.sh (Edit|Write) | None at Edit|Write | None | Different matchers |
| git-safety-check.sh (Bash) | context-mode-guard.sh (Bash) | None | Sequential chain; git check fires first |
| review-tracker.sh (PostToolUse Edit|Write) | No PostToolUse:Edit hook added | None | context-mode PostToolUse is MCP-only |
| update-leaderboard.sh (SessionEnd) | SessionStart hook added | None | Different lifecycle events |
| pattern-lifecycle.sh (SessionEnd) | SessionStart hook added | None | Different lifecycle events |

No existing hook is modified. The integration is purely additive.
