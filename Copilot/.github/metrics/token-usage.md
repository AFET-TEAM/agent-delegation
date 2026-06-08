---
last-updated: 2026-04-18
calibration-version: 3
total-records: 16
---

# Token Usage Log

Records actual token consumption per task for calibration of the estimation matrix in `task-planning.instructions.md`.

## Format

| Date       | Task Type               | Tier | Estimated | Actual | Deviation | Agent                    | Session   |
| ---------- | ----------------------- | ---- | --------- | ------ | --------- | ------------------------ | --------- |
| YYYY-MM-DD | {task type from matrix} | T{n} | {N}K      | {N}K   | +/-{N}%   | {AgentName}              | {plan-id} |

## Records

| Date       | Task Type               | Tier | Estimated | Actual | Deviation | Agent                    | Session   |
| ---------- | ----------------------- | ---- | --------- | ------ | --------- | ------------------------ | --------- |
| 2026-02-24 | Codebase analysis       | T5   | 3K        | 4K     | +33%      | AnalystAlpha             | PLAN-001  |
| 2026-02-24 | Codebase analysis       | T5   | 3K        | 3K     | 0%        | AnalystBeta              | PLAN-001  |
| 2026-02-24 | Codebase analysis       | T5   | 3K        | 4K     | +33%      | AnalystGamma             | PLAN-001  |
| 2026-02-24 | Code review             | T4   | 5K        | 6K     | +20%      | LeadAnalyst              | PLAN-001  |
| 2026-02-24 | Architecture design     | T1   | 10K       | 8K     | -20%      | PrincipalAlpha           | PLAN-001  |
| 2026-02-24 | Code review             | T1   | 8K        | 7K     | -13%      | PrincipalBeta            | PLAN-001  |
| 2026-03-19 | Codebase analysis       | T5   | 3K        | 5K     | +67%      | AnalystAlpha             | PLAN-004  |
| 2026-03-19 | Codebase analysis       | T5   | 3K        | 5K     | +67%      | AnalystBeta              | PLAN-004  |
| 2026-03-19 | Codebase analysis       | T5   | 3K        | 4K     | +33%      | AnalystGamma             | PLAN-004  |
| 2026-03-19 | Complex feature impl.   | T2   | 15K       | 12K    | -20%      | StaffEngineerAlpha       | PLAN-004  |
| 2026-03-19 | Complex feature impl.   | T2   | 15K       | 10K    | -33%      | StaffEngineerBeta        | PLAN-004  |
| 2026-03-19 | Component scaffolding   | T3   | 10K       | 8K     | -20%      | MidCoderAlpha            | PLAN-004  |
| 2026-03-19 | Component scaffolding   | T3   | 10K       | 9K     | -10%      | MidCoderBeta             | PLAN-004  |
| 2026-03-19 | Code review             | T4   | 5K        | 7K     | +40%      | LeadAnalyst              | PLAN-004  |
| 2026-03-19 | Architecture design     | T1   | 10K       | 15K    | +50%      | PrincipalAlpha           | PLAN-004  |
| 2026-03-19 | Code review             | T1   | 8K        | 10K    | +25%      | PrincipalBeta            | PLAN-004  |

## Calibration Summary

### Current Multiplier

- **Project size**: Small (< 50 files) → 1.0x

### Deviation Alerts

- **2026-02-24 AnalystAlpha**: Codebase analysis estimated 3K, actual 4K (+33%). Exceeds 30% threshold. Consider adjusting T5 analysis baseline to 3K-5K.
- **2026-02-24 AnalystGamma**: Codebase analysis estimated 3K, actual 4K (+33%). Same pattern as AnalystAlpha — T5 analysis tasks consistently run ~33% over estimate.
- **2026-03-19 AnalystAlpha / AnalystBeta**: Deep analysis tasks estimated 3K, actual 5K (+67%). v6.3.0 codebase significantly larger than initial analysis baseline. T5 deep-analysis budget should be 4K-6K for mature codebases.
- **2026-03-19 LeadAnalyst**: Consolidation review estimated 5K, actual 7K (+40%). Lead Analyst consolidation of 3 analyst reports requires more context than single-analyst review. Adjust T4 consolidation baseline to 6K-8K.
- **2026-03-19 PrincipalAlpha**: Architecture assessment estimated 10K, actual 15K (+50%). Post-fix re-scoring required reading all 28 findings + 3 analyst reports. T1 comprehensive assessment baseline should be 12K-18K.

> **Not**: PLAN-005 (v7.0.0) token verileri session sırasında kaydedilmemiştir.
