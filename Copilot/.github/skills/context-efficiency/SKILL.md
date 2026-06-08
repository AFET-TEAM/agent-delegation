---
name: Context Efficiency
description: >
  Context window protection and token-efficient tool usage. Think-in-Code paradigm,
  output routing, blocked patterns, and session continuity.
used-by: [T1, T2, T3, T4, T5]
estimated-tokens: 2200
core-sections: ["Purpose", "Think-in-Code Paradigm", "Output Routing Rules", "Blocked Patterns"]
extended-sections: ["Session Continuity", "Context Budget Awareness", "Tool Selection Priority"]
---

# Context Efficiency

## Purpose

Protect the context window from flooding. Every unmanaged tool call, raw file read, or verbose output consumes context that could be used for reasoning. This skill defines mandatory patterns for all agents to minimize context consumption while preserving full technical capability.

**Core principle**: The agent is a code generator, not a data processor. Program the analysis — don't compute it inline.

---

## Think-in-Code Paradigm

When an agent needs to analyze, count, filter, compare, search, parse, or transform data:

1. **Write a script** that performs the operation
2. **Output only the result** (via `console.log`, `print`, or equivalent)
3. **Never read raw data into context** for manual processing

### Before (Context-Wasteful)

```
Read 47 files → 700 KB in context → Agent counts functions manually
```

### After (Context-Efficient)

```
Execute script that reads files and outputs: "auth-service.ts: 12 functions, user-model.ts: 8 functions"
Result: 3.6 KB in context
```

### Rules

| Scenario | Wasteful Approach | Efficient Approach |
|----------|-------------------|-------------------|
| Count lines/functions across files | Read all files into context | Write a script, output summary |
| Compare two large files | Read both files | Write a diff script, output differences only |
| Search for patterns across codebase | Read multiple files | Use grep/search tools, report only matches |
| Analyze dependencies | Read package.json + lock file | Write script to extract dependency tree |
| Parse log files | Read entire log | Write script to filter and summarize |

### Mandatory Constraints

- If data exceeds **5 KB**, it MUST be processed via script, not read into context
- If more than **3 files** need to be read for a single analysis, use a batch script
- Raw HTTP responses, API outputs, and log dumps are NEVER read directly into context
- If a tool call will produce output larger than **2 KB**, route it through a file or script

---

## Output Routing Rules

### Write to Files, Not Inline

| Output Type | Route | Rationale |
|-------------|-------|-----------|
| Code artifacts (>20 lines) | Write to file | Keeps context clean |
| Analysis reports | Write to file, summarize inline | Full report preserved, context minimal |
| Large diffs | Write to file | Only summary in context |
| Dependency trees | Write to file | Query specific parts as needed |
| Test results | Summarize inline (pass/fail + count) | Full output only on failure |
| Build output | Summarize inline (success/failure) | Full output only on failure |

### Inline Responses (Keep Short)

Inline responses should contain:
- File paths of created/modified artifacts
- 1-line description per artifact
- Pass/fail status with counts
- Specific error messages (on failure only)

### Artifact Summary Pattern

When producing artifacts, report them as:

```
Created: src/auth/login-service.ts (JWT authentication with refresh token support)
Modified: src/shared/types.ts (added AuthToken interface)
Test: 12/12 passed
```

NOT:

```
I have created a new file at src/auth/login-service.ts which implements JWT authentication...
[followed by 200 lines of explanation]
```

---

## Blocked Patterns

The following patterns waste context and MUST be avoided:

### Never Do

| Pattern | Why It Wastes Context | Alternative |
|---------|----------------------|-------------|
| Read entire file to find one function | Loads KB of irrelevant code | Use grep/search for the specific symbol |
| Dump raw HTTP response into output | HTML/JSON floods context | Write to file, summarize key data |
| Read all test files to check coverage | Massive context consumption | Run coverage tool, report summary |
| Cat large log files | Unstructured data flood | Script to filter relevant lines |
| Read package-lock.json | Thousands of lines | Script to extract specific dependency info |
| Paste entire stack trace in analysis | Verbose repetition | Extract root cause line + file:line reference |

### Large Output Handling

When a command or tool produces large output:

1. **< 2 KB**: Include inline (acceptable)
2. **2-10 KB**: Include only the relevant portion, cite the rest as "full output in [location]"
3. **> 10 KB**: Write to file, report only summary/key findings inline

---

## Session Continuity

### Event Priority Categories

Track session events by priority for efficient context recovery:

| Priority | Category | Examples |
|----------|----------|----------|
| 1 (Critical) | Files, Rules, Tasks | File edits, rule changes, task assignments |
| 2 (Important) | CWD, Errors, Git, Env | Directory changes, errors, git operations |
| 3 (Context) | Search, Patterns | File searches, glob patterns |
| 4 (Reference) | External data | Fetched URLs, indexed content |
| 5 (Low) | Metadata | Statistics, timing, counts |

### State Preservation Rules

- Every file edit MUST be recorded with path and brief description
- Every decision MUST be recorded with rationale
- Every error MUST be recorded with resolution (or escalation)
- Session state is reconstructed from Priority 1-2 events; Priority 3-5 are optional context

### Context Compaction Survival

When context is compacted or a session resumes:
1. Priority 1 events are ALWAYS preserved
2. Priority 2 events are preserved if space allows
3. Priority 3-5 events are retrievable on demand but not pre-loaded

---

## Context Budget Awareness

Agents must be aware of their context consumption patterns:

### Per-Response Budget Guidelines

| Response Type | Target Size | Max Size |
|---------------|-------------|----------|
| Status update | 100-200 tokens | 500 tokens |
| Code review finding | 200-400 tokens | 800 tokens |
| Implementation report | 300-600 tokens | 1500 tokens |
| Architecture decision | 400-800 tokens | 2000 tokens |
| Full task report | 500-1000 tokens | 3000 tokens |

### Context Consumption Red Flags

If an agent notices any of these, it should restructure its approach:

- Reading more than 5 files for a single question
- Producing output longer than 2000 tokens for a non-architecture task
- Including raw data that could be summarized
- Repeating information already established in the session
- Explaining code that is self-documenting

---

## Tool Selection Priority

When multiple tools could accomplish the same goal, prefer the most context-efficient option:

| Need | Most Efficient | Less Efficient | Least Efficient |
|------|---------------|----------------|-----------------|
| Find a symbol | grep with exact pattern | Read file + search | Read multiple files |
| Understand a function | Read only that function (view_range) | Read the whole file | Read the file + its imports |
| Check build status | Run build, report pass/fail | Run build, include full output | — |
| Verify a change | Run specific test | Run full test suite | Run full suite + include output |
| Explore structure | glob for patterns | ls directories recursively | Read all files |

### Batch Operations

When multiple independent operations are needed:
- Make ALL independent tool calls in a single response (parallel execution)
- Chain dependent bash commands with `&&`
- Use `--quiet`, `--no-pager`, or pipe to `head`/`grep` to suppress verbose output
