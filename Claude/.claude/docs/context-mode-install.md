# context-mode Installation Guide

**Version:** @context-mode/mcp@1.0.146
**Platform:** macOS Darwin (tested on Darwin 25.x)
**Prerequisite:** Node.js >= 22.5.0

---

## Step 1: Verify Node.js Version

```bash
node --version
```

Must be >= 22.5.0. If not, install Node 22 LTS from https://nodejs.org/en/download

---

## Step 2: Install context-mode (Project-Local, Pinned)

```bash
cd /Users/tcvmaksutoglu/Dev/w/claude-code-saka
npm install @context-mode/mcp@1.0.146
```

Verify after install:

```bash
node -e "const p = require('./node_modules/@context-mode/mcp/package.json'); console.log(p.version)"
```

Expected output: `1.0.146`

---

## Step 3: Create Analysis Directory

```bash
mkdir -p .claude/analysis
```

Note: `.claude/analysis/` may already exist if T4/T5 agents have written raw or consolidated reports. This step is idempotent.

---

## Step 4: Initialize context-mode Database

```bash
CTX_DB_PATH=.claude/analysis/knowledge.db npx context-mode init
```

Expected output: `Database initialized at .claude/analysis/knowledge.db`

If you see `Database already exists`, that is acceptable — skip re-initialization.

---

## Step 5: Set Database Permissions

```bash
chmod 700 .claude/analysis/
chmod 600 .claude/analysis/knowledge.db
```

This ensures the SQLite file is not world-readable. Full encryption at rest (SQLCipher) is deferred to TASK-003-F in the hardening sprint.

---

## Step 6: Write Component Files

Files are written by T3 MidCoder per the implementation checklist in `.claude/docs/context-mode-integration-design.md`. If performing a manual reinstall, the files that must exist are:

- `.claude/hooks/context-mode-guard.sh`
- `.claude/skills/context-mode/SKILL.md`
- `.claude/rules/context-mode-usage.md`
- `.claude/settings.json` (updated with MCP config and env vars)

---

## Step 7: Make Guard Hook Executable

```bash
chmod +x .claude/hooks/context-mode-guard.sh
```

Verify:

```bash
test -x .claude/hooks/context-mode-guard.sh && echo OK
```

---

## Step 8: Verify Installation

```bash
npx context-mode doctor
```

Expected: all checks pass.

If you see `Database not found`: re-run Step 4.

---

## Step 9: Smoke Test

Open a Claude Code session and run:

```
ctx_index("test-doc", "# Test\nThis is a smoke test.", "prose")
ctx_search("smoke test")
```

Expected: `ctx_search` returns the indexed chunk.

---

## Step 10: Verify Hook Fires

In a Claude Code session, run:

```
Bash("curl http://example.com")
```

Expected: `context-mode-guard.sh` blocks with:

```
[context-mode-guard] BLOCKED: 'curl' is an exfiltration-capable tool. Use 'ctx_execute' with explicit allow if network access is required for analysis.
```

---

## Hardening Environment Variables

All 8 variables are set in `.claude/settings.json` under the `env` block:

| Variable | Value | Purpose |
|----------|-------|---------|
| `CTX_DB_PATH` | `./.claude/analysis/knowledge.db` | Project-scoped SQLite isolation |
| `CTX_FETCH_STRICT` | `"1"` | Blocks localhost and private IP fetches (P0 SEC-005) |
| `CTX_MAX_CONCURRENCY` | `"4"` | Maximum parallel ctx_execute threads |
| `CTX_OUTPUT_CAP` | `"102400000"` | Output cap at 100MB |
| `CTX_TIMEOUT_DEFAULT` | `"30000"` | 30-second execution timeout per command |
| `CTX_DB_ENCRYPTION` | `"true"` | Intent flag for SQLCipher (active after TASK-003-F) |
| `CTX_SEARCH_RATE_LIMIT` | `"10"` | ctx_search queries per second per session |
| `CTX_DENY_PATHS` | `"~/.ssh,~/.aws,~/.kube,~/.gnupg,./.env,./.env.*,./secrets"` | Denied file access paths inside ctx_execute (P1 SEC-002 partial mitigation) |

All 8 variables are set together in `settings.json`.

### Optional Local-Only Variables

Set in `.claude/settings.local.json` (machine-specific, not committed to version control):

```json
{
  "env": {
    "CTX_AUDIT_LOG": "./.claude/analysis/session-audit.log",
    "CTX_SAFE_PATH_ONLY": "1"
  }
}
```

`CTX_AUDIT_LOG` enables context-mode's built-in audit logging if supported in the installed version.
`CTX_SAFE_PATH_ONLY` is a forward-compatibility flag for TASK-003-C.

---

## Troubleshooting (macOS Darwin)

### `npx: command not found`

Node.js is not on PATH. Add to `~/.zshrc`:

```bash
export PATH="/usr/local/bin:$PATH"
```

Then: `source ~/.zshrc && node --version`

### `context-mode: command not found` after npm install

Use the local binary path:

```bash
./node_modules/.bin/context-mode doctor
```

Or use npx to resolve locally:

```bash
npx --no context-mode doctor
```

### `Database initialization failed: SQLITE_CANTOPEN`

The `.claude/analysis/` directory does not exist or is not writable. Run:

```bash
mkdir -p .claude/analysis && chmod 755 .claude/analysis
CTX_DB_PATH=.claude/analysis/knowledge.db npx context-mode init
chmod 700 .claude/analysis/
chmod 600 .claude/analysis/knowledge.db
```

### `jq: command not found` (hook fallback active)

`context-mode-guard.sh` falls back to `grep/sed` for JSON parsing if `jq` is absent. This is functional but less precise. Install jq for reliable parsing:

```bash
brew install jq
```

### Hook does not fire on `Bash("curl ...")`

Verify `context-mode-guard.sh` is listed in `.claude/settings.json` under `PreToolUse` → `Bash` matcher after `git-safety-check.sh`:

```bash
jq '.hooks.PreToolUse[] | select(.matcher == "Bash") | .hooks[].command' .claude/settings.json
```

Expected: two entries — `git-safety-check.sh` and `context-mode-guard.sh`.

### `SessionStart hook` fails silently

Verify context-mode is installed and the hook command resolves:

```bash
npx @context-mode/mcp hooks sessionstart --help
```

If the subcommand does not exist in the installed version, remove the SessionStart entry from `settings.json` and file a bug against `@context-mode/mcp@1.0.146`.

---

## Deferred Hardening Tasks

The following are NOT part of this installation sprint. They require upstream changes to context-mode internals:

| Task | Priority | Description |
|------|----------|-------------|
| TASK-003-B | P0 | Entropy-based credential redaction in posttooluse hook |
| TASK-003-C | P1 | chroot/seccomp for shell execution |
| TASK-003-D | P1 | PATH whitelist |
| TASK-003-F | P1 | SQLCipher encryption at rest |
| TASK-003-E | P1 | Java/Gradle/Golang/Rust env var denylist |

WARNING: Until TASK-003-B through TASK-003-F are complete, context-mode is approved for use only on trusted local development machines. Never deploy on shared systems or cloud VMs.
