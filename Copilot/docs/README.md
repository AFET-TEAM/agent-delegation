# Token Verimliliği Özellikleri — Genel Bakış

Bu klasör, multi-agent delegasyon sistemimizdeki token verimliliği özelliklerinin dokümantasyonunu içerir.

---

## Doküman Listesi

| Dosya | İçerik | Hedef Kitle |
|-------|--------|-------------|
| [context-efficiency.md](context-efficiency.md) | Bağlam verimliliği kuralları ve kullanım örnekleri | Tüm geliştiriciler |
| [knowledge-graph.md](knowledge-graph.md) | Bilgi grafiği tabanlı analiz metodolojisi | Analiz ajanları (T4/T5) + meraklılar |
| [caveman.md](caveman.md) | Caveman modu — kısa çıktı stili | Tüm geliştiriciler |
| [verimlilik-karsilastirma.md](verimlilik-karsilastirma.md) | Tüm modların karşılaştırma tabloları | Karar vericiler + meraklılar |

---

## Hızlı Başlangıç

### Hiçbir Şey Yapmanıza Gerek Yok

Temel verimlilik kuralları (**baseline**) her zaman aktiftir. Ajan'lar otomatik olarak:
- Büyük dosyaları grep ile tarar (Think-in-Code)
- Arama yapmadan dosya okumaz (Query-First)
- Büyük çıktıları dosyaya yönlendirir (Output Routing)

### İsteğe Bağlı Modlar

| Komut | Ne Yapar | Ne Zaman Kullan |
|-------|----------|----------------|
| `/context-mode` | Yoğunlaştırılmış bağlam verimliliği | Büyük analiz/görevlerde |
| `/caveman` | Kısa çıktı stili | Hızlı iterasyon istediğinde |
| `/context-mode` + `/caveman` | Maksimum verimlilik | Token bütçesi kritik olduğunda |

### Deaktivasyonlar

```
/context-mode off    → Baseline'a dön
/caveman off         → Normal çıktı stiline dön
```

---

## Mimari Diyagram

```
┌────────────────────────────────────────────────────────────┐
│                    AGENT RESPONSE                           │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  Katman 3 (en dış): /caveman                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ Çıktı stilini sıkıştırır                            │  │
│  │ "Dosya düzenlendi. Test pass." (kısa, öz)           │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                            │
│  Katman 2 (orta): /context-mode                           │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ Bağlam tüketimini yoğun optimize eder              │  │
│  │ Sıkı bütçeler, agresif batching, progressive disc.  │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                            │
│  Katman 1 (temel): Baseline — HER ZAMAN AKTİF            │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ Think-in-Code | Query-First | Output Routing         │  │
│  │ Confidence Tagging | Budget Awareness                │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

## Sık Sorulan Sorular

**S: Baseline kuralları performansı yavaşlatır mı?**
H: Hayır. Baseline kuralları zaten iyi mühendislik pratiğidir (önce ara, sonra oku). Token maliyeti ~500 token sabit overhead — ilk görevde kendini amorti eder.

**S: /context-mode ve /caveman çakışır mı?**
H: Hayır. Farklı katmanlara etki eder. Biri input'u, diğeri output'u optimize eder. Birlikte kullanılabilir.

**S: Kod kalitesi düşer mi?**
H: Hayır. Tüm modlar **teknik doğruluğu korur**. Sadece gereksiz bilgi/kelime/okuma azaltılır.

**S: Normal moduma geri dönebilir miyim?**
H: `/context-mode off` ve `/caveman off` ile anında deaktive edebilirsin. Baseline her zaman aktif kalır (ama zaten zararsız).
