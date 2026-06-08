# Tier Bridge — Global AGENTS.md ↔ Cursor Package

Cursor paketi **T1–T5** şemasını kanonik kabul eder. Workspace kökündeki [AGENTS.md](/Users/tcvmaksutoglu/Dev/w/crm/AGENTS.md) **T1 / T1.5 / T2 / T2.5 / T3** kullanır.

| Global (crm/AGENTS.md) | Cursor paketi | Rol |
|------------------------|---------------|-----|
| T1 Principal | T1 Principal | Mimari, final review |
| T1.5 Staff Engineer | T2 Staff Engineer | Karmaşık implementasyon, T3 review |
| T2 MidCoder | T3 Mid Coder | Sınırlı implementasyon |
| T2.5 Lead Analyst | T4 Lead Analyst | Analiz konsolidasyonu |
| T3 Analyst | T5 Analyst | Ham keşif / analiz |

## Review Chain Mapping

| Global | Cursor |
|--------|--------|
| T3 → T2.5 | T5 → T4 |
| T2 → T1.5 | T3 → T2 |
| T1.5 → T1 | T2 → T1 |

## Kullanım Notu

Host projede her iki AGENTS dosyası yüklenebilir. Çakışmada **Cursor paketi tier numaraları** delegasyon ve runtime artifact'ları için geçerlidir; global dosya genel kod standartları ve dil politikasını taşır.
