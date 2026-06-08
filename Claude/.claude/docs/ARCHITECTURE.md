# Architecture Reference — Claude Code Multi-Agent System

## System Overview

The Claude Code Multi-Agent Delegation System (v1.0.0) is a 5-tier orchestration framework layered on top of Claude Code. It accepts natural language software engineering tasks, decomposes them into atomic sub-tasks, distributes work across specialized AI agents, enforces code quality through automated hooks, and accumulates institutional knowledge across sessions.

```
User Prompt
    │
    ▼
┌─────────────────────────────────────────────────────────┐
│  ORCHESTRATOR (main session)                             │
│  Model: opus (env: sonnet-4-6 fallback)                  │
│  Role: Coordination, DAG construction, consolidation     │
└──────────────────────┬──────────────────────────────────┘
                       │ spawns agents via wave execution
          ┌────────────┼────────────┐
          ▼            ▼            ▼
    ┌──────────┐  ┌──────────┐  ┌──────────┐
    │T1 opus   │  │T2 sonnet │  │T3 sonnet │
    │Principal │  │Staff Eng │  │MidCoder  │
    └──────────┘  └──────────┘  └──────────┘
          ▲            ▲
          │            │
    ┌──────────┐  ┌──────────┐
    │T4 haiku  │  │T5 haiku  │
    │Lead Anl  │  │Analyst   │
    └──────────┘  └──────────┘
          │
    ┌─────────────────────────────────────────────────────┐
    │  ENFORCEMENT LAYER                                   │
    │  19 hooks: PreToolUse(11+2) PostToolUse(3) End(3+)  │
    └─────────────────────────────────────────────────────┘
          │
    ┌─────────────────────────────────────────────────────┐
    │  MEMORY + LEARNING LAYER                             │
    │  Sessions · Patterns · Leaderboard · Metrics         │
    └─────────────────────────────────────────────────────┘
```

---

## Tier Design

### Orchestrator

The main Claude Code session. Model is determined by the environment (opus when available; sonnet-4-6 fallback). The Orchestrator never writes application code directly.

**Responsibilities**:
- Prompt analysis and xN detection
- Prompt Enrichment Protocol (PEP) — clarifying questions before task distribution
- DAG construction with cycle detection
- Agent spawning via the Agent tool
- Review chain orchestration
- Result consolidation and session end reporting

**File access**: READ-ONLY on application code. Writes only to `.claude/todo/`, `.claude/memory/`, `.claude/metrics/`.

---

### T1 Principal (opus)

The senior architect agent. Handles the most complex decisions and performs the final quality gate on all T2 outputs.

**Responsibilities**: Architecture soundness, SOLID principles, production standards, cross-cutting concerns (logging, monitoring, auth).

**Review scope**: T2 Staff Engineer outputs, plus direct architectural consultations via `/architect`.

**Token ceiling**: 15,000 tokens per task (from `context-budget.json`).

---

### T2 Staff Engineer (sonnet)

Senior implementation agent. Designs service layers, interfaces, and transaction management. Reviews T3 outputs.

**Responsibilities**: Service layer design, complex business logic, error handling completeness, SOLID adherence.

**Review scope**: T3 MidCoder outputs. Reviews naming, complexity, security, SOLID.

**Token ceiling**: 10,000 tokens per task.

---

### T3 MidCoder (sonnet)

Standard implementation agent. Handles API endpoints, entities, DTOs, and routine code changes.

**Responsibilities**: Controllers, repositories, DTOs, entity mapping, standard CRUD.

**Token ceiling**: 5,000 tokens per task (`max_tokens_per_task` in JSON; 4K PCD context budget is a separate constraint).

---

### T4 Lead Analyst (haiku)

Consolidation agent. Takes T5 raw research and synthesizes it into actionable architecture briefs for coding agents.

**Write access**: ONLY `.claude/analysis/consolidated/`.

**Token ceiling**: 8,000 tokens per task.

---

### T5 Analyst (haiku)

Research and analysis agent. Reads existing code, documentation, and external sources. Does not write application code.

**Write access**: ONLY `.claude/analysis/raw/`.

**Token ceiling**: 6,000 tokens per task.

**Mandatory graphify usage**: For codebases with more than 20 files in scope, T5 must build or reuse a graphify knowledge graph before any file-reading analysis.

---

## DAG and Wave Execution

### DAG Construction

The Orchestrator breaks each task into atomic sub-tasks and models their dependencies as a Directed Acyclic Graph (DAG).

```
TASK-001 (T5, ~3K) ──────────────────────────────────────┐
                                                          │
TASK-002 (T5, ~3K) ──┐                                   │
                     ▼                                   ▼
              TASK-003 (T4, ~2K) → TASK-005 (T3, ~4K) → TASK-007 (T2, review)
                                   TASK-006 (T2, ~8K) ↗
```

**Cycle detection**: Before executing, the Orchestrator verifies no circular dependencies. A cyclic DAG stops execution and is reported to the user.

### Wave Execution (Topological Sort)

Waves are derived by topological sort:
1. Wave 1: All nodes with 0 in-degree (no dependencies)
2. Remove Wave 1 nodes, recalculate in-degrees
3. Repeat until all nodes are assigned

```
Wave 1: T5 agents (parallel) — research and analysis
Wave 2: T4 Lead Analyst — consolidation
Wave 3: T3 + T2 (parallel, where independent) — implementation
Wave 4+: Review chain (sequential up the tiers)
```

### Overflow Protocol

If a sub-task is estimated to exceed 15K tokens, it must be split further. If it cannot be split (e.g., a single-file rewrite that is inherently large), it is escalated to the next tier up, and the reason is documented in `active-plan.md`.

---

## Hook Layer

19 hooks fire at three event points in the tool lifecycle:

### PreToolUse:Edit/Write (11 hooks)

Fire before any file modification. Exit code 2 blocks the edit.

| Hook | What It Blocks |
|------|---------------|
| `block-console-log.sh` | `console.*` statements, `alert`, `confirm`, `prompt` |
| `block-any-type.sh` | TypeScript `: any`, `@ts-ignore` |
| `block-comments.sh` | Inline `//` and `/* */` comments, TODO/FIXME |
| `secret-guard.sh` | Hardcoded API keys, passwords, tokens |
| `sql-injection-check.sh` | SQL string concatenation |
| `xss-prevention-check.sh` | `innerHTML`, `dangerouslySetInnerHTML`, `eval` |
| `path-traversal-check.sh` | Unsanitized path operations with `..` |
| `cors-wildcard-check.sh` | Wildcard `*` CORS origins |
| `field-injection-check.sh` | `@Autowired` on fields (Java) |
| `figma-standards-guard.sh` | Hardcoded px, hex colors, inline styles |
| `analysis-scope-guard.sh` | T4/T5 writes outside designated analysis directories |

### PreToolUse:Bash (2 hooks)

Fire before Bash commands execute.

| Hook | What It Blocks |
|------|---------------|
| `git-safety-check.sh` | Destructive git ops (push, merge, reset) without explicit consent |
| `context-mode-guard.sh` | ctx_execute on denied paths or network targets |

### PostToolUse:Edit/Write (3 hooks)

Fire after successful file modification. Non-blocking — they collect metrics.

| Hook | What It Does |
|------|-------------|
| `review-tracker.sh` | Counts edits per file; warns at 5 and 10 edits |
| `self-learning-collector.sh` | Detects repeated edit cycles; creates learned pattern files |
| `graphify-rebuild.sh` | Marks graphify graph stale when source files change |

### SessionEnd (3 hooks)

Fire when the Claude Code session ends.

| Hook | What It Does |
|------|-------------|
| `update-leaderboard.sh` | Applies score deltas from session; emits `.session-complete` sentinel |
| `pattern-lifecycle.sh` | Processes pattern hits, promotions, and archival |
| `graphify-audit.sh` | Audits graphify graph usage statistics |

---

## Skills Layer

Skills are slash commands that invoke specialized capabilities:

| Skill | Command | Tier Scope |
|-------|---------|-----------|
| context-mode | `/ctx` | All tiers |
| graphify | `/graphify` | T4/T5 analysis |
| caveman | `/caveman` | Orchestrator output only |
| review | `/review` | Any tier |
| security-review | `/security-review` | T1/T2 typically |
| architect | `/architect` | Routes to T1 directly |
| test-gen | Invoked by T3 | T3 |

Skill definitions live in `.claude/skills/{name}/SKILL.md`.

---

## Memory and Learning System

### Session Files

After each multi-agent session, the Orchestrator writes a session file to `.claude/memory/sessions/` using the template at `.claude/memory/sessions/_session-template.md`. Contains: agent performance table, token usage, learned patterns, changed files.

Maximum 3 most-recent session files are loaded at session start (loading limit to control context size).

### Learned Patterns

`self-learning-collector.sh` creates pattern files in `.claude/memory/learned-patterns/` when the same file is edited 2+ times in a session. Pattern files use a standard frontmatter format:

```
pattern-id: LP-YYYY-MM-DD-{category}
category: {backend-security|React|TypeScript|...}
hit-count: 0
last-triggered: null
sessions-since-hit: 0
```

Maximum 10 most-recent patterns are loaded at session start.

### Pattern Lifecycle

`pattern-lifecycle.sh` runs at session end:

1. Greps each pattern's `Error`/`Hata` section keywords against the current session content
2. Match: increment `hit-count`, reset `sessions-since-hit`
3. No match: increment `sessions-since-hit`
4. At `hit-count >= 3`: promote to `.claude/rules/learned-{category}.md` (non-destructive, with deduplication marker)
5. At `sessions-since-hit >= 5` and `hit-count == 0`: archive to `.claude/memory/learned-patterns/archive/`

Archived patterns are never deleted — they remain recoverable.

---

## Metrics and Leaderboard

### Score Tracking

Agent display names come from a pool of 20 names in `.claude/config/name-pool.md`. Each name has a score that evolves across sessions via `update-leaderboard.sh`.

Score deltas per event:
- Task completed: +5
- Task failed: -5
- Code review first-pass: +3
- Review second-pass: +1
- Review 3+ rounds: -3
- Found P0/P1 issue: +4
- False positive finding: -2
- Unnecessary escalation: -2
- Model fallback: -1

### Score-Weighted Selection

At session start, the Orchestrator selects names for agents using weighted random selection:

```
weight = max(score + 101, 1) × tier_multiplier
```

Tier multipliers (from `name-pool.md`):
- Score ≥ 50: 2.0×
- Score 20–49: 1.5×
- Score 0–19: 1.0×
- Score -1 to -20: 0.8×
- Score < -20: 0.5×

Higher-scoring agents are more likely to be selected for new tasks. All agents receive work over time.

### Leaderboard Lock Safety

`update-leaderboard.sh` uses `flock` (or `mkdir` fallback on macOS without util-linux) to ensure atomic writes. A temp-file-plus-`mv` pattern guarantees the leaderboard is never in a partial state.

---

## File Ownership Model

Each file is owned by exactly one agent per session. Write conflicts are prevented by the task DAG design.

| Tier | Writable Paths | Read |
|------|---------------|------|
| Orchestrator | `.claude/todo/`, `.claude/memory/`, `.claude/metrics/` | All |
| T1 Principal | Assigned application files | All |
| T2 Staff Engineer | Assigned application files | All |
| T3 MidCoder | Assigned application files | All |
| T4 Lead Analyst | `.claude/analysis/consolidated/` only | All |
| T5 Analyst | `.claude/analysis/raw/` only | All |

`analysis-scope-guard.sh` enforces T4/T5 write boundaries at the hook level.

---

## Security Model

### Authentication

No external auth required. The system operates entirely within Claude Code sessions using your existing Anthropic API credentials (managed by the Claude Code CLI).

### Hook Enforcement

Hooks run as shell scripts at the Claude Code harness level. Their exit codes are binding — exit code 2 blocks the tool call before it executes. This enforcement is at the platform level and cannot be bypassed from within a session.

### Deny Lists

Two deny lists restrict agent access:

**Context-mode denied paths** (`.claude/rules/context-mode-usage.md`):
- `~/.ssh/`, `~/.aws/`, `~/.kube/`, `~/.gnupg/`
- `./.env`, `./.env.*`
- `./secrets/`

**Context-mode denied network targets**:
- `127.0.0.1`, `192.168.*.*`, `10.*.*.*`, `169.254.*.*`
- `metadata.google.internal`, `100.100.*.*`

### Sandboxing Notes

context-mode is a context reduction tool, not a security sandbox. Subprocess execution via `ctx_execute` has access to project files and system PATH tools (exfiltration tools are blocked by `context-mode-guard.sh`, but this is defense-in-depth, not a hard boundary).

Deploy only on trusted local development machines.

---

## Design Decisions

Key architectural decisions made during system design are recorded as ADRs in `.claude/docs/adr/`. The most significant decisions:

**Decision: T3 Budget Canonical Value (5K)**
`context-budget.json` is the machine-readable source of truth for `max_tokens_per_task`. The "4K" value in `tier-definitions.md` refers to PCD context file budget, a separate constraint. The JSON value of 5000 is the actual task ceiling.

**Decision: Tier Multiplier Scale (Decimals)**
`compute_tier_multiplier()` returns decimal values (2.0, 1.5, 1.0, 0.8, 0.5) matching the `name-pool.md` documentation. Weight arithmetic uses `awk` for floating-point precision.

**Decision: Bash 4+ Warning + Graceful Degradation**
Rather than requiring Bash 4+ at setup (which would break macOS CI/CD pipelines), `update-leaderboard.sh` gracefully degrades with an INFO message. `setup.sh` surfaces the warning prominently so users know before they see the session-end skip.

---

## Extension Points

### Adding a New Tier

1. Define the tier in `.claude/config/tier-definitions.md`
2. Add a token budget entry to `.claude/config/context-budget.json`
3. Create an agent prompt template in `.claude/agents/{role}.md`
4. Update `.claude/config/delegation-rules.md` for xN distribution
5. Update the xN Distribution Table in `CLAUDE.md`

### Adding a New Hook

1. Create the script in `.claude/hooks/`
2. Follow the exit code contract: 0=pass, 2=block, 1=infrastructure error
3. Register in `.claude/settings.json` under the appropriate event
4. Add to `.claude/config/hook-registry.md`
5. If the hook enforces a rule from a rule file, add a cross-reference in that rule file's Enforcement section

### Adding a New Rule File

1. Create in `.claude/rules/` following the established format
2. Add to the Key Configuration Files table in `CLAUDE.md`
3. Update the rule file count in `CLAUDE.md`
4. Reference from relevant agent prompt templates if tier-specific

### Adding a New Skill

1. Create directory: `.claude/skills/{name}/`
2. Create `SKILL.md` with frontmatter (`name`, `description`) and usage documentation
3. Register the slash command in Claude Code settings if needed
4. Reference from `CLAUDE.md` or relevant documentation

### Extending the Learning System

Patterns can be created manually by writing files to `.claude/memory/learned-patterns/` with the correct frontmatter. The lifecycle hook processes all files in that directory, so manual patterns participate in the same promotion and archival pipeline as auto-generated ones.

To add a new pattern category, create a new `learned-{category}.md` file in `.claude/rules/` — the lifecycle hook will promote matching patterns there automatically.

---

## Self-Learning Loop Summary

```
File edited 2+ times in session
       │
       ▼
self-learning-collector.sh
creates LP-{date}-{category}.md
(hit-count: 0)
       │
       ▼  (at session end)
pattern-lifecycle.sh
checks session content
       │
   ┌───┴───┐
   │match  │no match
   ▼       ▼
hit-count++ sessions-since-hit++
       │
  hit-count >= 3?
       │ YES
       ▼
append to .claude/rules/learned-{category}.md
(with deduplication marker)
       │
  sessions-since-hit >= 5 AND hit-count == 0?
       │ YES
       ▼
move to .claude/memory/learned-patterns/archive/
(recoverable, not deleted)
```

---

## Key Configuration File Reference

| File | Purpose |
|------|---------|
| `.claude/config/tier-definitions.md` | Tier-model mapping, role descriptions, budgets |
| `.claude/config/context-budget.json` | Machine-readable per-tier token ceilings |
| `.claude/config/delegation-rules.md` | xN agent distribution tables |
| `.claude/config/hook-registry.md` | All 19 hooks cross-referenced with rules |
| `.claude/config/name-pool.md` | 20 agent display names with scores and selection weights |
| `.claude/config/task-assignment-matrix.md` | Task type to tier mapping |
| `.claude/config/model-registry.md` | Model availability and fallback chain |
| `.claude/docs/hook-exit-codes.md` | Exit code semantics for all hooks |
| `.claude/docs/GETTING_STARTED.md` | New user onboarding guide |
| `.claude/docs/TROUBLESHOOTING.md` | Common issues and fixes |
| `.claude/docs/FAQ.md` | Frequently asked questions |
