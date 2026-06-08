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
| `ctx_upgrade()` | Upgrade context-mode to latest version | ~50 tokens |
| `ctx_purge()` | Clear all indexed data from knowledge base | ~50 tokens |
| `ctx_insight()` | AI-powered analysis of indexed knowledge | ~200 tokens |

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
