# Slash Commands — Instruction-Based Routing

Platform-agnostic command definitions. These commands work in any environment (VS Code, Copilot CLI, other tools) without requiring `.github/prompts/` support.

## Command Detection

When the user's message starts with one of the following commands, route to the specified behavior:

| Command | Target Agent | Behavior |
|---------|-------------|----------|
| `/delegate [task] xN` | Orchestrator | Multi-agent delegation |
| `/review [scope]` | Orchestrator | Review chain trigger |
| `/status` | Orchestrator | Delegation status report + context window dashboard |
| `/architect [task]` | PrincipalAlpha | Direct architecture task |
| `/resume [task-id]` | Orchestrator | Resume previous work |
| `/history [count]` | Orchestrator | Session history listing |
| `/create-agent [name]` | Orchestrator | Scaffold a new agent definition |

---

## /delegate — Multi-Agent Delegation

Delegate the user's request to the multi-agent team.

**Usage**: `/delegate [task description] x[agent count]`

**Examples**:
```
/delegate Create auth module, add JWT authentication x7
/delegate Write API endpoints x5
/delegate Analyze project structure x3
/delegate Fix this bug  (no xN → single agent)
```

**Steps**:
1. Detect the `xN` parameter at the end of the prompt.
2. Determine the agents according to the distribution table in `delegation-rules.instructions.md`.
3. Divide the task into sub-tasks.
4. Delegate each sub-task to the agent in the appropriate tier.
5. Collect results and run the review chain.
6. Present the final output to the user.

---

## /review — Review Chain

Submit current outputs or specified files to the review chain.

**Usage**:
```
/review                    → Review all recent outputs
/review src/auth/          → Review the specified directory
/review user-service.ts    → Review the specified file
```

**Steps**:
1. Determine the review scope.
2. Assign Tier 3 (Analyst) outputs to Tier 2.5 (Lead Analyst) for review.
3. Assign Tier 2 (MidCoder) outputs to Tier 1.5 (Staff Engineer) for review.
4. Assign Tier 1.5 (Staff Engineer) outputs to Tier 1 (Principal) for review.
5. Collect review reports from all tiers.
6. Notify the relevant agent of items requiring corrections.
7. Present the final review summary to the user.

---

## /status — Delegation Status

Show the status of the current multi-agent session.

**Output Format**:
```markdown
## Delegation Status

**Mode**: x{N} | Single Agent
**Active Agents**: {list}

### Agent Statuses

| Agent | Tier | Task | Status      | Last Updated |
| ----- | ---- | ---- | ----------- | ------------ |
| ...   | ...  | ...  | ⏳/✅/⚠️/❌ | ...          |

### Review Chain

| Source | Reviewer | Status   |
| ------ | -------- | -------- |
| ...    | ...      | ⏳/✅/⚠️ |

### Context Window Dashboard

| Agent | Tier | Platform Overhead | Skills Loaded | Work Tokens Used | Budget Remaining | Utilization |
| ----- | ---- | ---------------- | ------------- | --------------- | --------------- | ----------- |
| ...   | ...  | ~10K             | 3 (~4K)       | 8K              | 7K / 15K       | 53%         |

**Total Session Tokens**: ~{N}K estimated / ~{N}K actual
**Budget Health**: 🟢 On Track | 🟡 Approaching Limit | 🔴 Over Budget

### Cost Summary

- Tier 1 — Principal ($$$$$): {n} tasks
- Tier 1.5 — Staff Engineer ($$$$): {n} tasks
- Tier 2 — MidCoder ($$$): {n} tasks
- Tier 2.5 — Lead Analyst ($$): {n} tasks
- Tier 3 — Analyst ($): {n} tasks
```

---

## /architect — Direct Architecture Task

Assign an architecture task directly to PrincipalAlpha without needing the xN parameter.

**Usage**:
```
/architect Set up hexagonal architecture for the project
/architect Design the domain model for the auth module
/architect Refactor the API layer
```

> **Orchestrator Bypass**: This command sends tasks directly to PrincipalAlpha, bypassing the Orchestrator. The Orchestrator's delegation overhead is unnecessary when only one Principal-level task is needed. No xN parameter should be used with this command.

---

## /resume — Continue Previous Work

Resume work from the last saved state. Reads the active plan and session history to determine what to do next.

**Usage**:
```
/resume                  → Resume the active plan from where it stopped
/resume TASK-003         → Resume a specific task
```

**Steps**:
1. Read `.github/todo/active-plan.md` to find pending tasks.
2. Read the most recent session file from `.github/memory/sessions/`.
3. Determine the next task based on dependency graph and priority.
4. Display the resume summary to the user.
5. Ask for confirmation, then begin executing the next task.

**Resume Summary Format**:
```markdown
## Resume Summary

**Previous Session**: {date} — {mode}
**Last Completed**: TASK-{NNN} ({title})
**Remaining Tasks**: {N} tasks, ~{N}K estimated tokens

### Pending Tasks

| ID       | Title | Tier | Est. Tokens | Dependencies             |
| -------- | ----- | ---- | ----------- | ------------------------ |
| TASK-003 | ...   | T1.5 | ~15K        | TASK-001 ✅, TASK-002 ✅ |

### Recommended Next Action

Start with **TASK-{NNN}** — all dependencies are satisfied.
```

---

## /history — Session History

View past session summaries, decisions, and changes.

**Usage**:
```
/history           → Show last 3 sessions
/history 5         → Show last 5 sessions
/history all       → Show all session summaries
```

**Steps**:
1. Read session files from `.github/memory/sessions/` (sorted by date, newest first).
2. Read `.github/memory/history/archive.md` for older sessions (if requested).
3. Present a consolidated timeline.

**Output Format**:
```markdown
## Session History

### Most Recent: {date} — {mode} — {status}

**Summary**: {session summary}
**Decisions**: {key decisions}
**Changes**: {N} files modified
**Open Items**: {N} pending

---

### {date} — {mode} — {status}

**Summary**: {session summary}
**Changes**: {N} files modified
```

**Use Cases**:
- New developer onboarding — understand what has been done and what's pending.
- Context recovery — after a break, quickly catch up on project state.
- Decision audit — review past architectural and technical decisions.

---

## /create-agent — Scaffold New Agent

Create a new agent definition file from the standard template. This command guides the user through agent creation with sensible defaults.

**Usage**:
```
/create-agent MehmetYilmaz
/create-agent MehmetYilmaz --tier T2
/create-agent MehmetYilmaz --tier T1.5 --skills "clean-code,backend-development"
```

**Steps**:
1. Validate the agent name follows PascalCase convention.
2. Check if an agent with the same name already exists in `.github/agents/`.
3. Determine the tier (ask if not provided via `--tier`).
4. Determine the skills (suggest defaults based on tier if not provided via `--skills`).
5. Generate the agent file using the template from `agent-scaffolding.instructions.md`.
6. Validate the generated file against the agent definition schema.
7. Update `orchestrator.agent.md` to include the new agent in the `agents:` list.
8. Report the created file path and next steps to the user.

**Agent File Template**:
```markdown
---
name: {AgentName}
description: >
  {Role description based on tier}
tools:
  - {tools based on tier}
model: "{model based on tier}"
modelFallback: "{fallback model based on tier}"
---

# {Agent Display Name} — {Role Title}

{Instructions based on tier reference file}
```

**Tier Defaults**:

| Tier | Tools | Model | Skills (Default) |
|------|-------|-------|-----------------|
| T1   | edit, read, search, agent, fetch | Claude Opus 4.6 | clean-code, code-review, code-architecture |
| T1.5 | edit, read, search, fetch | Claude Sonnet 4.6 | clean-code, implementation, code-review |
| T2   | edit, read, search | GPT-5.3-Codex | clean-code, implementation |
| T2.5 | edit, read, search, fetch | Gemini 3.1 Pro (Preview) | analysis, code-review |
| T3   | edit, read, search, fetch | Gemini 3 Flash | analysis |
