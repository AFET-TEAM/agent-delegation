# Changelog

Bu dosya Multi-Agent Delegation System boilerplate'indeki tüm değişiklikleri takip eder.
Format [Keep a Changelog](https://keepachangelog.com/) standardına uygundur.

---

> v6.1.0–v6.4.0: Sürekli kalite denetim döngüsü — aynı gün iteratif olarak yayınlandı.

## [7.3.0] — 2026-05-20

### Added

#### Token Verimliliği Katmanı

- **Caveman Modu** (`.github/skills/caveman/SKILL.md`): Opsiyonel çıktı sıkıştırma (%40-65 output token azaltma). Üç seviye: lite/full/ultra. `/caveman` komutu veya anahtar kelime ile aktifleşir.
- **Context Efficiency** (`.github/skills/context-efficiency/SKILL.md`): Think-in-Code, Output Routing, Blocked Patterns. Baseline kurallar her zaman aktif, `/context-mode` ile yoğunlaştırılmış mod.
- **Knowledge Graph** (`.github/skills/knowledge-graph/SKILL.md`): Query-First, Confidence Tagging (🟢/🟡/🔴), God Node Detection, Progressive Disclosure. T4/T5 analiz ajanları için zorunlu.

#### Slash Komutları

- `/caveman [lite|full|ultra]` — Token-verimli kısa çıktı modu
- `/caveman off` — Deaktivasyon
- `/context-mode` — Yoğunlaştırılmış bağlam verimliliği
- `/context-mode off` — Deaktivasyon

#### Dokümantasyon

- `docs/` klasörü oluşturuldu: context-efficiency, knowledge-graph, caveman, verimlilik-karsilastirma rehberleri
- `cave.md` — Caveman implementasyon özeti (Türkçe)
- `context-mode-integration.md` — Context Efficiency + Knowledge Graph entegrasyon özeti (Türkçe)

### Changed

- `shared-base.instructions.md` — Context Efficiency Protocol (Always Active) + Context Mode (Optional) + Caveman Mode bölümleri eklendi (+103 satır)
- `context-loading.instructions.md` — Cross-Cutting Response Modifiers bölümü genişletildi (+41 satır)
- `slash-commands.instructions.md` — `/caveman` ve `/context-mode` komutları eklendi (+70 satır)
- `system-validation.instructions.md` — Skills minimum 14→16
- `README.md` — Token Verimliliği Modları bölümü, 16 skill, 9 slash komutu, skor tablosu güncellendi
- `USAGE.md` — Versiyon güncellendi

### Technical Details

- 3 yeni skill dosyası (caveman, context-efficiency, knowledge-graph)
- 16 toplam skill (önceki: 13)
- 9 slash komutu (önceki: 7)
- Cross-cutting modifier mimarisi: skill bütçesine dahil değil
- Stacking: /context-mode + /caveman birlikte kullanılabilir
- Baseline kurallar 0 ek token maliyeti (shared-base'de gömülü)
- İlham kaynakları: JuliusBrussee/caveman, mksglu/context-mode, safishamsi/graphify

---

## [7.2.0] — 2026-04-18

### Added

#### Frontend Versiyon-Duyarlı Geliştirme Sistemi

- **Version Detection Protocol** — `frontend-development/SKILL.md`'ye package.json'dan React ve Ant Design versiyon algılama protokolü eklendi. Agent'lar artık projenin `react` ve `antd` dependency versiyonlarını okuyarak versiyon-koşullu kurallar uygular.
- **React 19 Desteği** — `use()` hook, `useActionState`, `useFormStatus`, `useOptimistic`, React Compiler, `ref` as prop, `forwardRef` deprecation belgelendi. React 18→19 migration notları eklendi.
- **Ant Design 6 Desteği** — CSS Variables (v6 default), renamed props (`destroyInactiveTabPane`→`destroyOnHide`), yeni `Splitter` bileşeni, `Spin percent` prop belgelendi. v5→v6 migration notları eklendi.
- **React 19 Test Patterns** — `testing-standards/SKILL.md`'ye `use()` hook testi, form Actions testi, `useOptimistic` testi eklendi.
- **README Maliyet Karşılaştırması** — Sistem olmadan vs. sistem ile token/maliyet/context karşılaştırma tablosu eklendi.
- **Frontend Versiyon Desteği** skoru — Gelişim skoru tablosuna yeni boyut eklendi.

### Changed

- **frontend-development/SKILL.md** — Sıfırdan yeniden yazıldı: React 18/19 dual-version, Ant Design 5/6 dual-version, package.json algılama, versiyon-koşullu kurallar, migration notları (500→620+ satır)
- **testing-standards/SKILL.md** — `fireEvent` → `userEvent` güncellendi, React 19 test bölümü eklendi, version detection notu eklendi
- **implementation/SKILL.md** — Gereksiz `import React` kaldırıldı
- **react-spa.md** — React 18+/19, Ant Design 5.x/6.x, flat folder convention
- **README.md** — Sıfırdan yeniden yazıldı: maliyet karşılaştırması, frontend desteği, temizlenmiş skor tablosu

### Fixed

#### Sistem Geneli Bulgular

- **mid-coder-alpha/beta.agent.md** — Eksik Output Format bölümü eklendi (diğer tier'larla tutarlılık)
- **review-enforcer.json** — T4/T5 agent'lar için eksik explicit case'ler eklendi (wildcard yerine)
- **context-loading.instructions.md** — Türkçe metin İngilizce'ye çevrildi (Language Policy uyumu), T4 core/extended loading notu eklendi
- **copilot-instructions.md** — x2/x4 dağılımları, Dynamic Naming System, Language Policy referansı eklendi
- **plan.md** — Stale T1.5/T2.5 referansları olan dosya silindi
- **active-plan.md** — Stale filename referansı temizlendi

---

## [7.1.0] — 2026-04-18

### Changed

#### Tier Yapısı — Tam Sayı Refactoring (68+ dosya)

- **Tier numaralandırma sistemi** kırılımlı (1, 1.5, 2, 2.5, 3) yapıdan tam sayı (1, 2, 3, 4, 5) yapıya dönüştürüldü:
  - T1 Principal → T1 (değişmedi)
  - T1.5 Staff Engineer → **T2**
  - T2 MidCoder → **T3**
  - T2.5 Lead Analyst → **T4**
  - T3 Analyst → **T5**
- **11 agent dosyası** — Tier referansları, review chain, YAML metadata güncellendi
- **13 skill dosyası** — `used-by:` ve `tiers:` YAML metadata güncellendi
- **21 instruction dosyası** — Tier referansları, tablo, formül ve örnekler güncellendi
- **4 instruction dosyası yeniden adlandırıldı**:
  - `tier1-5-staff-engineer.instructions.md` → `tier2-staff-engineer.instructions.md`
  - `tier2-mid.instructions.md` → `tier3-mid.instructions.md`
  - `tier2-5-lead-analyst.instructions.md` → `tier4-lead-analyst.instructions.md`
  - `tier3-analyst.instructions.md` → `tier5-analyst.instructions.md`
- **5 hook dosyası** — Tier referansları güncellendi
- **3 template dosyası** — Agent assignment tabloları güncellendi
- **AGENTS.md, README.md, USAGE.md, PROGRESS.md, copilot-instructions.md** — Tüm tier referansları güncellendi

### Fixed

#### P1 Bulgular (4)

- **USAGE.md** — "10 kural" → "11 kural" (Rule 11 Dynamic Naming eklenmişti)
- **name-pool.md** — Scoring tablosuna eksik "False positive reported: -2" event'i eklendi
- **task-planning.instructions.md** — Token soft-limit (12K warning) ve hard-limit (15K stop) eşikleri tanımlandı
- **dynamic-naming.instructions.md** — Orchestrator session-end scoring referansı netleştirildi

#### P2 Bulgular (7)

- **agent-performance.md, token-usage.md** — Stale `last-updated` tarihleri 2026-04-18'e güncellendi
- **token-usage.md** — PLAN-005 kayıt eksikliği için açıklama notu eklendi
- **active-plan.md** — PLAN-005 arşivlendi, "No active plan" notu eklendi
- **context-loading.instructions.md** — Analysis/Review arası tablo kıran note düzeltildi
- **context-loading.instructions.md** — PCD bütçesinin ana bütçeye dahil olduğu netleştirildi
- **Principal ve MidCoder agent dosyaları** — Output format şablonu tutarlılığı sağlandı (shared-base referansı)
- **AGENTS.md ↔ clean-code-standards** — DRY ihlali fark edildi, mevcut yapı korundu (referans sistemi)

#### P3 Bulgular (4)

- **dynamic-naming.instructions.md** — Score -100'e ulaşan isimler için retirement protokolü eklendi
- **lead-analyst.agent.md** — Escalation path netleştirildi: "StaffEngineerAlpha (birincil), çözülemezse PrincipalAlpha"
- **PROGRESS.md** — TASK-003 açıklama bölümüne tamamlanma notu eklendi
- **archive.md** — Boş arşiv durumu fark edildi ve belgelendi

### File Summary

- Değiştirilen dosya sayısı: 68+
- Yeniden adlandırılan dosya: 4
- Yeni dosya: 1 (plan.md)

---

## [7.0.1] — 2026-03-28

### Added

#### Dinamik Agent İsimlendirme Sistemi

- **Dynamic Naming Protocol** — `.github/instructions/reference/dynamic-naming.instructions.md` oluşturuldu. Orchestrator Step 0.5 olarak entegre edildi — her oturumda 20 isimlik havuzdan skor-ağırlıklı random seçim ile 10 agent'a display name atanır. Ağırlık formülü: `weight = max(score + 101, 1)`, tier çarpanları (S: 1.5x, A: 1.3x, B: 1.0x, C: 0.7x, D: 0.5x).
- **Name Pool** — `.github/config/name-pool.md` oluşturuldu. 20 isimlik havuz (10 orijinal + 10 yeni). Performans puanlama sistemi: +5 görev tamamlama, +3 ilk geçiş onayı, -5 başarısızlık, -3 çoklu revizyon. Skor aralığı -100 ile +100.
- **Leaderboard** — `.github/metrics/leaderboard.md` oluşturuldu. Kümülatif skor takibi, S/A/B/C/D tier sıralaması, oturum geçmişi. Tüm 20 isim varsayılan 0 puanla başlatıldı.
- **Post-Development Auto-Analysis Hook** — `.github/hooks/post-dev-analysis.json` oluşturuldu. >5 edit veya >10 dosya değişikliği sonrasında otomatik analiz tetikleme. Hook sayısı 4 → 5.
- **System Validation Rule 11** — `system-validation.instructions.md`'ye "Dynamic Naming System Integrity" kuralı eklendi. Name pool boyutu, skor tutarlılığı, tier ataması, agent dosyaları role-based ID doğrulaması, hook case statement doğrulaması ve Orchestrator Step 0.5 kontrolü. Toplam kural sayısı 10 → 11.
- **Merit-Based Selection** — `delegation-rules.instructions.md`'ye "Merit-Based Agent Selection" bölümü eklendi. Skor-ağırlıklı seçim algoritması, tier çarpanları ve performans etkisi belgelendi.

### Changed

#### Agent Dosyaları — Role-Based YAML ID Dönüşümü (11 dosya)

- **Tüm 10 non-orchestrator agent dosyası**: İnsan isimli YAML `name` alanları role-based tanımlayıcılara dönüştürüldü. Dynamic naming callout blokları eklendi. Çapraz referanslar güncellendi.
  - TanerYilmaz → PrincipalAlpha, OyaKanat → PrincipalBeta
  - BarisBenli → StaffEngineerAlpha, TarikZiyaYesilcimen → StaffEngineerBeta
  - EnisSaitErken → MidCoderAlpha, SelinAkar → MidCoderBeta
  - CananBirsen → LeadAnalyst
  - EmreKilic → AnalystAlpha, AyseDemir → AnalystBeta, ElifOzgeMaksutoglu → AnalystGamma
- **orchestrator.agent.md**: `agents:` listesi role-based ID'lere güncellendi, xN dağıtım tablosu güncellendi, review chain güncellendi, output format şablonları güncellendi, görev atama örnekleri güncellendi, **Step 0.5 (Dynamic Name Assignment)** eklendi, Session End Protocol'e performans puanlama adımı eklendi.

#### Hook Dosyaları (4 mevcut + 1 yeni = 5 toplam)

- **agent-lifecycle.json**: Tüm `case` ifadeleri role-based ID'lere dönüştürüldü.
- **context-guard.json**: Tüm `case` ifadeleri role-based ID'lere dönüştürüldü.
- **review-enforcer.json**: Tüm `case` ifadeleri role-based ID'lere dönüştürüldü.
- **safety-guard.json**: Tüm `case` ifadeleri role-based ID'lere dönüştürüldü.

#### Instruction Dosyaları (8 dosya güncellendi + 1 yeni = 21 toplam)

- **shared-base.instructions.md**: Agent isim referansları role-based ID'lere güncellendi.
- **system-validation.instructions.md**: Model tablosu role-based ID'lere güncellendi. Rule 11 eklendi. Kural sayısı 10 → 11.
- **slash-commands.instructions.md**: Agent referansları role-based ID'lere güncellendi.
- **context-loading.instructions.md**: Agent referansları güncellendi.
- **model-fallback.instructions.md**: Agent referansları güncellendi.
- **task-planning.instructions.md**: Agent referansları güncellendi.
- **project-context-discovery.instructions.md**: Agent referansları güncellendi.
- **delegation-rules.instructions.md**: Merit-based selection bölümü eklendi.

#### Metrik Dosyaları (2 dosya + 1 yeni)

- **agent-performance.md**: Tüm agent isimleri role-based ID'lere güncellendi.
- **token-usage.md**: Tüm agent isimleri role-based ID'lere güncellendi.

#### Dokümantasyon (4 dosya)

- **README.md**: Agent dosya ağacı role-based ID'lere güncellendi. Versiyon v7.0.0 → v7.0.1.
- **USAGE.md**: Tüm agent tabloları role-based ID'lere güncellendi. Versiyon v7.0.0 → v7.0.1.
- **PROGRESS.md**: Agent referansları güncellendi, dosya/kural sayıları güncellendi. Versiyon v7.0.0 → v7.0.1.
- **CHANGELOG.md**: v7.0.0 girişindeki dosya sayıları düzeltildi.

### Dosya Özeti

**Oluşturulan (4):**

- `.github/config/name-pool.md` — 20 isimlik havuz, puanlama sistemi
- `.github/metrics/leaderboard.md` — Kümülatif skor takibi ve sıralama
- `.github/instructions/reference/dynamic-naming.instructions.md` — Dinamik isimlendirme protokolü (instruction #21)
- `.github/hooks/post-dev-analysis.json` — Post-development otomatik analiz hook'u (hook #5)

**Değiştirilen (~30):**

- `.github/agents/` (11 dosya) — Role-based YAML ID dönüşümü, dynamic naming callout
- `.github/hooks/` (4 dosya) — Role-based case statements
- `.github/instructions/` (8 dosya) — Agent referansları, Rule 11, merit-based selection
- `.github/metrics/` (2 dosya) — Agent isim güncellemeleri
- `README.md`, `USAGE.md`, `PROGRESS.md`, `CHANGELOG.md` — Versiyon ve referans güncellemeleri

### Teknik Detay

- **234+ hardcoded insan ismi referansı** role-based ID'lere migrate edildi.
- VarolMaksutoglu (Orchestrator) sabit kaldı — diğer 10 agent artık role-based.
- Eski insan isimleri `name-pool.md`'de havuz üyesi olarak korundu (by-design).
- CHANGELOG tarihsel girişlerindeki eski isimler korundu (versiyon geçmişi).

### Fixed

- **CHANGELOG.md v7.0.0 dosya sayıları**: Instruction ve hook sayıları düzeltildi.
- **x10-final-principal-review.md stale referansları**: 22 stale referans düzeltildi, skorlar yeniden hesaplandı.

---

## [7.0.0] — 2026-03-21

### Added

#### Roadmap Görevleri (10 TASK tamamlandı)

- **TASK-002: Skill Core/Extended Split** — 3 büyük skill dosyasına (testing-standards, frontend-development, api-integration) YAML frontmatter'da `core-sections` ve `extended-sections` metadata eklendi. `context-loading.instructions.md`'ye "Skill Core/Extended Split Protocol" bölümü eklendi. Tahmini %15-25 skill token tasarrufu.
- **TASK-004: DAG Tabanlı Görev Bağımlılık Grafiği** — `delegation-rules.instructions.md`'ye "Task Dependency Graph (DAG)" bölümü eklendi. Construction protocol, DAG notation, execution waves ve validation rules tanımlandı. Tahmini %20 daha az rework.
- **TASK-005: Paralel Review Protokolü** — `review-chain.instructions.md`'ye "Parallel Review Protocol" bölümü eklendi. Modül bazlı paralel review, review matrix, batching ve conflict detection kuralları tanımlandı. Tahmini %25 review süre iyileştirmesi.
- **TASK-008: Metrik Toplama Otomasyonu** — `orchestrator.agent.md`'ye "Metrics Automation Protocol" bölümü eklendi. Session-end otomatik metrik güncelleme, token karşılaştırma ve agent performance snapshot adımları tanımlandı.
- **TASK-009: /create-agent Komutu** — `slash-commands.instructions.md`'ye `/create-agent [name] [tier]` slash komutu eklendi. Komut tablosuna ve detaylı bölüme tanım yazıldı.
- **TASK-010: Dinamik Skill Discovery** — Tüm 13 skill dosyasına YAML frontmatter'da `tiers:` metadata eklendi. Her tier için `mandatory`/`optional` designation tanımlandı. Tek kaynak (SKILL.md metadata) → tüm referanslar otomatik.
- **TASK-011: Context Window Dashboard** — `slash-commands.instructions.md`'deki `/status` komutuna "Context Window Dashboard" bölümü eklendi. Tahmini vs gerçek token tüketimi karşılaştırması ve budget exceeded uyarıları.
- **TASK-012: Multi-Session Continuity** — `session-memory.instructions.md`'ye "Context Snapshots for Multi-Session Continuity" bölümü eklendi. Otomatik context snapshot, handoff document formatı ve `/resume` recovery protokolü.
- **TASK-013: Agent Performance Benchmark** — `agent-performance.md`'ye "Benchmark Framework" bölümü eklendi. 5 boyutlu değerlendirme (accuracy, efficiency, autonomy, quality, collaboration), scoring ve report template.
- **TASK-014: Proje Şablonları** — `.github/templates/` dizini oluşturuldu. 3 proje şablonu: `react-spa.md`, `spring-boot.md`, `full-stack.md`. Her şablon aktif/pasif skill'leri, PCD override'ları ve görev tipi mapping'lerini tanımlar.

#### Model Registry & Analyst Scoped Write

- **Model Name Registry** — `.github/instructions/reference/model-registry.instructions.md` oluşturuldu. Kanonik model tablosu (10 model), 4 kategori alias çözümleme tablosu, 5 adımlı çözümleme protokolü, YAML↔kanonik dönüşüm kuralları. `AGENTS.md`, `copilot-instructions.md`, `model-fallback.instructions.md` ve `system-validation.instructions.md` dosyalarına çapraz referans eklendi.
- **Analyst Scoped Write Access** — T3 Analyst (Emre, Ayşe, Elif Özge) ve T2.5 Lead Analyst (Canan) agent'larına `.github/analysis/` dizinine kapsamlı yazma izni verildi. T3 → `.github/analysis/raw/`, T2.5 → `.github/analysis/consolidated/`. Mimari karar kaydı: `ADR-002-analyst-write-permission.md`. `safety-guard.json` kapsamlı yazma enforcement'ı, `context-guard.json` EDIT alanı güncellendi. 4 analyst agent dosyası, `shared-base.instructions.md`, `tier3-analyst.instructions.md`, `tier2-5-lead-analyst.instructions.md` ve 12+ çapraz referans dosyası güncellendi.
- **Analysis Output Directories** — `.github/analysis/raw/` ve `.github/analysis/consolidated/` dizinleri oluşturuldu. T3 Analyst ham raporları `raw/`'a, T2.5 Lead Analyst konsolide raporları `consolidated/`'a yazılır. Dosya tabanlı handoff mekanizması.
- **System Validation Rule 10** — `system-validation.instructions.md`'ye "Analysis Directory Integrity" kuralı eklendi. Dizin varlığı, dosya adlandırma kuralları ve uygulama kodu yasağı doğrulaması. Toplam kural sayısı 9 → 10.

### Fixed

#### Konfigürasyon Düzeltmeleri (8 Gap Fix)

- **checkstyle.xml**: `CyclomaticComplexity` modülü eklendi (max=8). `TodoComment` severity `info`→`error`'a yükseltildi, `FIXME`/`HACK`/`XXX` pattern'leri eklendi.
- **pom-quality-plugins.xml.template**: JaCoCo `check` execution eklendi (%80 line, %70 branch coverage kuralları). Nested XML comment hatası düzeltildi (`<!-- -->` → `~~~ ~~~` marker).
- **spotbugs-exclude.xml**: Test/Config wildcard pattern'leri (`.*Test.*`, `.*Config.*`) suffix-based ve package-based eşleşmelere sıkılaştırıldı (`.*Test$`, `.*Tests$`, `.*TestCase$`, `.*Config$`, `.*Configuration$`).
- **safety-guard.json**: `.env`/secrets/credentials/key dosya yolu koruması eklendi (PreToolUse edit hook'a).
- **tier2-mid.instructions.md**: `console.log` ifadesi "ZERO tolerance" wording'ine güncellendi.
- **commit-standards/SKILL.md**: `feat!!` → `feat!` düzeltildi (standart Conventional Commits). `add` tipi proje-specific extension olarak belgelendi.
- **task-planning.instructions.md**: T3 baseline token bütçesi `2K-5K` → `3K-6K` olarak güncellendi.
- **.vscode/settings.json**: Java tooling ayarları eklendi (Checkstyle config path, SonarLint, null analysis, Java formatter).

### Changed

- **Versiyon**: v6.4.0 → v7.0.0 (README, USAGE, CHANGELOG, PROGRESS)
- **README.md**: Yeni özellikler (templates, /create-agent, DAG, paralel review, benchmarks, core/extended split, dynamic skill discovery, multi-session continuity), dosya ağacına `templates/` dizini, slash komutlar tablosu güncellendi, skor evrimi tablosuna v7.0.0 sütunu eklendi
- **USAGE.md**: v7.0.0 versiyon güncellemesi, yeni özellikler dokümantasyonu (templates, /create-agent, context window dashboard, DAG, paralel review, core/extended split, benchmarks, multi-session continuity)
- **PROGRESS.md**: 10 TASK durumu `Planlandı` → `✅ v7.0.0`, TASK-002 durumu düzeltildi, analiz tablosuna v7.0.0 kaydı eklendi

### Dosya Özeti

**Oluşturulan (7):**

- `.github/templates/react-spa.md`
- `.github/templates/spring-boot.md`
- `.github/templates/full-stack.md`
- `.github/instructions/reference/model-registry.instructions.md`
- `.github/analysis/raw/.gitkeep`
- `.github/analysis/consolidated/.gitkeep`
- `.github/docs/adr/ADR-002-analyst-write-permission.md`

**Değiştirilen (30+):**

- `.github/config/checkstyle.xml` — CyclomaticComplexity + TodoComment
- `.github/config/pom-quality-plugins.xml.template` — JaCoCo check + nested comment fix
- `.github/config/spotbugs-exclude.xml` — Pattern tightening
- `.github/hooks/safety-guard.json` — .env/secrets guard
- `.github/agents/orchestrator.agent.md` — Metrics Automation Protocol
- `.github/instructions/reference/delegation-rules.instructions.md` — DAG section
- `.github/instructions/reference/review-chain.instructions.md` — Parallel Review Protocol
- `.github/instructions/reference/tier2-mid.instructions.md` — ZERO tolerance
- `.github/instructions/reference/task-planning.instructions.md` — T3 baseline update
- `.github/instructions/reference/slash-commands.instructions.md` — /create-agent + context dashboard
- `.github/instructions/reference/session-memory.instructions.md` — Context Snapshots
- `.github/instructions/reference/context-loading.instructions.md` — Core/Extended Split Protocol
- `.github/skills/` (13 dosya) — tiers YAML metadata + core/extended sections (3 dosya)
- `.github/metrics/agent-performance.md` — Benchmark Framework
- `.vscode/settings.json` — Java tooling
- `.github/instructions/reference/model-fallback.instructions.md` — model-registry çapraz referans
- `.github/instructions/reference/system-validation.instructions.md` — Rule 10, model-registry referans
- `.github/instructions/shared-base.instructions.md` — scoped write access, analysis handoff
- `.github/instructions/reference/tier3-analyst.instructions.md` — scoped write kuralları
- `.github/instructions/reference/tier2-5-lead-analyst.instructions.md` — scoped write kuralları
- `.github/agents/` (4 analyst agent dosyası) — edit tool, analysis dizin erişimi
- `.github/hooks/safety-guard.json` — scoped write enforcement
- `.github/hooks/context-guard.json` — EDIT alanı güncelleme
- `AGENTS.md` — model-registry referans, scoped write kuralları
- `PROGRESS.md`, `README.md`, `CHANGELOG.md`, `USAGE.md` — versiyon ve dokümantasyon güncellemeleri

---

## [6.4.0] — 2026-03-19

### Fixed

#### Agent & Hook Düzeltmeleri
- **P1: Stale PrincipalAlpha referansı** — `orchestrator.agent.md` satır 46'daki eski `PrincipalAlpha` → `TanerYilmaz` olarak düzeltildi
- **P2: agent-lifecycle.json 3 rol uyumsuzluğu** — OyaKanat `Yazilim Mimari` → `Kidemli Yazilim Mimari`, TarikZiya `Kidemli Yazilim Muhendisi` → `Yazilim Muhendisi`, CananBirsen `Bas Analist` → `Kidemli Sistem Analisti`

#### Skill Dosyası Düzeltmeleri (7 düzeltme)
- **testing-standards**: Stale Next.js router mock → React Router, stale Redux mock → Zustand, nested folder yapısı → flat-folder
- **frontend-development**: Wildcard `import * as yup` → named imports
- **clean-code**: Java Checkstyle parameter limit (7) vs standard (3) reconciliation notu eklendi
- **backend-development**: Node.js `ApiResponse<T>` → `ServiceResponse<T>` — api-integration canonical type ile çakışma giderildi
- **backend-security**: `ApiResponse.success()` → `ServiceResponse.success()` — phantom method düzeltildi

#### Instruction Dosyası Düzeltmeleri (6 düzeltme)
- **shared-base**: Orchestrator tool set farkı (`agent, read, search` — `fetch` yok) belgelendi
- **context-loading**: `code-review` ve `testing-standards` Required → Phase-Loaded'a taşındı; Java skill'leri Skip'e eklendi; Orchestrator budget satırı eklendi
- **system-validation**: Rule 2 glob `*.instructions.md` → `**/*.instructions.md` — reference/ dosyalarını kapsayacak şekilde düzeltildi
- **review-chain**: x5+ mode dokümanı eklendi
- **AGENTS.md**: Dual authority → summary referans olarak değiştirildi
- **session-memory**: Orchestrator delegation notu eklendi

#### Dokümantasyon Düzeltmeleri
- **USAGE.md**: L38 cp flag sırası, L544 stale applyTo rehberi, L561 stale auto-load iddiası, L547-551 skill ekleme rehberi tamamlandı
- **ADR-001**: Stale ~45-55K → ~15-20K post-v6.0.0 token figürü, "tier/feature-specific" → "on-demand reference (5+11)", R-6 log rotation limitation eklendi
- **task-planning**: Platform overhead ~8-12K terminoloji açıklaması eklendi
- **PROGRESS.md**: 57/60 → 60/60 (denominatör açıklaması), v6.1.0 analiz kaydı, TASK-001/006 durum güncellemesi, öncelik matrisine Durum sütunu
- **README.md**: v6.2.2 bulgu sayısı 12 → 10, skor hesaplama yöntemi bölümü, versiyonlama notu, reviews/ runtime artifact notu

#### Principal Audit Düzeltmeleri (12 bulgu)
- **context-loading**: Phantom skill count notları düzeltildi (6→4 Required, 5→3 Required — Phase-Loaded'a taşınan skill'ler)
- **CHANGELOG**: 4 tarihsel sayı hatası düzeltildi (v4.8.0: 4→3, v1.1.0: 13→15, v6.0.0: 19→20, v3.0.0: 12→11)
- **AGENTS.md**: Mandatory Skills → Universal (2) + Domain-Specific (6) ayrımı yapıldı
- **safety-guard.json**: Variable quoting tutarlılığı (`AGENT="${...}"` — 2 satır düzeltildi)

---

## [6.3.0] — 2026-03-19

### Fixed

- **P1: delete_file hook coverage** — `safety-guard.json` ve `review-enforcer.json`'daki PreToolUse/PostToolUse tool listelerine `delete_file` eklendi. Dosya silme operasyonları artık izleniyor ve loglanıyor.
- **P1: Scaffolding path regression** — `agent-scaffolding.instructions.md` şablonu yeni instruction dosyalarını `reference/` dizinine yönlendirecek şekilde düzeltildi. `applyTo: "**"` şablon frontmatter'dan kaldırıldı. Token overhead regresyonu önlendi.
- **P1: Token estimate accuracy** — 13 skill dosyasının `estimated-tokens` YAML değerleri gerçek ölçümlerle kalibre edildi. `backend-security` 3500→4700 (+35%), `testing-standards` 5000→6600 (+32%), `api-integration` 4500→5200, `backend-development` 5500→4800, `analysis` 3000→2500, `code-review` 2500→1800, `clean-code` 3000→2700, `java-quality-tooling` 3500→2400, `pr-standards` 2000→1400.
- **P1: Budget overflow documentation** — `context-loading.instructions.md`'ye Backend API'nin T1/T1.5 bütçesini (5 skill max) ve Frontend UI'ın T2 bütçesini (4 skill max) aştığına dair notlar eklendi.
- **P1: Auto-load overhead correction** — `context-loading.instructions.md`'deki overhead iddiası ~8-12K'dan gerçek ölçüm ~4-5K'ya düzeltildi (3 occurrence).
- **P2: safety-guard mkdir-p** — `safety-guard.json`'ın 4 handler'ına `mkdir -p .github/logs` eklendi. Fresh clone'da log yazma hatası önlendi.
- **P2: review-enforcer SubagentStop mkdir-p** — SubagentStop handler'ına `mkdir -p .github/logs` eklendi.
- **P2: Output format references** — 3 tier instruction dosyasındaki output format referansı `AGENTS.md`'den doğru kaynak `shared-base.instructions.md`'ye düzeltildi.
- **P2: Orchestrator permission model** — `shared-base.instructions.md` section header'ı Orchestrator'ı read-only olarak dahil edecek şekilde güncellendi. 3 dosya arasındaki tutarsızlık giderildi.
- **P2: ApiResponse alignment** — `api-integration/SKILL.md`'ye canonical `ApiResponse<T>` format notu eklendi. `backend-development/SKILL.md` Node.js section ile çapraz referans açıklandı.
- **P2: File size limit clarification** — `clean-code/SKILL.md`'ye domain-specific override notları eklendi (frontend 300-satır, Java Checkstyle 2000-satır). `java-quality-tooling/SKILL.md`'ye Checkstyle-vs-team-standard açıklaması eklendi. `frontend-development/SKILL.md`'ye clean-code alignment notu eklendi.
- **P2: Hook platform limitations documented** — `shared-base.instructions.md`'ye "Hook System: Known Platform Limitations" section'ı eklendi (advisory enforcement, hook ordering, log locking, convention-based ownership).
- **P2: agent-lifecycle.json log sanitization** — SubagentStart/Stop/Error handler'larında `${COPILOT_AGENT:-unknown}` `tr -cd` ile sanitize ediliyor. Log injection önlendi.
- **P3: AGENT_NAME→AGENT rename** — `safety-guard.json` PreToolUse handler'larında değişken ismi `AGENT_NAME`'den `AGENT`'a standardize edildi.
- **P3: Duplicate counter-reset removed** — `agent-lifecycle.json`'daki duplicate `rm -f .edit-count` step'i kaldırıldı. Single source of truth: `review-enforcer.json`.
- **P3: Skill used-by fields** — 10/13 skill dosyasına eksik `used-by` YAML alanı eklendi. Tier uygulanabilirliği artık machine-parseable.
- **P3: README title corrections** — Oya Kanat "Kıdemli Yazılım Mimarı", Canan Birsen "Kıdemli Sistem Analisti" olarak agent dosyalarıyla tutarlı hale getirildi.
- **P3: backend-development testing cross-reference** — Testing section'a `testing-standards/SKILL.md` çapraz referansı eklendi.
- **P3: Path quoting** — `agent-lifecycle.json`'da active-plan.md path'i tırnaklandı.

### Added (Post-Fix Review Cycle)

- **P1: USAGE.md scaffolding path** — Agent oluşturma rehberindeki instructions dosya path'i `.github/instructions/reference/` dizinini içerecek şekilde düzeltildi. Kullanıcıların yanlışlıkla auto-load dosya oluşturması önlendi.
- **P2: backend-security used-by fix** — `used-by` listesinden T2 (MidCoder) kaldırıldı. 3 otoriter kaynak (tier2-mid, scaffolding, USAGE.md) T2'yi desteklememektedir.
- **P2: backend-development checklist** — "ApiResponse or ServiceResponse" ifadesi, doğru kullanımı açıklayan `ServiceResponse<T>` + `ApiResponse<T>` controller boundary açıklamasıyla güncellendi.
- **P2: USAGE.md reduced mode review** — x2, x3, x4 modlarının review zinciri adaptasyonu USAGE.md'ye eklendi. TASK-006 kapatıldı.
- **P2: active-plan.md completed** — Plan status'u `completed` olarak güncellendi. 14/14 phase tamamlandı.
- **P2: Metrics v6.3.0 records** — `token-usage.md`'ye 10 yeni kayıt eklendi (PLAN-004 session). Toplam 16 kayıt. Calibration version 3. Deviation alerts güncellendi.
- **P3: ADR-001 overhead clarification** — D-2 kararındaki ~8-12K token açıklaması, platform overhead dahil/hariç ayrımını netleştirecek şekilde güncellendi.
- **P3: used-by format standardization** — `backend-security/SKILL.md` ve `api-integration/SKILL.md`'deki long-form `used-by` formatı (`Tier 1 (Principal)`) kısa form `[T1, T1.5]`'e standardize edildi. 13/13 skill artık tutarlı format kullanıyor.
- **P3: Skill scaffolding guide** — `agent-scaffolding.instructions.md`'ye Section 9 eklendi: skill oluşturma şablonu, naming convention ve 7 adımlık post-creation checklist.
- **P3: PROGRESS.md history** — "Tamamlanan Analizler" tablosu v6.0.0→v6.3.0 arasındaki tüm analizlerle güncellendi (8 kayıt). F6 (reduced mode) düzeltildi olarak işaretlendi.

---

## [6.2.2] — 2026-03-19

### Fixed

- **P1: run_in_terminal PostToolUse** — `safety-guard.json`'a `run_in_terminal` için PostToolUse handler eklendi. Terminal komut tamamlanması artık loglanıyor.
- **P2: applyTo removal** — `.github/instructions/reference/` içindeki 16 dosyanın vestigial `applyTo: "**"` frontmatter'ı kaldırıldı. Platform davranışına bağlı olarak ~15K token/session tasarruf potansiyeli.
- **P2: shared-base documentation accuracy** — `safety-guard.json` hook davranışı "blocks" yerine doğru şekilde "logs and warns" olarak güncellendi. VarolMaksutoglu (Orchestrator) read-only agent listesine eklendi.
- **P2: Counter numeric validation** — `review-enforcer.json`'da corrupt counter dosya içeriği için `case` tabanlı numerik doğrulama eklendi. `[ -gt ]` shell hatası önlendi.
- **P2: Log echo sanitization** — `safety-guard.json`'daki tüm log echo ifadelerinde `$COPILOT_AGENT` artık `tr -cd` ile sanitize ediliyor (log injection önlemi).
- **P2: $(wc -c) quoting** — `agent-lifecycle.json` log rotation'da `$(wc -c)` tırnaklandı (defensive scripting).
- **P2: mkdir -p in Stop/Error** — `agent-lifecycle.json` SubagentStop ve SubagentError handler'larına `mkdir -p .github/logs` eklendi. Start olmadan çalışma durumunda log yazma hatası önlendi.
- **P2: README file tree** — `PROGRESS.md` ve `.github/reviews/` README dosya ağacına eklendi.
- **P2: Backend API context budget** — `context-loading.instructions.md`'ye Backend API görevinin T2 bütçesini (4 skill) aştığına dair not eklendi.
- **P3: PROGRESS.md Phase 14** — "Doğrulama bekliyor" stale durumu, v6.2.1 x10 audit sonuçlarıyla güncellendi (7/7 tutarlılık + 53/57 doküman doğruluğu).

---

## [6.2.1] — 2026-03-19

### Fixed

- **P0: Single-quote shell bug** — `agent-lifecycle.json` ve `safety-guard.json` içindeki 5 log echo ifadesi tek tırnak kullandığı için `${COPILOT_AGENT}` ve `$(date)` expansion yapamıyordu. Tüm log ifadeleri çift tırnağa çevrildi.
- **P0: Terminal safety guard** — `run_in_terminal` PreToolUse hook'u read-only agent kontrolü yapmıyordu. T2.5/T3/Orchestrator için read-only guard eklendi.
- **P1: Orchestrator read-only list** — VarolMaksutoglu (Orchestrator) safety-guard read-only listesinde yoktu, eklendi.
- **P1: 5th review chain step** — `orchestrator.agent.md` review chain'inde "Principal outputs → Submitted to Orchestrator (final report)" adımı eksikti, eklendi.
- **P1: Hook minimum stale** — `system-validation.instructions.md` Rule 2 hook minimum 2'ydi, gerçek değer 4'e güncellendi.
- **P2: Agent name sanitization** — `review-enforcer.json` ve `agent-lifecycle.json`'da `$COPILOT_AGENT` counter dosya adında sanitize edilmeden kullanılıyordu (path injection riski). `tr -cd 'A-Za-z0-9_-'` ile sanitize edildi.
- **P2: SubagentError handler** — `review-enforcer.json`'a SubagentError event handler eklendi, crash sonrası stale counter dosyaları temizleniyor.
- **P2: Dead code removal** — `context-guard.json` PostToolUse PCD invalidation kodu hiçbir zaman çalışmayan dead code'du, kaldırıldı.
- **P2: Log rotation** — `agent-lifecycle.json` SubagentStart'ta 1MB log rotation eklendi.
- **P3: Log interleaving** — SubagentStop'ta 2 ayrı echo yerine tek `printf` ile atomic yazma.
- **P3: Counter cleanup** — SubagentStart'ta önceki oturumdaki stale counter dosyaları temizleniyor.
- **P3: x2 agent names** — Orchestrator xN tablosunda x2 satırında agent isimleri eksikti, eklendi.

---

## [6.2.0] — 2026-03-19

### Added

- **Hook: review-enforcer.json** — PostToolUse edit sayacı + SubagentStop review chain yönlendirmesi. Her agent'ın edit sayısını takip eder, görev bittiğinde hangi tier'in review yapması gerektiğini otomatik gösterir.
- **Hook: context-guard.json** — SubagentStart'ta tier bazlı skill/PCD bütçe limitleri gösterimi. Agent'ların context bütçesini aşmasını önler.
- **Agent identity banner** — `agent-lifecycle.json` SubagentStart'ta insan ismi + tier + rol gösterir. Terminal ekranında agent kimliği artık görünür.
- **Active plan detection** — `agent-lifecycle.json` SubagentStart'ta `.github/todo/active-plan.md` varlığını kontrol eder.
- **Session count warning** — `agent-lifecycle.json` session sayısı 20'yi aştığında arşivleme uyarısı verir.
- Hook otomasyon referansları `shared-base.instructions.md`'e eklendi (Review Protocol, Read-Only Agents, Session Awareness).

### Changed

- **Agent dosya ağacında insan isimleri eklendi** — README.md agent dosya listesinde her dosyanın yanına insan ismi ve rol bilgisi eklendi. Dosya isimleri yapısal tanımlayıcı olarak korundu (VS Code Copilot dosya isimlerini agent çağrı ID'si olarak kullanır).
- **Agent identity banner** — `agent-lifecycle.json` SubagentStart hook'u terminalde insan ismi + tier + rol banner'ı gösterir. Dosya ismi değişmeden terminal görünürlüğü sağlandı.
- **safety-guard.json read-only tespiti düzeltildi** — Eski `*analyst*` pattern'i YAML agent isimleriyle (`EmreKilic`, `AyseDemir` vb.) eşleşmiyordu. Artık gerçek YAML isimlerine göre eşleşiyor. 🔴 Kritik güvenlik düzeltmesi.
- `system-validation.instructions.md` Rule 7 agent tablosuna "Display Name" kolonu eklendi.
- README.md agent dosya ağacı insan isimleri ve roller ile zenginleştirildi.
- README.md hook dosya listesi 4 hook'a genişletildi (açıklamalarla).
- USAGE.md'ye v6.2.0 hook otomasyon dokümantasyonu eklendi.
- `shared-base.instructions.md`'e hook otomasyon referansları eklendi (Review Protocol, Read-Only Agents, Session Awareness).

---

## [6.1.0] — 2026-03-19

### Fixed

- **Review Chain Contradiction (P1)**: `tier1-principal` ve `tier1-5-staff-engineer` instruction dosyalarında Major findings handling kuralı `shared-base` ile çelişiyordu. Artık tüm dosyalar tutarlı: "Critical → reviewer düzeltir, Major → task owner düzeltir, round 2 sonrası reviewer devralır"
- **SpotBugs Version Mismatch (P1)**: `pom-quality-plugins.xml.template` SpotBugs versiyonu 4.8.3.0'dan 4.8.6'ya güncellendi (`java-quality-tooling/SKILL.md` ile senkronize)
- **Stale Config Path (P1)**: `pom-quality-plugins.xml.template` içindeki `project-standards/config` yolu `.github/config` olarak düzeltildi (2 lokasyon)
- **ADR-001 Token Overhead (P1)**: `applyTo` broadcast davranışı dokümanı v6.0.0 reference/ migration'ını yansıtacak şekilde güncellendi (~30-40K → ~8-12K auto-load)
- **JaCoCo Exclusion Sync (P1)**: Template ve SKILL arasındaki JaCoCo exclusion listesi uyumsuzluğu giderildi. SKILL kanonik kaynak olarak belirlendi, template senkronize edildi

### Changed

- **Token Overhead Documentation**: `context-loading.instructions.md` ve `task-planning.instructions.md` dosyalarındaki "19 instruction files (~45-55K)" referansları v6.0.0 gerçekliğini yansıtacak şekilde güncellendi ("3 auto-load files (~8-12K)")
- **ServiceResponse vs ApiResponse Belgeleme (P2)**: `api-integration/SKILL.md` ve `backend-development/SKILL.md`'ye iki wrapper arasındaki farkı açıklayan notlar eklendi (ServiceResponse = internal traceId'li, ApiResponse = frontend contract)
- **README Gelişim Skoru Tablosu (P2)**: v5.0.0, v6.0.0 ve v6.1.0 sütunları eklendi. Yeni "Konfigürasyon Tutarlılığı" boyutu eklendi
- **VS Code Settings (P2)**: Mevcut olmayan `.github/prompts/` dizin referansı `settings.json`'dan kaldırıldı
- **AGENTS.md JSDoc Exception (P3)**: Absolute Prohibitions bölümündeki "No comments" kuralına JSDoc/TSDoc public API interface exception notu eklendi
- **Orchestrator Protocol (P3)**: `/architect` bypass davranışı eklendi, x2/x4 edge case dağılımları dağıtım tablosuna eklendi

### Notes

- x10 analiz oturumu ile tespit edilen 15 bulgunun tamamı (5 P1 + 5 P2 + 5 P3) düzeltildi
- Versiyon: README, USAGE, CHANGELOG, PROGRESS tutarlı şekilde v6.1.0'a güncellendi

---

## [6.0.0] — 2026-03-16

### Changed (BREAKING)

- **Agent İsimleri Türkçe İnsan İsimlerine Dönüştürüldü**: Tüm 11 agent dosyası jenerik isimlerden gerçek Türkçe insan isimlerine güncellendi
  - Orchestrator → Varol Maksutoğlu (Teknik Koordinatör)
  - PrincipalAlpha → Taner Yılmaz (Baş Yazılım Mimarı)
  - PrincipalBeta → Oya Kanat (Kıdemli Yazılım Mimarı)
  - StaffEngineerAlpha → Barış Benli (Kıdemli Yazılım Mühendisi)
  - StaffEngineerBeta → Tarık Ziya Yeşilçimen (Yazılım Mühendisi)
  - MidCoderAlpha → Enis Sait Erken (Yazılım Geliştirici)
  - MidCoderBeta → Selin Akar (Yazılım Geliştirici)
  - LeadAnalyst → Canan Birsen (Kıdemli Sistem Analisti)
  - AnalystAlpha → Emre Kılıç (Sistem Analisti)
  - AnalystBeta → Ayşe Demir (Güvenlik ve Performans Analisti)
  - AnalystGamma → Elif Özge Maksutoğlu (Test ve Kalite Analisti)
- **Token Optimizasyonu — Instruction Dosya Yeniden Yapılandırması**: 19 instruction dosyasından 16'sı `.github/instructions/reference/` alt dizinine taşındı
  - Sadece 3 evrensel dosya üst seviyede kaldı: `shared-base`, `clean-code-standards`, `git-safety`
  - `.vscode/settings.json` glob pattern'i `".github/instructions/**/*.instructions.md"` → `".github/instructions/*.instructions.md"` olarak değiştirildi
  - Taşınan dosyalar artık VS Code tarafından otomatik yüklenmez — agent'lar ihtiyaç halinde `reference/` dizininden okur
  - Tahmini tasarruf: ~30-40K token/oturum (%60-70 instruction overhead azaltımı)

### Changed

- **shared-base.instructions.md**: Agent isim referans tablosu yeni Türkçe isimlerle güncellendi
- **system-validation.instructions.md**: Kanonik model tablosu yeni agent display isimleriyle güncellendi
- **agent-performance.md**: Tüm agent isimleri yeni isimlerle güncellendi
- **token-usage.md**: Tüm agent isimleri yeni isimlerle güncellendi
- **AGENTS.md**: Instruction dosya yol referansları `reference/` alt dizinine güncellendi
- **copilot-instructions.md**: Instruction dosya yol referansları `reference/` alt dizinine güncellendi
- **README.md**: v6.0.0 versiyon güncellemesi, dosya yapısı ağacı, instruction yol referansları, skor evrimi tablosu
- **USAGE.md**: v6.0.0 versiyon güncellemesi, tüm agent isim tabloları, instruction yol referansları, FAQ bölümü
- **frontend-development/SKILL.md**: 690 → 490 satıra optimize edildi — tekrarlanan Performance Rules birleştirildi, SEO/a11y birleştirildi, code example'lar kısaltıldı, estimated-tokens 8000 → 6000
- **implementation/SKILL.md**: DRY ihlalleri giderildi — function rules, Result type, error handling clean-code referansına dönüştürüldü, estimated-tokens 3000 → 2500

### Dosya Özeti

**Taşınan (16):**

- `.github/instructions/` → `.github/instructions/reference/` dizinine `git mv` ile taşınan dosyalar:
  - `system-validation.instructions.md`, `delegation-rules.instructions.md`, `review-chain.instructions.md`
  - `context-loading.instructions.md`, `task-planning.instructions.md`, `model-fallback.instructions.md`
  - `session-memory.instructions.md`, `prompt-enrichment.instructions.md`, `project-context-discovery.instructions.md`
  - `slash-commands.instructions.md`, `agent-scaffolding.instructions.md`
  - `tier1-principal.instructions.md`, `tier1-5-staff-engineer.instructions.md`, `tier2-mid.instructions.md`
  - `tier2-5-lead-analyst.instructions.md`, `tier3-analyst.instructions.md`

**Değiştirilen (20):**

- 11 agent dosyası (`.github/agents/*.agent.md`) — isim, başlık, cross-reference güncellemeleri
- `.github/instructions/shared-base.instructions.md` — agent isim referansları
- `.github/instructions/reference/system-validation.instructions.md` — model tablosu
- `.github/metrics/agent-performance.md` — agent isimleri
- `.github/metrics/token-usage.md` — agent isimleri
- `.vscode/settings.json` — glob pattern
- `AGENTS.md`, `README.md`, `USAGE.md`, `.github/copilot-instructions.md` — yol ve versiyon güncellemeleri

### Notes

- Bu sürüm **geriye dönük uyumsuz** (breaking) — agent YAML `name` alanları değiştiği için mevcut session dosyaları ve slash komut referansları güncellenmeli
- Agent dosya isimleri (kebab-case) değişmedi — sadece YAML `name` ve içerik güncellendi
- `reference/` dizinindeki instruction dosyalarının `applyTo: "**"` frontmatter'ı hâlâ mevcut — glob pattern değiştiği için etkisiz, temizlik opsiyonel
- TASK-001 (Platform Context Overhead Azaltımı) bu sürümle büyük ölçüde çözüldü

---

## [5.0.0] — 2026-03-05

### Removed (BREAKING)

- **Proje-Specific Integration Skill Silindi**: Proje bağımsızlık için proje-specific entegrasyon skill'i kaldırıldı
- **Proje-Specific Referanslar Temizlendi**: Tüm agent, instruction ve skill dosyalarından proje-specific referanslar silindi
  - 4 agent dosyası: `principal-alpha`, `principal-beta`, `staff-engineer-alpha`, `staff-engineer-beta` — proje-specific skill satırı kaldırıldı
  - 2 tier instruction dosyası: `tier1-principal`, `tier1-5-staff-engineer` — proje-specific skill satırı kaldırıldı
  - `agent-scaffolding.instructions.md`: T1 ve T1.5 skill tablolarından proje-specific skill kaldırıldı
  - `context-loading.instructions.md`: Java Backend task type'dan proje-specific skill kaldırıldı
  - `delegation-rules.instructions.md`: Proje-specific task type kaldırıldı, Spring Boot task açıklaması genelleştirildi
  - `git-safety.instructions.md`: Proje-specific dosya referansı kaldırıldı
  - `system-validation.instructions.md`: Skill minimum sayısı 14 → 13 güncellendi

### Changed

- **Frontend Development Skill Genelleştirildi**: Proje-specific micro-frontend referansları genel micro-frontend pattern'lere dönüştürüldü
  - Proje-specific micro-frontend standards → genel "micro-frontend standards"
  - Nx Module Federation → genel "Micro-Frontend (Module Federation)"
  - Proje-specific import path → `@shared-ui` (genel referans)
- **PR Standards Genelleştirildi**: Proje-specific örnek referansı kaldırıldı
- **AGENTS.md**: Proje-specific skill zorunlu skill listesinden çıkarıldı
- **README.md**: Proje-specific özellik satırı kaldırıldı, skill sayısı 14 → 13, dosya ağacı ve skor tablosu güncellendi
- **USAGE.md**: Skill tablosundan proje-specific skill satırı kaldırıldı

### Notes

- Bu sürüm boilerplate'i **proje bağımsız** hale getirir — proje-specific tüm bilgiler kaldırılmıştır
- Proje bağlamı bilgileri artık hedef projenin `docs/` dizini altında sağlanmalı ve PCD (Project Context Discovery) ile otomatik keşfedilecektir
- Java/Spring Boot, Backend Security, Java Quality Tooling skill'leri korundu — bunlar genel/evrensel standartlardır
- CHANGELOG'daki tüm proje-specific referanslar temizlendi

### Fixed

- **USAGE.md Token Bütçe Tablosu** (P1): Token aralıkları `task-planning.instructions.md` ile senkronize edildi
- **README.md Versiyon Yörüngesi** (P2): v5.0.0 satırı eklendi, "Son Analiz" v5.0.0 olarak güncellendi
- **USAGE.md FAQ** (P2): `.vscode/settings.json` → `.vscode/` dizini olarak düzeltildi
- **PROGRESS.md Oluşturuldu**: 14 geliştirme görevi ile yol haritası dosyası eklendi

---

## [4.9.0] — 2026-03-02

### Fixed

- **Tier Skill Mapping Tutarsızlığı**: v4.8.0'da eklenen 4 yeni skill'in tier instruction dosyalarına yansıtılması
  - `tier1-principal.instructions.md`: 4 eksik skill eklendi (backend-security, java-quality-tooling, api-integration ve diğerleri)
  - `tier1-5-staff-engineer.instructions.md`: 4 eksik skill eklendi (backend-security, java-quality-tooling, api-integration ve diğerleri)
  - `tier2-mid.instructions.md`: 2 eksik skill eklendi (java-quality-tooling, api-integration)
- **Token Overhead Tutarsızlığı**: Instruction dosya sayısı ve token overhead tahminleri güncellendi
  - `context-loading.instructions.md`: "17 instruction files" → "19 instruction files", token overhead ~40-52K → ~45-55K
  - `task-planning.instructions.md`: Platform overhead ~30-40K → ~45-55K, toplam tüketim tahmini ~45-55K → ~60-70K
- **USAGE.md PEP Kategori Eksikliği**: Kategori 7 "Güvenlik & Uyumluluk" eklendi (v4.7.0'da instruction dosyasına eklenmiş ama USAGE.md'ye yansıtılmamıştı)
- **USAGE.md Setup Talimatı**: `.vscode/settings.json` → `.vscode/` dizini tamamı kopyalanacak şekilde güncellendi (`mcp.json` dahil)
- **USAGE.md Logs Açıklaması**: `.github/logs/` dizininin çalışma zamanında hook'lar tarafından oluşturulduğu açıklaması eklendi
- **README.md Dosya Ağacı**: `.vscode/mcp.json` dosyası eklendi
- **`.github/logs/.gitkeep`**: README'de belgelenen ama repo'da eksik olan dizin ve dosya oluşturuldu

### Analysis Summary

- x10 multi-agent analiz döngüsü: 3 Analyst (paralel) + 1 Lead Analyst (konsolidasyon)
- 9/9 sistem doğrulama kuralı PASS
- 12 bulgu tespit edildi: 3 P1 cross-reference + 4 P1 documentation + 4 P2 + 1 P3
- Tümü düzeltildi

---

## [4.8.0] — 2026-03-02

### Added

- **3 Yeni Skill Dosyası**: `rules/` dizinindeki proje standartları multi-agent sistemine entegre edildi
  - `backend-security/SKILL.md`: Spring Boot güvenlik standartları (SQL injection, XSS, input validation, BCrypt, JWT, rate limiting)
  - `java-quality-tooling/SKILL.md`: Maven kalite araçları (Checkstyle, SpotBugs, JaCoCo, SonarQube konfigürasyonu)
  - `api-integration/SKILL.md`: Frontend-backend entegrasyon kontratı (ApiResponse<T>, pagination, tarih/saat, hata yönetimi, CORS, auth)
- **Git Safety Instructions**: AI agent'ların git operasyonları için zorunlu onay mekanizması (`git-safety.instructions.md`)
- **Config Dosyaları**: `.github/config/` dizinine Checkstyle, SpotBugs ve Maven kalite plugin şablonları eklendi
- **Java Backend Task Type**: `context-loading.instructions.md`'ye yeni görev tipi eklendi
- **6 Yeni Task Type**: `delegation-rules.instructions.md`'ye Spring Boot görev tipleri eklendi

### Changed

- Versiyon: v4.7.0 → v4.8.0 (README, USAGE, CHANGELOG)
- `backend-development/SKILL.md`: Node.js-only → Dual-stack (Node.js + Java/Spring Boot) — Constructor injection, layered architecture, ServiceResponse<T>, GlobalExceptionHandler, retry/circuit breaker eklendi
- `frontend-development/SKILL.md`: 4 çakışma çözüldü (form standard → React Hook Form + Yup, component max → 300 satır, interface > type, flat feature folders) + micro-frontend kuralları, rem() auto-import, Zustand store naming, BEM prefixes eklendi
- `testing-standards/SKILL.md`: Java/JUnit backend testing section genişletildi — AssertJ, BDDMockito, parameterized tests, integration test patterns, test data builders, F.I.R.S.T. principles eklendi
- `context-loading.instructions.md`: Java Backend task type + api-integration skill eklendi
- `system-validation.instructions.md`: Skill minimum 8→14, instruction minimum 17→19
- `delegation-rules.instructions.md`: 6 yeni Spring Boot task type eklendi
- `agent-scaffolding.instructions.md`: Skills by Tier tablosu güncellendi (4 yeni skill)
- 7 agent dosyası güncellendi: Principal (×2), Staff Engineer (×2), MidCoder (×2) skill referansları güncellendi

### Removed

- `rules/` dizini kaldırıldı — tüm içerik `.github/skills/`, `.github/instructions/` ve `.github/config/` olarak entegre edildi

### Conflict Resolutions

- **Form Standard**: React Hook Form + Yup (proje kuralı) > Ant Design Form (boilerplate varsayılanı)
- **Component Max Lines**: 300 satır (proje kuralı) > 250 satır (boilerplate varsayılanı)
- **Interface vs Type**: `interface` for object shapes (proje kuralı) > `type` preferred (boilerplate varsayılanı)
- **Feature Folders**: Flat structure (proje kuralı) > Type-based sub-folders (boilerplate varsayılanı)

---

## [4.7.0] — 2026-02-26

### Added

- **Prompt Enrichment Protocol (PEP)**: Yeni sistem kuralı — non-trivial geliştirme görevlerinde Orchestrator otomatik olarak hedefli sorular sorar, gereksinimleri netleştirir ve detaylı implementasyon planı oluşturur
  - Yeni instruction dosyası: `prompt-enrichment.instructions.md`
  - 6 soru kategorisi: Kapsam, Davranış, Teknik, UI/UX, Test, Proje Bağlam Uyumu
  - Skip koşulları: Trivial görevler, `/resume`, kullanıcı override
  - Orchestrator Step 1.5 olarak entegre edildi
  - Onay kapısı: Plan kullanıcı onayı olmadan implementasyona geçilmez (max 2 revizyon turu)
- **System Validation Rule 9**: PEP instruction dosyasının varlığı ve gerekli bölümlerinin kontrolü

### Changed

- Versiyon: v4.6.0 → v4.7.0 (README, USAGE, CHANGELOG)
- `copilot-instructions.md`: PEP operating rule eklendi (Kural 7)
- `shared-base.instructions.md`: Universal Working Principles'a PEP eklendi
- `orchestrator.agent.md`: Step 1.5 olarak PEP süreci eklendi
- `AGENTS.md`: Prompt Enrichment Protocol bölümü eklendi
- `context-loading.instructions.md`: Instruction sayısı 16→17, token overhead 38-50K→40-52K
- `task-planning.instructions.md`: PEP token estimation satırı eklendi (1K-3K)
- `system-validation.instructions.md`: Rule 9 eklendi, minimum instruction sayısı 16→17, rapor formatı 8/8→9/9, validation trigger'a PEP değişiklikleri eklendi, "8 rules"→"9 rules"
- USAGE.md: PEP bölümü, içindekiler (18 entry), araçlar (9 rules), SSS güncellendi
- README.md: PEP feature, dosya yapısı, özelleştirme, skor evrimi güncellendi

### Fixed (v4.7.0 Analiz Bulguları)

- **CF-01** (P0): PEP — Default behavior tanımlandı: skip durumunda en konservatif yorumlama (en küçük kapsam, PCD uyumlu basit pattern)
- **CF-02** (P0): PEP — Cevaplanmayan soru edge case'leri eklendi (timeout, terk etme, partial answer handling)
- **CF-03** (P0): PEP — Plan task breakdown ↔ Orchestrator Step 3 yetki ilişkisi netleştirildi (PEP planı authoritative input)
- **CF-04** (P1): PEP — Security & Compliance soru kategorisi eklendi (Category 7)
- **CF-05** (P1): PEP — Partial answer stratejisi tanımlandı (varsayımlar plan'da işaretlenir)
- **CF-06** (P1): PEP — Dil politikası notu eklendi (template'ler English, kullanıcıya sunumda Language Policy geçerli)
- **CF-07** (P1): PEP — Trivial→complex escalation re-entry mekanizması eklendi
- **CF-08** (P1): PEP — Agent atamalarının preliminary olduğu, final atamanın Step 2/3'te yapıldığı netleştirildi
- **CF-09** (P1): PEP — Token tahmini 1K-3K → 1K-5K olarak güncellendi (🟢→🟡 confidence)
- **CF-10** (P1): PEP — PEP token overhead'ının 15K subtask bütçesinden bağımsız olduğu belirtildi
- **CF-11** (P2): PEP — Lead Analyst (T2.5) Agent Responsibilities'e eklendi
- **CF-12** (P2): PEP — Single-agent mode'da da uygulandığı açıkça belirtildi
- **CF-13** (P2): PEP — PCD→PEP veri akışı güçlendirildi (Step 1'e PCD context, Category 6'ya PCD referansı)
- **CF-14** (P2): PEP — ~30% improvement iddiası "estimated, calibration'a tabi" olarak nitelendirildi

---

## [4.6.0] — 2026-02-26

### Added

- **Project Context Discovery (PCD)**: Yeni sistem kuralı — boilerplate herhangi bir projeye taşındığında, hedef projenin `README.md`, kök dizinindeki `.md` dosyaları ve `docs/` klasörü otomatik olarak taranır ve sistem bağlamı olarak kullanılır
  - Yeni instruction dosyası: `project-context-discovery.instructions.md`
  - Öncelik hiyerarşisi: Boilerplate yapısal kuralları > Proje-spesifik kurallar > Boilerplate kodlama varsayılanları
  - Tier bazlı PCD bağlam bütçesi (T1: 5 dosya/8K token, T3: 2 dosya/3K token)
  - Orchestrator Step 0'a PCD tarama adımı eklendi
- **System Validation Rule 8**: PCD instruction dosyasının varlığı ve gerekli bölümlerinin kontrolü

### Changed

- Versiyon: v4.5.0 → v4.6.0 (README, USAGE, CHANGELOG)
- `copilot-instructions.md`: PCD operating rule eklendi (Kural 6)
- `shared-base.instructions.md`: Universal Working Principles'a PCD eklendi
- `context-loading.instructions.md`: Progressive Loading Strategy'ye PCD adımı, PCD Context Budget tablosu ve kanonik kaynak referansı eklendi; instruction sayısı 15→16, token overhead 35-47K→38-50K
- `orchestrator.agent.md`: Step 0 PCD tarama protokolü ve task assignment PCD alanları eklendi
- `AGENTS.md`: Project Context Discovery bölümü eklendi
- `system-validation.instructions.md`: Rule 8 eklendi, minimum instruction sayısı 14→16, rapor formatı 7/7→8/8, validation trigger'a PCD değişiklikleri eklendi, "7 rules"→"8 rules" düzeltildi
- USAGE.md: PCD bölümü, içindekiler, araçlar, PCD yapılandırması ve SSS güncellendi
- README.md: PCD feature, dosya yapısı, özelleştirme bölümü ve skor evrimi güncellendi

### Fixed (v4.6.0 Analiz Bulguları)

- **CF-01** (P0): PCD — README.md yoksa edge case eklendi, eksik kaynak graceful degradation
- **CF-02** (P1): system-validation.instructions.md — "run all 7 rules" → "run all 8 rules"
- **CF-03** (P1): PCD — docs/ klasörü yoksa davranış tanımlandı, max 3 seviye derinlik limiti
- **CF-04** (P1): PCD — Proje dokümanları arası çakışma çözüm kuralları eklendi (intra-project conflict)
- **CF-05** (P1): PCD — Yapısal vs kodlama kuralı sınırı netleştirildi (structural vs coding boundary)
- **CF-06** (P1): PCD — Bütçe ilişkisi netleştirildi (within, not additive) ve kanonik kaynak atandı
- **CF-07** (P1): Orchestrator task assignment — PCD context alanları eklendi
- **CF-08** (P2): PCD — Cache invalidation mekanizması eklendi
- **CF-09** (P2): system-validation — "When to Validate" trigger'a PCD dosya değişiklikleri eklendi

---

## [4.5.0] — 2026-02-25

### Removed

- **scripts/validate-system.sh**: Bash linter kaldırıldı — kurumsal ortamlarda güvenlik kısıtlamalarına takılabiliyordu
- **scripts/create-agent.sh**: Bash scaffold generator kaldırıldı — aynı güvenlik endişesi
- **scripts/ dizini**: Tamamen kaldırıldı

### Added

- **system-validation.instructions.md**: Linter'ın 7 kontrolünü declarative kurallar olarak yeniden tanımladı — agent'lar read/search araçlarıyla manuel doğrulama yapar
- **agent-scaffolding.instructions.md**: Scaffold generator'ı tier konfigürasyon matrisi, şablonlar ve post-creation checklist olarak yeniden tanımladı

### Changed

- Versiyon: v4.4.0 → v4.5.0 (README, USAGE, CHANGELOG)
- README dosya ağacından `scripts/` kaldırıldı, yeni instruction dosyaları eklendi
- USAGE Araçlar bölümü instruction-tabanlı yaklaşıma güncellendi
- USAGE Özelleştirme bölümünden script referansları kaldırılıp instruction rehberine yönlendirildi

### Fixed (Post-Migration Residuals)

- **CF-01** (P1): context-loading.instructions.md — instruction sayısı 13→15, token overhead 30-40K→35-47K
- **CF-02** (P2): system-validation.instructions.md — minimum instruction threshold 10→14
- **CF-03** (P3): system-validation.instructions.md — provenance referansı geçmiş zamana çevrildi
- **CF-04** (P3): agent-scaffolding.instructions.md — provenance referansı geçmiş zamana çevrildi
- **CF-05** (P3): system-validation.instructions.md — Rule 4 code fence kontrolüne regex pattern eklendi

---

## [4.4.0] — 2026-02-24

### Fixed — v4.3.0 Analiz Bulguları (8. Döngü)

#### 🔴 P0 Düzeltmeleri

- **CF-01**: Orchestrator "Never edit" / "Update" çelişkisi çözüldü — Session End Protocol `agent` tool üzerinden delegasyon modeline geçirildi (`orchestrator.agent.md`)

#### 🟠 P1 Düzeltmeleri

- **CF-02 + CF-03**: Context-loading tablosu tamamen yeniden yapılandırıldı — tüm 7 satır 10/10 skill sınıflandırması; `commit-standards` ve `pr-standards` "Phase-Loaded" kategorisine taşındı, skill budget aşımı çözüldü (`context-loading.instructions.md`)
- **CF-04**: README fix sayısı düzeltildi — "9 fix (3 P1 + 6 P2)" → "8 fix (3 P1 + 5 P2)" (`README.md`)

#### 🟡 P2 Düzeltmeleri

- **CF-05**: x4 review chain düzeltildi — T3→T2 yerine T3→T1.5 (daha yüksek tier), chain integrity kuralına reduced-mode istisnası eklendi (`review-chain.instructions.md`)
- **CF-06**: Lead Analyst aşağı yönlü eskalasyonu düzeltildi — "MidCoder veya Staff Engineer" → "Staff Engineer veya Principal" (`lead-analyst.agent.md`, `tier2-5-lead-analyst.instructions.md`)
- **CF-07**: MidCoderBeta aktivasyon modu düzeltildi — "x5+ modunda aktif" → "x10 modunda aktif" (`USAGE.md`)
- **CF-08**: Linter açıklamasına 7. kontrol eklendi — model tutarlılığı (`USAGE.md`)
- **CF-09**: SKILL.md Usage bölümleri frontmatter ile hizalandı — `analysis/SKILL.md` T2.5 eklendi, `implementation/SKILL.md` T1 eklendi
- **CF-10**: Clean-code skill tablosuna T2.5 (awareness) notu eklendi (`USAGE.md`, `README.md`)
- **CF-11**: Boundary max formüllerine `round()` eklendi (`delegation-rules.instructions.md`)
- **CF-12**: MidCoderBeta Working Principles'a File Ownership eklendi (`mid-coder-beta.agent.md`)

#### 🟢 P3 Düzeltmeleri

- **CF-13**: Feedback loop diyagramına Orchestrator mediation eklendi (`review-chain.instructions.md`)
- **CF-14**: x2 modunda Principal→Analyst review kriterleri eklendi (`review-chain.instructions.md`)
- **CF-15**: Linter sed fallback'e best-effort notu eklendi (`validate-system.sh`)
- **CF-16**: `refaktor-v4.0.0.md` README dosya ağacına eklendi (`README.md`)

### Changed

- Versiyon: v4.3.0 → v4.4.0 (README, USAGE, CHANGELOG)
- Context-loading tablosu 3 sütunlu yapıya geçti (Required / Skip / Phase-Loaded†)
- x4 review chain: `T3→T2→T1.5→T1` → `T3→T1.5, T2→T1.5→T1`
- README skor tablosu sadeleştirildi — sadece son 3 production-ready sürüm gösteriliyor

### Fixed — Post-Review Residuals

- **R-1**: x4 delegation-rules açıklaması review-chain ile hizalandı — "MidCoder for review" → "Staff Engineer" (`delegation-rules.instructions.md`)
- **R-2**: shared-base "Mandatory" ibaresi Phase-Loaded ile uyumlu hale getirildi — commit-standards'a "(loaded during commit/PR phase)" eklendi (`shared-base.instructions.md`)

---

## [4.3.0] — 2026-02-24

### Fixed — v4.2.0 Analiz Bulguları (6. Döngü)

#### 🟠 P1 Düzeltmeleri

- **CF-01**: 4 SKILL.md dosyasında tier açıklaması düzeltildi — `implementation` ve `testing-standards` → T1 (Principal) eklendi; `analysis` → T2.5 (Lead Analyst) eklendi; `clean-code` → T2.5 awareness notu eklendi
- **CF-02**: `agent-performance.md` maliyet dağılımı %100'e düzeltildi (Notes sütunu ve methodology açıklaması eklendi)
- **CF-03**: Safety-guard hook'ta dead code düzeltildi — `grep -oE '(analyst|lead-analyst)'` yerine `case $LOWER_NAME in *analyst*)` pattern matching kullanıldı (hyphen sorunu ortadan kalktı)

#### 🟡 P2 Düzeltmeleri

- **CF-06**: Linter xN exclusion filtresi güçlendirildi — `grep -vE` pattern'ine `edge.case`, `Edge Case`, `diminishing`, markdown heading exclusion eklendi
- **CF-07**: Linter model consistency check'te substring match → exact match (copilot suffix strip sonrası birebir karşılaştırma); pipe-delimited parsing ile boşluklu model adları düzgün parse edilir
- **CF-08**: Scaffold post-creation checklist'e 5. madde eklendi — T1 (Principal) agent'ları için `agents: [...]` YAML alanının doldurulması hatırlatması
- **CF-09**: Context-loading Architecture satırı tamamlandı — tüm 10 skill Required veya Skip sütunlarından birine atandı
- **CF-10**: Delegation-rules canonical source note güncellendi — x2 ve x4 fixed distribution'ları da kapsama alındı

### Changed

- README.md: v4.3.0 bump, skor tablosu güncellendi
- USAGE.md: v4.3.0 bump
- Linter model expected list: `Gemini 3.1 Pro (Preview)` / `Gemini 3.0 Pro (Preview)` tam model adları eklendi
- Linter delimiter: boşluk (` `) → pipe (`|`) — model adlarındaki boşluk parsing sorununu çözdü

---

## [4.2.0] — 2026-02-24

### Fixed — v4.1.1 Analiz Bulguları (5. Döngü)

#### 🔴 Hook Case-Sensitivity Düzeltmesi

- `safety-guard.json`: T2.5/T3 edit-audit-logging hook'undaki `grep` PascalCase agent isimlerini (`AnalystAlpha`, `LeadAnalyst`) yakalayamıyordu. `tr '[:upper:]' '[:lower:]'` eklenerek case-insensitive eşleşme sağlandı.

#### 🟠 Scaffold Tool Vocabulary Harmonizasyonu

- `create-agent.sh`: `render_tools_yaml()` ve `render_tool_descriptions()` verbose tool isimlerinden (`codebase`, `edit_file`, `read_file`, `insert_edit_into_file`) mevcut 11 agent dosyasıyla uyumlu abstract formata (`edit`, `search`, `read`, `fetch`, `agent`) geçirildi.

#### 🟠 Scaffold Model Name Format Düzeltmesi

- `create-agent.sh`: `resolve_default_model()` ve `resolve_fallback_model()` kebab-case slug'lardan (`claude-opus-4.6`) mevcut agent YAML formatına (`Claude Opus 4.6 (copilot)`) geçirildi.

#### 🟠 Skill Tier Mapping Düzeltmeleri

- `USAGE.md`: Backend Development "Tier 1.5 & 2" → "Tier 1, 1.5 & 2", Implementation "Tier 1.5 & 2" → "Tier 1, 1.5 & 2".
- `README.md`: Dosya ağacı skill yorumları düzeltildi — implementation, pr-standards, testing-standards tümü "T1, T1.5, T2" olarak güncellendi.

#### 🟡 Review Emoji Tutarlılığı

- `code-review/SKILL.md`: Suggestion seviyesi emojisi 🟦 → 🔵 olarak düzeltildi (shared-base ve review-chain ile uyumlu).

#### 🟡 Metrik Senkronizasyonu

- `agent-performance.md`: PLAN-001 session verileriyle güncellendi — 6 agent görevi, maliyet dağılımı ve review verimliliği.
- `token-usage.md`: +33% sapma uyarıları eklendi (AnalystAlpha ve AnalystGamma).

#### 🟡 Linter İyileştirmeleri

- `validate-system.sh`: Yasaklı xN regex'i `x1[2-9]` → `x1[1-9]` düzeltildi (x11 artık yakalanıyor).
- `validate-system.sh`: Kullanılmayan `has_failure` değişkeni kaldırıldı.

#### 🟡 CHANGELOG Doğruluk Düzeltmesi

- v4.1.1 "Hook Edit-Blocking" → "Hook Edit-Audit-Logging" olarak yeniden adlandırıldı (mekanizma uyarı loglar, engellemez).

### Added — 10.0 Hedefli İyileştirmeler

#### 🆕 Budget Exceeded Protocol

- `context-loading.instructions.md`: Context budget aşıldığında 3 adımlı protokol eklendi (STOP → Report → Orchestrator reassign).

#### 🆕 Git Tracking Model Dokümantasyonu

- `session-memory.instructions.md`: Hangi artifact'ların git-tracked olduğunu gösteren tablo eklendi (active-plan ✅, session files ❌).

#### 🆕 Mandatory Skills Netleştirmesi

- `clean-code-standards.instructions.md`: "Always Mandatory" (clean-code) ve "Conditionally Mandatory" (frontend-development) olarak ayrıldı.

### Changed — Dokümantasyon Güncellemeleri

- `README.md`: v4.1.1 → v4.2.0 versiyon güncellemesi.
- `README.md`: Maliyet tablosuna Claude Sonnet 4.6 ve Gemini 3.1 Pro (Preview) satırları eklendi.
- `README.md`: Dosya ağacına `.gitignore` eklendi.
- `README.md`: Skor evrimi tablosuna v4.1.1 ve v4.2.0 satırları eklendi.
- `USAGE.md`: v4.1.1 → v4.2.0 versiyon güncellemesi.

## [4.1.1] — 2026-02-24

### Fixed — v4.1.0 Analiz Bulguları

#### 🔴 CF-01: Scaffold Model Hatası

- `scripts/create-agent.sh`: T2.5 birincil model `gemini-3-pro-preview` → `gemini-3.1-pro-preview`, fallback `gemini-3-pro-preview` → `gemini-3.0-pro-preview` düzeltildi.

#### 🟠 CF-02: USAGE.md İçindekiler Eksikleri

- USAGE.md ToC'ye 5 eksik madde eklendi: Model Fallback, Session Memory, Çakışma Önleme Mekanizması, Metrik Toplama Sistemi, Token Optimizasyonu.

#### 🟠 CF-03 + CF-05: README Dosya Ağacı Eksikleri

- README.md Dosya Yapısı ağacına `scripts/` dizini (create-agent.sh, validate-system.sh), `.github/docs/adr/` (ADR-001) ve `LICENSE` dosyası eklendi.

#### 🟡 CF-04: Model İsim Uyumsuzluğu

- `.github/copilot-instructions.md`: Gemini model isimlerine "(Preview)" soneki eklendi.

#### 🟡 CF-06: Linter Dosya Sayısı Kontrolü

- `scripts/validate-system.sh`: `check_file_counts()` fonksiyonu `info()` yerine minimum eşik değerli `pass()`/`fail()` kullanacak şekilde güncellendi (agents≥8, instructions≥10, skills≥8, hooks≥2).

#### 🟡 CF-07: Session Memory Hook Referansı

- USAGE.md Session Memory bölümüne v4.1.0 hook-based SubagentStop auto-save açıklaması eklendi.

### Added — Skor İyileştirme Geliştirmeleri

#### 🆕 Model Tutarlılık Kontrolü

- `scripts/validate-system.sh`: Yeni `check_model_consistency()` fonksiyonu — agent YAML model/modelFallback değerlerinin kanonik tabloyla uyumluluğunu doğrular.
- Toplam linter kontrol sayısı: 6 → 7.

#### 🆕 Scaffold Post-Creation Checklist

- `scripts/create-agent.sh`: Scaffold sonrası 4 maddelik checklist çıktısı — orchestrator güncellemesi, AGENTS.md, delegation-rules, linter çalıştırma hatırlatması.

#### 🆕 Hook Edit-Audit-Logging (Defense-in-Depth)

- `safety-guard.json`: PreToolUse edit hook'u T2.5/T3 agent'lar için uyarı loglayan savunma katmanı eklendi. Agent ismi "analyst" veya "lead-analyst" içeriyorsa `[SAFETY-BLOCKED]` logu yazılır.

#### 🆕 Token Budget Scope Açıklaması

- `task-planning.instructions.md`: "Budget Scope Clarification" bölümü eklendi — 15K bütçenin çalışma token'ı olduğu, ~30-40K platform overhead'inin hariç tutulduğu belgelendi.

#### 🆕 İlk Kalibrasyon Verisi

- `.github/metrics/token-usage.md`: v4.1.0 analiz döngüsünden 6 baseline kalibrasyon kaydı eklendi.

### Changed — Dokümantasyon Güncellemeleri

- `README.md`: v4.1.0 → v4.1.1 versiyon güncellemesi.
- `README.md`: Skor evrimi tablosuna v4.1.0 ve v4.1.1 satırları eklendi.
- `USAGE.md`: v4.1.0 → v4.1.1 versiyon güncellemesi.

## [4.1.0] — 2026-02-24

### Added — Yol Haritası Öğeleri (9.5/10 Hedefi)

#### 🆕 Scaffold Generator Script

- `scripts/create-agent.sh`: Yeni agent ve instruction dosyalarını otomatik oluşturan scaffold generator eklendi.
- Tier bazlı şablonlar: t1, t1.5, t2, t2.5, t3 için model, fallback, tool seti ve skill listesi otomatik atanır.
- Kebab-case adlandırma zorunluluğu ve mevcut dosya kontrolü dahil.

#### 🆕 Sistem Doğrulama Linter'ı

- `scripts/validate-system.sh`: Boilerplate bütünlüğünü doğrulayan self-check linter eklendi.
- 6 kontrol kategorisi: versiyon tutarlılığı, dosya sayıları, yasak referanslar, code fence kontrolü, Unicode doğrulama, hook paritesi.
- macOS uyumlu (GNU-spesifik flag kullanılmaz).

#### 🆕 Platform Sınırları ADR

- `.github/docs/adr/ADR-001-platform-boundary.md`: VS Code + GitHub Copilot platform bağımlılığı ve mimari kısıtlamaları belgeleyen Architecture Decision Record eklendi.
- 5 karar (D-1 → D-5): Platform kilidi, applyTo kısıtlaması, dosya sahipliği konvansiyonu, token bütçesi, model fallback.
- 5 risk (R-1 → R-5): Değerlendirilmiş riskler ve mitigasyon stratejileri.

#### 🆕 Hook-Based Session Auto-Save

- `agent-lifecycle.json` SubagentStop event'ine session marker step eklendi.
- Agent durduğunda otomatik olarak `.github/logs/agent-activity.log` dosyasına session referansı yazılır.
- R-4 riski (Orchestrator disiplinine bağımlı session kaybı) azaltıldı.

#### 📊 Skor Evrimi Takibi

- `README.md`'ye "Skor Evrimi & Kalite Takibi" bölümü eklendi — versiyon yörüngesi, boyut detayları ve analiz metodolojisi.
- Bu bölüm her analiz döngüsü sonrasında güncellenecek canlı bir referanstır.

### Changed — Dokümantasyon Güncellemeleri

- `README.md`: v4.0.1 → v4.1.0 versiyon güncellemesi.
- `USAGE.md`: v4.0.1 → v4.1.0, "Araçlar" bölümü eklendi (scaffold generator, linter, ADR referansı).
- `USAGE.md`: "Özelleştirme → Yeni Agent Ekleme" bölümü scaffold script kullanımıyla güncellendi.
- `USAGE.md`: İçindekiler tablosuna "Araçlar" maddesi eklendi.

---

## [4.0.1] — 2026-02-24

### Fixed — Dokümantasyon Tutarlılığı (%100 Hedefi)

#### 🔴 P0 — Delegation Cap Çelişkisi (CF-03)

- `delegation-rules.instructions.md`: x12/x15 satırları dağılım örnekleri tablosundan kaldırıldı (N>10 cap ile çelişiyordu).
- `delegation-rules.instructions.md`: Dinamik dağılım örneği `x12` → `x8` olarak güncellendi.
- `USAGE.md` L216: Dinamik dağılım örneği `x12` → `x8` olarak güncellendi.
- `USAGE.md` SSS: "Herhangi bir pozitif tam sayı" → "Maksimum x10" olarak düzeltildi.

#### 🟠 P1 — Kritik Tutarlılık Düzeltmeleri

- **CF-11**: `delegation-rules.instructions.md` x4 edge case satırına canonical not eklendi (formül farklı sonuç üretir; tablo kazanır).
- **CF-02**: `README.md` versiyon v3.1.0 → v4.0.1 olarak güncellendi.
- **CF-02**: `USAGE.md` versiyon v3.1.0 → v4.0.1, tarih 2026-02-24 olarak güncellendi.
- **CF-05**: `AGENTS.md` L122 ve L139'daki bozuk Unicode emoji karakterleri (`�`) düzeltildi (🔒 ve 🔄).
- **CF-01**: `CHANGELOG.md` v4.0.0 tarihi 2025-07-24 → 2026-02-24 olarak düzeltildi (zaman çizelgesi tutarlılığı).

#### 🟡 P2 — İyileştirmeler

- **CF-06**: 4 skill dosyasında 4-backtick code fence kapanışları 3-backtick'e düzeltildi (`clean-code`, `frontend-development`, `pr-standards`, `testing-standards`).
- **CF-09**: `safety-guard.json` PostToolUse hook'una `edit_notebook_file` eklendi (PreToolUse ile parite).
- **CF-07**: `principal-alpha.agent.md` ve `principal-beta.agent.md` skill listelerine `implementation` ve `testing-standards` eklendi (instruction dosyalarıyla eşleşme).
- **CF-08**: `mid-coder-alpha.agent.md` ve `mid-coder-beta.agent.md` skill listelerine `pr-standards` eklendi.
- **CF-10**: `principal-beta.agent.md`, `staff-engineer-beta.agent.md`, `mid-coder-beta.agent.md` dosyalarına File Ownership kuralı eklendi (Alpha varyantlarıyla tutarlılık).
- **CF-04**: `USAGE.md` skill tier mapping tablosu güncellendi — Frontend Development'a T1, PR Standards'a T2, Testing Standards'a T1 eklendi.
- **CF-12**: Root dizindeki `.DS_Store` dosyası silindi.

---

## [4.0.0] — 2026-02-24

### Fixed — Kritik Hata Düzeltmeleri (P0)

#### 🔴 T3 Analyst Review Zinciri Hatası

- `tier3-analyst.instructions.md` satır 34: "MidCoder" referansı "Lead Analyst (Tier 2.5)" olarak düzeltildi.
- T3 çıktıları artık doğru şekilde T2.5 Lead Analyst tarafından incelenecek şekilde belgelendi.

#### 🔴 Hook Sistemi İyileştirmesi

- `agent-lifecycle.json`: Agent adı (`COPILOT_AGENT` değişkeni) log kayıtlarına eklendi.
- `agent-lifecycle.json`: `SubagentError` olay işleyicisi eklendi — hata durumları artık loglanıyor.
- `safety-guard.json`: Terminal ve edit operasyonlarına agent kimlik bilgisi eklendi.
- `safety-guard.json`: `PostToolUse` hook'u eklendi — düzenleme sonrası doğrulama loglaması.
- Tüm log kayıtları artık hangi agent'ın işlemi yaptığını gösteriyor (x10 modunda kritik).

#### 🔴 applyTo Kısıtlaması Belgelendi

- `context-loading.instructions.md`: `applyTo: "**"` platformu kısıtlaması belgelendi.
- Token overhead'i, etkisi ve azaltma stratejileri açıklandı.
- Orchestrator'ın görev başına skill belirlemesi zorunlu çözüm olarak vurgulandı.

### Fixed — Önemli Düzeltmeler (P1)

#### ⚠️ Skill Listesi ve Context Budget Uyumsuzluğu

- `tier1-principal.instructions.md`: Skill listesi 4'ten 9'a genişletildi (tam capability map).
- `tier2-mid.instructions.md`: Skill listesi 3'ten 8'e genişletildi (tam capability map).
- `tier1-5-staff-engineer.instructions.md`: Mevcut 8 skill listesine "Capability Map" başlığı eklendi.
- Tüm tier dosyalarına "Per task, load only the subset specified by the Orchestrator" notu eklendi.
- Capability Map (tüm yetenekler) ile Load List (görev başına yüklenen) ayrımı netleştirildi.

#### ⚠️ x7 Formül-Tablo Uyumsuzluğu

- `delegation-rules.instructions.md`: Sabit dağılım tablosuna "Canonical Source" notu eklendi.
- Formül sadece x3/x5/x7/x10 dışındaki değerler için geçerli — tablo her zaman öncelikli.

#### ⚠️ x3/x4 Review Zinciri Boşluğu

- `review-chain.instructions.md`: "Reduced Mode Review Rules" bölümü eklendi.
- x2 modu: T3 → T1 → Orchestrator.
- x3 modu: T3 → T1.5 → T1 → Orchestrator.
- x4 modu: T3 → T2 → T1.5 → T1 → Orchestrator.
- Genel kural: Bir reviewer tier'ı yapılandırmada yoksa, bir üst tier sorumluluğu devralır.

#### ⚠️ x10+ Agent Limiti

- `delegation-rules.instructions.md`: N>15 limiti N>10 olarak güncellendi.
- Mevcut agent tanımları maksimum 10 agent destekliyor (2P + 2SE + 2MC + 1LA + 3A).
- N>10 için ek `.agent.md` dosyaları oluşturulması gerektiği belgelendi.

#### ⚠️ İçerik Tekrarı Azaltma

- `AGENTS.md`: Review chain ve Model Fallback bölümlerine "Authoritative Source" işaretçileri eklendi.
- Diğer instruction dosyaları bu canonical kaynaklara referans veriyor.

#### ⚠️ refaktor.md Taşıma

- `refaktor.md` repo kökünden `.github/memory/history/refaktor-v4.0.0.md` konumuna taşındı.
- Tamamlanmış planlama artefaktı olarak arşivlendi.

### Fixed — İyileştirmeler (P2)

#### 🔵 /architect Bypass Belgeleme

- `architect.prompt.md`: Orchestrator bypass'ının kasıtlı bir tasarım kararı olduğu belgelendi.
- Tek agent mimari çalışmaları için Orchestrator overhead'inin gereksiz olduğu açıklandı.

#### 🔵 Skill YAML Frontmatter Standardizasyonu

- 5 skill dosyasından (`clean-code`, `commit-standards`, `frontend-development`, `pr-standards`, `testing-standards`) ` ```skill` / ` ````skill` fence'leri kaldırıldı.
- Tüm 10 skill dosyası artık standart `---` YAML frontmatter formatını kullanıyor.
- Trailing boş code fence artefaktları temizlendi.

#### 🔵 Context Loading Architecture Task Type

- `context-loading.instructions.md`: Architecture görev tipine `backend-development` skill'i eklendi.

---

## [3.1.0] — 2026-02-22

### Added — Derinlemesine Analiz İyileştirmeleri

Derinlemesine yapı analizi sonucunda tespit edilen 7 iyileştirme önerisi uygulandı.

#### 📊 Token Ölçümü Kalibrasyonu

- `task-planning.instructions.md` dosyasına `Confidence` kolonu ve Backend API/DB satırları eklendi.
- Token kalibrasyon protokolü ve proje boyutu çarpanları (1.0x, 1.3x, 1.6x) eklendi.
- Gerçek token tüketimini takip etmek için `.github/metrics/token-usage.md` dosyası oluşturuldu.

#### 🪝 Hook Genişletme (Edit Log)

- `safety-guard.json` dosyasına `insert_edit`, `replace_string_in_file` ve `create_file` araçları için ikinci bir `PreToolUse` hook'u eklendi.
- Dosya düzenleme işlemleri artık `agent-activity.log` dosyasına kaydediliyor.

#### 💾 Session Arşivleme Otomasyonu

- `session-memory.instructions.md` dosyasına otomatik arşivleme protokolü eklendi.
- Session sayısı 20'yi aştığında en eski session'ların otomatik olarak `archive.md` dosyasına özetlenmesi sağlandı.
- Orchestrator'ın Session End protokolüne arşivleme kontrolü eklendi.

#### ⚖️ xN Dinamik Dağılım Doğrulama

- `delegation-rules.instructions.md` dosyasına dinamik dağılım için sınır kısıtlamaları (Boundary Constraints) eklendi.
- Uç durumlar (Edge Case Handling) ve doğrulama formülü (Validation Formula) eklendi.

#### 🛠️ Backend Skill Oluşturma

- `.github/skills/backend-development/SKILL.md` dosyası oluşturuldu.
- REST API tasarımı, veritabanı pattern'leri, JWT auth, middleware mimarisi ve error handling standartları eklendi.
- `context-loading.instructions.md` dosyasına Backend API görev tipi eklendi.

#### 🔒 Çakışma Önleme Mekanizması

- `shared-base.instructions.md` dosyasına dosya sahipliği (File Ownership) ve çakışma önleme kuralları eklendi.
- Orchestrator'ın görev dağıtımı sırasında dosya sahipliğini açıkça belirtmesi zorunlu kılındı.

#### 📈 Metrik Toplama Sistemi

- Agent performansını takip etmek için `.github/metrics/agent-performance.md` dosyası oluşturuldu.
- Orchestrator'ın Session End protokolüne metrik güncelleme adımları eklendi.

### Changed

- **Lisans Değişikliği**: Proje lisansı MIT'den GNU GPL v3'e değiştirildi. `LICENSE` dosyası güncellendi ve `README.md`'deki lisans badge'i değiştirildi.
- **Dokümantasyon Güncellemeleri**: `AGENTS.md`, `README.md` ve `USAGE.md` dosyaları yeni özellikler (metrikler, çakışma önleme, backend skill) ve lisans değişikliği ile güncellendi.

---

## [3.0.1] — 2026-02-22

### Fixed — Analiz Bulguları Düzeltmeleri

Derinlemesine yapı analizi sonucunda tespit edilen 14 bulgu düzeltildi.

#### P0 Kritik Düzeltmeler

- **C-1**: `AGENTS.md` — "inline comments" ifadesi kaldırıldı, clean-code zero-comment politikasıyla uyumlu hale getirildi
- **C-2**: `tier2-5-lead-analyst.instructions.md` — Fallback model "Claude Sonnet 4.6" → "Gemini 3.0 Pro (Preview)" olarak düzeltildi
- **C-3**: `README.md` — Mimari diyagram 3-tier'dan 5-tier'a güncellendi, dağılım tablosuna T1.5 ve T2.5 eklendi
- **C-4**: `review.prompt.md` — Review zinciri 5-tier yapıya güncellendi (T3→T2.5→T2→T1.5→T1)
- **C-5**: `session-memory.instructions.md` — Session dosya adı formatı `YYYY-MM-DD-HH-MM-session-name.md` olarak standardize edildi
- **C-6**: `principal-alpha.agent.md` ve `principal-beta.agent.md` — `agents` YAML listesi eklendi
- **C-7**: `implementation/SKILL.md` — `console.log` ve `any[]` içeren withLogging örneği düzeltildi

#### P1 Önemli Düzeltmeler

- **I-2**: `code-review/SKILL.md` — Kullanıcı listesine Staff Engineer (T1.5) ve Lead Analyst (T2.5) eklendi
- **I-3**: `status.prompt.md` — Maliyet tablosuna T1.5 ve T2.5 tier'ları eklendi
- **I-4**: `context-loading.instructions.md` — PR/Commit task type eklendi (commit-standards, pr-standards)
- **I-5**: `principal-beta.agent.md` — "x7 mode" → "x10 mode" olarak düzeltildi

#### P2 İyileştirmeler

- **S-5**: `.gitignore` — No-op negation pattern'ları düzeltildi, `.github/logs/.gitkeep` eklendi
- **S-6**: `_template.md` — Status alanına `in-progress`, `completed`, `blocked` değerleri eklendi
- **S-8**: `README.md` — Başlığa v3.0.0 versiyon numarası eklendi

---

## [3.0.0] — 2026-02-22

### Added — Model Fallback, Token Optimizasyonu, Session Memory

#### 🔄 Model Fallback Sistemi

Tüm agent'lara otomatik model fallback zinciri eklendi. Birincil model erişilemez olduğunda yedek modele geçiş yapılır.

| Tier                | Birincil                 | Yedek                    |
| ------------------- | ------------------------ | ------------------------ |
| Orchestrator / T1   | Claude Opus 4.6          | Claude Opus 4.5          |
| T1.5 Staff Engineer | Claude Sonnet 4.6        | Claude Sonnet 4.5        |
| T2 MidCoder         | GPT-5.3-Codex            | GPT-5.2-Codex            |
| T2.5 Lead Analyst   | Gemini 3.1 Pro (Preview) | Gemini 3.0 Pro (Preview) |
| T3 Analyst          | Gemini 3 Flash           | Claude Haiku 4.5         |

- 11 agent dosyasına `modelFallback` YAML property eklendi
- `.github/instructions/model-fallback.instructions.md` oluşturuldu

#### 📊 Token Optimizasyonu

Agent dosyalarındaki tekrarlanan içerik merkezi dosyalara taşınarak token tüketimi azaltıldı.

- `.github/instructions/shared-base.instructions.md` — Evrensel kurallar merkezileştirildi
- `.github/instructions/context-loading.instructions.md` — Görev tipine göre skill yükleme kuralları
- `.github/instructions/task-planning.instructions.md` — 15K token bütçeli görev bölme kuralları
- 11 agent dosyası optimize edildi (tekrarlanan bölümler referansa dönüştürüldü)

#### 📋 Görev Planlama Sistemi

Token-aware görev planlama ve duraklatma/devam mekanizması eklendi.

- `.github/todo/_template.md` — Görev şablonu (priority, tier, estimated-tokens)
- `.github/todo/active-plan.md` — Aktif plan takip dosyası (bağımlılık grafiği, devam noktası)

#### 💾 Session Memory

Her oturum sonunda konuşma geçmişi, kararlar ve değişiklikler otomatik kaydedilir.

- `.github/memory/sessions/_session-template.md` — Session kayıt şablonu
- `.github/memory/history/archive.md` — Uzun vadeli arşiv dosyası
- `.github/instructions/session-memory.instructions.md` — Session yaşam döngüsü kuralları
- Orchestrator'a Step 0 (Session & Plan Check) eklendi
- Hook'lara session dizin oluşturma eklendi

#### 🎯 Yeni Slash Komutları

- `.github/prompts/resume.prompt.md` — `/resume` komutu: son session ve aktif planı geri yükler
- `.github/prompts/history.prompt.md` — `/history` komutu: son session'ları listeler

### Changed

- `AGENTS.md` — Model Fallback, Session Memory ve Token Optimization bölümleri eklendi
- `.github/copilot-instructions.md` — Fallback, token optimizasyonu ve session memory bilgileri eklendi
- `.github/hooks/agent-lifecycle.json` — Session dizin oluşturma ve kısaltılmış log formatı
- Orchestrator agent'a session yönetimi, token bütçe farkındalığı ve model durum raporlama eklendi

### Dosya Özeti

**Oluşturulan (11):**

- `.github/instructions/model-fallback.instructions.md`
- `.github/instructions/shared-base.instructions.md`
- `.github/instructions/context-loading.instructions.md`
- `.github/instructions/task-planning.instructions.md`
- `.github/instructions/session-memory.instructions.md`
- `.github/todo/_template.md`
- `.github/todo/active-plan.md`
- `.github/memory/sessions/_session-template.md`
- `.github/memory/history/archive.md`
- `.github/prompts/resume.prompt.md`
- `.github/prompts/history.prompt.md`

**Değiştirilen (14):**

- `.github/agents/orchestrator.agent.md`
- `.github/agents/principal-alpha.agent.md`
- `.github/agents/principal-beta.agent.md`
- `.github/agents/staff-engineer-alpha.agent.md`
- `.github/agents/staff-engineer-beta.agent.md`
- `.github/agents/mid-coder-alpha.agent.md`
- `.github/agents/mid-coder-beta.agent.md`
- `.github/agents/lead-analyst.agent.md`
- `.github/agents/analyst-alpha.agent.md`
- `.github/agents/analyst-beta.agent.md`
- `.github/agents/analyst-gamma.agent.md`
- `.github/hooks/agent-lifecycle.json`
- `AGENTS.md`
- `.github/copilot-instructions.md`

---

## [2.0.0] — 2026-02-14

### Changed — Dil Standardizasyonu & Yeni Skill'ler

#### 🌐 Dil Değişikliği (Türkçe → İngilizce)

Tüm teknik dosyalar (agent, skill, instruction, prompt, AGENTS.md, copilot-instructions.md) Türkçe'den İngilizce'ye çevrildi. LLM modelleri İngilizce talimatlarla daha doğru çalıştığı için bu değişiklik yapıldı. Kullanıcıya dönük dokümanlar (README, USAGE, CHANGELOG) Türkçe kalmaya devam ediyor.

**Çevrilen dosyalar (23):**

- 8 agent dosyası (`.github/agents/*.agent.md`)
- 4 skill dosyası (`.github/skills/*/SKILL.md`)
- 5 instruction dosyası (`.github/instructions/*.instructions.md`)
- 4 prompt dosyası (`.github/prompts/*.prompt.md`)
- `AGENTS.md`
- `.github/copilot-instructions.md`

#### 🆕 Yeni Skill: Clean Code

- `.github/skills/clean-code/SKILL.md` oluşturuldu
- SOLID, DRY, KISS, YAGNI prensipleri
- Koşulsuz kurallar: Kod'da yorum satırı yasağı, console.log yasağı, debug artifact yasağı
- Fonksiyon limitleri (20 satır, 3 parametre, 2 nesting seviyesi)
- Naming convention rehberi
- Error handling pattern'leri
- Tüm kod yazan agent'lar (Tier 1 ve Tier 2) için **zorunlu**

#### 🆕 Yeni Skill: Frontend Development

- `.github/skills/frontend-development/SKILL.md` oluşturuldu
- Principal seviye JavaScript/TypeScript best practices (ES2024+)
- React 18+ component mimarisi, hooks pattern'leri, state management
- Ant Design 5.x usage pattern'leri (Form, Table, Theme customization)
- Performans optimizasyonu ve accessibility standartları
- Feature-based proje yapısı rehberi
- Tüm frontend görevleri için **zorunlu**

#### 🆕 Yeni Instruction: Clean Code Standards

- `.github/instructions/clean-code-standards.instructions.md` oluşturuldu
- `applyTo: "**"` — tüm dosyalarda geçerli
- Mutlak yasakları (yorum, console, debug) zorunlu kılıyor
- Clean code ve frontend-development skill'lerini mandatory olarak referanslıyor
- İhlal = 🔴 Critical review bulgusu

#### 🆕 5-Tier Agent Yapısına Geçiş

3-tier'dan 5-tier'a geçiş kapsamında yeni agent'lar oluşturuldu:

- `.github/agents/staff-engineer-alpha.agent.md` — Tier 1.5 Staff Engineer (birincil kodlama agent'ı)
- `.github/agents/staff-engineer-beta.agent.md` — Tier 1.5 Staff Engineer (ikincil, paralel kodlama)
- `.github/agents/lead-analyst.agent.md` — Tier 2.5 Lead Analyst (Analyst çıktı review ve konsolidasyon)
- `.github/instructions/tier1-5-staff-engineer.instructions.md` — Staff Engineer talimatları
- `.github/instructions/tier2-5-lead-analyst.instructions.md` — Lead Analyst talimatları

#### 📝 Agent Güncellemeleri

- `principal-alpha.agent.md` — clean-code ve frontend-development skill referansları eklendi
- `principal-beta.agent.md` — clean-code ve frontend-development skill referansları eklendi
- `mid-coder-alpha.agent.md` — clean-code ve frontend-development skill referansları eklendi
- `mid-coder-beta.agent.md` — clean-code ve frontend-development skill referansları eklendi

#### 📝 AGENTS.md Güncellemesi

- "📚 Mandatory Skills" bölümü eklendi
- "Absolute Prohibitions in Code" kuralları belgelendi

### Eklenen Dosyalar (8)

- `.github/agents/staff-engineer-alpha.agent.md`
- `.github/agents/staff-engineer-beta.agent.md`
- `.github/agents/lead-analyst.agent.md`
- `.github/instructions/tier1-5-staff-engineer.instructions.md`
- `.github/instructions/tier2-5-lead-analyst.instructions.md`
- `.github/skills/clean-code/SKILL.md`
- `.github/skills/frontend-development/SKILL.md`
- `.github/instructions/clean-code-standards.instructions.md`

---

## [1.1.0] — 2026-02-13

### Fixed — x7 Analiz Sonrası Düzeltmeler

#### 🔴 Critical

- **Hook JSON şeması düzeltildi**: `commands`/`command` → `steps`/`run` (VS Code Copilot hook standardı)
- **`$AGENT_NAME` kaldırıldı**: Hook'larda geçersiz environment variable kullanımı düzeltildi
- **`disable-model-invocation: true` kaldırıldı**: 3 Analyst agent'ın LLM model çağrısını engelleyen flag kaldırıldı
  - `analyst-alpha.agent.md`
  - `analyst-beta.agent.md`
  - `analyst-gamma.agent.md`

#### 🟠 Major

- **Prompt frontmatter temizlendi**: 4 prompt dosyasından geçersiz `model` ve `tools` property'leri kaldırıldı
  - `delegate.prompt.md`, `review.prompt.md`, `status.prompt.md`, `architect.prompt.md`
- **`applyTo` pattern'leri genişletildi**: 5 instruction dosyasının `applyTo` değeri `"**"` yapılarak tüm çalışma bağlamında erişilebilir kılındı
  - `delegation-rules.instructions.md`, `review-chain.instructions.md`
  - `tier1-principal.instructions.md`, `tier2-mid.instructions.md`, `tier3-analyst.instructions.md`
- **Orchestrator `user-invokable: true` eklendi**: Eksik olan explicit user-invokable flag eklendi

#### 🟡 Minor

- **`.gitignore` oluşturuldu**: OS, IDE, log, dependency ve environment dosyaları için ignore kuralları eklendi
- **Log dizini düzeltildi**: Hook log çıktıları `.github/hooks/` → `.github/logs/` dizinine taşındı
- **`.github/logs/.gitkeep` eklendi**: Log dizininin Git'te takip edilmesi sağlandı

### Etkilenen Dosyalar (15)

- `.github/hooks/agent-lifecycle.json`
- `.github/hooks/safety-guard.json`
- `.github/agents/analyst-alpha.agent.md`
- `.github/agents/analyst-beta.agent.md`
- `.github/agents/analyst-gamma.agent.md`
- `.github/agents/orchestrator.agent.md`
- `.github/prompts/delegate.prompt.md`
- `.github/prompts/review.prompt.md`
- `.github/prompts/status.prompt.md`
- `.github/prompts/architect.prompt.md`
- `.github/instructions/delegation-rules.instructions.md`
- `.github/instructions/review-chain.instructions.md`
- `.github/instructions/tier1-principal.instructions.md`
- `.github/instructions/tier2-mid.instructions.md`
- `.github/instructions/tier3-analyst.instructions.md`

### Eklenen Dosyalar (2)

- `.gitignore`
- `.github/logs/.gitkeep`

---

## [1.0.0] — 2026-02-13

### Added — İlk Sürüm

#### Proje Yapısı

- `.github/` dizin yapısı oluşturuldu (agents, instructions, skills, prompts, hooks)
- `.vscode/settings.json` — VS Code konfigürasyonu eklendi
- `AGENTS.md` — Global agent kuralları tanımlandı
- `.github/copilot-instructions.md` — Always-on proje bağlam dosyası eklendi

#### Agent Dosyaları (`.github/agents/`)

- `orchestrator.agent.md` — Ana koordinatör agent (Claude Opus 4.6)
- `principal-alpha.agent.md` — Tier 1 birincil mimari agent (Claude Opus 4.6)
- `principal-beta.agent.md` — Tier 1 ikincil mimari agent (Claude Opus 4.6)
- `mid-coder-alpha.agent.md` — Tier 2 birincil kodlama agent (GPT-5.3 Codex)
- `mid-coder-beta.agent.md` — Tier 2 ikincil kodlama agent (GPT-5.3 Codex)
- `analyst-alpha.agent.md` — Tier 3 birincil analiz agent (Gemini 3 Flash)
- `analyst-beta.agent.md` — Tier 3 ikincil analiz agent (Gemini 3 Flash)
- `analyst-gamma.agent.md` — Tier 3 üçüncül analiz agent (Gemini 3 Flash)

#### Skill Dosyaları (`.github/skills/`)

- `code-architecture/SKILL.md` — Mimari paternler, SOLID, ölçeklenebilirlik (Tier 1)
- `code-review/SKILL.md` — Review checklist, severity, feedback formatı (Tier 1 & 2)
- `implementation/SKILL.md` — Kodlama standartları, pattern'ler, test rehberi (Tier 2)
- `analysis/SKILL.md` — Analiz şablonları, araştırma protokolü (Tier 3)

#### Instruction Dosyaları (`.github/instructions/`)

- `tier1-principal.instructions.md` — Principal agent çalışma talimatları
- `tier2-mid.instructions.md` — MidCoder agent çalışma talimatları
- `tier3-analyst.instructions.md` — Analyst agent çalışma talimatları
- `review-chain.instructions.md` — Review zinciri kuralları
- `delegation-rules.instructions.md` — xN parametresi ve görev dağılım kuralları

#### Prompt Dosyaları (`.github/prompts/`)

- `delegate.prompt.md` — `/delegate` slash komutu — multi-agent delegasyon
- `review.prompt.md` — `/review` slash komutu — review zinciri tetikleyici
- `status.prompt.md` — `/status` slash komutu — durum özeti
- `architect.prompt.md` — `/architect` slash komutu — doğrudan mimari görev

#### Hook Dosyaları (`.github/hooks/`)

- `agent-lifecycle.json` — SubagentStart/Stop event logging
- `safety-guard.json` — PreToolUse terminal güvenlik filtresi

#### Dokümantasyon

- `CHANGELOG.md` — Değişiklik takip dosyası (bu dosya)
- `USAGE.md` — Kullanım kılavuzu
- `README.md` — Proje tanıtımı ve hızlı başlangıç
