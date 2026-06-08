---
task-id: G04
agent: Ayse Demir
tier: T4
source: G02-use-cases-examples.md
status: Complete
date: 2026-05-21
---

# Use Case Catalog — HTML Doc Structure Outline

## Recommended Section Hierarchy (8 Main Sections)

### 1. Quick Start (5 min)
- 1.1 What is Claude Code?
- 1.2 One-command setup
- 1.3 Your first task (fix a typo)

### 2. Core Concepts (15 min)
- 2.1 Five Tiers Explained (T1–T5)
- 2.2 xN Modes Quick Reference (x2, x3, x5, x10)
- 2.3 The Review Chain
- 2.4 Hooks System Overview
- 2.5 Skills System (4 slash commands)

### 3. Common Workflows (30 min)
- 3.1 Simple fix — no xN
- 3.2 Small feature — x3
- 3.3 Standard feature — x5
- 3.4 System audit — x10
- 3.5 Using /caveman (compressed mode)
- 3.6 Using /ctx (context-mode + memory)
- 3.7 Using /graphify (knowledge graph)
- 3.8 Combining tools

### 4. Advanced Topics (40 min)
- 4.1 Custom skills creation
- 4.2 Custom hooks (pre/post tool enforcement)
- 4.3 Custom agent templates
- 4.4 Memory + learned patterns lifecycle
- 4.5 Cost optimization strategies
- 4.6 Escalation handling (revision limits, tier promotion)
- 4.7 Score-weighted agent selection

### 5. Tools Reference (25 min)
- 5.1 context-mode (11 MCP tools: ctx_search, ctx_execute, ctx_index)
- 5.2 graphify (build, query, god_nodes, surprising_connections)
- 5.3 All slash commands (/caveman, /graphify, /ctx, /review, /security-review, /architect)

### 6. Configuration (20 min)
- 6.1 settings.json structure and hook registration
- 6.2 Hooks catalog (19 scripts: enforcement points and triggers)
- 6.3 Agent templates (5 tier templates: opus/sonnet/haiku models)
- 6.4 Rules catalog (17 files: clean-code, backend-security, code-review, etc.)

### 7. Troubleshooting (15 min)
- 7.1 Common errors and recovery steps
- 7.2 Hook failures and debugging
- 7.3 Permission denials and escalation
- 7.4 Cost overruns and optimization

### 8. Reference (Bookmarks)
- 8.1 Cheat sheet (commands + xN table)
- 8.2 Glossary (xN, PEP, DAG, god nodes, etc.)
- 8.3 FAQ (12 common questions)
- 8.4 Metrics interpretation (leaderboard.md, token-usage.md)

---

## Progressive Disclosure Paths

### Beginner Path (15 min total)
1 → 2.1, 2.2 → 3.1 → Start simple task

### Intermediate Path (45 min)
Full Section 2 → 3.1–3.5 → 5.3 (skills reference) → Try x3/x5

### Advanced Path (90 min)
4.* (all advanced) → 6.* (config) → 8.* (reference) → Customize system

---

## Top 20 Use Cases (Extracted from G02)

| # | Use Case | Brief Description |
|---|----------|---|
| 1 | A.1: First-Time Setup | Install and initialize Claude Code with all configs and hooks |
| 2 | A.2: Simple Task — Fix a Typo | Single-agent mode for trivial changes in <1 minute |
| 3 | A.3: Asking for Explanation | Query system behavior without spawning agents |
| 4 | A.4: Custom Skill Invocation | Use /caveman, /graphify, /ctx slash commands |
| 5 | A.5: Status Check — Session Progress | Monitor ongoing x10 session with active-plan.md |
| 6 | A.6: Reading the Leaderboard | Interpret agent scores and tier placement |
| 7 | B.1: x3 Mode — Small Team | Lightweight 3-agent task with Principal → Staff → Analyst chain |
| 8 | B.2: x5 Mode — Full Review | Standard 5-agent execution with complete review chain |
| 9 | B.3: Code Review Skill | /review command applies code-review.md checklist |
| 10 | B.4: Security Review Skill | /security-review command focused on security anti-patterns |
| 11 | B.5: Using graphify | Build codebase knowledge graph, identify god classes |
| 12 | B.6: Combining Tools | graphify + context-mode together for large codebase analysis |
| 13 | B.7: Plan Mode — PEP | Trigger Prompt Enrichment Protocol for complex tasks |
| 14 | B.8: Caveman Mode | Enable compressed prose output for quick-debug sessions |
| 15 | C.1: x10 Full Power | Maximum capacity (2×T1,T2,T3,T4,T5) for critical overhauls |
| 16 | C.2: Custom Learned Patterns | Create persistent rules from repeated errors (hit-count ≥3) |
| 17 | C.3: Custom Hooks | Add new pre/post tool enforcement hooks for policies |
| 18 | C.4: Custom Agent Templates | Domain-specific agent variants (e.g. T3-React) |
| 19 | C.5: Cross-Session Memory | Index prior session findings for reuse via ctx_index |
| 20 | C.6: Escalation Handling | Understand revision limits and automatic tier promotion |

---

## Walkthroughs (3 Guided Walkthroughs in G02)

| # | Title | Scope | Est. Reading Time | Location |
|---|-------|-------|-------------------|----------|
| **W1** | **Beginner** — Fix a Typo | Single-agent, 1 file | ~1 min | G02: F.1 |
| **W2** | **Intermediate** — Add API Endpoint (x5) | Full 5-agent workflow with PEP → review chain | ~12 min | G02: F.2 |
| **W3** | **Advanced** — Codebase Audit + Refactor (x10) | Full 10-agent parallel execution, graphify + security | ~25 min | G02: F.3 |

**Cross-linking:** Section 1.3 should reference these walkthroughs for hands-on learning.

---

## Cheat Sheet Content (For Section 8.1)

### Slash Commands

| Command | Effect | When to Use |
|---------|--------|------------|
| `/caveman` | Enable concise prose output (40-65% fewer words) | Quick-debug sessions, rapid iteration |
| `/graphify . --local-only` | Build codebase knowledge graph (AST-based, no API calls) | Codebase >20 files, topology unknown |
| `/ctx` | Enable context-mode memory tools (ctx_search, ctx_index, ctx_execute) | Complex analysis, cross-session reuse |
| `/review` | Run code review checklist on current branch | Before merge, PR quality gate |
| `/security-review` | Focused security analysis (injection, XSS, secrets, auth) | Before deploying, compliance audit |
| `/architect` | Route directly to T1 Principal (opus model) | Architectural decisions, system design |

### xN Modes Quick Reference

| Mode | Agents Deployed | Cost | Best For | Review Chain |
|------|-----------------|------|----------|--------------|
| Single | 1 (Orchestrator) | ~$0.50–1 | Trivial fixes, explanations | N/A |
| **x2** | 2 (T1+T5) | ~$2–3 | Architecture review + research | T5 → T1 |
| **x3** | 3 (T1+T2+T5) | ~$2.50–3.50 | Small feature with senior review | T5 → T2 → T1 |
| **x4** | 4 (T1+T2+T3+T5) | ~$3–4 | Single module standard dev | T5 → T2 → (T3→T2) → T1 |
| **x5** ⭐ | 5 (T1+T2+T3+T4+T5) | ~$4–6 | **DEFAULT**: Balanced team, full chain | T5 → T4 → [T3→T2,T2→T1] |
| **x7** | 7 (1T1+2T2+T3+T4+2T5) | ~$7–10 | Parallel research + design tracks | Full standard + parallel |
| **x10** | 10 (2T1+2T2+2T3+2T4+2T5) | ~$12–18 | Critical system overhaul, max firepower | Full parallel review |

### Top Decisions

| Decision | Criteria | Recommendation |
|----------|----------|-----------------|
| **Single vs x2** | Trivial? (<3 lines, 1 file) | Single (no agent) |
| **x2 vs x3** | Need implementation? | x2 (research only), x3 (research + senior review) |
| **x3 vs x5** | Standard feature? | x5 (safer, includes analysis + design phases) |
| **x5 vs x10** | System-wide impact? | x5 (modular), x10 (cross-module) |
| **When to use /caveman** | Decision-making task? | NO (use normal mode). Debug/quick fix? YES |
| **When to use /graphify** | >20 files? | YES (token savings pay off). <20 files? | NO (direct reads cheaper) |

---

## Cross-Link Recommendations

### Primary Navigation Flow

```
1. Quick Start (1.*)
    ↓
2. Core Concepts (2.1, 2.2)
    ↓
3. Common Workflows (3.1 → try simple)
    ↓
(User success) → 3.2–3.8 (learn more workflows)
    ↓
4. Advanced Topics (4.1–4.7)
```

### Contextual Cross-Links

| From Section | To Section | Reason |
|---|---|---|
| 1.3 (Your first task) | 3.1 (Simple fix workflow) | Hands-on walkthrough |
| 2.1 (Five Tiers) | 4.7 (Agent selection) | How agent assignment works |
| 2.2 (xN Modes) | 3.2–3.4 (Workflows) | See each mode in action |
| 2.5 (Skills System) | 5.3 (All slash commands) | Full command reference |
| 3.5 (/caveman) | 5.3 → caveman docs | Extended caveman rules |
| 3.6 (/ctx) | 5.1 (context-mode tools) | 11 MCP tools explained |
| 3.7 (/graphify) | 5.2 (graphify queries) | jq examples + queries |
| 3.8 (Combining tools) | 5.1 + 5.2 + 5.3 | End-to-end workflows |
| 4.2 (Custom hooks) | 6.2 (Hooks catalog) | 19 hook reference |
| 4.3 (Agent templates) | 6.3 (Agent templates) | 5 tier templates |
| 4.4 (Learned patterns) | 6.4 (Rules catalog) | Pattern promotion mechanics |
| 4.5 (Cost optimization) | 8.4 (Metrics interpretation) | Read leaderboard + token-usage |
| 6.1 (settings.json) | 6.2 (Hooks catalog) | How hooks register |
| 7.* (Troubleshooting) | 8.3 (FAQ) | Common issues |

### Sidebar Anchor Links

Implement sticky sidebar with:
- Section TOC (current section outline)
- "Jump to" quick links: Cheat Sheet, FAQ, Glossary
- Breadcrumb: Current section path

---

## Content Organization Principles

### 1. Layered Complexity
- **Beginner**: "What" and "How" (surface level)
- **Intermediate**: "Why" and "When" (decision trees)
- **Advanced**: "Custom" and "Extend" (system modification)

### 2. Worked Examples
- **W1** (1 min): Trivial — builds confidence
- **W2** (12 min): Realistic — shows full workflow
- **W3** (25 min): Complex — demonstrates power

### 3. Visual Elements (Recommended)
- Flowchart: "Which xN mode should I use?"
- Timeline diagram: x5 workflow (5 waves)
- Table: xN comparison matrix
- Code block: Example commands with expected output
- Icon legend: 🟢 (correct), 🔴 (avoid), ⭐ (recommended)

### 4. Search Optimization
- Keyword tags: each section, each use case
- FAQ answers: searchable by common questions
- Glossary: auto-linked terminology

---

## HTML Doc Deliverables (For T2-B Designer)

1. **Navigation Structure**: 8 main sections with 3+ subsections each
2. **Cheat Sheet Card**: Printable 1-page reference (Section 8.1)
3. **xN Decision Tree**: Interactive flowchart (Section 2.2)
4. **Walkthrough Timeline**: Visual execution flow (W1–W3)
5. **Cross-link Map**: Graph showing section relationships
6. **Search Index**: Keywords + anchors for all 20+ use cases
7. **Mobile Responsiveness**: Sidebar collapses, cheat sheet stacks

---

## Summary Stats

| Metric | Count |
|--------|-------|
| **Main Sections** | 8 |
| **Subsections** | 40+ |
| **Use Cases** | 20 (plus 8 more in G02) |
| **Walkthroughs** | 3 (beginner, intermediate, advanced) |
| **Slash Commands** | 6 (/caveman, /graphify, /ctx, /review, /security-review, /architect) |
| **Hooks** | 19 (cataloged in Section 6.2) |
| **Rules** | 17 (listed in Section 6.4) |
| **xN Modes** | 7 (single, x2, x3, x4, x5, x7, x10) |
| **Cheat Sheet Items** | 20+ (commands + modes + quick decisions) |
| **Cross-links** | 30+ (primary + contextual) |

---

## Next Steps for HTML Design (T2-B)

1. **Layout**: Create responsive 8-section navigation (sticky sidebar + main content)
2. **Cheat Sheet**: Design printable 1-pager or modal card
3. **Interactive Elements**: 
   - xN decision tree (quiz-like flow)
   - Walkthrough timeline with collapsible steps
   - Command reference with copy-to-clipboard
4. **Search**: Implement full-text search + keyword filters
5. **Mobile**: Collapse sidebar into hamburger menu; stack cheat sheet
6. **Dark mode**: Support system preference + toggle
7. **Accessibility**: WCAG 2.1 AA compliance (semantic HTML, ARIA labels)

---

**Document prepared by:** Ayse Demir (T4 Lead Analyst)  
**Source:** G02-use-cases-examples.md (1515 lines, 28 use cases)  
**Status:** Ready for T2-B HTML architecture design
