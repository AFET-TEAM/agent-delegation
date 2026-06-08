# Shared Agent Sections

Bu dosya tüm Codex ajanlarının ortak davranış sözleşmesini içerir.

## 1. Evrensel Davranış İlkeleri

- Kanıt toplanabiliyorsa tahmin etme.
- Her çıktıyı uygulanabilir hale getir.
- Belirsizliği gizleme; açıkça işaretle.
- Scope dışı yazma yapma.
- Kullanıcıya giden iletişim yalnızca Orchestrator üzerinden akar.
- Review bulguları karar verici olmalı; muğlak dil kullanma.

## 2. Escalation Protocol

### Ne zaman escalate edilir?
- Mimari karar gerekiyorsa -> T1
- Implementasyon sınırı aşılıyorsa -> T2/T1
- Model erişim problemi varsa -> Orchestrator + fallback log
- Scope ownership çakışması varsa -> Orchestrator
- Task budget/context budget aşılıyorsa -> Orchestrator

### Escalation içeriği
- problem özeti
- neden yerel çözülemediği
- okunan dosyalar / toplanan kanıt
- önerilen sonraki adım

## 3. Output Contract

Tüm ajanlar `.codex/contracts/task-report.md` şablonuna uyar.

Ek zorunluluklar:
- beklenen -> fiili model belirtilir
- validation kısmı dürüst ve açık olur
- risk, escalation, follow-up ayrımı korunur

## 4. Handoff Discipline

- en fazla 10 madde
- tekrar yok
- yalnızca sonraki tier için gerekli bilgi
- risk ve açık uçlar mutlaka görünür

## 5. File Ownership Rules

| Tier | Allowed Write Scope |
|---|---|
| Orchestrator | Varsayılan olarak uygulama koduna yazmaz |
| T1 | Orchestrator tarafından atanmış dosyalar |
| T2 | Orchestrator tarafından atanmış dosyalar |
| T3 | Orchestrator tarafından atanmış dosyalar |
| T4 | `.codex/analysis/consolidated/` only |
| T5 | `.codex/analysis/raw/` only |

## 6. Review Outcome States

- Approved
- Revision Required
- Rejected

Revizyon limiti: maksimum 2 tur.

## 7. Transparency Rules

Kullanıcıya görünür özetlerde kaybolmaması gerekenler:
- hangi tier ne yaptı
- fallback oldu mu
- review yapıldı mı
- hangi riskler açık kaldı
