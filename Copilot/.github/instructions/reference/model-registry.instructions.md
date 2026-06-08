# Model Registry & Alias Resolution

Canonical model name registry and alias resolution protocol. When an agent encounters a model name that does not exactly match the canonical table, this registry provides the resolution mechanism.

## Canonical Model Table

> **Single Source of Truth**: This table defines the official model names used across the system. All other references (YAML frontmatter, documentation, validation rules) must resolve to these canonical names.

| Canonical Name               | YAML Format (with suffix)                  | Provider | Tier Assignment                |
| ---------------------------- | ------------------------------------------ | -------- | ------------------------------ |
| Claude Opus 4.6              | Claude Opus 4.6 (copilot)                  | Anthropic | Orchestrator, T1 Principal    |
| Claude Opus 4.5              | Claude Opus 4.5 (copilot)                  | Anthropic | Orchestrator (fb), T1 (fb)    |
| Claude Sonnet 4.6            | Claude Sonnet 4.6 (copilot)                | Anthropic | T2 Staff Engineer           |
| Claude Sonnet 4.5            | Claude Sonnet 4.5 (copilot)                | Anthropic | T2 (fallback)               |
| GPT-5.3-Codex                | GPT-5.3-Codex (copilot)                    | OpenAI   | T3 MidCoder                   |
| GPT-5.2-Codex                | GPT-5.2-Codex (copilot)                    | OpenAI   | T3 (fallback)                 |
| Gemini 3.1 Pro (Preview)     | Gemini 3.1 Pro (Preview) (copilot)         | Google   | T4 Lead Analyst             |
| Gemini 3.0 Pro (Preview)     | Gemini 3.0 Pro (Preview) (copilot)         | Google   | T4 (fallback)               |
| Gemini 3 Flash               | Gemini 3 Flash (copilot)                   | Google   | T5 Analyst                    |
| Claude Haiku 4.5             | Claude Haiku 4.5 (copilot)                 | Anthropic | T5 (fallback)                 |

## Alias Resolution Table

When a model name does not match the canonical table exactly, resolve it using the alias table below. Aliases are grouped by resolution type.

### Short Name Aliases

| Alias                    | Resolves To                  |
| ------------------------ | ---------------------------- |
| Opus                     | Claude Opus 4.6              |
| Opus 4.6                 | Claude Opus 4.6              |
| Opus 4.5                 | Claude Opus 4.5              |
| Sonnet                   | Claude Sonnet 4.6            |
| Sonnet 4.6               | Claude Sonnet 4.6            |
| Sonnet 4.5               | Claude Sonnet 4.5            |
| Haiku                    | Claude Haiku 4.5             |
| Haiku 4.5                | Claude Haiku 4.5             |
| Codex                    | GPT-5.3-Codex                |
| GPT Codex                | GPT-5.3-Codex                |
| Flash                    | Gemini 3 Flash               |
| Gemini Flash             | Gemini 3 Flash               |
| Gemini Pro               | Gemini 3.1 Pro (Preview)     |

### Suffix Variation Aliases

| Alias                                  | Resolves To                  |
| -------------------------------------- | ---------------------------- |
| Claude Opus 4.6 (copilot)             | Claude Opus 4.6              |
| Claude Opus 4.5 (copilot)             | Claude Opus 4.5              |
| Claude Sonnet 4.6 (copilot)           | Claude Sonnet 4.6            |
| Claude Sonnet 4.5 (copilot)           | Claude Sonnet 4.5            |
| GPT-5.3-Codex (copilot)               | GPT-5.3-Codex                |
| GPT-5.2-Codex (copilot)               | GPT-5.2-Codex                |
| Gemini 3.1 Pro (Preview) (copilot)    | Gemini 3.1 Pro (Preview)     |
| Gemini 3.0 Pro (Preview) (copilot)    | Gemini 3.0 Pro (Preview)     |
| Gemini 3 Flash (copilot)              | Gemini 3 Flash               |
| Claude Haiku 4.5 (copilot)            | Claude Haiku 4.5             |

### Formatting Variation Aliases

| Alias                    | Resolves To                  | Variation Type        |
| ------------------------ | ---------------------------- | --------------------- |
| GPT-5.3 Codex            | GPT-5.3-Codex                | Space instead of hyphen |
| GPT-5.2 Codex            | GPT-5.2-Codex                | Space instead of hyphen |
| GPT 5.3-Codex            | GPT-5.3-Codex                | Space instead of hyphen |
| GPT 5.2-Codex            | GPT-5.2-Codex                | Space instead of hyphen |
| GPT5.3-Codex             | GPT-5.3-Codex                | Missing hyphen        |
| GPT5.2-Codex             | GPT-5.2-Codex                | Missing hyphen        |
| Gemini 3.1 Pro Preview   | Gemini 3.1 Pro (Preview)     | Missing parentheses   |
| Gemini 3.0 Pro Preview   | Gemini 3.0 Pro (Preview)     | Missing parentheses   |
| Gemini 3.1 Pro           | Gemini 3.1 Pro (Preview)     | Missing Preview suffix |
| Gemini 3.0 Pro           | Gemini 3.0 Pro (Preview)     | Missing Preview suffix |

### Version Shorthand Aliases

| Alias                    | Resolves To                  |
| ------------------------ | ---------------------------- |
| Claude Opus              | Claude Opus 4.6              |
| Claude Sonnet            | Claude Sonnet 4.6            |
| Claude Haiku             | Claude Haiku 4.5             |
| GPT Codex 5.3            | GPT-5.3-Codex                |
| GPT Codex 5.2            | GPT-5.2-Codex                |
| Gemini Flash 3            | Gemini 3 Flash               |

## Resolution Protocol

When an agent or the Orchestrator encounters a model name, follow this resolution chain:

### Step 1 — Exact Match

Compare the input against the **Canonical Name** column in the Canonical Model Table. If an exact match is found, use it.

### Step 2 — Suffix Strip

If no exact match, strip the ` (copilot)` suffix and compare again against the Canonical Name column.

### Step 3 — Alias Lookup

If still no match, search the Alias Resolution Table (all sections). If found, resolve to the canonical name.

### Step 4 — Case-Insensitive Match

If still no match, perform a case-insensitive comparison against both the Canonical Model Table and the Alias Resolution Table.

### Step 5 — Fuzzy Match Report

If all steps fail, the agent must:

1. Report the unresolved model name in its task output.
2. List the top 3 closest canonical names (by string similarity).
3. Use the tier's default primary model as a temporary resolution.
4. Flag the mismatch for Orchestrator attention.

```markdown
### Model Resolution Warning

**Input**: {unresolved model name}
**Resolution**: FAILED — using tier default ({default model name})
**Closest matches**: {candidate 1}, {candidate 2}, {candidate 3}
**Action required**: Orchestrator must verify and correct the model reference.
```

## YAML ↔ Canonical Conversion

### To YAML Format

Append ` (copilot)` to the canonical name:
`Claude Opus 4.6` → `Claude Opus 4.6 (copilot)`

### From YAML Format

Strip ` (copilot)` suffix:
`Claude Opus 4.6 (copilot)` → `Claude Opus 4.6`

## Integration Points

- **system-validation.instructions.md** Rule 7: Uses this registry for model consistency checks.
- **model-fallback.instructions.md**: References this registry for canonical model names.
- **agent-scaffolding.instructions.md** Section 2: Uses this registry when assigning models to new agents.
- **slash-commands.instructions.md** `/create-agent`: Uses this registry for tier defaults.

## Maintenance

When adding a new model to the system:

1. Add the canonical entry to the Canonical Model Table.
2. Add common aliases to the Alias Resolution Table.
3. Update the YAML Format column with the `(copilot)` suffixed version.
4. Update `model-fallback.instructions.md` if the model participates in a fallback chain.
5. Run system validation Rule 7 to confirm consistency.
