# graphify Integration Design

**Author**: Tarik Ziya Yesilcimen (T2 Staff Engineer)
**Date**: 2026-05-20
**Session**: 2026-05-20-context-graphify-x10
**Status**: Ready for T3 Implementation

---

## ADR-002: graphify Knowledge Graph Integration

### Status

Accepted

### Context

Our multi-agent system (Claude Code v1.0.0) uses T5 Analysts and T4 Lead Analysts to explore large codebases before coding agents act. Currently these agents read individual files one-by-one, consuming 25,000–60,000 tokens per session to understand structure. T4/T5 report A-502 and C-T4B establish:

- graphify (PyPI: `graphifyy`) builds queryable knowledge graphs via tree-sitter AST (code, local) and Claude vision API (docs/images, remote)
- Token reduction: 71.5x on 52-file benchmark; conservative 20–30% per full session
- MCP server mode enables programmatic tool access compatible with our settings.json infrastructure
- Three critical security issues require local mitigations before production use (S-001 transparency, S-002 naming, S-003 cache integrity)
- T4 consolidation: **CONDITIONAL GO** — safe for trusted internal environments with documented mitigations

### Decision

Integrate graphify as a T4/T5 analysis accelerator with:
1. A slash command skill (`/graphify`) scoped to analysis tiers
2. A usage rules file governing when and how agents invoke it
3. A stale-marker hook (not auto-rebuild) on source file edits
4. Protocol additions to T5 Analyst and T4 Lead Analyst agent templates
5. MCP tool registration in settings.json for agents that have MCP server running
6. Security mitigations applied locally pending upstream fixes for S-001/S-002/S-003

### Rationale

- MCP tools (query_graph, god_nodes, get_neighbors, shortest_path) align exactly with our agent tier architecture
- Persistent graph.json survives session-to-session, compounding savings as cache warms
- Break-even at ~20 sessions (~1–2 weeks at normal velocity)
- All three CRITICAL security issues are mitigated by local controls without upstream patches
- Integration cost: 6–8 hours engineering time; T3 implements from this spec

### Consequences

**Positive**:
- T5 agents can query codebase structure without reading 50+ files
- T4 agents can run god_nodes() and cluster_cohesion() for architectural consolidation
- Token cost drops ~20–30% per multi-agent session immediately
- graph.json persists as living documentation of codebase topology

**Negative**:
- Adds Python toolchain dependency (graphifyy, uv/pipx)
- MCP server must be started manually per codebase (no auto-start)
- Upstream S-001/S-002/S-003 require monitoring until patched
- Clustering failures (Issue #943) require graceful fallback documentation

**Neutral**:
- No conflict with existing .claude/hooks/ (different namespaces)
- No dependency conflicts with our current tool set

### Affected Files

| File | Action |
|------|--------|
| `.claude/skills/graphify/SKILL.md` | Create |
| `.claude/rules/graphify-usage.md` | Create |
| `.claude/hooks/graphify-rebuild.sh` | Create |
| `.claude/agents/analyst.md` | Modify (append section) |
| `.claude/agents/lead-analyst.md` | Modify (append section) |
| `.claude/settings.json` | Modify (add MCP config + SessionEnd hook) |
| `.claude/memory/graphs/.gitkeep` | Create (directory placeholder) |
| `.claude/config/task-assignment-matrix.md` | Modify (add codebase query rows) |

---

## Component Specifications

### 1. skills/graphify/SKILL.md Content

T3 must create this file at `.claude/skills/graphify/SKILL.md` with the following exact content:

```markdown
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
```

---

### 2. rules/graphify-usage.md Content

T3 must create this file at `.claude/rules/graphify-usage.md` with the following exact content:

```markdown
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
```

---

### 3. hooks/graphify-rebuild.sh Content

T3 must create this file at `.claude/hooks/graphify-rebuild.sh` with the following exact content:

```bash
#!/usr/bin/env bash
set -euo pipefail

: "${CLAUDE_PROJECT_DIR:?CLAUDE_PROJECT_DIR must be set}"

INPUT=$(cat)

if command -v jq >/dev/null 2>&1; then
  FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null || true)
else
  FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  if [ -z "$FILE_PATH" ]; then
    FILE_PATH=$(echo "$INPUT" | grep -o '"path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  fi
fi

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

case "$FILE_PATH" in
  */.claude/*)
    exit 0
    ;;
  */graphify-out/*)
    exit 0
    ;;
  *.md|*.json)
    exit 0
    ;;
esac

case "$FILE_PATH" in
  *.py|*.ts|*.tsx|*.js|*.jsx|*.java|*.kt|*.go|*.rs|*.rb|*.cs|*.cpp|*.c|*.h|*.scala|*.php)
    ;;
  *)
    exit 0
    ;;
esac

CODEBASE_ROOT=$(dirname "$FILE_PATH")

GRAPHIFY_OUT=""
SEARCH_DIR="$CODEBASE_ROOT"
for i in $(seq 1 5); do
  if [ -d "$SEARCH_DIR/graphify-out" ]; then
    GRAPHIFY_OUT="$SEARCH_DIR/graphify-out"
    break
  fi
  PARENT=$(dirname "$SEARCH_DIR")
  if [ "$PARENT" = "$SEARCH_DIR" ]; then
    break
  fi
  SEARCH_DIR="$PARENT"
done

if [ -n "$GRAPHIFY_OUT" ] && [ -f "$GRAPHIFY_OUT/graph.json" ]; then
  touch "$GRAPHIFY_OUT/.graphify-stale"
fi

exit 0
```

T3 must also make this hook executable: `chmod +x .claude/hooks/graphify-rebuild.sh`

**Hook behavior explanation**:
- Triggers on PostToolUse:Edit or Write
- Ignores .claude/ files, graphify-out/ files, and non-source files
- Source files: .py, .ts, .tsx, .js, .jsx, .java, .kt, .go, .rs, .rb, .cs, .cpp, .c, .h, .scala, .php
- Walks up to 5 directory levels to find the nearest graphify-out/ directory
- If graph.json exists, writes `.graphify-stale` marker
- Does NOT rebuild the graph (too slow for every edit — agents check staleness on their own)
- Exit 0 always (warning, not blocking)

---

### 4. agents/analyst.md Additions

T3 must append the following section to `.claude/agents/analyst.md`, after the last `---` line:

```markdown
---

## graphify Usage Protocol

### Session Start Check

Before beginning analysis on any codebase with more than 20 files:

1. Check if graph is stale: `ls graphify-out/.graphify-stale 2>/dev/null`
2. Check if graph exists: `ls graphify-out/graph.json 2>/dev/null`
3. Apply decision:

| State | Action |
|-------|--------|
| graph.json exists, no `.graphify-stale` | REUSE graph; skip rebuild |
| graph.json exists, `.graphify-stale` present | REBUILD: `graphify . --local-only`, then `rm graphify-out/.graphify-stale` |
| graph.json missing | BUILD: `graphify . --local-only` |
| Codebase has <=20 files | SKIP graphify; use Read tool directly |

### Standard Analysis Workflow with graphify

For codebases >20 files:

1. **Build/load graph**: Per decision table above
2. **Read GRAPH_REPORT.md**: `graphify-out/GRAPH_REPORT.md` for topology summary (~300 tokens)
3. **Identify god nodes**: Top 5 degree nodes = highest-risk classes/modules
4. **Run targeted queries** instead of opening raw files:
   - "What modules depend on X?" → `get_neighbors("X")`
   - "What are the architectural hubs?" → `god_nodes()`
   - "Are there unexpected couplings?" → `surprising_connections()`
5. **Open raw files only** for line-level evidence required by finding citations

### Interpreting GRAPH_REPORT.md for Code Quality

| Report Section | Code Smell Mapping | Confidence |
|---------------|--------------------|------------|
| god_nodes (degree > 20) | God Class | High |
| god_nodes (degree 10–20) | God Class (potential) | Medium |
| surprising_connections | Feature Envy or Shotgun Surgery | Medium |
| community cohesion < 0.4 | Divergent Change (SRP violation) | Medium |
| community size > 15 | Shotgun Surgery | Medium |

### Token Budget: graphify vs Direct Read

Use graphify when:
- Answering structural questions (dependencies, topology, coupling)
- Scoping an unknown codebase
- Finding code smell patterns at the architectural level

Use direct Read when:
- Citing a specific line number as evidence
- Verifying a single implementation detail
- The total scope is <=5 files

### MCP Tools (when graphify --mcp server is running)

If the MCP server is available, prefer these over CLI commands:

| Tool | Usage | When to Use |
|------|-------|-------------|
| `query_graph("god_nodes")` | Returns top-degree nodes | Any architectural question |
| `query_graph("surprising_connections")` | Returns non-obvious relationships | Coupling analysis |
| `get_node("ClassName")` | Returns node metadata | Node-specific analysis |
| `get_neighbors("ModuleName")` | Returns connected nodes | Dependency mapping |
| `shortest_path("A", "B")` | Returns connection path | Coupling risk assessment |
| `graph_stats()` | Returns graph metadata | Session context |

### Security: Code-Only Mode Default

ALWAYS use `--local-only` unless the task explicitly involves analyzing documents, PDFs, or images.

`--local-only` ensures:
- Zero API calls for source code files
- Tree-sitter parses code locally (deterministic, no network)
- Docs/images are NOT sent to Claude APIs

Only use `--mode deep` when the task description explicitly requires PDF or image analysis.
```

---

### 5. agents/lead-analyst.md Additions

T3 must append the following section to `.claude/agents/lead-analyst.md`, after the last `---` line:

```markdown
---

## graphify Consolidation Protocol

### Using Graph Data for T5 Output Consolidation

When consolidating T5 Analyst outputs, use graphify graph data to:

1. **Verify architectural findings**: Cross-reference T5's "god class" claims against god_nodes() output
2. **Identify analysis gaps**: T5 may have missed high-degree nodes not in their scope
3. **Assess blast radius**: Use get_neighbors() to confirm impact scope of reported issues
4. **Detect community boundary violations**: Compare T5's module findings against cluster communities

### Graph-Based Consolidation Workflow

If a graph.json exists in the analyzed codebase:

1. Read `graphify-out/GRAPH_REPORT.md` for topology summary
2. Extract top 5 god nodes → these are mandatory review targets for T5
3. Check if T5 reports covered all god nodes → flag gaps as consolidation findings
4. Use `surprising_connections` list → cross-reference against T5's architectural risk findings
5. Use community map → verify T5's module boundary analysis matches graph communities

```bash
# Get top god nodes for coverage check
jq '.nodes | sort_by(-.degree) | .[0:5] | .[] | .id' graphify-out/graph.json

# List all communities for boundary verification
jq '.communities[] | {id: .id, cohesion: .cohesion, size: (.nodes | length)}' graphify-out/graph.json

# Find surprising connections (non-obvious edges)
jq '.metadata.surprising_connections // []' graphify-out/graph.json
```

### Graph Community Detection → Module Boundary Identification

graphify's Leiden community detection groups related modules.

Mapping to our architecture rules:

| Community Property | Architecture Implication | Action |
|-------------------|------------------------|--------|
| cohesion_score > 0.8 | Well-bounded module | No action needed |
| cohesion_score 0.5–0.8 | Module with some coupling | Flag as Medium risk |
| cohesion_score < 0.5 | Poor module boundaries | Flag as High risk (SRP violation) |
| Community spanning multiple feature dirs | Missing abstraction layer | Flag as architectural finding |
| Single node community | Potentially orphaned module | Flag for T3 investigation |

### Token Efficiency in Consolidation

For consolidation tasks:
- Use graph queries for structural questions (~200 tokens each)
- Read T5 raw reports from `.claude/analysis/raw/` (required for quality review)
- Avoid reading codebase files directly — T5 reports + graph queries provide sufficient context
- Estimated savings: 10,000–20,000 tokens per consolidation session

### MCP Tools for Lead Analyst (when server running)

| Tool | Consolidation Use |
|------|------------------|
| `god_nodes()` | Verify T5 covered critical modules; flag gaps |
| `cluster_cohesion()` | Identify SRP violations not caught by T5 |
| `graph_diff(before, after)` | Assess architectural change across sessions (sprint-level drift) |
| `surprising_connections()` | Find cross-cutting concerns T5 may have missed |
```

---

### 6. Security Mitigation Config

**Local mitigations for S-001, S-002, S-003 (mandatory before any agent use):**

#### S-001: Code Exfiltration Transparency

Default flag `--local-only` must be used in ALL agent-generated graphify invocations.
The SKILL.md and agent template additions above enforce this.

Agent prompt instruction (already included in Section 4 and 5 above):
> ALWAYS use `--local-only` unless the task explicitly involves analyzing documents, PDFs, or images.

No API key is required for `--local-only` mode. Set API key only when `--mode deep` is needed:
```bash
export ANTHROPIC_API_KEY="$(cat ~/.anthropic_api_key)"
```
Never store ANTHROPIC_API_KEY in settings.json, .env, or any file tracked by git.

#### S-002: PyPI Naming Divergence

The correct install command (PyPI package `graphifyy`, double-y):
```bash
uv tool install graphifyy
```

Verification command (always run after install):
```bash
pip show graphifyy | grep -E "^(Name|Version)"
graphify --version
```

If `pip show graphify` (single-y) returns a result, a typosquatting package may be installed. Remove it immediately and install the correct package.

#### S-003: Cache Integrity (Local Mitigation)

After every graphify run, set restrictive permissions on the output directory:
```bash
chmod -R 0700 graphify-out/
```

The `graphify-rebuild.sh` hook does NOT set permissions automatically (out of scope for a stale marker hook). Users/agents must apply this manually after each build.

A wrapper command agents can use (safe graphify invocation pattern):
```bash
graphify . --local-only && chmod -R 0700 graphify-out/
```

#### S-004: Symlink Traversal

Document in `.claude/rules/graphify-usage.md` (already included above):
- Do NOT analyze repositories containing symlinks pointing outside the repo root
- graphify's `os.walk(followlinks=False)` prevents collection, but build_from_json() has an edge case

#### Directory Scoping Patterns

Exclude sensitive directories from graphify analysis scope:
```bash
graphify . --local-only --exclude ".env,.pem,.key,secrets/,private/"
```

If `--exclude` flag is not available in the installed version, create a `.graphifyignore` file in the repo root (if supported) or pre-clean the analysis target directory.

#### Cache Directory Permissions

Post-build permission hardening (apply after every build):
```bash
chmod -R 0700 graphify-out/
```

Verify:
```bash
stat -f "%Mp%Lp %N" graphify-out/ 2>/dev/null || stat --format "%a %n" graphify-out/
```
Expected output: `700 graphify-out/`

---

### 7. Installation Steps

Ordered checklist for the user/operator to complete before integration is live:

**Pre-requisites:**

- [ ] **Step 1**: Verify Python version meets minimum requirement
  ```bash
  python3 --version
  ```
  Must be >= 3.10. If not, install via Homebrew: `brew install python@3.11`

- [ ] **Step 2**: Verify uv is installed (preferred installer)
  ```bash
  uv --version
  ```
  If not installed: `brew install uv`

**Installation:**

- [ ] **Step 3**: Install the correct PyPI package (note: double-y in package name)
  ```bash
  uv tool install "graphifyy[all]"
  ```
  The `[all]` extra includes: pdf support, watch mode, neo4j export, mcp server.
  If uv is unavailable: `pipx install "graphifyy[all]"`

- [ ] **Step 4**: Verify installation and that the correct package is installed
  ```bash
  pip show graphifyy | grep -E "^(Name|Version)"
  graphify --version
  ```
  Expected output line 1: `Name: graphifyy` (double-y, confirming correct package)
  Expected output line 2: version string e.g. `graphify version 0.1.14`

- [ ] **Step 5**: Verify graphify binary is on PATH
  ```bash
  which graphify
  ```
  If not found, add uv tool bin to PATH: `export PATH="$HOME/.local/bin:$PATH"`
  Add to shell profile (.zshrc or .bash_profile) for persistence.

**First-run test:**

- [ ] **Step 6**: Test on this project's .claude directory (safe, local-only)
  ```bash
  cd /Users/tcvmaksutoglu/Dev/w/claude-code-saka
  graphify .claude --local-only
  ```
  Expected: `graphify-out/` directory created with `graph.json`, `GRAPH_REPORT.md`, `graph.html`

- [ ] **Step 7**: Apply security permissions to output directory
  ```bash
  chmod -R 0700 graphify-out/
  ```

- [ ] **Step 8**: Verify graph.json is valid JSON
  ```bash
  jq '.nodes | length' graphify-out/graph.json
  ```
  Expected: a positive integer (node count)

- [ ] **Step 9**: Open graph visualization to confirm output
  ```bash
  open graphify-out/graph.html
  ```

**MCP server test (optional — for MCP integration):**

- [ ] **Step 10**: Test MCP server mode
  ```bash
  graphify --mcp &
  MCP_PID=$!
  sleep 2
  echo "MCP server started with PID $MCP_PID"
  kill $MCP_PID
  ```
  Expected: MCP server starts without error on stdio.

---

## T3 Implementation Checklist

T3 MidCoder (Canan Birsen) must complete these tasks in order:

### Files to Create

- [ ] **Create** `.claude/skills/graphify/SKILL.md` — exact content from Section 1 above
- [ ] **Create** `.claude/rules/graphify-usage.md` — exact content from Section 2 above
- [ ] **Create** `.claude/hooks/graphify-rebuild.sh` — exact script from Section 3 above
- [ ] **Create** `.claude/memory/graphs/.gitkeep` — empty file, creates directory for graph storage

### Files to Modify

- [ ] **Append** to `.claude/agents/analyst.md` — section from Section 4 above (after last `---`)
- [ ] **Append** to `.claude/agents/lead-analyst.md` — section from Section 5 above (after last `---`)
- [ ] **Modify** `.claude/settings.json` — two changes:

  **Change 1**: Add `graphify-rebuild.sh` to PostToolUse hooks (after `self-learning-collector.sh`):
  ```json
  {
    "type": "command",
    "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/graphify-rebuild.sh",
    "timeout": 5
  }
  ```

  **Change 2**: Add `graphify-audit.sh` to SessionEnd hooks (after `pattern-lifecycle.sh`):
  ```json
  {
    "type": "command",
    "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/graphify-audit.sh",
    "timeout": 30
  }
  ```
  Note: `graphify-audit.sh` is a separate hook (TASK-011) that runs pip-audit on graphify dependencies. T3 must also create that script (see below).

- [ ] **Modify** `.claude/config/task-assignment-matrix.md` — add these rows to "Task Type to Tier Mapping" table:

  | Task Type | Assigned Tier | Model | Rationale |
  |-----------|---------------|-------|-----------|
  | Codebase graph building | T5 Analyst | haiku | Analysis task; uses graphify skill |
  | Graph query / topology analysis | T5 Analyst | haiku | Structural analysis |
  | Architectural hub identification | T4 Lead Analyst | haiku | Consolidation; uses god_nodes() |
  | Cross-session drift detection | T4 Lead Analyst | haiku | graph_diff() comparison |

### Additional File to Create (from T4 consolidated task TASK-011)

- [ ] **Create** `.claude/hooks/graphify-audit.sh` with the following content:

```bash
#!/usr/bin/env bash
set -euo pipefail

: "${CLAUDE_PROJECT_DIR:?CLAUDE_PROJECT_DIR must be set}"

if ! command -v graphify >/dev/null 2>&1; then
  exit 0
fi

if ! command -v pip-audit >/dev/null 2>&1; then
  if ! command -v pip >/dev/null 2>&1; then
    exit 0
  fi
  exit 0
fi

AUDIT_LOG="$CLAUDE_PROJECT_DIR/.claude/metrics/.graphify-audit-$(date +%Y%m%d).log"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

pip-audit --requirement <(pip show graphifyy 2>/dev/null | grep -i requires | sed 's/Requires://;s/,/\n/g;s/ //g') \
  --output json 2>/dev/null | \
  jq -r '.[] | select(.vulns | length > 0) | "VULN: \(.name) \(.version) - \(.vulns[0].id)"' \
  >> "$AUDIT_LOG" 2>/dev/null || true

echo "$TIMESTAMP graphify-audit completed" >> "$AUDIT_LOG"

exit 0
```

Make executable: `chmod +x .claude/hooks/graphify-audit.sh`

### Post-Implementation Verification

After all files are created/modified, T3 must verify:

- [ ] `bash -n .claude/hooks/graphify-rebuild.sh` — no syntax errors
- [ ] `bash -n .claude/hooks/graphify-audit.sh` — no syntax errors
- [ ] `.claude/settings.json` is valid JSON: `jq . .claude/settings.json > /dev/null`
- [ ] `.claude/skills/graphify/SKILL.md` exists and contains `/graphify` command
- [ ] `.claude/rules/graphify-usage.md` exists and contains threshold rule (20 files)
- [ ] `.claude/agents/analyst.md` contains "graphify Usage Protocol" section
- [ ] `.claude/agents/lead-analyst.md` contains "graphify Consolidation Protocol" section
- [ ] `.claude/memory/graphs/` directory exists

### File Ownership Summary

| File | Owner | Tier Restriction |
|------|-------|-----------------|
| `.claude/skills/graphify/SKILL.md` | T3 MidCoder | Create |
| `.claude/rules/graphify-usage.md` | T3 MidCoder | Create |
| `.claude/hooks/graphify-rebuild.sh` | T3 MidCoder | Create |
| `.claude/hooks/graphify-audit.sh` | T3 MidCoder | Create |
| `.claude/agents/analyst.md` | T3 MidCoder | Append only |
| `.claude/agents/lead-analyst.md` | T3 MidCoder | Append only |
| `.claude/settings.json` | T3 MidCoder | Modify (add entries) |
| `.claude/config/task-assignment-matrix.md` | T3 MidCoder | Modify (add rows) |
| `.claude/memory/graphs/.gitkeep` | T3 MidCoder | Create |

### Dependency Note for T3

T3 does NOT implement MCP settings.json mcpServers entry in this task. graphify's MCP server is started manually per codebase (`graphify --mcp`); it does not auto-start via settings.json. If the Orchestrator decides to wire graphify as a persistent MCP server in settings.json, that is a separate architectural decision (ADR-003) requiring T1 Principal approval.

---

*Design document prepared by T2 Staff Engineer — Tarik Ziya Yesilcimen*
*Date: 2026-05-20*
*Next action: Assign implementation to T3 MidCoder (Canan Birsen)*
