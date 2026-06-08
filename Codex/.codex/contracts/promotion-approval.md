# Promotion Approval Contract

When runtime workers write into `workspace-mirror`, the system should emit:
- a per-file unified diff under `.codex/runtime/runs/<run_id>/diffs/`
- a machine-readable candidate manifest at `.codex/runtime/runs/<run_id>/promotion-candidates.json`
- a human-readable approval summary at `.codex/runtime/runs/<run_id>/promotion-summary.md`

Rules:
- mirror writes do not automatically modify live repo targets
- promotion requires human approval in a later explicit step
- approval artifacts must preserve target path, mirror path, and diff path

Apply step support:
- `./bin/team-apply <run_id> --approve <target>`
- `./bin/team-apply <run_id> --approve-all`
- applied results are logged under `.codex/runtime/runs/<run_id>/apply-logs/`
- human-readable apply result is written to `.codex/runtime/runs/<run_id>/apply-summary.md`

Extended apply protections:
- file-locking prevents concurrent apply/write collisions within a run
- rollback snapshots are written under `.codex/runtime/runs/<run_id>/rollback/`
- rollback manifest is written to `.codex/runtime/runs/<run_id>/rollback-manifest.json`
- post-apply validation artifacts are written under `.codex/runtime/runs/<run_id>/validation/`

Rollback support:
- `./bin/team-rollback <run_id> --all`
- `./bin/team-rollback <run_id> --target README.md`
- rollback writes `rollback-summary.md` and `rollback-log.json`
- semantic validation runs during apply for markdown/json/python/shell targets

Git-aware apply reporting:
- apply writes `git-report.md` and `git-report.json`
- reports include `git status --short`, diff snapshot, and staged diff snapshot

Git workflow support:
- `./bin/team-git stage <run_id> <target...>`
- `./bin/team-git commit <run_id> <message>`
- `./bin/team-git pr <run_id> <title> <body> [base] [head]` (dry-run by default)
- artifacts: `stage-report.*`, `commit-report.*`, `pr-report.*`
