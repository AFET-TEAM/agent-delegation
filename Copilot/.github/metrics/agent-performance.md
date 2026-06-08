---
last-updated: 2026-04-18
tracking-version: 2
---

# Agent Performance Metrics

Tracks agent success rates, review efficiency, cost distribution, and fallback activations.

## Agent Task Metrics

| Agent                    | Tier | Tasks Assigned | Completed | Failed | Avg Review Rounds | Fallback Used |
| ------------------------ | ---- | -------------- | --------- | ------ | ----------------- | ------------- |
| PrincipalAlpha           | T1   | 4              | 4         | 0      | —                 | No            |
| PrincipalBeta            | T1   | 4              | 4         | 0      | —                 | No            |
| StaffEngineerAlpha       | T2   | 4              | 4         | 0      | 1.0               | No            |
| StaffEngineerBeta        | T2   | 3              | 3         | 0      | 1.0               | No            |
| MidCoderAlpha            | T3   | 3              | 3         | 0      | 1.0               | No            |
| MidCoderBeta             | T3   | 3              | 3         | 0      | 1.0               | No            |
| LeadAnalyst              | T4   | 4              | 4         | 0      | 1.0               | No            |
| AnalystAlpha             | T5   | 4              | 4         | 0      | —                 | No            |
| AnalystBeta              | T5   | 4              | 4         | 0      | —                 | No            |
| AnalystGamma             | T5   | 4              | 4         | 0      | —                 | No            |

## Cost Distribution

| Tier | Tasks | Estimated Cost | Percentage | Notes |
| ---- | ----- | -------------- | ---------- | ----- |
| T1   | 8     | $$$$$          | 42%        | Architecture + review |
| T2   | 7     | $$$$           | 25%        | Feature impl + validation |
| T3   | 6     | $$$            | 15%        | Scaffolding + skill fixes |
| T4   | 4     | $$             | 10%        | Lead Analyst consolidation |
| T5   | 12    | $              | 8%         | Analysis across 4 sessions |

## Review Efficiency

| Review Pair                        | Reviews Done | Approved (Round 1) | Approved (Round 2) | Rejected |
| ---------------------------------- | ------------ | ------------------ | ------------------ | -------- |
| Principal → Staff Engineer         | 4            | 4                  | 0                  | 0        |
| Staff Engineer → MidCoder          | 4            | 3                  | 1                  | 0        |
| LeadAnalyst → Analyst               | 4            | 3                  | 1                  | 0        |

## Fallback Activations

| Date | Agent | Expected Model | Actual Model | Reason |
| ---- | ----- | -------------- | ------------ | ------ |

_No fallback activations recorded._

## Recording Instructions

The Orchestrator updates this file at the end of each multi-agent session:

1. Increment task counts per agent.
2. Record review round averages.
3. Log any fallback activations.
4. Update cost distribution percentages.

---

## Benchmark Framework

Standardized benchmarks for measuring and comparing agent performance across sessions.

### Benchmark Dimensions

| Dimension | Metric | Target | Measurement |
|-----------|--------|--------|-------------|
| **Task Completion Rate** | Completed / Assigned | > 95% | Per agent, per tier |
| **First-Pass Approval Rate** | Approved in Round 1 / Total Reviews | > 80% | Per review pair |
| **Token Efficiency** | Actual / Estimated tokens | < 1.3x (30% tolerance) | Per task type |
| **Review Turnaround** | Avg review rounds to approval | < 1.5 rounds | Per review pair |
| **Escalation Rate** | Escalated tasks / Total tasks | < 10% | Per tier |
| **Fallback Frequency** | Fallback activations / Total tasks | < 5% | Per agent |

### Benchmark Scoring

Each dimension is scored 1-5:

| Score | Label | Criteria |
|-------|-------|----------|
| 5 | Excellent | Exceeds target by > 20% |
| 4 | Good | Meets or slightly exceeds target |
| 3 | Acceptable | Within 10% of target |
| 2 | Below | Misses target by 10-30% |
| 1 | Critical | Misses target by > 30% |

### Agent Benchmark Report Template

Generated at the end of every 5th session or on-demand via `/status --benchmark`:

```markdown
## Agent Benchmark Report — {date}

**Sessions Analyzed**: {N}
**Total Tasks**: {N}

### Tier Summary

| Tier | Completion Rate | First-Pass Rate | Token Efficiency | Score |
| ---- | -------------- | --------------- | --------------- | ----- |
| T1   | {%}            | —               | {x}             | {1-5} |
| T2   | {%}            | {%}             | {x}             | {1-5} |
| T3   | {%}            | {%}             | {x}             | {1-5} |
| T4   | {%}            | —               | {x}             | {1-5} |
| T5   | {%}            | {%}             | {x}             | {1-5} |

### Individual Agent Scores

| Agent | Tasks | Completion | First-Pass | Efficiency | Overall |
| ----- | ----- | ---------- | ---------- | ---------- | ------- |
| ...   | {N}   | {1-5}      | {1-5}      | {1-5}      | {avg}   |

### Trends

{Comparison with previous benchmark report — improving/declining/stable per dimension}

### Recommendations

{Actionable items: reassign task types, adjust baselines, retrain patterns}
```

### Benchmark Triggers

1. **Automatic**: Every 5th multi-agent session, the Orchestrator delegates benchmark generation.
2. **Manual**: User runs `/status --benchmark` to generate an on-demand report.
3. **Calibration**: When a benchmark score drops below 3 for any dimension, the Orchestrator flags it in the session summary.
