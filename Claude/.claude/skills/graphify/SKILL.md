---
name: graphify
description: Build and query knowledge graphs from codebases. Scoped to T4/T5 analysis tiers. Use for codebases >20 files or when codebase topology is unknown.
---

# /graphify Skill

## Purpose

graphify converts a directory of source files into a queryable knowledge graph using
tree-sitter AST (code, no API calls) and optionally Claude vision API (docs/images).
It outputs graph.json, GRAPH_REPORT.md, and graph.html.

T4/T5 agents use this skill to avoid reading 50+ individual files. A graph query
returns relevant context in ~500 tokens vs ~25,000 tokens for raw file reads.

## Slash Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `/graphify` | `/graphify .` | Build graph for current directory (code-only, local) |
| `/graphify` | `/graphify . --local-only` | Explicitly restrict to code files; skip doc/image API calls |
| `/graphify` | `/graphify . --watch` | Auto-rebuild on file changes (code-only, zero token cost) |
| `/graphify query` | `/graphify query "god_nodes"` | Query existing graph |
| `/graphify query` | `/graphify query "surprising_connections"` | Find non-obvious relationships |
| `/graphify --mode deep` | `/graphify . --mode deep` | Include docs and images (sends non-code files to Claude API) |

## Activation Decision Table

| Condition | Action |
|-----------|--------|
| Codebase has >20 files to analyze | Run `/graphify . --local-only` before reading any files |
| graph.json exists AND `.graphify-stale` does NOT exist | Use existing graph; skip rebuild |
| graph.json exists AND `.graphify-stale` exists | Rebuild with `/graphify .` then delete `.graphify-stale` |
| graph.json does NOT exist | Build with `/graphify . --local-only` |
| Task involves docs, PDFs, or images | Run `/graphify . --mode deep` (API calls will be made for non-code files) |
| Codebase has <=20 files | Skip graphify; read files directly |

## Step-by-Step Execution (T5 Usage)

1. Check for `.graphify-stale` marker: `ls graphify-out/.graphify-stale 2>/dev/null`
2. Check for existing graph: `ls graphify-out/graph.json 2>/dev/null`
3. If stale or missing: run `graphify . --local-only` in the codebase root
4. Read `graphify-out/GRAPH_REPORT.md` for the summary (god nodes, surprising connections)
5. Query graph.json for specific context instead of opening individual files
6. If MCP server is running: use MCP tools (query_graph, god_nodes, get_neighbors)

## Output Artifacts

| File | Location | Description |
|------|----------|-------------|
| `graph.json` | `graphify-out/graph.json` | Primary queryable graph (nodes, edges, communities) |
| `GRAPH_REPORT.md` | `graphify-out/GRAPH_REPORT.md` | Human-readable: god nodes, surprising connections, gaps |
| `graph.html` | `graphify-out/graph.html` | Interactive browser visualization |

## MCP Tools (when server running)

Start MCP server: `graphify --mcp`

Available tools via MCP:
- `query_graph(query: str)` — Execute graph query ("god_nodes", "surprising_connections")
- `get_node(name: str)` — Retrieve node details and metadata
- `get_neighbors(node: str)` — Find directly connected nodes
- `shortest_path(source: str, target: str)` — Calculate coupling risk between modules
- `graph_stats()` — Retrieve graph metadata (node count, edge count, communities)
- `god_nodes()` — Identify most connected modules (architectural hubs)
- `cluster_cohesion()` — Measure module cohesion (SRP violation detection)
- `graph_diff(before: str, after: str)` — Track architectural changes across snapshots

## Integration with T5/T4 Analysis Workflow

**T5 Analyst**: Use graphify as the first step for any codebase analysis task with >20 files.
Replace "read all relevant files" with:
1. Build graph (one-time per session)
2. Read GRAPH_REPORT.md for topology summary
3. Query specific nodes/edges for findings
4. Open individual files only for line-level evidence

**T4 Lead Analyst**: Use god_nodes() output to focus consolidation.
- Top 5 god nodes = critical files requiring deeper review
- surprising_connections() = candidates for architectural findings
- Cross-reference T5 findings against graph community boundaries

## Security Disclaimer

IMPORTANT — READ BEFORE USE:

- Code files (*.py, *.ts, *.java, etc.) are parsed locally via tree-sitter. No code is sent to external APIs.
- Documents (*.md, *.pdf), images (*.png, *.jpg), and papers ARE sent to Claude APIs for semantic extraction.
- Default flag `--local-only` restricts processing to code files only. No API calls are made.
- Do NOT use `/graphify . --mode deep` on repositories containing confidential documents.
- API key for Claude must be set via environment variable ANTHROPIC_API_KEY. Never hardcode it.
- Cache directory `graphify-out/` must have permissions 0700 (owner-only) to prevent cache poisoning.

## Known Issues

| Issue | Severity | Workaround |
|-------|----------|------------|
| BrokenProcessPool on clustering (Issue #943) | Medium | Re-run with `--local-only`; fallback to non-clustered graph |
| PyPI package name `graphifyy` (double-y) vs `graphify` (repo name) | Medium | Always install as `pip install graphifyy`; verify with `pip show graphifyy` |
| Cache files have no HMAC signature | Medium | Restrict `graphify-out/` to `chmod 0700`; validate graph.json before use |

## References

- Repository: https://github.com/safishamsi/graphify
- PyPI: https://pypi.org/project/graphifyy/
- Analysis: `.claude/analysis/consolidated/C-T4B-graphify.md`
