# graphify Usage Rules

paths:
  - ".claude/agents/analyst.md"
  - ".claude/agents/lead-analyst.md"
  - ".claude/analysis/raw/**"
  - ".claude/analysis/consolidated/**"

## When T5 Analysts SHOULD Use graphify

| Condition | Use graphify? | Reason |
|-----------|--------------|--------|
| Codebase has >20 files in analysis scope | YES — mandatory | Token savings justify build time |
| Unknown codebase (first session) | YES — mandatory | Build graph before any exploration |
| Task asks "what depends on X?" | YES | get_neighbors() answers directly |
| Task asks "what are the god classes?" | YES | god_nodes() answers directly |
| Task asks "what modules are related?" | YES | surprising_connections() answers directly |
| Codebase has <=20 files | NO | Direct file reading is cheaper |
| Only 1-2 specific files need reading | NO | graph overhead exceeds savings |
| Repeated task on same session's graph | REUSE — no rebuild | graph.json persists in graphify-out/ |

## Threshold Rule

**Files > 20 in analysis scope → use graphify first, always.**

Justification: graphify build cost (~500 tokens for code graph) pays back within the first 3 queries.
For scopes <=20 files, direct Read tool is cheaper.

## Stale Marker Protocol

Before using graph.json, T5 agents MUST check for `.graphify-stale`:

```bash
ls graphify-out/.graphify-stale 2>/dev/null && echo "STALE" || echo "FRESH"
```

If STALE:
1. Rebuild: `graphify . --local-only`
2. Delete marker: `rm graphify-out/.graphify-stale`
3. Proceed with fresh graph

If FRESH:
1. Use graph.json directly — no rebuild needed

## Querying graph.json Programmatically

graph.json structure:
```json
{
  "nodes": [{"id": "ClassName", "type": "class", "degree": 12, "community": 3}],
  "edges": [{"source": "A", "target": "B", "type": "calls", "weight": 1.0}],
  "communities": [{"id": 1, "nodes": ["A", "B"], "cohesion": 0.8}],
  "metadata": {"god_nodes": ["ServiceX"], "surprising_connections": []}
}
```

Useful jq queries:
```bash
# Get top god nodes (highest degree)
jq '.nodes | sort_by(-.degree) | .[0:5] | .[] | .id' graphify-out/graph.json

# Get all nodes in a community
jq '.communities[] | select(.id == 1) | .nodes' graphify-out/graph.json

# Find all edges from a specific node
jq '.edges[] | select(.source == "UserService")' graphify-out/graph.json

# Count nodes by type
jq '.nodes | group_by(.type) | map({type: .[0].type, count: length})' graphify-out/graph.json
```

## god_nodes Analysis → God Class Code Smell Detection

god_nodes in graphify = top-degree nodes (most incoming + outgoing connections).

Mapping to our code smells (`.claude/rules/clean-code.md`):

| graphify Metric | Code Smell | Clean Code Violation |
|-----------------|------------|---------------------|
| degree > 20 | God Class | "Class doing too much" |
| degree > 10 AND type=function | Long Method / Feature Envy | "Function uses another class's data more than its own" |
| community size > 15 | Shotgun Surgery | "One change requires editing many classes" |
| cohesion_score < 0.4 | Divergent Change | "One class changed for multiple reasons" |
| surprising_connections with distance > 3 | Feature Envy | "Method uses another class's data more than its own" |

When a god node is identified:
1. Report it as a potential God Class finding (`.claude/rules/clean-code.md` Code Smell Catalog)
2. Set confidence = High if degree > 20, Medium if degree 10–20
3. Include degree count and top connected nodes as evidence

## Token Budget Guidance

| Operation | Estimated Token Cost | Use When |
|-----------|---------------------|----------|
| Build graph (code-only) | ~500 tokens | First time, or after stale marker |
| Read GRAPH_REPORT.md | ~300 tokens | Always after build |
| query_graph("god_nodes") | ~200 tokens | Any architectural question |
| get_neighbors("NodeName") | ~100 tokens | Dependency investigation |
| Read raw file (~300 lines) | ~2,000 tokens | Only for line-level evidence |
| Read 10 raw files | ~20,000 tokens | Avoid; use graphify queries instead |

**Rule**: If graphify can answer the question, do not read raw files. Only open a raw file when you need exact line numbers for a finding citation.

## Caching Protocol

graph.json persists across sessions in `graphify-out/` within the analyzed codebase directory.

**Cache reuse rules**:
1. If graph.json exists and `.graphify-stale` is absent: REUSE. Zero rebuild cost.
2. If graph.json exists and `.graphify-stale` is present: REBUILD. Cost: ~500 tokens.
3. If graph.json does not exist: BUILD. Cost: ~500 tokens (code-only).

**Cross-session reuse**: T5 agents in Session N+1 benefit from Session N's graph if the codebase has not changed significantly. The stale marker mechanism (managed by graphify-rebuild.sh hook) ensures consistency.

**Graph versioning**: For long-term drift detection, T4 agents may export named snapshots:
```bash
graphify export --format json --output graphify-out/graph-$(date +%Y%m%d).json
```
Store these in `.claude/memory/graphs/` for cross-session comparison.

## Security Constraints

- ALWAYS use `--local-only` unless the task explicitly requires document/image semantic extraction
- NEVER run graphify on directories containing `.env`, credentials, or private keys
- ALWAYS verify `chmod 0700 graphify-out/` before trusting cache
- NEVER pass user-controlled strings as graph query arguments without sanitization
- API key must come from environment: `export ANTHROPIC_API_KEY=...` (set by user, never by agents)

## .gitignore Requirements

The following entries MUST be in `.gitignore` to prevent committing generated artifacts:

```
graphify-out/
.graphify-stale
```

These are auto-generated and may be large (graph.json can reach several MB on large codebases). The project `.gitignore` at the repo root already includes these entries.
