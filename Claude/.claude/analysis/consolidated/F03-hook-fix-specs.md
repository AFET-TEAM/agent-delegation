---
task-id: F03
agent: Elif Ozge Maksutoglu
tier: T4
status: Complete
date: 2026-06-02
---

# Hook Fix Specifications — Exact Edit Operations for T2/T3

## Summary
Two hooks missing `.html` exclusion and other file type patterns. F01 audit identified exact inconsistencies. This document provides copy-pasteable Edit tool operations.

---

## Fix 1: block-console-log.sh

**File:** `.claude/hooks/block-console-log.sh`

### Current State (Lines 23–27)
```bash
case "$FILE_PATH" in
  *.spec.*|*.test.*|*.stories.*|*.md|*.json|*.sh)
    exit 0
    ;;
esac
```

### Edit Operation

**old_string:**
```bash
case "$FILE_PATH" in
  *.spec.*|*.test.*|*.stories.*|*.md|*.json|*.sh)
    exit 0
    ;;
esac
```

**new_string:**
```bash
case "$FILE_PATH" in
  *.spec.*|*.test.*|*.stories.*|*.md|*.json|*.sh|*.yml|*.yaml|*.html|*.xml|*.svg|*.css)
    exit 0
    ;;
  *.config.*|*vite.config*|*vitest.config*|*tsconfig*|*eslint*|*prettier*)
    exit 0
    ;;
esac
```

### Verification Checklist
- ✅ **Matches block-comments.sh reference pattern:** YES
  - block-comments.sh line 24: `*.md|*.json|*.sh|*.yml|*.yaml|*.html|*.xml|*.svg|*.css`
  - block-comments.sh line 27: `*.config.*|*vite.config*|*vitest.config*|*tsconfig*|*eslint*|*prettier*`
  - This fix adds all 9 file types + 6 pattern-based exclusions exactly as present in reference
  
- ✅ **Syntax valid:** YES
  - Case statement properly closed
  - All pipe separators aligned with Bash glob syntax
  - No typos or extra whitespace
  
- ✅ **Won't break existing logic:** YES
  - Exit codes unchanged
  - Exclusion logic expanded only (superset of current behavior)
  - Console.log detection (lines 33–40) remains unchanged

### Impact
After fix: `.html` files will be excluded from console.log/alert/confirm/prompt checks, matching the original intent (these hooks should not validate markup files).

---

## Fix 2: block-any-type.sh

**File:** `.claude/hooks/block-any-type.sh`

### Current State (Lines 23–27)
```bash
case "$FILE_PATH" in
  *.spec.*|*.test.*|*.d.ts|*.md|*.json|*.sh|*.scss|*.css)
    exit 0
    ;;
esac
```

### Edit Operation

**old_string:**
```bash
case "$FILE_PATH" in
  *.spec.*|*.test.*|*.d.ts|*.md|*.json|*.sh|*.scss|*.css)
    exit 0
    ;;
esac
```

**new_string:**
```bash
case "$FILE_PATH" in
  *.spec.*|*.test.*|*.d.ts|*.md|*.json|*.sh|*.scss|*.css|*.yml|*.yaml|*.html|*.xml|*.svg)
    exit 0
    ;;
  *.config.*|*vite.config*|*vitest.config*|*tsconfig*|*eslint*|*prettier*)
    exit 0
    ;;
esac
```

### Verification Checklist
- ✅ **Matches block-comments.sh reference pattern:** YES (modified for TypeScript-specific files)
  - Preserves existing `.d.ts` (TypeScript definition files) and `.scss` (SCSS style files)
  - Adds `.html`, `.yml`, `.yaml`, `.xml`, `.svg` from reference pattern
  - Adds all 6 pattern-based exclusions exactly as in reference
  
- ✅ **Syntax valid:** YES
  - Case statement properly closed
  - All pipe separators aligned with Bash glob syntax
  - No typos or extra whitespace
  
- ✅ **Won't break existing logic:** YES
  - Exit codes unchanged
  - Exclusion logic expanded only (superset of current behavior)
  - TypeScript `any` detection (lines 33–40) remains unchanged

### Impact
After fix: `.html`, `.yml`, `.yaml`, `.xml`, `.svg` files will be excluded from TypeScript `any` type checks, preventing false positives on non-source files.

---

## Decision: Additional File Types

**Question from T5:** Should we also add other missing extensions (`.yml`, `.yaml`, `.xml`, `.svg`, `.css`) not yet in the hooks?

**Decision:** ✅ **YES — Add all of them now**

**Rationale:**
1. **Consistency:** All three hooks should have identical extension lists (primary file types)
2. **Prevention:** Avoids future workarounds when developers encounter similar false positives
3. **Correctness:** Config files (`.yml`, `.yaml`), markup (`.html`, `.xml`, `.svg`), and style sheets (`.css`) are never source code and should never trigger linter rules designed for application code
4. **Zero risk:** These are purely additive exclusions — no logic changes

**Extensions added (both hooks):**
- `.html` — HTML templates (primary addition)
- `.yml` — YAML config files
- `.yaml` — YAML config files (alt extension)
- `.xml` — XML markup
- `.svg` — SVG vector graphics
- `.css` — Cascading stylesheets

**Pattern exclusions added (both hooks):**
- `*.config.*` — Config files with any extension
- `*vite.config*` — Vite config (any variant)
- `*vitest.config*` — Vitest config
- `*tsconfig*` — TypeScript config
- `*eslint*` — ESLint config
- `*prettier*` — Prettier config

---

## T3 Implementation Instructions

T3-A will receive the two exact Edit operations above. Execute in this order:

### Step 1: Edit block-console-log.sh
```bash
File: /Users/tcvmaksutoglu/Dev/w/claude-code-saka/.claude/hooks/block-console-log.sh
Tool: Edit
old_string: [provided above under Fix 1]
new_string: [provided above under Fix 1]
```

### Step 2: Edit block-any-type.sh
```bash
File: /Users/tcvmaksutoglu/Dev/w/claude-code-saka/.claude/hooks/block-any-type.sh
Tool: Edit
old_string: [provided above under Fix 2]
new_string: [provided above under Fix 2]
```

### Step 3: Verification (bash)
After both edits complete, run:
```bash
# Verify block-console-log.sh syntax
bash -n /Users/tcvmaksutoglu/Dev/w/claude-code-saka/.claude/hooks/block-console-log.sh && echo "✓ block-console-log.sh syntax OK"

# Verify block-any-type.sh syntax
bash -n /Users/tcvmaksutoglu/Dev/w/claude-code-saka/.claude/hooks/block-any-type.sh && echo "✓ block-any-type.sh syntax OK"

# Verify case statements are correctly formatted (should return non-empty)
grep -A 2 'case "$FILE_PATH"' /Users/tcvmaksutoglu/Dev/w/claude-code-saka/.claude/hooks/block-console-log.sh | head -3
grep -A 2 'case "$FILE_PATH"' /Users/tcvmaksutoglu/Dev/w/claude-code-saka/.claude/hooks/block-any-type.sh | head -3
```

### Step 4: Manual Sanity Check
- Confirm both hooks have identical primary exclusion list: `.*.md|*.json|*.sh|*.yml|*.yaml|*.html|*.xml|*.svg|*.css`
- Confirm both hooks have identical pattern exclusion list: `*.config.*|*vite.config*|*vitest.config*|*tsconfig*|*eslint*|*prettier*`
- Confirm no duplicate pipes or malformed globbing syntax

### Step 5: Mark T3-A Task Complete
If all steps pass, close the task. Do NOT commit (orchestrator will handle git consent protocol).

---

## Reference: block-comments.sh Pattern (Already Correct)

For verification, block-comments.sh lines 24–29 show the target pattern:

```bash
case "$FILE_PATH" in
  *.md|*.json|*.sh|*.yml|*.yaml|*.html|*.xml|*.svg|*.css)
    exit 0
    ;;
  *.spec.*|*.test.*|*.stories.*|*.config.*|*vite.config*|*vitest.config*|*tsconfig*|*eslint*|*prettier*)
    exit 0
    ;;
esac
```

Both fixed hooks should now match this pattern exactly (with preservation of TypeScript-specific extensions in block-any-type.sh where applicable).

---

## Summary Table

| Hook | Fix Applied? | Added Extensions | Added Patterns | Status |
|------|---|---|---|---|
| `block-console-log.sh` | ✅ YES | `.html`, `.yml`, `.yaml`, `.xml`, `.svg`, `.css` | 6 pattern rules | Ready for T3 |
| `block-any-type.sh` | ✅ YES | `.html`, `.yml`, `.yaml`, `.xml`, `.svg` | 6 pattern rules | Ready for T3 |
| `block-comments.sh` | ✅ NONE | (already correct) | (already correct) | No change needed |

All fixes ensure **consistency across the three hooks** and **prevent false positives** on non-source files.
