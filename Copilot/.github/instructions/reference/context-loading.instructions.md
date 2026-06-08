# Dynamic Context Loading

Load only the skills and context needed for the current task. This reduces token consumption significantly.

## Conditional Skill Loading Rules

### Task Type Detection

Before reading any skill file, determine the task type:

| Task Type    | Required Skills | Skip | Phase-Loaded† |
| ------------ | --------------- | ---- | ------------- |
| Frontend UI  | clean-code, frontend-development, implementation | code-architecture, analysis, backend-development, java-quality-tooling, backend-security | commit-standards, pr-standards, code-review, testing-standards |
| Backend API  | clean-code, backend-development, implementation, api-integration | frontend-development, code-architecture, analysis, java-quality-tooling, backend-security | commit-standards, pr-standards, code-review, testing-standards |
| Java Backend | clean-code, backend-development, java-quality-tooling, backend-security | frontend-development, code-architecture, analysis | commit-standards, pr-standards |
| Architecture | clean-code, code-architecture, code-review, backend-development | implementation, frontend-development, analysis, testing-standards, java-quality-tooling, backend-security | commit-standards, pr-standards |
| Analysis     | analysis | clean-code, code-architecture, code-review, backend-development, implementation, frontend-development, testing-standards, commit-standards, pr-standards, java-quality-tooling, backend-security | — |
| Review       | code-review, clean-code, commit-standards, pr-standards | code-architecture, frontend-development, backend-development, analysis, implementation, testing-standards, java-quality-tooling, backend-security | — |
| Testing      | testing-standards, clean-code, implementation | code-architecture, analysis, frontend-development, backend-development, code-review, commit-standards, pr-standards, java-quality-tooling, backend-security | — |
| PR/Commit    | commit-standards, pr-standards, clean-code, code-review | code-architecture, analysis, frontend-development, backend-development, implementation, testing-standards, java-quality-tooling, backend-security | — |

> **Analysis Output Directories**: Analysis task outputs are persisted to `.github/analysis/raw/` (T5 raw reports) and `.github/analysis/consolidated/` (T4 consolidated reports). Coding agents read consolidated reports from `.github/analysis/consolidated/` as input for implementation tasks.

> **† Phase-Loaded**: Skills loaded only during the commit/PR phase, not during active development. They do not count against the skill budget during the coding phase.

### Context Budget

| Agent Tier        | Max Skills to Load | Max Context Files |
| ----------------- | ------------------ | ----------------- |
| T1 Principal      | 5                  | 10                |
| T2 Staff Eng    | 5                  | 8                 |
| T3 MidCoder       | 4                  | 6                 |
| T4 Lead Analyst | 3                  | 5                 |
| T5 Analyst        | 2                  | 4                 |
| Orchestrator      | — (unlimited)       | — (unlimited)      |

> Orchestrator does not execute coding tasks; skill/context budget does not apply.

**STRICT**: Exceeding the context budget is forbidden. If a task requires more skills than the budget allows, the agent must request Orchestrator guidance to prioritize which skills to load. Loading skills outside the assigned tier capability is never permitted.

> **Note**: Backend API has 4 required skills (`clean-code`, `backend-development`, `implementation`, `api-integration`) plus 4 phase-loaded skills (`code-review`, `testing-standards`, `commit-standards`, `pr-standards`). Phase-loaded skills are deferred to the review/commit phase, keeping the active development budget within T3 limits.

> **Note**: Frontend UI has 3 required skills (`clean-code`, `frontend-development`, `implementation`) plus 4 phase-loaded skills (`code-review`, `testing-standards`, `commit-standards`, `pr-standards`). All tier budgets are satisfied during active development.

### Budget Exceeded Protocol

If an agent detects it needs more skills than its budget allows:

1. **STOP** — do not load additional skills beyond the budget.
2. **Report** the conflict in the task output with the list of needed vs available skills.
3. **Orchestrator reassigns**: either splits the task into smaller subtasks or elevates to a higher-tier agent with a larger budget.

## Orchestrator Task Assignment Enhancement

When the Orchestrator assigns a task, it specifies which skills to load:

```markdown
**Agent**: StaffEngineerAlpha
**Task**: Implement login form component
**Load Skills**: clean-code, frontend-development, testing-standards
**Skip Skills**: code-architecture, analysis, commit-standards, pr-standards
```

## Progressive Loading Strategy

1. **Always load first**: `shared-base.instructions.md` (auto-included via `applyTo: "**"`)
2. **Project Context Discovery**: Scan and load host project documentation (`README.md`, root `*.md` files, `docs/` folder) per `project-context-discovery.instructions.md` PCD Context Budget
3. **Load on demand**: Tier-specific skills based on task type
4. **Never pre-load**: Skills outside the agent's tier capability

## Project Context Loading (PCD)

Project Context Discovery runs before skill loading and counts **within** the existing context budget — PCD files consume context file slots from the "Max Context Files" column in the Context Budget table above. PCD is **not** a separate additive budget; a T3 MidCoder with 6 max context files uses those same 6 slots for both PCD files and skill/source files combined. See `project-context-discovery.instructions.md` for full protocol.

> **Canonical Source**: The PCD budget table in `project-context-discovery.instructions.md` is the authoritative reference. The table below is a convenience copy.

| Agent Tier | Max PCD Files | Max PCD Tokens |
|------------|--------------|----------------|
| T1 Principal | 5 | 8K |
| T2 Staff Eng | 4 | 6K |
| T3 MidCoder | 3 | 4K |
| T4 Lead Analyst | 3 | 4K |
| T5 Analyst | 2 | 3K |

## Session Context Loading

- Read `.github/memory/sessions/` only when continuing previous work
- Read `.github/todo/active-plan.md` only when `/resume` is invoked or task references ongoing work
- Skip session context for fresh, standalone tasks

## Token Optimization: reference/ Migration (v6.0.0+)

As of v6.0.0, only **3 universal instruction files** auto-load via `applyTo: "**"` (~4-5K tokens):
- `shared-base.instructions.md` — Universal agent rules
- `clean-code-standards.instructions.md` — Mandatory code quality
- `git-safety.instructions.md` — Git consent protocol

The remaining **17 instruction files** reside in `.github/instructions/reference/` and are **not** auto-loaded. They are loaded on-demand by agents when referenced. This reduces per-session platform overhead from ~45-55K to ~4-5K tokens.

### Impact (Post-Migration)

- Only 3 instruction files auto-load per session (~4-5K tokens of overhead).
- Tier-specific instructions are in `reference/` and loaded only when that agent reads them.
- The 15K subtask token budget is more practical with reduced overhead.

### Mitigation

1. **Orchestrator specifies skills per task**: The Orchestrator's task assignment explicitly lists which skills to load and which to skip, keeping per-task skill loading within budget.
2. **Instruction files are kept concise**: Tier-specific instruction files should contain only role definition and expectations unique to that tier. Shared rules live in `shared-base.instructions.md`.
3. **Agent files contain tier-specific context**: The `.agent.md` files are only loaded when that specific agent is invoked, making them the preferred location for detailed tier-specific guidance.

## Skill Core/Extended Split Protocol

Large skill files (> 4000 estimated tokens) support a core/extended split to reduce token consumption when full skill content is not needed.

### How It Works

1. Skill files with `core-sections` and `extended-sections` in their YAML frontmatter indicate which sections are core (always loaded) vs extended (loaded only when needed).
2. **Core sections**: Essential rules, patterns, and constraints that apply to every task using this skill.
3. **Extended sections**: Detailed examples, advanced patterns, edge cases, and reference material.

### Loading Rules

| Scenario | Load |
|----------|------|
| Skill is **required** for the task type AND agent is T3 (budget-constrained) | Core only |
| Skill is **required** for the task type AND agent is T1/T2 (higher budget) | Full (core + extended) |
| Skill is **phase-loaded** (commit/PR phase) | Core only |
| Agent explicitly requests extended content | Full (core + extended) |

### Token Savings

| Skill | Full Tokens | Core Tokens | Savings |
|-------|------------|------------|---------|
| testing-standards | ~6600 | ~3300 | 50% |
| frontend-development | ~6000 | ~3000 | 50% |
| api-integration | ~5200 | ~2600 | 50% |

### Frontmatter Format

```yaml
core-sections: ["Scope", "Rules", "Patterns"]
extended-sections: ["Examples", "Advanced Patterns", "Edge Cases", "Reference"]
```

### Agent Responsibility

- T3/T5 agents load core sections by default.
- T4 Lead Analyst follows the same core/extended loading rules as T5 (core-only by default, full on explicit request).
- T1/T2 agents load full content by default but may opt for core-only if budget is tight.
- The Orchestrator can explicitly specify `load: core-only` or `load: full` in task assignments.

## Cross-Cutting Response Modifiers

Some skills act as response style modifiers rather than task-type skills. They overlay any task type without replacing the task's required skills.

### Context Efficiency (Always Active — Baseline)

- **Skills**: `.github/skills/context-efficiency/SKILL.md` + `.github/skills/knowledge-graph/SKILL.md`
- **Trigger**: Always active (baseline rules in `shared-base.instructions.md`). Full skill files loaded on-demand per task or when `/context-mode` is triggered.
- **Budget impact**: ~2.2K + ~1.8K tokens (full load). Core sections only: ~1.1K + ~0.9K. Does NOT count against task-type skill budget — these are cross-cutting efficiency modifiers.
- **Loading rule**:
  - Baseline rules (Think-in-Code, Output Routing, Query-First) are embedded in shared-base → always available, zero extra load
  - Full skill files loaded when: (a) `/context-mode` is explicitly triggered, or (b) Orchestrator specifies them in task assignment for analysis-heavy tasks
- **Scope**: All tiers (T1-T5). Affects how agents use tools and structure output — does not affect code generation logic.

### Context Mode (Intensified — Optional)

- **Skills**: `.github/skills/context-efficiency/SKILL.md` (full) + `.github/skills/knowledge-graph/SKILL.md` (full)
- **Trigger**: `/context-mode` command or `context mode`/`context-mode` keyword in user prompt
- **Budget impact**: ~4K tokens combined (full load of both skills). Does NOT count against task-type skill budget.
- **Loading rule**: Loaded on-demand only when triggered. Never pre-loaded.
- **Scope**: All tiers (T1-T5). Intensifies efficiency rules beyond baseline — applies strict output budgets and aggressive batching.

### Caveman Mode

- **Skill**: `.github/skills/caveman/SKILL.md`
- **Trigger**: `/caveman` command or `caveman` keyword in user prompt
- **Budget impact**: ~1.5K tokens. Does NOT count against the task-type skill budget because it is a response modifier, not a task skill.
- **Loading rule**: Loaded on-demand only when triggered. Never pre-loaded.
- **Scope**: All tiers (T1-T5). Modifies text output only — does not affect code generation or structured artifacts.

### Combining Modifiers

Cross-cutting modifiers can stack. For example, a "Frontend UI" task with both context-mode and caveman active loads: `clean-code + frontend-development + implementation + context-efficiency + knowledge-graph + caveman`. No modifier displaces any required skill.

| Combination | Effect |
|-------------|--------|
| Baseline only (default) | Standard efficiency rules from shared-base |
| + Context Mode | Strict budgets, aggressive batching, full skill enforcement |
| + Caveman | Compressed text output (~65% reduction) |
| + Both | Maximum efficiency — strict budgets AND compressed output |
