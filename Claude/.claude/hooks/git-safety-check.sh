#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)

COMMAND=$(echo "$INPUT" | grep -o '"command"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')

if [ -z "$COMMAND" ]; then
  exit 0
fi

if ! echo "$COMMAND" | grep -q "git "; then
  exit 0
fi

case "$COMMAND" in
  *"git status"*|*"git diff"*|*"git log"*|*"git show"*|*"git branch"*|*"git remote"*|*"git stash list"*|*"git tag"*)
    exit 0
    ;;
esac

if echo "$COMMAND" | grep -qE 'git\s+(push|merge|rebase|reset|checkout\s+-b|branch\s+-[dD]|cherry-pick|revert|stash\s+(push|pop|drop|apply|save))'; then
  echo "WARNING: Destructive git operation detected: '$COMMAND'. This requires explicit user consent. Confirm with the user before proceeding." >&2
  exit 2
fi

if echo "$COMMAND" | grep -qE 'git\s+(commit|add|tag\s+[^-l])'; then
  echo "BLOCKED: Git write operation requires explicit user consent. Command: '$COMMAND'. See .claude/rules/git-safety.md" >&2
  exit 2
fi

exit 0
