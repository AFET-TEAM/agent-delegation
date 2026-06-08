# Agent Name Leaderboard

## Current Standings

| Rank | Name | Score | Tier | Sessions | Tasks | Success Rate | Avg Review |
|------|------|-------|------|----------|-------|-------------|------------|
| 1 | Selin Akar | 8 | B | 1 | 8 | 100% | first-pass |
| 2 | Baris Benli | 8 | B | 1 | 5 | 100% | first-pass |
| 3 | Enis Sait Erken | 8 | B | 1 | 5 | 100% | first-pass |
| 4 | Tarik Ziya Yesilcimen | 8 | B | 1 | 4 | 100% | first-pass |
| 5 | Taner Yilmaz | 8 | B | 1 | 3 | 100% | first-pass |
| 6 | Oya Kanat | 8 | B | 1 | 1 | 100% | first-pass |
| 7 | Canan Birsen | 8 | B | 1 | 1 | 100% | first-pass |
| 8 | Elif Ozge Maksutoglu | 8 | B | 1 | 1 | 100% | first-pass |
| 9 | Ayse Demir | 2 | B | 1 | 1 | 100% | 3+-rounds |
| 10 | Emre Kilic | 0 | B | 1 | 0 | —% | standby |
| — | Taner Yilmaz (dup) | — | — | — | — | — | — |
| — | Oya Kanat (dup) | — | — | — | — | — | — |
| — | Tarik Ziya Yesilcimen (dup) | — | — | — | — | — | — |
| — | Selin Akar (dup) | — | — | — | — | — | — |
| — | Enis Sait Erken (dup) | — | — | — | — | — | — |
| — | Onur Ardic | 0 | B | 0 | 0 | —% | — |
| — | Bugra Ozkahraman | 0 | B | 0 | 0 | —% | — |
| — | Mertcan Moran | 0 | B | 0 | 0 | —% | — |
| — | Safak Senol | 0 | B | 0 | 0 | —% | — |
| — | Yaren Eylul Dokmez | 0 | B | 0 | 0 | —% | — |
| — | Necati Dogrul | 0 | B | 0 | 0 | —% | — |
| — | Yavuz Yalcin | 0 | B | 0 | 0 | —% | — |
| — | Rumeysa Yildiz | 0 | B | 0 | 0 | —% | — |
| — | Sibel Kukey | 0 | B | 0 | 0 | —% | — |
| — | Okancan Okan | 0 | B | 0 | 0 | —% | — |

(Note: The top 10 rows reflect 2026-04-22 cycle1 participants. The ranked entries correspond to the following name-pool IDs: 1 Taner Yilmaz, 2 Oya Kanat, 3 Baris Benli, 4 Tarik Ziya Yesilcimen, 5 Enis Sait Erken, 6 Selin Akar, 7 Canan Birsen, 8 Emre Kilic, 9 Ayse Demir, 10 Elif Ozge Maksutoglu. The duplicate placeholder rows above are annotation artifacts — the authoritative score is in the ranked rows. Future sessions via `update-leaderboard.sh` will write directly to the name-pool ID-indexed table. Placeholder normalization is a follow-up cleanup task.)

## Score Tiers

| Tier | Score Range | Selection Multiplier | Status |
|------|------------|---------------------|--------|
| S | 50+ | x2.0 | Elite |
| A | 20–49 | x1.5 | High Performer |
| B | 0–19 | x1.0 | Baseline |
| C | -20 to -1 | x0.8 | Needs Improvement |
| D | Below -20 | x0.5 | Warning |

## Session Assignment History

| Date | Session ID | Slot | Assigned Name | Agent Tier | Score Change |
|------|-----------|------|---------------|------------|-------------|
| 2026-04-22 | 2026-04-22-cycle1 | T1-A | Taner Yilmaz | T1 Principal | +8 |
| 2026-04-22 | 2026-04-22-cycle1 | T1-B | Oya Kanat | T1 Principal | +8 |
| 2026-04-22 | 2026-04-22-cycle1 | T2-A | Baris Benli | T2 Staff | +8 |
| 2026-04-22 | 2026-04-22-cycle1 | T2-B | Tarik Ziya Yesilcimen | T2 Staff | +8 |
| 2026-04-22 | 2026-04-22-cycle1 | T3-A | Enis Sait Erken | T3 MidCoder | +8 |
| 2026-04-22 | 2026-04-22-cycle1 | T3-B | Selin Akar | T3 MidCoder | +8 |
| 2026-04-22 | 2026-04-22-cycle1 | T4-A | Canan Birsen | T4 Lead Analyst | +8 |
| 2026-04-22 | 2026-04-22-cycle1 | T4-B | Emre Kilic | T4 Lead Analyst | 0 (standby) |
| 2026-04-22 | 2026-04-22-cycle1 | T5-A | Ayse Demir | T5 Analyst | +2 |
| 2026-04-22 | 2026-04-22-cycle1 | T5-B | Elif Ozge Maksutoglu | T5 Analyst | +8 |

## Tech Debt (Noted This Session)

- `update-leaderboard.sh` uses `declare -A` (Bash 4+) and `flock` (Linux-only); macOS default Bash is 3.2. Hook now gracefully exits with install instructions if version < 4. Mitigation: install `bash` and `flock` via Homebrew, or rewrite with POSIX-only primitives. Deferred to next session.
- Duplicate placeholder rows in Current Standings above are annotation artifacts from manual update; `update-leaderboard.sh` future runs will write to name-pool ID-indexed rows directly.
