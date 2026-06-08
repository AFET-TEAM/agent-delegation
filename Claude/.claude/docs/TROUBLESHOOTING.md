# Troubleshooting Guide

Common issues encountered when setting up or running the Claude Code Multi-Agent System.

---

## Setup Issues

### Issue: `Node.js not found` or `Node.js v18+ required`

**Cause**: Node.js is not installed or the installed version is below v18.

**Fix**:
1. Check current version: `node --version`
2. If missing or below v18, install from https://nodejs.org or via a version manager:
   ```bash
   nvm install 18
   nvm use 18
   ```
3. Re-run setup: `bash .claude/scripts/setup.sh`

---

### Issue: `Python 3.10+ not found — graphify will not be available`

**Cause**: Python is not installed, or the installed version is below 3.10. This is a warning, not a failure — graphify is optional.

**Fix (if graphify is needed)**:
1. Check: `python3 --version`
2. Install Python 3.10+: https://python.org or via `pyenv`:
   ```bash
   pyenv install 3.11
   pyenv global 3.11
   ```
3. Re-run setup to install graphify.

**If graphify is not needed**: Ignore the warning. All other features work without Python.

---

### Issue: `graphify installed but not in PATH`

**Cause**: Python's user-level `bin/` directory is not in `$PATH`. Common on macOS and some Linux distributions.

**Fix**:
```bash
# macOS with uv
export PATH="$HOME/.local/bin:$PATH"

# macOS with Homebrew Python
export PATH="/opt/homebrew/bin:$PATH"

# Add permanently to shell profile:
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Verify: `graphify --version`

---

### Issue: `jq: command not found`

**Cause**: `jq` is not installed. Hooks use grep fallback but prefer jq for JSON parsing.

**Fix**:
```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# Alpine
apk add jq
```

**Impact without jq**: Hooks fall back to grep-based JSON parsing. All features still work, but hook validation may be slightly less precise.

---

### Issue: `flock: command not found`

**Cause**: `flock` is not available. This is expected on macOS where it ships without `flock`.

**Fix (macOS)**:
```bash
brew install util-linux
```

**Impact without flock**: The leaderboard update script (`update-leaderboard.sh`) uses a `mkdir`-based lock fallback. This is safe under normal usage but less robust under concurrent session-end events (rare).

---

## Bash Version Issues

### Issue: Leaderboard scores never change, stuck at 0

**Cause**: `update-leaderboard.sh` requires Bash 4+ for associative arrays. macOS ships with Bash 3.2. The script detects this and exits with an INFO message rather than failing — so scores are silently skipped.

**Diagnosis**:
```bash
bash --version   # Should show 5.x or 4.x
```

**Fix (macOS)**:
```bash
brew install bash
```

After installation, verify:
```bash
/opt/homebrew/bin/bash --version   # Should show 5.x
```

**Impact without Bash 4+**: All features work normally except leaderboard score accumulation. Sessions complete successfully, session files are created, and patterns are processed. Only the score column in `.claude/metrics/leaderboard.md` remains at 0.

---

### Issue: `update-leaderboard.sh requires Bash 4+` in session end output

**Cause**: Same as above — Bash 3.2 on macOS.

**Expected message** (this is normal on macOS without Homebrew bash):
```
INFO: update-leaderboard.sh requires Bash 4+. macOS default is 3.2 — install via 'brew install bash'. Skipping leaderboard update.
```

**Action**: See the Bash 4+ fix above if leaderboard tracking is needed.

---

## Hook Failures

### Issue: Hook blocks code I believe is valid

**Cause**: A pre-tool hook detected a pattern it considers a violation.

**Diagnosis**: The error message includes:
1. The `BLOCKED:` prefix
2. Which pattern was detected
3. Why it is prohibited

Example:
```
BLOCKED: console.* statements are prohibited in production code. Use a structured logging service instead.
```

**Fix**:
1. Read the specific error message to understand what was detected
2. Replace the prohibited pattern:
   - `console.log` → use a structured logger (e.g., `logger.info(...)`)
   - `: any` type → use a specific type or `unknown`
   - SQL concatenation → use parameterized queries
3. Retry the edit

**If the block is a false positive** (e.g., a test file or documentation):
- Some hooks check file extensions. `.md`, `.sh`, `.json` files are typically exempt from TypeScript-specific hooks
- If the hook does not exempt your file type, raise this as a false positive by noting the finding in your session report

---

### Issue: Hook fires but no clear error message appears

**Cause**: The hook may have exited with code 1 (infrastructure error) rather than code 2 (block). Code 1 is non-blocking — it means the hook script itself failed, not that your code violated a rule.

**Diagnosis**:
```bash
# Check if the hook file exists and is executable
ls -la .claude/hooks/
```

**Fix**:
1. Verify the hook file exists: `ls .claude/hooks/{hook-name}.sh`
2. Verify it is executable: `chmod +x .claude/hooks/{hook-name}.sh`
3. Run the hook manually to see its output:
   ```bash
   echo '{"tool_input":{"file_path":"test.ts","new_string":"test"}}' | bash .claude/hooks/block-console-log.sh
   ```

For full exit code semantics, see `.claude/docs/hook-exit-codes.md`.

---

## Agent Escalation Issues

### Issue: T3 agent fails twice and escalation does not occur

**Cause**: Escalation is triggered automatically after 2 revision rounds (revision_attempts = 2). If the Orchestrator is not tracking `revision_attempts` correctly, it may not escalate.

**Symptoms**: Same task assigned to T3 three or more times with the same errors.

**Fix**: If you observe this in session output, report it to the Orchestrator explicitly:
```
Bu T3 görevi 2 kez başarısız oldu. T2'ye escalate et.
```

The Orchestrator should then spawn T2 with the full escalation seed (previous output + all review findings).

---

### Issue: Review chain produces conflicting findings

**Cause**: T2 and T1 reviewers may disagree on approach. This is expected for complex architectural changes.

**Fix**: The T1 Principal's review takes precedence. If T1 approves and T2 flagged an issue, the T1 finding wins. If T1 rejects what T2 approved, T2's output is sent back for revision.

---

## Active Plan Issues

### Issue: `active-plan.md` appears corrupted or references completed tasks

**Cause**: The session ended unexpectedly before the Orchestrator could mark tasks complete and update the plan.

**Fix**:
```bash
# Option 1: Reset the plan (Orchestrator creates fresh on next session)
rm .claude/todo/active-plan.md

# Option 2: Manually review and fix the plan
cat .claude/todo/active-plan.md
# Edit the file to correct task statuses
```

After deletion, start a new session — the Orchestrator will detect no active plan and treat the task as fresh.

---

## graphify Issues

### Issue: `graphify-out/.graphify-stale` never cleared

**Cause**: The `graphify-rebuild.sh` hook marks the graph stale when source files change. If graphify is not rebuilt, the stale marker persists indefinitely.

**Symptoms**: T5 agents see `STALE` when checking for the marker, rebuild the graph on every query.

**Fix**:
```bash
# Manually rebuild the graph
graphify . --local-only

# Clear the stale marker
rm graphify-out/.graphify-stale
```

---

### Issue: `graphify` command not found after `uv tool install`

**Cause**: `uv` installs tools into `~/.local/bin` which may not be in `$PATH`.

**Fix**:
```bash
export PATH="$HOME/.local/bin:$PATH"
# Or use the full path:
~/.local/bin/graphify --version
```

---

## Pattern Lifecycle Issues

### Issue: Pattern hit-count never increments

**Cause**: `pattern-lifecycle.sh` did not run, or did not match the session content against pattern keywords.

**Diagnosis**:
1. Check that `pattern-lifecycle.sh` is wired in `.claude/settings.json` as a SessionEnd hook
2. Check that `.claude/metrics/.session-complete` sentinel is created at session end
3. Check that pattern files use `## Error` (English) or `## Hata` (Turkish) as the section header

```bash
# Check sentinel creation
ls .claude/metrics/.session-complete

# Check pattern file headers
head -20 .claude/memory/learned-patterns/*.md
```

**Fix**: If `pattern-lifecycle.sh` is missing from settings.json, use the `update-config` skill to add it as a SessionEnd hook.

---

### Issue: Pattern promotion creates duplicate entries in `learned-*.md`

**Cause**: The promotion marker comment (`<!-- pattern: LP-xxx -->`) was not found, so the script promoted the same pattern twice.

**Fix**: Check the `learned-{category}.md` file for duplicate blocks and remove extras manually. The marker comment on the first promotion should prevent recurrence.

---

## Performance Issues

### Issue: x10 session timing out or taking 40+ minutes

**Cause**: Very large codebases combined with x10 mode can push individual agent token budgets to their limits.

**Fix options**:
1. Reduce scope: Instead of "audit all code", try "audit only the auth module"
2. Use x5 instead of x10: Two fewer T2+T3 pairs reduces total execution time
3. Pre-build the graphify graph in a separate step so T5 agents skip the build time:
   ```bash
   graphify . --local-only
   ```
   Then run your x10 session — T5 agents will reuse the existing graph.

---

### Issue: Token budget exceeded warning during session

**Cause**: An individual agent's task exceeded the per-tier token ceiling defined in `context-budget.json`.

**Expected behavior**: The Orchestrator should have split the task. If it did not, the overflow protocol applies — escalate to the next tier up.

**Fix**: If you see this mid-session, tell the Orchestrator:
```
Bu görev token limitini aşıyor. Görevi ikiye böl.
```

---

## Common Error Messages Reference

| Message | Meaning | Action |
|---------|---------|--------|
| `BLOCKED: console.* statements are prohibited` | console.log in production code | Use structured logger |
| `BLOCKED: TypeScript any type detected` | `: any` or `@ts-ignore` found | Use specific types |
| `BLOCKED: SQL string concatenation detected` | SQL built with string concat | Use parameterized queries |
| `BLOCKED: Potential hardcoded secret detected` | API key or credential in code | Use environment variables |
| `INFO: update-leaderboard.sh requires Bash 4+` | macOS Bash 3.2 detected | `brew install bash` |
| `WARNING: graphify graph is STALE` | Source files changed since last build | `graphify . --local-only` |

---

For architecture and design context, see `.claude/docs/ARCHITECTURE.md`.
For frequently asked questions, see `.claude/docs/FAQ.md`.
