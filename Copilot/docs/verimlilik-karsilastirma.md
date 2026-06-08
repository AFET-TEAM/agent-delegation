# Verimlilik Karşılaştırma Tablosu

Bu dokümanda, Context Efficiency ve Knowledge Graph özelliklerinin **aktif olduğu** ve **olmadığı** durumlar arasındaki farkları gösteren karşılaştırma tabloları yer almaktadır.

---

## 1. Genel Davranış Karşılaştırması

| Durum | Özellik KAPALI (Eski Davranış) | Özellik AÇIK (Yeni Davranış) |
|-------|-------------------------------|------------------------------|
| Büyük dosya okuma | Dosya baştan sona okunur (~4000 token) | grep ile sadece ilgili satırlar okunur (~200 token) |
| Analiz raporu | Tüm bulgular inline gösterilir | 200+ satır → dosyaya yazılır, özet gösterilir |
| Bulgu güvenilirliği | "Bu dosya karmaşık" (belirsiz) | "🟡 INFERRED (0.7): Cyclomatic complexity 18" (ölçülebilir) |
| Dosya arama | Tüm dosyalar okunarak aranır | Önce grep → sonra sadece eşleşenler okunur |
| Bağımlılık analizi | Manuel okuma ile tespit | İlişki haritası + God Node tespiti |
| Çıktı boyutu kontrolü | Sınırsız inline çıktı | Tip bazlı bütçe (durum ≤500, rapor ≤2000 token) |
| Tekrarlayan bilgi | Aynı bilgi birden fazla kez yazılabilir | Referans ile yönlendirme ("yukarıda belirtildiği gibi") |
| Aynı dosyanın tekrar okunması | Her ihtiyaçta yeniden okunabilir | İlk okumada tüm gerekli bilgi çıkarılır |

---

## 2. Token Kullanım Karşılaştırması (Senaryo Bazlı)

### Senaryo A: Tek Dosya Analizi (800 satırlık servis dosyası)

| Metrik | KAPALI | AÇIK | Fark |
|--------|--------|------|------|
| Dosya okuma token | ~4,000 | ~300 (grep ile) | **-92.5%** |
| Analiz çıktı token | ~800 | ~600 (yapılandırılmış) | **-25%** |
| Toplam token | ~4,800 | ~900 | **-81%** |

### Senaryo B: Multi-Dosya Bağımlılık Taraması (150 dosya projesi)

| Metrik | KAPALI | AÇIK | Fark |
|--------|--------|------|------|
| Okunan dosya sayısı | 150 (hepsini okur) | 12 (sadece eşleşenler) | **-92%** |
| Input token | ~300,000 | ~24,000 | **-92%** |
| Output token | ~5,000 | ~3,500 | **-30%** |
| Toplam token | ~305,000 | ~27,500 | **-91%** |

### Senaryo C: Standart Feature Geliştirme (3 dosya oluştur/düzenle)

| Metrik | KAPALI | AÇIK | Fark |
|--------|--------|------|------|
| Input token | ~15,000 | ~12,000 | **-20%** |
| Output token | ~4,000 | ~3,200 | **-20%** |
| Toplam token | ~19,000 | ~15,200 | **-20%** |
| Bağlam penceresi kullanımı | %28 | %22 | **-6 puan** |

### Senaryo D: x10 Multi-Agent Görev (10 ajan paralel)

| Metrik | KAPALI | AÇIK | Fark |
|--------|--------|------|------|
| T5 Analyst (×3) toplam | ~54,000 | ~30,000 | **-44%** |
| T3 MidCoder (×2) toplam | ~30,000 | ~22,000 | **-27%** |
| T2 Staff Eng (×2) toplam | ~60,000 | ~43,000 | **-28%** |
| T1 Principal (×2) toplam | ~24,000 | ~17,000 | **-29%** |
| T4 Lead Analyst (×1) toplam | ~12,000 | ~8,000 | **-33%** |
| **GENEL TOPLAM** | **~180,000** | **~120,000** | **-33%** |

---

## 3. Mod Kombinasyonu Karşılaştırması

| Konfigürasyon | Input Token | Output Token | Toplam | Tasarruf |
|--------------|-------------|-------------|--------|----------|
| Normal (hiçbir mod aktif değil) | ~45K | ~8K | ~53K | — |
| Sadece Baseline (her zaman aktif) | ~35K | ~7K | ~42K | **%21** |
| Baseline + `/context-mode` | ~28K | ~6K | ~34K | **%36** |
| Baseline + `/caveman` | ~35K | ~3.2K | ~38.2K | **%28** |
| Baseline + `/context-mode` + `/caveman` | ~28K | ~2.4K | ~30.4K | **%43** |

> Not: "Normal" satırı baseline kuralları henüz yokken (eski durumu) temsil eder. Mevcut sistemde baseline her zaman aktiftir.

---

## 4. Ajan Tipi Bazında Etki

| Ajan Tipi | En Çok Fayda Gördüğü Alan | Tahmini Tasarruf | Neden |
|-----------|--------------------------|-----------------|-------|
| T5 Analyst | Query-First + Think-in-Code | **%40-50** | Çok dosya okur, büyük raporlar üretir |
| T4 Lead Analyst | Output Routing + Confidence Tagging | **%30-40** | Birden fazla raporu konsolide eder |
| T3 MidCoder | Think-in-Code + Blocked Patterns | **%20-30** | Dosya okuma/yazmada tasarruf |
| T2 Staff Engineer | Query-First + Output Routing | **%25-35** | Kompleks implementasyonda hedefli okuma |
| T1 Principal | Progressive Disclosure + Review | **%20-30** | Review'da sadece kritik bölümleri okur |

---

## 5. Bilgi Kalitesi Karşılaştırması

| Kalite Metriki | KAPALI | AÇIK |
|----------------|--------|------|
| Bulgu doğrulanabilirliği | "Dosya karmaşık görünüyor" | "🟢 EXTRACTED: 450 satır, 12 metot, CC=18" |
| Kaynak referansı | Genellikle yok | Her bulgu kaynak:satır içerir |
| Güvenilirlik bilgisi | Yok — her şey kesinmiş gibi yazılır | 🟢/🟡/🔴 + puan ile şeffaf |
| Kritik nokta tespiti | Manuel inceleme gerekir | God Node Detection otomatik |
| İlişki görünürlüğü | Sadece doğrudan import'lar | imports + extends + calls + configures haritası |
| False positive riski | Yüksek — çıkarımlar kesin gibi yazılır | Düşük — 🔴 AMBIGUOUS ile belirsizlik açıkça belirtilir |

---

## 6. Operasyonel Farklar

| Operasyon | KAPALI | AÇIK |
|-----------|--------|------|
| "Bu servis ne yapıyor?" | Tüm dosyayı oku → 850 satır = ~4K token | grep "export\|public\|async" → 15 satır = ~100 token |
| "Kim bu modülü kullanıyor?" | 50 dosya oku, ara | grep "import.*ModuleName" → 5 satır = ~50 token |
| "Test coverage durumu nedir?" | Test dosyalarını oku + say | glob "\*\*/\*.test.\*" → count + coverage report grep |
| "Bağımlılıklar güncel mi?" | package.json oku, tek tek kontrol | grep "dependencies" + outdated komutu → özet |
| "Güvenlik açığı var mı?" | Her dosyayı oku, eval/exec ara | grep -r "eval\|exec\|innerHTML" → hedefli |

---

## 7. Uyarılar ve Limitler

### Özellik Tasarruf SAĞLAMAZ Durumlar

| Durum | Neden |
|-------|-------|
| Küçük dosyalar (< 50 satır) | Zaten kısa, grep ile okuma arasında fark yok |
| Yeni dosya oluşturma | Üretilen kod sıkıştırılamaz |
| Basit 1-dosya düzenleme | Overhead > tasarruf |
| Tam dosya içeriğinin gerçekten gerektiği durumlar | view kaçınılmaz |

### Potansiyel Dezavantajlar

| Durum | Risk | Azaltma |
|-------|------|---------|
| Aşırı grep kullanımı | Bağlam kaybı — "ağaçları görmek ama ormanı görememek" | Progressive Disclosure ile dengelenir |
| Confidence tagging overhead | Ek ~50-100 token/bulgu | Sadece T4/T5 için zorunlu |
| Yoğunlaştırılmış mod yükü | +4.5K token skill yükleme | Sadece büyük görevlerde aktifle |

---

## 8. Özet Sonuç Tablosu

| Kategori | Normal Mod | + Context Mode | + Caveman | + Her İkisi |
|----------|-----------|---------------|-----------|-------------|
| **Input verimliliği** | Temel | ⬆️ %30-40 | Değişmez | ⬆️ %30-40 |
| **Output verimliliği** | Temel | ⬆️ %20-25 | ⬆️ %40-65 | ⬆️ %55-75 |
| **Toplam token tasarrufu** | — | %25-35 | %30-50 | **%40-55** |
| **Bilgi kalitesi** | İyi | Çok iyi (güven etiketli) | Aynı (sıkışık) | Çok iyi + sıkışık |
| **Teknik doğruluk** | Korunur | Korunur | Korunur | Korunur |
| **Kullanım karmaşıklığı** | Sıfır | Düşük (slash command) | Düşük | Düşük |
| **Ek token yükü (overhead)** | 0 | +4.5K (skill yükleme) | +1K (skill) | +5.5K |
| **Net kazanım (40K görevde)** | — | +10-14K net | +12-20K net | **+16-22K net** |

> **Not**: "Net kazanım" = Brüt tasarruf − Overhead. Overhead sabit, tasarruf görev büyüdükçe artar.

---

## Metodoloji ve Varsayımlar

Bu tablodaki değerler aşağıdaki varsayımlara dayanmaktadır:

1. **Token sayımı**: Standart GPT tokenizer oranları kullanılmıştır (~4 karakter = 1 token)
2. **Dosya boyutları**: Ortalama TypeScript/Java dosyası ~200 satır, büyük dosya 500+ satır olarak kabul edilmiştir
3. **grep tasarrufu**: Tam dosya okuma vs hedefli grep arasındaki fark, dosya boyutu × (1 - ilgili_satır_oranı) olarak hesaplanmıştır
4. **Output routing tasarrufu**: 200+ satır çıktı inline yerine dosyaya yazıldığında, inline kalan ~5 satır özetin token maliyeti baz alınmıştır
5. **Kaynak repo referansları**: context-mode %30-50 context azaltma iddia ediyor, graphify %40-60 exploration tasarrufu iddia ediyor — bu değerler muhafazakar olarak %20-40 bandına çekilmiştir

**Önemli**: Gerçek tasarruf oranları projenin boyutuna, dosya karmaşıklığına ve görev tipine göre değişir. Küçük projeler/görevler için tasarruf oranı düşer, büyük projeler/görevler için artar.
