# Getting Started — Claude Code Multi-Agent System

## What is This?

This is the Claude Code Multi-Agent Delegation System (v1.0.0) — an orchestration layer built on top of Claude Code that distributes software engineering tasks across a structured team of specialized AI agents. Rather than routing every request to a single model, the system assigns work to the right tier: research tasks go to fast Haiku analysts, implementation goes to Sonnet engineers, and architectural decisions go to Opus principals.

The system includes 19 enforcement hooks that automatically block prohibited patterns (SQL injection, hardcoded credentials, console.log in production, TypeScript `any` types), a self-learning loop that promotes repeated error patterns into permanent rules, and a metrics layer that tracks agent performance across sessions.

It is designed for development teams that want consistent, reviewed, production-ready output from Claude Code — not just quick drafts.

---

## 60-Second Overview

- **5 tiers**: T1 Principal (opus), T2 Staff Engineer (sonnet), T3 MidCoder (sonnet), T4 Lead Analyst (haiku), T5 Analyst (haiku)
- **19 enforcement hooks**: Pre/post tool validation, session lifecycle management
- **19 rule files**: Clean code, architecture, security, testing, backend, React, PR standards
- **xN modes**: x2 through x10, scaling team size and review depth
- **6 slash commands**: `/ctx`, `/graphify`, `/caveman`, `/review`, `/security-review`, `/architect`
- **Self-learning**: Repeated errors become patterns; patterns with 3+ hits become permanent rules

---

## Prerequisites

Before running setup, ensure you have:

| Requirement | Version | Purpose | Required? |
|-------------|---------|---------|-----------|
| macOS, Linux, or WSL | — | Operating system | Required |
| Claude Code CLI | Latest | Runs the system | Required |
| Node.js | 18+ | context-mode MCP server | Required |
| jq | Any | Hook JSON parsing | Required |
| awk | Any | Scoring calculations | Required |
| Python | 3.10+ | graphify knowledge graph | Optional |
| uv or pipx | Any | Python tool installer | Optional |
| Bash | **4+** | Leaderboard atomic updates | Recommended |

### Bash 4+ on macOS

macOS ships with Bash 3.2 (GPL-2 licensed). The leaderboard update hook (`update-leaderboard.sh`) requires Bash 4+ for associative arrays and the `flock` locking pattern.

**Without Bash 4+**: All features work normally. Leaderboard scores will NOT update at session end.

**Install Bash 4+**:

```bash
brew install bash
```

After installation, add the new shell to `/etc/shells`:

```bash
echo "/opt/homebrew/bin/bash" | sudo tee -a /etc/shells
```

To use as default shell (optional):

```bash
chsh -s /opt/homebrew/bin/bash
```

Note: Claude Code hooks will use the system Bash (`/bin/bash`) unless you update the shebang in hook files to `#!/opt/homebrew/bin/bash`.

---

## Installation

### Option A: One-Command Setup

From your project root (the directory containing `.claude/`):

```bash
bash .claude/scripts/setup.sh
```

This script:
1. Verifies Node.js 18+ is present
2. Caches the context-mode MCP package (`@context-mode/mcp@1.0.146`)
3. Detects Python 3.10+ and installs graphify via `uv`, `pipx`, or `pip`
4. Prints a setup summary

### Option B: Manual Setup

**Step 1: Verify Node.js**

```bash
node --version   # Must be v18 or higher
```

**Step 2: Cache context-mode**

```bash
npx --yes @context-mode/mcp@1.0.146 --version
```

**Step 3: Install graphify (optional)**

```bash
uv tool install "graphifyy[all]"
```

Note: The PyPI package name is `graphifyy` (double-y). Verify:

```bash
pip show graphifyy
graphify --version
```

**Step 4: Install jq**

```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq
```

### Verification

```bash
bash .claude/scripts/verify-install.sh
```

Expected output: a pass/warn/fail report for all 19 hooks, config files, runtime dependencies, and required directories.

---

## Your First Task

### Example 1: Simple Fix (no xN)

Type in Claude Code:

```
Bu typo'yu düzelt: src/utils/format.ts:23
```

What happens:
1. Orchestrator detects: single file, trivial scope, no xN — single-agent mode
2. File is read, typo is fixed
3. Hooks validate the edit (no violations expected for a typo fix)
4. Task complete in seconds
5. No session file created, no performance report (single-agent mode is lightweight)

**Cost**: Near zero  
**Time**: Seconds  
**When to use**: Typos, version bumps, single-line fixes

---

### Example 2: Feature with x3

Type in Claude Code:

```
Login endpoint'i ekle x3
```

What happens:
1. Orchestrator detects x3 → activates 3-agent mode
2. Prompt Enrichment Protocol (PEP) asks 3–7 clarifying questions (request/response format, auth required?, error codes)
3. You approve the plan
4. Wave 1: T5 Analyst (haiku) researches login patterns, security requirements
5. Wave 2: T2 Staff Engineer (sonnet) reviews T5 output
6. Wave 3: T1 Principal (opus) reviews T2's review — approved
7. Performance report printed at end

**Cost**: ~$2–3  
**Time**: ~8–10 minutes  
**When to use**: Small features, bug fixes with analysis needed, code review tasks

---

### Example 3: System-Wide with x10

Type in Claude Code:

```
Tüm error handling'i refactor et x10
```

What happens:
1. Full 10-agent team mobilized: 2×T5, 2×T4, 2×T3, 2×T2, 2×T1
2. Wave 1: 2 T5 Analysts research in parallel (current patterns, refactoring scope)
3. Wave 2: 2 T4 Lead Analysts consolidate findings in parallel
4. Wave 3: 2 T2 + 2 T3 agents design and implement in parallel
5. Wave 4+: Review chain runs sequentially up the tier ladder
6. Detailed performance report with all agent contributions, token usage, revision counts

**Cost**: ~$12–18  
**Time**: ~25–35 minutes  
**When to use**: System-wide changes, critical security overhauls, large refactoring sprints

---

## Key Concepts in 5 Minutes

### The 5 Tiers

| Tier | Role | Model | Best For |
|------|------|-------|---------|
| T1 Principal | Lead architect | opus | Architecture decisions, final review |
| T2 Staff Engineer | Senior implementation | sonnet | Service layer design, complex features |
| T3 MidCoder | Standard implementation | sonnet | API endpoints, entities, hooks |
| T4 Lead Analyst | Analysis consolidation | haiku | Synthesizing T5 research into briefs |
| T5 Analyst | Research + analysis | haiku | Codebase exploration, security research |

Cost-conscious rule: always delegate to the **lowest capable tier**. T5 (haiku) costs ~12x less per token than T1 (opus).

---

### xN Modes

| Mode | Agents | Cost | Use Case |
|------|--------|------|----------|
| None | 1 (Orchestrator) | ~$0.50 | Trivial tasks |
| x2 | 2 (T1 + T5) | ~$2–3 | Architecture review + research only |
| x3 | 3 (T1 + T2 + T5) | ~$2.50–3.50 | Small feature with senior review |
| x4 | 4 (T1 + T2 + T3 + T5) | ~$3–4 | Single module, standard development |
| x5 | 5 (one of each tier) | ~$4–6 | **Default: balanced team, full review chain** |
| x7 | 7 | ~$7–10 | Parallel research + design tracks |
| x10 | 10 (two of each tier) | ~$12–18 | Critical overhauls, multiple teams |

**Recommendation**: Start with x5. It is the best cost-to-depth ratio for standard features.

---

### The Review Chain

After coding agents finish, outputs pass up the review ladder:

```
T5 output → T4 Lead Analyst reviews
T3 output → T2 Staff Engineer reviews
T2 output → T1 Principal reviews
T1 output → Orchestrator consolidates
```

Each review can result in:
- Approved: move to next wave
- Revision Required: re-spawn agent with findings (max 2 rounds)
- Rejected (after 2 rounds): escalate to next-higher tier with full context

The review chain is automatic and cannot be skipped in multi-agent mode.

---

### Hooks System

19 shell scripts fire automatically at tool boundaries (before/after Edit, Write, Bash, and at session end). They block policy violations before they reach the codebase. Examples:

- `block-console-log.sh` — blocks `console.*` statements in production code
- `secret-guard.sh` — blocks hardcoded API keys and credentials
- `sql-injection-check.sh` — blocks SQL string concatenation
- `git-safety-check.sh` — blocks destructive git operations without explicit consent

Exit code 0 = pass. Exit code 2 = BLOCK (operation refused). Exit code 1 = hook infrastructure error (non-blocking).

See `.claude/docs/hook-exit-codes.md` for full reference.

---

### Skills (Slash Commands)

Skills are specialized capabilities you invoke with `/` commands:

| Command | Effect |
|---------|--------|
| `/ctx` | Activate context-mode tools (prevents context flooding) |
| `/graphify` | Build and query codebase knowledge graph |
| `/caveman` | Enable concise response mode (40–65% fewer words) |
| `/review` | Run structured code review on current branch changes |
| `/security-review` | Run security-focused audit on pending changes |
| `/architect` | Route directly to T1 Principal (no xN needed) |

---

## Session Output

After any multi-agent session, you will receive:

1. **Final implementation output** — code, analysis, or review findings
2. **Performance Report** — table of all agents, their tasks, status, token usage, revision counts
3. **Session file** — saved automatically to `.claude/memory/sessions/`
4. **Learned patterns** — if review failures occurred, new patterns are saved to `.claude/memory/learned-patterns/`
5. **Leaderboard update** — agent scores updated based on session outcomes

---

## Next Steps

- Read `.claude/docs/TOOLS_OVERVIEW.md` for context-mode + graphify combined usage
- Read `.claude/docs/TROUBLESHOOTING.md` if you hit setup or runtime issues
- Read `.claude/docs/ARCHITECTURE.md` for deep architectural reference
- Read `.claude/docs/FAQ.md` for common questions about modes, costs, and customization
- Read `.claude/docs/hook-exit-codes.md` for hook exit code semantics

---

## Cheat Sheet

### Slash Commands

| Command | Effect |
|---------|--------|
| `/ctx` | context-mode: run code without polluting context |
| `/graphify` | Build codebase knowledge graph |
| `/caveman` | Compressed prose output mode |
| `/review` | Code review checklist on current branch |
| `/security-review` | Security audit on pending changes |
| `/architect` | Direct to T1 Principal for architecture questions |

### xN Quick Reference

| xN | Agents | Cost | Best For |
|----|--------|------|---------|
| x2 | 2 | ~$2–3 | Architecture + research, no code |
| x3 | 3 | ~$2.50–3.50 | Small feature + senior review |
| x5 | 5 | ~$4–6 | Standard feature (recommended default) |
| x7 | 7 | ~$7–10 | Parallel tracks needed |
| x10 | 10 | ~$12–18 | Critical system work |

### Quick Fixes for Common Issues

**Node.js version too low**: `nvm use 18` or install from https://nodejs.org

**graphify not in PATH after install**: Add Python's bin directory to PATH, e.g. `export PATH="$HOME/.local/bin:$PATH"`

**Leaderboard not updating**: You likely have Bash 3.x. Run `brew install bash` and verify with `bash --version`.

**Hook blocking legitimate code**: Check which hook fired (look for `BLOCKED:` prefix in the error). The specific hook name and reason are always included.

**Active plan corrupted**: Delete `.claude/todo/active-plan.md` — the Orchestrator creates a fresh one on the next session.

For more detailed troubleshooting: `.claude/docs/TROUBLESHOOTING.md`
