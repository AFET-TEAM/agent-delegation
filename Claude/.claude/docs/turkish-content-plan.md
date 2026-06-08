# Türkçe İçerik Planı — HTML Dokümantasyon

**Hazırlayan**: Enis Sait Erken (T2 Staff Engineer)
**Tarih**: 2026-05-22
**Kaynak**: H01 audit + H03 bağlayıcı kararlar + docs/index.html

---

## 1. Sabit UI String'leri

### 1.1 HTML `<head>` Etiketleri

| Element | Türkçe Değer |
|---------|-------------|
| `<html lang="...">` | `lang="tr"` |
| `<title>` | `Claude Code Çoklu Agent Sistemi v1.0.0 - Dokümantasyon` |
| `<meta name="description">` | `Claude Code Çoklu Agent Delegasyon Sistemi için eksiksiz dokümantasyon: 5 seviye, 19 kanca, 17 kural, 7 xN modu, 3 izlenecek yol.` |

### 1.2 Erişilebilirlik & Navigasyon Stringleri

| Element | Türkçe Değer |
|---------|-------------|
| Skip link | `Ana içeriğe git` |
| Sidebar toggle aria-label | `Navigasyonu aç/kapat` |
| Dark mode toggle aria-label | `Gece modunu aç/kapat` |
| Dark mode button title | `Gece modunu aç/kapat` |
| Reading progress aria-label | `Okuma ilerlemesi` |
| Section navigation aria-label | `Bölüm navigasyonu` |

### 1.3 Arama & Header

| Element | Türkçe Değer |
|---------|-------------|
| Search input placeholder | `Dokümantasyonda ara...` |
| Header brand (bileşik) | `Claude Code` (ürün adı kalır) + sürüm rozeti `v1.0.0` (kalır) |
| Sidebar quicklinks label | `Şuraya atla` |

### 1.4 JavaScript Stringleri (Kod İçinde)

| Değişken / Satır | Türkçe Değer |
|-----------------|-------------|
| Copy button başlangıç metni | `Kopyala` |
| Copy button tıklandıktan sonra | `Kopyalandı` |
| Copy button aria-label | `Kodu panoya kopyala` |
| Dark mode toggle ikon (dark aktif) | `☀` (değişmez) |
| Dark mode toggle ikon (light) | `☽` (değişmez) |

### 1.5 Navigasyon Yönlendirme Linkleri

| Element | Türkçe Değer |
|---------|-------------|
| Prev arrow label | `← Önceki` |
| Next arrow label | `Sonraki →` |
| Cheat Sheet quicklink | `Kısa Referans` |
| FAQ quicklink | `SSS` |
| Glossary quicklink | `Sözlük` |

### 1.6 Footer

| Element | Türkçe Değer |
|---------|-------------|
| Footer ana metin | `Claude Code Çoklu Agent Sistemi v1.0.0 - Dokümantasyon 2026-05-21'de oluşturuldu` |
| Footer not | `Tek dosya, çevrimdışı kullanılabilir, harici bağımlılık yok. Yazdırmak için Ctrl/Cmd+P tuşlarına basın.` |

### 1.7 Callout Başlıkları (Sistem Geneli)

| Tür | Türkçe Başlık |
|-----|--------------|
| Info | `Not` |
| Warning | `Uyarı` |
| Success | `Başarı` / `İpucu` (bağlama göre — aşağıda bölüm bölüm belirtildi) |
| Danger | `❌ Tehlike` |
| Difficulty: Beginner | `Zorluk: Başlangıç` |
| Difficulty: Intermediate | `Zorluk: Orta` |
| Difficulty: Advanced | `Zorluk: İleri` |
| Section N | `Bölüm N` |
| N min read | `N dakikalık okuma` |
| All levels | `Tüm seviyeler` |

### 1.8 Print Butonu

| Element | Türkçe Değer |
|---------|-------------|
| Print button text | `Yazdır` |

---

## 2. Section Başlıkları ve Sidebar Navigasyon

### Ana Bölüm Başlıkları

```
H1: Claude Code Çoklu Agent Sistemi

Section 1 — Bölüm 1 — 5 dakikalık okuma — Zorluk: Başlangıç
H2: 1. Hızlı Başlangıç
  H3: 1.1 Bu Sistem Nedir?           [anchor: #what-is-claude-code — kalır]
  H3: 1.2 Tek-Komut Kurulumu         [anchor: #one-command-setup — kalır]
  H3: 1.3 İlk Göreviniz              [anchor: #first-task — kalır]

Section 2 — Bölüm 2 — 20 dakikalık okuma — Zorluk: Orta
H2: 2. Temel Kavramlar
  H3: 2.1 Beş Seviye Açıklandı       [anchor: #five-tiers — kalır]
  H3: 2.2 xN Modu Referansı          [anchor: #xn-modes — kalır]
  H3: 2.3 İnceleme Zinciri           [anchor: #review-chain — kalır]
  H3: 2.4 Kanca Sistemine Genel Bakış [anchor: #hooks-overview — kalır]
  H3: 2.5 Beceri Sistemi             [anchor: #skills-system — kalır]

Section 3 — Bölüm 3 — 30 dakikalık okuma — Zorluk: Orta
H2: 3. Yaygın İş Akışları
  H3: 3.1 Basit Düzeltme - Tek Ajan (W1)     [anchor: #workflow-simple — kalır]
  H3: 3.2 Küçük Özellik - x3 Modu            [anchor: #workflow-x3 — kalır]
  H3: 3.3 Standart Özellik - x5 Modu (W2)    [anchor: #workflow-x5 — kalır]
  H3: 3.4 Sistem Denetimi - x10 Modu (W3)    [anchor: #workflow-x10 — kalır]
  H3: 3.5 /caveman Kullanımı                  [anchor: #workflow-caveman — kalır]
  H3: 3.6 /ctx Kullanımı (Context-Mode)       [anchor: #workflow-ctx — kalır]
  H3: 3.7 /graphify Kullanımı                 [anchor: #workflow-graphify — kalır]
  H3: 3.8 Araçları Birleştirme               [anchor: #workflow-combined — kalır]

Section 4 — Bölüm 4 — 40 dakikalık okuma — Zorluk: İleri
H2: 4. İleri Konular
  H3: 4.1 Özel Beceri Oluşturma     [anchor: #custom-skills — kalır]
  H3: 4.2 Özel Kancalar             [anchor: #custom-hooks — kalır]
  H3: 4.3 Özel Ajan Şablonları      [anchor: #custom-agents — kalır]
  H3: 4.4 Bellek ve Öğrenilen Kalıplar [anchor: #learned-patterns — kalır]
  H3: 4.5 Maliyet Optimizasyonu     [anchor: #cost-optimization — kalır]
  H3: 4.6 Yükseltme İşlemi          [anchor: #escalation — kalır]
  H3: 4.7 Puan Ağırlıklı Ajan Seçimi [anchor: #agent-selection — kalır]

Section 5 — Bölüm 5 — 25 dakikalık okuma — Zorluk: Orta
H2: 5. Araçlar Referansı
  H3: 5.1 context-mode              [anchor: #context-mode-ref — kalır]
  H3: 5.2 graphify                  [anchor: #graphify-ref — kalır]
  H3: 5.3 Slash Komutları Referansı [anchor: #slash-commands — kalır]

Section 6 — Bölüm 6 — 20 dakikalık okuma — Zorluk: İleri
H2: 6. Yapılandırma
  H3: 6.1 settings.json Yapısı     [anchor: #settings-json — kalır]
  H3: 6.2 Kanca Kataloğu (19 Kanca) [anchor: #hooks-catalog — kalır]
  H4: PreToolUse:Edit/Write (11 kanca)
  H4: PreToolUse:Bash (2 kanca)
  H4: PostToolUse:Edit/Write (3 kanca)
  H4: SessionEnd (3 kanca)
  H3: 6.3 Ajan Şablonları (5)       [anchor: #agent-templates — kalır]
  H3: 6.4 Kural Kataloğu (17 Dosya) [anchor: #rules-catalog — kalır]

Section 7 — Bölüm 7 — 15 dakikalık okuma — Zorluk: Orta
H2: 7. Sorun Giderme
  H3: 7.1 Yaygın Hatalar ve Kurtarma      [anchor: #common-errors — kalır]
  H3: 7.2 Kanca Hataları ve Hata Ayıklama [anchor: #hook-debugging — kalır]
  H3: 7.3 İzin Reddedilmeleri             [anchor: #permission-issues — kalır]
  H3: 7.4 Maliyet Aşmaları ve Optimizasyon [anchor: #cost-issues — kalır]
  H3: 7.5 Anti-Kalıplar (Yapılmaması Gerekenler) [anchor: #anti-patterns — kalır]

Section 8 — Bölüm 8 — Referans — Tüm seviyeler
H2: 8. Referans
  H3: 8.1 Kısa Referans Kartı        [anchor: #cheat-sheet — kalır]
  H3: 8.2 Sözlük                     [anchor: #glossary — kalır]
  H3: 8.3 SSS                        [anchor: #faq — kalır]
  H3: 8.4 Metrikler Yorumlaması      [anchor: #metrics — kalır]
```

### Sidebar Quicklinks

```html
<span class="quicklinks-label">Şuraya atla</span>
<a href="#cheat-sheet">Kısa Referans</a>
<a href="#faq">SSS</a>
<a href="#glossary">Sözlük</a>
```

---

## 3. T3-A Talimatları (Bölüm 1-4)

### Genel Talimat

T3-A, aşağıdaki Bölüm 1–4 içeriğini eksiksiz Türkçeye çevirir. Her alt bölüm için:
- Verilen giriş paragrafını kullanın (harfi harfine değil, doğal Türkçeyle yeniden ifade edilmiş hali olarak)
- Her H3'ün en az 1 paragraf + 1 görsel öge (tablo/callout/kod) içerdiğinden emin olun
- Ton: formal, "siz" formu, teknik ama anlaşılır
- Kod syntax + identifier + dosya yolları = değişmez; yorum satırları = Türkçe

---

### BÖLÜM 1: Hızlı Başlangıç

#### H1 Ana Sayfa Metni

```
Claude Code Çoklu Agent Sistemi
```

Alt metin (H1'in hemen altındaki paragraf):
```
Mühendislik görevlerini 5 uzmanlaşmış yapay zeka seviyesi arasında dağıtan bir orkestrasyon katmanı.
Özel kancalar, kurallar ve öz-öğrenme örüntüleriyle Anthropic Claude Code v1.0.0 üzerine inşa edilmiştir.
```

#### 1.1 Bu Sistem Nedir?

**H3 başlık**: `1.1 Bu Sistem Nedir?`

**Giriş paragrafı 1**:
```
Claude Code Çoklu Agent Delegasyon Sistemi, yazılım mühendisliği görevlerini yapılandırılmış bir
yapay zeka ajansı ekibine dağıtan bir orkestrasyon katmanıdır. Her şeyi tek bir modele yönlendirmek
yerine, işler karmaşıklığa göre atanır: araştırma hızlı Haiku analistlere, uygulama Sonnet
mühendislere, mimari kararlar ise Opus principallarına gider.
```

**Giriş paragrafı 2**:
```
Orkestratör (ana Claude oturumunuzdur) ekibi koordine eder, inceleme zincirini yönetir, kod
kalitesi kancalarını uygular ve çıktıları nihai sonuçta birleştirir.
```

**Stat kartları** (4 kart, değerleri sabit):
```
5       → Ajan Seviyeleri
19      → Zorunluluk Kancaları
17      → Kural Dosyaları
7       → xN Modları
```

**Callout (Info — "Not")**:
```
Başlık: Not
İçerik: Bu bir orkestrasyon katmanıdır, tek bir yapay zeka yardımcısı değil. Orkestratör,
hangi seviye(ler)in her görevi üstleneceğine karar verir ve çoklu ajan modunda uygulama kodu
doğrudan yazmaz.
```

**Sistem akışı açıklaması** (kod bloğu öncesi satır):
```
Bir bakışta sistem akışı:
```

Kod bloğundaki yorum satırları için Türkçe karşılıklar:
```
-- Mimari, nihai inceleme
-- Servis katmanı, tasarım
-- Uygulama
-- Konsolidasyon
-- Araştırma, ham analiz
```

---

#### 1.2 Tek-Komut Kurulumu

**H3 başlık**: `1.2 Tek-Komut Kurulumu`

**Giriş paragrafı**:
```
Ön koşullar: Node.js 18+, git, Claude Code CLI kurulu.
```

**Kod bloğu yorum satırları** (Türkçe):
```
# .claude/ dizinini de içerecek şekilde depoyu klonlayın veya kopyalayın
# Kurulum doğrulama
# Sistem hazır — tüm kancalar, kurallar ve ajan şablonları yüklendi
```

**Kurulum başarı callout** (Success):
```
Başlık: Kurulum Tamamlandı
İçerik: 20 Türkçe isimle ajan adı havuzu başlatıldı. Kancalar kaydedildi.
Kural dosyaları yüklendi. Sistem çoklu agent görevlere hazır.
```

**Beklenen çıktı açıklaması** (kod bloğu öncesi):
```
Beklenen yapı:
```

---

#### 1.3 İlk Göreviniz

**H3 başlık**: `1.3 İlk Göreviniz`

**Giriş paragrafı**:
```
Sistemi denemenin en hızlı yolu, gerçek bir düzeltme görevi ile başlamaktır. Aşağıdaki örnek,
Orkestratörün önemsiz bir görevi nasıl algıladığını ve tek ajan modunda nasıl işlediğini gösterir.
```

**Kullanıcı komutu örneği** — HTML'deki mevcut Türkçe komut korunur:
```
Hocam, bu comment'teki typo'yu duzelt: 'usre' -> 'user'
Dosya: src/features/user/user-service.ts, satir 42
```
> **Not T3-A**: Bu komut zaten Türkçedir; `<pre><code>` içinde olduğu için değişmeden bırakın.

**Orkestratör analizi açıklama metni**:
```
Orkestratör analizi:
```

Madde işaretleri:
```
- Algılandı: tek dosya, 1 satır, önemsiz (yazım hatası)
- xN parametresi yok
- PEP atlandı: EVET (önemsiz görev)
- Mod: tek ajan (Orkestratör doğrudan ilgilenir)
```

**Çalıştırma metni**:
```
Çalıştırma:
```

Adım listesi:
```
1. src/features/user/user-service.ts dosyasını oku
2. 42. satırdaki yorumda yazım hatasını bul
3. "usre ID validation" değerini "user ID validation" olarak değiştir
4. Kanca tetiklenmedi (yalnızca yorum değişikliği)
5. Dosyayı kaydet
```

**Sonraki adım callout** (Info):
```
Başlık: Sonraki adım
İçerik: Tam bir adım adım izlenecek yol için, Bölüm 3'teki Walkthrough W2'ye (x5 modu) bakın.
```

**Önceki/Sonraki nav metinleri**:
```
← Önceki: (yok — ilk bölüm)
Sonraki →: Temel Kavramlar
```

---

### BÖLÜM 2: Temel Kavramlar

**Section meta**:
```
Bölüm 2
20 dakikalık okuma
Zorluk: Orta
```

**H2**: `2. Temel Kavramlar`

**Bölüm girişi** (H2'nin hemen altına):
```
Bu bölüm, sistemin beş temel bileşenini açıklar: seviyeler, xN modları, inceleme zinciri, kancalar
ve beceriler. Bu kavramları öğrenmek, hangi modu ne zaman kullanacağınızı ve görev sonuçlarını
nasıl yorumlayacağınızı anlamanızı sağlar.
```

---

#### 2.1 Beş Seviye Açıklandı

**H3 başlık**: `2.1 Beş Seviye Açıklandı`

**Giriş paragrafı**:
```
Sistem, farklı model güçlerine ve maliyet profillerine sahip beş ajan seviyesi üzerinde çalışır.
Orkestratör, görevi karmaşıklığa ve maliyete göre doğru seviyeye atar.
```

**Tablo başlıkları** (Türkçe):
```
Seviye | Rol | Model | Sorumluluk | Maliyet/Görev
```

**Tablo satır içerikleri** (Rol + Sorumluluk sütunları):

| Seviye | Rol (kalır) | Model (kalır) | Sorumluluk (Türkçe) | Maliyet/Görev (kalır) |
|--------|-------------|---------------|---------------------|----------------------|
| T1 | Principal | opus | Mimari kararlar, nihai inceleme, yükseltme hedefi | — |
| T2 | Staff Engineer | sonnet | Servis tasarımı, T3 kodunu inceler | — |
| T3 | MidCoder | sonnet | API uç noktaları, DTO'lar, standart CRUD | — |
| T4 | Lead Analyst (Kıdemli Analist) | haiku | T5 ham analizini birleştirir | — |
| T5 | Analyst (Analist) | haiku | Kod tabanı araştırması, ham bulgular | — |

**Anahtar ilke callout** (Info):
```
Başlık: Anahtar İlke
İçerik: T1 opus, en yüksek kapasiteye sahip ama aynı zamanda en pahalı seviyedir. Sistemi
maliyet açısından verimli tutan; araştırmanın haiku'ya, tasarım çalışmasının sonnet'e ve yalnızca
mimari kararların opus'a yönlendirilmesidir.
```

---

#### 2.2 xN Modu Referansı

**H3 başlık**: `2.2 xN Modu Referansı`

**Giriş paragrafı**:
```
xN parametresi, çoklu ajan modunu etkinleştirir ve kaç ajanın belirlenmiş dalga düzeninde
çalışacağını belirler. İsteminizin sonuna x2–x10 ekleyin.
```

**xN Kart İçerikleri** (her kartın açıklama metni):

| xN Etiketi (kalır) | Açıklama (Türkçe) |
|---------------------|-------------------|
| Single | xN yok. Tek ajan modu. Önemsiz düzeltmeler, açıklamalar, inceleme zinciri yok. |
| x2 | Mimari inceleme + araştırma. Uygulama yok. |
| x3 | Üst düzey incelemeli küçük özellik. |
| x4 | Tek modül standart geliştirme. |
| x5 | VARSAYILAN. Dengeli ekip, tam inceleme zinciri. Standart özellikler için en iyi. |
| x7 | Paralel özellik izleri, birden fazla modül. |
| x10 | Kritik sistem revizyonu, maksimum yetenek. |

**Kart içindeki "Maliyet ~$X-Y" etiketi**: `Maliyet ~$X-Y` (sayılar kalır, "Maliyet" kelimesi Türkçe)

**Karar ağacı** (xN seçimi için):

```
xN nasıl seçilir — hızlı karar ağacı:
```

Madde işaretleri:
```
- Önemsiz (<3 satır, 1 dosya)? → Single (xN yok)
- Yalnızca araştırma, kod yok? → x2
- Üst düzey incelemeli küçük özellik? → x3
- Standart özellik, tam zincir? → x5 ⭐ (varsayılan)
- Birden fazla paralel iz? → x7
- Sistem çapında revizyon? → x10
```

**Varsayılan öneri callout** (Success):
```
Başlık: Varsayılan Öneri
İçerik: Kararsız kaldığınızda x5 kullanın. Makul bir maliyetle tam inceleme zinciri sağlar.
Sistemin önerilen varsayılanıdır.
```

---

#### 2.3 İnceleme Zinciri

**H3 başlık**: `2.3 İnceleme Zinciri`

**Giriş paragrafı**:
```
Çoklu ajan modunda, tüm kod çıktıları sıralı bir inceleme zincirinden geçer. Her inceleyici
onaylar, revizyon ister (maksimum 2 tur) veya çalışmayı reddeder.
```

**Review chain node etiketleri** (HTML'deki div'ler):
```
T5 Çıktısı  →  T4 İncelemesi  →  T2 İncelemesi  →  T1 Onayı
```

**İnceleme sonuçları tablosu başlık**: `İnceleme sonuçları:`

**Tablo başlıkları**:
```
Sonuç | İşlem
```

**Tablo satır içerikleri**:
```
✅ Onaylandı          | Birleştir ve sonraki göreve geç
⚠️ Revizyon Gerekli  | Bulguları içeren yeni ajan başlat, maksimum 2 tur
❌ Reddedildi         | Tohum istemiyle bir üst seviyeye yükselt
```

**Revizyon sayacı açıklaması**:
```
Revizyon sayacı: Her görev revision_attempts değerini (0'dan başlar) takip eder. Her uyarı
yeniden başlatması 1 artırır. Aynı seviye içinde iki artış artı bir red, bir üst seviyeye
zorunlu yükseltmeyi tetikler. Sayaç yalnızca daha yüksek bir seviyeye yükseltilirken sıfırlanır.
```

---

#### 2.4 Kanca Sistemine Genel Bakış

**H3 başlık**: `2.4 Kanca Sistemine Genel Bakış`

**Giriş paragrafı**:
```
Kancalar, her araç çağrısından önce ve sonra otomatik olarak tetiklenen shell script'leridir.
Kural ihlallerini engellerler (çıkış 1) veya uyarı verirler (çıkış 0). İhlaller atlanamaz.
```

**Tablo başlıkları**:
```
Kanca Olayı | Amaç | Adet
```

**Tablo satır içerikleri**:
```
PreToolUse:Edit/Write | Yasaklı örüntüleri engelle (konsol ifadeleri, türsüz değerler, SQL enjeksiyonu, XSS vb.) | 11
PreToolUse:Bash       | Yıkıcı git işlemlerini ve tehlikeli bash örüntülerini engelle | 2
PostToolUse:Edit/Write | Düzenlemeleri takip et, tekrarlanan örüntüleri tespit et, oturum etkinliğini kaydet | 3
SessionEnd             | Lider tablosunu güncelle, öğrenilen örüntüleri işle, eski olanları arşivle | 3
```

**Çapraz referans metni**:
```
Tüm 19 kancanın tam kataloğu için bkz. Bölüm 6.2.
```

---

#### 2.5 Beceri Sistemi

**H3 başlık**: `2.5 Beceri Sistemi`

**Giriş paragrafı**:
```
Beceriler, uzmanlaşmış davranışa yönlendiren yeniden kullanılabilir slash komutlarıdır.
Sistemle birlikte altı komut gelir.
```

**Tablo başlıkları**:
```
Komut | Etki | Ne Zaman Kullanılır
```

**Tablo satır içerikleri** (Komut kalır, Etki ve Ne Zaman Türkçe):
```
/caveman        | Sıkıştırılmış düz metin çıktısı (%40-65 daha az kelime) | Hızlı hata ayıklama oturumları, hızlı iterasyon
/graphify        | Kod tabanı bilgi grafı oluştur (AST tabanlı)            | Kod tabanı >20 dosya, topoloji bilinmiyor
/ctx             | Context-mode bellek araçları (ctx_search, ctx_index)    | Karmaşık analiz, oturumlar arası yeniden kullanım
/review          | Kontrol listesine karşı kod incelemesi                   | Birleştirme öncesi, PR kalite kapısı
/security-review | Odaklanmış güvenlik analizi                             | Dağıtım öncesi, uyumluluk denetimi
/architect       | Doğrudan T1 Principal'a yönlendir (opus)                | Mimari kararlar, sistem tasarımı
```

**Önceki/Sonraki nav**:
```
← Önceki: Hızlı Başlangıç
Sonraki →: Yaygın İş Akışları
```

---

### BÖLÜM 3: Yaygın İş Akışları

**Section meta**:
```
Bölüm 3
30 dakikalık okuma
Zorluk: Orta
```

**Bölüm girişi** (H2'nin hemen altına):
```
Bu bölüm, en sık kullanılan iş akışlarını gerçek komutlar, beklenen çıktılar ve maliyet tahminleriyle
birlikte gösterir. Üç tam izlenecek yol (W1, W2, W3) ve araç kullanım örnekleri içerir.
```

---

#### 3.1 Basit Düzeltme - Tek Ajan (W1)

**H3 başlık**: `3.1 Basit Düzeltme - Tek Ajan (W1)`

**Giriş satırı**:
```
İzlenecek Yol W1: Tek yazım hatasını düzelt, tek ajan modu, yaklaşık 1 dakika.
```

**"Kullanıcı komutu:" etiketi**: `Kullanıcı komutu:`

**"Orkestratör analizi:" etiketi**: `Orkestratör analizi:`

**"Çalıştırma:" etiketi**: `Çalıştırma:`

**"Çıktı:" etiketi**: `Çıktı:`

Çıktı içindeki metin satırları:
```
Oturum dosyası oluşturulmadı (tek ajan modu).
Tamamlandı.
```

**Metrik tablosu başlıkları**:
```
Metrik | Değer
```

**Metrik satır içerikleri**:
```
Zaman       | ~1 dakika
Maliyet     | ~$0
Ajanlar     | 0 (yalnızca Orkestratör)
Oturum dosyası | Oluşturulmadı
```

**Performans raporu yok callout** (Info):
```
Başlık: Performans raporu yok
İçerik: Tek ajan modu hiçbir zaman oturum performans raporu üretmez. Bu artifact yalnızca
çoklu ajan (xN) oturumlarına özgüdür.
```

---

#### 3.2 Küçük Özellik - x3 Modu

**H3 başlık**: `3.2 Küçük Özellik - x3 Modu`

**"Kullanıcı komutu:" etiketi**: `Kullanıcı komutu:`

**Ajan tahsisi metni**: `Ajan tahsisi:`

Tier rozeti açıklamaları:
```
T1 Principal (opus) - Nihai onay
T2 Staff Engineer (sonnet) - T5 çıktısını inceler
T5 Analyst (haiku) - Giriş örüntülerini araştır, güvenlik gereksinimlerini belirle
```

**Dalga başlıkları ve açıklamaları**:
```
Dalga 1: T5 Analizi
T5, mevcut giriş dokümanlarını okur, test senaryoları oluşturur, kalıcı oturumlar için
güvenlik gereksinimlerini belirler.

Dalga 2: T5'in T2 İncelemesi
T2, analiz kalitesini doğrular, eksik sınır durumlarını işaretler. Sonuç: ✅ Onaylandı.

Dalga 3: T1 Nihai Onayı
Orkestratör birleştirilmiş çıktıyı sunar. Görev tamamlandı.
```

**Maliyet/zaman satırı**:
```
Maliyet: ~$2-3   Zaman: ~8-10 dakika   Çıktı: Onaylı test senaryoları + uygulama önerileri.
```

---

#### 3.3 Standart Özellik - x5 Modu (W2)

**H3 başlık**: `3.3 Standart Özellik - x5 Modu (W2)`

**Giriş satırı**:
```
İzlenecek Yol W2: Tam inceleme zinciriyle API uç noktası ekle. Bu, kanonik çoklu ajan akışıdır.
```

**Orkestratör analizi madde işaretleri**:
```
- Görev türü: Özellik (API uç noktası)
- Karmaşıklık: Orta (2-3 dosya: servis + controller + DTO)
- Önemsiz değil: çok dosyalı, iş mantığı gerekli
- PEP zorunlu: EVET
```

**PEP başlığı**: `İstem Zenginleştirme Protokolü (PEP):`

**Kullanıcı onayı metni**: `Kullanıcı varsayılanları onaylar.` ardından `Orkestratör görev planı oluşturur:`

**Dalga başlıkları ve açıklamaları** (kod bloğu içindeki yorumlar):
```
### Dalga 1: Analiz
- TASK-001 (T5 Analyst): Kullanıcı profil örüntülerini, güvenliği, önbelleği araştır

### Dalga 2: Konsolidasyon
- TASK-002 (T4 Lead Analyst): T5 bulgularını mimari özetine sentezle

### Dalga 3: Uygulama (Paralel)
- TASK-003 (T2 Staff Engineer): Servis katmanı (ProfileService, önbellekleme)
- TASK-004 (T3 MidCoder): Controller uç noktası, DTO'lar, entity eşleme

### Dalga 4: Kod İncelemesi
- TASK-005 (T2, T3'ü inceler): Kod kalitesi, hata yönetimi, güvenlik
- TASK-006 (T1, T2'yi inceler): Mimari tutarlılık, servis tasarımı

### Tahmini Maliyet: $4-6
### Tahmini Süre: 12-15 dakika
```

**Workflow wave açıklamaları**:
```
Dalga 1 - T5 Analizi (haiku, ~38K belirteç)
T5, kullanıcı entity'sini (12 alan), mevcut profil uç noktalarını, profil veri açığa çıkarma
örüntülerini, mevcut önbellek kütüphanelerini okur. .claude/analysis/raw/T5-user-profile.md
dosyasına çıktı verir.

Dalga 2 - T4 Konsolidasyon (haiku, ~32K belirteç)
T4, T5 bulgularını sentezler: uç nokta şekli, servis sözleşmesi, hata durumları, önbellek
stratejisi. .claude/analysis/consolidated/T4-profile-brief.md dosyasına çıktı verir.

Dalga 3 - T2 + T3 Uygulaması (paralel, sonnet, ~146K belirteç)
T3, controller + DTO'ları uygular. T2, servis katmanını uygular. İkisi bağımsız dosyalara
dokundukları için paralel çalışır.

Dalga 4 - İnceleme zinciri (sıralı, ~180K belirteç)
T2, T3 kodunu inceler (küçük sorun: @Validated eksik). T1, T2 mimarisini inceler
(✅ onaylandı). Nihai konsolidasyon.
```

**"T3 uygulama alıntısı:" etiketi**: `T3 uygulama alıntısı:`

**"T2 servis uygulaması:" etiketi**: `T2 servis uygulaması:`

---

#### 3.4 Sistem Denetimi - x10 Modu (W3)

**H3 başlık**: `3.4 Sistem Denetimi - x10 Modu (W3)`

**Giriş paragrafı**:
```
İzlenecek Yol W3: Sistem genelinde güvenlik ve mimari denetimi. Bu, mevcut bir kod tabanını
birden fazla paralel iz üzerinde analiz eder.
```

**Görev planı** (kod bloğundaki yorum satırları Türkçe):
```
## Çoklu Ajan Planı - x10 Modu

### Dalga 1: Paralel Analiz (2x T5)
- TASK-001 (T5-A): Kimlik doğrulama ve yetkilendirme akışlarını araştır
- TASK-002 (T5-B): Veritabanı katmanı ve N+1 sorgu örüntülerini araştır

### Dalga 2: Çift Konsolidasyon (2x T4)
- TASK-003 (T4-A): T5-A bulgularını güvenlik özetine sentezle
- TASK-004 (T4-B): T5-B bulgularını performans özetine sentezle

### Dalga 3: Uygulama (2x T3 paralel)
- TASK-005 (T3-A): Kimlik doğrulama güvenlik yamalarını uygula
- TASK-006 (T3-B): Sorgu optimizasyonlarını uygula

### Dalga 4+: İnceleme Zinciri (2x T2 → 2x T1)
```

**Bütçe callout** (Warning):
```
Başlık: Uyarı — Bütçeyi gerçekçi belirleyin
İçerik: Tam x10 çalıştırması için 25-35 dakika planlayın. Kurulum, paralel dalgalar ve
inceleme zincirinin hepsi zaman alır. Sıkışık son teslim tarihlerinde x10 oturumu planlamayın.
```

---

#### 3.5 /caveman Kullanımı

**H3 başlık**: `3.5 /caveman Kullanımı`

**Giriş paragrafı**:
```
Caveman modu, Orkestratörden kullanıcıya giden düz metni %40-65 sıkıştırır. Kod blokları,
dosya yolları, tanımlayıcılar ve güvenlik metinleri hiçbir zaman sıkıştırılmaz.
```

**"Kullanıcı komutu:" etiketi**: `Kullanıcı komutu:`

**"Yan yana karşılaştırma:" etiketi**: `Yan yana karşılaştırma:`

**Karşılaştırma tablosu başlıkları**:
```
Normal mod | Caveman modu
```

**Tablo satır içerikleri** (prose çevirisi — kod satırları değişmez):
```
Satır 1 Normal: "Şimdi hata ayıklamak için log'ları inceleyecek ve kod yolunu takip edeceğim."
Satır 1 Caveman: "Hata ayıklanıyor. Log'lar ve kod yolu kontrol ediliyor."

Satır 2 Normal: "Projedeki ihlalleri belirlemek için şimdi linter'ı çalıştıracağım."
Satır 2 Caveman: "Linter çalışıyor."

Satır 3 Normal: "Tarama tamamlandığında, bulduğum her sorunu düzelteceğim ve nelerin değiştiğini bildireceğim."
Satır 3 Caveman: "Düzeltilecek ve bildirilecek."
```

**Kod bloğu açıklama metni**:
```
Her iki modda da kod blokları birebir aynı kalır:
```

**Caveman kullanılmaması callout** (Warning):
```
Başlık: /caveman Ne Zaman Kullanılmaz
İçerik: Mimari kararlar, güvenlik uyarıları, yıkıcı eylem onayları ve git onay iletişim
kutuları için caveman modundan kaçının. Bu otomatik açıklık istisnaları, moddan bağımsız
olarak her zaman kapsamlı kalır.
```

**Devre dışı bırakma metni**:
```
Devre dışı bırakma: Ayrıntılı çıktıya dönmek için "stop caveman" veya "normal mode" yazın.
```

---

#### 3.6 /ctx Kullanımı (Context-Mode)

**H3 başlık**: `3.6 /ctx Kullanımı (Context-Mode)`

**Giriş paragrafı**:
```
Context-mode, bağlam penceresi dolmasını önler. Araç çıktıları izole alt süreçlerde çalışır;
yalnızca sonuçlar bağlama girer. Oturum durumu, SQLite + FTS5 aracılığıyla sıkıştırma
sonrasında da kalıcı olarak saklanır.
```

**"Tipik iş akışı:" etiketi**: `Tipik iş akışı:`

**Kod bloğu yorum satırları** (Türkçe):
```
# Adım 1: Context-mode'u etkinleştir
# Adım 2: Bağlamı kirletmeden ağır analiz çalıştır
# Adım 3: Büyük dosyayı işle (yalnızca sonuç bağlama girer)
# Adım 4: Oturumlar arası yeniden kullanım için bulguları dizinle
# Adım 5: Önceki oturumları ara
```

**Belirteç tasarrufu callout** (Success):
```
Başlık: Belirteç Tasarrufu
İçerik: x10 oturumu başına yaklaşık %76 (tahmini 50.000 → 12.000 belirteç). 11 adet ctx_*
MCP aracı toplu olarak uzun oturumlardaki bağlam baskısını azaltır.
```

**Tam araç referansı bağlantısı**:
```
Tam araç referansı için bkz. Bölüm 5.1.
```

---

#### 3.7 /graphify Kullanımı

**H3 başlık**: `3.7 /graphify Kullanımı`

**Giriş paragrafı**:
```
Graphify, 20'den fazla dosya içeren kod tabanlarından sorgulanabilir bilgi grafları oluşturur.
Mimari sorular için toplu dosya-grep işlemini ortadan kaldırır.
```

**"Komutlar:" etiketi**: `Komutlar:`

**Kod bloğu yorum satırları** (Türkçe):
```
# Graf oluştur (kod yerel olarak işlenir, API çağrısı yok)
# Raporu oku
# En yüksek dereceli ilk 5 tanrı-düğümünü sorgula
```

**"Çıktı dosyaları:" etiketi**: `Çıktı dosyaları:`

**Çıktı dosyaları tablosu başlıkları**:
```
Dosya | Amaç
```

**Tablo satır içerikleri**:
```
graphify-out/graph.json       | Sorgulanabilir graf (oturumlar arasında kalıcı)
graphify-out/GRAPH_REPORT.md  | Tanrı düğümleri + şaşırtıcı bağlantı özeti
graphify-out/graph.html       | Etkileşimli tarayıcı görselleştirmesi
```

**"Örnek graph.json yapısı:" etiketi**: `Örnek graph.json yapısı:`

**--local-only callout** (Warning):
```
Başlık: Uyarı — Her zaman --local-only kullanın
İçerik: --local-only kullanılmazsa kod içeriği harici LLM API'lerine gönderilebilir.
--mode deep seçeneğini yalnızca hangi verilerin paylaşıldığını tam olarak anlayarak kullanın.
```

**"Bayat işaret protokolü:" etiketi**: `Bayat işaret protokolü:`

---

#### 3.8 Araçları Birleştirme

**H3 başlık**: `3.8 Araçları Birleştirme`

**Giriş paragrafı**:
```
Graphify ve context-mode birbirini tamamlar: graphify topoloji farkındalığı sağlar,
context-mode ise bulguları oturumlar arasında korur.
```

**Kod bloğu yorum satırları** (Türkçe):
```
# Adım 1: Graf oluştur
# Adım 2: Raporu bağlama oku
# Adım 3: Oturumlar arası yeniden kullanım için raporu dizinle
# Adım 4: Tüm dosyaları okumadan hedefli analiz çalıştır
# Adım 5: Varsa önceki oturumları ara
```

**Belirteç tasarrufu açıklaması**:
```
Belirteç tasarrufu: Graf oluşturma için ~500 belirteç + jq sorgusu başına ~200 = ham dosya
okumaya kıyasla yaklaşık 20.000 bağlam belirteç tasarrufu.
```

**Önceki/Sonraki nav**:
```
← Önceki: Temel Kavramlar
Sonraki →: İleri Konular
```

---

### BÖLÜM 4: İleri Konular

**Section meta**:
```
Bölüm 4
40 dakikalık okuma
Zorluk: İleri
```

**Bölüm girişi**:
```
Bu bölüm, sistemi özelleştiren ileri düzey yapılandırmaları kapsar: özel beceriler, kancalar,
ajan şablonları, öz-öğrenme döngüsü, maliyet optimizasyonu ve yükseltme yönetimi.
```

---

#### 4.1 Özel Beceri Oluşturma

**H3 başlık**: `4.1 Özel Beceri Oluşturma`

**Giriş paragrafı**:
```
Beceriler, .claude/skills/{isim}/ dizinlerinde saklanan yeniden kullanılabilir slash komutlarıdır.
Her becerinin tetikleyici koşulları ve davranışı belirten bir SKILL.md dosyası vardır.
```

**Kod bloğu yorum satırları** (Türkçe):
```
# Beceri dizini oluştur
# Ön yüz (frontmatter) ve gövdeyle SKILL.md oluştur
# Tetikleyici: /myteam-deploy slash komutu aracılığıyla çağrılır
# Gövde: Orkestratöre ekibin dağıtım politikasını bildirir
```

**Açıklama satırı**:
```
Beceriler, Skill aracının kullanılabilir listesinde otomatik olarak görünür. Orkestratör, kullanıcı
isteği üzerine onlara yönlendirebilir.
```

---

#### 4.2 Özel Kancalar

**H3 başlık**: `4.2 Özel Kancalar`

**Giriş paragrafı**:
```
Kancalar, Claude Code platformu tarafından belirli araç olaylarında tetiklenen shell script'leridir.
Araç girdisi argüman olarak verilmek üzere proje çalışma dizininde çalışırlar.
```

**"Kanca yapısı:" etiketi**: `Kanca yapısı:`

**Kod bloğu yorum satırları** (Türkçe):
```
# Dosya: .claude/hooks/custom-credential-check.sh
# Ön-Edit kancası: sabit kodlu değerleri engeller

# 1. JSON stdin'den file_path ve içeriği oku
# 2. Yasaklı örüntülere karşı regex denetimi uygula
# 3. Engellemek için stderr mesajıyla 1 çık; izin vermek için 0 çık
```

**İkinci kod bloğu yorumları** (Türkçe):
```
# Çalıştırılabilir yap
# .claude/settings.json içindeki hooks.PreToolUse.Edit'e kaydet
```

**Çıkış kodları callout** (Warning):
```
Başlık: Uyarı — Çıkış kodları önemlidir
İçerik: 1 çıkışı araç çağrısını engeller. 0 çıkışı buna izin verir. 2 çıkışı uyarır ama
devam eder. stderr, Claude'a hata mesajı olarak gösterilir.
```

---

#### 4.3 Özel Ajan Şablonları

**H3 başlık**: `4.3 Özel Ajan Şablonları`

**Giriş paragrafı**:
```
Her seviyenin .claude/agents/{rol}.md içinde varsayılan bir şablonu vardır. Yeni şablonlar
oluşturup delegasyon kurallarını güncelleyerek alana özgü varyantlar (örneğin T3-React)
ekleyebilirsiniz.
```

**Kod bloğu yorum satırları** (Türkçe):
```
# Dosya: .claude/agents/mid-coder-react.md
# T3 MidCoder - React Uzmanı

[Standart T3 şablon başlığı]

## React Özel Yönergeleri

### Bileşen Yapısı
- Dosya başına bir bileşen
- İşlevsel bileşenler + kancalar
- Sunum ve container bileşenleri ayırın

### Ant Design Entegrasyonu
- antd'den içe aktarın (antd/es değil)
- Renkler için theme.useToken() kullanın
- Boşluklar için rem birimiyle css kullanın
```

**Açıklama satırı**:
```
Orkestratör, görev *.tsx dosyalarına dokunduğunda standart T3 yerine mid-coder-react'ı
koşullu olarak başlatabilir.
```

---

#### 4.4 Bellek ve Öğrenilen Kalıplar

**H3 başlık**: `4.4 Bellek ve Öğrenilen Kalıplar`

**Giriş paragrafı**:
```
Öz-öğrenme döngüsü, tekrarlanan inceleme reddedilmelerini kalıcı örüntülere dönüştürür.
Örüntü dosyaları .claude/memory/learned-patterns/ içinde yaşar ve bir sonraki başlatmada
ajan istemlerine enjekte edilir.
```

**"Yaşam döngüsü:" etiketi**: `Yaşam döngüsü:`

**Yaşam döngüsü kod bloğu açıklamaları** (Türkçe):
```
hata oluşur -> self-learning-collector.sh aynı dosyaya 2+ düzenleme tespit eder
              -> hit-count: 0 ile LP-{id}.md oluşturur
              |
              v
        aktif örüntü, ajan istemlerine enjekte edilir
              |
              v
hit-count >= 3 -> .claude/rules/learned-{kategori}.md'ye yükseltilir
                  (işaretleyicili yıkıcı olmayan ekleme)

sessions-since-hit >= 5 VE hit-count == 0
            -> .claude/memory/learned-patterns/archive/'ye arşivlenir
               (kurtarılabilir, silinmez)
```

**"Örüntü dosyası yapısı (ön yüz + gövde):" etiketi**: `Örüntü dosyası yapısı (ön yüz + gövde):`

**Örüntü dosyasındaki İngilizce section başlıkları** (YAML anahtarları kalır; markdown bölüm başlıkları çevrilir):
```
# Hata: useEffect'te Eksik Bağımlılıklar

## Hata
Harici durum değişkenleriyle useEffect kullanan ama bunları bağımlılık
dizisine dahil etmeyen kod (eski kapanış riski).

## Düzeltme
Tüm harici değişkenleri bağımlılık dizisine dahil edin ya da işlev
referanslarını sabitlemek için useCallback kullanın.

## Kural
Harici değişken referansları olan her useEffect, bu değişkenleri bağımlılık
dizisinde listelemelidir. İhlalleri otomatik olarak tespit etmek için
react-hooks/exhaustive-deps ESLint kuralını kullanın.

## Bağlam
React 18+, eski kapanışları ve sonsuz döngüleri önlemek için bağımlılık
dizileri gerektirir.
```

**Etki satırı**:
```
Etki: başlatılan sonraki T3 ajanı bu örüntüyü "Dikkat Edilecek Noktalar" altında görür.
```

---

#### 4.5 Maliyet Optimizasyonu

**H3 başlık**: `4.5 Maliyet Optimizasyonu`

**Giriş paragrafı**:
```
Belirteç maliyetleri, haiku ile opus arasında ~12 kat farklılık gösterir. Orkestrasyon sistemi,
ortalama maliyeti düşük tutmak için bilinçli bir şekilde delegasyon yapar.
```

**Görev türü tablosu başlıkları**:
```
Görev türü | Önerilen mod | Tahmini maliyet
```

**Tablo satır içerikleri**:
```
Yazım hatası düzeltme, tek satır           | Tek ajan        | ~$0.05
Açıklama / Soru-Cevap                      | Tek ajan        | ~$0.20-0.50
Hata düzeltme, 2-3 dosya                   | x3              | ~$2-3
Küçük özellik (tek modül)                  | x4              | ~$3-4
Standart özellik (tam zincir)              | x5              | ~$4-6
Paralel özellik izleri                     | x7              | ~$7-10
Kritik sistem revizyonu                    | x10             | ~$12-18
```

**Tasarruf karşılaştırma tablosu başlıkları**:
```
Görev | Tek opus | Çoklu ajan (x5) | Tasarruf
```

**Tablo satır içerikleri**:
```
Küçük API uç noktası | $8-10  | $1-2   | %80-90
Özellik (500 satır)  | $15-20 | $4-6   | %70-80
Sistem yeniden tasarımı | $35-50 | $12-18 | %65-75
```

**İpucu callout** (Success):
```
Başlık: İpucu
İçerik: Araştırma için T1 ($0.75/görev) yerine önce T5 kullanın ($0.05/görev). T5 ham
bulgular üretir; T4 bunları birleştirir; yalnızca bundan sonra tasarım çalışması daha
yüksek seviyelere ulaşır.
```

---

#### 4.6 Yükseltme İşlemi

**H3 başlık**: `4.6 Yükseltme İşlemi`

**Giriş paragrafı**:
```
Bir seviye incelemeyi iki kez geçemediğinde (revision_attempts = 2), görev otomatik olarak
bir üst seviyeye yükseltilir. Yeni ajan, tam bağlamla birlikte yapılandırılmış bir tohum
istem alır.
```

**"Revizyon sayacı durum makinesi:" etiketi**: `Revizyon sayacı durum makinesi:`

**Yükseltme tohum formatı etiket satırı**: `Yükseltme tohum formatı (zorunlu):`

**Tohum formatındaki Türkçe bölüm başlıkları**:

> **Not T3-A**: Bu kod bloğu içindedir. Bölüm başlıklarını Türkçeye çevirin:
```
## Yükseltme Bağlamı
Önceki ajan: T{n} | Revizyon turları: 2

## Önceki Çıktı
{başarısız ajanın son çıktısı}

## İnceleme Bulguları
{önem derecesiyle etiketlenmiş tüm inceleyici yorumları}

## Göreviniz
{orijinal görev açıklaması}
```

**Sayaç sıfırlama kuralı açıklaması**:
```
Sayaç sıfırlama kuralı: revision_attempts yalnızca T{n+1}'e yükseltilirken sıfırlanır. Aynı
seviye içindeki yeniden başlatmalar sayacın artmaya devam etmesine neden olur.
```

---

#### 4.7 Puan Ağırlıklı Ajan Seçimi

**H3 başlık**: `4.7 Puan Ağırlıklı Ajan Seçimi`

**Giriş paragrafı**:
```
Her seviyenin adlandırılmış ajanlardan oluşan bir havuzu vardır. Seçim, yüksek performanslı
kişilerin daha fazla yüksek görünürlüklü görev almasını sağlarken tüm ajanların çalışmaya
devam etmesini sağlayan puan ağırlıklı rastgele örnekleme kullanır.
```

**"Ağırlık formülü:" etiketi**: `Ağırlık formülü:`

**"Seviye çarpanları:" etiketi**: `Seviye çarpanları:`

**Seviye çarpanları tablosu başlıkları**:
```
Kademe | Puan aralığı | Çarpan
```

**Tablo satır içerikleri**:
```
A-kademe | > 20   | 1.5x
B-kademe | 0-19   | 1.0x
C-kademe | -20 ile -1 arası | 0.8x
D-kademe | < -20  | 0.6x
```

**"Puan değişimleri:" etiketi**: `Puan değişimleri:`

**Puan değişimleri tablosu başlıkları**:
```
Olay | Değişim
```

**Tablo satır içerikleri**:
```
Görev tamamlandı               | +5
Görev başarısız                | -5
Kod incelemesi ilk geçişte     | +3
İnceleme ikinci geçişte        | +1
İnceleme 3+ tur                | -3
P0/P1 sorun bulundu            | +4
Yanlış pozitif                 | -2
Gereksiz yükseltme             | -2
Model yedeği                   | -1
```

**Etki açıklaması**:
```
Etki: A-kademe ajanları B-kademe'ye kıyasla %50, D-kademe'ye kıyasla ~3.4 kat daha fazla
seçilme olasılığına sahiptir. Tüm ajanlar zaman içinde çalışmaya devam eder.
```

**Önceki/Sonraki nav**:
```
← Önceki: Yaygın İş Akışları
Sonraki →: Araçlar Referansı
```

---

## 4. T3-B Talimatları (Bölüm 5-8)

### Genel Talimat T3-B

T3-B, Bölüm 5–8 içeriğini Türkçeye çevirir. Kod blokları + dosya yolları + slash komutları değişmez. Tablo başlıkları, açıklamalar, callout metinleri tam olarak çevrilir.

---

### BÖLÜM 5: Araçlar Referansı

**Section meta**:
```
Bölüm 5
25 dakikalık okuma
Zorluk: Orta
```

**Bölüm girişi**:
```
Bu bölüm üç aracın tam referansını sunar: context-mode MCP araçları, graphify komut seti ve
altı slash komutunun her biri için ayrıntılı açıklamalar.
```

---

#### 5.1 context-mode

**H3 başlık**: `5.1 context-mode`

**Amaç paragrafı**:
```
Amaç: Bağlam penceresi dolmasını önler. Araç çıktıları izole alt süreçlerde çalışır; yalnızca
sonuçlar bağlama girer. Oturum durumu, SQLite + FTS5 aracılığıyla sıkıştırma sonrasında da
kalıcı olarak saklanır.
```

**Slash komutu satırı**:
```
Slash komutu: /ctx
```

**Ne zaman kullanılır (madde listesi)**:
```
Ne zaman kullanılır:
- Bağlama >10 KB dökebilecek analiz script'leri
- Sıkıştırma sonrasında önceki oturum bulgularını arama
- Oturumlar arası erişim için T5 analiz raporlarını dizinleme
```

**Temel araçlar tablosu başlıkları**:
```
Araç | Kullanım durumu
```

**Tablo satır içerikleri** (araç adları kalır; kullanım durumu Türkçe):
```
ctx_execute           | Analiz script'lerini çalıştır; yalnızca sonucu kaydet
ctx_execute_file      | Dosyaları yüklemeden işle
ctx_batch_execute     | Paralel analiz (en fazla 8 eş zamanlı)
ctx_index             | Bulguları FTS5 bilgi tabanında sakla
ctx_search            | Dizinlenmiş içerikte BM25 sıralı arama
ctx_fetch_and_index   | Web içeriğini al ve dizinle
ctx_stats             | Kullanım istatistikleri
ctx_doctor            | Sağlık kontrolü
```

**"Güvenlik: yasaklı yollar (ctx_execute'a hiçbir zaman geçirmeyin):" etiketi**:
```
Güvenlik: yasaklı yollar (ctx_execute'a hiçbir zaman geçirmeyin):
```

**Belirteç tasarrufu satırı**:
```
Belirteç tasarrufu: x10 oturumu başına yaklaşık %76 (tahmini 50.000 → 12.000 belirteç).
```

**Kurulum callout** (Info):
```
Başlık: Kurulum
İçerik: Bkz. .claude/docs/context-mode-install.md. Kurallar: .claude/rules/context-mode-usage.md.
```

---

#### 5.2 graphify

**H3 başlık**: `5.2 graphify`

**Amaç paragrafı**:
```
Amaç: Kod tabanlarını sorgulanabilir bilgi graflarına dönüştürür. Mimari sorular için
toplu dosya-grep işlemini ortadan kaldırır.
```

**Slash komutu satırı**:
```
Slash komutu: /graphify
```

**Çağrı modları tablosu başlıkları**:
```
Komut | Kullanım
```

**Tablo satır içerikleri** (komutlar kalır; kullanım Türkçe):
```
/graphify . --local-only    | Graf oluştur (kod yerel olarak işlenir, API çağrısı yok)
/graphify query "auth modülü" | Yeniden oluşturmadan anlamsal arama
/graphify . --mode deep     | Agresif ilişki çıkarımı (Anthropic API kullanır)
/graphify . --watch         | Dosyalar değiştikçe otomatik senkronize et
```

**Eşik kuralı satırı**:
```
Eşik kuralı: Analiz kapsamında 20'den fazla dosya varsa önce graphify kullanın.
20 veya daha az dosya için doğrudan Read daha ucuzdur.
```

**Tanrı sınıfı tespit eşleme tablosu başlıkları**:
```
graphify metriği | Kod kokusu | Temiz kod ihlali
```

**Tablo satır içerikleri**:
```
degree > 20                    | Tanrı Sınıfı            | Çok fazla iş yapan sınıf
degree > 10 VE type=function   | Uzun Metot / Özellik Kıskançlığı | Kendi verisinden çok başka sınıfın verisini kullanıyor
community size > 15            | Saçma Sapan Ameliyat   | Bir değişiklik birçok sınıfı düzenlemeyi gerektiriyor
cohesion_score < 0.4           | Ayrışık Değişim         | Birden fazla nedenden dolayı değiştirilen bir sınıf
```

**Belirteç bütçe kılavuzu tablosu başlıkları**:
```
İşlem | Belirteç maliyeti | Ne zaman kullanılır
```

**Tablo satır içerikleri**:
```
Graf oluştur (yalnızca kod)  | ~500   | İlk seferinde veya bayat işaretten sonra
GRAPH_REPORT.md oku          | ~300   | Her zaman oluşturmadan sonra
query_graph "god_nodes"      | ~200   | Herhangi bir mimari soru için
get_neighbors "Düğüm"        | ~100   | Bağımlılık araştırması
Ham dosya oku (~300 satır)   | ~2000  | Yalnızca satır düzeyi kanıt için
10 ham dosya oku             | ~20000 | Kaçının; bunun yerine graphify sorguları kullanın
```

**PyPI yazım hatası callout** (Warning):
```
Başlık: Uyarı — PyPI Yazım Hatası Kasıtlıdır
İçerik: Paket PyPI'de graphifyy (çift-y) olarak adlandırılmıştır. Şununla yükleyin:
uv tool install "graphifyy[all]". pip show graphifyy ile doğrulayın.
```

---

#### 5.3 Slash Komutları Referansı

**H3 başlık**: `5.3 Slash Komutları Referansı`

**Tab grubu** (sekme buton etiketleri değişmez; sekme panel içerikleri Türkçe):

**Sekme: /caveman**
```
Etki: Orkestratörden kullanıcıya giden düz metni %40-65 sıkıştırır. Kod, yollar, tanımlayıcılar,
güvenlik metinleri değişmez.

Devre dışı bırakma: "stop caveman" veya "normal mode".
```

**Sekme: /graphify**
```
Etki: --local-only modunda API çağrısı olmadan AST tabanlı kod tabanı bilgi grafı oluşturur.

Çıktı: graphify-out/graph.json, GRAPH_REPORT.md, graph.html.
```

**Sekme: /ctx**
```
Etki: İzole çalıştırma + kalıcı dizinleme için 11 ctx_* MCP aracını etkinleştirir.

Belirteç tasarrufu: x10 oturumu başına yaklaşık %76.
```

**Sekme: /review**
```
Etki: Bekleyen değişikliklere karşı .claude/rules/code-review.md kontrol listesini çalıştırır.

Örnek çıktı: (kod bloğu içindeki İngilizce metin kalır — araç çıktısı)
```

**Sekme: /security-review**
```
Etki: Odaklanmış güvenlik incelemesi (SQL enjeksiyonu, XSS, sabit kodlu gizli bilgiler, kimlik doğrulama).

Örnek çıktı: (kod bloğu içindeki İngilizce metin kalır — araç çıktısı)
```

**Sekme: /architect**
```
Etki: İstemi doğrudan T1 Principal'a (opus modeli) yönlendirir. xN gerekli değil.

Ne zaman kullanılır: Mimari tavsiye, sistem tasarımı, ADR taslağı.
```

**Önceki/Sonraki nav**:
```
← Önceki: İleri Konular
Sonraki →: Yapılandırma
```

---

### BÖLÜM 6: Yapılandırma

**Section meta**:
```
Bölüm 6
20 dakikalık okuma
Zorluk: İleri
```

**Bölüm girişi**:
```
Bu bölüm, .claude/settings.json yapısını, 19 kancayı, 5 ajan şablonunu ve 17 kural
dosyasını kataloglar. Herhangi bir bileşeni özelleştirirken başvuru noktası olarak kullanın.
```

---

#### 6.1 settings.json Yapısı

**H3 başlık**: `6.1 settings.json Yapısı`

**Giriş paragrafı**:
```
Claude Code platformu, oturum başında .claude/settings.json dosyasını okur. Kancaları,
izinleri, MCP sunucularını ve ortam değişkenlerini kaydeder.
```

**settings.json kod bloğu yorumları** (YAML/JSON anahtarları kalır; yorum varsa Türkçe):
> Bu kod bloğunda yorum satırı yoktur; değişmeden bırakın.

---

#### 6.2 Kanca Kataloğu (19 Kanca)

**H3 başlık**: `6.2 Kanca Kataloğu (19 Kanca)`

**Giriş paragrafı**:
```
Kancalar otomatik olarak tetiklenir. 1 çıkışı aracı engeller. 0 çıkışı buna izin verir.
stderr hata mesajı olarak gösterilir.
```

**H4: PreToolUse:Edit/Write (11 kanca)**

Tablo başlıkları:
```
Kanca | Zorunlu Kılar
```

Tablo satır içerikleri (dosya adları kalır; zorunlu kılar sütunu Türkçe):
```
block-console-log.sh      | Konsol ifadesi yok (log/warn/error/vb.)
block-any-type.sh         | TypeScript türsüz değer veya baskılama yönergesi yok
block-comments.sh         | Satır içi veya blok yorum yok
secret-guard.sh           | Sabit kodlu kimlik bilgisi, API anahtarı yok
no-inline-styles.sh       | JSX'te satır içi style özelliği yok
no-hardcoded-colors.sh    | Tasarım belirteçleri kullanın, onaltılık değer yok
sql-injection-check.sh    | SQL'de dize birleştirme yok
xss-prevention-check.sh   | HTML'de kullanıcı girdisini temizle
path-traversal-check.sh   | Dosya yollarında yol-geçiş örüntüsü yok
cors-wildcard-check.sh    | Joker CORS kaynağı yok
field-injection-check.sh  | Alan düzeyi autowire yok (Java)
```

**H4: PreToolUse:Bash (2 kanca)**

Tablo başlıkları:
```
Kanca | Zorunlu Kılar
```

Tablo satır içerikleri:
```
git-safety-check.sh       | Force-push, rm -rf vb. engelle
context-mode-guard.sh     | Yasaklı yollarda ctx_execute'u engelle
```

**H4: PostToolUse:Edit/Write (3 kanca)**

Tablo başlıkları:
```
Kanca | İşlev
```

Tablo satır içerikleri:
```
review-tracker.sh             | Dosya başına düzenleme sayar; 5 ve 10'da uyarır
self-learning-collector.sh    | Aynı dosyaya 2+ düzenleme tespit eder, LP örüntüsü oluşturur
figma-standards-guard.sh      | Figma'dan Ant Design dönüşüm kurallarını uygular
```

**H4: SessionEnd (3 kanca)**

Tablo başlıkları:
```
Kanca | İşlev
```

Tablo satır içerikleri:
```
update-leaderboard.sh    | Puan değişimlerini atomik olarak uygula (flock); işaret gönder
pattern-lifecycle.sh     | İsabetleri işle, hit-count >=3'te yükselt, soğuyan örüntüleri arşivle
graphify-rebuild.sh      | Kaynak dosyalar değiştiyse graphify-out/'u bayat olarak işaretle
```

---

#### 6.3 Ajan Şablonları (5)

**H3 başlık**: `6.3 Ajan Şablonları (5)`

**Giriş paragrafı**:
```
Her seviye, .claude/agents/{rol}.md içinde bir şablon dosyasına sahiptir. Orkestratör,
ajan başlatırken bu şablonları okur ve tam içerikleriyle iletir.
```

**Tablo başlıkları**:
```
Seviye | Şablon dosyası | Model | Ana davranışlar
```

**Tablo satır içerikleri** (ana davranışlar Türkçe; dosya adları + seviyeler + modeller kalır):
```
T1 | .claude/agents/principal.md    | opus   | Mimari kararlar, nihai inceleme, yükseltme hedefi
T2 | .claude/agents/staff-engineer.md | sonnet | Servis tasarımı, T3 kodunu inceler
T3 | .claude/agents/mid-coder.md    | sonnet | API uç noktaları, DTO'lar, standart CRUD
T4 | .claude/agents/lead-analyst.md | haiku  | T5 ham analizini birleştirir
T5 | .claude/agents/analyst.md      | haiku  | Kod tabanı araştırması, ham bulgular
```

---

#### 6.4 Kural Kataloğu (17 Dosya)

**H3 başlık**: `6.4 Kural Kataloğu (17 Dosya)`

**Giriş paragrafı**:
```
Kural dosyaları, ajan istemlerine bağlam olarak yüklenir ve hook katmanı tarafından uygulanır.
```

**Tablo başlıkları**:
```
Dosya | Kapsam | Ana kurallar
```

**Tablo satır içerikleri** (dosya adları kalır; kapsam ve ana kurallar Türkçe):
```
clean-code.md           | Tüm dosyalar          | 20 satır işlev sınırı, 250 satır dosya sınırı, yorum yok
code-architecture.md    | Tüm dosyalar          | Katmanlı mimari, özellik modülleri, SOLID
implementation.md       | TS dosyaları          | Katı TypeScript, hata sınıfları, fabrika örüntüleri
code-review.md          | Tüm dosyalar          | İnceleme kontrol listesi, önem seviyeleri, sonuç kuralları
backend-development.md  | Java/Kotlin           | Katmanlı controller'lar, yapıcı enjeksiyonu, doğrulama
backend-security.md     | Java/güvenlik         | SQL enjeksiyonu, XSS, JWT, CORS, hız sınırlama
java-quality-tooling.md | Java dosyaları        | Checkstyle, SpotBugs, JaCoCo, SonarQube
commit-standards.md     | Git işlemleri         | Geleneksel commit'ler, 50 karakterlik konu
pr-standards.md         | Pull request'ler      | 500 satır sınırı, 15 dosya sınırı, PR şablonu
git-safety.md           | Git işlemleri         | Yazma işlemleri için açık onay zorunlu
analysis.md             | T4/T5 çıktıları       | Yazma izni sınırları, rapor şablonu
graphify-usage.md       | T4/T5                 | graphify ne zaman kullanılır, eşik kuralları, jq sorguları
context-mode-usage.md   | Tüm ajanlar           | Zorunlu yönlendirme kuralları, yasaklı yollar
caveman.md              | Orkestratör çıktısı   | Tetikleyici tespiti, stil kuralları, istisnalar
metrics-tracking.md     | Hook sistemi          | Öz-öğrenme döngüsü, puan değişimleri, yaşam döngüsü
react.md                | React dosyaları       | Bileşen örüntüleri, kancalar, Ant Design entegrasyonu
testing.md              | Test dosyaları        | AAA örüntüsü, fabrika işlevleri, kapsam hedefleri
```

**Kapanış satırı**:
```
Yükseltilen örüntüler, öğrenilen örüntüler hit-count >= 3'e ulaştığında otomatik olarak
oluşturulan .claude/rules/learned-{kategori}.md dosyalarında yaşar.
```

**Önceki/Sonraki nav**:
```
← Önceki: Araçlar Referansı
Sonraki →: Sorun Giderme
```

---

### BÖLÜM 7: Sorun Giderme

**Section meta**:
```
Bölüm 7
15 dakikalık okuma
Zorluk: Orta
```

**Bölüm girişi**:
```
Bu bölüm, yaygın hataları, kanca hatalarını, izin sorunlarını, maliyet aşmalarını ve
anti-kalıpları ele alır.
```

---

#### 7.1 Yaygın Hatalar ve Kurtarma

**H3 başlık**: `7.1 Yaygın Hatalar ve Kurtarma`

**Tablo başlıkları**:
```
Belirti | Muhtemel neden | Kurtarma
```

**Tablo satır içerikleri** (araç/dosya adları kalır; açıklamalar Türkçe):
```
Tüm lider tablosu puanları 0 kalıyor | update-leaderboard.sh settings.json SessionEnd'e bağlı değil | settings.json hooks.SessionEnd dizisini yeniden doğrula
Örüntü hit-count hiç artmıyor | pattern-lifecycle.sh oturum dosyasını okumuyor | update-leaderboard.sh'daki işaret gönderimi kontrol et
Kanca meşru düzenlemeyi engelliyor | Kanca regex'i çok agresif | Kanca script'ini incele; istisna ekle veya örüntüyü iyileştir
graphify bayat sonuçlar döndürüyor | .graphify-stale işareti mevcut | Yeniden oluştur: /graphify . --local-only; işareti kaldır
Ajan bağlam taşması | Seviye bütçesi için görev >15K belirteç | Taşma Protokolü: görevi böl veya seviyeyi yükselt
Model daha düşük seviyeye düşüyor | opus kotası aşıldı | Sıfırlanmasını bekle; bu arada sonnet/haiku kullan
macOS lider tablosu güncellenmiyor | macOS'ta varsayılan Bash 3.2 | bash 5 yükle: brew install bash
```

---

#### 7.2 Kanca Hataları ve Hata Ayıklama

**H3 başlık**: `7.2 Kanca Hataları ve Hata Ayıklama`

**Giriş paragrafı**:
```
Bir kanca düzenlemeyi engellediğinde, kanca script'inin stderr çıktısı Claude'a gösterilir.
Araç çağrısı çıkış koduyla başarısız olur.
```

**"Bir kancayı elle test edin:" etiketi**: `Bir kancayı elle test edin:`

**Kod bloğu yorumları** (Türkçe):
```
# Örnek girdiyle kancayı simüle et
# İhlal içeren örnek için beklenen çıktı:
# BLOCKED: console statements are prohibited in production code
# exit: 2
```
> **Not T3-B**: İkinci ve üçüncü yorum satırı araç çıktısıdır; İngilizce olarak kalır.

**Hook çıktısı callout** (Info):
```
Başlık: Not — Kanca çıktısı stderr'e gider
İçerik: Tam hata için Claude'un araç çıktı panelini kontrol edin. Kanca script'leri kullanıcı
dostu mesajları stdout değil stderr'e yazmalıdır.
```

---

#### 7.3 İzin Reddedilmeleri

**H3 başlık**: `7.3 İzin Reddedilmeleri`

**Giriş paragrafı**:
```
Claude Code, izin verilenler listesinde olmayan araçlar ve Bash örüntüleri için izin ister.
Yaygın örüntüleri settings.json dosyasına ekleyerek önceden onaylayabilirsiniz.
```

**Kapanış cümlesi**:
```
Yıkıcı işlemler için (git push, rm -rf vb.) oturum başına açık onay gereklidir.
git-safety-check.sh kancası bunu uygular.
```

---

#### 7.4 Maliyet Aşmaları ve Optimizasyon

**H3 başlık**: `7.4 Maliyet Aşmaları ve Optimizasyon`

**"Maliyet aşması belirtileri:" etiketi**: `Maliyet aşması belirtileri:`

Madde listesi:
```
- x10 oturumu >45 dakika çalışıyor
- Tekrarlanan revizyon turları (birden fazla kez revision_attempts > 1)
- Sık yükseltmeler
- token-usage.md seviye bütçelerinin aşıldığını gösteriyor
```

**"Hızlı çözüm:" etiketi**: `Hızlı çözüm:`

Madde listesi:
```
- Oturumu iptal edin ve daha düşük xN ile yeniden başlatın
- Orkestratör düzyazısını sıkıştırmak için /caveman kullanın (Orkestratör belirteçlerinde ~%40-65 tasarruf)
- Analizi alt sürece boşaltmak için /ctx kullanın (x10'da ~%76 tasarruf)
- Birçok dosya okumak yerine /graphify kullanın (mimari sorgularda ~71x tasarruf)
```

**Çapraz referans satırı**:
```
Tam maliyet optimizasyonu stratejileri için bkz. Bölüm 4.5.
```

---

#### 7.5 Anti-Kalıplar (Yapılmaması Gerekenler)

**H3 başlık**: `7.5 Anti-Kalıplar (Yapılmaması Gerekenler)`

**12 Danger Callout — Başlık ve İçerik Çevirileri**:

```
G.1 - xN'i önemsiz bir görevle birleştirme
KÖTÜ: x10 ile tek satırlık temizlik istemek. DOĞRU: xN parametresini bırakın; önemsiz
görevler için tek ajan modunu kullanın.

G.2 - T3'ten mimari karar istemek
KÖTÜ: T1 (Opus) gerektiğinde sistem tasarımını T3'e (Sonnet) atamak. DOĞRU: T1 Principal'a
yönlendirmek için /architect kullanın.

G.3 - ctx_execute'u hassas işlemlerde kullanma
KÖTÜ: Context-mode aracılığıyla kimlik bilgilerine erişen komutlar çalıştırmak. DOĞRU:
Ortam değişkenlerini veya güvenli depoları kullanın. Gizli bilgileri asla metin olarak
geçirmeyin.

G.4 - graphify'ı --local-only olmadan çalıştırma
KÖTÜ: Gizli kodu harici API'ye göndermek. DOĞRU: Kod analizi için her zaman --local-only
kullanın.

G.5 - İnceleme zincirini atlamak
KÖTÜ: Çoklu ajan modunda zorunlu inceleme katmanlarını atlatmak. DOĞRU: Sistem inceleme
zincirini otomatik olarak uygular; atlanamaz.

G.6 - --no-verify ile kancaları atlatmak
KÖTÜ: Kalite kapılarını atlamak için --no-verify kullanmak. DOĞRU: İhlalleri düzeltin ve
normal şekilde commit yapın.

G.7 - xN maliyetinin doğrusal olduğunu varsaymak
KÖTÜ: x10'un tek ajan'dan 10 kat daha pahalı olduğunu düşünmek. DOĞRU: x10 mutlak
anlamda ~15-20 kat daha pahalıdır ama karmaşık sorunları 10-20 kat daha hızlı çözer.

G.8 - x10'un <5 dakikada biteceğini beklemek
KÖTÜ: x10 oturumunun anında bitmesini planlamak. DOĞRU: Tam x10 çalıştırması için
25-35 dakika planlayın.

G.9 - Kritik kararlar için caveman kullanmak
KÖTÜ: Caveman modunda mimari soru sormak (sıkıştırılmış yanıt). DOĞRU: Tam bağlam
gerektiren kararlar için normal modu kullanın.

G.10 - .graphify-stale'i kontrol etmemek
KÖTÜ: Güncel olmayan topolojiyle bayat graph.json'ı sorgulamak. DOĞRU: Sorgulamadan önce
bayat işareti kontrol edin; gerekirse yeniden oluşturun.

G.11 - İlgisiz görevleri tek oturumda birleştirmek
KÖTÜ: Tek x5'te kimlik doğrulama + raporlama + kısıtlama. DOĞRU: Özelliğe göre ayırın,
oturumları da ayırın.

G.12 - Doğrulanmamış örüntülere güvenmek
KÖTÜ: Düşük güvenlikli öğrenilen örüntülere kural gibi davranmak. DOĞRU: Örüntüler
sezgiseldir; nihai inceleme hâlâ doğrular.
```

**Önceki/Sonraki nav**:
```
← Önceki: Yapılandırma
Sonraki →: Referans
```

---

### BÖLÜM 8: Referans

**Section meta**:
```
Bölüm 8
Referans
Tüm seviyeler
```

**Bölüm girişi**:
```
Sistem için hızlı başvuru kaynakları: basılabilir Kısa Referans Kartı, teknik terimlerin
sözlüğü, sık sorulan soruların yanıtları ve metrik yorumlama kılavuzu.
```

---

#### 8.1 Kısa Referans Kartı

**H3 başlık (cheat sheet kart başlığı)**: `Kısa Referans Kartı`

**Yazdır butonu**: `Yazdır`

**Üç sütun başlıkları**:
```
Slash Komutları | xN Modları | Hızlı Kararlar
```

**Slash Komutları tablosu başlıkları**:
```
Komut | Kullanım
```

Satır içerikleri (komutlar kalır; kullanım Türkçe):
```
/caveman         | Kısa çıktı
/graphify        | Kod tabanı grafı
/ctx             | Context-mode
/review          | Kod incelemesi
/security-review | Güvenlik denetimi
/architect       | T1'e yönlendir
```

**xN Modları tablosu başlıkları**:
```
Mod | Maliyet
```

Satır içerikleri (mod adları + maliyet değerleri değişmez; sütun başlığı Türkçe).

**Hızlı Kararlar tablosu başlıkları**:
```
Eğer | O zaman
```

Satır içerikleri (değerler kalır; koşul metni Türkçe):
```
<3 satır, 1 dosya    | Single
Yalnızca araştırma   | x2
Küçük özellik        | x3
Varsayılan           | x5
Sistem geneli        | x10
>20 dosya            | +/graphify
Uzun oturum          | +/ctx
```

---

#### 8.2 Sözlük

**H3 başlık**: `8.2 Sözlük`

**Tüm terim tanımları** (dt = terim değişmez; dd = tanım Türkçe):

```
xN
Çoklu ajan etkinleştirme parametresi. O kadar ajan başlatmak için bir istemin sonuna x2
ile x10 arası bir değer ekleyin.

PEP (Prompt Enrichment Protocol)
Görev öncesi netleştirme aşaması. Orkestratör, ajan başlatmadan önce önerilen
varsayılanlarla birlikte 3-7 soru sorar. Önemsiz görevler için atlanır.

DAG
Yönlü Asiklik Graf. Alt görevlerin bağımlılık yapısı. Dalga çalıştırması, DAG üzerinde
topolojik sıralamayı kullanır.

Wave (Dalga)
Paralel çalışabilen bağımsız alt görevler kümesi. Dalgalar sıralı olarak çalışır.

Tier (T1-T5) [Seviye]
Ajan yetenek seviyesi. T1 = opus (Principal). T2/T3 = sonnet (Mühendis/MidCoder).
T4/T5 = haiku (Analist).

Orchestrator (Orkestratör)
Ana Claude oturumu. Ajanları koordine eder, incelemeleri yönetir, çoklu ajan modunda
asla uygulama kodu yazmaz.

Review chain (İnceleme Zinciri)
Sıralı onay akışı: T5 → T4 → T2 → T1. Sonuçlar: Onaylandı, Revizyon Gerekli, Reddedildi.

revision_attempts
Bir görevin revizyon bulgularıyla kaç kez yeniden başlatıldığını izleyen sayaç.
İki = zorunlu yükseltme.

Escalation (Eskalasyon)
Başarısız bir görevi daha yüksek bir seviyeye yeniden atama. Yeni ajan, yükseltme tohumunu
alır (önceki çıktı + inceleme bulguları + orijinal görev).

God node / God class (Tanrı Düğümü / Tanrı Sınıfı)
graphify grafında degree > 20 olan bir sınıf — çok fazla gelen ve giden çağrı. SRP ihlali.

graphify
AST tabanlı kod tabanı bilgi grafı oluşturucu. Her dosyayı okumadan topoloji analizi için
kullanılır.

context-mode
İzole alt süreç çalıştırma ve kalıcı FTS5 bilgi tabanı sağlayan MCP araç paketi.

ctx_index
Oturumlar arası erişim için bir bulguyu kalıcı FTS5 bilgi tabanında sakla.

ctx_search
Dizinlenmiş bilgide BM25 sıralı arama. Oturum dosyalarını yeniden okumak yerine kullanılır.

Stale marker (Bayat İşaret)
graphify-out/.graphify-stale dosyası. Kaynak kodun graf oluşturulmadan bu yana değiştiğini
gösterir.

File ownership (Dosya Sahipliği)
Her dosya oturum başına tam olarak bir ajan tarafından sahiplenilir. Eş zamanlı düzenlemeleri
önler.

Learned pattern (LP) (Öğrenilen Kalıp)
Tekrarlanan inceleme reddedilmelerinden otomatik oluşturulan kural. .claude/memory/learned-patterns/
içinde yaşar.

hit-count
Öğrenilen bir örüntünün hata anahtar sözcüklerinin tespit edildiği oturum sayısı.
Yükseltme eşiği: 3.

Caveman mode (Caveman Modu)
İsteğe bağlı kısa-düzyazı stili. /caveman komutu veya "caveman" kelimesiyle tetiklenir.
Kod blokları ve güvenlik metinleri birebir kalır.

Name pool (İsim Havuzu)
Ajanlar için 20 Türkçe görünen ad. Seçim puan ağırlıklı rastgele örneklemedir.

Score deltas (Puan Değişimleri)
SessionEnd'de ajan adlarına uygulanan olay başına puan değişimleri. Lider tablosunu yönlendirir.
```

---

#### 8.3 SSS

**H3 başlık**: `8.3 SSS`

Tüm 16 soru ve cevap çevirisi:

```
S: Bu sistem nedir?
C: Claude Code Çoklu Agent Delegasyon Sistemi, Claude Code v1.0.0 üzerine kurulu bir
orkestrasyon katmanıdır. Mühendislik görevlerini farklı yetenek seviyelerindeki yapılandırılmış
yapay zeka ajansı ekibine dağıtır; zorunlu inceleme zincirleri ve kanca tabanlı kalite
uygulamasıyla birlikte.

S: Bu kimler içindir?
C: Kodlama standartlarının otomatik uygulamasıyla Claude Code'dan tutarlı, incelenmiş çıktı
isteyen geliştirme ekipleri için. Önemsiz tek seferlik sorular için gerekli değil — sistem bunları
algılar ve tek ajan modunda çalıştırır.

S: Bir xN değeri nasıl seçerim?
C: Önemsiz için Single (xN yok); araştırma için x2; küçük özellikler için x3; tam incelemeyle
standart özellikler için x5 (varsayılan); paralel izler için x7; sistem revizyonları için x10.
Kararsız kaldığınızda x5.

S: x10'u NE ZAMAN kullanmamalıyım?
C: Tek dosyalık değişiklikler, önemsiz hata düzeltmeleri veya 5 satırın altındaki herhangi bir
görev için. x10 $12-18 maliyetlidir ve 25-35 dakika sürer. Yalnızca kapsam gerçekten modüller
arası olduğunda kullanın.

S: Bir kanca düzenlemeyi engellerse ne olur?
C: Araç çağrısı, kanca'nın stderr mesajıyla başarısız olur. İhlali düzeltin ve yeniden deneyin.
Kancaları asla atlatmayın — bir nedenleri var.

S: Bir ajanın revizyon sayacını nasıl sıfırlarım?
C: Sıfırlamazsınız — görev bir sonraki seviyeye yükseltildiğinde (T3 → T2 veya T2 → T1)
otomatik olarak sıfırlanır. Aynı seviye içindeki yeniden başlatmalar sayacın artmaya devam
etmesine neden olur.

S: x10 ile caveman modunu birlikte kullanabilir miyim?
C: Evet. Caveman modu xN'den bağımsızdır. Yalnızca Orkestratörden kullanıcıya giden düzyazıyı
etkiler. Ajan başlatma istemleri, kod blokları ve performans raporu tabloları, moddan
bağımsız olarak her zaman kapsamlı kalır.

S: graphify neden bayat sonuçlar veriyor?
C: graphify-out/.graphify-stale dosyasına bakın. Varsa, kaynak dosyalar graf oluşturulmadan
bu yana değişmiştir. /graphify . --local-only ile yeniden oluşturun ve işareti silin.

S: Öğrenilen bir kalıbı elle nasıl yükseltirim?
C: Ön yüzdeki hit-count değerini 3 veya üzerine düzenleyin. Bir sonraki SessionEnd,
kalıbı .claude/rules/learned-{kategori}.md dosyasına ekleyecek pattern-lifecycle.sh'ı tetikler.

S: Ajanlar birbiriyle doğrudan iletişim kurabilir mi?
C: Hayır. Tüm ajanlar arası iletişim Orkestratör üzerinden akar. T5, .claude/analysis/raw/'a
yazar, T4 bunu okuyup .claude/analysis/consolidated/'a yazar ve Orkestratör bulguları
başlatma istemleri aracılığıyla kodlama ajanlarına yönlendirir.

S: Bir ajan belirteç bütçesini aşarsa ne olur?
C: Taşma Protokolü uygulanır: alt görevi birden fazla ajan arasında bölün ya da bir üst
seviyeye yükseltin. Seviye bütçeleri .claude/config/context-budget.json dosyasında tanımlanmıştır.

S: graphify kodum dış API'ye gönderiyor mu?
C: Yalnızca --local-only olmadan. Yalnızca kod analizi için her zaman --local-only kullanın.
--mode deep seçeneği, anlamsal ilişki çıkarımı için Anthropic API'yi kullanır — tescilli kodda
kullanmaktan kaçının.

S: Bir oturumu geri alabilir miyim?
C: Sistem otomatik olarak hiçbir şeyi commit etmez. Tüm dosya düzenlemeleri çalışma
dizininizde kalır. Standart git araçlarını kullanın: incelemek için git diff, geri almak için
git checkout . (yıkıcı).

S: x10, tek ajandan 10 kat daha pahalı mı?
C: Hayır. Opus fiyatlandırmasında tek ajan, belirteç başına daha pahalıdır. Haiku, opus'tan
~12 kat ucuzdur. x10 mutlak anlamda ~15-20 kat daha pahalıdır ama işi daha ucuz seviyeler
arasında dağıtır.

S: Bunu Linux'ta kullanabilir miyim?
C: Evet. macOS ve Linux'ta (Debian/Ubuntu/Alpine) test edilmiştir. WSL çalışır. macOS'a
özgü not: macOS'ta varsayılan bash 3.2, lider tablosu güncellemelerinin sessizce atlanmasına
neden olur. macOS'ta Homebrew aracılığıyla bash 5 yükleyin.

S: PEP nedir ve ne zaman çalışır?
C: İstem Zenginleştirme Protokolü. Orkestratör, çoklu ajan görevi için ajan başlatmadan
önce 3-7 netleştirici soru sorar. Önemsiz görevler için (3 satırdan az, en fazla 1 dosyaya
dokunuyor) veya kullanıcı "skip questions" dediğinde atlanır.
```

---

#### 8.4 Metrikler Yorumlaması

**H3 başlık**: `8.4 Metrikler Yorumlaması`

**"token-usage.md yapısı:" etiketi**: `token-usage.md yapısı:`

**Kod bloğu içindeki tablo başlıkları** (Türkçe):
```
# Belirteç Kullanım Takibi

## Oturum Özeti
| Oturum | Tarih | Mod | Toplam Belirteçler | Ortalama/Ajan | Maliyet (API) |

## Ajan Seviyesi Bütçeleri (Tahmini)
| Seviye | Model | Belirteç/Görev | Maliyet/Görev |
```

**"leaderboard.md örneği:" etiketi**: `leaderboard.md örneği:`

**Kod bloğu içindeki tablo başlıkları** (Türkçe):
```
| Sıra | İsim | Puan | Oturumlar | Seviye | Durum |
```

**Durum sütunu değerleri** (Türkçe):
```
Güvenilir | Tutarlı | Gelişiyor | Yeni
```

**Yorum madde listeleri** — Puan yorumu (başlık + maddeler):
```
Puan yorumu:
- > 20 puan → A-kademe; yüksek görünürlüklü görevler için tercih edilir
- 0-19 puan → B-kademe; dengeli seçim
- Negatif puan → Performansa bakın; bağlam içi yükseltmeler veya başarısız görevler nedeniyle olabilir
- Puan sıfırlanmaz; dönem içi hareketliliği gösterir
```

**Maliyet içgörüsü (başlık + maddeler)**:
```
Maliyet içgörüsü:
- Ortalama/Ajan > 150K belirteç → bağlamı azaltmak için /ctx etkinleştirmeyi düşünün
- Yüksek T1 oranı → daha önemsiz görevleri T3'e veya T5'e indirgeme fırsatı
```

---

## 5. Glossary Uygulama Kuralları

### Bağlayıcı Terminoloji (H03 Master Glossary Özeti)

T3-A ve T3-B aşağıdaki kurallara kesinlikle uymalıdır:

| Kural | Doğru | Yanlış |
|-------|-------|--------|
| Orchestrator terimi | Orkestratör | Koordinatör |
| Tier isimleri | T1 Principal, T2 Staff Engineer, T3 MidCoder, T4 Lead Analyst, T5 Analyst | Türkçe karşılıklar |
| Generic seviye referansı | "üst seviye", "haiku seviyesinde" | "tier" (Türkçe bağlamda) |
| Slash komutları | /caveman, /graphify, /ctx, /review, /security-review, /architect | Türkçe karşılık |
| Model adları | opus, sonnet, haiku | Türkçe karşılık |
| İnceleme zinciri | İnceleme Zinciri | Review Chain (metin içinde) |
| Escalation | Eskalasyon (isim) / Yükseltme (fiilimsi) | — |
| Hook | Kanca | hook (Türkçe metinde) |
| Wave | Dalga | — |
| Token | Belirteç (API bağlamı) | token (Türkçe cümlede) |
| Workflow | İş akışı | workflow (Türkçe bağlamda) |
| Walkthrough | İzlenecek Yol | — |
| Pattern | Örüntü veya Kalıp | — |
| Learned pattern | Öğrenilen Kalıp | — |
| God class | Tanrı Sınıfı | — |
| Leaderboard | Lider Tablosu | — |
| Dark mode | Gece Modu | — |
| Note callout | Not | — |
| Warning callout | Uyarı | — |
| Tip callout | İpucu | — |
| Error callout | Hata | — |
| Success callout | Başarı | — |
| Quick Start | Hızlı Başlangıç | — |
| Copy button | Kopyala / Kopyalandı | — |
| Print button | Yazdır | — |
| Toggle navigation | Navigasyonu Aç/Kapat | — |
| Jump to | Şuraya Atla | — |
| FAQ | SSS | — |
| Cheat Sheet | Kısa Referans Kartı | Hile Sayfası |

### Değişmeyen Elementler (Kesinlikle çevrilmez)

```
- Dosya yolları: .claude/config/name-pool.md, src/features/...
- Slash komut adları: /caveman, /graphify, /ctx
- Tier etiketleri: T1, T2, T3, T4, T5
- Model adları: opus, sonnet, haiku
- Hook dosya adları: block-console-log.sh, sql-injection-check.sh
- xN mode adları: x2, x3, x5, x7, x10
- Kod identifier'ları: UserService, createUser(), revision_attempts
- JSON anahtarları: "permissions", "mcpServers", "hooks"
- Bash komutları ve flag'leri: --local-only, --format json
- Regex örüntüleri: ^[A-Z], (?:^|\s)caveman(?:\s|[^\w])
- URL'ler: https://...
- Para birimi değerleri: $0.50, $4-6
- Emoji'ler: ✅, ⚠️, 🔴, 📋
- Teknik kısaltmalar: SOLID, CORS, XSS, JWT, MCP, API
- Ürün adları: Claude Code, Ant Design, Figma
- Araç adları: graphify, context-mode, ctx_execute
```

### Karma Dil String'i Kuralı

```
İngilizce: "use /ctx command"         → Türkçe: "/ctx komutunu kullanın"
İngilizce: "T1 Principal reviews"     → Türkçe: "T1 Principal inceler"
İngilizce: "Wave 1 analysis"          → Türkçe: "Dalga 1 analizi"
İngilizce: "Exit code 1 blocks"       → Türkçe: "1 çıkış kodu engeller"
İngilizce: "config/name-pool.md file" → Türkçe: "config/name-pool.md dosyası"
```

### Kod Bloğu Yönetimi

```
Çevrilir:   - Yorum satırları (# ile başlayanlar)
            - String literal açıklama metinleri
            - Markdown section başlıkları (## Error → ## Hata)

Çevrilmez:  - Kod syntax (const, public, @Bean, vb.)
            - Identifier'lar (UserService, getUserById)
            - Dosya yolları (.claude/hooks/block-console-log.sh)
            - Araç çıktıları (hata mesajları, terminal çıktıları)
            - JSON anahtar adları
            - Bash komutları
```

---

## 6. T3 Kalite Kontrol Listesi

Bir bölümü tamamlamadan önce T3-A ve T3-B aşağıdakileri kontrol etmelidir:

### İçerik Kontrolü

- [ ] Her bölüm, 2-3 cümlelik giriş paragrafıyla başlıyor
- [ ] Her H3 alt bölümde en az 1 paragraf + 1 görsel öge (tablo/callout/kod) var
- [ ] Hiçbir İngilizce cümle metin paragraflarında kalmıyor
- [ ] Tüm tablo başlıkları Türkçe
- [ ] Tüm callout başlıkları ve gövdeleri Türkçe
- [ ] Tüm UI string'leri (buton, placeholder, ARIA etiketleri) Türkçe

### Terminoloji Kontrolü

- [ ] "Orkestratör" tutarlı kullanılıyor; "Koordinatör" yok (tek başına)
- [ ] Tier isimleri (T1 Principal vb.) İngilizce kalıyor
- [ ] Slash komutları değişmeden kalıyor (/caveman, /graphify, vb.)
- [ ] Model adları değişmeden kalıyor (opus, sonnet, haiku)
- [ ] Dosya yolları değişmeden kalıyor (.claude/...)
- [ ] "Siz" formu kullanılıyor; "sen" formu yok
- [ ] "hocam" hitabı yok

### Teknik Kontrol

- [ ] Anchor ID'leri değişmedi (#quick-start, #five-tiers, vb.)
- [ ] Kod bloklarında yalnızca yorum satırları çevrilmiş; syntax değişmemiş
- [ ] Çapraz referanslar doğru bölüm numaralarına işaret ediyor
- [ ] Önceki/Sonraki nav'daki bölüm adları çevrilmiş ama anchor ID'leri kalıyor

### Ton ve Dil Kontrolü

- [ ] Formal Türkçe, "siz" formu
- [ ] Teknik ama anlaşılır — kuru veya robotik değil
- [ ] Türkçe doğal okuyor (kelimesi kelimesine çeviri değil)
- [ ] Örnekler gerçek (placeholder metin yok)
- [ ] UTF-8 karakter kodlaması doğru (ç, ğ, ı, ö, ş, ü)

### Yapısal Kontrol

- [ ] HTML yapısı korunmuş (sadece metin içeriği değişmiş)
- [ ] Tüm bağlantılar çalışıyor (anchor hedefleri değişmedi)
- [ ] Tablo sütunları hizalanmış
- [ ] Kod blokları biçimlendirilmiş

---

*Hazırlayan: Enis Sait Erken (T2 Staff Engineer)*
*Tarih: 2026-05-22*
*Oturum: 2026-05-22-html-tr-examples-x10*
*Kaynak belgeler: H01-html-english-audit.md, H03-translation-scope.md, docs/index.html*
