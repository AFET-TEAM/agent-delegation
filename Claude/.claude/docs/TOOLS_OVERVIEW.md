# Integration Tools — Quick Reference

Two tools integrated into this multi-agent system: **context-mode** (context window optimizer) and **graphify** (codebase knowledge graph).

## context-mode

**Purpose:** Prevents context window flooding. Tool outputs run in isolated subprocesses; only results enter context. Session state persists across compaction via SQLite + FTS5.

**Slash command:** `/ctx`

**When to use:**
- Analysis scripts that would dump >10KB into context
- Searching prior session findings after compaction
- Indexing T5 analysis reports for cross-session retrieval

**Core tools:**

| Tool | Use Case |
|------|----------|
| `ctx_execute(lang, code)` | Run analysis scripts; log only result |
| `ctx_execute_file(path, lang, code)` | Process large files without loading them |
| `ctx_batch_execute([...])` | Parallel analysis (up to 8 concurrent) |
| `ctx_index(source, content)` | Store findings in FTS5 knowledge base |
| `ctx_search(query)` | BM25-ranked search across indexed content |
| `ctx_fetch_and_index(url)` | Fetch + index web content |
| `ctx_stats` / `ctx_doctor` | Usage stats / health check |

**Installation:** See `.claude/docs/context-mode-install.md`

**Rules:** `.claude/rules/context-mode-usage.md`

**Token savings:** ~76% per x10 session (50K → 12K tokens estimated)

---

## graphify

**Purpose:** Transforms codebases into queryable knowledge graphs. Eliminates mass file-grepping for architectural questions.

**Slash command:** `/graphify`

**When to use:**
- Codebase scope > 20 files
- Unknown topology ("what depends on X?")
- God class / god node detection
- PR impact analysis

**Invocation modes:**

| Command | Use |
|---------|-----|
| `/graphify . --local-only` | Build graph (code processed locally, no API calls) |
| `/graphify query "auth module"` | Semantic search without rebuilding |
| `/graphify . --mode deep` | Aggressive relationship extraction |
| `/graphify . --watch` | Auto-sync as files change |

**Outputs:**
- `graphify-out/graph.json` — queryable graph (persistent across sessions)
- `graphify-out/GRAPH_REPORT.md` — god nodes + surprising connections
- `graphify-out/graph.html` — interactive visualization

**Installation:** See `.claude/docs/graphify-install.md`

**Rules:** `.claude/rules/graphify-usage.md`

**Token savings:** ~71.5x fewer tokens per query vs. raw file reading (benchmark)

---

## Using Both Together

context-mode and graphify complement each other:

1. Build graphify graph: `/graphify . --local-only`
2. Index the GRAPH_REPORT: `ctx_index("graph-report", content_of_GRAPH_REPORT.md)`
3. Query across sessions: `ctx_search("god nodes auth module")`
4. Run targeted analysis: `ctx_execute("js", "read specific file, log result")`

This pattern gives you **topology awareness** (graphify) + **context preservation** (context-mode) simultaneously.

---

## Stale Graph Protocol

When source files change, `.graphify-stale` marker appears in `graphify-out/`.

```bash
ls graphify-out/.graphify-stale 2>/dev/null && echo "STALE" || echo "FRESH"
```

If STALE: run `/graphify . --local-only` to rebuild before querying.

---

## Security Notes

- **context-mode**: Process-level isolation only — not a security sandbox. Use `--local-only` equivalent (`CTX_FETCH_STRICT=1` is set). Never `ctx_execute` on credential-adjacent commands.
- **graphify**: ALWAYS use `--local-only`. Without it, file content may be sent to external LLM APIs.
- **PyPI package name**: Install via `uv tool install "graphifyy[all]"` (double-y). Verify: `pip show graphifyy`.
