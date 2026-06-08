---
name: Knowledge Graph
description: >
  Structured codebase understanding through graph-based reasoning. Query-first principle,
  confidence-tagged analysis, relationship mapping, and token-efficient exploration.
used-by: [T1, T2, T3, T4, T5]
estimated-tokens: 1800
core-sections: ["Purpose", "Query-First Principle", "Confidence-Tagged Analysis", "Relationship Mapping"]
extended-sections: ["Token-Efficient Exploration", "Structured Findings Format", "God Node Detection"]
---

# Knowledge Graph

## Purpose

Understand codebases through structured relationships rather than brute-force file reading. Instead of reading every file to understand a system, map the connections between entities and query the structure. This skill defines patterns for building mental models efficiently and communicating findings with precision.

**Core principle**: Query the structure, don't read the corpus. A single well-targeted query replaces reading ten files.

---

## Query-First Principle

Before reading any file, determine if the answer can be found through a targeted query:

### Decision Tree

```
Need to understand something?
├─ Can grep/search answer it? → Use grep (1 tool call, ~0.5 KB)
├─ Need function signature? → Use view_range on specific lines (~1 KB)
├─ Need call flow? → Trace imports + grep for usage (~2 KB)
├─ Need full implementation? → Read the specific file (~5-20 KB)
└─ Need system understanding? → Build relationship map (see below)
```

### Query Patterns

| Question Type | Efficient Query | Wasteful Approach |
|---------------|----------------|-------------------|
| "What calls this function?" | `grep -r "functionName("` | Read all importing files |
| "What does this service depend on?" | `grep "import" service.ts` | Read service + all referenced files |
| "How is auth implemented?" | `grep -r "auth\|jwt\|token" --include="*.ts"` | Read entire src/auth/ directory |
| "What's the API surface?" | `grep -r "export.*function\|export.*class"` | Read all public modules |
| "Where is X configured?" | `grep -r "X" --include="*.{json,yaml,yml,env}"` | Read all config files |

### Scoped Exploration Protocol

When exploring an unfamiliar codebase:

1. **Map the structure first** — `glob` or `find` to understand directory layout (~0.1 KB)
2. **Identify entry points** — Look at package.json scripts, main files, index files (~1 KB)
3. **Trace from entry** — Follow imports/requires from entry points (~2-3 KB)
4. **Read only what's needed** — Targeted `view_range` on specific functions (~1-2 KB per function)

Total context for understanding a module: **~5-7 KB** vs reading all files: **50-200 KB**

---

## Confidence-Tagged Analysis

Every finding, relationship, or assertion in analysis outputs MUST carry a confidence tag:

### Confidence Levels

| Tag | Symbol | Meaning | When to Use |
|-----|--------|---------|-------------|
| EXTRACTED | 🟢 | Directly found in source | Import statements, function calls, explicit config |
| INFERRED | 🟡 | Reasonable deduction from evidence | Naming patterns, co-location, contextual clues |
| AMBIGUOUS | 🔴 | Uncertain — needs verification | Indirect references, assumed relationships |

### Confidence Scores (for INFERRED findings)

| Score | Meaning | Example |
|-------|---------|---------|
| 0.95 | Near-certain | Cross-file reference with single plausible target |
| 0.85 | Strong evidence | Naming + context alignment |
| 0.75 | Reasonable | Contextual but not explicit |
| 0.65 | Weak | Naming similarity only |
| 0.55 | Speculative | Co-location in same directory |

### Application in Reports

Every analysis finding uses this format:

```
[EXTRACTED] UserService calls AuthRepository.validateToken() — src/auth/repository.ts:42
[INFERRED 0.85] PaymentService likely depends on UserService for customer lookup — same module, matching parameter types
[AMBIGUOUS] CacheManager may handle session state — referenced in comments but no direct usage found
```

---

## Relationship Mapping

### Entity Relationships

When analyzing code, map these relationship types:

| Relationship | Direction | Example |
|--------------|-----------|---------|
| `calls` | A → B | UserService calls AuthRepository |
| `imports` | A → B | Controller imports Service |
| `implements` | A → B | ConcreteClass implements Interface |
| `extends` | A → B | AdminUser extends User |
| `uses` | A → B | Handler uses Validator |
| `configures` | A → B | Config sets up Database |
| `emits` | A → B | Service emits Event |
| `subscribes` | A → B | Handler subscribes to Event |

### Node Categories

| Category | Examples | Priority |
|----------|----------|----------|
| Entry Points | Controllers, Handlers, Main | High — read these first |
| Domain Logic | Services, UseCases, Models | High — core business rules |
| Infrastructure | Repositories, Adapters, Clients | Medium — implementation details |
| Configuration | Config files, Constants, Env | Medium — system shape |
| Utilities | Helpers, Utils, Shared | Low — read only when referenced |
| Tests | Test files, Fixtures, Mocks | Low — read for behavior verification |

### God Node Detection

**God nodes** are entities with disproportionately high connectivity. They indicate:
- Potential single points of failure
- Candidates for refactoring
- Critical dependencies that need stability

Detection heuristic: A node with connections to >30% of other nodes in its module is a god node.

When reporting analysis, explicitly call out god nodes:

```
⚠️ GOD NODE: UserService (connected to 12/15 entities in auth module)
  - Risk: Single point of failure for authentication flow
  - Recommendation: Consider splitting into AuthenticationService + UserProfileService
```

---

## Token-Efficient Exploration

### Exploration Budget

| Exploration Goal | Max Context Budget | Strategy |
|-----------------|-------------------|----------|
| "What does this project do?" | 3 KB | README + package.json + entry point |
| "How does feature X work?" | 8 KB | Entry point → trace flow → read key functions |
| "Full module understanding" | 15 KB | Map structure → read interfaces → read implementations |
| "Cross-cutting concern audit" | 20 KB | grep patterns → read matches → build relationship map |

### Progressive Disclosure

Don't front-load all information. Build understanding incrementally:

1. **Level 1 — Shape** (0.5 KB): Directory structure, file names, exports
2. **Level 2 — Interface** (2 KB): Public APIs, type definitions, function signatures
3. **Level 3 — Logic** (5 KB): Implementation of key functions, control flow
4. **Level 4 — Detail** (10+ KB): Edge cases, error paths, full implementations

Only proceed to the next level when the current level is insufficient to answer the question.

---

## Structured Findings Format

Analysis outputs follow this structure for maximum information density:

### Finding Template

```markdown
### [Finding Title]

**Confidence**: [EXTRACTED 🟢 | INFERRED 🟡 0.XX | AMBIGUOUS 🔴]
**Source**: [file:line or search pattern]
**Impact**: [P0 Critical | P1 Important | P2 Nice-to-have]

[1-2 sentence description of the finding]

**Evidence**:
- [Source reference 1]
- [Source reference 2]

**Recommendation**: [Actionable next step]
```

### Summary Table Format

For multi-finding reports, use a summary table:

```markdown
| # | Finding | Confidence | Impact | Source |
|---|---------|-----------|--------|--------|
| 1 | [Title] | 🟢 EXTRACTED | P1 | file:line |
| 2 | [Title] | 🟡 INFERRED 0.85 | P2 | file:line |
```

This structure enables:
- Quick scanning by priority
- Confidence-aware decision making
- Source traceability for verification
