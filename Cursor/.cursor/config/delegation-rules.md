# Delegation Rules

## Fixed xN Distributions

| Parametre | Toplam | T1 | T2 | T3 | T4 | T5 |
|---|---:|---:|---:|---:|---:|---:|
| x2 | 2 | 1 | 0 | 0 | 0 | 1 |
| x3 | 3 | 1 | 1 | 0 | 0 | 1 |
| x4 | 4 | 1 | 1 | 1 | 0 | 1 |
| x5 | 5 | 1 | 1 | 1 | 1 | 1 |
| x7 | 7 | 1 | 2 | 1 | 1 | 2 |
| x10 | 10 | 2 | 2 | 2 | 2 | 2 |

## Dynamic Formula

- T1 = max(1, round(N * 0.15))
- T2 = max(1, round(N * 0.20))
- T3 = N >= 5 ? max(1, round(N * 0.20)) : 0
- T4 = N >= 5 ? 1 : 0
- T5 = remainder

## Edge Cases

- `x1` => single-agent
- `x0` veya negatif => ignore
- `N > 10` => x10'a cap et, uyarı ver
- parametre yoksa single-agent mod

## Review Chain

- x2: T1, T5 çıktısını doğrudan review eder
- x3: T2 → T5, T1 → T2
- x4: T2 → T3/T5, T1 → T2
- x5+: T4 → T5, T2 → T3, T1 → T2

## Execution Waves

1. Wave 1: T5 araştırma/keşif
2. Wave 2: T4 konsolidasyon
3. Wave 3: T3/T2 implementasyon
4. Wave 4: T2/T1 review zinciri
