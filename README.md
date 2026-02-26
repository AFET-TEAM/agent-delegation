# Multi-Agent Delegation System — v4.5.0

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
- **Otomatik Review Zinciri** — Alt tier'ın çıktısı üst tier tarafından review edilir
- **Maliyet Optimizasyonu** — Pahalı modeller yalnızca kritik görevlerde kullanılır
- **Model Fallback** — Model erişilemezse otomatik yedek modele geçiş
- **Session Memory** — Konuşma geçmişi ve kararlar otomatik kaydedilir
- **Token Optimizasyonu** — Paylaşılan kurallar, isteğe bağlı skill yükleme, 15K token bütçesi
- **Metrik Toplama** — Agent performansı ve token kullanımının otomatik takibi
- **Çakışma Önleme** — Dosya sahipliği ve kilit mekanizması ile güvenli paralel çalışma
- **Hazır Skill Dosyaları** — Mimari, kodlama, review, analiz ve backend için önceden tanımlı skill'ler
- **Slash Komutları** — `/delegate`, `/review`, `/status`, `/architect`, `/resume`, `/history`

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
     │      ││      ││      ││      ││ READ   │
     │WRITE ││WRITE ││WRITE ││ READ ││ ONLY   │
     │REVIEW││REVIEW││      ││ ONLY ││        │
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
│   │   ├── orchestrator.agent.md            # Koordinatör (Claude Opus 4.6)
│   │   ├── principal-alpha.agent.md         # T1: Mimari & kod (Claude)
│   │   ├── principal-beta.agent.md          # T1: Paralel mimari (Claude)
│   │   ├── staff-engineer-alpha.agent.md    # T1.5: Kodlama (Claude Sonnet)
│   │   ├── staff-engineer-beta.agent.md     # T1.5: Paralel kodlama (Sonnet)
│   │   ├── mid-coder-alpha.agent.md         # T2: Kodlama (GPT-5.3)
│   │   ├── mid-coder-beta.agent.md          # T2: Paralel kodlama (GPT-5.3)
│   │   ├── lead-analyst.agent.md            # T2.5: Analyst review (Gemini Pro)
│   │   ├── analyst-alpha.agent.md           # T3: Analiz (Gemini 3 Flash)
│   │   ├── analyst-beta.agent.md            # T3: Güvenlik/perf (Gemini)
│   │   └── analyst-gamma.agent.md           # T3: Test/doküman (Gemini)
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
│   │   └── analysis/SKILL.md               # T2.5, T3: Analiz şablonları
│   ├── instructions/
│   │   ├── clean-code-standards.instructions.md
│   │   ├── tier1-principal.instructions.md
│   │   ├── tier1-5-staff-engineer.instructions.md
│   │   ├── tier2-mid.instructions.md
│   │   ├── tier2-5-lead-analyst.instructions.md
│   │   ├── tier3-analyst.instructions.md
│   │   ├── review-chain.instructions.md
│   │   ├── delegation-rules.instructions.md
│   │   ├── model-fallback.instructions.md
│   │   ├── shared-base.instructions.md
│   │   ├── context-loading.instructions.md
│   │   ├── task-planning.instructions.md
│   │   ├── session-memory.instructions.md
│   │   ├── system-validation.instructions.md
│   │   └── agent-scaffolding.instructions.md
│   ├── prompts/
│   │   ├── delegate.prompt.md
│   │   ├── review.prompt.md
│   │   ├── status.prompt.md
│   │   ├── architect.prompt.md
│   │   ├── resume.prompt.md
│   │   └── history.prompt.md
│   ├── todo/
│   │   ├── _template.md
│   │   └── active-plan.md
│   ├── memory/
│   │   ├── sessions/
│   │   │   └── _session-template.md
│   │   └── history/
│   │       ├── archive.md
│   │       └── refaktor-v4.0.0.md              # Arşivlenmiş v4.0.0 refaktör notları
│   ├── metrics/
│   │   ├── agent-performance.md             # Agent başarı ve maliyet metrikleri
│   │   └── token-usage.md                   # Token tüketim kalibrasyon logları
│   ├── hooks/
│   │   ├── agent-lifecycle.json
│   │   └── safety-guard.json
│   ├── docs/
│   │   └── adr/
│   │       └── ADR-001-platform-boundary.md  # Platform bağımlılık kararları
│   └── logs/
│       └── .gitkeep
├── .gitignore                               # Git dışlama kuralları
├── .vscode/
│   └── settings.json                       # VS Code yapılandırması
├── AGENTS.md                                # Global agent kuralları
├── CHANGELOG.md                             # Değişiklik takibi
├── LICENSE                                  # GNU GPL v3
├── USAGE.md                                 # Detaylı kullanım kılavuzu
└── README.md                                # Bu dosya
```

---

## Slash Komutları

| Komut                   | Açıklama                              |
| ----------------------- | ------------------------------------- |
| `/delegate [görev] xN`  | Multi-agent delegasyon                |
| `/review [dosya/dizin]` | Manuel review zinciri                 |
| `/status`               | Delegasyon durumu                     |
| `/architect [görev]`    | Doğrudan mimari görev                 |
| `/resume`               | Son session ve aktif planı geri yükle |
| `/history`              | Son session'ları listele (onboarding) |

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

- **Yeni agent ekle**: `.github/instructions/agent-scaffolding.instructions.md` rehberine uyarak yeni agent oluşturun
- **Yeni skill ekle**: `.github/skills/[name]/SKILL.md`
- **Dağılımı değiştir**: `.github/instructions/delegation-rules.instructions.md`
- **Proje bağlamını güncelle**: `.github/copilot-instructions.md`

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

### Gelişim Skoru (Son Analiz: v4.5.0)

| Boyut | v4.3.0 | v4.4.0 | v4.5.0 |
|-------|:------:|:------:|:------:|
| Yapısal Bütünlük | 9.1 | 9.5 | **9.7** |
| Dokümantasyon Tutarlılığı | 8.8 | 9.4 | **9.5** |
| Agent Tier Tasarımı | 9.3 | 9.6 | **9.7** |
| Review Chain | 9.5 | 9.6 | **9.6** |
| Delegation Logic | 9.4 | 9.6 | **9.6** |
| Token Optimizasyonu | 9.0 | 9.5 | **9.7** |
| Hook Sistemi | 9.0 | 9.4 | **9.4** |
| Genişletilebilirlik | 8.8 | 9.1 | **9.5** |
| Session Memory | 9.3 | 9.5 | **9.5** |

### Analiz Metodolojisi

Her analiz döngüsü **x10 multi-agent** mode ile çalıştırılır:
- **3 Analyst** (T3): Yapı, cross-reference, dokümantasyon paralel analizi
- **1 Lead Analyst** (T2.5): Bulgu konsolidasyonu, de-duplikasyon, kalite kapısı
- **2 Principal** (T1): Mimari değerlendirme + operasyonel hazırlık skorlaması
- **2 Staff Engineer + 2 MidCoder** (T1.5, T2): Analiz döngülerinde idle — kodlama görevlerinde aktif

> _Son güncelleme: v4.5.0 — 2026-02-24_
