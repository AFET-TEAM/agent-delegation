# Context Efficiency (Bağlam Verimliliği)

> Kaynak ilham: [mksglu/context-mode](https://github.com/mksglu/context-mode)

## Ne İşe Yarar?

Context Efficiency, AI ajanlarının **bağlam penceresini** (context window) verimli kullanmasını sağlayan bir kurallar setidir. Ajanlar gereksiz yere büyük dosyalar okumak, uzun çıktılar üretmek veya aynı bilgiyi tekrar etmek yerine hedefli ve ekonomik davranır.

---

## Temel Kurallar

### 1. Think-in-Code (Kodla Düşün)

**Kural**: 500+ satırlık bir dosyayı analiz etmen gerekiyorsa, dosyayı baştan sona okuma — bunun yerine script/komut kullanarak sadece ihtiyacın olan bilgiyi çıkar.

#### Örnek: Bir serviste kaç metot var?

❌ **Verimsiz** (Normal Mod — baseline olmadan):
```
# Ajanın düşünce süreci:
# "user-service.ts dosyasını okuyayım"
→ view user-service.ts  (850 satır okundu = ~4000 token harcandı)
→ "Bu dosyada 12 metot var"
```

✅ **Verimli** (Context Efficiency aktif):
```
# Ajanın düşünce süreci:
# "Metot sayısını grep ile bulabilirim"
→ grep "^\s*(async\s+)?\w+\(" user-service.ts --count
→ "12 metot bulundu"  (~50 token harcandı)
```

**Tasarruf**: ~3950 token (dosya başına)

---

### 2. Output Routing (Çıktı Yönlendirme)

**Kural**: Büyük çıktıları kullanıcıya inline gösterme — dosyaya yaz, sadece özetini göster.

| Çıktı Boyutu | Ne Yapılır |
|---------------|-----------|
| < 50 satır | Inline göster |
| 50-200 satır | Dosyaya yaz + 3-satır özet ver |
| 200+ satır | Dosyaya yaz + 5-satır özet ver |

#### Örnek: Dependency audit sonucu

❌ **Verimsiz**:
```markdown
## Bağımlılık Raporu

1. react@18.2.0 → react@18.3.1 (minor, güvenli)
2. typescript@5.3.2 → typescript@5.5.4 (minor, güvenli)
3. eslint@8.56.0 → eslint@9.5.0 (major, breaking changes var)
... (200 satır daha inline)
```

✅ **Verimli**:
```markdown
## Bağımlılık Raporu

📄 Tam rapor: `.github/analysis/raw/analyst-alpha-dependency-audit.md`

**Özet**: 47 bağımlılık incelendi. 3 major güncelleme (breaking), 12 minor, 32 patch.
Kritik: eslint 8→9 (config formatı değişti), webpack 5.88→5.92 (loader API değişti)
```

**Tasarruf**: ~1500 token (rapor başına)

---

### 3. Blocked Patterns (Yasaklı Kalıplar)

Aşağıdaki davranışlar **her zaman yasaktır**:

| Yasaklı Kalıp | Neden Yasak | Ne Yapılmalı |
|----------------|-------------|-------------|
| 500+ satır dosyayı komple okuma | Bağlam israfı | grep/awk ile hedefli okuma |
| Raw JSON/XML çıktıyı inline koyma | Okunaksız + büyük | Dosyaya yaz, özet göster |
| Önceki yanıtı tekrar etme | Gereksiz tekrar | Referans ver: "Yukarıda belirtildiği gibi..." |
| Aynı dosyayı birden fazla okuma | Duplikasyon | İlk okumada gerekli tüm bilgiyi çıkar |
| Kullanılmayan import/bilgiyi dahil etme | Gürültü | Sadece kullanılanı ekle |

---

### 4. Context Budget (Bağlam Bütçesi)

Her yanıt tipinin tahmini bir token bütçesi vardır:

| Yanıt Tipi | Maksimum Token | Örnek |
|-------------|---------------|-------|
| Durum bildirimi | ≤ 500 | "3 dosya değiştirildi, test geçiyor" |
| Görev raporu | ≤ 2000 | Standart ajan task report |
| Analiz raporu | ≤ 3000 | T5 Analyst bulgular |
| Kod üretimi | Sınırsız* | Üretilen kod ne kadarsa o kadar |

*Kod sıkıştırılamaz — doğruluğu önceliktir.

---

## Aktivasyon

### Her Zaman Aktif (Baseline)

Temel kurallar (Think-in-Code, Output Routing, Query-First, Blocked Patterns) **her zaman aktiftir**. Özel bir tetikleyici gerektirmez. `shared-base.instructions.md` dosyasında gömülüdür.

### Yoğunlaştırılmış Mod

Daha sıkı bütçeler ve agresif optimizasyon için:

```
/context-mode          → Yoğunlaştırılmış modu aktifle
/context-mode off      → Baseline'a dön
```

Veya prompt'ta `context-mode` kelimesini kullan.

---

## Kullanım Senaryoları

### Senaryo 1: Büyük Proje Analizi

**Görev**: "Projedeki tüm servis dosyalarını analiz et, bağımlılıkları çıkar"

**Baseline davranışı** (her zaman aktif):
```
1. glob "src/**/*-service.ts" → 23 dosya bulundu
2. Her dosya için grep ile import satırlarını çek (dosyayı komple okumadan)
3. Bağımlılık matrisini oluştur
4. Sonucu .github/analysis/raw/ altına yaz
5. Kullanıcıya 5-satır özet göster
```

**Yoğunlaştırılmış mod** (/context-mode aktif):
```
1-5 aynı + ek olarak:
6. Sıkı bütçe: rapor maksimum 1000 token
7. Progressive disclosure: önce sadece god node'ları göster
8. Batch: tüm grep çağrıları tek turda paralel
```

### Senaryo 2: Bug Fix

**Görev**: "UserService'deki login hatası düzelt"

**Baseline davranışı**:
```
1. grep "login" src/services/user-service.ts → ilgili satırları bul
2. Sadece login metodu etrafındaki 20 satırı oku (view_range)
3. Hatayı tespit et, düzelt
4. Özet: "user-service.ts:45 — null check eklendi"
```

### Senaryo 3: Multi-Agent x10 Görevi

**Görev**: "Auth modülünü yeniden tasarla" (x10 delegation)

**Baseline etkisi** (otomatik):
- T5 Analyst'ler dosya okumak yerine grep ile analiz → %40 input tasarrufu
- T3 MidCoder'lar büyük scaffold çıktısını dosyaya yazar → output routing aktif
- T2 Staff Engineer sadece atanan dosyaları okur → gereksiz okuma yok
- Toplam bağlam tasarrufu: ~%30-35

---

## Caveman ile Birlikte Kullanım

| Mod | Ne Optimize Eder | Örnek Etki |
|-----|-----------------|-----------|
| Sadece Baseline | Input okuma davranışı | grep > view |
| + `/context-mode` | Input + output bütçeleri | Sıkı limitler, aggressive batching |
| + `/caveman` | Output yazım stili | "3 dosya değişti. Test geçiyor." |
| + `/context-mode` + `/caveman` | Her şey | Minimum okuma + minimum yazma |

---

## Teknik Detaylar

### Skill Dosyası

Tam kurallar: `.github/skills/context-efficiency/SKILL.md`

### İlgili Konfigürasyon Dosyaları

- `.github/instructions/shared-base.instructions.md` — Baseline kurallar
- `.github/instructions/reference/context-loading.instructions.md` — Yükleme kuralları
- `.github/instructions/reference/slash-commands.instructions.md` — `/context-mode` komutu
