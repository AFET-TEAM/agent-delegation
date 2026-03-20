# ADR-001: VS Code + GitHub Copilot Platform Boundary

## Status

Accepted

## Date

2026-02-24

## Context

The Multi-Agent Delegation System is built entirely on VS Code's native agent mechanism:
- `.agent.md` files define agent identity and tool access
- `.instructions.md` files with `applyTo` control instruction loading
- `.hooks/` JSON files provide lifecycle and safety automation
- Model selection via `model` and `modelFallback` YAML properties

This creates an inherent dependency on VS Code (1.109+) and GitHub Copilot extensions.

## Decisions

### D-1: Accept Single-Platform Dependency

The system targets VS Code + GitHub Copilot exclusively. No abstraction layer for portability to other agent platforms (Cursor, Windsurf, JetBrains AI) is provided.

**Rationale**: Native integration provides the best developer experience. An abstraction layer would add complexity without current demand.

### D-2: Accept `applyTo: "**"` Broadcast Behavior

Previously, all 19 instruction files used `applyTo: "**"` which loaded them in every Copilot Chat interaction (~45-55K tokens overhead including platform system prompts). As of v6.0.0, only 3 universal instruction files auto-load (~4-5K tokens for instruction content alone; ~15-20K total when platform system prompts and skill definitions are included); 16 on-demand reference files (5 tier-specific + 11 system-wide) are in `reference/` and loaded by agents when needed.

**Rationale**: VS Code Copilot's `applyTo` targets workspace file patterns, not agent identity. The `reference/` migration exploits this by placing non-universal files outside the glob pattern.

**Mitigation**: Only `shared-base`, `clean-code-standards`, and `git-safety` auto-load. Orchestrator specifies per-task skill and instruction loading subset. Context-loading budget limits (2-5 skills per agent tier) enforce practical filtering.

### D-3: File Ownership is Convention-Based

File ownership rules exist in agent instructions and AGENTS.md but are NOT enforced by platform hooks. An LLM agent can technically edit files it doesn't "own."

**Rationale**: VS Code hooks can log edit operations but cannot block them based on agent identity in the current API.

**Mitigation**: safety-guard.json PostToolUse hook logs all edit operations with agent identity (COPILOT_AGENT variable) for audit trail.

### D-4: Token Budget is Advisory

The 15K subtask token budget depends on Orchestrator compliance. No hard circuit-breaker exists to terminate an agent exceeding its budget.

**Rationale**: Token counting is not exposed to hook scripts in the current VS Code Copilot API.

**Mitigation**: active-plan.md tracks estimated vs actual token usage. Manual recovery via /resume command.

### D-5: Model Fallback is Declarative

The `modelFallback` YAML property documents intent, but actual model routing is controlled entirely by the VS Code/Copilot platform. If the platform doesn't support the declared fallback model, the system has no recourse.

**Rationale**: Model selection is a platform concern, not a configuration concern.

**Mitigation**: Agents report fallback activation in task reports. Orchestrator includes Model Status section for transparency.

## Consequences

### Positive

- Deep VS Code integration provides native-feeling agent experience
- No custom runtime, server, or build step required — pure configuration
- Leverages VS Code's rapid iteration cycle and extension ecosystem
- Familiar to developers already using Copilot

### Negative

- Not portable to other platforms without significant rewrite
- Some constraints (D-2, D-3, D-4) are fundamentally unresolvable at the boilerplate level
- Platform updates may break assumptions (e.g., applyTo behavior changes)

### Risks Documented

| ID | Risk | Severity | Mitigation |
|----|------|----------|------------|
| R-1 | File Ownership not enforced | Medium | Audit logging via hooks |
| R-2 | Token budget advisory only | Low | active-plan.md + /resume |
| R-3 | Model fallback declarative | Low | Transparent reporting |
| R-4 | Session memory depends on Orchestrator discipline | Medium | Hook-based auto-save markers |
| R-5 | Single-platform dependency | Medium | Documented as accepted trade-off |
| R-6 | Log rotation single-backup (`.old`) | Low | x10 TOCTOU race theoretical; telemetry-only data, no business impact |
