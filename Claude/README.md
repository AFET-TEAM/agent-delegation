# Multi-Agent Delegation System for Claude Code

> v1.0.0 — Turkcell Atmosware için geliştirilmiş, Claude Code üzerinde çalışan katmanlı multi-agent kod kalitesi sistemi

Bu sistem, karmaşık yazılım geliştirme görevlerini maliyet-bilinçli bir ajan hiyerarşisine dağıtır. Orkestratör görevi analiz eder ve DAG tabanlı paralel yürütme planı oluşturur; araştırma görevleri en ucuz modele (Haiku), implementasyon orta katmana (Sonnet), mimari kararlar ve final review en pahalı modele (Opus) delege edilir. Sistem 14 otomatik enforcement hook'u, 15 kodlama standardı dosyası ve oturumlar arası öğrenme mekanizması ile üretim kalitesinde kod üretir ve aynı hatayı bir daha yapmaz.

---

## Mimari

### Tier Yapısı

| Tier | Rol | Model | Token Bütçesi | Amaç |
|------|-----|-------|--------------|------|
| Orchestrator | Teknik Koordinatör | opus | Sınırsız | Koordinasyon, delegasyon — uygulama kodu yazmaz |
| T1 Principal | Baş Yazılım Mimarı | opus | ~80K | Mimari kararlar, final review, kalite kapısı |
| T2 Staff Engineer | Kıdemli Yazılım Mühendisi | sonnet | ~60K | Birincil implementasyon, T3 review |
| T3 MidCoder | Yazılım Geliştirici | sonnet | ~40K | Standart kodlama, API endpoint, boilerplate |
| T4 Lead Analyst | Kıdemli Sistem Analisti | haiku | ~25K | Analiz konsolidasyonu, T5 review |
| T5 Analyst | Sistem Analisti | haiku | ~15K | Codebase araştırması, ham analiz |

### xN Dağılım Tablosu

Mesajın sonuna eklenen `xN` parametresi multi-agent modunu aktive eder ve aşağıdaki ajan dağılımını tetikler:

| xN | T1 opus | T2 sonnet | T3 sonnet | T4 haiku | T5 haiku | Toplam |
|----|---------|-----------|-----------|----------|----------|--------|
| x2 | 1 | 0 | 0 | 0 | 1 | 2 |
| x3 | 1 | 1 | 0 | 0 | 1 | 3 |
| x4 | 1 | 1 | 1 | 0 | 1 | 4 |
| x5 | 1 | 1 | 1 | 1 | 1 | 5 |
| x7 | 1 | 2 | 1 | 1 | 2 | 7 |
| x10 | 2 | 2 | 2 | 2 | 2 | 10 |

Parametre eklenmezse tek-ajan modu çalışır: Orkestratör görevi doğrudan karşılar veya en uygun tek ajana delege eder.

---

## 4 Katmanlı Enforcement

### Katman 1: Hook Layer (Otomatik, Bypass Edilemez)

`.claude/settings.json`'a kayıtlı 14 shell script, her kod düzenlemesinde anında çalışır. `exit 2` döndüren hook düzenlemeyi bloklar — ajan ne isterse istesin, hook kuralını ihlal eden kod yazılamaz.

| Kategori | Hook Script | Engellediği |
|----------|-------------|-------------|
| Kod Kalitesi | `block-console-log.sh` | `console.log/warn/error/debug` |
| Kod Kalitesi | `block-any-type.sh` | TypeScript `any` tipi |
| Kod Kalitesi | `block-comments.sh` | Inline `//` ve block `/* */` yorumlar |
| Güvenlik | `secret-guard.sh` | Hardcoded API key, şifre, token |
| Güvenlik | `sql-injection-check.sh` | SQL string concatenation |
| Güvenlik | `xss-prevention-check.sh` | `innerHTML`, `dangerouslySetInnerHTML` |
| Güvenlik | `path-traversal-check.sh` | Kullanıcı girdisi ile dosya yolu yapımı |
| Güvenlik | `field-injection-check.sh` | `@Autowired` field injection |
| Güvenlik | `cors-wildcard-check.sh` | Wildcard CORS origin |
| UI Standartları | `figma-standards-guard.sh` | Hardcoded hex renk, `px` birim, inline style |
| Git Güvenliği | `git-safety-check.sh` | İzinsiz commit, push, merge |
| Kapsam Koruması | `analysis-scope-guard.sh` | T5/T4 dışı ajanların analiz dizinine yazması |
| Metrik | `review-tracker.sh` | Review sonuçlarını kayıt altına alır |
| Öğrenme | `self-learning-collector.sh` | Hata pattern'lerini `learned-patterns/`'a yazar |

### Katman 2: Rule Layer (Context ile Yüklenir)

`.claude/rules/` altındaki 15 standart dosya, ilgili ajan promptlarına context olarak eklenir. Kodlama standartları, mimari kurallar, test yazım kılavuzları ve güvenlik kontrol listeleri bu katmanda tanımlanır.

| Dosya | Kapsam |
|-------|--------|
| `clean-code.md` | SRP, DRY, KISS, fonksiyon/dosya boyut limitleri |
| `code-architecture.md` | Katmanlı mimari, SOLID, hexagonal yapı |
| `implementation.md` | TypeScript strict mode, hata yönetimi, test yazımı |
| `react-patterns.md` | React 19, AntD 6, hook kuralları |
| `backend-development.md` | Spring Boot, Node.js servis katmanı |
| `backend-security.md` | JWT, CORS, rate limiting, şifre politikası |
| `testing.md` | AAA pattern, test isimlendirme, mock stratejisi |
| `api-integration.md` | REST tasarımı, standart response formatı |
| `code-review.md` | Severity seviyeleri, review checklist |
| `java-quality-tooling.md` | Checkstyle, SpotBugs, JaCoCo eşikleri |
| `commit-standards.md` | Conventional commits, atomic commit kuralları |
| `pr-standards.md` | PR boyut limitleri, branch isimlendirme |
| `git-safety.md` | Git işlemleri için açık onay gerekliliği |
| `scss-standards.md` | BEM, design token kullanımı |
| `analysis.md` | T5 analiz raporu formatı |

### Katman 3: Review Chain (Ajan Tabanlı)

Her multi-agent oturumunda aşağıdaki sıralı review zinciri çalışır:

```
T5 Analyst çıktısı  → T4 Lead Analyst review eder
T3 MidCoder çıktısı → T2 Staff Engineer review eder
T2 Staff Engineer   → T1 Principal review eder
T1 Principal onayı  → Orchestrator konsolide eder
```

Review sonuçları: Approved / Revision Required (max 2 tur) / Rejected (üst tier devralır). xN değerine göre review zinciri azaltılır; x2'de T1 Principal T4 Lead Analyst rolünü de üstlenir.

### Katman 4: Self-Learning Layer (Oturumlar Arası Öğrenme)

Review'da reddedilen kod blokları ve hook ihlalleri `.claude/memory/learned-patterns/` altına hata pattern'i olarak kaydedilir. Her oturum başlangıcında bu pattern'ler (max 10 aktif dosya) ajan promptlarına "Dikkat Edilecek Noktalar" bölümü olarak enjekte edilir. 3+ kez tetiklenen pattern'ler kalıcı `.claude/rules/` kuralı adayı olarak işaretlenir.

---

## Maliyet Karşılaştırması

Sistem olmadan tüm işlemler ana oturumun (Opus model) context'inde sıralı yürür. Sistem ile araştırma Haiku'ya, implementasyon Sonnet'e, yalnızca review Opus'a taşınır; DAG tabanlı paralel yürütme duvar saati süresini 3-4x kısaltır.

| Metrik | Sistem Olmadan | Sistem İle | Fark |
|--------|---------------|------------|------|
| Örnek 10-görev projesi | ~$30 (10× Opus) | ~$8 (4 Haiku + 4 Sonnet + 2 Opus) | ~%73 tasarruf |
| Paralel yürütme | Sıralı | DAG tabanlı parallel | 3-4x hız artışı |
| Hata tespiti | PR review'ında (geç) | Hook'ta anında (ücretsiz) | Sıfır drift |
| Context kirliliği | Tek devasa context | Her agent izole context | Daha temiz thinking |
| Tekrarlayan hatalar | Her seferinde tekrar | Self-learning ile önlenir | Kümülatif iyileşme |

**Yaklaşık API fiyatları (2026):**
- Opus: ~$15/M input token, ~$75/M output token
- Sonnet: ~$3/M input token, ~$15/M output token
- Haiku: ~$0.80/M input token, ~$4/M output token

Tipik bir x5 oturumunda (1 T1 + 1 T2 + 1 T3 + 1 T4 + 1 T5): T4 ve T5 araştırma görevleri Haiku'da tüketilir (~$0.5), T2 ve T3 implementasyonu Sonnet'te (~$2), T1 final review Opus'ta (~$1.5). Tüm görevler Opus'ta yapılsaydı maliyet ~$12 olurdu.

---

## Sistem Sağlık Durumu

Genel Skor: **10/10** (Döngü 4, her döngüde güncellenir)

| Döngü | Tarih | Genel | Token | Context | Güvenlik | Tutarlılık | Doğruluk | Performans |
|-------|-------|-------|-------|---------|----------|------------|----------|------------|
| C1 (İlk Hali) | 2026-04-17 | 3.5/10 | 5 | 4 | 3 | 4 | 3 | 2 |
| C2 (P0+P1+P2) | 2026-04-17 | 8.5/10 | 8 | 8 | 9 | 9 | 9 | 8 |
| C3 (Derinlemesine) | 2026-04-18 | 9.5/10 | 9 | 9 | 10 | 10 | 10 | 9 |
| **C4 (Tier+Frontend)** | **2026-04-18** | **10/10** | **10** | **10** | **10** | **10** | **10** | **10** |

C4'te kapanan açıklar: T1.5/T2.5 → T1–T5 tam sayılı tier renaming (14 dosya + 6 ek artık), `_shared-sections.md` konsolidasyonu (~50 satır duplikasyon kaldırıldı), Context Gate mekanizması (T1–T3 template), x10 T4 bottleneck fix (T4:1→2), React 19 (use/useOptimistic/useActionState/useTransition async/ref-as-prop/Context-as-provider) + AntD 6.x (CSS Variables/breaking API değişiklikleri) desteği, README + usage-guide sıfırdan yeniden yazıldı.

---

## Dizin Yapısı

```
claude-code-saka/
├── CLAUDE.md                   # Orchestrator talimatları — tüm protokol buradadır
├── README.md                   # Bu dosya
└── .claude/
    ├── settings.json            # Hook kayıt dosyası; izin/engel listeleri
    ├── agents/                  # Agent prompt şablonları (7 dosya)
    │   ├── orchestrator.md
    │   ├── principal.md         # T1
    │   ├── staff-engineer.md    # T2
    │   ├── mid-coder.md         # T3
    │   ├── lead-analyst.md      # T4
    │   ├── analyst.md           # T5
    │   └── _shared-sections.md  # Ortak bölümler (tekrarı önler)
    ├── rules/                   # Kodlama standartları (15 dosya)
    ├── hooks/                   # Enforcement scripts (14 dosya)
    ├── config/                  # Sistem konfigürasyonu (6 dosya)
    │   ├── tier-definitions.md  # SSOT: tier-model eşlemesi, token bütçeleri
    │   ├── delegation-rules.md  # xN dağılım tabloları
    │   ├── context-budget.md    # Tier bazlı context limitleri
    │   ├── task-assignment-matrix.md  # Görev türü → tier eşlemesi
    │   ├── name-pool.md         # Dinamik ajan isimlendirme havuzu (20 isim)
    │   └── model-registry.md    # Model kullanım bağlamı
    ├── memory/
    │   ├── sessions/            # Oturum geçmişi; önceki bağlamı yükler
    │   └── learned-patterns/    # Review redlerinden öğrenilen hata pattern'leri
    ├── analysis/
    │   ├── raw/                 # T5 Analyst ham araştırma çıktıları
    │   └── consolidated/        # T4 Lead Analyst konsolide raporları
    ├── metrics/
    │   ├── agent-performance.md # Ajan bazlı görev başarı/başarısızlık takibi
    │   ├── token-usage.md       # Tier bazlı token tüketim analizi
    │   └── leaderboard.md       # İsim havuzu puanları; weighted random seçim
    ├── templates/               # Proje şablonları: react-spa, spring-boot, full-stack
    ├── todo/
    │   └── active-plan.md       # Aktif oturum görev planı; DAG ve dosya sahipliği
    └── docs/
        ├── usage-guide.md       # Türkçe kullanım kılavuzu ve SSS
        └── adr/                 # Architecture Decision Records
```

---

## Hızlı Başlangıç

### Gereksinimler

- Claude Code CLI (güncel sürüm)
- Anthropic API key

### Kurulum

Bu repodan `.claude/` dizinini ve `CLAUDE.md` dosyasını projenize kopyalayın, ardından Claude Code'u açın. Ek bir yapılandırma gerekmez; `settings.json` hook'ları otomatik devreye girer.

### Kullanım Örnekleri

**Basit görev (x2 — minimum, hızlı araştırma + mimari onay):**
```
Auth servisindeki token yenileme mantığını açıkla. x2
```
T1 Principal + T5 Analyst ile çalışır.

**Standart görev (x5 — önerilen, tam ekip):**
```
Kullanıcı profil sayfası ve avatar yükleme feature'ını implement et. x5
```
T1 + T2 + T3 + T4 + T5 ile çalışır. DAG Wave 1: T5 araştırma. Wave 2: T4 konsolidasyon. Wave 3: T2 + T3 paralel implementasyon. Wave 4: review zinciri.

**Büyük görev (x10 — maksimum, büyük sprint):**
```
Ödeme modülünü sıfırdan yaz: Stripe entegrasyonu, webhook handler, fatura yönetimi. x10
```
2×T1 + 2×T2 + 2×T3 + 2×T4 + 2×T5 ile çalışır. Dosya sahipliği DAG'da tanımlanır; her dosyaya tam olarak bir ajan atanır.

---

## Temel Konfigürasyon Dosyaları

| Dosya | Amaç |
|-------|------|
| `.claude/config/tier-definitions.md` | SSOT: tier-model eşlemesi, token bütçeleri |
| `.claude/config/delegation-rules.md` | xN dağılım tabloları ve reduced mode kuralları |
| `.claude/config/context-budget.md` | Tier başına context limitleri ve yükleme öncelikleri |
| `.claude/config/task-assignment-matrix.md` | Görev türü → hangi tier uygun eşlemesi |
| `.claude/config/name-pool.md` | 20 isimlik dinamik ajan isimlendirme havuzu |
| `.claude/config/model-registry.md` | Model kullanım bağlamı ve maliyet notları |
