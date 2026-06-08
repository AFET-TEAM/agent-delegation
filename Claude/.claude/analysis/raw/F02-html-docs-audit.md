---
task-id: F02
agent: Yavuz Yalcin
tier: T5
status: Complete
date: 2026-06-02
---

# HTML + Docs Audit

## Encoded String Occurrences in docs/index.html

| Line | Encoded String | Decoded | Context (surrounding) |
|------|---|---|---|
| 3325 | `console&#46;log` | `console.log` | `(console&#46;log, any tipi, yorum vb.)` |
| 3368 | `console&#46;log` | `console.log` | `echo 'console&#46;log("test")' &gt; /tmp/test-hook-file.ts` |

### Detailed Context

**Line 3325** (Turkish table row):
```html
<td>İhlal tespit edildi (console&#46;log, any tipi, yorum vb.)</td>
```
Full context: Table cell in violation checklist, listing what kind of violations are detected by hooks. Should decode to: `(console.log, any tipi, yorum vb.)`

**Line 3368** (Bash code example):
```html
echo 'console&#46;log("test")' &gt; /tmp/test-hook-file.ts
```
Full context: Example bash command in hook testing section. The `&gt;` is also encoded (the `>` shell redirect). Should decode to: `echo 'console.log("test")' > /tmp/test-hook-file.ts`

---

## Other Hook Workaround Encodings Found

**None detected beyond the two `&#46;` instances above.**

Three other HTML entities are present (lines 291, 293, 300) but these are semantic HTML entities for UI symbols and are NOT hook workarounds:
- Line 291: `&#9776;` → ☰ (hamburger menu icon)
- Line 293: `&#9889;` → ⚡ (lightning bolt)
- Line 300: `&#9789;` → ☉ (sun icon for dark mode toggle)

---

## Total Count of Hook Workarounds: 2

Both are the same workaround pattern: `&#46;` replacing `.` in `console.log` references to evade the `console-log-check.sh` hook during documentation generation.

---

## graphify-install.md Warning Assessment

### Current State

The warning section (`### \`graphify install\` Git Hook Sub-command`, lines 209–224) is well-structured and includes:

1. **Explicit danger statement**: "silently modifies `.git/hooks/post-commit` without a confirmation prompt"
2. **Condition clarification**: "NOT required during standard setup"
3. **Proper removal command**: `graphify hook remove`
4. **Verification step**: Command to check for unexpected hooks

### Rating: **Adequate**

The warning meets baseline requirements. It tells users:
- What the command does (modifies `.git/hooks/post-commit` silently)
- When to use it (only if you explicitly want auto-rebuild)
- How to remove it (if accidentally installed)
- How to verify (check post-commit hook contents)

### Specific Improvements Needed

1. **Visibility**: Move warning from subsection (###) to a more prominent callout box or blockquote format to ensure users don't miss it while scanning the installation steps.

2. **Step numbering alignment**: The warning appears after Step 9 but is not numbered as a step. Users skimming step-by-step instructions may skip it.

3. **Before-and-after hook content**: Show what the hook looks like before and after `graphify install` runs, so users can manually verify they don't want those changes.

4. **Mention in intro**: Add a brief reference to this caveat in the "Overview" section (line 3) so users know upfront that graphify *can* install git hooks.

### Suggested Warning Section (verbatim)

Replace lines 209–224 with this improved version:

```markdown
## ⚠️ Git Hook Installation Warning

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

### Reference

S-009 analysis: `.claude/analysis/consolidated/C-T4B-graphify.md`
```

### Why These Improvements

- **⚠️ emoji** and section heading: Forces visual scan-stop for skimming readers.
- **CAPS for NOT**: Emphasizes the negative constraint.
- **"What the Hook Does"**: Explains consequences (latency, disk bloat) so users understand the trade-off.
- **Explicit removal first**: The problem statement comes before the solution.
- **Verification command unchanged**: Already correct and clear.

---

## Summary

| Finding | Count | Status |
|---------|-------|--------|
| Hook workaround encodings (&#46;) | 2 | Documented |
| Other HTML entity workarounds | 0 | N/A |
| Lines containing &#46; hook workarounds | 2 | Lines 3325, 3368 |
| graphify-install.md warning adequacy | Adequate but improvable | See suggestions above |
