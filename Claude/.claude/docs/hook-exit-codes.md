# Hook Exit Code Semantics

Referenced by hooks in `.claude/hooks/` and monitored by Claude Code harness.

## Exit Code Reference

| Exit Code | Meaning | Claude Code Action | When Used |
|-----------|---------|-------------------|-----------|
| `0` | PASS | Allow the tool call to proceed | Hook ran successfully; no violation detected |
| `1` | ERROR | Report hook error; tool call may proceed (non-blocking) | Hook script itself failed (missing dependency, parse error) |
| `2` | BLOCK | Block the tool call; show error message to agent | Violation detected; operation must not proceed |

## Semantics Detail

### Exit 0 — PASS

The hook completed without finding a violation. The pending tool call (Edit, Write, Bash, etc.) is allowed to proceed.

Used when:
- Content was scanned and no prohibited patterns found
- The file type is exempt (e.g., `.md`, `.sh`, `.json` for `block-console-log.sh`)
- No relevant content was provided in the tool input

### Exit 1 — ERROR

The hook script encountered an internal error (e.g., `jq` not found, invalid JSON input, required environment variable missing). This exit code signals a hook infrastructure problem, not a code violation. Claude Code treats this as non-blocking by default — the tool call proceeds, but the hook failure is reported.

Used when:
- `jq` parse fails on malformed input
- `CLAUDE_PROJECT_DIR` is not set (though most hooks use `set -euo pipefail` which triggers before exit 1)
- A dependency command is missing

> **Note**: Due to `set -euo pipefail` in most hooks, unhandled errors exit with code 1. Operators should check stderr output for the `BLOCKED:` prefix to distinguish code violations (exit 2) from hook errors (exit 1).

### Exit 2 — BLOCK

The hook detected a policy violation in the pending operation. Claude Code blocks the tool call and displays the hook's stderr output as an error message to the agent.

Used when:
- `console.log` or `console.*` statement detected in non-exempt file
- `any` TypeScript type detected
- SQL string concatenation detected
- Hardcoded secret or credential detected
- Prohibited git operation attempted without consent

## Per-Hook Exit Code Usage

| Hook | Exit 0 Condition | Exit 2 Condition |
|------|-----------------|-----------------|
| `block-console-log.sh` | File type exempt OR no `console.*` found | `console.*` or `alert/confirm/prompt` found |
| `block-any-type.sh` | No `: any` or `@ts-ignore` found | `: any` or `@ts-ignore` detected |
| `block-comments.sh` | No inline comments found | `//`, `/* */`, `TODO`, `FIXME` detected |
| `secret-guard.sh` | No credential patterns found | API key, password, token patterns detected |
| `sql-injection-check.sh` | No string concatenation in SQL | SQL built via string concat/format |
| `xss-prevention-check.sh` | No unsafe HTML patterns found | `innerHTML`, `dangerouslySetInnerHTML`, `eval` detected |
| `path-traversal-check.sh` | No unsanitized path operations | `..` in user-controlled path operations |
| `cors-wildcard-check.sh` | No `*` CORS origin | Wildcard origin configured |
| `field-injection-check.sh` | No `@Autowired` on fields | `@Autowired` field injection found |
| `figma-standards-guard.sh` | No hardcoded px/hex/inline styles | Design token violations found |
| `analysis-scope-guard.sh` | Within allowed scope | Write to `.claude/analysis/` root (T1-T3) |
| `git-safety-check.sh` | Safe read-only git op OR consent present | Destructive git op without explicit consent |
| `context-mode-guard.sh` | No denied paths or exfiltration tools | Access to `~/.ssh/`, `.env`, denied network targets |

### Non-Blocking Hooks (Always Exit 0)

The remaining 6 hooks fire on `PostToolUse:Edit/Write/MultiEdit` and `SessionEnd` events. They collect metrics, manage state, or update files. **None of them block tool calls — they always exit 0.** They may write `INFO:` or `WARN:` messages to stderr for diagnostic purposes but never use exit 2.

| Hook | Event | Effect |
|------|-------|--------|
| `review-tracker.sh` | PostToolUse:Edit/Write/MultiEdit | Increments edit counter; warns at 5 and 10 edits per file |
| `self-learning-collector.sh` | PostToolUse:Edit/Write/MultiEdit | Creates learned pattern file when same file edited 2+ times |
| `graphify-rebuild.sh` | PostToolUse:Edit/Write/MultiEdit | Writes `graphify-out/.graphify-stale` marker on source change |
| `update-leaderboard.sh` | SessionEnd | Applies score deltas; writes `.session-complete` sentinel |
| `pattern-lifecycle.sh` | SessionEnd | Processes pattern hits, promotions, and archival |
| `graphify-audit.sh` | SessionEnd | Warns if graphify graph is stale or >7 days old |

**Total**: 13 PreToolUse hooks (may block) + 6 PostToolUse/SessionEnd hooks (always pass) = 19 hooks documented.

## Stderr Output Format

When a hook exits 2, it writes a `BLOCKED:` prefixed message to stderr:

```
BLOCKED: console.* statements are prohibited in production code. Use a structured logging service instead.
```

When a hook exits 1 (error), it writes an `INFO:` or `ERROR:` prefixed message:

```
INFO: update-leaderboard.sh requires Bash 4+. macOS default is 3.2 — install via 'brew install bash'. Skipping leaderboard update.
```

## Adding a New Hook

When writing a new hook, follow this exit code contract:

```bash
#!/usr/bin/env bash
set -euo pipefail

: "${CLAUDE_PROJECT_DIR:?CLAUDE_PROJECT_DIR must be set}"

INPUT=$(cat)

CONTENT=$(...)

case "$FILE_PATH" in
  *.md|*.json|*.sh) exit 0 ;;
esac

if echo "$CONTENT" | grep -qE 'prohibited_pattern'; then
  echo "BLOCKED: Description of what was blocked and why." >&2
  exit 2
fi

exit 0
```

Key rules:
- Always exit 0 at the end (explicit PASS)
- Always exit 2 for violations (never exit 1 for policy blocks)
- Always write `BLOCKED:` prefix on stderr for exit 2
- Always write `INFO:` or `WARN:` prefix on stderr for informational messages

## Debugging Hook Failures

When a hook fires unexpectedly or a tool call is blocked, use this procedure:

1. **Identify the hook**: Claude Code reports the hook name in the error message when exit 2 fires.
2. **Read the stderr output**: Look for the `BLOCKED:` prefix to confirm the violation type.
3. **Distinguish error vs. block**: Exit 1 means the hook script itself failed (check `jq`, `awk`, env vars). Exit 2 means a policy violation was detected.
4. **Run the hook manually** to reproduce:
   ```bash
   echo '{"tool_name":"Edit","tool_input":{"file_path":"src/example.ts","new_string":"console.log(x)"}}' \
     | bash .claude/hooks/block-console-log.sh
   echo "Exit: $?"
   ```
5. **Check environment**: Ensure `CLAUDE_PROJECT_DIR` is set and the hook has execute permission (`chmod +x`).
6. **False positive**: If the hook blocked valid code, file an issue and check `.claude/config/hook-registry.md` for exempt patterns. Do not disable the hook without T1 Principal approval.

## References

- `.claude/config/hook-registry.md` — complete list of all 19 hooks
- `.claude/rules/backend-security.md` §Enforcement Hooks — security hook registry
- CLAUDE.md §Enforcement Layers — overall enforcement architecture
