# Multi-Agent Delegation System — v7.3.0

> AI agent'larını bir takım gibi organize eden, görevleri maliyet ve yetkinlik bazında dağıtan orkestrasyon boilerplate'i.

[![VS Code](https://img.shields.io/badge/VS%20Code-1.109%2B-blue)](https://code.visualstudio.com/)
[![Copilot](https://img.shields.io/badge/GitHub%20Copilot-Required-green)](https://github.com/features/copilot)
[![License](https://img.shields.io/badge/License-GPLv3-yellow)](LICENSE)

---

## Nedir?

Bu boilerplate, VS Code'un yerel agent mekanizmasını kullanarak birden fazla AI modelini bir ekip gibi çalıştırır. Bir prompt verdiğinizde, sistem görevi analiz eder, alt-görevlere böler ve her birini en uygun (ve en maliyet-etkin) AI modeline dağıtır.

### Temel Özellikler

| Özellik | Açıklama |
|---------|----------|
| **5 Tier Agent Hiyerarşisi** | T1 Mimari (Claude), T2-T3 Kodlama (Sonnet/GPT), T4-T5 Analiz (Gemini) |
| **xN Delegasyon** | Prompt sonuna `x7` ekle, 7 agent çalışsın |
| **Versiyon-Duyarlı Frontend** | React 18/19, Ant Design 5/6 — package.json'dan otomatik algılama |
| **Proje Bağlamı Keşfi (PCD)** | Hedef projenin README, .md ve docs/ klasörünü otomatik tarar |
| **Prompt Zenginleştirme (PEP)** | Geliştirme öncesi hedefli sorular, detaylı plan, onay |
| **Otomatik Review Zinciri** | T5→T4→T3→T2→T1 kademeli review pipeline |
| **Model Fallback** | Erişilemez modelde otomatik yedek geçişi |
| **Session Memory** | Konuşma geçmişi ve kararlar otomatik kaydedilir |
| **Token Optimizasyonu** | 15K bütçe, soft/hard limit, on-demand skill yükleme |
| **Dinamik Agent İsimlendirme** | 20 isimlik havuz, merit-based skor sistemi, leaderboard |
| **DAG Tabanlı Görev Grafiği** | Bağımlılık analizi ile paralel execution wave'leri |
| **Çakışma Önleme** | Dosya sahipliği ve kilit mekanizması |
| **16 Hazır Skill** | Frontend, backend, review, analiz, güvenlik, test, API kontrat, caveman, context-efficiency, knowledge-graph |
| **9 Slash Komutu** | `/delegate`, `/review`, `/status`, `/architect`, `/resume`, `/history`, `/create-agent`, `/caveman`, `/context-mode` |
| **Token Verimliliği Modları** | Caveman (çıktı sıkıştırma), Context Mode (bağlam optimizasyonu), Knowledge Graph (akıllı analiz) |

---

## Bu Sistemi Kullanmanın Faydası: Maliyet Karşılaştırması

### Senaryo: Orta ölçekli bir feature geliştirme (API + UI + Test)

| Metrik | Sistem Olmadan (Tek Agent) | Bu Sistem ile (x7) | Fark |
|--------|:--------------------------:|:-------------------:|:----:|
| **Kullanılan model** | Claude Opus (en pahalı) | 5 farklı model (maliyet-optimum) | — |
| **Tahmini token** | ~120K token (tek context) | ~85K token (dağıtık) | **~%30 tasarruf** |
| **Maliyet** | ~$3.60 (tamamı Opus fiyatıyla) | ~$1.44 (ağırlıklı ortalama) | **~%60 tasarruf** |
| **Context window kullanımı** | %100 tek pencere (taşma riski) | %15-40 per agent (taşma yok) | **Sıfır taşma** |
| **Review kalitesi** | Self-review (kendi hatalarını görme) | Kademeli cross-review (T5→T1) | **5 katmanlı** |
| **Paralel çalışma** | Sıralı (tek agent) | DAG wave'leriyle paralel | **2-3x hız** |

### Maliyet Detayı (Model Bazında)

| Model | Tier | Input/1M | Output/1M | Kullanım Alanı |
|-------|:----:|:--------:|:---------:|----------------|
| Claude Opus 4.6 | T1 | $15.00 | $75.00 | Yalnızca mimari + review |
| Claude Sonnet 4.6 | T2 | $3.00 | $15.00 | Kodlama görevleri |
| GPT-5.3-Codex | T3 | $2.00 | $8.00 | Kodlama görevleri |
| Gemini 3.1 Pro | T4 | $1.25 | $5.00 | Analiz review |
| Gemini 3 Flash | T5 | $0.075 | $0.30 | Analiz + araştırma |

> **Neden %60 tasarruf?** Analiz görevleri ($0.075/M) ve kodlama görevleri ($2-3/M) en pahalı model ($15/M) yerine uygun tier'da çalışır. Yalnızca mimari kararlar ve final review en pahalı modeli kullanır.

### Token Optimizasyon Mekanizmaları

| Mekanizma | Etkisi |
|-----------|--------|
| **3 evrensel + 18 on-demand instruction** | ~%70 daha az auto-load overhead |
| **Core/extended skill split** | T5 agent'lar yalnızca core bölümleri yükler |
| **15K subtask bütçesi** | Görev büyürse otomatik decompose |
| **12K soft limit uyarısı** | Taşma öncesi erken müdahale |
| **PCD bütçe entegrasyonu** | Proje dosyaları skill bütçesinden pay alır |
| **Context Efficiency (baseline)** | Think-in-Code + Query-First her zaman aktif |
| **`/context-mode` (yoğunlaştırılmış)** | Büyük görevlerde %30-45 bağlam tasarrufu |
| **`/caveman` (çıktı sıkıştırma)** | %40-65 output token azaltma |

---

## Hızlı Başlangıç

### 1. Kurulum

```bash
git clone <repo-url> agentDelegation
cp -r agentDelegation/.github /path/to/your/project/
cp agentDelegation/AGENTS.md /path/to/your/project/
cp -r agentDelegation/.vscode /path/to/your/project/
```

### 2. Gereksinimler

- VS Code 1.109+
- GitHub Copilot (aktif abonelik)
- Copilot Chat / Agent Mode

### 3. Kullanım

```
# Tek agent — klasik kullanım
Bu fonksiyonu refactor et

# 3 agent ekip
/delegate Login formunu oluştur x3

# 5 agent ekip
/delegate REST API'yi implement et x5

# 7 agent tam ekip
/delegate E-ticaret modülünü sıfırdan tasarla ve kur x7

# Doğrudan mimari görev
/architect Hexagonal architecture kur
```

---

## Mimari

```
            ┌──────────────┐
            │  Kullanıcı    │
            │  prompt + xN  │
            └──────┬───────┘
                   │
         ┌─────────▼─────────┐
         │   Orchestrator     │
         │  Claude Opus 4.6   │
         └──┬───┬───┬───┬───┬┘
            │   │   │   │   │
     ┌──────▼┐┌─▼──┐┌▼───┐┌▼────┐┌▼─────┐
     │Tier 1 ││Tier ││Tier││Tier ││Tier  │
     │       ││ 2   ││ 3  ││ 4   ││ 5    │
     │Claude ││Clau.││GPT ││Gem. ││Gem.  │
     │Opus   ││Son. ││5.3 ││3.1  ││Flash │
     │4.6    ││4.6  ││Cdx ││Pro  ││      │
     │       ││     ││    ││     ││SCOPED│
     │WRITE  ││WRITE││WRIT││SCPD ││WRITE │
     │REVIEW ││     ││    ││WRIT ││      │
     └───────┘└─────┘└────┘└─────┘└──────┘
       $$$$$   $$$$   $$$    $$      $

  Review: T5 → T4 review
          T3 → T2 review
          T2 → T1 review
```

### Agent Dağılımı

| Parametre | Principal (T1) | Staff Eng (T2) | MidCoder (T3) | Lead Analyst (T4) | Analyst (T5) |
|-----------|:--------------:|:--------------:|:-------------:|:-----------------:|:------------:|
| _yok_ | 1 (varsayılan) | — | — | — | — |
| `x3` | 1 | 1 | 0 | 0 | 1 |
| `x5` | 1 | 1 | 1 | 1 | 1 |
| `x7` | 1 | 2 | 1 | 1 | 2 |
| `x10` | 2 | 2 | 2 | 1 | 3 |

---

## Slash Komutları

| Komut | Açıklama |
|-------|----------|
| `/delegate [görev] xN` | Multi-agent delegasyon |
| `/review [dosya/dizin]` | Manuel review zinciri |
| `/status` | Delegasyon durumu + context dashboard |
| `/architect [görev]` | Doğrudan mimari görev |
| `/resume` | Son session ve aktif planı geri yükle |
| `/history` | Son session'ları listele |
| `/create-agent [ad] [tier]` | Yeni agent scaffold'u oluştur |
| `/caveman [lite\|full\|ultra]` | Token-verimli kısa çıktı modu |
| `/context-mode` | Yoğunlaştırılmış bağlam verimliliği |

---

## Frontend Desteği

Bu sistem, projenin `package.json` dosyasından framework versiyonlarını otomatik algılayarak versiyon-duyarlı kod önerileri yapar:

| Framework | Desteklenen Versiyonlar | Algılama |
|-----------|------------------------|----------|
| **React** | 18.x, 19.x | `react` dependency version |
| **Ant Design** | 5.x, 6.x | `antd` dependency version |
| **TypeScript** | 5.x+ | `typescript` dependency version |

### React 18 vs 19

| Özellik | React 18 | React 19 |
|---------|----------|----------|
| Veri çekme | `useEffect` + state | `use()` + `<Suspense>` |
| Form yönetimi | Manuel state | `useActionState` + `useFormStatus` |
| Optimistik UI | Manuel rollback | `useOptimistic` |
| Memoization | `useMemo`/`useCallback` | React Compiler (otomatik) |
| Ref forwarding | `forwardRef()` wrapper | `ref` prop olarak |
| Context okuma | `useContext(Ctx)` | `use(Ctx)` |

### Ant Design 5 vs 6

| Özellik | Ant Design 5 | Ant Design 6 |
|---------|-------------|-------------|
| Tema sistemi | CSS-in-JS runtime | CSS Variables (performans artışı) |
| `Tabs` prop | `destroyInactiveTabPane` | `destroyOnHide` |
| `Modal` default | `destroyOnClose: false` | `destroyOnClose: true` |
| `Spin` | Sadece indeterminate | `percent` prop ile determinate |
| Yeni bileşen | — | `Splitter` (resizable panels) |

---

## Dosya Yapısı

```
your-project/
├── .github/
│   ├── copilot-instructions.md              # Always-on proje bağlamı
│   ├── agents/
│   │   ├── orchestrator.agent.md            # Koordinatör (Claude Opus 4.6)
│   │   ├── principal-alpha.agent.md         # T1: Baş Yazılım Mimarı
│   │   ├── principal-beta.agent.md          # T1: Kıdemli Yazılım Mimarı
│   │   ├── staff-engineer-alpha.agent.md    # T2: Kıdemli Müh. (Sonnet)
│   │   ├── staff-engineer-beta.agent.md     # T2: Yazılım Müh. (Sonnet)
│   │   ├── mid-coder-alpha.agent.md         # T3: Geliştirici (GPT-5.3)
│   │   ├── mid-coder-beta.agent.md          # T3: Geliştirici (GPT-5.3)
│   │   ├── lead-analyst.agent.md            # T4: Kıdemli Analist (Gemini Pro)
│   │   ├── analyst-alpha.agent.md           # T5: Analist (Gemini Flash)
│   │   ├── analyst-beta.agent.md            # T5: Analist (Gemini Flash)
│   │   └── analyst-gamma.agent.md           # T5: Analist (Gemini Flash)
│   ├── skills/
│   │   ├── clean-code/SKILL.md              # Tüm kodlama + T4: Kod hijyeni
│   │   ├── code-architecture/SKILL.md       # T1: Mimari rehber
│   │   ├── code-review/SKILL.md             # T1, T2, T3, T4: Review
│   │   ├── commit-standards/SKILL.md        # T1, T2, T3: Commit formatı
│   │   ├── frontend-development/SKILL.md    # T1, T2, T3: React 18/19 + AntD 5/6
│   │   ├── backend-development/SKILL.md     # T1, T2, T3: Backend rehber
│   │   ├── implementation/SKILL.md          # T1, T2, T3: Kodlama standartları
│   │   ├── pr-standards/SKILL.md            # T1, T2, T3: PR standartları
│   │   ├── testing-standards/SKILL.md       # T1, T2, T3: Test standartları (R19)
│   │   ├── analysis/SKILL.md               # T4, T5: Analiz şablonları
│   │   ├── backend-security/SKILL.md        # T1, T2: Spring Boot güvenlik
│   │   ├── java-quality-tooling/SKILL.md    # T1, T2, T3: Maven kalite araçları
│   │   ├── api-integration/SKILL.md         # T1, T2, T3: Frontend-backend kontrat
│   │   ├── caveman/SKILL.md                 # Tüm tier: Token-verimli çıktı modu
│   │   ├── context-efficiency/SKILL.md      # Tüm tier: Bağlam optimizasyonu
│   │   └── knowledge-graph/SKILL.md         # T4, T5: Bilgi grafiği analiz
│   ├── instructions/
│   │   ├── clean-code-standards.instructions.md   # Universal (auto-loaded)
│   │   ├── shared-base.instructions.md            # Universal (auto-loaded)
│   │   ├── git-safety.instructions.md             # Universal (auto-loaded)
│   │   └── reference/
│   │       ├── tier1-principal.instructions.md
│   │       ├── tier2-staff-engineer.instructions.md
│   │       ├── tier3-mid.instructions.md
│   │       ├── tier4-lead-analyst.instructions.md
│   │       ├── tier5-analyst.instructions.md
│   │       ├── review-chain.instructions.md
│   │       ├── delegation-rules.instructions.md
│   │       ├── model-fallback.instructions.md
│   │       ├── context-loading.instructions.md
│   │       ├── task-planning.instructions.md
│   │       ├── session-memory.instructions.md
│   │       ├── system-validation.instructions.md
│   │       ├── agent-scaffolding.instructions.md
│   │       ├── project-context-discovery.instructions.md
│   │       ├── prompt-enrichment.instructions.md
│   │       ├── model-registry.instructions.md
│   │       ├── slash-commands.instructions.md
│   │       └── dynamic-naming.instructions.md
│   ├── hooks/
│   │   ├── agent-lifecycle.json
│   │   ├── safety-guard.json
│   │   ├── review-enforcer.json
│   │   ├── context-guard.json
│   │   └── post-dev-analysis.json
│   ├── config/
│   │   ├── checkstyle.xml
│   │   ├── spotbugs-exclude.xml
│   │   ├── pom-quality-plugins.xml.template
│   │   └── name-pool.md
│   ├── metrics/
│   │   ├── agent-performance.md
│   │   ├── token-usage.md
│   │   └── leaderboard.md
│   ├── todo/
│   │   ├── _template.md
│   │   └── active-plan.md
│   ├── memory/
│   │   ├── sessions/_session-template.md
│   │   └── history/archive.md
│   ├── templates/
│   │   ├── react-spa.md
│   │   ├── spring-boot.md
│   │   └── full-stack.md
│   ├── docs/adr/
│   │   ├── ADR-001-platform-boundary.md
│   │   └── ADR-002-analyst-write-permission.md
│   ├── analysis/
│   │   ├── raw/.gitkeep
│   │   └── consolidated/.gitkeep
│   └── logs/.gitkeep
├── docs/
│   ├── README.md                            # Dokümantasyon genel bakış
│   ├── context-efficiency.md                # Bağlam verimliliği rehberi
│   ├── knowledge-graph.md                   # Bilgi grafiği analiz rehberi
│   ├── caveman.md                           # Caveman modu rehberi
│   └── verimlilik-karsilastirma.md          # Karşılaştırma tabloları
├── .vscode/
│   ├── settings.json
│   └── mcp.json
├── AGENTS.md
├── CHANGELOG.md
├── LICENSE
├── PROGRESS.md
├── USAGE.md
└── README.md
```

---

## Token Verimliliği Modları

Sistem, üç katmanlı token optimizasyonu sunar:

```
┌─────────────────────────────────────────────────┐
│  Katman 3: /caveman — Çıktı Sıkıştırma         │  ← Opsiyonel
│  Katman 2: /context-mode — Bağlam Optimizasyonu │  ← Opsiyonel
│  Katman 1: Baseline — HER ZAMAN AKTİF          │  ← Otomatik
└─────────────────────────────────────────────────┘
```

| Mod | Tetikleyici | Ne Optimize Eder | Tasarruf |
|-----|-------------|-----------------|----------|
| **Baseline** | Otomatik (her zaman) | Input okuma davranışı (grep > view) | %15-25 |
| **`/context-mode`** | Slash komutu veya anahtar kelime | Bağlam tüketimi (sıkı bütçeler, batch ops) | %30-45 |
| **`/caveman`** | Slash komutu veya anahtar kelime | Çıktı yazım stili (kısa, öz, dolgu yok) | %40-65 |
| **Her ikisi birlikte** | `/context-mode` + `/caveman` | Input + Output → Maksimum verimlilik | %40-55 |

### Caveman Seviyeleri

| Seviye | Örnek Çıktı |
|--------|-------------|
| `/caveman lite` | "Dosya oluşturuldu. 3 test geçiyor." |
| `/caveman full` | "Dosya oluşturuldu. 3 test pass. Hata yok." |
| `/caveman ultra` | "✅ dosya → 3 test pass → 0 err" |

### Context Mode Temel Kuralları

| Kural | Ne Yapar |
|-------|----------|
| **Think-in-Code** | 500+ satır dosyaları grep/awk ile tarar, komple okumaz |
| **Query-First** | Dosya açmadan önce grep/glob ile arama yapar |
| **Output Routing** | 200+ satır çıktıyı dosyaya yazar, özet gösterir |
| **Confidence Tagging** | Analiz bulgularına 🟢/🟡/🔴 güven etiketi koyar |

> Detaylı dokümantasyon: [`docs/`](docs/) klasörü

---

## Özelleştirme

Detaylı rehber için [USAGE.md](USAGE.md) dosyasına bakın.

- **Yeni agent ekle**: `.github/instructions/reference/agent-scaffolding.instructions.md`
- **Yeni skill ekle**: `.github/skills/[name]/SKILL.md`
- **Dağılımı değiştir**: `.github/instructions/reference/delegation-rules.instructions.md`
- **Proje bağlamı**: `.github/copilot-instructions.md`

---

## Skor Evrimi & Kalite Takibi

### Versiyon Yörüngesi

| Versiyon | Mimari | Operasyonel | Değişiklik Özeti | Durum |
|:--------:|:------:|:-----------:|------------------|:-----:|
| v4.0.1 | 9.0 | 9.3 | İlk stabil sürüm | ✅ |
| v4.4.0 | 9.5 | 9.5 | 16 fix | ✅ |
| v4.6.0 | 10.0 | 10.0 | PCD feature + 9 fix | ✅ |
| v4.7.0 | 10.0 | 10.0 | PEP feature | ✅ |
| v5.0.0 | 10.0 | 10.0 | Proje bağımsızlık | ✅ |
| v6.0.0 | 10.0 | 10.0 | Token optimizasyonu + reference/ migration | ✅ |
| v6.2.0 | 10.0 | 10.0 | Hook lifecycle otomasyon | ✅ |
| v6.3.0 | 10.0 | 10.0 | 38 bulgu düzeltmesi | ✅ |
| v7.0.0 | 10.0 | 10.0 | DAG, paralel review, templates, benchmarks | ✅ |
| v7.0.1 | 10.0 | 10.0 | Dinamik agent isimlendirme | ✅ |
| v7.1.0 | 10.0 | 10.0 | Tier yapısı 1-5 tam sayı refactoring + 15 bulgu | ✅ |
| v7.2.0 | 10.0 | 10.0 | Frontend güçlendirme (R18/19 + AntD 5/6) + sistem bulgu düzeltmeleri | ✅ |
| v7.3.0 | 10.0 | 10.0 | Token verimliliği katmanı: Caveman + Context Efficiency + Knowledge Graph | ✅ |

### Gelişim Skoru (Son Analiz: v7.3.0)

| Boyut | v6.0.0 | v6.3.0 | v7.0.0 | v7.0.1 | v7.1.0 | v7.2.0 | v7.3.0 |
|-------|:------:|:------:|:------:|:------:|:------:|:------:|:------:|
| Yapısal Bütünlük | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Dokümantasyon Tutarlılığı | 9.5 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Agent Tier Tasarımı | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Review Chain | 9.8 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Delegation Logic | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Token Optimizasyonu | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Hook Sistemi | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Genişletilebilirlik | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Session Memory | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Proje Bağlamı Keşfi (PCD) | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Prompt Zenginleştirme (PEP) | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Konfigürasyon Tutarlılığı | 8.5 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Hook Lifecycle Otomasyon | — | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Dinamik Naming Sistemi | — | — | — | 10.0 | 10.0 | 10.0 | **10.0** |
| Tier Yapısı Netliği | — | — | — | — | 10.0 | 10.0 | **10.0** |
| Frontend Versiyon Desteği | — | — | — | — | — | 10.0 | **10.0** |
| Token Verimliliği Modları | — | — | — | — | — | — | **10.0** |

### Analiz Metodolojisi

Her analiz döngüsü **x10 multi-agent** mode ile çalıştırılır:
- **3 Analyst** (T5): Yapı, cross-reference, dokümantasyon paralel analizi
- **1 Lead Analyst** (T4): Bulgu konsolidasyonu, de-duplikasyon, kalite kapısı
- **2 Principal** (T1): Mimari değerlendirme + operasyonel hazırlık skorlaması
- **2 Staff Engineer + 2 MidCoder** (T2, T3): Analiz döngülerinde idle — kodlama görevlerinde aktif

### Skor Hesaplama Yöntemi

Skorlar, her versiyonun **post-fix** durumunu yansıtır:
- Analiz → Bulgu tespiti → Düzeltme → Doğrulama → Skor atanır
- 10.0 = Tespit edilen tüm bulgular düzeltilmiş, 11/11 yapısal doğrulama PASS
- P0/P1 bulgu varsa düzeltilmeden skor 10.0 atanamaz

> _Son güncelleme: v7.3.0 — 2026-05-20_

---

## Lisans

GNU GPL v3 — Özgürce kullanın, değiştirin ve dağıtın. Değiştirilmiş versiyonlar da aynı lisansla açık kaynak olmalıdır.
