# Delegation Rules

## xN Parameter Distribution Table

The `xN` parameter appended to the end of the user's prompt determines the number of agents and tier distribution.

### Fixed Distributions

> **Canonical Source**: The table below is the authoritative reference for x3, x5, x7, and x10 distributions. The Edge Case Handling section defines additional fixed distributions for x2 and x4. The dynamic formula applies only to values not covered by either table. When the formula and any fixed table conflict, the table wins.

| Parameter | Total | T1 Principal | T2 Staff Eng | T3 MidCoder | T4 Lead Analyst | T5 Analyst |
| --------- | ----- | ------------ | -------------- | ----------- | ----------------- | ---------- |
| `x3`      | 3     | 1            | 1              | 0           | 0                 | 1          |
| `x5`      | 5     | 1            | 1              | 1           | 1                 | 1          |
| `x7`      | 7     | 1            | 2              | 1           | 1                 | 2          |
| `x10`     | 10    | 2            | 2              | 2           | 1                 | 3          |

### Dynamic Distribution (values other than x3, x5, x7, x10)

Proportional distribution for N value:

- **Tier 1 (Principal)**: ~15% (always at least 1)
- **Tier 2 (Staff Engineer)**: ~20% (always at least 1)
- **Tier 3 (MidCoder)**: ~20% (always at least 1 when N >= 5)
- **Tier 4 (Lead Analyst)**: ~10% (always at least 1 when N >= 5)
- **Tier 5 (Analyst)**: ~35% (remainder)

Example: `x8` → 1 Principal + 2 Staff Eng + 2 MidCoder + 1 Lead Analyst + 2 Analyst

### Distribution Validation Rules

#### Boundary Constraints

| Tier              | Minimum           | Maximum                    |
| ----------------- | ----------------- | -------------------------- |
| T1 Principal      | 1                 | round(max(1, N × 0.20))   |
| T2 Staff Eng    | 1                 | round(max(1, N × 0.25))   |
| T3 MidCoder       | 0 (N<5) / 1 (N≥5) | round(max(1, N × 0.25))   |
| T4 Lead Analyst | 0 (N<5) / 1 (N≥5) | 1                          |
| T5 Analyst        | 1                 | remainder                  |

#### Edge Case Handling

| Input  | Resolution                                                                                                                 |
| ------ | -------------------------------------------------------------------------------------------------------------------------- |
| `x1`   | Single agent mode — no multi-agent                                                                                         |
| `x2`   | 1 Principal + 1 Analyst                                                                                                    |
| `x4`   | **Canonical**: 1 Principal + 1 Staff Eng + 1 MidCoder + 1 Analyst (no Lead Analyst — analyst output is reviewed by Staff Engineer, the next higher available tier). The dynamic formula may produce a different result; this table wins. |
| N > 10 | Cap at x10 — warn user that current agent definitions support max 10 agents (2P + 2SE + 2MC + 1LA + 3A). Values above x10 require additional agent file definitions. |
| N = 0  | Ignore — treat as no parameter                                                                                             |
| N < 0  | Ignore — treat as no parameter                                                                                             |

#### Validation Formula

```
T1  = max(1, round(N × 0.15))
T2  = max(1, round(N × 0.20))
T3  = N >= 5 ? max(1, round(N × 0.20)) : 0
T4  = N >= 5 ? 1 : 0
T5  = N - T1 - T2 - T3 - T4

Assertion: T1 + T2 + T3 + T4 + T5 == N
```

#### Distribution Examples

| xN    | T1  | T2 | T3  | T4 | T5  | Total |
| ----- | --- | ---- | --- | ---- | --- | ----- |
| `x4`  | 1   | 1    | 1   | 0    | 1   | 4     |
| `x6`  | 1   | 1    | 1   | 1    | 2   | 6     |
| `x8`  | 1   | 2    | 2   | 1    | 2   | 8     |
| `x9`  | 1   | 2    | 2   | 1    | 3   | 9     |
| `x10` | 2   | 2    | 2   | 1    | 3   | 10    |

### Without Parameter

If the `xN` parameter is not provided, multi-agent mode is **not activated**.
Standard operation with a single agent (default model — Claude Opus 4.6).

---

## Cost Optimization

### Tier Cost Comparison

| Tier     | Model                    | Relative Cost | Capability                              |
| -------- | ------------------------ | ------------- | --------------------------------------- |
| Tier 1   | Claude Opus 4.6          | $$$$$         | Architecture, review, final authority   |
| Tier 2   | Claude Sonnet 4.6        | $$$$          | All coding tasks, Staff Engineer review |
| Tier 3   | GPT-5.3-Codex            | $$$           | Simple coding, boilerplate              |
| Tier 4 | Gemini 3.1 Pro (Preview) | $$            | Analyst output review, consolidation    |
| Tier 5   | Gemini 3 Flash           | $             | Analysis, research, documentation       |

### Distribution Principles

1. **Cost-sensitive tasks go down**: Analysis, research, doc reading → Tier 5
2. **Productive tasks go to the middle**: Simple coding, utility, test → Tier 3
3. **Complex coding goes to Staff Engineer**: Feature implementation, complex logic → Tier 2
4. **Critical decisions go up**: Architecture, final review → Tier 1
5. **Analysis review goes to Lead Analyst**: Analyst output consolidation → Tier 4
6. **Repetitive tasks go down**: Multi-file generation with similar structure → Tier 3/5

### Task Assignment Matrix

| Task Type                      | Assigned Tier | Rationale                               |
| ------------------------------ | ------------- | --------------------------------------- |
| Architecture design            | Tier 1        | Critical decision, high-level knowledge |
| Final code review              | Tier 1        | Quality gate, final authority           |
| Complex feature implementation | Tier 2        | Primary coding agent                    |
| Complex algorithm              | Tier 2        | High accuracy coding                    |
| API endpoint implementation    | Tier 3        | Templated work, medium complexity       |
| Utility function               | Tier 3        | Simple, repetitive                      |
| Component scaffolding          | Tier 3        | Boilerplate generation                  |
| Analyst output review          | Tier 4        | Lead Analyst consolidation (writes to `.github/analysis/consolidated/`) |
| Dependency analysis            | Tier 5        | Research, writes raw report to `.github/analysis/raw/` |
| Codebase mapping               | Tier 5        | Analysis, writes raw report to `.github/analysis/raw/` |
| Document reading/summarizing   | Tier 5        | Low complexity                          |
| Test scenario generation       | Tier 5        | Analysis-based                          |
| Performance profiling          | Tier 5        | Research                                |
| Spring Boot service implementation | Tier 2    | Complex domain logic, backend integration   |
| Spring Boot entity/DTO creation | Tier 3       | Boilerplate-heavy, templated            |
| Backend security audit         | Tier 5        | Analysis, writes raw report to `.github/analysis/raw/` |
| Frontend-backend contract alignment | Tier 3   | Templated, well-documented              |
| Java quality gate setup        | Tier 3        | Maven plugin configuration              |
| Code review (Tier 3 output)    | Tier 2        | Staff Engineer reviews MidCoder         |
| Code review (Tier 2 output)    | Tier 1        | Principal reviews Staff Engineer        |
| Code review (Tier 5 output)    | Tier 4        | Lead Analyst reviews Analyst            |

---

## Orchestrator Behavior Rules

### Task Division

1. Analyze the incoming prompt — what sub-tasks can it be divided into?
2. Evaluate the complexity of each sub-task.
3. Determine the tier according to the task assignment matrix.
4. Run independent tasks in parallel, dependent tasks sequentially.

### Agent Selection

- In `x10` mode with 2 Principals, distribute architecture tasks evenly between them.
- In `x7`/`x10` mode with 2 Staff Engineers, distribute coding tasks evenly between them.
- In `x5` mode with 1 Principal, all Tier 1 tasks go to that agent.
- Lead Analyst is always a single agent — no parallel Lead Analysts.
- Balance workload when assigning tasks to agents within the same tier.

### Merit-Based Display Name Selection

When the Orchestrator assigns display names at session start (Step 0.5), it uses score-weighted random selection from the name pool:

1. **Read scores**: Load cumulative scores from `.github/metrics/leaderboard.md`.
2. **Calculate weights**: For each name, `weight = max(score + 101, 1)`. This ensures even the lowest-scoring names retain minimal selection probability.
3. **Apply tier multipliers**: Performance tiers provide additional selection advantage:
   - **S-Tier** (50+ points): weight x 2.0
   - **A-Tier** (20-49 points): weight x 1.5
   - **B-Tier** (0-19 points): weight x 1.0 (baseline)
   - **C-Tier** (-20 to -1 points): weight x 0.8
   - **D-Tier** (below -20 points): weight x 0.5
4. **Select without replacement**: Pick 10 names for 10 agent slots using weighted random selection. Each name can only be used once per session.
5. **Record selections**: Log name-to-slot assignments in the session file.

See `dynamic-naming.instructions.md` for the full protocol and scoring criteria.

### Result Collection

1. Collect results when all agents have completed their tasks.
2. Start the review chain — from bottom to top.
3. Present the final output to the user once all reviews are completed.
4. Summarize what each agent did in the output (transparency).

### Optimal Task Sizing

- Each sub-task should target a **single deliverable** (one file, one module, one report).
- If a sub-task requires editing more than 3 files, consider splitting it further.
- Analysis tasks: scope to one concern (e.g., "dependency audit" not "full codebase analysis").
- Coding tasks: scope to one feature or one module boundary.
- If estimated token cost exceeds 15K for a sub-task, the Orchestrator must split before assigning.

---

## Task Dependency Graph (DAG)

The Orchestrator constructs a Directed Acyclic Graph (DAG) before dispatching tasks. This ensures correct execution order and maximizes parallelism.

### DAG Construction Protocol

1. **List all sub-tasks** from the decomposed prompt.
2. **Identify dependencies**: For each sub-task, determine which other sub-tasks must complete first.
3. **Build the graph**: Each node is a sub-task; each edge represents a "depends-on" relationship.
4. **Validate acyclicity**: If a cycle is detected, the Orchestrator must restructure tasks to break the cycle.
5. **Identify parallel groups**: Sub-tasks with no unresolved dependencies can run concurrently.

### DAG Notation

Use the following format in task plans:

```
TASK-001 (T5, ~3K) → [no dependencies — can start immediately]
TASK-002 (T5, ~3K) → [no dependencies — can start immediately]
TASK-003 (T2, ~12K) → depends on: TASK-001, TASK-002
TASK-004 (T3, ~8K) → depends on: TASK-003
TASK-005 (T1, ~10K) → depends on: TASK-003
TASK-004, TASK-005 → [parallel group — no mutual dependency]
```

### Execution Waves

The Orchestrator groups tasks into execution waves based on the DAG:

| Wave | Tasks | Execution Mode | Gate |
|------|-------|---------------|------|
| Wave 1 | All root nodes (no dependencies) | Parallel | — |
| Wave 2 | Tasks whose dependencies completed in Wave 1 | Parallel | Wave 1 complete |
| Wave 3 | Tasks whose dependencies completed in Wave 2 | Parallel | Wave 2 complete |
| ... | Continue until all tasks are dispatched | ... | ... |

### DAG Validation Rules

1. **No orphan tasks**: Every task must appear in the graph.
2. **No cycles**: The graph must be a valid DAG — topological sort must succeed.
3. **Minimize critical path**: When splitting tasks, prefer splits that reduce the longest dependency chain.
4. **Review dependencies**: Review tasks implicitly depend on the coding tasks they review (auto-added by Orchestrator).
5. **Cross-tier dependencies**: Analysis tasks (T5) that feed into coding tasks (T3/T2) must complete in an earlier wave.
