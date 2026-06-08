# Git Operation Safety Rules

## Consent Requirement

**Explicit, unambiguous text consent** is required before any write-level git operation — commit, push, merge, rebase, or any command that mutates history or index. **No exceptions.**

## What Counts as Consent

| Phrase | Valid? |
|---|---|
| "Commit it" / "Go ahead and commit" | Yes |
| "Stage and commit the changes" | Yes |
| "Push it" / "You can push" | Yes |
| "I approve" (implementation context) | **No** |
| "Continue" / "Go on" / "OK" / "Yes" | **No** |
| "Apply the plan" / "Make the changes" | **No** |

General affirmations like "OK", "Yes", "Continue" are **never** valid git consent. The user must **explicitly reference a git operation**.

## Correct Workflow

1. Make code changes.
2. Show what changed — run `git status`, `git diff`.
3. **Always ask**: "Would you like me to commit these changes?"
4. **Only proceed** when the user gives explicit git-specific approval.

## Safe Operations (No Consent Needed)

`git status`, `git diff`, `git log`, `git show`, `git branch` (list), `git remote -v`, `git stash list`, `git tag -l`

## Prohibited Without Consent

`git add`, `git commit`, `git push`, `git pull`, `git merge`, `git rebase`, `git checkout -b`, `git branch -d`, `git reset`, `git revert`, `git stash`, `git cherry-pick`

## Enforcement

This rule is enforced by the `git-safety-check.sh` hook. Destructive operations (push, merge, rebase, reset, branch delete) are **blocked** by the hook. Write operations (commit, add) trigger a warning.
