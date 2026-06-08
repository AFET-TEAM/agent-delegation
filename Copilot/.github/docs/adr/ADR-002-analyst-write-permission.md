# ADR-002: Scoped Write Permission for Analyst Agents

## Status

Accepted

## Date

2026-03-28

## Context

The Multi-Agent Delegation System enforces a strict read-only constraint on Tier 4 (Lead Analyst) and Tier 5 (Analyst) agents. Analysis output exists only within the subagent conversation context — it is never persisted to the filesystem.

When analysis results need to be written to files (for session persistence, cross-agent sharing, or coding agent consumption), the Orchestrator must delegate a Tier 3 (MidCoder, $$$) or Tier 2 (Staff Engineer, $$$$) coding agent to perform the write. This creates:

1. **Token waste**: Expensive coding agent tokens are consumed for a trivial file write operation.
2. **Orchestrator relay overhead**: The Orchestrator must copy analysis text between subagent contexts, consuming its own token budget.
3. **No persistence**: Analysis results vanish when the session ends unless explicitly saved via a coding agent delegation.
4. **Pipeline latency**: An additional agent dispatch is needed just to persist analysis output.

Estimated token waste per x10 session: ~8-12K tokens from T3/T2 agents performing analysis writes.

## Decisions

### D-1: Grant Scoped Write Access to T4 and T5 Agents

Analyst agents (T4 Lead Analyst, T5 Analyst) receive the `edit` tool in their YAML `tools` field. Write access is **scoped by instruction** to the `.github/analysis/` directory only.

- **T5 Analyst**: May write to `.github/analysis/raw/` only.
- **T4 Lead Analyst**: May write to `.github/analysis/consolidated/` only.
- **All other directories**: Remain read-only for T4 and T5. Instruction-based and hook-based enforcement.

**Rationale**: The platform `edit` tool is all-or-nothing — there is no directory-scoped tool access in the VS Code Copilot API. Scoping is enforced through instruction compliance (primary) and safety-guard hook warnings (secondary). This mirrors the existing convention-based file ownership system (ADR-001, D-3).

### D-2: Create Dedicated Analysis Output Directory

A new directory structure is created:

```
.github/analysis/
├── raw/            ← T5 Analyst individual reports
├── consolidated/   ← T4 Lead Analyst consolidated reports
```

**Rationale**: Separating raw and consolidated outputs maintains the review chain integrity. Coding agents consume only the consolidated reports.

### D-3: Update Safety Guard Hook

The `safety-guard.json` hook is updated to:
- **Allow**: T4/T5 edit operations targeting `.github/analysis/` paths (log without warning).
- **Warn**: T4/T5 edit operations targeting any other path (existing behavior — log with warning).

**Rationale**: The hook provides an advisory safety net. The primary enforcement remains instruction-based.

### D-4: Analysis Output Replaces Context Relay

The analysis pipeline changes from conversation-relay to file-based:

```
Old: T5 (text) → Orchestrator relay → T4 (text) → Orchestrator relay → T3 writes file
New: T5 writes .github/analysis/raw/ → T4 reads raw/, writes .github/analysis/consolidated/ → Coding agents read consolidated/
```

**Rationale**: Eliminates Orchestrator relay overhead and coding agent write delegation entirely.

## Consequences

### Positive

- T3/T2 token savings: ~8-12K tokens/session (x10 mode)
- Orchestrator token savings: No analysis text relay needed
- Analysis persistence: Reports survive session boundaries
- Coding agents can read analysis from files (cheaper than context injection)
- Cross-session continuity: `/resume` can reference prior analysis

### Negative

- T4/T5 agents now have `edit` tool access (platform-level, all-or-nothing)
- Instruction-based scoping is not enforceable by the platform (same risk as D-3 in ADR-001)
- Slightly larger `.agent.md` files due to additional tool entry

### Risks

| ID  | Risk                                            | Severity | Mitigation                                      |
| --- | ----------------------------------------------- | -------- | ------------------------------------------------ |
| R-1 | T4/T5 edits files outside `.github/analysis/` | Medium   | Instruction scoping + safety-guard hook warnings  |
| R-2 | Analysis directory grows unbounded               | Low      | Session cleanup protocol clears old analysis files |
| R-3 | Raw reports without consolidation are consumed   | Low      | Coding agents instructed to read only consolidated/ |

## Related

- ADR-001: VS Code + GitHub Copilot Platform Boundary (D-3: Convention-based file ownership)
- `model-registry.instructions.md`: Introduced in the same change set
