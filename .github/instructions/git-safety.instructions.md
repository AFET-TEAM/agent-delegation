---
applyTo: "**"
---

# Git Operation Safety Rules

> These rules are MANDATORY for all agents that perform git operations.

## Consent Requirement

AI agents **MUST** obtain **explicit, unambiguous text consent** from the user before executing any write-level git operation — commit, push, merge, rebase, or any command that mutates the repository history or working tree index. **There are NO exceptions to this rule.**

### Correct Workflow

1. Make code changes (no consent needed).
2. Show the user what changed — run `git status`, `git diff`.
3. **Always ask**: _"Would you like me to commit these changes?"_ or similar.
4. **Only proceed** when the user gives an explicit git-specific approval.

## What Counts as Consent

| Phrase | Counts as Git Consent? |
|---|---|
| "Commit it" | ✅ Yes |
| "Go ahead and commit" | ✅ Yes |
| "Stage and commit the changes" | ✅ Yes |
| "You can git commit" | ✅ Yes |
| "Push it" / "You can push" | ✅ Yes |
| "You can merge" | ✅ Yes |
| "I approve" (implementation context) | ❌ **No** |
| "Continue" / "Go on" | ❌ **No** |
| "OK" / "Yes" | ❌ **No** |
| "Apply the plan" | ❌ **No** |
| "Make the changes" | ❌ **No** |

> General affirmations like "OK", "Yes", "Continue" are **never** valid git consent.
> The user must **explicitly reference a git operation** in their approval.

## Prohibited Without Consent

The following commands require explicit consent **every time**:

```bash
git add <file>
git commit -m "message"
git push
git pull
git merge
git rebase
git checkout -b <branch>
git branch -d <branch>
git reset
git revert
git stash
git cherry-pick
```

## Safe Operations (No Consent Needed)

Read-only commands that **do not** mutate the repository may be run freely:

```bash
git status
git diff
git log
git show
git branch          # list only, no -d / -D
git remote -v
git stash list
git tag -l
```

## Why This Matters

- **Git history belongs to the user** — only they decide what gets recorded.
- **Commit messages are a user choice** — agents must not author them silently.
- **Write operations are hard to reverse** — especially push, rebase, and reset.
- **Team workflow impact** — unauthorized pushes or merges can disrupt the entire team.
