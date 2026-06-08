---
pattern-id: LP-2026-05-20-02
name: graphify hook install Silently Modifies Git Hooks
category: security
hit-count: 0
last-triggered: null
sessions-since-hit: 1
---

# Error
`graphify hook install` command modifies `.git/hooks/post-commit` without a confirmation prompt. Users who run this during standard setup may not realize they've installed a persistent post-commit hook that triggers graphify rebuilds on every commit.

# Fix
Document this explicitly in installation guides. Add warning: "Do NOT run `graphify hook install` during setup — use the `.graphify-stale` marker approach instead (already handled by `.claude/hooks/graphify-rebuild.sh`)." If users want git-hook-based rebuilds, they should explicitly opt in.

# Rule
Any command that modifies `.git/hooks/` is a write-level git operation per `.claude/rules/git-safety.md`. Always surface this to the user before executing. Include `graphify hook remove` command in documentation so users can undo if they ran it accidentally.

# Context
Caught by T2-B (Tarik Ziya Yesilcinen) during review of graphify-install.md in session 2026-05-20-context-graphify-x10. T3 (Canan Birsen) missed this; T2 added the warning section directly.
