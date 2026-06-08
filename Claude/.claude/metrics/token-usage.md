# Token Usage Log

## Session Token Consumption

| Date | Session ID | Mode | Agent | Tier | Estimated Tokens | Actual Tokens | Delta | Notes |
|------|-----------|------|-------|------|-----------------|---------------|-------|-------|

## Calibration Notes

Track estimate accuracy over time. If 3+ tasks in a session deviate >30% from estimates, adjust the baseline in `.claude/config/context-budget.md`.

## Aggregate Statistics

| Tier | Total Sessions | Avg Tokens/Task | Avg Deviation | Trend |
|------|---------------|-----------------|---------------|-------|
| T1 opus | 0 | — | — | — |
| T2 sonnet | 0 | — | — | — |
| T3 sonnet | 0 | — | — | — |
| T4 haiku | 0 | — | — | — |
| T5 haiku | 0 | — | — | — |

## Session: 2026-04-17 — x10 Implementation

| Agent | Estimated | Actual | Delta |
|-------|-----------|--------|-------|
| Emre (T2) | 15K | ~40K | +25K (3 files created) |
| Mert (T2) | 8K | ~38K | +30K (file read+edit) |
| Zeynep (T2) | 12K | ~45K | +33K (CLAUDE.md 7 sections) |
| Arda (T2) | 10K | ~43K | +33K (4 files) |
| Burak (T1) | 8K | ~44K | +36K (3 files + verify) |
| Elif (T1) | 8K | ~47K | +39K (3 templates + QA) |
| **Total** | **61K** | **~257K** | **+196K** |

## Session: 2026-04-18 — x10 Analysis + Improvements

| Agent | Estimated | Actual | Delta |
|-------|-----------|--------|-------|
| Emre Kilic (T3) | 8K | ~66K | +58K (29 tool use, deep analysis) |
| Ayse Demir (T3) | 8K | ~60K | +52K (20 tool use) |
| Elif Ozge (T3) | 8K | ~62K | +54K (22 tool use) |
| Canan Birsen (T4) | 5K | ~51K | +46K (13 tool use, consolidation) |
| Baris Benli (T2) | 12K | ~49K | +37K (18 tool use) |
| Tarik Ziya (T2) | 10K | ~46K | +36K (11 tool use) |
| Enis Sait (T2) | 8K | ~57K | +49K (27 tool use) |
| Selin Akar (T2) | 8K | ~64K | +56K (20 tool use) |
| Taner Yilmaz (T1) | 8K | ~50K | +42K (19 tool use) |
| Oya Kanat (T1) | 8K | ~57K | +49K (11 tool use, 2nd attempt) |
| **Total** | **83K** | **~562K** | **+479K** |

## Cost Efficiency

| Mode | Sessions | Avg Cost (relative) | vs All-Opus Baseline | Savings % |
|------|----------|--------------------|--------------------|-----------|
| x3 | 0 | — | — | — |
| x5 | 0 | — | — | — |
| x7 | 0 | — | — | — |
| x10 | 2 | 409.5K | baseline | — |
