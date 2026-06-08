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

## .gitignore Requirements

The following entry MUST be in `.gitignore` to prevent committing the SQLite knowledge base:

```
.claude/analysis/knowledge.db
.claude/analysis/knowledge.db-shm
.claude/analysis/knowledge.db-wal
```

The project `.gitignore` at the repo root already includes these entries.

## Residual Risk Notice

context-mode is a **context reduction tool, not a security sandbox**.
Subprocess execution via `ctx_execute` has access to:
- Project files (unless listed in CTX_DENY_PATHS)
- System PATH tools (mitigated by `context-mode-guard.sh` blocking exfiltration tools)

Deploy only on trusted local development machines. Never use on shared systems or cloud VMs
without completing the full hardening sprint (TASK-003-B through TASK-003-F).
