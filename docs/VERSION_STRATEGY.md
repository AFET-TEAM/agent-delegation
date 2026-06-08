# Version Strategy / Sürüm Stratejisi

Bu belge, platformlar arası sürümleme politikasını tanımlar. `docs/index.html` içindeki birleşik changelog tek bir yayın akışı gibi görünse de pratikte **çoğunlukla Copilot-led** ilerler; Claude, Codex ve Cursor ise kendi teslim ritimlerine göre bağımsız sürümlenir.

---

## Versioning Policy / Sürüm Politikası

- Her platform **bağımsız versiyonlanır**.
- **Lock-step release yoktur**; tüm platformların aynı sürüm numarasına gelmesi gerekmez.
- Sürüm numarası, o platformun kendi kullanıcıya görünen davranışını ve kendi artifact set'ini temsil eder.
- Root `docs/index.html`, birleşik hikâyeyi ve ana changelog'u tutar; bu akış bugün için ağırlıklı olarak **Copilot** üzerinden şekillenir.

### Reference Feature Set

| Platform | Current Version | Reference Feature Set |
|----------|----------------|-----------------------|
| Copilot  | v7.4.3         | Default-on modes + script-based hooks |
| Claude   | v1.0.0         | Skills + hooks + graphify rules |
| Codex    | v4.3.0         | Wrappers + runtime + delegation engine |
| Cursor   | v1.1.0         | bin/ wrapper scripts (ctx/team/verify) |

---

## Feature Parity Matrix / Özellik Parite Matrisi

> Not: Bu matris, **current policy snapshot** ile bu PR serisinde hedeflenen parite yönünü birlikte özetler. `✓` = mevcut/hedeflenen parity kapsamında var, `—` = platformun odak alanında değil.

| Feature | Copilot | Claude | Codex | Cursor | Notes |
|---------|---------|--------|-------|--------|-------|
| Independent versioning | ✓ | ✓ | ✓ | ✓ | Tüm platformlar kendi cadence'i ile ilerler. |
| Default-on modes (`caveman` + `context-mode` + `graphify`) | ✓ | — | ✓ | ✓ | Copilot release messaging bunu ana akım davranış olarak taşır; Claude tarafında daha çok opt-in/skill odaklıdır. |
| Hooks | ✓ | ✓ | ✓ | ✓ | Hook katmanı her platformda korunur. |
| Graphify rules / graph-aware workflow | ✓ | ✓ | ✓ | ✓ | Graphify tüm platformlarda desteklenen ortak capability'dir. |
| Skills | ✓ | ✓ | ✓ | ✓ | Yoğunluk ve kapsam platforma göre değişebilir. |
| Dedicated wrappers / entry scripts | — | — | ✓ | ✓ | Codex runtime wrapper ağına, Cursor ise `bin/` akışına odaklanır. |
| Delegation engine / local runtime | — | — | ✓ | — | Bugün en belirgin runtime/delegation ownership Codex tarafındadır. |
| `mode-overrides.md` | ✓ | — | ✓ | ✓ | Bu PR hedef snapshot'ında Copilot + Codex + Cursor paritesi olarak takip edilir. |
| `selftest` harness | ✓ | ✓ | ✓ | ✓ | Bu PR hedef snapshot'ında tüm platformlar için parity hedefidir. |
| Unified changelog ownership | ✓ | — | — | — | Root `docs/index.html` çoğunlukla Copilot-led değişim akışını toplar. |

---

## Release Cadence / Yayın Ritmi

- Yayınlar **ad-hoc** yapılır; takvimden çok doğrulanmış özellik seti belirleyicidir.
- Birincil yön verici platform şu anda **Copilot**'tur.
- Diğer platformlar, özellikler sahada doğrulanıp stabil hale geldikçe yetişir ve kendi sürümlerini bağımsız artırır.
- Bu nedenle parity, aynı sürüm numarasından çok **eşdeğer kullanıcı değeri** üzerinden değerlendirilmelidir.

---

## Migration Notes / Geçiş Notları

Platform sürümü artırılırken temel kural:

- **Yeni özellik** eklendiyse → **minor bump**
- **Kullanıcıya görünen davranış değiştiyse** → **minor bump**
- **Security fix / güvenlik düzeltmesi** geldiyse → **patch bump**
- **Kırıcı davranış / contract change** varsa → **major bump**

Ek olarak:

- Sadece iç refactor yapıldı ve kullanıcı davranışı değişmediyse sürüm artışı zorunlu değildir.
- Bir parity özelliği başka platforma taşındığında, yalnızca etkilenen platformun sürümü artırılır.
- Root changelog güncellense bile tüm platformların aynı anda bump alması gerekmez.

---

## Future Plans / Gelecek Planları

- `v8.0+` sonrasında **unified semver** yaklaşımı yeniden değerlendirilebilir.
- Bu konu şu anda **TBD** durumundadır.
- Kısa vadede tercih edilen model: bağımsız sürümleme + parity takibi + Copilot-led changelog anlatısı.
