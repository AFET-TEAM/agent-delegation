---
task-id: F04
agent: Ayse Demir
tier: T4
status: Complete
date: 2026-06-02
---

# Docs Fix Specifications

**Consolidated from**: F02-html-docs-audit.md (T5 Yavuz Yalcin)

---

## Fix 1: docs/index.html — Decode console.log

### ⚠️ CRITICAL: This fix requires hook fix to be deployed first!

The hook-workaround encodings in HTML must NOT be edited until the console-log-check hook is fixed. Otherwise, the Edit tool will be blocked by the hook.

**Prerequisite**: T3-A must deploy the hook fix (disable/patch console-log-check.sh) BEFORE this edit can proceed.

### File
`docs/index.html`

### Edit Operation
**Use `replace_all: true`** — there are 2 occurrences.

```
old_string: console&#46;log
new_string: console.log
```

### Occurrences to Fix

| Line | Context | Current | Fixed |
|------|---------|---------|-------|
| 3325 | Turkish table row listing violations | `(console&#46;log, any tipi, yorum vb.)` | `(console.log, any tipi, yorum vb.)` |
| 3368 | Bash code example in hook testing | `echo 'console&#46;log("test")' &gt; /tmp/test-hook-file.ts` | `echo 'console.log("test")' > /tmp/test-hook-file.ts` |

### Verification After Fix
Run this to confirm all occurrences are decoded:
```bash
grep -n "console&#46;log" docs/index.html
```
Expected output: **0 lines** (empty result)

### Why These Are Hook Workarounds
Both occurrences use `&#46;` (HTML entity for `.`) to escape the period in `console.log`. This was done to avoid triggering the `console-log-check.sh` hook during HTML documentation generation. Once the hook is fixed, the HTML entities are no longer needed.

---

## Fix 2: graphify-install.md — Strengthen Warning

### File
`.claude/docs/graphify-install.md`

### Edit Operation
Replace lines 209–224 (the weak warning section) with the improved version:

```
old_string: ### `graphify install` Git Hook Sub-command

graphify includes a `graphify install` sub-command that silently modifies `.git/hooks/post-commit` without a confirmation prompt (S-009 in C-T4B analysis). This command is NOT required during standard setup and should NOT be run unless you explicitly want graphify to auto-rebuild on every git commit.

If you have run `graphify install` and want to remove the git hook:

```bash
graphify hook remove
```

Verify no unexpected hook was installed:

```bash
cat .git/hooks/post-commit 2>/dev/null || echo "No post-commit hook installed"
```

new_string: ## ⚠️ Git Hook Installation Warning

graphify includes a `graphify install` sub-command that **silently modifies** `.git/hooks/post-commit` to auto-rebuild the graph on every commit. This command is **NOT required** for normal operation and **should NOT be run** unless you explicitly want automatic graph rebuilds.

### What the Hook Does

If run, `graphify install` appends a line to `.git/hooks/post-commit` that rebuilds `graphify-out/graph.json` after each commit. This adds latency to every commit and fills disk with intermediate build artifacts.

### How to Remove It

If you have accidentally run `graphify install`, remove the hook:

```bash
graphify hook remove
```

Verify the hook was removed:

```bash
cat .git/hooks/post-commit 2>/dev/null || echo "No post-commit hook installed"
```
```

### What's Improved

1. **Visual Callout**: Changed from subsection heading (`###`) to section heading (`##`) with ⚠️ emoji — ensures readers don't skip it while scanning.

2. **Explicit Emphasis**: Added **bold** formatting for "silently modifies", "NOT required", and "should NOT be run" — stronger signal of danger.

3. **Consequence Explanation**: New subsection "What the Hook Does" explains latency + disk bloat trade-offs, so users understand the cost.

4. **Before/After**: The verification command remains unchanged and is clear.

5. **Semantic Improvement**: Changed from sub-subsection structure (confusing hierarchy) to clear parent + child sections.

### Scope of Change
- Replace only lines 209–224 (the entire weak `### graphify install...` section)
- Keep the rest of the file intact
- Section S-003 (Cache Integrity) follows immediately after and should remain unchanged

### Why This Matters
T5 Yavuz rated the original warning as "Adequate but improvable" because:
- Users skimming step-by-step instructions may miss a subsection-level warning
- The consequences (latency, disk usage) were not explained
- The warning lacked visual prominence (no emoji, no bold)

The improved version addresses all three gaps without adding length.

---

## T3-B and T1-A Implementation Instructions

### For T3-B: Fix 2 (graphify-install.md)
1. Edit `.claude/docs/graphify-install.md` immediately (no dependencies)
2. Use the exact Edit operation above
3. Verify the file renders correctly in Markdown viewer
4. No hook risk — this is documentation-only

### For T1-A: Fix 1 (docs/index.html)
1. **Wait for**: T3-A to complete hook fix and confirm deployment
2. After T3-A completes hook fix:
   - Edit `docs/index.html` with the exact operation above (`replace_all: true`)
   - Run verification command (grep for `console&#46;log`)
   - Confirm 0 lines returned
3. The hook fix removes the blocker; this edit will succeed

---

## Dependency Summary

```
T3-A (Hook Fix: disable console-log-check.sh)
    ↓ (gates)
T1-A (Fix 1: docs/index.html)

T3-B (Fix 2: graphify-install.md)
    ↓ (parallel, no dependency)
```

**Execution Order**:
- **Immediate**: T3-B starts Fix 2 (graphify-install.md)
- **Concurrent**: T3-A works on hook fix
- **After T3-A completes**: T1-A proceeds with Fix 1 (docs/index.html)

---

## Session Context

- **Session**: 2026-06-02-hook-fixes-x10
- **Task**: TASK-F04 (Consolidate F02 docs audit → exact fix specs)
- **Input**: F02-html-docs-audit.md (raw analysis by T5 Yavuz Yalcin)
- **Output**: This specification document (consolidated by T4 Ayse Demir)
- **Next**: Handed off to T3 coders (T3-B for Fix 2, T1-A for Fix 1 after T3-A hook fix)
