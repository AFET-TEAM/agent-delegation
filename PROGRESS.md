# Multi-Agent Delegation System — Geliştirme Yol Haritası

> Bu dosya, sistemin mevcut durumunu, tespit edilen iyileştirme fırsatlarını ve planlanan geliştirme adımlarını takip eder.
> Son güncelleme: v5.0.0

---

## Mevcut Durum

| Metrik | Değer |
|--------|-------|
| Versiyon | v5.0.0 |
| Yapısal Bütünlük | 9/9 doğrulama kuralı ✅ PASS |
| Cross-Reference Tutarlılığı | 9/9 kontrol ✅ PASS |
| Dokümantasyon Doğruluğu | 17 kontrol ✅ PASS, 6 bulgu düzeltildi |
| Agent Sayısı | 11 (5 tier) |
| Skill Sayısı | 13 |
| Instruction Sayısı | 19 |

---

## Geliştirme Görevleri

### 🔴 P0 — Kritik (Token Optimizasyonu)

#### TASK-001: Platform Context Overhead Azaltımı
**Problem**: Her agent oturumu ~45-55K token platform overhead yüklüyor (19 instruction dosyası `applyTo: "**"` ile). 15K subtask bütçesi dahil toplam ~60-70K token tüketiliyor.
**Önerilen Çözüm**: 
- Instruction dosyalarını tier-aware `applyTo` pattern'leriyle gruplayarak sadece ilgili dosyaları yükle
- Shared-base + tier-specific + task-specific olarak 3 katmanlı yükleme sistemi
- Platform sınırlaması (`applyTo` sadece dosya pattern'i destekliyor, agent identity değil) nedeniyle alternatif: instruction dosyalarını birleştirerek dosya sayısını azalt
**Tahmini Etki**: %20-30 token tasarrufu (~10-15K token/oturum)
**Karmaşıklık**: Yüksek — tüm instruction dosyaları yeniden yapılandırılmalı

#### TASK-002: Skill Dosyası Token Bütçesi Optimizasyonu
**Problem**: Bazı skill dosyaları çok büyük (frontend-development: 691 satır, testing-standards: 550 satır, api-integration: 435 satır). Bunlar context bütçesini hızla tüketiyor.
**Önerilen Çözüm**:
- Büyük skill dosyalarını "core" ve "extended" bölümlerine ayır
- Core bölüm her zaman yüklenir, extended sadece ilgili görevlerde
- Veya: Skill dosyaları içinde bölüm başlıkları ile seçici yükleme (agent'lar sadece ilgili bölümü okur)
**Tahmini Etki**: %15-25 skill token tasarrufu
**Karmaşıklık**: Orta

---

### 🟠 P1 — Önemli (Paralel Agent Optimizasyonu)

#### TASK-003: Paralel Agent Execution Stratejisi
**Problem**: x10 modunda 10 agent çalışıyor ama bazıları (Staff Engineer, MidCoder) analiz görevlerinde idle. Kodlama görevlerinde ise Analyst'ler idle. Agent kullanım verimi düşük.
**Önerilen Çözüm**:
- Phase-based execution: Analiz fazı (T3 + T2.5 aktif) → Kodlama fazı (T1.5 + T2 aktif) → Review fazı (T1 + T1.5 aktif)
- Analiz sonuçlarını kodlama agent'larına otomatik besleme
- İdle agent'lar için "pre-fetch" mekanizması (context yükleme, dosya okuma)
**Tahmini Etki**: %30-40 toplam süre iyileştirmesi
**Karmaşıklık**: Yüksek — Orchestrator protokolü güncellenmeli

#### TASK-004: Agent Arası Bağımlılık Grafiği
**Problem**: Orchestrator görev dağıtımında bağımlılıklar açıkça tanımlı değil. Sıralı çalışması gereken görevler bazen paralel atanıyor.
**Önerilen Çözüm**:
- `delegation-rules.instructions.md`'ye görev bağımlılık matrisi ekle
- Orchestrator'ın DAG (Directed Acyclic Graph) tabanlı görev sıralaması yapması
- Paralel gruplar ve sıralı zincirler açıkça tanımlanmalı
**Tahmini Etki**: %20 daha az rework, daha az review round
**Karmaşıklık**: Orta

#### TASK-005: Review Chain Paralelleştirme
**Problem**: Review zinciri sıralı çalışıyor (T3→T2.5→T1.5→T1). Farklı modüllerin review'ları paralel yapılabilir.
**Önerilen Çözüm**:
- Modül bazlı paralel review: Modül A'nın T1.5 review'ı ile Modül B'nin T2.5 review'ı eşzamanlı
- Review sonuçlarının Orchestrator'da merge edilmesi
- Conflict detection: Aynı dosyaya dokunan farklı modül review'larında uyarı
**Tahmini Etki**: %25 review süre iyileştirmesi
**Karmaşıklık**: Orta

---

### 🟡 P2 — Orta Öncelikli (Dokümantasyon & DX)

#### TASK-006: Reduced Mode Review Kurallarının USAGE.md'ye Eklenmesi
**Problem**: `review-chain.instructions.md`'deki reduced mode kuralları (x2, x3, x4) USAGE.md'de dokümante edilmemiş.
**Önerilen Çözüm**: USAGE.md "Review Zinciri" bölümüne reduced mode tablosu ekle
**Karmaşıklık**: Düşük

#### TASK-007: AGENTS.md Mandatory Skills Koşulluluk Açıklaması
**Problem**: AGENTS.md 8 "mandatory" skill listelerken bunların koşullu olduğunu (task type'a göre) yeterince açıklamıyor. Context-loading bütçesiyle çelişki izlenimi yaratabilir.
**Önerilen Çözüm**: "Mandatory" yerine "Binding Rules (task type'a göre aktif)" ifadesi + koşul tablosu
**Karmaşıklık**: Düşük

#### TASK-008: Metrik Toplama Otomasyonu
**Problem**: `.github/metrics/` dosyaları (agent-performance.md, token-usage.md) şablon olarak var ama otomatik güncelleme mekanizması yok. Orchestrator'ın session sonunda güncellemesi gerekiyor ama bu süreç manuel.
**Önerilen Çözüm**:
- Orchestrator session-end protokolüne otomatik metrik güncelleme adımı ekle
- Token kullanımı tahmini vs gerçek karşılaştırma tablosu
- Session bazlı agent performance snapshot'ı
**Karmaşıklık**: Orta

#### TASK-009: Agent Scaffolding Wizard Deneyimi
**Problem**: Yeni agent oluşturmak `agent-scaffolding.instructions.md`'yi okumayı ve dosyaları manuel oluşturmayı gerektiriyor.
**Önerilen Çözüm**:
- `/create-agent [name] [tier]` slash komutu ekle
- Orchestrator şablonu otomatik doldurur, dosyaları oluşturur, cross-ref'leri günceller
- Post-creation checklist'i otomatik çalıştır
**Karmaşıklık**: Orta

---

### 🟢 P3 — İyileştirme (Gelecek Özellikler)

#### TASK-010: Dinamik Skill Discovery
**Problem**: Skill'ler statik olarak agent dosyalarında tanımlı. Yeni skill eklendiğinde tüm agent dosyaları manuel güncelleniyor.
**Önerilen Çözüm**:
- Skill dosyalarına YAML frontmatter'da `tiers: [T1, T1.5, T2]` metadata ekle
- Agent dosyaları skill'leri discover etsin (PCD benzeri mekanizma)
- Tek kaynak (SKILL.md metadata) → tüm referanslar otomatik
**Karmaşıklık**: Yüksek

#### TASK-011: Context Window Kullanım Dashboard'u
**Problem**: Agent'ların context window'larının ne kadarını kullandığı görünmüyor. Token bütçesi tahmini elle yapılıyor.
**Önerilen Çözüm**:
- Orchestrator `/status` komutuna context window kullanım yüzdesi ekle
- Tahmini vs gerçek token tüketimi karşılaştırması
- Budget exceeded uyarıları
**Karmaşıklık**: Yüksek — platform API desteği gerekebilir

#### TASK-012: Multi-Session Task Continuity
**Problem**: Token limiti aşıldığında `/resume` ile devam edilebiliyor ama session geçişleri sırasında context kaybı yaşanabiliyor.
**Önerilen Çözüm**:
- Session-end'de otomatik context snapshot (sadece karar noktaları, değişen dosyalar, pending görevler)
- `/resume` komutunun snapshot'ı okuyarak tam context recovery sağlaması
- Session arası "handoff document" formatı
**Karmaşıklık**: Orta

#### TASK-013: Agent Performance Benchmark
**Problem**: Agent'ların görev başarı oranı, revision round sayısı, token verimliliği ölçülmüyor.
**Önerilen Çözüm**:
- Her görev sonrası: başarı (✅/⚠️/❌), revision round, tahmini vs gerçek token
- Agent bazlı performans raporu
- Düşük performanslı agent-görev eşleştirmelerini tespit ve öneri
**Karmaşıklık**: Orta

#### TASK-014: Proje Şablonu (Template) Desteği
**Problem**: Boilerplate farklı proje tiplerine (React SPA, Next.js, Spring Boot, Full-Stack) uygulanırken her seferinde aynı PCD süreci tekrarlanıyor.
**Önerilen Çözüm**:
- `.github/templates/` dizini: react-spa, nextjs, spring-boot, full-stack şablonları
- Şablon seçimiyle ilgili skill'ler otomatik aktif/pasif
- `/init [template]` komutu ile hızlı kurulum
**Karmaşıklık**: Yüksek

---

## Önceliklendirme Matrisi

| Görev | Öncelik | Etki | Efor | Önerilen Sıralama |
|-------|---------|------|------|-------------------|
| TASK-001 | P0 | Yüksek | Yüksek | 1 |
| TASK-002 | P0 | Yüksek | Orta | 2 |
| TASK-003 | P1 | Yüksek | Yüksek | 3 |
| TASK-006 | P2 | Düşük | Düşük | 4 |
| TASK-007 | P2 | Düşük | Düşük | 5 |
| TASK-004 | P1 | Orta | Orta | 6 |
| TASK-005 | P1 | Orta | Orta | 7 |
| TASK-008 | P2 | Orta | Orta | 8 |
| TASK-009 | P2 | Orta | Orta | 9 |
| TASK-010 | P3 | Yüksek | Yüksek | 10 |
| TASK-012 | P3 | Orta | Orta | 11 |
| TASK-013 | P3 | Orta | Orta | 12 |
| TASK-011 | P3 | Orta | Yüksek | 13 |
| TASK-014 | P3 | Yüksek | Yüksek | 14 |

---

## Tamamlanan Analizler (v5.0.0)

| Analiz | Sonuç | Agent |
|--------|-------|-------|
| Yapısal Doğrulama (9 kural) | 9/9 ✅ PASS | AnalystAlpha (T3) |
| Cross-Reference Tutarlılığı | 9/9 ✅ PASS | AnalystBeta (T3) |
| Dokümantasyon Doğruluğu | 17 ✅ PASS, 6 bulgu (1 P1 + 3 P2 + 2 P3) | AnalystGamma (T3) |

### Düzeltilen Bulgular (v5.0.0)

| # | Bulgu | Önem | Düzeltme |
|---|-------|------|----------|
| F1 | README versiyon yörüngesi tablosunda v5.0.0 satırı eksik | P2 | v5.0.0 satırı eklendi |
| F2 | USAGE.md token bütçe tablosu task-planning ile uyumsuz | P1 | Değerler senkronize edildi |
| F3 | USAGE.md FAQ'da `.vscode/settings.json` → `.vscode/` olmalı | P2 | Düzeltildi |
| F4 | AGENTS.md mandatory skills koşulluluk açıklaması | P2 | TASK-007 olarak planlandı |
| F5 | README'de scaffolding/validation feature eksik | P3 | TASK planına alındı |
| F6 | Reduced mode review kuralları USAGE.md'de yok | P2 | TASK-006 olarak planlandı |
