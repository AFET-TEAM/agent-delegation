# Kullanım Kılavuzu — Multi-Agent Delegation System v1.0.0

## 1. Hızlı Başlangıç — 5 Adımda Sistem Kullanımı

**Adım 1:** Bu repodan `.claude/` dizinini ve `CLAUDE.md` dosyasını projenize kopyalayın.

**Adım 2:** Claude Code'u projenizin kök dizininde açın. `settings.json` içindeki hook'lar otomatik devreye girer.

**Adım 3:** Görevinizi yazın. Basit bir araştırma veya tek dosya değişikliği için parametre eklemenize gerek yoktur; sistem tek-ajan modunda çalışır.

**Adım 4:** Birden fazla ajan gerekiyorsa mesajın sonuna `xN` parametresi ekleyin (x2–x10).

**Adım 5:** Oturum sonunda sistem otomatik olarak performans raporu üretir, learned-patterns günceller ve session dosyası yazar.

---

## 2. xN Parametresi — Hangi xN Ne Zaman?

`xN` parametresi mesajın sonuna eklenerek multi-agent modunu aktive eder. Aşağıdaki karar ağacını kullanarak doğru xN'i seçin:

```
Görev basit mi? (< 3 satır kod, tek dosya, iş mantığı yok)
  └─ Evet → xN ekleme; tek-ajan mod yeterli

Araştırma + mimari onay gerekiyor ama implementasyon yok?
  └─ Evet → x2 (T1 + T5)

Küçük feature, kıdemli review gerekiyor?
  └─ Evet → x3 (T1 + T2 + T5)

Tek modül, standart geliştirme?
  └─ Evet → x4 (T1 + T2 + T3 + T5)

Standart tam ekip, analiz + implementasyon + review?
  └─ Evet → x5 (T1 + T2 + T3 + T4 + T5) ← önerilen varsayılan

Paralel feature geliştirme, birden fazla modül?
  └─ Evet → x7 (T1 + 2×T2 + T3 + T4 + 2×T5)

Büyük sprint, çok modüllü, kritik sistem değişikliği?
  └─ Evet → x10 (2×T1 + 2×T2 + 2×T3 + 2×T4 + 2×T5)
```

### Tier Hızlı Referans

| Tier | Rol | Model |
|------|-----|-------|
| T1 Principal | Baş Yazılım Mimarı | opus |
| T2 Staff Engineer | Kıdemli Yazılım Mühendisi | sonnet |
| T3 MidCoder | Yazılım Geliştirici | sonnet |
| T4 Lead Analyst | Kıdemli Sistem Analisti | haiku |
| T5 Analyst | Sistem Analisti | haiku |

---

## 3. Review Zinciri

Multi-agent oturumlarında tüm kod çıktıları aşağıdaki sıralı review sürecinden geçer:

```
T5 Analyst üretir
  └─ T4 Lead Analyst inceler ve onaylar

T3 MidCoder uygular
  └─ T2 Staff Engineer review eder

T2 Staff Engineer uygular veya düzeltir
  └─ T1 Principal review eder

T1 Principal onaylar
  └─ Orchestrator konsolide eder ve kullanıcıya sunar
```

Her review üç sonuçtan biriyle biter:
- **Approved:** Bir üst tiere iletilir.
- **Revision Required:** Ajan aynı task ile yeniden spawn edilir. Maksimum 2 revizyon turu. İkinci turdan sonra hâlâ onaylanmazsa otomatik eskalasyon.
- **Rejected:** Üst tier görevi sıfırdan devralır; önceki çıktı ve tüm review bulguları seed prompt'a eklenir.

### xN'e Göre Azaltılmış Zincir

| xN | Review Zinciri |
|----|---------------|
| x2 | T1 Principal T5 çıktısını doğrudan inceler (T4 rolünü üstlenir) |
| x3 | T2 Staff Engineer → T5 review; T1 Principal → T2 review |
| x4 | T2 Staff Engineer → T5 + T3 review; T1 Principal → T2 review |
| x5+ | Tam standart zincir |

---

## 4. Maliyet Optimizasyonu

Sistem, görevi doğal maliyetiyle en düşük uygun tiere delege eder.

| Görev Türü | Atanan Tier | Model | Neden |
|------------|-------------|-------|-------|
| Codebase araştırma, dosya okuma | T5 | Haiku | Araştırma context-okuma işi; pahalı model gerekmez |
| Analiz sentezi, rapor üretimi | T4 | Haiku | Yapılandırılmış yazı; Haiku yeterli |
| Standart API, component, boilerplate | T3 | Sonnet | Yeterli kapasitede orta maliyet |
| Servis katmanı, karmaşık feature | T2 | Sonnet | Yüksek karmaşıklık; güçlü reasoning gerekir |
| Mimari karar, sistem tasarımı, final review | T1 | Opus | Kritik kararlar; en güçlü model |

### Tahmini Oturum Maliyetleri

| Mod | Tahmini Maliyet | Ne Zaman Kullan |
|-----|----------------|-----------------|
| Tek ajan | ~$0.5–1 | Basit görevler |
| x2 | ~$2–3 | Hızlı araştırma + onay |
| x5 | ~$4–6 | Standart feature geliştirme |
| x7 | ~$7–10 | Paralel modül geliştirme |
| x10 | ~$12–18 | Büyük sprint veya sistem yenileme |

Karşılaştırma: Aynı x5 görevi tümüyle Opus'ta çalışsaydı ~$20–25 olurdu. Sistem doğru delegasyon ile %70–75 tasarruf sağlar.

---

## 5. React 19 + AntD 6 Versiyon Tespiti

Ajanlar kodu yazmadan önce `package.json`'dan versiyon okuyarak uyumlu API kullanır. Örnek pattern:

```typescript
// package.json okuma
const packageJson = JSON.parse(fs.readFileSync('package.json', 'utf-8'));
const reactVersion = packageJson.dependencies['react'] ?? packageJson.devDependencies['react'];
const antdVersion = packageJson.dependencies['antd'] ?? packageJson.devDependencies['antd'];

// Versiyon bazlı dallanma
const isReact19 = parseInt(reactVersion) >= 19;
const isAntd6 = parseInt(antdVersion) >= 6;
```

Ajan promptlarında açık versiyon talimatı verilmezse bu bilgi task briefing'e eklenir. React 19'da `use` hook ve Server Components; AntD 6'da yeni `theme.useToken()` API ve component import yolları aktif olur. Hooks `figma-standards-guard.sh` ile `px` birim ve hardcoded hex kullanımını her iki versiyonda da engeller.

---

## 6. Sık Sorulan Sorular

**S: xN parametresiz de çalışabilir miyim?**
Evet. Parametre eklenmezse sistem tek-ajan modunda çalışır. Orkestratör görevi doğrudan karşılar veya en uygun tek ajana delege eder. Review zinciri bu modda aktif değildir.

**S: Hangi xN'i seçmeliyim emin değilsem?**
x5 iyi bir varsayılan. Tek modüllük çoğu geliştirme görevi için yeterli ekip büyüklüğü, makul maliyet ve tam review zinciri sağlar.

**S: Hook ihlali aldım, ne yapmalıyım?**
Hook'ları bypass etmeye çalışmayın. Hata mesajı hangi standardın ihlal edildiğini gösterir. Kodu standarda uygun hale getirip tekrar deneyin. Örneğin `console.log` yerine yapılandırılmış logger kullanın, hardcoded hex yerine design token kullanın.

**S: Review zincirini atlayabilir miyim?**
Hayır. Multi-agent modunda review zinciri zorunludur ve CLAUDE.md protokolünde tanımlıdır. x2 modunda bile T1 review adımı çalışır; yalnızca zincirin uzunluğu xN değerine göre kısalır.

**S: Aynı hatayı tekrar tekrar alıyorum, kalıcı kural yapılabilir mi?**
Evet. 3+ kez tetiklenen learned-pattern otomatik olarak kalıcı `.claude/rules/` kuralı adayı olarak işaretlenir. Orkestratör bu teklifi oturum raporunda bildirir. Onayladığınızda ilgili kural dosyasına eklenir.

**S: /architect komutu ne yapar?**
`/architect` komutu görevi doğrudan T1 Principal'e yönlendirir. xN parametresi gerekmez; mimari analiz ve sistem tasarımı görevleri için kullanılır. Sonuç Orchestrator üzerinden kullanıcıya iletilir.
