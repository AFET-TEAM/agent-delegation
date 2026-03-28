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

> **Analysis Output Directories**: Analysis task outputs are persisted to `.github/analysis/raw/` (T3 raw reports) and `.github/analysis/consolidated/` (T2.5 consolidated reports). Coding agents read consolidated reports from `.github/analysis/consolidated/` as input for implementation tasks.
| Review       | code-review, clean-code, commit-standards, pr-standards | code-architecture, frontend-development, backend-development, analysis, implementation, testing-standards, java-quality-tooling, backend-security | — |
| Testing      | testing-standards, clean-code, implementation | code-architecture, analysis, frontend-development, backend-development, code-review, commit-standards, pr-standards, java-quality-tooling, backend-security | — |
| PR/Commit    | commit-standards, pr-standards, clean-code, code-review | code-architecture, analysis, frontend-development, backend-development, implementation, testing-standards, java-quality-tooling, backend-security | — |

> **† Phase-Loaded**: Skills loaded only during the commit/PR phase, not during active development. They do not count against the skill budget during the coding phase.

### Context Budget

| Agent Tier        | Max Skills to Load | Max Context Files |
| ----------------- | ------------------ | ----------------- |
| T1 Principal      | 5                  | 10                |
| T1.5 Staff Eng    | 5                  | 8                 |
| T2 MidCoder       | 4                  | 6                 |
| T2.5 Lead Analyst | 3                  | 5                 |
| T3 Analyst        | 2                  | 4                 |
| Orchestrator      | — (sınırsız)       | — (sınırsız)      |

> Orchestrator kodlama görevi yürütmediği için skill/context bütçesi uygulanmaz.

**STRICT**: Exceeding the context budget is forbidden. If a task requires more skills than the budget allows, the agent must request Orchestrator guidance to prioritize which skills to load. Loading skills outside the assigned tier capability is never permitted.

> **Note**: Backend API has 4 required skills (`clean-code`, `backend-development`, `implementation`, `api-integration`) plus 4 phase-loaded skills (`code-review`, `testing-standards`, `commit-standards`, `pr-standards`). Phase-loaded skills are deferred to the review/commit phase, keeping the active development budget within T2 limits.

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

Project Context Discovery runs before skill loading and counts **within** the existing context budget (PCD files consume context file slots, not additive). See `project-context-discovery.instructions.md` for full protocol.

> **Canonical Source**: The PCD budget table in `project-context-discovery.instructions.md` is the authoritative reference. The table below is a convenience copy.

| Agent Tier | Max PCD Files | Max PCD Tokens |
|------------|--------------|----------------|
| T1 Principal | 5 | 8K |
| T1.5 Staff Eng | 4 | 6K |
| T2 MidCoder | 3 | 4K |
| T2.5 Lead Analyst | 3 | 4K |
| T3 Analyst | 2 | 3K |

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
| Skill is **required** for the task type AND agent is T2 (budget-constrained) | Core only |
| Skill is **required** for the task type AND agent is T1/T1.5 (higher budget) | Full (core + extended) |
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

- T2/T3 agents load core sections by default.
- T1/T1.5 agents load full content by default but may opt for core-only if budget is tight.
- The Orchestrator can explicitly specify `load: core-only` or `load: full` in task assignments.
