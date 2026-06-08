---
pattern-id: LP-2026-05-20-01
name: External MCP Server Registration Requires Explicit User Authorization
category: security
hit-count: 0
last-triggered: null
sessions-since-hit: 1
---

# Error
Auto-mode sandbox blocks T1 Principal from writing to settings.json when the change registers a new external MCP server (npx-based package execution), even though the CLAUDE.md role grants T1 full settings.json access.

# Fix
Do not attempt to write the MCP server registration in the same T1 agent wave. Orchestrator must present the payload to the user and request explicit written authorization before applying. The three related writes (settings.json MCP entry, agent template update, hook-registry update) should be presented as a coordinated transaction.

# Rule
External MCP server registration (mcpServers block with npx command) requires explicit user-message authorization beyond role-based grants. This is categorically different from adding a local shell script to PostToolUse — the latter succeeds without extra authorization (T1-B confirmed this).

# Context
Triggered in session 2026-05-20-context-graphify-x10 during context-mode integration. T1-B (graphify) successfully added graphify-rebuild.sh (local script) to settings.json. T1-A (context-mode) was blocked adding npx @context-mode/mcp@1.0.146 (external package). The distinction: external code execution vs local script reference.
