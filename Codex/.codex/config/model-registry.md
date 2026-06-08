# Model Registry

Kanonik tier eşlemesi `tier-definitions.md` dosyasındadır. Bu dosya kullanım bağlamını açıklar.

## Model Seçim İlkeleri

1. Principal ve Orchestrator için en güçlü model kullanılır: `gpt-5.4`.
2. Standart coding işleri için `gpt-5.3-codex` tercih edilir.
3. Daha basit, ucuz ve dar kapsamlı işler için `gpt-5.2` kullanılır.
4. Tüm önemli ajanlarda reasoning effort açıkça yüksek tutulur; basit bounded işler için orta effort yeterlidir.
5. Fallback yalnızca kayıt altına alınarak yapılır.

## Kullanım Rehberi

- `gpt-5.4`: Orchestrator ve Principal için birincil; kritik review ve mimari kararlar
- `gpt-5.3-codex`: T2 coding ve gerektiğinde güçlü coding fallback
- `gpt-5.2`: T3/T4/T5 ve basit/orta kapsamlı işler

## Fallback Kuralları

- Orchestrator/T1: `gpt-5.4 -> gpt-5.3-codex -> gpt-5.2`
- T2: `gpt-5.3-codex -> gpt-5.2 -> gpt-5.4`
- T3/T4/T5: `gpt-5.2 -> gpt-5.3-codex -> gpt-5.4`

## Reasoning Effort

- Orchestrator/T1/T2/T4/T5: high
- T3: medium by default, high if task risk is elevated
