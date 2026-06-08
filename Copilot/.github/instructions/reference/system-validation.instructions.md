# System Validation Rules

Agent-verifiable integrity rules that supersede the former bash linter (`scripts/validate-system.sh`). When the Orchestrator or any Principal needs to validate system integrity, they follow these rules manually using read/search tools instead of running a script.

---

## Rule 1 — Version Consistency

The version string must be identical across three files.

| File | Location | Format |
|------|----------|--------|
| `README.md` | Line 1 | `vX.Y.Z` |
| `USAGE.md` | Header (first 5 lines) | `X.Y.Z` |
| `CHANGELOG.md` | First `## [X.Y.Z]` entry | `X.Y.Z` |

**Verification:** Read line 1 of each file, extract the version token, normalize to `vX.Y.Z` format, and compare. PASS if all three match. FAIL with mismatched values.

---

## Rule 2 — File Counts

The repository must contain a minimum number of files in each category.

| Directory | Pattern | Minimum |
|-----------|---------|---------|
| `.github/agents/` | `*.agent.md` | 8 |
| `.github/instructions/` | `**/*.instructions.md` | 21 |
| `.github/skills/*/` | `SKILL.md` (in subdirectories) | 16 |
| `.github/hooks/` | `*.json` | 5 |

**Verification:** List files in each directory matching the pattern, count, and compare against the minimum. PASS if all counts meet or exceed their minimum. FAIL with actual vs. expected counts.

---

## Rule 3 — No Forbidden xN References

No references to prohibited multipliers (x11 or higher) may appear in `.github/instructions/` files.

**Search pattern:** `x1[1-9]|x[2-9][0-9]`

**Scope:** All `*.instructions.md` files in `.github/instructions/`.

**Excluded matches (not violations):**

- Lines that are headings (start with `#`)
- Lines containing `prohibited`, `CHANGELOG`, `changelog`, `edge case`, `Edge Case`, or `diminishing`

**Verification:** Search all instruction files for the pattern. Filter out matches on excluded lines. PASS if zero violations remain. FAIL with file, line number, and content of each violation.

---

## Rule 4 — Code Fences

No 4+ backtick code fences in any SKILL.md file. Only standard 3-backtick fences are allowed.

**Search pattern:** Four or more consecutive backtick characters (regex: `` `{4,} ``).

**Scope:** All `.github/skills/*/SKILL.md` files.

**Verification:** Search each SKILL.md for the pattern. PASS if no matches. FAIL with file and line number of each violation.

---

## Rule 5 — Unicode Integrity

No Unicode replacement characters (U+FFFD, `�`) in `AGENTS.md`.

**Search pattern:** The byte sequence `\xEF\xBF\xBD` or the rendered character `�`.

**Scope:** `AGENTS.md` at the repository root.

**Verification:** Read `AGENTS.md` and search for the replacement character. PASS if zero occurrences. FAIL with the count and affected line numbers.

---

## Rule 6 — Hook Parity

In `.github/hooks/safety-guard.json`, the edit-related tools listed under `PreToolUse` events must exactly match those under `PostToolUse` events.

**Edit-related tools:** Any tool name containing `edit`, `create`, `replace`, or `write` (case-insensitive).

**Verification:** Parse the hook JSON. Collect edit-related tool names from `PreToolUse` entries into a set and from `PostToolUse` entries into another set. PASS if the sets are identical. FAIL with the symmetric difference.

---

## Rule 7 — Model Consistency

Each agent file's YAML `model` and `modelFallback` fields must match the canonical model table below. Strip any ` (copilot)` suffix from YAML values before comparison. Use `.github/instructions/reference/model-registry.instructions.md` for alias resolution when encountering non-canonical model names.

### Canonical Model Table

| Agent (filename) | YAML Name (Role ID) | Primary Model | Fallback Model |
|-------|-------------|--------------|----------------|
| orchestrator | VarolMaksutoglu | Claude Opus 4.6 | Claude Opus 4.5 |
| principal-alpha | PrincipalAlpha | Claude Opus 4.6 | Claude Opus 4.5 |
| principal-beta | PrincipalBeta | Claude Opus 4.6 | Claude Opus 4.5 |
| staff-engineer-alpha | StaffEngineerAlpha | Claude Sonnet 4.6 | Claude Sonnet 4.5 |
| staff-engineer-beta | StaffEngineerBeta | Claude Sonnet 4.6 | Claude Sonnet 4.5 |
| mid-coder-alpha | MidCoderAlpha | GPT-5.3-Codex | GPT-5.2-Codex |
| mid-coder-beta | MidCoderBeta | GPT-5.3-Codex | GPT-5.2-Codex |
| lead-analyst | LeadAnalyst | Gemini 3.1 Pro (Preview) | Gemini 3.0 Pro (Preview) |
| analyst-alpha | AnalystAlpha | Gemini 3 Flash | Claude Haiku 4.5 |
| analyst-beta | AnalystBeta | Gemini 3 Flash | Claude Haiku 4.5 |
| analyst-gamma | AnalystGamma | Gemini 3 Flash | Claude Haiku 4.5 |

> **Note**: Display names are dynamically assigned each session from the name pool. See `dynamic-naming.instructions.md`.

### Constraints

- The `model` and `modelFallback` values must never be identical for the same agent.
- YAML values may carry a ` (copilot)` suffix; strip it before comparing against this table.

**Verification:**

1. For each agent in the table, read `.github/agents/<agent>.agent.md`.
2. Extract `model` and `modelFallback` YAML fields. Strip ` (copilot)` suffix.
3. Compare against the canonical table row.
4. Verify `model` ≠ `modelFallback` (pre-strip values).

PASS if all agents match and no identical model/fallback pairs exist. FAIL with the agent name and mismatched values.

---

## Validation Protocol

### When to Validate

- After every version bump
- After adding or removing an agent
- After modifying any file in `.github/hooks/`
- After modifying `project-context-discovery.instructions.md`
- After modifying `prompt-enrichment.instructions.md`
- After modifying analysis directory structure (`.github/analysis/`)

### Who Validates

| Role | Obligation |
|------|-----------|
| Orchestrator | Mandatory — run all 11 rules at session end |
| Principal | Optional — spot-check any subset of rules |

### Report Format

Present results as a numbered list. Each rule gets one line.

```
1. Version Consistency: PASS — vX.Y.Z across all files
2. File Counts: PASS — Agents=11, Instructions=21, Skills=13, Hooks=5
3. No Forbidden xN References: PASS
4. Code Fences: PASS
5. Unicode Integrity: PASS
6. Hook Parity: PASS
7. Model Consistency: PASS
8. PCD File: PASS — All 4 required sections present
9. PEP File: PASS — All 4 required sections present
10. Analysis Directory Integrity: PASS — Both directories exist, naming conventions OK
11. Dynamic Naming System: PASS — 20 names, all scores valid, role-based IDs confirmed

Summary: 11/11 PASS
```

For failures, append the details inline:

```
6. Hook Parity: FAIL — PreToolUse has {edit_file} but PostToolUse is missing it

Summary: 10/11 PASS, 1 FAIL
```

---

## Rule 8 — Project Context Discovery File

The PCD instruction file must exist and contain required sections.

**Required file:** `.github/instructions/reference/project-context-discovery.instructions.md`

**Required sections** (search for exact headings):

- `## Discovery Protocol`
- `## Priority Hierarchy`
- `## Agent Obligations`
- `## Context Loading Integration`

**Verification:** Read the PCD file. Confirm it exists and all four section headings are present. PASS if file exists and all headings found. FAIL with missing file or missing headings.

---

## Rule 9 — Prompt Enrichment Protocol File

The PEP instruction file must exist and contain required sections.

**Required file:** `.github/instructions/reference/prompt-enrichment.instructions.md`

**Required sections** (search for exact headings):

- `## When to Apply PEP`
- `## Question Categories`
- `## Enrichment Process`
- `## Orchestrator Integration`

**Verification:** Read the PEP file. Confirm it exists and all four section headings are present. PASS if file exists and all headings found. FAIL with missing file or missing headings.

---

## Rule 10 — Analysis Directory Integrity

The analysis output directories must exist and contain only properly scoped files.

**Required directories:**

| Directory | Purpose | Allowed writers |
|-----------|---------|----------------|
| `.github/analysis/raw/` | Tier 5 Analyst raw reports | T5 Analysts only |
| `.github/analysis/consolidated/` | Tier 4 Lead Analyst consolidated reports | T4 Lead Analyst only |

**File naming conventions:**

- Raw reports: `{agent-name}-{topic}.md` (e.g., `analyst-alpha-dependency-audit.md`)
- Consolidated reports: `{topic}-consolidated.md` (e.g., `dependency-audit-consolidated.md`)

**Verification:**

1. Confirm both directories exist (at minimum, `.gitkeep` files).
2. If analysis files are present, verify naming conventions match the expected patterns.
3. Verify no application code files (`.ts`, `.js`, `.java`, `.json`, `.yaml`) exist in these directories.

PASS if directories exist and all files follow conventions. FAIL with the specific violation.

---

## Rule 11 — Dynamic Naming System Integrity

The dynamic naming system must have all required files and consistent data.

**Required files:**

| File | Purpose |
|------|---------|
| `.github/config/name-pool.md` | 20 names, scoring rules, selection algorithm |
| `.github/metrics/leaderboard.md` | Cumulative scores, rankings, tier assignments |
| `.github/instructions/reference/dynamic-naming.instructions.md` | Protocol definition, agent obligations |

**Validation checks:**

1. **Name pool size**: Exactly 20 names must be present in `name-pool.md`.
2. **Score consistency**: All names in `name-pool.md` must have corresponding entries in `leaderboard.md`.
3. **Tier assignment**: Every name must have a valid tier (S/A/B/C/D) based on its score.
4. **Agent files**: All 10 non-orchestrator agent files must use role-based YAML `name` fields (not human names).
5. **Hook files**: All hook `case` statements must reference role-based IDs (PrincipalAlpha, StaffEngineerBeta, etc.), not human names.
6. **Orchestrator integration**: `orchestrator.agent.md` must contain Step 0.5 (Dynamic Name Assignment) in its protocol.

**Verification:**

1. Read `name-pool.md` — count names, verify format.
2. Read `leaderboard.md` — verify all 20 names present with valid scores.
3. Spot-check 3 agent files — verify YAML `name` is role-based.
4. Read `orchestrator.agent.md` — confirm Step 0.5 exists.

PASS if all checks pass. FAIL with the specific violation.

---

## New Agent Validation

After a new agent is scaffolded, re-run the following rules to verify integration:

| Rule | Purpose |
|------|---------|
| Rule 2 — File Counts | Confirm the new agent file increments the agent count |
| Rule 7 — Model Consistency | Confirm the new agent has correct model and fallback assignments |

Update the canonical model table in this file when adding a new agent.
