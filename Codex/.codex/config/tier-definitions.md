# Tier Definitions — Single Source of Truth

## Tier Model Mapping

> Model names must match the real models available in the target OpenAI environment. This package standardizes on a high-capability principal/orchestrator tier and cheaper coding/analysis tiers.

| Tier | Rol | Primary Model | Fallback 1 | Fallback 2 | Reasoning Effort |
|---|---|---|---|---|---|
| Orchestrator | Teknik Koordinatör | gpt-5.4 | gpt-5.3-codex | gpt-5.2 | high |
| T1 Principal | Baş Yazılım Mimarı | gpt-5.4 | gpt-5.3-codex | gpt-5.2 | high |
| T2 Staff Engineer | Kıdemli Yazılım Mühendisi | gpt-5.3-codex | gpt-5.2 | gpt-5.4 | high |
| T3 Mid Coder | Yazılım Geliştirici | gpt-5.2 | gpt-5.3-codex | gpt-5.4 | medium |
| T4 Lead Analyst | Kıdemli Sistem Analisti | gpt-5.2 | gpt-5.3-codex | gpt-5.4 | high |
| T5 Analyst | Sistem Analisti | gpt-5.2 | gpt-5.3-codex | gpt-5.4 | high |

## Tier Token Budget

| Tier | Max Active Rules | Max Context Files | PCD Files | PCD Tokens | Edit Permission |
|---|---:|---:|---:|---:|---|
| T1 | 5 | 10 | 5 | 8000 | Full |
| T2 | 5 | 8 | 4 | 6000 | Full |
| T3 | 4 | 6 | 3 | 4000 | Full |
| T4 | 3 | 5 | 5 | 5000 | Scoped consolidated |
| T5 | 3 | 6 | 3 | 3000 | Scoped raw only |
