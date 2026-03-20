---
last-updated: 2026-03-19
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
| 2026-02-24 | Codebase analysis       | T3   | 3K        | 4K     | +33%      | Emre Kılıç               | PLAN-001  |
| 2026-02-24 | Codebase analysis       | T3   | 3K        | 3K     | 0%        | Ayşe Demir               | PLAN-001  |
| 2026-02-24 | Codebase analysis       | T3   | 3K        | 4K     | +33%      | Elif Özge Maksutoğlu     | PLAN-001  |
| 2026-02-24 | Code review             | T2.5 | 5K        | 6K     | +20%      | Canan Birsen             | PLAN-001  |
| 2026-02-24 | Architecture design     | T1   | 10K       | 8K     | -20%      | Taner Yılmaz             | PLAN-001  |
| 2026-02-24 | Code review             | T1   | 8K        | 7K     | -13%      | Oya Kanat                | PLAN-001  |
| 2026-03-19 | Codebase analysis       | T3   | 3K        | 5K     | +67%      | Emre Kılıç               | PLAN-004  |
| 2026-03-19 | Codebase analysis       | T3   | 3K        | 5K     | +67%      | Ayşe Demir               | PLAN-004  |
| 2026-03-19 | Codebase analysis       | T3   | 3K        | 4K     | +33%      | Elif Özge Maksutoğlu     | PLAN-004  |
| 2026-03-19 | Complex feature impl.   | T1.5 | 15K       | 12K    | -20%      | Barış Benli              | PLAN-004  |
| 2026-03-19 | Complex feature impl.   | T1.5 | 15K       | 10K    | -33%      | Tarık Ziya Yeşilçimen    | PLAN-004  |
| 2026-03-19 | Component scaffolding   | T2   | 10K       | 8K     | -20%      | Enis Sait Erken          | PLAN-004  |
| 2026-03-19 | Component scaffolding   | T2   | 10K       | 9K     | -10%      | Selin Akar               | PLAN-004  |
| 2026-03-19 | Code review             | T2.5 | 5K        | 7K     | +40%      | Canan Birsen             | PLAN-004  |
| 2026-03-19 | Architecture design     | T1   | 10K       | 15K    | +50%      | Taner Yılmaz             | PLAN-004  |
| 2026-03-19 | Code review             | T1   | 8K        | 10K    | +25%      | Oya Kanat                | PLAN-004  |

## Calibration Summary

### Current Multiplier

- **Project size**: Small (< 50 files) → 1.0x

### Deviation Alerts

- **2026-02-24 Emre Kılıç**: Codebase analysis estimated 3K, actual 4K (+33%). Exceeds 30% threshold. Consider adjusting T3 analysis baseline to 3K-5K.
- **2026-02-24 Elif Özge Maksutoğlu**: Codebase analysis estimated 3K, actual 4K (+33%). Same pattern as Emre Kılıç — T3 analysis tasks consistently run ~33% over estimate.
- **2026-03-19 Emre Kılıç / Ayşe Demir**: Deep analysis tasks estimated 3K, actual 5K (+67%). v6.3.0 codebase significantly larger than initial analysis baseline. T3 deep-analysis budget should be 4K-6K for mature codebases.
- **2026-03-19 Canan Birsen**: Consolidation review estimated 5K, actual 7K (+40%). Lead Analyst consolidation of 3 analyst reports requires more context than single-analyst review. Adjust T2.5 consolidation baseline to 6K-8K.
- **2026-03-19 Taner Yılmaz**: Architecture assessment estimated 10K, actual 15K (+50%). Post-fix re-scoring required reading all 28 findings + 3 analyst reports. T1 comprehensive assessment baseline should be 12K-18K.
