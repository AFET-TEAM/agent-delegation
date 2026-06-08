---
plan-id: 2026-05-22-html-tr-examples-x10
created: 2026-05-22T00:00:00Z
status: complete
total-tasks: 12
completed-tasks: 12
session-mode: x10
---

# Active Plan — HTML Türkçe Dönüşüm + Örnek Kullanımlar (x10)

## Görev
1. `docs/index.html` mevcut İngilizce içerik tamamen Türkçeleşecek
2. Her özelliğin örnek kullanımı eklenecek (slash commands, hooks, skills, xN modes, tools)
3. Birlikte kullanım örnekleri (context-mode + graphify, /caveman + xN, vb.)
4. Mevcut yapı korunarak (122KB → 180KB tahmini)

## Agent Atamaları

| Slot | Name | Tier | Görev |
|------|------|------|-------|
| T5-A | Onur Ardic | T5 | H01: İngilizce content audit |
| T5-B | Yavuz Yalcin | T5 | H02: Özellik + örnek katalog |
| T4-A | Elif Ozge Maksutoglu | T4 | H03: Çeviri scope konsolidasyonu |
| T4-B | Ayse Demir | T4 | H04: Örnek katalog konsolidasyonu |
| T2-A | Enis Sait Erken | T2 | H05: Türkçe içerik planı + H09: T3-A review |
| T2-B | Tarik Ziya Yesilcinen | T2 | H06: Örnek section design + H10: T3-B review |
| T3-A | Taner Yilmaz | T3 | H07: Türkçe Section 1-4 markdown |
| T3-B | Canan Birsen | T3 | H08: Türkçe Section 5-8 + örnek HTML |
| T1-A | Selin Akar | T1 | H11: Final HTML build |
| T1-B | Baris Benli | T1 | H12: Final review |

## DAG

```
Wave 1: H01 (T5-A) ∥ H02 (T5-B)
Wave 2: H03 (T4-A) ← H01    ∥    H04 (T4-B) ← H02
Wave 3: H05 (T2-A) ← H03    ∥    H06 (T2-B) ← H04
Wave 4: H07 (T3-A) ← H05    ∥    H08 (T3-B) ← H05+H06
Wave 5: H09 (T2-A) ← H07    ∥    H10 (T2-B) ← H08
Wave 6: H11 (T1-A) ← H09+H10    ∥    H12 (T1-B) ← H11
```

Cycle check: clean.

## File Ownership

| File | Owner |
|------|-------|
| `.claude/analysis/raw/H01-html-english-audit.md` | T5-A |
| `.claude/analysis/raw/H02-feature-example-catalog.md` | T5-B |
| `.claude/analysis/consolidated/H03-translation-scope.md` | T4-A |
| `.claude/analysis/consolidated/H04-example-catalog.md` | T4-B |
| `.claude/docs/turkish-content-plan.md` | T2-A |
| `.claude/docs/example-sections-design.md` | T2-B |
| `.claude/analysis/raw/H07-tr-sections-1-4.md` | T3-A |
| `.claude/analysis/raw/H08-tr-sections-5-8-examples.md` | T3-B |
| `.claude/analysis/consolidated/H09-T3A-review.md` | T2-A |
| `.claude/analysis/consolidated/H10-T3B-review.md` | T2-B |
| `docs/index.html` (REWRITE) | T1-A |
| `.claude/analysis/consolidated/H12-final-review.md` | T1-B |

## Wave Status
| Wave | Status |
|------|--------|
| 1 | RUNNING |
| 2-6 | pending |
