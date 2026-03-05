# Changelog

Bu dosya Multi-Agent Delegation System boilerplate'indeki tüm değişiklikleri takip eder.
Format [Keep a Changelog](https://keepachangelog.com/) standardına uygundur.

---

## [4.9.0] — 2026-03-02

### Fixed

- **Tier Skill Mapping Tutarsızlığı**: v4.8.0'da eklenen 4 yeni skill'in tier instruction dosyalarına yansıtılması
  - `tier1-principal.instructions.md`: 4 eksik skill eklendi (mayacore-integration, backend-security, java-quality-tooling, api-integration)
  - `tier1-5-staff-engineer.instructions.md`: 4 eksik skill eklendi (mayacore-integration, backend-security, java-quality-tooling, api-integration)
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

- **4 Yeni Skill Dosyası**: `rules/` dizinindeki proje standartları multi-agent sistemine entegre edildi
  - `mayacore-integration/SKILL.md`: MayaCore ekosistem entegrasyonu (Config Server, Common Library, API Gateway, Session Library, OpenShift deployment)
  - `backend-security/SKILL.md`: Spring Boot güvenlik standartları (SQL injection, XSS, input validation, BCrypt, JWT, rate limiting)
  - `java-quality-tooling/SKILL.md`: Maven kalite araçları (Checkstyle, SpotBugs, JaCoCo, SonarQube konfigürasyonu)
  - `api-integration/SKILL.md`: Frontend-backend entegrasyon kontratı (ApiResponse<T>, pagination, tarih/saat, hata yönetimi, CORS, auth)
- **Git Safety Instructions**: AI agent'ların git operasyonları için zorunlu onay mekanizması (`git-safety.instructions.md`)
- **Config Dosyaları**: `.github/config/` dizinine Checkstyle, SpotBugs ve Maven kalite plugin şablonları eklendi
- **Java Backend Task Type**: `context-loading.instructions.md`'ye yeni görev tipi eklendi
- **6 Yeni Task Type**: `delegation-rules.instructions.md`'ye Spring Boot ve MayaCore görev tipleri eklendi

### Changed

- Versiyon: v4.7.0 → v4.8.0 (README, USAGE, CHANGELOG)
- `backend-development/SKILL.md`: Node.js-only → Dual-stack (Node.js + Java/Spring Boot) — Constructor injection, layered architecture, ServiceResponse<T>, GlobalExceptionHandler, retry/circuit breaker eklendi
- `frontend-development/SKILL.md`: 4 çakışma çözüldü (form standard → React Hook Form + Yup, component max → 300 satır, interface > type, flat feature folders) + MayaCore Nx MFE kuralları, rem() auto-import, Zustand store naming, BEM prefixes eklendi
- `testing-standards/SKILL.md`: Java/JUnit backend testing section genişletildi — AssertJ, BDDMockito, parameterized tests, integration test patterns, test data builders, F.I.R.S.T. principles eklendi
- `context-loading.instructions.md`: Java Backend task type + api-integration skill eklendi
- `system-validation.instructions.md`: Skill minimum 8→14, instruction minimum 17→19
- `delegation-rules.instructions.md`: 6 yeni Spring Boot/MayaCore task type eklendi
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

**Oluşturulan (12):**

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

### Etkilenen Dosyalar (13)

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
