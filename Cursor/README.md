# Cursor Multi-Agent Mühendislik Boilerplate

> v1.1.0 — Doğal dil + xN ile çok-ajan işletim (terminal komutu gerekmez)

## Kurulum (bir kez)

```bash
Cursor/.cursor/scripts/setup.sh /path/to/projeniz
```

Kurulum sonrası Cursor IDE’de sohbet yeterli.

## Nasıl kullanılır?

Görevi normal cümle olarak yazın. **Slash (`/pcd`) veya `bin/` yok.**

### Çok-ajan delegasyon (otomatik)

Prompt içine **x2 … x10** yazın — sistem otomatik manifest üretir ve Orchestrator Task subagent’lara böler.

```
auth modülü ekle x5
x10 migration analizi
pcd yeni microservice x3
```

### Mod anahtar kelimeleri

| Kelime | Ne yapar |
|--------|----------|
| `pcd` | Önce README / docs keşfi |
| `caveman` | Kısa yanıt |
| `graphify` | Topoloji ile daraltma |
| `context-mode` veya `ctx` | Context disiplini |
| `review` | Review öncelikli |
| `architect` | Mimari (T1) |

Örnekler:

```
pcd repo analizi
graphify bağımlılık haritası
caveman özet ver
pcd graphify payment modülü x7
```

### Varsayılan

`caveman`, `context-mode`, `graphify` varsayılan açık değildir. Bu modları etkinleştirmek için prompt içinde ilgili anahtar kelimeyi açıkça belirtin (`caveman`, `context-mode` / `ctx`, `graphify`).

## Cross-Platform Parity Notes

- **Default-on token-efficiency modes (v7.4.3+)**: This is a Copilot-only feature. In Cursor, `caveman`, `context-mode`, and `graphify` remain opt-in (explicit keyword or slash-style mode trigger required). For the default-on parity design pattern, see `Copilot/.github/config/mode-overrides.md`.

## Configuration

- Yerel [`.cursor/config/mode-overrides.md`](.cursor/config/mode-overrides.md) dosyası şu anda referans tasarım / gelecekteki wrapper entegrasyonu içindir; v7.4.3 default-on davranışı sağlamaz.

## Geliştiriciler için (opsiyonel)

```bash
Cursor/bin/verify          # kurulum kontrolü
Cursor/.cursor/scripts/setup.sh
```

`bin/team` legacy; günlük kullanımda gerekmez.

## Dokümantasyon

- [AGENTS.md](AGENTS.md) — Orchestrator sözleşmesi
- [.cursor/docs/GETTING_STARTED.md](.cursor/docs/GETTING_STARTED.md)
- [.cursor/docs/tier-bridge-global.md](.cursor/docs/tier-bridge-global.md)

> **Versioning**: see [docs/VERSION_STRATEGY.md](../docs/VERSION_STRATEGY.md) for cross-platform parity policy.
