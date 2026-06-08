# Caveman Modu

> Kaynak ilham: [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman)

## Ne İşe Yarar?

Caveman modu, AI ajanlarının **metin çıktılarını** (açıklamalar, raporlar, yanıtlar) drastik şekilde kısaltır. Teknik doğruluğu koruyarak tüm dolgu kelimeleri, nezaket ifadelerini ve gereksiz geçişleri kaldırır.

**Bir cümleyle**: Beyin aynı kalır, ağız küçülür.

---

## Seviyeleri

| Seviye | Tetikleyici | Açıklama | Örnek |
|--------|------------|----------|-------|
| **lite** | `/caveman lite` | Profesyonel ama sıkı — dolgu kelimeler kalkar | "Dosya oluşturuldu. 3 test geçiyor." |
| **full** | `/caveman` veya `/caveman full` | Klasik caveman — kırık cümleler, artikelsiz | "Dosya oluşturuldu. 3 test geçiyor. Hata yok." |
| **ultra** | `/caveman ultra` | Telgraf tarzı — kısaltmalar, ok işaretleri | "✅ dosya → 3 test pass → 0 err" |

---

## Aktivasyon

| Tetikleyici | Etki |
|-------------|------|
| `/caveman` | full seviye aktif |
| `/caveman lite` | lite seviye aktif |
| `/caveman full` | full seviye aktif |
| `/caveman ultra` | ultra seviye aktif |
| `/caveman off` | Deaktive et |
| Prompt'ta `caveman` kelimesi | full seviye aktif |

---

## Örnek: Aynı Yanıtın 4 Hali

**Görev**: "Bu dosyadaki hatayı düzelt"

### Normal Mod:
```
Dosyayı inceledim ve sorunu tespit ettim. `user-service.ts` dosyasının 45. satırında bir null 
reference hatası bulunmaktadır. Bu hata, `getUser` metodunun undefined döndürebilmesi durumunda 
oluşmaktadır. Sorunu çözmek için bir null check ekledim. Değişiklik sonrasında mevcut testler 
başarıyla geçmektedir.
```
*(62 token)*

### Caveman Lite:
```
`user-service.ts:45` — null reference hatası. `getUser` undefined dönebiliyor. 
Null check eklendi. Testler geçiyor.
```
*(28 token)*

### Caveman Full:
```
user-service.ts:45 null ref. getUser undefined dönüyor. Null check eklendi. Test pass.
```
*(18 token)*

### Caveman Ultra:
```
user-service.ts:45 → null ref → +null check → ✅ tests
```
*(12 token)*

---

## Ne ETKİLENMEZ

Caveman modu aşağıdakileri **asla** değiştirmez:

| Korunan Alan | Neden |
|-------------|-------|
| Kod blokları | Teknik doğruluk — sıkıştırılamaz |
| Komut satırı çıktıları | Doğruluk gerekli |
| Hata mesajları | Tam olarak korunmalı |
| Commit mesajları | Conventional Commits formatına uymalı |
| Dosya yolları | Kesin olmalı |
| Tip tanımları | Doğruluk gerekli |
| Test isimleri | Kesin olmalı |

---

## Context Efficiency ile Farkı

| | Caveman | Context Efficiency |
|---|---------|-------------------|
| **Ne optimize eder** | Çıktı yazım stili | Bağlam tüketimi (input) |
| **Nasıl çalışır** | Kısa cümleler, dolgu yok | Akıllı arama, output routing |
| **Kodu etkiler mi** | ❌ Hayır | ❌ Hayır |
| **Birlikte kullanılabilir** | ✅ Evet | ✅ Evet |
| **Varsayılan davranış** | Tamamen opsiyonel | Baseline her zaman aktif |

---

## Teknik Detaylar

### Skill Dosyası

Tam kurallar: `.github/skills/caveman/SKILL.md`

### İlgili Konfigürasyon Dosyaları

- `.github/instructions/shared-base.instructions.md` — Aktivasyon tespit kuralları
- `.github/instructions/reference/context-loading.instructions.md` — Cross-cutting modifier statüsü
- `.github/instructions/reference/slash-commands.instructions.md` — `/caveman` komutu
