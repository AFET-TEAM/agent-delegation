# graphify Installation Guide

## Overview

graphify (PyPI: `graphifyy`) builds queryable knowledge graphs from codebases using tree-sitter AST for code files. This guide covers installation, verification, and security configuration on macOS Darwin.

**PyPI package name**: `graphifyy` (double-y) — do NOT install `graphify` (single-y), which is a different, unrelated package.

---

## Pre-requisites

### Step 1: Verify Python Version

```bash
python3 --version
```

Must be >= 3.10. If not installed or version is older:

```bash
brew install python@3.11
```

macOS Darwin note: System Python at `/usr/bin/python3` may be 3.9.x. Use Homebrew Python to ensure version compliance. Verify which Python is active: `which python3`.

### Step 2: Verify uv is Installed

```bash
uv --version
```

uv is the preferred installer — faster and more reliable than pip for tool installs. If not installed:

```bash
brew install uv
```

---

## Installation

### Step 3: Install the Correct PyPI Package

Primary method (uv — recommended):

```bash
uv tool install "graphifyy[all]"
```

The `[all]` extra includes: pdf support, watch mode, neo4j export, mcp server.

Fallback method (pipx):

```bash
pipx install "graphifyy[all]"
```

If neither uv nor pipx is available, use pip (not recommended for tool installs):

```bash
pip install "graphifyy[all]"
```

### Step 4: Verify the Correct Package is Installed

```bash
pip show graphifyy | grep -E "^(Name|Version)"
graphify --version
```

Expected output:
- Line 1: `Name: graphifyy` — confirms the double-y package (not a typosquatting package)
- Line 2: version string, e.g. `graphify version 0.1.14`

If `pip show graphify` (single-y) returns a result, a typosquatting package may be installed. Remove it immediately:

```bash
pip uninstall graphify
pip show graphifyy | grep -E "^(Name|Version)"
```

### Step 5: Verify graphify Binary is on PATH

```bash
which graphify
```

If not found, add the uv tool bin directory to PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Add to shell profile for persistence:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

---

## First-Run Test

### Step 6: Test on Project Directory (Safe, Local-Only)

```bash
cd /Users/tcvmaksutoglu/Dev/w/claude-code-saka
graphify .claude --local-only
```

Expected: `graphify-out/` directory created with `graph.json`, `GRAPH_REPORT.md`, `graph.html`.

macOS Darwin note: tree-sitter native binaries compile on first run. This may take 15–30 seconds. Subsequent runs are fast.

### Step 7: Apply Security Permissions to Output Directory

```bash
chmod -R 0700 graphify-out/
```

This is mandatory. graph.json has no HMAC signature (S-003), so restricting permissions to owner-only is the local mitigation.

Verify permissions:

```bash
stat -f "%Mp%Lp %N" graphify-out/ 2>/dev/null || stat --format "%a %n" graphify-out/
```

Expected output: `700 graphify-out/`

### Step 8: Verify graph.json is Valid JSON

```bash
jq '.nodes | length' graphify-out/graph.json
```

Expected: a positive integer (the node count for the analyzed directory).

### Step 9: Open Graph Visualization

```bash
open graphify-out/graph.html
```

Expected: interactive graph opens in the default browser.

---

## MCP Server Test (Optional)

### Step 10: Test MCP Server Mode

```bash
graphify --mcp &
MCP_PID=$!
sleep 2
echo "MCP server started with PID $MCP_PID"
kill $MCP_PID
```

Expected: MCP server starts without error on stdio. The MCP server exposes tools: `query_graph`, `get_node`, `get_neighbors`, `shortest_path`, `graph_stats`, `god_nodes`, `cluster_cohesion`, `graph_diff`.

MCP server usage: start manually per-codebase when agents need MCP tool access. There is no auto-start. Run `graphify --mcp` in the codebase root before spawning T4/T5 agents that require MCP tools.

---

## Security Configuration

### S-001: Code Exfiltration Transparency

Always use `--local-only` for source code analysis. This ensures zero API calls:

```bash
graphify . --local-only
```

Only use `--mode deep` when the task explicitly requires PDF or image semantic extraction. Set API key via environment variable only — never in files:

```bash
export ANTHROPIC_API_KEY="$(cat ~/.anthropic_api_key)"
```

Never store `ANTHROPIC_API_KEY` in `.env`, `settings.json`, or any file tracked by git.

### S-002: PyPI Naming Divergence

The PyPI package name is `graphifyy` (double-y). The GitHub repository is named `graphify` (single-y). These are the same project. Always install and verify with the double-y name.

Verification command:

```bash
pip show graphifyy | grep -E "^(Name|Version)"
```

If `Name: graphify` (single-y) appears, a typosquatting package is present. Remove it.

### S-003: Cache Integrity

Apply after every build:

```bash
graphify . --local-only && chmod -R 0700 graphify-out/
```

Do not trust `graph.json` from shared or world-readable directories without verifying permissions first.

## ⚠️ Git Hook Installation Warning

graphify includes a `graphify install` sub-command that **silently modifies** `.git/hooks/post-commit` to auto-rebuild the graph on every commit. This command is **NOT required** for normal operation and **should NOT be run** unless you explicitly want automatic graph rebuilds.

### What the Hook Does

If run, `graphify install` appends a line to `.git/hooks/post-commit` that rebuilds `graphify-out/graph.json` after each commit. This adds latency to every commit and fills disk with intermediate build artifacts.

### How to Remove It

If you have accidentally run `graphify install`, remove the hook:

```bash
graphify hook remove
```

Verify the hook was removed:

```bash
cat .git/hooks/post-commit 2>/dev/null || echo "No post-commit hook installed"
```

### Sensitive Directory Exclusion

Exclude sensitive files from analysis scope:

```bash
graphify . --local-only --exclude ".env,.pem,.key,secrets/,private/"
```

If `--exclude` is not available in the installed version, create a `.graphifyignore` file in the repo root (if supported by the installed version).

---

## Troubleshooting

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| `graphify: command not found` | Binary not on PATH | `export PATH="$HOME/.local/bin:$PATH"` |
| `BrokenProcessPool` error | Clustering failure (Issue #943) | Re-run with `--local-only`; use non-clustered output |
| `Name: graphify` in pip show | Typosquatting package installed | `pip uninstall graphify && uv tool install "graphifyy[all]"` |
| Empty `graph.json` | No source files found in target directory | Verify target path contains `.py`, `.ts`, `.java`, or other supported extensions |
| `jq: command not found` | jq not installed | `brew install jq` |
| Build takes > 60 seconds | tree-sitter compiling native binaries | Wait for first-run compilation to complete; subsequent runs are faster |

---

## References

- Repository: https://github.com/safishamsi/graphify
- PyPI: https://pypi.org/project/graphifyy/
- Skill: `.claude/skills/graphify/SKILL.md`
- Usage rules: `.claude/rules/graphify-usage.md`
- Analysis reports: `.claude/analysis/consolidated/C-T4B-graphify.md`
