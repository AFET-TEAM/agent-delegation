# Model Fallback

## İlkeler

- Önce Codex ailesi kullanılır
- Codex erişilemiyorsa GPT fallback kullanılır
- Fallback sessiz yapılmaz; raporlanır
- Fallback kalite ve maliyet etkisi session sonunda özetlenir

## Ne zaman fallback olur?

- model erişim hatası
- kapasite/erişilebilirlik sorunu
- görev tipi için beklenen model kullanılamıyorsa

## Beklenen davranış

1. Orchestrator fallback zincirini uygular
2. Olay loglanır
3. Handoff ve final özette belirtilir
4. Gerekirse kullanıcıya kalite/maliyet etkisi açıklanır
