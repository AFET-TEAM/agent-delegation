# Name Pool

## Agent Name Registry

20 names for 10 agent slots. Names are selected via weighted random selection based on cumulative score.

| ID | Name | Score | Sessions |
|----|------|-------|----------|
| 1 | Taner Yilmaz | 0 | 0 |
| 2 | Oya Kanat | 0 | 0 |
| 3 | Baris Benli | 0 | 0 |
| 4 | Tarik Ziya Yesilcimen | 0 | 0 |
| 5 | Enis Sait Erken | 0 | 0 |
| 6 | Selin Akar | 0 | 0 |
| 7 | Canan Birsen | 0 | 0 |
| 8 | Emre Kilic | 0 | 0 |
| 9 | Ayse Demir | 0 | 0 |
| 10 | Elif Ozge Maksutoglu | 0 | 0 |
| 11 | Onur Ardic | 0 | 0 |
| 12 | Bugra Ozkahraman | 0 | 0 |
| 13 | Mertcan Moran | 0 | 0 |
| 14 | Safak Senol | 0 | 0 |
| 15 | Yaren Eylul Dokmez | 0 | 0 |
| 16 | Necati Dogrul | 0 | 0 |
| 17 | Yavuz Yalcin | 0 | 0 |
| 18 | Rumeysa Yildiz | 0 | 0 |
| 19 | Sibel Kukey | 0 | 0 |
| 20 | Okancan Okan | 0 | 0 |

## Pool Rules

- Pool size: 20 names for a maximum of 10 concurrent agent slots
- Each session assigns names via weighted random selection (no duplicates within a session)
- Names persist across sessions; scores accumulate over time
- A name can only be assigned to one active agent at a time

## Scoring Rules

| Event | Score Delta |
|-------|-------------|
| Task completed successfully | +5 |
| Task failed | -5 |
| Code review passed first attempt | +3 |
| Code review passed second attempt | +1 |
| Code review required 3+ rounds | -3 |
| Found P0/P1 issue during review | +4 |
| Reported false positive issue | -2 |
| Unnecessary escalation to higher tier | -2 |
| Model fallback triggered | -1 |

### Initial Scores

All agent names start at score=0. Scores evolve across sessions based on Scoring Rules above. The `update-leaderboard.sh` hook (SessionEnd event) applies deltas after each session.

## Score-Weighted Selection Algorithm

### Weight Calculation

weight = max(score + 101, 1)

This ensures all agents have a positive weight. An agent with score=0 has weight=101, score=-100 has weight=1.

### Tier Multipliers

These multipliers apply to the selection **weight calculation** only — they do not modify the score itself. An agent's tier is determined by its current score range, and the multiplier adjusts how likely that agent is to be selected for a new slot in weighted random selection.

| Tier | Score Range | Multiplier |
|------|-------------|------------|
| S-tier | 50 and above | x2.0 |
| A-tier | 20 to 49 | x1.5 |
| B-tier | 0 to 19 | x1.0 |
| C-tier | -20 to -1 | x0.8 |
| D-tier | below -20 | x0.5 |

### Final Weight

final_weight = max(score + 101, 1) * tier_multiplier

### Selection Process

1. Calculate final_weight for all available (unassigned) names
2. Sum all weights to get total_weight
3. Generate random number R in [0, total_weight)
4. Iterate through names, accumulating weights until accumulated >= R
5. Selected name is the current name when threshold is crossed
6. Remove selected name from available pool for this session
7. Repeat for each agent slot needed
