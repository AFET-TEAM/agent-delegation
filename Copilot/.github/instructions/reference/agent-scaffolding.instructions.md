# Agent Scaffolding Rules

Portable, declarative guide for any coding agent (T1, T2, T3) to create a new agent. Supersedes the former `scripts/create-agent.sh` bash script with security-friendly instructions that work in any environment.

## 1. Naming Convention

Agent names **must** be kebab-case, matching the pattern `^[a-z][a-z0-9]*(-[a-z0-9]+)*$`.

**PascalCase conversion**: split on hyphens, capitalize each segment's first letter, concatenate.
`security-auditor` → `SecurityAuditor`, `data-pipeline` → `DataPipeline`

**File paths**:

- Agent file: `.github/agents/{agent-name}.agent.md`
- Instructions file: `.github/instructions/reference/{tier-prefix}-{agent-name}.instructions.md`

**Tier prefix mapping**:

| Tier | Prefix |
|------|--------|
| t1 | tier1 |
| t2 | tier2 |
| t3 | tier3 |
| t4 | tier4 |
| t5 | tier5 |

## 2. Tier Configuration Matrix

| Property | T1 (Principal) | T2 (Staff Eng) | T3 (MidCoder) | T4 (Lead Analyst) | T5 (Analyst) |
|----------|----------------|-------------------|---------------|---------------------|--------------|
| Description | Tier 1 Principal Agent | Tier 2 Staff Engineer Agent | Tier 3 MidCoder Agent | Tier 4 Lead Analyst Agent | Tier 5 Analyst Agent |
| Model | Claude Opus 4.6 (copilot) | Claude Sonnet 4.6 (copilot) | GPT-5.3-Codex (copilot) | Gemini 3.1 Pro (Preview) (copilot) | Gemini 3 Flash (copilot) |
| Fallback | Claude Opus 4.5 (copilot) | Claude Sonnet 4.5 (copilot) | GPT-5.2-Codex (copilot) | Gemini 3.0 Pro (Preview) (copilot) | Claude Haiku 4.5 (copilot) |
| Tools | edit, search, read, fetch, agent | edit, search, read, fetch | edit, search, read | edit, read, search, fetch | edit, read, search, fetch |
| Edit Permission | ✅ Full | ✅ Full | ✅ Full | ⚠️ Scoped — `.github/analysis/consolidated/` only | ⚠️ Scoped — `.github/analysis/raw/` only |
| Can Review | ✅ Staff Eng outputs | ✅ MidCoder outputs | Self-review only | ✅ Analyst outputs | ❌ No |

## 3. Agent File Template

Create `.github/agents/{agent-name}.agent.md` with this exact structure. Replace all `{placeholder}` values using the Tier Configuration Matrix.

```markdown
---
name: {PascalCaseName}
description: >
  {TierDescription} — {agent-specific description}
user-invokable: false
tools:
  - {tool1}
  - {tool2}
model: "{Model}"
modelFallback: "{Fallback}"
agents: []
---

# {PascalCaseName} — {TierDescription}

## Role Definition

{Define specific role and responsibilities}

## Skills

{Tier-appropriate skill references from Section 4}

## Tool Access

{Tool descriptions from the tool description table below}

## File Ownership

{Tier-appropriate ownership rule from Section 7}
```

**Tool description values** (use verbatim in the Tool Access section):

| Tool | Write Tiers (T1, T2, T3) | Scoped Write Tiers (T4, T5) |
|------|----------------------------|-------------------------------|
| edit | File creation and editing | Scoped file creation — analysis output directories only |
| search | Codebase search and navigation | Codebase search and navigation |
| read | File reading | File reading |
| fetch | External resource access | External resource access |
| agent | Running sub-agents (delegation) — T1 only | N/A |

## 4. Skills by Tier

| Tier | Skills |
|------|--------|
| T1 | clean-code, code-architecture, code-review, implementation, frontend-development, backend-development, commit-standards, pr-standards, testing-standards, backend-security, java-quality-tooling, api-integration |
| T2 | clean-code, implementation, code-review, frontend-development, backend-development, commit-standards, pr-standards, testing-standards, backend-security, java-quality-tooling, api-integration |
| T3 | clean-code, implementation, code-review, frontend-development, backend-development, commit-standards, pr-standards, testing-standards, java-quality-tooling, api-integration |
| T4 | clean-code, analysis, code-review |
| T5 | analysis |

Reference each skill as: `.github/skills/{skill-name}/SKILL.md`

## 5. Instructions File Template

Create `.github/instructions/reference/{tier-prefix}-{agent-name}.instructions.md` with this exact structure:

```markdown
# {TierDescription} — {PascalCaseName} Instructions

## Role Definition

{Define the detailed role and behavioral instructions for this agent.}

## Expectations

{Define expectations for this agent's tier.}

## Skills (Capability Map)

{List skills from Section 4 as markdown references:}
- `.github/skills/{skill-name}/SKILL.md` — {brief purpose}

## Tool Access

{Tool descriptions matching the agent file — see Section 3 tool table.}

## Output Expectations

{Define expected output format for this agent.}

> **Shared rules**: See `shared-base.instructions.md` for universal working principles, output format, and file ownership rules that apply to all tiers.
```

## 6. Post-Creation Checklist

After creating both files, the creating agent **must** complete every applicable step:

1. Add the new agent to `orchestrator.agent.md` → `agents` list (customAgents section).
2. Add the new agent to `AGENTS.md` → the relevant tier table.
3. Update `delegation-rules.instructions.md` → distribution tables if the tier distribution changes.
4. For T1 agents: populate `agents: [...]` in the YAML frontmatter with sub-agent references.
5. Run system validation rules — verify file counts (Check 2) and model consistency (Check 7).
6. Update `USAGE.md` and `README.md` if the total agent count or available capabilities change.

## 7. File Ownership Rules by Tier

| Tiers | Rule |
|-------|------|
| T1, T2, T3 | Only edit files assigned to you by the Orchestrator. Report conflicts rather than editing unowned files. |
| T4 | Scoped write access — may only write to `.github/analysis/consolidated/`. Never edit application code or other system files. |
| T5 | Scoped write access — may only write to `.github/analysis/raw/`. Never edit application code or other system files. |

## 8. Validation Guards

Before writing any file, the creating agent must verify:

- The agent name matches `^[a-z][a-z0-9]*(-[a-z0-9]+)*$`.
- Neither the agent file nor the instructions file already exists.
- The tier value is one of: `t1`, `t1.5`, `t2`, `t2.5`, `t3`.
- The `.github/agents/` and `.github/instructions/reference/` directories exist.

## 9. Skill Scaffolding Guide

To create a new skill, follow the consistent pattern established by the 13 existing skills:

### Skill File Template

Create `.github/skills/{skill-name}/SKILL.md` with this structure:

```yaml
---
name: {Skill Name}
description: >
  {1-2 sentence description of what this skill covers}
used-by: [{tier list, e.g. T1, T2, T3}]
estimated-tokens: {calibrated token estimate}
---
```

### Naming Convention

- Directory: `kebab-case` (e.g., `api-integration`, `clean-code`)
- File: Always `SKILL.md` (uppercase)
- YAML `name`: `Title Case` (e.g., `API Integration`, `Clean Code`)

### Post-Creation Checklist

1. Add the skill to `context-loading.instructions.md` → Task Type Detection table (specify which task types require it).
2. Add the skill to the relevant tier's skill list in `agent-scaffolding.instructions.md` Section 4.
3. Add the skill to each applicable tier's instruction file skill capability map.
4. Add the skill to each applicable agent's `.agent.md` description if it changes capabilities.
5. Run system validation — verify file count (Rule 2: minimum 13 SKILL.md files).
6. Update `USAGE.md` and `README.md` if the skill count or capabilities change.
7. Calibrate `estimated-tokens` by measuring actual file size after content is written.
