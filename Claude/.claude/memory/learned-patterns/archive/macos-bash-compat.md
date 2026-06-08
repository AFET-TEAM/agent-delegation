---
pattern-id: macos-bash-compat
category: hooks
hit-count: 0
last-triggered: null
sessions-since-hit: 5
created: 2026-04-22
source: session-2026-04-22-cycle1
---

# Learned Pattern

## Error

macOS default Bash is 3.2 (not upgradable by Apple due to GPLv3 licensing). Hooks written with Bash 4+ features fail at runtime:
- `declare -A` (associative arrays) — syntax error
- `${var,,}` / `${var^^}` (case conversion) — syntax error
- Namerefs (`declare -n`) — not supported
- `mapfile` / `readarray` — not available

Additionally, `flock` is Linux-only by default; macOS needs `brew install flock` or a fallback (e.g., `mkdir`-based locking).

Session 2026-04-22 `update-leaderboard.sh` hit both issues on first run.

## Fix

1. Add a Bash version check at the top of any hook using Bash 4+ features:
   ```bash
   if [ "${BASH_VERSINFO[0]:-0}" -lt 4 ]; then
     echo "INFO: requires Bash 4+. Install via 'brew install bash' and use /opt/homebrew/bin/bash shebang." >&2
     exit 0
   fi
   ```
2. For locking, fall back to `mkdir` atomicity when `flock` is unavailable:
   ```bash
   if command -v flock >/dev/null 2>&1; then
     exec 200>"$LOCKFILE"; flock -n 200 || exit 0
   else
     LOCKDIR="${LOCKFILE}.d"; mkdir "$LOCKDIR" 2>/dev/null || exit 0
     trap 'rmdir "$LOCKDIR" 2>/dev/null || true' EXIT
   fi
   ```
3. Alternative: rewrite hooks in POSIX-only Bash (avoid assoc arrays — use parallel arrays or named variables).

## Rule

Any hook script targeting macOS compatibility must either: (a) require Bash 4+ explicitly with a version check, (b) use POSIX-only Bash, or (c) be rewritten in Python/another cross-platform language. Always check `command -v` for any non-POSIX utility (flock, timeout, gdate, etc.) before invoking.

## Context

Applies when:
- Writing shell hooks in `.claude/hooks/`
- Working on multi-platform projects where macOS is a target
- Using Bash 4+ features (assoc arrays, namerefs, mapfile)

## References

- Source session: 2026-04-22-cycle1
- Affected file: `.claude/hooks/update-leaderboard.sh` (lines 6-10 added version check)
- Related: metrics-tracking.md §Troubleshooting
