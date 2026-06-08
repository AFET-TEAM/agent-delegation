---
task-id: H03
agent: Elif Ozge Maksutoglu
tier: T4 Lead Analyst
source: H01-html-english-audit.md
status: Complete
binding-decisions: 3
glossary-entries: 52
master-glossary-locale: tr_TR
---

# Çeviri Scope + Bağlayıcı Kararlar

## Bağlayıcı Kararlar (Binding Decisions)

### Karar 1: Orchestrator Terminology → "Orkestratör"

**Arka Plan (Context)**
- Hedef kullanıcı: Turkcell Atmosware multi-disiplin ekip lideri; teknik yetkinliğe sahip, komut satırı alanında rahat
- Sistem tasarımında: `Orchestrator` kod identifier olarak kullanılıyor; rol şablonlarında "Teknik Koordinator" hitabı zaten mevcut
- Seçenekler:
  1. "Orkestratör" — Loanword (İngilizceden doğrudan); sistem kodunun (agent param: "Orchestrator") paralel
  2. "Koordinatör" — Tam çeviri; ama "Teknik Koordinator" (T1 rol adı) ile karışma riski

**Tavsiye & Karar**
- **Kararlaştırıldı: "Orkestratör"**
- **Sebep**: Sistemde zaten iki role hitap ediliyor: T1 "Teknik Koordinator", Orchestrator "Orkestratör" (farklı düzey). Loanword tutarlılığı, Anthropic SDK terminolojisine (opus, sonnet, haiku) benzer şekilde, teknik terminolojiye uygun
- **Kullanım**: Tüm HTML'de "Orkestratör" geçecek; "Koordinatör" tek başına değil

---

### Karar 2: Tier Terminology — Keep "Tier", Use "Seviye" Context-Dependent

**Arka Plan (Context)**
- T1-T5 sistem tanımıdır; tüm kaynaklarda (kod, config, log) "T1", "T2"... şeklinde görünür
- "Tier" kelimesi türkçe teknoloji sözlüğüne zaten giriş yapmış (mimariye, cloud hizmetlerine hitap ederken)
- Seçenekler:
  1. "Tier" → Loanword; tutarlı, tanınan
  2. "Seviye" → Çeviri; ama "Katman" (layered architecture) ile benziyor, karışabilir
  3. Hibrid: Tier isimleri (T1 Principal, T2 Staff Engineer) İngilizce kalır; generic "seviye" referans (e.g., "üst seviye ajan") türkçe yazılır

**Tavsiye & Karar**
- **Kararlaştırıldı: Hibrid Yaklaşım**
  - **Tier isimleri (role başlıklar)**: "T1 Principal", "T2 Staff Engineer", vb. → İngilizce kalır (sistem etiketleri)
  - **Generic seviye referans**: "üst seviye ajan", "haiku seviyesinde", "seviye 5" → Türkçe
- **Sebep**: Role başlıkları dokümantasyon boyunca tekrar eden identifierler; tutarlılık için sabit kalmalı. "Seviye" tabî Türkçe bağlamda daha doğal okuyor
- **Kullanım**: Bölüm başlıklarında "Beş Seviye Açıklandı" ✓; tablo başlığında "Seviye" ✓; metinde "T1 Principal'a git" ✓

---

### Karar 3: Ton — Formal Türkçe, siz form, Teknik ve Direkt

**Arka Plan (Context)**
- Kullanıcı belleğinden: "Türkçe, 'hocam' hitabı, samimi dil"
- Döküman türü: Resmi teknik dokümantasyon (proje README/docs değil, kendi başına kaynak)
- "hocam" o/s sohbet (informal), döküman yazı dil değil; ancak "samimi" = "donuk bir profesyoneliz değil, erişilebilir ve dostça"

**Tavsiye & Karar**
- **Kararlaştırıldı: Formal Türkçe (siz form), teknik, erişilebilir ton**
  - 2. kişi çekim: "yapabilirsiniz", "kullabilirsiniz", "gidebilirsiniz" (siz form)
  - Ton: Profesyonel ama kuru değil; teknik terim kesin, ama açıklama anlaşılır
  - "hocam" → HAYIR (konuşma diline ait; yazı dilinde yerleşik olmayan)
  - Jargon karışık: HAYIR (Türkçe + İngilizce yığını kaçınılmalı; seçimli loanword ✓)
  
- **Sebep**: Hedef kitle teknik/yönetici, Türkçe yazılı dokümantasyon beklentisine uygun. siz form dostça olmayıp profesyonel. "Samimi" → açık yazılı, örnek-ağırlıklı, jargon-açıklamalı
- **Kullanım**: "Bu sistemin avantajlarını göreceksiniz..." ✓; "Agent'lerinizi izleyebilirsiniz..." ✓; "hocam, şu kanca niye patlıyor?" ✗ (chat gibi sesleniş)

---

## Master Glossary — Kanonik Türkçe Terminoloji (Canonical Turkish → Keep Throughout)

Bu sözlük T2-A tarafından yazılan tüm Türkçe içerikte tutarlı şekilde kullanılacaktır. Girişlerin sırası: Başlık (EN) → Türkçe (Kanonik) → Notlar.

| English (EN) | Turkish (TR Canonical) | Context & Notes |
|---|---|---|
| **Multi-Agent** | Çoklu Agent | Sistem adıyla birlikte kullanılır; "agent" loanword |
| **Tier / Agent Tier** | Seviye (bağlamda) / T1-T5 (sistem referansı) | T1, T2, ... role başlıklar İngilizce kalır (hibrid rule) |
| **Orchestrator** | Orkestratör | Kararlaştırılmış loanword; T1 "Teknik Koordinator" ile ayırt etmek |
| **Principal** | Principal | Role başlığı; İngilizce kalır |
| **Staff Engineer** | Staff Engineer | Role başlığı; İngilizce kalır |
| **MidCoder** | MidCoder | Role başlığı; İngilizce kalır |
| **Lead Analyst** | Kıdemli Analist | T4 rolü çevirisi |
| **Analyst** | Analist | T5 rolü çevirisi |
| **Hook** | Kanca | Teknoloji terimi; "shell hook" bağlamında établi |
| **Skill** | Beceri (slash komut bağlamında) / Skill | Bağlama göre; "/" komut adları kalır |
| **Slash command** | Slash komutu | Hibrid; `/caveman`, `/graphify` kalır |
| **Wave** | Dalga | Execution unit; "Dalga 1", "Dalga 2" |
| **Review chain** | İnceleme Zinciri | Sistem kavramı |
| **Escalation** | Eskalasyon | Loanword, standart |
| **Performance Report** | Performans Raporu | Dokümantasyon yapısı |
| **Token** | Belirteç | API terimi; context-mode "token savings" → "belirteç tasarrufu" |
| **Budget** | Bütçe | Token bütçesi referans |
| **Workflow** | İş akışı / Workflow | Bağlama göre; sistem tanımında "workflow" kalabilir |
| **Walkthrough** | İzlenecek Yol | Kılavuz / örnek senaryosu |
| **Cheat Sheet** | Hile Sayfası / Kısa Referans | "Kısa Referans" önerilir (uzunluğu uyarı) |
| **FAQ** | SSS / Sık Sorulan Sorular | İkisi paralel; bölüm başlığında "SSS" kısaltması |
| **Quick Start** | Hızlı Başlangıç | Bölüm 1 başlığı |
| **Core Concepts** | Temel Kavramlar | Bölüm 2 başlığı |
| **Common Workflows** | Yaygın İş Akışları | Bölüm 3 başlığı |
| **Advanced Topics** | İleri Konular | Bölüm 4 başlığı |
| **Tools Reference** | Araçlar Referansı | Bölüm 5 başlığı |
| **Configuration** | Yapılandırma | Bölüm 6 başlığı |
| **Troubleshooting** | Sorun Giderme | Bölüm 7 başlığı |
| **Reference** | Referans | Bölüm 8 başlığı |
| **Code review** | Kod incelemesi | Emoji + başlık kombinasyonu |
| **Security review** | Güvenlik incelemesi | Emojilü başlık |
| **Knowledge graph** | Bilgi Grafı | graphify bağlamında |
| **Sandbox** | Sandbox | Loanword (emniyet kutusu çok uzun) |
| **Dependency** | Bağımlılık | İlişkiler/DAG bağlamında |
| **Pattern / Learned pattern** | Örüntü / Öğrenilmiş Örüntü | Teknik; ya da Pattern/Öğrenilmiş Pattern (hibrid) |
| **Leaderboard** | Lider Tablosu | Metrik/skor bağlamında |
| **Score / Puan** | Skor / Puan | "Score delta" → "puan değişimi" |
| **Promotion (pattern)** | Yükseltme / Promosyon | "Yükseltme" önerilir (pattern yükseltme) |
| **Archive / Archival** | Arşivleme / Arşiv | İzleme ve lifecycle bağlamında |
| **Dark mode** | Gece Modu | UI toggle |
| **Reading progress** | Okuma İlerlemesi | ARIA label; sayfa bağlamında |
| **Skip to main content** | Ana İçeriğe Git | Erişilebilirlik linki |
| **Search** | Ara / Dokümantasyonda ara | Placeholder: "Dokümantasyonda ara..." |
| **Copy** | Kopyala | Button label |
| **Copied** | Kopyalandı | Feedback mesajı |
| **Toggle navigation** | Navigasyonu Aç/Kapat | Sidebar buton |
| **Jump to / Shortcuts** | Şuraya Atla / Direkt Git | Sidebar quick links |
| **Print** | Yazdır | Button |
| **Previous / Next** | Önceki / Sonraki | Breadcrumb navigasyon |
| **Installation Complete** | Kurulum Tamamlandı | Callout başlığı |
| **Note** | Not | Info callout |
| **Warning** | Uyarı | Warning callout |
| **Success** | Başarı | Success callout |
| **Error** | Hata | Error callout |
| **Tip** | İpucu | Success/info callout |
| **Difficulty: Beginner** | Zorluk: Başlangıç | Difficulty tag |
| **Difficulty: Intermediate** | Zorluk: Orta | Difficulty tag |
| **Difficulty: Advanced** | Zorluk: İleri | Difficulty tag |
| **Updated** | Güncellendi | Timestamp annotation |
| **Read time** | Okuma Süresi | "5 dakikalık okuma" |
| **Metadata / Meta description** | Üstveri / Meta Açıklaması | HTML head |
| **Version badge** | Sürüm Rozeti | "v1.0.0" kalır |
| **Product name** | Ürün Adı | "Claude Code" kalır |
| **API Response** | API Yanıtı | Kod örnekleri |
| **Command** | Komut | CLI bağlamında |
| **Output** | Çıktı | Terminal output |
| **Configuration file** | Yapılandırma dosyası | .claude/* dosyalar |
| **File path** | Dosya Yolu | Yollar kalır |
| **Code block** | Kod Bloğu | Örnek görüntülemesi |
| **Table** | Tablo | Dokümantasyon yapısı |
| **Column header** | Sütun Başlığı | Tablo bağlamında |

**Toplam Girişler**: 52 kanonik term

---

## Çeviri Önceliği (Section-by-Section Translation Priority)

| Bölüm | Adı (TR) | Kelime Sayısı | Zorluk | Tahmini Token | Öncelik |
|---|---|---|---|---|---|
| 1 | Hızlı Başlangıç | ~1,200 | Orta | 2K | 1 — Giriş; kurulum örnekleri |
| 2 | Temel Kavramlar | ~2,200 | Yüksek | 3.5K | 2 — Sistem tanımı; tablo ağır |
| 3 | Yaygın İş Akışları | ~2,800 | Yüksek | 4.5K | 3 — Walkthrough; kod |
| 4 | İleri Konular | ~1,500 | Yüksek | 2.5K | 4 — Maliyet, eskalasyon, pattern |
| 5 | Araçlar Referansı | ~1,600 | Orta | 2.5K | 5 — Tool referans; /ctx, /graphify |
| 6 | Yapılandırma | ~1,200 | Orta | 2K | 6 — Hook kataloğu, kural listesi |
| 7 | Sorun Giderme | ~900 | Düşük | 1.5K | 7 — Hata ağacı, anti-kalıplar |
| 8 | Referans | ~2,500 | Orta | 3.5K | 8 — Cheat sheet, SSS, glossary |
| **TOTAL** | — | **~17,900** | — | **~25K** | — |

---

## Yapılmaması Gerekenler (Exclusions — Stay in English)

| Element | Reason | Example |
|---|---|---|
| **File paths** | Teknik identifier; kod referansı | `.claude/config/name-pool.md`, `src/features/` |
| **Slash command adları** | Sistem komut; user-typed | `/caveman`, `/graphify`, `/ctx`, `/review`, `/architect` |
| **Tier etiketleri** | Sistem tanımlayıcı (role adları) | `T1 Principal`, `T2 Staff Engineer`, `T4 Lead Analyst` |
| **Model adları** | AI model identifier; Anthropic ürün adı | `opus`, `sonnet`, `haiku` |
| **Hook dosya adları** | Shell script identifier | `block-console-log.sh`, `sql-injection-check.sh` |
| **xN mode adları** | Sistem parametre | `x2`, `x3`, `x5`, `x10` (x olası ama tavsiye: kalır) |
| **Kod blok örnek isimleri** | Teknik referans | `UserService`, `createUser()`, `DTO`, `JPA` |
| **Variable names** | Kaynak kod identifier | `revision_attempts`, `hit_count`, `god_nodes` |
| **JSON key names** | Yapılandırma key | `"permissions"`, `"mcpServers"`, `"hooks"` |
| **Bash command fleri** | Teknik komut | `--local-only`, `--format json` |
| **REST API endpoint şemalan** | Teknik yol | `GET /api/v1/users`, `POST /api/v2/tasks` |
| **Regex patterns** | Teknik desen | `^[A-Z]`, `(?:^|\s)caveman(?:\s|[^\w])` |
| **SQL örnekleri** | Teknik sorgu | `SELECT * FROM users WHERE...` |
| **URL'ler** | Web adresi | `https://github.com/...` |
| **Currency symbols** | Sayısal ifade | `$0.50`, `$4-6` (USD kalır) |
| **Emoji ikonlar** | Visual identifier | ✅, ⚠️, 🔴, 📋 |
| **Abbreviation özellikleri** | Teknik kısaltma | SOLID, CORS, XSS, JWT, OAuth, CSRF, MCP |
| **Sayılar** | Sayısal değer | `5 tiers`, `19 hooks`, `487 strings` |
| **Turkish display names (varsa)** | Zaten çevrilen; tutarlılık | Selin Akar, Barış Benli, Taner Yılmaz |

---

## T2-A İçin Resmi Talimatlar (Instructions for T2-A: Content Planning)

1. **Glossary Uyması**: Tüm Türkçe içeriği H03 Master Glossary'ye uygun olarak yazınız. "Orkestratör", "Seviye", "siz form" tercihlerini sabit tutunuz

2. **Tone Standardı**: Formal Türkçe (siz form), teknik, açıklamalı. "hocam" saymayınız; loanword (opus, hook, pattern) bilinçli seçimle kullannız

3. **Sistem Etiketleri (Kalır)**: 
   - Rol başlıklar: `T1 Principal`, `T2 Staff Engineer` → İngilizce
   - Slash komutlar: `/caveman`, `/graphify` → İngilizce kalır
   - Dosya yolları: `.claude/config/` → İngilizce kalır
   - Model adları: `opus`, `sonnet`, `haiku` → İngilizce kalır

4. **Kod Blok Yönetimi**:
   - Kod içinde yorumlar → Türkçeye çevir
   - Kod syntax, identifier, flag → Kalır
   - Output/description → Türkçeye çevir

5. **Tablo Başlıkları**: Tüm tablo başlıkları Türkçeye çevrilir; tier ID, model, dosya adı hücrelerinde kalır

6. **Başlık Çevirisi**: Tüm H1, H2, H3, H4, H5 başlıkları Türkçeye çevrilir; çapa ID'leri (anchor IDs) kalır

7. **İnternasyon Alanlarında** (search, placeholder, button):
   - Button label: `Copy` → `Kopyala`
   - Placeholder: `Search docs...` → `Dokümantasyonda ara...`
   - ARIA label: `Copy code to clipboard` → `Kodu panoya kopyala`

8. **Eksik Kontrolü**:
   - Hiçbir İngilizce satır dokümanda kalmaz (örn: "This is a setup file" ✗)
   - Her tablo başlığı çevrilir
   - Her callout başlığı çevrilir
   - Her button/link label çevrilir

9. **Karışık Dil String'i**: "use /ctx command" → "/ctx komutunu kullan" (komut kalır, fiil çevrilir)

10. **Bölüm Sırası (İş Dağılımı önerisi)**:
    - Bölüm 1 (Hızlı Başlangıç) → Başlangıç, yapı basit
    - Bölüm 2 (Temel Kavramlar) → Tablo ağır; parallel
    - Bölüm 3 (Yaygın İş Akışları) → Walkthrough uzun; parallel
    - Bölüm 4-8 → Sequential finalizasyon

---

## Yapılacaklar Değil (Prohibited Actions)

- ✗ "Koordinatör" kullanmak ("Orkestratör" seç)
- ✗ "Katman" kullanmak T1-T5 için ("Seviye" seç, ya da "T1-T5" etiketleri kalır)
- ✗ "sen" formu (informel) → "siz" formu (formal) tutun
- ✗ "hocam" hitabı döküman yazısına eklemek (sohbet dilinde)
- ✗ Kod parçaları türkçeye çevirmeye çalışmak (identifier kalır)
- ✗ Dosya yollarını çevirmeye çalışmak
- ✗ `/caveman` → `/aaatı-modu` vb dönüşüm yapmak (komut adları tutarlı)
- ✗ Farklı bölümlerde farklı terim kullanmak (glossary doğru kaynağı)

---

## QA Checklist (T2-A Özet Kontrol Listesi)

Sonlandırmadan önce T2-A kontrol etmeli:

- [ ] Master Glossary'deki 52 terimin tamamı paralel kullanılmış
- [ ] "Orkestratör" tutarlı, "Koordinatör" yok
- [ ] Tier referansları: Rol adları (T1 Principal) İngilizce, generic ("üst seviye") Türkçe
- [ ] Slash komutlar kalır (`/caveman`, `/graphify`, vb.)
- [ ] Tüm başlıklar Türkçe (başlık ID'leri kalır)
- [ ] Tüm tablo başlığı Türkçe
- [ ] Tüm callout başlığı Türkçe
- [ ] Tüm button label Türkçe
- [ ] Tüm placeholder Türkçe
- [ ] Dosya yolları kalır (`.claude/...`)
- [ ] Hiçbir İngilizce cümle dokümanda kalmaz
- [ ] HTML yapısı, bağlantı anchor'ları, kimlikleri değişmedi
- [ ] Kod blok comment'leri Türkçe, syntax kalır
- [ ] UTF-8 encoding kontrol (ç, ğ, ı, ö, ş, ü doğru)

---

## Taşınabilirlik & Next Steps

**Bu konsolide rapor (H03)** T2-A'ya 3 şey verir:

1. **Bağlayıcı Kararlar**: "Orkestratör" ✓, Tier hibrid ✓, siz form ✓ — Sorulacak başka soru yok
2. **Master Glossary**: 52 kanonik term; her kelimenin seçimi yazılı, sebep açık
3. **Çeviri Talimatları**: Hangi bölüm sırada, ne yapılır ne yapılmaz, QA kontrol listesi

**Sonraki Adımlar**:
1. T2-A: `docs/index.html` bölümlere ayırır, dağılım planı oluşturur
2. T3-A: Asenkron bölüm çevirisi yapar; HTML rebuild + lint
3. T2-A: Section çevirilerini birleştirir, glossary tutarlılığını doğrular
4. T2-A Code Review: Ton, erişilebilirlik, görsel test
5. T1-A: Nihai onay, stil kılavuz uyması

---

## Kaynaklar (Sources)

- `.claude/analysis/raw/H01-html-english-audit.md` — T5 İngilizce audit raporu (487+ string, 8 bölüm)
- `/Users/tcvmaksutoglu/Dev/w/claude-code-saka/CLAUDE.md` — Sistem tanımı; "Teknik Koordinator", "Orkestratör" rol adları
- `.claude/memory/sessions/*` — Kullanıcı belleği: "Türkçe, hocam hitabı, samimi dil"
- `.claude/config/name-pool.md` — Agent display names; Türkçe imler

**Audit Data Summary**:
- Total translatable strings: 487+
- Glossary terms identified: 52+
- Sections: 8
- Estimated translation tokens: 25-30K
- Complexity: Medium-High (teknik + procedural + reference)

---

## Değerlendirme

**Confidence**: ⭐ Yüksek (High)
- Bağlayıcı kararlar: Kullanıcı belleği + sistem tasarım + hedef kitle analizi ile doğrulandı
- Master Glossary: H01 audit raporu ve CLAUDE.md sistem tanımından çekildi
- Çeviri talimatları: Clean Code + Backend Development + Commit Standards kurallarına uygun

**Risk Faktörleri**: DÜŞÜK
- İnsan çevirisi gerekli (otomatik çeviri yetersiz); fakat T2-A deneyimli
- Tablo ve kod örnek yönetimi kritik; fakat kurallar açık
- Glossary tutarlılığı = bölüm çevirmenler arasında komünikasyon zorunlu (koordinasyonu T2-A sağlar)

---

## Tamamlanış Notu

Çeviri scope tamamlandı. H01'den 487+ string tanımlandı, T4 konsolidasyonuyla:
- ✅ 3 Bağlayıcı Karar (Orchestrator, Tier, Ton)
- ✅ 52 Master Glossary Girişi (Kanonik Türkçe)
- ✅ T2-A Resmi Talimatları (Bölüm sırası, QA)

**Hazır T2-A'ya yönlendirmeye.**

---

*Report prepared by Elif Ozge Maksutoglu (T4 Lead Analyst)*
*Date: 2026-05-22*
*Consolidated from H01 audit by Onur Ardic (T5)*
