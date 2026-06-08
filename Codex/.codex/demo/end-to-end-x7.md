# End-to-End Demo — x7 + PCD + Fallback + Review

## Senaryo

Görev: `Müşteri bildirim modülünü oluştur; tercih yönetimi, API endpointleri, React ayar ekranı ve testler dahil. /pcd /context-mode x7`

## Wave 0 — Orchestrator Intake

- intent çıkarılır
- x7 parse edilir
- task dalgalara ayrılır
- PCD başlatılır
- context-mode aktif edilir

### x7 Dağılımı

- T1: 1 Principal
- T2: 2 Staff Engineer
- T3: 1 Mid Coder
- T4: 1 Lead Analyst
- T5: 2 Analyst

## Wave 1 — PCD + Repo Keşfi

### T5 Analyst A
- README, docs, existing notification/preferences code tarar
- raw rapor yazar

### T5 Analyst B
- config, routes, API contracts, tests alanlarını tarar
- raw rapor yazar

## Wave 2 — Konsolidasyon

### T4 Lead Analyst
- iki raw raporu birleştirir
- riskler: mevcut preference modeli, auth dependency, test gap
- coding tier'lar için önerilen dosya listesi çıkarır

## Wave 3 — Implementasyon

### T2 Staff Engineer Alpha
- backend preference service + endpointler

### T2 Staff Engineer Beta
- test stratejisi + integration wiring

### T3 Mid Coder
- React ayar ekranı + basit UI state akışı

## Wave 4 — Fallback Örneği

T3 beklenen model: `gpt-5.2`

Varsayım: model erişim hatası oluşur.

Orchestrator aksiyonu:
- T3 görevi `gpt-5.3-codex` fallback ile sürdürür
- fallback event loglanır
- final özette kalite artışı / maliyet artışı belirtilir

## Wave 5 — Review Chain

- T2, T3 çıktısını review eder
- T1, iki T2 çıktısını review eder
- gerekiyorsa tek revizyon turu açılır
- kabul sonrası final konsolidasyon yapılır

## Session End

- session summary yazılır
- token usage işlenir
- fallback-log güncellenir
- leaderboard ve active-plan güncellenir

## Kullanıcıya Final Rapor Örneği

- tamamlanan backend dosyaları
- tamamlanan frontend dosyaları
- test kapsamı
- fallback olayı
- açık follow-up maddeleri
