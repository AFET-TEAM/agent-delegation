# Agent Name Pool

> Canonical source for dynamic agent display names.
> Orchestrator assigns names from this pool at session start.
> Only `VarolMaksutoglu` (Orchestrator) has a fixed name.

---

## Pool Rules

1. **Pool Size**: 20 names for 10 agent slots. Each session uses 10 names.
2. **Selection**: Weighted random — higher-scoring names have higher probability.
3. **No Repeat in Session**: A name assigned to one agent slot cannot be assigned to another in the same session.
4. **Score Range**: -100 to +100. New names start at 0.
5. **Canonical Source**: This file is the single source of truth for available names.

---

## Name Registry

| # | Name | Score | Sessions | Status |
|---|------|-------|----------|--------|
| 1 | Taner Yilmaz | 0 | 0 | active |
| 2 | Oya Kanat | 0 | 0 | active |
| 3 | Baris Benli | 0 | 0 | active |
| 4 | Tarik Ziya Yesilcimen | 0 | 0 | active |
| 5 | Enis Sait Erken | 0 | 0 | active |
| 6 | Selin Akar | 0 | 0 | active |
| 7 | Canan Birsen | 0 | 0 | active |
| 8 | Emre Kilic | 0 | 0 | active |
| 9 | Ayse Demir | 0 | 0 | active |
| 10 | Elif Ozge Maksutoglu | 0 | 0 | active |
| 11 | Onur Ardic | 0 | 0 | active |
| 12 | Bugra Ozkahraman | 0 | 0 | active |
| 13 | Mertcan Moran | 0 | 0 | active |
| 14 | Safak Senol | 0 | 0 | active |
| 15 | Yaren Eylul Dokmez | 0 | 0 | active |
| 16 | Necati Dogrul | 0 | 0 | active |
| 17 | Yavuz Yalcin | 0 | 0 | active |
| 18 | Rumeysa Yildiz | 0 | 0 | active |
| 19 | Sibel Kukey | 0 | 0 | active |
| 20 | Okancan Okan | 0 | 0 | active |

---

## Scoring Rules

| Event | Points | Description |
|-------|--------|-------------|
| Task completed successfully | +5 | Agent completed assigned task without escalation |
| First-pass approval | +3 | Task approved in review without revision requests |
| Second-pass approval | +1 | Task approved after one revision round |
| Critical finding identified | +4 | Analyst discovered a P0/P1 issue |
| Task failed | -5 | Agent could not complete assigned task |
| Review rejection (2+ rounds) | -3 | Task required 3+ review rounds to pass |
| Escalation required | -2 | Agent had to escalate to higher tier |
| False positive reported | -2 | Agent reported a false positive finding |
| Fallback model activated | -1 | Primary model unavailable, fallback used |

---

## Score-Weighted Selection Algorithm

```
1. Read all active names and their scores from this file
2. Normalize scores to weights: weight = max(score + 101, 1)
   - Score -100 → weight 1 (minimum, never zero)
   - Score 0 → weight 101
   - Score +100 → weight 201
3. For each agent slot (10 slots):
   a. Calculate probability: P(name) = weight(name) / sum(all remaining weights)
   b. Select name using weighted random
   c. Remove selected name from remaining pool
4. Record assignments in session file
```

---

## Name-to-Slot Assignment History

> Updated by Orchestrator at each session end. Last 5 sessions shown.

| Session | Date | PrincipalAlpha | PrincipalBeta | StaffEngineerAlpha | StaffEngineerBeta | MidCoderAlpha | MidCoderBeta | LeadAnalyst | AnalystAlpha | AnalystBeta | AnalystGamma |
|---------|------|----------------|---------------|--------------------|--------------------|---------------|--------------|-------------|--------------|-------------|--------------|
| — | — | — | — | — | — | — | — | — | — | — | — |
