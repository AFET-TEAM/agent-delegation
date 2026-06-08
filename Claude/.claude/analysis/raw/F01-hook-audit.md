---
task-id: F01
agent: Onur Ardic
tier: T5
status: Complete
date: 2026-06-02
---

# Hook Audit: .html Exclusion Pattern

## block-comments.sh — Reference Pattern

### File Path Extraction
Lines 9-21 extract `FILE_PATH` from tool_input JSON:

```bash
# With jq (preferred):
FILE_PATH=$(jq -r '.tool_input.file_path // .tool_input.path // empty' <<<"$INPUT")

# Fallback (grep + sed):
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
if [ -z "$FILE_PATH" ]; then
  FILE_PATH=$(echo "$INPUT" | grep -o '"path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
fi
```

### Extension Check Logic
**Lines 23-30**: Case statement pattern matching:

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

### Extensions Currently Excluded
**Primary exclusions (line 24):**
- `*.md`, `*.json`, `*.sh`, `*.yml`, `*.yaml`, **`*.html`**, `*.xml`, `*.svg`, `*.css`

**Pattern exclusions (line 27):**
- `*.spec.*`, `*.test.*`, `*.stories.*`, `*.config.*`, `*vite.config*`, `*vitest.config*`, `*tsconfig*`, `*eslint*`, `*prettier*`

**Note:** `.html` is already included in the reference pattern on line 24.

---

## block-console-log.sh — Current State

### Full Content
```bash
#!/usr/bin/env bash
set -euo pipefail

# Require CLAUDE_PROJECT_DIR
: "${CLAUDE_PROJECT_DIR:?CLAUDE_PROJECT_DIR must be set}"

INPUT=$(cat)

if command -v jq >/dev/null 2>&1; then
  FILE_PATH=$(jq -r '.tool_input.file_path // .tool_input.path // empty' <<<"$INPUT")
  CONTENT=$(jq -r '.tool_input.content // .tool_input.new_string // empty' <<<"$INPUT")
else
  FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  if [ -z "$FILE_PATH" ]; then
    FILE_PATH=$(echo "$INPUT" | grep -o '"path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  fi
  CONTENT=$(echo "$INPUT" | grep -o '"new_string"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  if [ -z "$CONTENT" ]; then
    CONTENT=$(echo "$INPUT" | grep -o '"content"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  fi
fi

case "$FILE_PATH" in
  *.spec.*|*.test.*|*.stories.*|*.md|*.json|*.sh)
    exit 0
    ;;
esac

if [ -z "$CONTENT" ]; then
  exit 0
fi

if echo "$CONTENT" | grep -qE 'console\.(log|warn|error|debug|info|table|time|timeEnd|trace|dir|count|group|groupEnd|clear|assert|profile|profileEnd)\s*\('; then
  echo "BLOCKED: console.* statements are prohibited in production code. Use a structured logging service instead." >&2
  exit 2
fi

if echo "$CONTENT" | grep -qE '\balert\s*\(|\bconfirm\s*\(|\bprompt\s*\('; then
  echo "BLOCKED: alert(), confirm(), prompt() are prohibited. Use Ant Design Modal or notification instead." >&2
  exit 2
fi

exit 0
```

### Missing: .html Exclusion
**Line 23-27** defines the case statement, but `*.html` is NOT in the exclusion list.

Currently excluded: `*.spec.*|*.test.*|*.stories.*|*.md|*.json|*.sh`

**Missing:** `*.html` and other file types present in reference pattern (`.yml`, `.yaml`, `.xml`, `.svg`, `.css`)

---

## block-any-type.sh — Current State

### Full Content
```bash
#!/usr/bin/env bash
set -euo pipefail

# Require CLAUDE_PROJECT_DIR
: "${CLAUDE_PROJECT_DIR:?CLAUDE_PROJECT_DIR must be set}"

INPUT=$(cat)

if command -v jq >/dev/null 2>&1; then
  FILE_PATH=$(jq -r '.tool_input.file_path // .tool_input.path // empty' <<<"$INPUT")
  CONTENT=$(jq -r '.tool_input.content // .tool_input.new_string // empty' <<<"$INPUT")
else
  FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  if [ -z "$FILE_PATH" ]; then
    FILE_PATH=$(echo "$INPUT" | grep -o '"path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  fi
  CONTENT=$(echo "$INPUT" | grep -o '"new_string"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  if [ -z "$CONTENT" ]; then
    CONTENT=$(echo "$INPUT" | grep -o '"content"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  fi
fi

case "$FILE_PATH" in
  *.spec.*|*.test.*|*.d.ts|*.md|*.json|*.sh|*.scss|*.css)
    exit 0
    ;;
esac

if [ -z "$CONTENT" ]; then
  exit 0
fi

if echo "$CONTENT" | grep -qE ':\s*any\b|as\s+any\b|<any>|<any,'; then
  echo "BLOCKED: TypeScript 'any' type is prohibited. Use 'unknown' with type narrowing, or define a proper type/interface." >&2
  exit 2
fi

if echo "$CONTENT" | grep -qE '@ts-ignore|@ts-expect-error'; then
  echo "BLOCKED: @ts-ignore and @ts-expect-error are prohibited without a documented issue reference." >&2
  exit 2
fi

exit 0
```

### Missing: .html Exclusion
**Line 23-27** defines the case statement, but `*.html` is NOT in the exclusion list.

Currently excluded: `*.spec.*|*.test.*|*.d.ts|*.md|*.json|*.sh|*.scss|*.css`

**Missing:** `*.html` and other file types present in reference pattern (`.yml`, `.yaml`, `.xml`, `.svg`)

---

## Exact Fixes Needed

### For block-console-log.sh

**Current line 23-27:**
```bash
case "$FILE_PATH" in
  *.spec.*|*.test.*|*.stories.*|*.md|*.json|*.sh)
    exit 0
    ;;
esac
```

**Replace with:**
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

**Rationale:** Align with reference pattern in block-comments.sh. Add `.html`, `.yml`, `.yaml`, `.xml`, `.svg`, `.css` and pattern-based exclusions.

### For block-any-type.sh

**Current line 23-27:**
```bash
case "$FILE_PATH" in
  *.spec.*|*.test.*|*.d.ts|*.md|*.json|*.sh|*.scss|*.css)
    exit 0
    ;;
esac
```

**Replace with:**
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

**Rationale:** Add `.html`, `.yml`, `.yaml`, `.xml`, `.svg` (not previously listed). TypeScript-specific files (`.d.ts`) already present, no duplication needed.

---

## Hook Wiring Verification

From `.claude/settings.json` (lines 66-126):

**PreToolUse:Edit|Write|MultiEdit hooks:**
- `block-console-log.sh` (line 73) ✓ wired
- `block-any-type.sh` (line 78) ✓ wired
- `block-comments.sh` (line 83) ✓ wired

All three hooks are active and execute in PreToolUse:Edit/Write/MultiEdit events. Fixes will apply immediately upon configuration.

---

## Summary

| Hook | Current .html? | Fix Status |
|------|---|---|
| `block-comments.sh` | ✓ YES (line 24) | No change needed |
| `block-console-log.sh` | ✗ NO (missing) | Add to line 24 case pattern |
| `block-any-type.sh` | ✗ NO (missing) | Add to line 24 case pattern |

**Consistency Gap:** Two of three hooks are missing `.html` exclusion, causing HTML template files to fail validation for console statements and `any` types (which are invalid in `.html` anyway).

**Recommended Edit Sequence for T2:**
1. Edit `block-console-log.sh`: Replace lines 23-27
2. Edit `block-any-type.sh`: Replace lines 23-27
3. No edit needed for `block-comments.sh` (already compliant)

Fixes ensure all three hooks exclude the same file types consistently.
