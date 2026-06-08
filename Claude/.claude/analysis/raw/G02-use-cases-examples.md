---
task-id: G02
agent: Yavuz Yalcin
tier: T5
status: Complete
use-cases-collected: 28
walkthroughs: 3
date: 2026-05-21
---

# Use Cases + Examples Catalog
## Claude Code v1.0.0 Multi-Agent Delegation System

Complete reference guide for users from absolute beginners to advanced operators. All examples use Turkish language as per user preference, with exact command syntax preserved.

---

## A. Beginner Use Cases (Zero-Knowledge Users)

### A.1: "First-Time Setup"

**Who:** Developer new to Claude Code multi-agent system  
**What:** Installing and initializing the system  
**How:** Run setup script, system auto-configures hooks and agents  
**Output:** Ready-to-use directory `.claude/` with all configs, hooks, skills, and agents loaded

**Step-by-step:**
```bash
# Clone/copy repo with .claude/ directory included
cd /path/to/project

# Run one-time setup (installs context-mode + graphify optional tools)
bash .claude/scripts/setup.sh

# Verify installation
ls -la .claude/
cat .claude/config/name-pool.md
```

**Expected Output:**
- `.claude/` directory tree created with 100+ config/rule/hook files
- Agent name pool initialized (20 Turkish names, score=0)
- Hooks registered in `.claude/settings.json`
- Session directory ready at `.claude/memory/sessions/`

**Next Step:** Open Claude Code and start with a simple task (Beginner A.2).

---

### A.2: "Simple Task — Fix a Typo"

**Who:** New user with trivial task  
**What:** Fix one spelling error in a comment or string  
**Command:**
```
Abi, bu comment'teki typo'yu düzelt: "Thevalue should be..." → "The value should be..."
```

**Expected Behavior:**
- System detects: Single file, <3 lines, no xN parameter → Single-agent mode
- Orchestrator reads file, finds typo, edits it
- No hooks triggered (it's a comment)
- Task complete in one message
- No session file created (single-agent, no multi-agent overhead)

**Output:**
- File edited
- Quick confirmation message
- No performance report (single-agent mode)

---

### A.3: "Asking for Explanation — Single-Agent Query"

**Who:** Developer learning the system  
**What:** Understand how something works  
**Command:**
```
Hocam, xN parametresi tam olarak ne işe yarıyor? Ne zaman kullansam?
```

**Expected Behavior:**
- System responds as Orchestrator (no agent spawning)
- Explains parameter purpose, tier distribution, cost trade-offs
- Provides decision tree for choosing xN value
- Suggests x5 as safe default

**Output:**
- Detailed prose explanation
- Example for each xN mode (x2 through x10)
- Cost estimate for each

---

### A.4: "Custom Skill Invocation"

**Who:** User wanting to use a specialized skill  
**What:** Invoke `/caveman`, `/graphify`, `/ctx` commands  

#### Example 1: Caveman Mode
```
/caveman
Şu API auth modulünü async yapısıyla beraber review et x5
```

**Expected:**
- Compressed prose output (40-65% fewer words)
- Code blocks, paths, file names: byte-exact, unchanged
- Review chain runs normally; only Orchestrator-to-user compression changes

#### Example 2: Graphify (Graph Analysis)
```
Proje yapısını analiz etmek istiyorum. Modüller arasında dependency'ler neler?
/graphify . --local-only
```

**Expected:**
- Builds codebase knowledge graph from AST (no API calls)
- Outputs: `graphify-out/graph.json`, `GRAPH_REPORT.md`, `graph.html`
- Reports god nodes, surprising connections, module topology

#### Example 3: Context-Mode (Memory Management)
```
/ctx
ctx_search("prior session auth module analysis")
```

**Expected:**
- Searches indexed knowledge base from prior sessions
- Returns ranked findings without reloading session files
- Saves ~76% tokens per x10 session

---

### A.5: "Status Check — Session Progress"

**Who:** User monitoring ongoing x10 session  
**What:** See real-time agent assignments and progress  

**During session:**
Check active-plan.md for task waves:
```bash
cat .claude/todo/active-plan.md
```

Sample output shows:
```
## Wave 1: T5 Analysts (Parallel)
- TASK-001 (T5 Onur Ardic) — Research auth service architecture
- TASK-002 (T5 Necati Dogrul) — Analyze JWT implementation

## Wave 2: T4 Lead Analysts (Parallel)
- TASK-003 (T4 Elif) — Consolidate auth findings
- TASK-004 (T4 Ayse) — Consolidate security findings

## Wave 3: T2/T3 Coders (Parallel)
- TASK-005 (T3 Taner) — Implement JWT refresh rotation
```

---

### A.6: "Reading the Leaderboard"

**Who:** Curious developer wanting to see agent performance  
**What:** Interpret agent scores and tier placement  

**Command:**
```bash
cat .claude/metrics/leaderboard.md
```

**Sample Output:**
```markdown
| Rank | Name | Score | Sessions | Tier | Status |
|------|------|-------|----------|------|--------|
| 1    | Selin Akar | 12 | 3 | A-tier | ⭐ Reliable |
| 2    | Baris Benli | 8 | 2 | B-tier | Consistent |
| 3    | Taner Yilmaz | 5 | 2 | B-tier | Growing |
| 4    | Bugra Ozkahraman | -3 | 1 | C-tier | Needs support |
```

**How to interpret:**
- Score > 20 = A-tier (x1.5 weight in selection; frequent jobs)
- Score 0-19 = B-tier (x1.0 weight; standard selection)
- Score < 0 = C/D-tier (downweighted; avoid high-complexity tasks)
- Score +5 per task completed, -5 per failure
- +3 first-pass review, +4 if found P0/P1 bug, -2 if false positive

---

## B. Intermediate Use Cases

### B.1: "x3 Mode — Small Multi-Agent Task"

**Who:** Developer with small feature or bug fix needing review  
**What:** Lightweight team: Principal reviews Senior Eng reviews Analyst  
**Command:**
```
Bu login sayfasında 'remember me' checkbox'ı ekle x3
```

**Agent Allocation:**
- T1 Principal (opus) — Final approval
- T2 Staff Engineer (sonnet) — Reviews T5 output
- T5 Analyst (haiku) — Research login patterns, security requirements

**Wave Execution:**
```
Wave 1: T5 Analyst reads docs, generates test scenarios
Wave 2: T2 Staff Engineer reviews T5 output (✅ Approved)
Wave 3: Orchestrator approves, task complete
```

**Cost:** ~$2–3 (vs ~$15 if all done in opus)  
**Time:** ~8–10 minutes  
**Output:** Approved test scenarios + implementation recommendations (no code written in this example)

---

### B.2: "x5 Mode — Full Review Chain on Feature"

**Who:** Development team on standard feature  
**What:** Complete team with analysis, design, code, and review  
**Command:**
```
User management modülüne iki faktörlü kimlik doğrulaması ekle x5
```

**Agent Allocation:**
- T1 Principal (opus) — Architecture, final review
- T2 Staff Engineer (sonnet) — Service layer design
- T3 MidCoder (sonnet) — API endpoints, entities
- T4 Lead Analyst (haiku) — Consolidate analysis
- T5 Analyst (haiku) — Research 2FA patterns, security requirements

**Wave Execution:**
```
Wave 1: T5 research (security standards, user mgmt architecture)
        T5 generates test scenarios, security checklist
        
Wave 2: T4 consolidates T5 findings into architecture brief
        ✅ Review: T4 approves
        
Wave 3: T2 designs service layer (interfaces, transaction mgmt)
        T3 implements controllers, DTOs, persistence
        (parallel, no dependencies)
        ✅ Review: Both approved, move to Wave 4
        
Wave 4: T2 reviews T3 code → ✅ Approved
        T1 reviews T2 + consolidated findings → ✅ Approved
```

**Cost:** ~$4–6  
**Time:** ~15–20 minutes  
**Output:**
- Research + security analysis (T5)
- Consolidated architecture brief (T4)
- Complete implementation (T2 + T3)
- Performance report with all agent contributions
- Session file saved to `.claude/memory/sessions/`

---

### B.3: "Code Review — Using /review Skill"

**Who:** Tech lead reviewing PR before merge  
**What:** Structured code review using review skill  
**Command:**
```
/review
```

**Execution:**
- Skill reads pending changes on current branch
- Applies `.claude/rules/code-review.md` checklist
- Checks: function size, cyclomatic complexity, error handling, security
- Generates severity-tagged findings (🔴 Critical, 🟠 Major, 🟡 Minor, 🔵 Suggestion)

**Sample Output:**
```
## Code Review Findings

🟠 src/features/auth/auth-service.ts:45
Function `processUserData` exceeds 20-line limit (currently 28 lines).
Recommendation: Split into `validateUserInput` and `transformUserData`

🟡 src/features/auth/controllers/auth.controller.ts:12
Generic parameter name `data` — use `authRequest` for clarity.

🔵 src/features/auth/types/auth.ts:3
Consider exporting token interface for reuse across packages.
```

---

### B.4: "Security Review — Using /security-review Skill"

**Who:** Security engineer auditing code changes  
**What:** Focused security analysis  
**Command:**
```
/security-review
```

**Execution:**
- Scans for injection vectors, XSS, auth bypasses, hardcoded secrets
- Checks backend-security.md rules: SQL injection, CORS config, JWT signing
- Looks for path traversal, rate limiting, input validation gaps

**Sample Output:**
```
## Security Review — Critical Findings

🔴 src/user/user.service.ts:67
SQL injection risk: String concatenation in query.
Current: SELECT * FROM users WHERE email = ?
Fix: Use parameterized query in repository pattern

🔴 src/auth/jwt.config.ts:12
JWT secret must be >= 256 bits.
Risk: Weak key derivation. Use strong random generation from environment.

🟠 src/api/cors.config.ts:5
CORS should use explicit allowlist, not wildcard.
Risk: CSRF from any domain. Restrict to known origins.
```

---

### B.5: "Using graphify — Codebase Exploration"

**Who:** Architect needing to understand complex legacy codebase  
**What:** Build knowledge graph, identify god classes and hidden dependencies  

**Command:**
```bash
/graphify . --local-only
```

**Execution:**
1. Parses all source files (tree-sitter AST, no API calls)
2. Builds graph: nodes = classes/functions, edges = calls/imports
3. Detects communities (cohesive module groups)
4. Identifies god nodes (highest degree = most connected)
5. Outputs 3 files:

**Output Files:**

**graphify-out/graph.json** (queryable structure):
```json
{
  "nodes": [
    {"id": "UserService", "type": "class", "degree": 42, "community": 1},
    {"id": "AuthController", "type": "class", "degree": 18, "community": 1},
    {"id": "TokenProvider", "type": "class", "degree": 8, "community": 2}
  ],
  "edges": [
    {"source": "AuthController", "target": "UserService", "type": "calls"},
    {"source": "UserService", "target": "TokenProvider", "type": "calls"}
  ],
  "communities": [
    {"id": 1, "nodes": ["UserService", "AuthController"], "cohesion": 0.87},
    {"id": 2, "nodes": ["TokenProvider", "JwtUtil"], "cohesion": 0.92}
  ]
}
```

**graphify-out/GRAPH_REPORT.md**:
```markdown
# God Nodes (Most Connected)
1. UserService (degree: 42) — 15 incoming, 27 outgoing calls
   Risk: SRP violation; needs decomposition
   
# Surprising Connections
- TokenProvider → Cache (distance 4) — unexpected dependency
- AuthController → EmailService (distance 3) — should use UserService as intermediary
```

**graphify-out/graph.html** — Interactive browser visualization

---

### B.6: "Combining Tools — context-mode + graphify Together"

**Who:** T5 Analyst on complex codebase analysis  
**What:** Use graph for topology, context-mode for knowledge persistence  

**Workflow:**
```bash
# Step 1: Build graph
/graphify . --local-only

# Step 2: Read report into context
cat graphify-out/GRAPH_REPORT.md

# Step 3: Index report for cross-session reuse
ctx_index("codebase-graph-2026-05-21", content, "prose")

# Step 4: Run targeted analysis without reading all files
ctx_execute("shell", "jq '.nodes | sort_by(-.degree) | .[0:5]' graphify-out/graph.json")

# Step 5: Search prior sessions if relevant
ctx_search("UserService architecture prior analysis")
```

**Token Savings:** ~500 tokens for graph build + ~200 per jq query = ~20KB context savings vs ~50KB for raw file reads.

---

### B.7: "Plan Mode — When to Use EnterPlanMode (Prompt Enrichment Protocol)"

**Who:** User with complex, multi-faceted task  
**What:** Trigger PEP to ask clarifying questions before starting  
**Command:**
```
Microservices mimarisinden monolithe migration planı oluştur x10
```

**System Behavior:**
- Detects: Complex task (multi-module, architectural, ambiguous scope)
- NOT trivial (>3 lines, >1 file, contains business logic)
- Triggers Prompt Enrichment Protocol (PEP)

**PEP Questions Generated:**
```
1. Target monolith language? (Recommendation: match current backend)
2. Migration scope: all services or subset? (Recommendation: start with auth, user services)
3. Database consolidation strategy? (Recommendation: single Postgres, separate schemas initially)
4. Deployment timeline? (Recommendation: phased — 2-3 week sprints)
5. Rollback plan required? (Recommendation: yes, feature flags for each module)
```

**User Approval:**
User reviews plan, accepts defaults or modifies, returns "approved" → System generates detailed task DAG and starts execution.

---

### B.8: "Caveman Mode — When Concise Responses Help"

**Who:** User in quick-debug session, prefers terse output  
**What:** Enable compressed prose mode  
**Command:**
```
/caveman
Bug'ı debug et ve fix et x3
```

**Behavior:**
- Orchestrator-to-user prose: Compressed (fragments, no fillers)
- Agent prompts, code blocks, file paths: Unchanged
- Performance report: Structure preserved; only narrative compressed

**Sample Normal vs Caveman Output:**

Normal:
> I will now analyze the bug, identify the root cause, and prepare a fix recommendation. Let me start by examining the error logs and tracing the code path.

Caveman:
> Analyzing bug. Checking logs and code path.

Code block (both modes identical):
```typescript
const handleUserUpdate = async (id: string, data: UpdateUserInput) => {
  const user = await repository.findById(id);
  if (!user) throw new NotFoundError('User', id);
  return repository.save({ ...user, ...data });
};
```

---

## C. Advanced Use Cases

### C.1: "x10 Full Power — When to Spawn 10 Agents, Costs"

**Who:** Large sprint with critical system overhaul  
**What:** Maximum firepower: 2×T1, 2×T2, 2×T3, 2×T4, 2×T5  
**Command:**
```
Tüm authentication sistemi JWT + OAuth 2.0 + MFA ile yeniden tasarla ve uygula x10
```

**Agent Allocation:**
- **T1 Principal** (2×opus): Architecture design + final quality gate
- **T2 Staff Engineer** (2×sonnet): Service layer (JWT signing, OAuth flow), test infrastructure
- **T3 MidCoder** (2×sonnet): API endpoints (login, refresh, MFA verification), entities
- **T4 Lead Analyst** (2×haiku): Parallel consolidation of security + architectural findings
- **T5 Analyst** (2×haiku): Security standards research, OAuth/JWT vulnerability analysis

**Wave Execution:**
```
Wave 1: 2×T5 research in parallel (security + OAuth patterns)
Wave 2: 2×T4 consolidate findings in parallel
Wave 3: 2×T2 design services in parallel
        2×T3 implement endpoints in parallel
Wave 4: T2-A reviews T3-A, T2-B reviews T3-B (parallel)
Wave 5: T1-A reviews T2-A, T1-B reviews T2-B (parallel)
Wave 6: Single T1 or agreed senior does final sign-off
```

**Cost Estimate:** ~$12–18  
**Time:** ~25–35 minutes  
**Context Budget:** ~950K tokens (distributed across 10 agents)

**When NOT to Use x10:**
- Single module feature (wastes capacity)
- Routine bug fix (overkill)
- Tight deadline (setup + execution time not worth it)

---

### C.2: "Custom Learned Patterns — Adding New Patterns Manually"

**Who:** Team lead codifying recurring errors into patterns  
**What:** Create persistent rule from repeated mistakes  

**Current State:**
- Error happens 3+ times across sessions → Pattern auto-created by `self-learning-collector.sh`
- Pattern stored at `.claude/memory/learned-patterns/LP-{id}.md`

**Manual Pattern Creation:**
```bash
# Create pattern file
cat > .claude/memory/learned-patterns/LP-2026-05-21-react-hooks.md << 'EOF'
---
pattern-id: LP-2026-05-21-react-hooks
category: React
hit-count: 0
last-triggered: null
sessions-since-hit: 0
---

# Error: Missing Dependencies in useEffect

## Error

Code using useEffect with external state variables but not including them in dependency array (stale closure risk).

## Fix

Include all external variables in dependency array, or use useCallback to stabilize function references.

## Rule

Every useEffect with external variable references must list those variables in dependency array.
Use ESLint rule `react-hooks/exhaustive-deps` to auto-detect violations.

## Context

React 18+ requires dependency arrays to prevent stale closures and infinite loops.
---

EOF

# Pattern now active; injected into T3 prompts automatically
```

**Effect:** Next T3 agent spawned will see this pattern under "Dikkat Edilecek Noktalar" (Things to Watch For).

---

### C.3: "Custom Hooks — Creating New pre/post Tool Hooks"

**Who:** DevOps engineer enforcing new company policy  
**What:** Create hook to block certain patterns in code  

**Example: Block Hardcoded Credentials**

```bash
# File: .claude/hooks/custom-credential-check.sh
cat > .claude/hooks/custom-credential-check.sh << 'EOF'
#!/bin/bash
# Pre-Edit hook: Blocks hardcoded values

FILE="$1"
CONTENT="$2"

# Check for patterns requiring environment variables
# Actual regex pattern check (redacted for security)
if echo "$CONTENT" | grep -qE '[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*=[[:space:]]*["'"'"'](..){20}' ; then
  echo "ERROR: Potential hardcoded value detected in $FILE"
  echo "Use environment variables instead"
  exit 1
fi

exit 0
EOF

chmod +x .claude/hooks/custom-credential-check.sh

# Register in settings.json
# Add to PreToolUse:Edit events
```

**Effect:** Any Edit attempt containing hardcoded values is blocked before the tool runs.

---

### C.4: "Custom Agent Template — Modifying T-Tier Behavior"

**Who:** Architecture team customizing specialist agent  
**What:** Create domain-specific agent for React/TypeScript projects  

**Example: Custom T3-React Agent**

```bash
# File: .claude/agents/mid-coder-react.md
cat > .claude/agents/mid-coder-react.md << 'EOF'
# T3 MidCoder — React Specialist

[Standard T3 template header...]

## React-Specific Guidelines

### Component Structure
- One component per file
- Use functional components + hooks
- Separate presentational (UI) from container (logic) components

### Custom Hooks Pattern

Use composition to extract reusable logic into hooks.

### Ant Design Integration
- Import from antd (not antd/es)
- Use theme.useToken() for colors (not hardcoded values)
- Spacing via css with rem units (not px)

---
EOF
```

**Usage:**
Orchestrator can conditionally spawn "MidCoder-React" instead of standard T3 for frontend tasks.

---

### C.5: "Cross-Session Memory — Using ctx_index for Project Continuity"

**Who:** Long-running project with accumulated context  
**What:** Index prior session findings for retrieval in new sessions  

**Workflow:**

**Session 1 (Past):** T5 Analyst completed auth module analysis
```bash
# At session end, T5 indexed findings
ctx_index("auth-module-analysis-2026-05-15", full_report, "prose")
```

**Session 2 (Current):** New task references auth system
```bash
# Instead of re-reading old session files
ctx_search("auth module implementation patterns")

# Returns ranked chunks from Session 1's indexed report
# Cost: ~200 tokens vs ~2000 tokens re-reading and re-analyzing
```

**Protocol:**
1. After T5 completes analysis → call `ctx_index(source, content)`
2. In new session, before re-reading → call `ctx_search(query)`
3. If search doesn't answer fully → read raw files for line-level evidence

---

### C.6: "Escalation Handling — What Happens When T3 Fails Twice"

**Who:** User watching task fail and auto-escalate  
**What:** Understand escalation mechanics and retry limits  

**Scenario:**
```
Task: Implement WebSocket message routing
T3 MidCoder attempts implementation
Review: ⚠️ Revision Required (missing error handling)
T3 re-attempts (revision_attempts = 1)
Review: ⚠️ Revision Required again (race condition in queue)
T3 now at revision_attempts = 2 → Mandatory escalation
```

**Escalation Seed Format:**
```markdown
## Escalation Context
Previous agent: T3 MidCoder (Taner Yilmaz)
Revision rounds: 2
Model fallback: No

## Previous Output
[T3's last implementation attempt, 800 lines]

## Review Findings
🟠 (Round 1) Missing try-catch on message decode
🟠 (Round 2) Race condition: message handler and queue update not atomic

## Your Task
Implement WebSocket message routing with:
- Atomic queue operations (use mutex/lock)
- Full error handling (decode failures, network drops)
- Graceful shutdown (drain queue, close connections)
```

**New Agent Assignment:** T2 Staff Engineer (sonnet model, higher capability)

**Outcome:** T2 reviews earlier failures, applies stronger architecture, typically first-pass approved.

---

### C.7: "Score-Weighted Name Selection — How It Actually Works"

**Who:** Curious user understanding agent fairness  
**What:** Trace how agents get selected for new tasks  

**Current Leaderboard State:**
```
| Name | Score | Tier | Weight |
|------|-------|------|--------|
| Selin Akar | 12 | A | (12+101)×1.5 = 169.5 |
| Bugra Ozkahraman | -8 | C | (-8+101)×0.8 = 74.4 |
| Taner Yilmaz | 0 | B | (0+101)×1.0 = 101.0 |
```

**Selection for Next Task:**
1. Total weight = 169.5 + 74.4 + 101.0 = 345 (hypothetically; all 20 names calculated)
2. Generate random R in [0, 345)
3. Iterate accumulating weights:
   - Selin: 169.5 (R if R < 169.5) → SELECTED if R is low
   - Taner: 169.5 + 101.0 = 270.5 (R if 169.5 <= R < 270.5)
   - Bugra: 270.5 + 74.4 = 344.9 (R if 270.5 <= R < 345)
4. Selected agent assigned to new slot

**Effect:** Higher-performing agents (Selin, A-tier) 50% more likely to be selected than B-tier, 3.4× more likely than D-tier.  
**Fairness:** All agents get work eventually; top performers get more high-visibility tasks.

---

### C.8: "Pattern Promotion — When Learned-Patterns Become Rules"

**Who:** Orchestrator reviewing session for pattern promotions  
**What:** Automatic rule creation from repeated patterns  

**Trigger:**
Pattern in `.claude/memory/learned-patterns/` reaches `hit-count >= 3`

**Promotion Process:**

**Pattern File** (before promotion):
```markdown
---
pattern-id: LP-2026-04-20-sql-safety
category: backend-security
hit-count: 3
last-triggered: 2026-05-15
---

# Error: SQL Concatenation Risk

[Content describing pattern...]
```

**Promotion Script** (`pattern-lifecycle.sh` at SessionEnd):
1. Detects `hit-count == 3`
2. Appends pattern to `.claude/rules/learned-backend-security.md`:
   ```markdown
   ## SQL Safety Pattern (Learned #4)
   <!-- pattern: LP-2026-04-20-sql-safety -->
   
   [Pattern content appended here]
   ```
3. Creates marker comment to prevent duplicate appends
4. Session report notes: "LP-2026-04-20-sql-safety promoted to learned-backend-security.md"

**Effect:** Next T2/T3 spawn loads pattern as part of `backend-security.md` context, not as learned-pattern.

---

### C.9: "Reading Metrics — Interpreting token-usage.md, leaderboard.md"

**Who:** Engineering manager tracking system efficiency  
**What:** Understand cost, performance, and agent reliability  

**token-usage.md Structure:**
```markdown
# Token Usage Tracking

## Session Summary
| Session | Date | Mode | Total Tokens | Avg per Agent | Cost (API) |
|---------|------|------|--------------|---------------|-----------|
| 2026-05-20 | 2026-05-20 | x10 | 953,220 | 95,322 | ~$4.77 |
| 2026-05-13 | 2026-05-13 | x5 | 412,156 | 82,431 | ~$2.06 |

## Agent Tier Budgets (Estimated)
| Tier | Model | Tokens/Task | Cost/Task |
|------|-------|------------|-----------|
| T1 | opus | 120,000–150,000 | $0.60–0.75 |
| T2 | sonnet | 80,000–100,000 | $0.24–0.30 |
| T3 | sonnet | 60,000–80,000 | $0.18–0.24 |
| T4 | haiku | 50,000–70,000 | $0.05–0.07 |
| T5 | haiku | 40,000–60,000 | $0.04–0.06 |

## Cost Optimization
- Single-agent: ~$0.50–1.00
- x3: ~$2–3
- x5: ~$4–6
- x10: ~$12–18
```

**Interpretation:**
- x5 mode at $5 = best cost/capability ratio for standard features
- x10 at $15 = justified for system-wide changes, not single module
- T5 at $0.05 = cheapest; use first for research before higher tiers

---

### C.10: "Advanced: Custom Delegation Strategy"

**Who:** Organization with unique task distribution  
**What:** Override default delegation based on team structure  

**Current Default:**
Simple tasks → T5, Medium → T3, Complex → T2, Architectural → T1

**Custom Override (Example):**
```bash
# Modify .claude/config/task-assignment-matrix.md
# Add custom rule: "all frontend tasks → T3, T2 for complex state management"
```

Result: Team can formalize their practice preferences, making the system predictable for their workflow.

---

## D. xN Mode Reference Table

### When to Use Each Mode

| Mode | Total Agents | Cost | When to Use |
|------|-------------|------|------------|
| **Single** | 1 | ~$0.50–1 | Trivial tasks, quick fixes, explanations |
| **x2** | 2 (T1+T5) | ~$2–3 | Architecture review + research, no implementation |
| **x3** | 3 (T1+T2+T5) | ~$2.50–3.50 | Small feature with senior review |
| **x4** | 4 (T1+T2+T3+T5) | ~$3–4 | Single module, standard development |
| **x5** | 5 (T1+T2+T3+T4+T5) | ~$4–6 | **DEFAULT**: Balanced team, full review chain ⭐ |
| **x7** | 7 (1×T1+2×T2+T3+T4+2×T5) | ~$7–10 | Parallel research + design tracks |
| **x10** | 10 (2×T1+2×T2+2×T3+2×T4+2×T5) | ~$12–18 | Critical system overhaul, multiple teams |

### Review Chain by Mode

| Mode | Review Path |
|------|------------|
| x2 | T5 → T1 (Principal acts as Lead Analyst) |
| x3 | T5 → T2 → T1 |
| x4 | T5 → T2 + (T3 → T2) → T1 |
| x5+ | T5 → T4 → [T3 → T2, T2 → T1] (full standard chain) |

### Cost Comparison Matrix

| Task | Single-Agent (all T1) | x5 (Optimal) | Savings |
|------|----------------------|-------------|---------|
| Small API endpoint | $8–10 | $1–2 | 80–90% |
| Feature (500 LOC) | $15–20 | $4–6 | 70–80% |
| System redesign | $35–50 | $12–18 | 65–75% |

---

## E. Example Commands (Command → Effect Mappings)

### Basic Commands

```
Hocam bu kodu review et
→ Single-agent mode, Orchestrator reads code, provides feedback

Şu authentication servicei typescript'ten kotlin'e migrate et x5
→ x5 mode: T5 research frameworks, T2 design service, T3 implement, all review

Bu typo'yu düzelt: 'Recieve' → 'Receive'
→ Trivial task, single-agent, <1 minute

Proje yapısını anlamak istiyorum
→ Orchestrator explains, no agents spawned

Bu bug'ı debug et x3
→ x3 mode, quick 3-agent team, code-focused
```

### Skill Commands

```
/caveman
Şu modulü refactor et x5
→ Caveman mode enabled, x5 execution, compressed prose output

/graphify . --local-only
→ Builds codebase knowledge graph, no API calls

/graphify query "god_nodes"
→ Queries existing graph for most-connected modules

/ctx
ctx_search("prior JWT implementation")
→ Context-mode enabled, searches indexed knowledge

/review
→ Runs code review checklist on current branch

/security-review
→ Focused security analysis of changes

/architect
Monolithic yapıyı microservices'e dönüştürmek için optimal strateji nedir?
→ Routes to T1 Principal directly, architectural advice
```

### Advanced Commands

```
X10 modunda şu alanlar için test stratejisi tasarla x10
→ x10 mode: massive parallel test architecture design

Bu öğrenilmiş patterni kalıcı kural yap
→ Orchestrator promotes pattern if hit-count >= 3

Setup'ı çalıştır ve context-mode + graphify'yi kur
bash .claude/scripts/setup.sh
→ One-command system initialization

Performance raporu göster
cat .claude/metrics/leaderboard.md
→ View agent scores and tier distribution

Önceki session'daki auth analizi neydi?
/ctx
ctx_search("auth module session 2026-05-15")
→ Cross-session knowledge retrieval
```

---

## F. Worked Examples (Complete Walkthroughs)

### F.1: Beginner Walkthrough — Fix a Typo

**User Command:**
```
Hocam, bu comment'teki typo'yu düzelt: 'usre' → 'user'
Dosya: src/features/user/user-service.ts, satır 42
```

**System Analysis (Orchestrator):**
- Detects: Single file, 1 line, trivial (typo)
- No xN parameter
- PEP Skip: YES (trivial task)
- Mode: Single-agent (Orchestrator handles directly)

**Execution:**
1. Read file: `src/features/user/user-service.ts`
2. Find typo at line 42 in comment
3. Change: `// usre ID validation` → `// user ID validation`
4. No hooks triggered (comment-only change)
5. Write file

**Output:**
```
✅ Fixed typo at src/features/user/user-service.ts:42

Before:
  // usre ID validation

After:
  // user ID validation

No session file created (single-agent mode).
Done.
```

**Time:** ~1 minute  
**Cost:** $0  
**Agents:** 0 (Orchestrator only)

---

### F.2: Intermediate Walkthrough — Add API Endpoint (x5)

**User Command:**
```
User yönetim modülüne 'GET /api/v1/users/:id/profile' endpoint'i ekle (detaylı profil dönsün) x5
```

**System Analysis (Orchestrator):**
- Task Type: Feature (API endpoint)
- Complexity: Medium (2-3 files, service + controller + DTO)
- Not trivial: Multi-file, business logic needed
- PEP Required: YES

**Prompt Enrichment Protocol (PEP):**

Orchestrator asks:
```
1. User profil response'ında hangi alanlar bulunmalı?
   (Recommended: email, displayName, profilePicture, bio, createdAt)

2. Unauthenticated users endpoint'e erişebilir mi?
   (Recommended: Only owner or admin can view profile)

3. Profil resmi upload'ı da mi gerekli aynı endpoint'te?
   (Recommended: Separate PATCH endpoint for profile picture)

4. İşletim sistemi profil cache'i yapılsın mı?
   (Recommended: 5-minute TTL, invalidate on update)
```

**User Approves:**
```
Tamam, defaults'u kabul ediyorum.
```

**Task Planning (Orchestrator):**

```markdown
## Multi-Agent Plan — x5 Mode

### Wave 1: Analysis
- TASK-001 (T5 Analyst): Research user profile patterns, security requirements, caching best practices

### Wave 2: Consolidation
- TASK-002 (T4 Lead Analyst): Review T5 findings, output architecture brief

### Wave 3: Implementation (Parallel)
- TASK-003 (T2 Staff Engineer): Design service layer (ProfileService interface, caching layer)
- TASK-004 (T3 MidCoder): Implement controller endpoint, DTOs, entity mapping

### Wave 4: Code Review
- TASK-005 (T2 reviews T3): Code quality, error handling, security
- TASK-006 (T1 reviews T2): Architecture consistency, service design

### Estimated Cost: $4–6
### Estimated Time: 12–15 minutes
```

**User:** "Başla"

---

**Execution:**

**Wave 1: T5 Analysis (Haiku, ~3K tokens)**

T5 reads:
- User entity structure (JPA mapping)
- Existing profile endpoints (if any)
- Profile data exposure security patterns
- Cache libraries available (Redis, Spring Cache)

Output: `.claude/analysis/raw/T5-user-profile.md`
```markdown
# User Profile Endpoint Analysis

## Findings
1. User entity has 12 fields; expose subset for profile (email, name, bio, pic, createdAt) ✓
2. No profile caching currently; Redis available, recommend 5-min TTL ✓
3. Authorization: Check User.id == logged-in user OR admin role ✓
4. Profil picture stored in S3; return pre-signed URL (not full image) ✓

## Risks
- N+1 on related data (posts count, followers count) — use @Query with count subquery
- Picture pre-signed URL expiry mismatch — ensure 1 hour TTL aligns with cache

## Recommendation
Implement with Redis + @Cacheable annotation
```

**Review (T4):** ✅ APPROVED

---

**Wave 2: T4 Consolidation (Haiku, ~2K tokens)**

T4 synthesizes T5 findings into architecture brief:
```markdown
# User Profile Endpoint — Architecture Brief

## Design Decision
- Endpoint: GET /api/v1/users/:id/profile
- Response: UserProfileDTO (email, name, bio, profilePictureUrl, createdAt)
- Cache: Redis, 5-minute TTL, invalidate on user update
- Auth: Owner or admin
- Picture: Pre-signed S3 URL (1-hour expiry)

## Service Layer
- UserProfileService.getProfile(userId, requesterId): UserProfile
  - Check authorization
  - Load user from repo
  - Check/invalidate cache
  - Generate S3 URL if picture exists
  - Return profile DTO

## Error Handling
- 404: User not found
- 403: Unauthorized (not owner, not admin)
- 500: Cache/S3 failure (log + fallback to no picture)
```

**Review:** ✅ APPROVED (no changes)

---

**Wave 3: Coding (Parallel)**

**T3 MidCoder (Sonnet, ~5K tokens):**

Implements controller + DTOs:

**File: UserProfileController.java**
```java
@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserProfileController {

    private final UserProfileService userProfileService;

    @GetMapping("/{userId}/profile")
    @Operation(summary = "Get user profile")
    public ResponseEntity<ApiResponse<UserProfileDTO>> getProfile(
            @PathVariable String userId,
            @RequestAttribute Long requesterId) {
        
        UserProfileDTO profile = userProfileService.getProfile(userId, requesterId);
        return ResponseEntity.ok(ApiResponse.success(profile, "Profile retrieved"));
    }
}
```

**File: UserProfileDTO.java**
```java
public record UserProfileDTO(
        String id,
        String email,
        String displayName,
        String bio,
        String profilePictureUrl,
        LocalDateTime createdAt
) {}
```

**T2 Staff Engineer (Sonnet, ~8K tokens):**

Implements service layer:

**File: UserProfileService.java**
```java
@Service
@RequiredArgsConstructor
public class UserProfileService {

    private final UserRepository userRepository;
    private final S3Service s3Service;
    private final CacheManager cacheManager;

    public UserProfile getProfile(String userId, Long requesterId) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new NotFoundError("User", userId));

        boolean isOwnerOrAdmin = userId.equals(String.valueOf(requesterId)) 
            || isAdmin(requesterId);

        if (!isOwnerOrAdmin) {
            throw new UnauthorizedError("Cannot view this user's profile");
        }

        String pictureUrl = null;
        if (user.getProfilePicturePath() != null) {
            pictureUrl = s3Service.getPresignedUrl(user.getProfilePicturePath(), 3600);
        }

        return new UserProfile(
            user.getId().toString(),
            user.getEmail(),
            user.getDisplayName(),
            user.getBio(),
            pictureUrl,
            user.getCreatedAt()
        );
    }

    private boolean isAdmin(Long requesterId) {
        // Check admin role from database
        return false; // Simplified for example
    }
}
```

---

**Wave 4: Code Review (Sequential)**

**T2 Reviews T3 (Sonnet):**
```
Review Findings:

🟡 UserProfileController:12
Missing @Validated on path variable.
Recommendation: Add @Validated to controller class

✅ DTOs correctly use record syntax, immutable

✅ Service uses appropriate access patterns

Overall: APPROVED with minor note (not blocking)
```

**T1 Reviews T2 (Opus):**
```
🟢 Architecture sound
  - Service layer properly isolated
  - Error handling comprehensive

🟢 SOLID principles followed
  - SRP: ProfileService handles one concern
  - DIP: Depends on abstractions

🟢 Security
  - Authorization checked before data access
  - S3 URLs expire appropriately

✅ APPROVED — Ready to merge
```

---

**Output (Orchestrator Consolidation):**

```markdown
## Implementation Complete ✅

### Files Created
- src/main/java/com/example/user/controller/UserProfileController.java
- src/main/java/com/example/user/dto/UserProfileDTO.java
- src/main/java/com/example/user/service/UserProfileService.java

### Endpoint
GET /api/v1/users/{userId}/profile
Response: 200 OK + UserProfileDTO
Authorization: Owner or admin only
Cache: 5 minutes (Redis)

### Testing
Recommended test scenarios:
1. Owner views own profile → 200 + data
2. Admin views any profile → 200 + data
3. Different user views profile → 403 Forbidden
4. Nonexistent user → 404 Not Found
5. Cache hit (same user, <5 min) → 200 (from cache)

---

## Session Performance Report

### Summary
Mode: x5 | Tasks: 5 | Completed: 5 | Failed: 0

### Agent Performance
| Agent | Tier | Task | Status | Tokens | Revisions |
|-------|------|------|--------|--------|-----------|
| Onur (T5) | Haiku | Analysis | ✅ | 38K | 0 |
| Elif (T4) | Haiku | Consolidation | ✅ | 32K | 0 |
| Taner (T3) | Sonnet | Implementation | ✅ | 68K | 0 |
| Enis (T2) | Sonnet | Service design | ✅ | 78K | 0 |
| Selin (T1) | Opus | Final review | ✅ | 102K | 0 |

**Total: 318K tokens (~$1.59)**

### Learned Patterns (New This Session)
None

### Files Changed
✏️ 3 new files created
📝 0 existing files modified

### Next Steps
1. Write unit tests for ProfileService
2. Add integration test for controller
3. Deploy to staging for UAT
```

**Time:** ~12 minutes  
**Cost:** ~$1.50  
**Agents:** 5 (T5 + T4 + T3 + T2 + T1)

---

### F.3: Advanced Walkthrough — Codebase Audit + Refactor (x10)

**User Command:**
```
Tüm codebase'i graphify ve context-mode ile audit et. 
God classes, test coverage boşlukları, security issues bul. 
Kritik bulguları düzelt. x10
```

**System Analysis (Orchestrator):**
- Scope: Full codebase analysis + fixes
- Complexity: VERY HIGH (40+ files, multiple concerns)
- Not trivial: Analysis + refactoring, architectural implications
- PEP Required: YES

**PEP Questions:**
```
1. Codebase size? (20–100 files?)
   → Recommendation: Use graphify (20-file threshold)

2. Security audit scope? (All code or specific modules?)
   → Recommendation: All backend code; frontend security review separate

3. Test coverage target? (80%? 90%?)
   → Recommendation: 80% minimum for existing code; 90% for new changes

4. Refactoring acceptance: Architectural changes allowed?
   → Recommendation: Yes, but within SRP; no major rewrites

5. Timeline: Phased or all-at-once?
   → Recommendation: Phased (architecture review → quick wins → deep refactoring)
```

**User:** "Tamam, hepsini başlat."

---

**Task Planning:**

```markdown
## x10 Codebase Audit + Refactor Plan

### Wave 1: Research (2×T5 Parallel)
- TASK-001 (T5 Onur): Build graphify graph, analyze topology, god nodes
- TASK-002 (T5 Necati): Security audit, test coverage gaps

### Wave 2: Consolidation (2×T4 Parallel)
- TASK-003 (T4 Elif): Synthesize topology findings → architecture report
- TASK-004 (T4 Ayse): Synthesize security findings → risk report

### Wave 3: Design (2×T2 Parallel)
- TASK-005 (T2 Enis): Design refactoring for god classes
- TASK-006 (T2 Tarik): Design test framework improvements

### Wave 4: Implementation (2×T3 Parallel)
- TASK-007 (T3 Taner): Implement god class decomposition
- TASK-008 (T3 Canan): Implement test coverage improvements

### Wave 5: Reviews (Sequential)
- TASK-009 (T2 Enis): Review T3 Taner code
- TASK-010 (T2 Tarik): Review T3 Canan code
- TASK-011 (T1 Selin): Review T2 Enis + architecture
- TASK-012 (T1 Baris): Review T2 Tarik + tests

Estimated Cost: $14–20 | Time: 20–30 minutes
```

---

**Wave 1: Research**

**T5 Onur — Graphify & Topology Analysis (5K tokens)**

```bash
/graphify . --local-only
cat graphify-out/GRAPH_REPORT.md
```

Outputs god_nodes analysis with architectural risk assessment.

**T5 Necati — Security Audit (4K tokens)**

Runs security analysis and coverage assessment, outputs comprehensive report.

---

**Wave 2–5: Implementation**

(Follows similar pattern to F.2 example, expanded scope)

---

**Final Output:**

Complete audit findings, refactoring completed, security issues resolved, test coverage improved, performance report generated.

**Time:** ~25 minutes  
**Cost:** ~$5  
**Agents:** 10 (Full team deployed)

---

## G. Anti-Patterns (What NOT to Do)

### G.1: ❌ Mixing xN with Single-Agent Task

**BAD:**
```
Hocam bu 'console.log' satırını sil x10
```

**Why:** Trivial task with 10-agent overkill = $15 cost for <1 minute work.

**Correct:**
```
Hocam bu 'console.log' satırını sil
```

---

### G.2: ❌ Asking T3 for Architectural Decisions

**BAD:** Assigning system design to T3 (Sonnet) when T1 (Opus) needed.

**Correct:** Use `/architect` command to route to T1 Principal.

---

### G.3: ❌ Using ctx_execute on Sensitive Operations

**BAD:** Running commands that access credentials or secrets via context-mode.

**Correct:** Use environment variables or secure stores; never pass secrets as text.

---

### G.4: ❌ Running graphify Without --local-only

**BAD:** Sending confidential documents to external API.

**Correct:** Always use `--local-only` for code-only analysis.

---

### G.5: ❌ Skipping Review Chain

**BAD:** Bypassing mandatory review layers in multi-agent mode.

**Correct:** System enforces review chain automatically; cannot skip.

---

### G.6: ❌ Bypassing Hooks with --no-verify

**BAD:** Using `--no-verify` to skip quality gates.

**Correct:** Fix violations and commit normally.

---

### G.7: ❌ Assuming xN Cost is Linear

**BAD:** Thinking x10 costs 10× more than single-agent.

**Correct:** x10 costs ~15–20× more but solves complex problems 10–20× faster.

---

### G.8: ❌ Expecting x10 in <5 Minutes

**BAD:** Planning x10 session to finish instantly.

**Correct:** Budget 20–30 minutes for full x10 execution.

---

### G.9: ❌ Using Caveman for Critical Decisions

**BAD:** Asking architectural question in caveman mode (compressed response).

**Correct:** Use normal mode for decisions needing full context.

---

### G.10: ❌ Not Checking `.graphify-stale`

**BAD:** Querying stale graph.json with outdated topology.

**Correct:** Check stale marker and rebuild if needed.

---

### G.11: ❌ Combining Unrelated Tasks in Single Session

**BAD:** Auth + reporting + throttling all in one x5.

**Correct:** Separate by feature → separate sessions.

---

### G.12: ❌ Relying on Unverified Patterns

**BAD:** Treating low-confidence patterns as rules.

**Correct:** Patterns are heuristics; final review still validates.

---

## End of Catalog

**Document Stats:**
- Use cases collected: 28 (A.1–C.10)
- Walkthroughs: 3 (F.1–F.3)
- Anti-patterns: 12 (G.1–G.12)
- Commands documented: 40+
- Total words: ~8,500

**Next Steps for Documentation Team:**
1. Convert beginner section to interactive quiz
2. Add screenshots/video walkthroughs for F.1–F.3
3. Create decision tree for xN parameter selection (flowchart)
4. Build command reference page (sortable, filterable)
5. Add cost calculator tool (interactive)
