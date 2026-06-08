# Frequently Asked Questions

---

## General

### What is this system?

The Claude Code Multi-Agent Delegation System is an orchestration layer that distributes software engineering tasks across a structured team of AI agents. Instead of routing everything to a single model, work is assigned by complexity: research goes to fast Haiku analysts, implementation goes to Sonnet engineers, and architectural decisions go to Opus principals.

The Orchestrator (your main Claude session) coordinates the team, manages the review chain, enforces code quality hooks, and consolidates outputs into a final result.

---

### Who is this for?

Development teams and individual engineers who want:
- Consistent, reviewed code output from Claude Code
- Automatic enforcement of coding standards (no console.log, no `any` types, no SQL injection, etc.)
- Transparent multi-agent execution with performance tracking
- A self-improving system that learns from past errors

It is not needed for trivial one-off questions or single-line fixes. The system itself detects trivial tasks and handles them in single-agent mode automatically.

---

### Can I use this on any project?

Yes. The `.claude/` directory is portable — copy it to any project root and the system works. The hooks and rules are language-agnostic at the meta level, though specific rule files target TypeScript/React and Java/Spring Boot. You can add or modify rule files for other stacks.

---

### What is the difference between x2 and x10 mode?

Both are multi-agent modes, but they differ in team size, review depth, and cost:

- **x2**: 2 agents (T1 Principal + T5 Analyst). Best for architectural research with no implementation. T1 acts as Lead Analyst, reviewing T5 output directly.
- **x10**: 10 agents (2 of each tier). Maximum analysis depth and parallel execution. Best for critical system overhauls or large sprints across multiple modules.

x2 costs ~$2–3. x10 costs ~$12–18. x5 (5 agents, one per tier) is the recommended default for standard feature work at ~$4–6.

---

## Setup

### Do I need both context-mode and graphify?

No, both are optional enhancements:

- **context-mode** prevents context window flooding during large analysis sessions. Required only if your sessions involve reading many large files or you need cross-session knowledge retrieval.
- **graphify** builds queryable knowledge graphs from codebases with >20 files. Required only if T5 agents need to answer topology questions ("what depends on X?", "which are the god classes?").

The core multi-agent system (tiers, hooks, review chain, learning loop) works without either tool.

---

### Can I use this on Linux?

Yes. The system is tested on macOS and Linux (Debian/Ubuntu/Alpine). WSL also works. The only macOS-specific issue is Bash version: macOS ships with Bash 3.2, which causes leaderboard updates to be silently skipped. On Linux, Bash 5 is typically the default, so this issue does not arise.

---

### Does graphify send my code to an external API?

Only if you run it without `--local-only`. The system always uses `--local-only` for code-only analysis, which processes everything with a local tree-sitter parser. No code leaves your machine.

The `--mode deep` option uses the Anthropic API for semantic relationship extraction from documents and comments. Never use deep mode on proprietary or confidential codebases without reviewing what data is sent.

---

### The PyPI package name has a typo (`graphifyy`)?

This is intentional — the package is named `graphifyy` (double-y) on PyPI. This is the correct package name for the version integrated here. Always install with:

```bash
uv tool install "graphifyy[all]"
```

Verify after install: `pip show graphifyy`

---

## Usage

### How do I pick an xN value?

Use this decision guide:

| Task Characteristics | Recommended Mode |
|---------------------|-----------------|
| Single file, trivial scope | None (single-agent) |
| Research or review only, no code | x2 |
| Small feature (<3 files), senior review needed | x3 |
| Standard feature (3–5 files) | x4 or x5 |
| Multi-module feature, full review chain | x5 (default) |
| Multiple parallel tracks (e.g., auth + tests) | x7 |
| Critical system change, full codebase scope | x10 |

When in doubt, use x5. It provides the full review chain at a reasonable cost and is the system's recommended default.

---

### Can I undo a session?

The system does not make git commits automatically — all file edits are staged in your working directory. You can undo changes with standard git tools:

```bash
git diff           # See what changed
git checkout .     # Revert all changes (caution: destructive)
git checkout -- src/specific/file.ts   # Revert one file
```

Git operations require explicit consent per `.claude/rules/git-safety.md`. The system will never commit, push, or merge without your explicit instruction.

---

### What is the Prompt Enrichment Protocol (PEP)?

Before starting a multi-agent task, the Orchestrator asks 3–7 clarifying questions about requirements, assumptions, and scope. This prevents wasted agent work on misunderstood requirements.

PEP is skipped for trivial tasks (fewer than 3 lines, touches at most 1 file, no business logic). You can also skip it by saying "skip questions" in your prompt.

---

### Can agents communicate with each other directly?

No. All inter-agent communication flows through the Orchestrator. T5 writes to `.claude/analysis/raw/`, T4 reads that and writes to `.claude/analysis/consolidated/`, and the Orchestrator reads both and passes findings to coding agents via their spawn prompts.

Agents cannot read each other's files directly during execution, and they cannot invoke other agents.

---

### What happens if an agent exceeds its token budget?

The Overflow Protocol applies:
1. If the sub-task can be split, the Orchestrator splits it and assigns parts to multiple agents
2. If it cannot be split (e.g., a single-file rewrite), it escalates to the next tier up

Each tier has a defined `max_tokens_per_task` in `.claude/config/context-budget.json`. T3 MidCoder: 5000, T2 Staff Engineer: 10000, T1 Principal: 15000.

---

## Cost and Tokens

### Does x10 cost 10 times more than single-agent?

No. "Single-agent" in this context means all work done by the Orchestrator or T1 Principal at opus pricing. x10 distributes work across cheaper tiers (haiku is ~12× cheaper than opus per token).

Cost comparison for a typical feature:
- All-opus single-agent: ~$8–10
- x5 (mixed tiers): ~$4–6
- x10 (full team): ~$12–18

x10 is more expensive than x5, but often less expensive than routing everything to T1.

---

### What is the token budget per tier?

Per `.claude/config/context-budget.json`:

| Tier | Model | Max Tokens/Task |
|------|-------|----------------|
| T1 Principal | opus | 15,000 |
| T2 Staff Engineer | sonnet | 10,000 |
| T3 MidCoder | sonnet | 5,000 |
| T4 Lead Analyst | haiku | 8,000 |
| T5 Analyst | haiku | 6,000 |

---

## Security

### Are my credentials safe when using context-mode?

context-mode has a deny-path list that prevents execution against credential-adjacent paths:

Denied paths: `~/.ssh/`, `~/.aws/`, `~/.kube/`, `~/.gnupg/`, `./.env`, `./secrets/`

These are enforced by the `context-mode-guard.sh` hook. Additionally, `ctx_fetch_and_index` blocks internal network targets (127.0.0.1, 192.168.x.x, 10.x.x.x, metadata endpoints).

context-mode is a context reduction tool, not a security sandbox. Do not run it on shared systems or cloud VMs without completing the full hardening sprint documented in `.claude/docs/context-mode-integration-design.md`.

---

### Can the hooks themselves be bypassed?

Hooks run as shell scripts executed by Claude Code's harness. The harness enforces their exit codes — exit 2 blocks the tool call at the platform level, regardless of what Claude Code itself thinks about the content.

You cannot bypass hooks from within a Claude session. To modify hook behavior, you must directly edit the hook script files in `.claude/hooks/` and (for destructive git ops) the hook will ask for explicit consent before proceeding anyway.

---

## Customization

### How do I add a new hook?

1. Create your hook script in `.claude/hooks/`:
   ```bash
   #!/usr/bin/env bash
   set -euo pipefail
   INPUT=$(cat)
   FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')
   CONTENT=$(echo "$INPUT" | jq -r '.tool_input.new_string // ""')

   # Exempt non-source files
   case "$FILE_PATH" in
     *.md|*.sh|*.json) exit 0 ;;
   esac

   if echo "$CONTENT" | grep -qE 'your_prohibited_pattern'; then
     echo "BLOCKED: Description of what was blocked." >&2
     exit 2
   fi
   exit 0
   ```
2. Make it executable: `chmod +x .claude/hooks/your-hook.sh`
3. Register it in `.claude/settings.json` under the appropriate event (`PreToolUse:Edit`, `PostToolUse:Write`, etc.)
4. Add it to `.claude/config/hook-registry.md`

See `.claude/docs/hook-exit-codes.md` for exit code contract.

---

### How do I add a new rule file?

1. Create your rule file in `.claude/rules/` following the existing format
2. Add a reference in the Key Configuration Files table in `CLAUDE.md`
3. Update the rule count in `CLAUDE.md` if you change the total
4. Rules are automatically loaded as context by agent spawn prompts for relevant tiers

---

### How do I add a new agent tier or modify an existing agent?

Agent prompt templates live in `.claude/agents/{role}.md`. To customize:
1. Read the existing template
2. Edit to add domain-specific guidelines (e.g., React-specific patterns for T3)
3. The Orchestrator will use your modified template on the next spawn

To add a new specialized agent (e.g., a database-specialist T3), create a new template file and reference it explicitly in the Orchestrator prompt for applicable task types.

---

### How do learned patterns get promoted to permanent rules?

The lifecycle is automatic:
1. `self-learning-collector.sh` (PostToolUse) detects when the same file is edited 2+ times in a session and creates a pattern file in `.claude/memory/learned-patterns/`
2. `pattern-lifecycle.sh` (SessionEnd) scans each pattern against session content. A match increments `hit-count`
3. At `hit-count >= 3`, the pattern is appended to `.claude/rules/learned-{category}.md` with a deduplication marker
4. At `sessions-since-hit >= 5` with `hit-count == 0`, the pattern is archived (not deleted)

You can manually create patterns by writing files with the correct frontmatter to `.claude/memory/learned-patterns/`.

---

### Why does caveman mode not affect code blocks?

Caveman mode compresses Orchestrator-to-user prose only. Code blocks, file paths, error messages, shell commands, SQL queries, regex patterns, and version strings are always output verbatim — compressing them would introduce ambiguity or errors. Security warnings and git consent dialogs also bypass caveman compression.

The full list of verbatim-preserved content is in `.claude/rules/caveman.md`.

---

## Performance Tracking

### How do I view agent performance metrics?

```bash
cat .claude/metrics/leaderboard.md     # Agent scores and tier placement
cat .claude/metrics/agent-performance.md  # Detailed per-session performance
cat .claude/metrics/token-usage.md    # Token consumption tracking
```

Each session's performance report is also saved to `.claude/memory/sessions/`.

---

### What do the leaderboard scores mean?

| Score Range | Tier | Selection Weight |
|-------------|------|-----------------|
| 50+ | S-tier | 2.0× |
| 20–49 | A-tier | 1.5× |
| 0–19 | B-tier | 1.0× |
| -1 to -20 | C-tier | 0.8× |
| Below -20 | D-tier | 0.5× |

Score changes per session:
- Task completed: +5
- Task failed: -5
- Code review first-pass: +3
- Found P0/P1 issue: +4
- Unnecessary escalation: -2
- Model fallback used: -1

Higher-scoring agents are more likely to be selected for new tasks, but all 20 names in the pool receive work over time.
