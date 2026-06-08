# Git Safety Rules

## 1. Explicit Consent Requirement

The following require explicit user approval every time:
- git add
- git commit
- git push
- git pull
- git merge
- git rebase
- git reset
- git revert
- git stash

## 2. What Does Not Count As Consent

General affirmations like:
- yes
- okay
- continue
- go ahead

are not sufficient unless they clearly reference the git action.

## 3. Safe Read-Only Commands

Allowed without consent:
- git status
- git diff
- git log
- git show

## 4. Operational Scenarios

If the user says “continue”, you may continue analysis or coding, but not commit or push unless the git action is explicitly authorized.
