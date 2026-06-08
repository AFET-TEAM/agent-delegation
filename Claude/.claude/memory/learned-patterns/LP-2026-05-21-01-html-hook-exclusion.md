---
pattern-id: LP-2026-05-21-01
name: HTML files must be excluded from console/any-type hooks
category: hooks
hit-count: 0
last-triggered: null
sessions-since-hit: 0
---

# Error
When writing HTML documentation that mentions technical terms (`console.log`, `: any`, etc.) verbatim, the hooks `block-console-log.sh` and `block-any-type.sh` trigger BLOCKED on the Write operation. This forces docs authors to use prose paraphrases instead of accurate technical terminology, reducing documentation precision.

# Fix
Add `*.html` to the file-type exclusion case statements in:
- `.claude/hooks/block-console-log.sh`
- `.claude/hooks/block-any-type.sh`

Reference pattern: `.claude/hooks/block-comments.sh` already excludes `*.html` correctly.

# Rule
Documentation files (`.md`, `.html`, `.txt`) should NOT be subject to source-code linting hooks. The hooks protect application code from `console.log`, `any` type, and inline comments — but docs files exist precisely to describe these patterns in plain text.

**Why:** Documentation precision requires accurate terminology. Paraphrasing "console.log" as "console statements" makes the docs less useful for developers searching for exact pattern names.

**How to apply:** When creating a new file-content guard hook, always include `*.html`, `*.md`, `*.txt` in the file-type exclusion case statement before pattern matching.

# Context
Discovered in session 2026-05-21-deep-analysis-html-docs-x10 during G11 (HTML documentation creation by T1-A Selin Akar). The agent had to remove `console.log(` literal patterns and `: string` / `: UpdateUserInput` type annotations from code examples to write the file. This is a workaround, not a fix — the hooks themselves should exclude HTML.
