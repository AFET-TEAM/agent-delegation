# Dynamic Agent Naming Protocol

> Instruction file for the dynamic name assignment system.
> Canonical source: `.github/config/name-pool.md`

---

## 1. Overview

Agent display names are **not fixed**. Each session, the Orchestrator assigns display names from a pool of 20 names to 10 agent slots. Only `VarolMaksutoglu` (Orchestrator) has a permanent name.

Agent YAML `name` fields use **role-based identifiers** (e.g., `PrincipalAlpha`, `StaffEngineerBeta`) that are stable across sessions. Display names are session-scoped personas assigned from the name pool.

---

## 2. Role-Based Agent Identifiers (Stable)

| YAML Name | File | Tier | Role |
|-----------|------|------|------|
| VarolMaksutoglu | orchestrator.agent.md | Orchestrator | Teknik Koordinator (FIXED) |
| PrincipalAlpha | principal-alpha.agent.md | T1 | Bas Yazilim Mimari |
| PrincipalBeta | principal-beta.agent.md | T1 | Kidemli Yazilim Mimari |
| StaffEngineerAlpha | staff-engineer-alpha.agent.md | T1.5 | Kidemli Yazilim Muhendisi |
| StaffEngineerBeta | staff-engineer-beta.agent.md | T1.5 | Yazilim Muhendisi |
| MidCoderAlpha | mid-coder-alpha.agent.md | T2 | Yazilim Gelistirici |
| MidCoderBeta | mid-coder-beta.agent.md | T2 | Yazilim Gelistirici |
| LeadAnalyst | lead-analyst.agent.md | T2.5 | Kidemli Sistem Analisti |
| AnalystAlpha | analyst-alpha.agent.md | T3 | Sistem Analisti |
| AnalystBeta | analyst-beta.agent.md | T3 | Guvenlik ve Performans Analisti |
| AnalystGamma | analyst-gamma.agent.md | T3 | Test ve Kalite Analisti |

---

## 3. Name Assignment Protocol (Orchestrator Step 0.5)

The Orchestrator performs name assignment **after PCD scan (Step 0) and before PEP (Step 1.5)**:

### Step 0.5: Dynamic Name Assignment

1. **Read** `.github/config/name-pool.md` — extract all active names and scores
2. **Read** `.github/metrics/leaderboard.md` — cross-reference current rankings
3. **Calculate weights** using the Score-Weighted Selection Algorithm:
   ```
   base_weight = max(score + 101, 1)
   tier_modifier = Performance Tier modifier (S=2x, A=1.5x, B=1x, C=0.75x, D=0.5x)
   final_weight = base_weight * tier_modifier
   ```
4. **Assign names** to 10 agent slots via weighted random selection (no repeats)
5. **Record assignments** in session file and announce in task distribution
6. **Use assigned names** in all agent communication for the session

### Assignment Announcement Format

```markdown
## Session Name Assignments

| Slot | Display Name | Score | Tier |
|------|-------------|-------|------|
| PrincipalAlpha | [Assigned Name] | [Score] | [S/A/B/C/D] |
| ... | ... | ... | ... |
```

---

## 4. Agent Obligations

### All Agents (except Orchestrator)

- **Use your assigned display name** in all output (task reports, review comments, escalation messages)
- **Do NOT use your YAML role identifier** in user-facing output — always use the display name
- **Your display name is communicated** by the Orchestrator at task assignment
- **Include your display name** in the Output Format Template: `## [Display Name] — Task Report`

### Orchestrator

- **Perform Step 0.5** at session start before any task distribution
- **Include name assignments** in the session file
- **Update scores** at session end based on task outcomes
- **Update leaderboard** with new rankings

---

## 5. Performance Scoring Protocol (Session End)

At session end, the Orchestrator evaluates each agent's performance and updates scores:

### 5.1 Evaluation Criteria

For each agent that participated in the session:

1. **Task Completion**: Did the agent complete its assigned task?
   - Yes → +5 points
   - No (failed/incomplete) → -5 points

2. **Review Quality**: How many review rounds were needed?
   - First-pass approval → +3 points
   - Second-pass (1 revision) → +1 point
   - Third-pass+ (2+ revisions) → -3 points

3. **Analysis Quality** (Analysts only): Did the agent identify significant findings?
   - P0/P1 finding identified → +4 points per finding
   - False positive reported → -2 points per false positive

4. **Autonomy**: Did the agent escalate unnecessarily?
   - No escalation needed → +0 (neutral)
   - Necessary escalation → +0 (neutral)
   - Unnecessary escalation → -2 points

5. **Fallback**: Was a model fallback activated?
   - No → +0 (neutral)
   - Yes → -1 point

### 5.2 Score Update Process

1. Calculate total points for each participating name
2. Update score in `.github/config/name-pool.md`
3. Update session count in name-pool.md
4. Add entry to `.github/metrics/leaderboard.md` scoring events log
5. Recalculate rankings in leaderboard
6. Determine MVP and Needs Improvement for session summary

### 5.3 Session Performance Report

At session end, the Orchestrator generates and displays a performance table:

```markdown
## Session Performance Report

| Slot | Display Name | Tasks | Review Rounds | Findings | Points | Score |
|------|-------------|-------|---------------|----------|--------|-------|
| PrincipalAlpha | [Name] | 2/2 | 1.0 avg | — | +8 | 8 |
| AnalystAlpha | [Name] | 1/1 | — | 3 P1 | +17 | 17 |
| ... | ... | ... | ... | ... | ... | ... |

**MVP**: [Name] (+17 points) | **Needs Improvement**: [Name] (-3 points)
```

---

## 6. Merit-Based Agent Selection

When the Orchestrator selects which agent slots to activate for a task (via delegation-rules.instructions.md), the **name assigned to the slot influences task assignment priority**:

### Selection Priority Rules

1. **For critical tasks** (architecture decisions, P0 fixes): Assign to slots whose current display name has the **highest score** in the relevant tier
2. **For standard tasks**: Use normal delegation rules — name score does not affect slot selection
3. **For training/growth tasks** (simple features, documentation): Prefer slots whose current display name has **lower scores** — gives struggling names opportunity to earn points
4. **Tie-breaking**: When two slots at the same tier are equally qualified, prefer the slot whose display name has the higher score

### Competition Culture

- The leaderboard is visible to all agents (any agent can read `.github/metrics/leaderboard.md`)
- Session performance reports highlight MVP and Needs Improvement
- Names in S-tier (score 50+) receive a special designation in the session banner
- Names in D-tier (score -50 or below) receive a warning notice

---

## 7. Cross-Reference

- **Name Pool**: `.github/config/name-pool.md`
- **Leaderboard**: `.github/metrics/leaderboard.md`
- **Delegation Rules**: `.github/instructions/reference/delegation-rules.instructions.md`
- **Orchestrator Protocol**: `.github/agents/orchestrator.agent.md` (Step 0.5)
- **Agent Lifecycle Hook**: `.github/hooks/agent-lifecycle.json` (banner display)
- **System Validation**: `.github/instructions/reference/system-validation.instructions.md` (Rule 11)
