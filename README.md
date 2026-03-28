# Multi-Agent Delegation System — v7.0.1

> AI agent'larını bir takım gibi organize eden, görevleri maliyet ve yetkinlik bazında dağıtan orkestrasyon boilerplate'i.

[![VS Code](https://img.shields.io/badge/VS%20Code-1.109%2B-blue)](https://code.visualstudio.com/)
[![Copilot](https://img.shields.io/badge/GitHub%20Copilot-Required-green)](https://github.com/features/copilot)
[![License](https://img.shields.io/badge/License-GPLv3-yellow)](LICENSE)

---

## Nedir?

Bu boilerplate, VS Code'un yerel agent mekanizmasını kullanarak birden fazla AI modelini bir ekip gibi çalıştırır. Bir prompt verdiğinizde, sistem görevi analiz eder, alt-görevlere böler ve her birini en uygun (ve en maliyet-etkin) AI modeline dağıtır.

### Temel Özellikler

- **5 Tier Agent Hiyerarşisi** — Mimari (Claude), Kodlama (Sonnet/GPT), Analiz (Gemini)
- **xN Delegasyon** — Prompt sonuna `x7` ekle, 7 agent çalışsın
- **Proje Bağlamı Keşfi (PCD)** — Hedef projenin README, .md dosyaları ve docs/ klasörünü otomatik tarar ve sistem bağlamı olarak kullanır
- **Prompt Zenginleştirme Protokolü (PEP)** — Geliştirmeye başlamadan önce hedefli sorular sorar, detaylı plan oluşturur, onay alır
- **Otomatik Review Zinciri** — Alt tier'ın çıktısı üst tier tarafından review edilir
- **Maliyet Optimizasyonu** — Pahalı modeller yalnızca kritik görevlerde kullanılır
- **Model Fallback** — Model erişilemezse otomatik yedek modele geçiş
- **Session Memory** — Konuşma geçmişi ve kararlar otomatik kaydedilir
- **Token Optimizasyonu** — Paylaşılan kurallar, isteğe bağlı skill yükleme, 15K token bütçesi
- **Metrik Toplama** — Agent performansı ve token kullanımının otomatik takibi
- **Çakışma Önleme** — Dosya sahipliği ve kilit mekanizması ile güvenli paralel çalışma
- **Java/Spring Boot Standartları** — Backend güvenlik, kalite araçları (Checkstyle, SpotBugs, JaCoCo) skill'leri
- **Frontend-Backend Entegrasyon Kontratı** — API response formatı, pagination, tarih/saat, hata yönetimi standartları
- **Git Güvenlik Kuralları** — AI agent'ların git operasyonları için zorunlu onay mekanizması
- **13 Hazır Skill Dosyası** — Mimari, kodlama, review, analiz, backend, güvenlik, kalite araçları ve frontend-backend kontrat skill'leri (core/extended split desteğiyle)
- **Dinamik Skill Discovery** — Skill dosyalarındaki `tiers:` YAML metadata ile tier bazlı otomatik skill keşfi
- **DAG Tabanlı Görev Bağımlılık Grafiği** — Orchestrator'ın bağımlılık analizi ile execution wave'leri oluşturması
- **Paralel Review Protokolü** — Farklı modüllerin review'larının eşzamanlı yürütülmesi
- **Agent Performance Benchmark** — Görev başarı oranı, revision round ve token verimliliği ölçüm framework'ü
- **Multi-Session Continuity** — Context snapshot'ları ile session geçişlerinde bağlam korunması
- **Proje Şablonları** — React SPA, Spring Boot ve Full-Stack için hazır proje şablonları
- **Slash Komutları** — `/delegate`, `/review`, `/status`, `/architect`, `/resume`, `/history`, `/create-agent`

---

## Hızlı Başlangıç

### 1. Kurulum

```bash
# Bu repo'yu klonlayın veya ilgili dosyaları projenize kopyalayın
git clone <repo-url> agentDelegation

# Projenize taşıyın
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
         │  Koordinasyon      │
         └──┬───┬───┬───┬───┬┘
            │   │   │   │   │
     ┌─────▼┐┌─▼───┐┌▼────┐┌▼─────┐┌▼──────┐
     │Tier 1││Tier  ││Tier 2││Tier   ││Tier 3  │
     │      ││1.5   ││      ││2.5   ││        │
     │Claude││Claude││GPT   ││Gemini││Gemini  │
     │Opus  ││Sonnet││5.3   ││3.1   ││3 Flash │
     │4.6   ││4.6   ││Codex ││Pro   ││        │
     │      ││      ││      ││      ││ SCOPED │
     │WRITE ││WRITE ││WRITE ││SCOPED││ WRITE  │
     │REVIEW││REVIEW││      ││WRITE ││        │
     └──────┘└──────┘└──────┘└──────┘└────────┘
       $$$$$   $$$$    $$$     $$       $

  Review: Tier3 → Tier2.5 review
          Tier2 → Tier1.5 review
          Tier1.5 → Tier1 review
```

### Agent Dağılımı

| Parametre |     Principal (T1)     | Staff Eng (T1.5) | MidCoder (T2) | Lead Analyst (T2.5) | Analyst (T3) |
| --------- | :--------------------: | :--------------: | :-----------: | :-----------------: | :----------: |
| _yok_     | Tek agent (varsayılan) |        —         |       —       |          —          |      —       |
| `x3`      |           1            |        1         |       0       |          0          |      1       |
| `x5`      |           1            |        1         |       1       |          1          |      1       |
| `x7`      |           1            |        2         |       1       |          1          |      2       |
| `x10`     |           2            |        2         |       2       |          1          |      3       |

---

## Dosya Yapısı

```
your-project/
├── .github/
│   ├── copilot-instructions.md              # Always-on proje bağlamı
│   ├── agents/
│   │   ├── orchestrator.agent.md            # Koordinatör — Varol Maksutoğlu (Claude Opus 4.6)
│   │   ├── principal-alpha.agent.md         # T1: Baş Yazılım Mimarı — PrincipalAlpha (Claude)
│   │   ├── principal-beta.agent.md          # T1: Kıdemli Yazılım Mimarı — PrincipalBeta (Claude)
│   │   ├── staff-engineer-alpha.agent.md    # T1.5: Kıdemli Müh. — StaffEngineerAlpha (Sonnet)
│   │   ├── staff-engineer-beta.agent.md     # T1.5: Yazılım Müh. — StaffEngineerBeta (Sonnet)
│   │   ├── mid-coder-alpha.agent.md         # T2: Geliştirici — MidCoderAlpha (GPT-5.3)
│   │   ├── mid-coder-beta.agent.md          # T2: Geliştirici — MidCoderBeta (GPT-5.3)
│   │   ├── lead-analyst.agent.md            # T2.5: Kıdemli Sistem Analisti — LeadAnalyst (Gemini 3.1 Pro (Preview))
│   │   ├── analyst-alpha.agent.md           # T3: Analist — AnalystAlpha (Gemini Flash)
│   │   ├── analyst-beta.agent.md            # T3: Analist — AnalystBeta (Gemini Flash)
│   │   └── analyst-gamma.agent.md           # T3: Analist — AnalystGamma (Gemini Flash)
│   ├── skills/
│   │   ├── clean-code/SKILL.md              # Tüm kodlama + T2.5 (awareness): Kod hijyeni
│   │   ├── code-architecture/SKILL.md       # T1: Mimari rehber
│   │   ├── code-review/SKILL.md             # T1, T1.5, T2, T2.5: Review
│   │   ├── commit-standards/SKILL.md        # T1, T1.5, T2: Commit formatı
│   │   ├── frontend-development/SKILL.md    # T1, T1.5, T2: Frontend rehber
│   │   ├── backend-development/SKILL.md     # T1, T1.5, T2: Backend rehber
│   │   ├── implementation/SKILL.md          # T1, T1.5, T2: Kodlama standartları
│   │   ├── pr-standards/SKILL.md            # T1, T1.5, T2: PR standartları
│   │   ├── testing-standards/SKILL.md       # T1, T1.5, T2: Test standartları
│   │   ├── analysis/SKILL.md               # T2.5, T3: Analiz şablonları
│   │   ├── backend-security/SKILL.md        # T1, T1.5: Spring Boot güvenlik standartları
│   │   ├── java-quality-tooling/SKILL.md    # T1, T1.5, T2: Maven kalite araçları
│   │   └── api-integration/SKILL.md         # T1, T1.5, T2: Frontend-backend kontrat
│   ├── instructions/
│   │   ├── clean-code-standards.instructions.md   # Universal (auto-loaded)
│   │   ├── shared-base.instructions.md            # Universal (auto-loaded)
│   │   ├── git-safety.instructions.md             # Universal (auto-loaded)
│   │   └── reference/                             # Reference docs (NOT auto-loaded)
│   │       ├── tier1-principal.instructions.md
│   │       ├── tier1-5-staff-engineer.instructions.md
│   │       ├── tier2-mid.instructions.md
│   │       ├── tier2-5-lead-analyst.instructions.md
│   │       ├── tier3-analyst.instructions.md
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
│   ├── todo/
│   │   ├── _template.md
│   │   └── active-plan.md
│   ├── memory/
│   │   ├── sessions/
│   │   │   └── _session-template.md
│   │   └── history/
│   │       └── archive.md
│   ├── config/
│   │   ├── checkstyle.xml                   # Checkstyle kuralları
│   │   ├── spotbugs-exclude.xml             # SpotBugs istisnalar
│   │   ├── pom-quality-plugins.xml.template # Maven kalite plugin şablonu
│   │   └── name-pool.md                     # 20 isimlik dinamik isimlendirme havuzu
│   ├── metrics/
│   │   ├── agent-performance.md             # Agent başarı ve maliyet metrikleri
│   │   ├── token-usage.md                   # Token tüketim kalibrasyon logları
│   │   └── leaderboard.md                   # Dinamik isimlendirme skor sıralaması
│   ├── hooks/
│   │   ├── agent-lifecycle.json              # Agent kimlik banner'ı + session yönetimi
│   │   ├── safety-guard.json                 # Read-only koruma + edit audit log
│   │   ├── review-enforcer.json              # Otomatik review döngüsü takibi
│   │   ├── context-guard.json                # Context/skill bütçe kontrolü
│   │   └── post-dev-analysis.json            # Post-development otomatik analiz tetikleme
│   ├── templates/
│   │   ├── react-spa.md                      # React SPA proje şablonu
│   │   ├── spring-boot.md                    # Spring Boot proje şablonu
│   │   └── full-stack.md                     # Full-stack proje şablonu
│   ├── docs/
│   │   └── adr/
│   │       ├── ADR-001-platform-boundary.md  # Platform bağımlılık kararları
│   │       └── ADR-002-analyst-write-permission.md  # Analyst scoped write izni
│   ├── analysis/
│   │   ├── raw/                               # T3 Analyst ham raporları
│   │   │   └── .gitkeep
│   │   └── consolidated/                      # T2.5 Lead Analyst konsolide raporları
│   │       └── .gitkeep
│   └── logs/
│       └── .gitkeep
├── .gitignore                               # Git dışlama kuralları
├── .vscode/
│   ├── settings.json                       # VS Code yapılandırması
│   └── mcp.json                            # MCP server yapılandırması (disabled)
├── AGENTS.md                                # Global agent kuralları
├── CHANGELOG.md                             # Değişiklik takibi
├── LICENSE                                  # GNU GPL v3
├── PROGRESS.md                              # Geliştirme yol haritası ve mevcut durum
├── USAGE.md                                 # Detaylı kullanım kılavuzu
└── README.md                                # Bu dosya
```

---

## Slash Komutları

| Komut                   | Açıklama                              |
| ----------------------- | ------------------------------------- |
| `/delegate [görev] xN`  | Multi-agent delegasyon                |
| `/review [dosya/dizin]` | Manuel review zinciri                 |
| `/status`               | Delegasyon durumu + context dashboard |
| `/architect [görev]`    | Doğrudan mimari görev                 |
| `/resume`               | Son session ve aktif planı geri yükle |
| `/history`              | Son session'ları listele (onboarding) |
| `/create-agent [ad] [tier]` | Yeni agent scaffold'u oluştur     |

---

## Maliyet Optimizasyonu

| Model                    | Maliyet | Kullanım                 |
| ------------------------ | ------- | ------------------------ |
| Claude Opus 4.6          | $$$$$   | Yalnızca mimari + review |
| Claude Sonnet 4.6        | $$$$    | Kodlama görevleri (T1.5) |
| GPT-5.3-Codex            | $$$     | Kodlama görevleri (T2)   |
| Gemini 3.1 Pro (Preview) | $$      | Analyst review (T2.5)    |
| Gemini 3 Flash           | $       | Analiz + araştırma       |

> **x7 ile tahmini ~%60 tasarruf** — tüm görevler en pahalı modelde yapılsaydı kıyasla.

---

## Özelleştirme

Detaylı özelleştirme rehberi için [USAGE.md](USAGE.md) dosyasına bakın.

- **Yeni agent ekle**: `.github/instructions/reference/agent-scaffolding.instructions.md` rehberine uyarak yeni agent oluşturun
- **Yeni skill ekle**: `.github/skills/[name]/SKILL.md`
- **Dağılımı değiştir**: `.github/instructions/reference/delegation-rules.instructions.md`
- **Proje bağlamını güncelle**: `.github/copilot-instructions.md`
- **Proje Bağlamı Keşfi (PCD)**: Boilerplate'i bir projeye kopyaladığınızda, projenin kök dizinindeki `README.md`, diğer `.md` dosyaları ve `docs/` klasörü otomatik olarak taranır ve sistem bağlamı olarak kullanılır. Detaylar: `.github/instructions/reference/project-context-discovery.instructions.md`
- **Prompt Zenginleştirme (PEP)**: Non-trivial geliştirme görevlerinde Orchestrator otomatik olarak soru sorar, gereksinim netleştirir ve detaylı plan oluşturur. Detaylar: `.github/instructions/reference/prompt-enrichment.instructions.md`

---

## Lisans

GNU GPL v3 — Özgürce kullanın, değiştirin ve dağıtın. Değiştirilmiş versiyonlar da aynı lisansla açık kaynak olmalıdır.

---

## Skor Evrimi & Kalite Takibi

> Bu bölüm her analiz döngüsü sonrasında güncellenir. Sistemin kalite yolculuğunu takip eder.

### Versiyon Yörüngesi

| Versiyon | Mimari | Operasyonel | Fix Sayısı | Durum |
|:--------:|:------:|:-----------:|:----------:|:-----:|
| v4.0.1 | 9.0 | 9.3 | 12 | ✅ Production-ready |
| v4.3.0 | 9.0 | 9.0 | 8 fix (3 P1 + 5 P2) | ✅ Production-ready |
| v4.4.0 | 9.5 | 9.5 | 16 fix (1 P0 + 3 P1 + 8 P2 + 4 P3) | ✅ Production-ready |
| v4.5.0 | 9.7 | 9.5 | Scripts→Instructions migration + 5 fix | ✅ Production-ready |
| v4.6.0 | 10.0 | 10.0 | PCD feature + 9 fix (1 P0 + 6 P1 + 2 P2) | ✅ Production-ready |
| v4.7.0 | 10.0 | 10.0 | PEP feature + PCD integration | ✅ Production-ready |
| v4.8.0 | 10.0 | 10.0 | Rules entegrasyonu + 3 yeni skill + 3 skill update + 2 yeni instruction | ✅ Production-ready |
| v4.9.0 | 10.0 | 10.0 | 12 fix (7 P1 + 4 P2 + 1 P3) — tier skill mapping + token overhead + docs | ✅ Production-ready |
| v5.0.0 | 10.0 | 10.0 | Proje bağımsızlık — proje-specific skill kaldırıldı + 6 fix (1 P1 + 3 P2 + 2 P3) | ✅ Production-ready |
| v6.0.0 | 10.0 | 10.0 | Türkçe agent isimleri + token optimizasyonu (16 instruction → reference/) + isim güncellemeleri | ✅ Production-ready |
| v6.1.0 | 10.0 | 10.0 | 15 bulgu düzeltmesi (5 P1 + 5 P2 + 5 P3) — review chain + Java config + token docs + Orchestrator | ✅ Production-ready |
| v6.2.0 | 10.0 | 10.0 | Hook lifecycle otomasyon (4 hook) + agent identity banner + safety-guard fix | ✅ Production-ready |
| v6.2.1 | 10.0 | 10.0 | 12 bulgu düzeltmesi (2 P0 + 3 P1 + 4 P2 + 3 P3) — shell quoting + terminal guard + log rotation + sanitization | ✅ Production-ready |
| v6.2.2 | 10.0 | 10.0 | 10 bulgu (1 P1 + 8 P2 + 1 P3) — run_in_terminal PostToolUse + applyTo removal + doc accuracy + counter validation | ✅ Production-ready |
| v6.3.0 | 10.0 | 10.0 | 28+10 bulgu — delete_file hook + scaffolding path fix + token recalibration + skill used-by + ApiResponse alignment + platform limitations documented | ✅ Production-ready |
| v6.4.0 | 10.0 | 10.0 | 20+ bulgu — stale refs fix + skill conflict resolution + instruction table fixes + score methodology + doc accuracy | ✅ Production-ready |
| v7.0.0 | 10.0 | 10.0 | 10 roadmap görevi + 8 gap fix — DAG, paralel review, templates, /create-agent, benchmarks, core/extended split, context snapshots, dynamic skill discovery | ✅ Production-ready |
| v7.0.1 | 10.0 | 10.0 | Dinamik agent isimlendirme sistemi — 234+ hardcoded isim → role-based ID, name pool, leaderboard, merit-based selection, post-dev analysis hook | ✅ Production-ready |

### Gelişim Skoru (Son Analiz: v7.0.1)

| Boyut | v4.3.0 | v4.4.0 | v4.5.0 | v4.6.0 | v4.7.0 | v4.8.0 | v4.9.0 | v5.0.0 | v6.0.0 | v6.1.0 | v6.2.0 | v6.3.0 | v7.0.0 | v7.0.1 |
|-------|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|
| Yapısal Bütünlük | 9.1 | 9.5 | 9.7 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Dokümantasyon Tutarlılığı | 8.8 | 9.4 | 9.5 | 10.0 | 10.0 | 9.2 | 10.0 | 9.5 | 9.5 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Agent Tier Tasarımı | 9.3 | 9.6 | 9.7 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Review Chain | 9.5 | 9.6 | 9.6 | 10.0 | 10.0 | 10.0 | 10.0 | 9.8 | 9.8 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Delegation Logic | 9.4 | 9.6 | 9.6 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Token Optimizasyonu | 9.0 | 9.5 | 9.7 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Hook Sistemi | 9.0 | 9.4 | 9.4 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Genişletilebilirlik | 8.8 | 9.1 | 9.5 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Session Memory | 9.3 | 9.5 | 9.5 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Proje Bağlamı Keşfi (PCD) | — | — | — | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Prompt Zenginleştirme (PEP) | — | — | — | — | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Konfigürasyon Tutarlılığı | — | — | — | — | — | — | — | 8.5 | 8.5 | 10.0 | 10.0 | 10.0 | 10.0 | **10.0** |
| Hook Lifecycle Otomasyon | — | — | — | — | — | — | — | — | — | — | 10.0 | 10.0 | 10.0 | **10.0** |
| Dinamik Naming Sistemi | — | — | — | — | — | — | — | — | — | — | — | — | — | **10.0** |

### Analiz Metodolojisi

Her analiz döngüsü **x10 multi-agent** mode ile çalıştırılır:
- **3 Analyst** (T3): Yapı, cross-reference, dokümantasyon paralel analizi
- **1 Lead Analyst** (T2.5): Bulgu konsolidasyonu, de-duplikasyon, kalite kapısı
- **2 Principal** (T1): Mimari değerlendirme + operasyonel hazırlık skorlaması
- **2 Staff Engineer + 2 MidCoder** (T1.5, T2): Analiz döngülerinde idle — kodlama görevlerinde aktif

### Skor Hesaplama Yöntemi

Skorlar, her versiyonun **post-fix (düzeltme sonrası)** durumunu yansıtır:
- Analiz → Bulgu tespiti → Düzeltme → Doğrulama → Skor atanır
- 10.0 = Tespit edilen tüm bulgular düzeltilmiş, 11/11 yapısal doğrulama PASS
- P0/P1 bulgu varsa düzeltilmeden skor 10.0 atanamaz
- P2/P3 bulgular düzeltilmeden skor ≤ 9.5 kalır

> _Son güncelleme: v7.0.1 — 2026-03-28_
