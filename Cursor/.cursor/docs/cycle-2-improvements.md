# Cycle 2 — Improvement Backlog

Deep analysis after v1.0.0 Cursor port.

## Gaps Identified

1. **Automatic Task spawn** — Cursor IDE does not auto-invoke Task from manifest; Orchestrator must follow spawn_order manually (documented). SDK could close this gap.
2. **Hook path in monorepo** — Package uses `Cursor/.cursor/hooks.json`; host install via `setup.sh` rewrites to `.cursor/`. Run setup on consumer repo.
3. **Graphify artifact** — Pipeline not bundled; degrades to search until `graphify` CLI installed.
4. **context-mode MCP** — Requires Node 18+ and network for `npx @context-mode/mcp`; verify warns if missing.
5. **Tier scope guard** — analysis-scope-guard is path-based; pre-write checks temp file content but not all StrReplace edge cases.
6. **Global AGENTS drift** — crm/AGENTS.md uses T1.5 schema; bridge doc exists but dual-load may confuse operators.

## Strengths

- Full xN distribution parity with Codex/Claude
- 19 legacy guards + Cursor JSON adapters
- spawn-packets with explore/generalPurpose mapping
- Wrapper CLI for /pcd, /context-mode, /graphify, /delegate, /caveman, /review
- verify-install 35-check green path

## Recommended Cycle 2 Tasks

| Priority | Task |
|----------|------|
| P0 | `setup.sh` on host + document in README |
| P1 | parity_validator.py three-package diff |
| P1 | Wave-aware subagentStop (T5 batch then T4) |
| P2 | graphify install in setup.sh optional step |
| P2 | PEP template in `.cursor/templates/` |
| P3 | Cursor SDK spawn helper script |
