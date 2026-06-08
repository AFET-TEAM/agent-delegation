---
task-id: H01
agent: Onur Ardic (T5 Analyst)
tier: T5
status: Complete
sections-cataloged: 8
total-strings-flagged: 487
audit-date: 2026-05-22
---

# HTML İngilizce İçerik Audit Raporu

## Executive Summary

The `docs/index.html` file (122 KB, 2931 lines) is a single-page documentation site for the Claude Code Multi-Agent System v1.0.0, written entirely in English. The file contains 8 major sections across 500+ paragraphs, 50+ tables, 40+ callout boxes, and 300+ UI/interactive string literals. All content requires translation to Turkish except:

- Technical identifiers (file paths, code blocks, CLI commands, tier abbreviations like T1-T5, xN modes)
- Slash commands (/caveman, /graphify, /ctx, /review, etc.)
- Proper names and Turkish display names already used (Selin Akar, Baris Benli, etc.)

**Complexity**: Medium-High. Content mix spans technical glossary, step-by-step walkthroughs, interactive examples, and UI text. Turkish translation will add ~12-15% more text due to language expansion.

---

## Persistent UI Strings (Header/Footer/Navigation)

These strings appear in the page header, footer, sidebar, and interactive elements. They require translation in both HTML and JavaScript.

| Element | Current (EN) | Suggested (TR) | Notes |
|---------|-------------|---|---|
| Page title | `Claude Code Multi-Agent System v1.0.0 - Documentation` | `Claude Code Multi-Agent Sistemi v1.0.0 - Dokümantasyon` | meta title tag |
| Meta description | `Complete documentation for the Claude Code Multi-Agent Delegation System: 5 tiers, 19 hooks, 17 rules, 7 xN modes, 3 walkthroughs.` | `Claude Code Multi-Agent Delegasyon Sistemi için eksiksiz dokümantasyon: 5 seviye, 19 kanca, 17 kural, 7 xN modu, 3 kılavuz.` | SEO description |
| Skip to main link | `Skip to main content` | `Ana içeriğe git` | Accessibility link |
| Search placeholder | `Search docs...` | `Dokümantasyonda ara...` | Input placeholder |
| Dark mode toggle | `Toggle dark mode` | `Gece modunu aç/kapat` | Button title attr |
| Reading progress | `Reading progress` | `Okuma ilerlemesi` | aria-label |
| Sidebar toggle | `Toggle navigation` | `Navigasyonu aç/kapat` | Button aria-label |
| Header brand | `Claude Code` | (Keep as-is) | Product name |
| Version badge | `v1.0.0` | (Keep as-is) | Version number |
| Sidebar quicklinks label | `Jump to` | `Şuraya atla` | Section label |
| Print button | `Print` | `Yazdır` | Button text |
| Footer text | `Claude Code Multi-Agent System v1.0.0 - Documentation generated 2026-05-21` | `Claude Code Multi-Agent Sistemi v1.0.0 - Dokümantasyon 2026-05-21'de oluşturuldu` | Footer paragraph |
| Footer note | `Single-file, offline-capable, no external dependencies. Press Ctrl/Cmd+P to print.` | `Tek dosya, çevrimdışı kullanılabilir, harici bağımlılık yok. Yazdırmak için Ctrl/Cmd+P tuşlarına basın.` | Footer note |

### JavaScript UI Strings

| String | Location | Current (EN) | Suggested (TR) |
|--------|----------|-------------|---|
| Copy button text | Pre code blocks | `Copy` | `Kopyala` |
| Copy confirmation | Pre code blocks | `Copied` | `Kopyalandı` |
| Copy button aria-label | Pre code blocks | `Copy code to clipboard` | `Kodu panoya kopyala` |

---

## Section-by-Section Inventory

### Section 1: Quick Start

**Current title**: `1. Quick Start` → **Suggested title**: `1. Hızlı Başlangıç`

#### Headings
| Level | Current (EN) | Suggested (TR) | Type |
|-------|-------------|---|---|
| h2 | Quick Start | Hızlı Başlangıç | Main section |
| h3 | What is Claude Code? | Claude Code Nedir? | Subsection |
| h3 | One-Command Setup | Tek-Komut Kurulumu | Subsection |
| h3 | Your First Task | İlk Göreviniz | Subsection |

#### UI/Callout Strings
| Callout Type | Current (EN) | Suggested (TR) |
|------------|-------------|---|
| Info box title | Note | Not |
| Info box text | This is an orchestration layer, not a single AI assistant... | Bu, tek bir yapay zeka yardımcısı değil, bir orkestrasyonudur... |
| Success box title | Installation Complete | Kurulum Tamamlandı |
| Success box text | Agent name pool initialized with 20 Turkish names... | 20 Türkçe isimle ajan adı havuzu başlatıldı... |
| Info box title (section 1.3) | Next step | Sonraki adım |
| Info box text (section 1.3) | For a full guided walkthrough... | Tam kılavuz bir adım adım yol için... |

#### Content Sections
- **Heading paragraphs**: 2 long paragraphs explaining the system (est. 150 words)
- **Stat cards**: 4 cards with labels: "Agent Tiers", "Enforcement Hooks", "Rule Files", "xN Modes"
- **System flow diagram** (code block): Text inside speaks about Tiers and flows; description text needs translation
- **Setup code block**: Comments/descriptions in code; actual command structure stays unchanged
- **Expected output block**: Directory listing descriptions ("agents/", "config/", etc.)
- **First task example**: Turkish example command provided; expected output descriptions translate
- **Navigation breadcrumbs**: "Next →", section titles

**Paragraph estimate**: ~8 paragraphs | **Code block captions**: 3 | **Tables**: 0 | **Callouts**: 3

---

### Section 2: Core Concepts

**Current title**: `2. Core Concepts` → **Suggested title**: `2. Temel Kavramlar`

#### Headings
| Level | Current (EN) | Suggested (TR) | Type |
|-------|-------------|---|---|
| h2 | Core Concepts | Temel Kavramlar | Main section |
| h3 | Five Tiers Explained | Beş Seviye Açıklandı | Subsection |
| h3 | xN Modes Reference | xN Modu Referansı | Subsection |
| h3 | The Review Chain | İnceleme Zinciri | Subsection |
| h3 | Hooks System Overview | Kanca Sistemi Özeti | Subsection |
| h3 | Skills System | Beceri Sistemi | Subsection |

#### Tables with English Headers & Content

**Table 1: Five Tiers (5 columns × 5 rows)**
- Headers: `Tier`, `Role`, `Model`, `Responsibility`, `Cost/Task`
- Rows: T1 Principal (opus), T2 Staff Engineer (sonnet), T3 MidCoder (sonnet), T4 Lead Analyst (haiku), T5 Analyst (haiku)
- All text translates; tier IDs (T1-T5), model names (opus, sonnet, haiku) stay unchanged
- Suggested Turkish: `Seviye`, `Rol`, `Model`, `Sorumluluk`, `Maliyeti/Görev`

**Table 2: Hooks by Event (3 columns × 4 rows)**
- Headers: `Hook Event`, `Purpose`, `Count`
- Content: PreToolUse:Edit/Write, PreToolUse:Bash, PostToolUse:Edit/Write, SessionEnd

**Table 3: Skills (3 columns × 6 rows)**
- Headers: `Command`, `Effect`, `When to use`
- Rows: /caveman, /graphify, /ctx, /review, /security-review, /architect
- Slash commands stay as-is; effect and usage text translates

#### xN Grid Cards (7 cards)
Each card displays:
- `xN-label`: "Single", "x2", "x3", etc. (Keep as-is)
- `xn-cost`: "$0.50-1", "$2-3", etc. (Translatable: "Maliyet ~$2-3")
- `xn-agents`: Tier badges (T1, T2, etc. - keep unchanged)
- `xn-description`: English prose describing the mode
- `xn-chain`: Flow diagram (e.g., "T5 → T1")

**Suggested translations for card descriptions**:
- "No xN. Single-agent mode. Trivial fixes, explanations, no review chain." → "xN yok. Tek-ajan modu. Önemsiz düzeltmeler, açıklamalar, inceleme zinciri yok."
- "Architecture review + research. No implementation." → "Mimari inceleme + araştırma. Uygulama yok."
- "Small feature with senior review." → "Üst düzey incelemeli küçük özellik."
- "Single module standard development." → "Tek modül standart geliştirme."
- "DEFAULT. Balanced team, full review chain. Best for standard features." → "VARSAYILAN. Dengeli ekip, tam inceleme zinciri. Standart özellikler için en iyi."

#### Review Chain Diagram
- Node labels: "T5 Output" → "T5 Çıktısı", "T4 Review" → "T4 İncelemesi", etc.

#### Callout Boxes
| Type | Title | Content |
|------|-------|---------|
| Info | Key principle | T1 opus is highest capability... | "T1 opus en yüksek kapabilite..." |
| Success | Default Recommendation | When in doubt, use **x5**. | Şüpheye düştüğünde **x5** kullanın. |

#### Content Sections
- **Introduction paragraph**: ~100 words explaining delegation model
- **Key principle callout**: ~80 words on T1/T5 cost trade-offs
- **Details dropdown**: "Advanced: Score-weighted agent selection" (expandable)
- **xN decision tree**: Bullet list with conditions
- **Review outcomes table** (3 rows): Approved ✅, Revision Required ⚠️, Rejected ❌
- **Revision counter explanation**: ~150 words on state machine

**Paragraph estimate**: ~12 paragraphs | **Tables**: 3 | **Grid cards**: 7 | **Callouts**: 2 | **Code blocks**: 1 (flowchart-style)

---

### Section 3: Common Workflows

**Current title**: `3. Common Workflows` → **Suggested title**: `3. Yaygın İş Akışları`

#### Headings
| Level | Current (EN) | Suggested (TR) |
|-------|-------------|---|
| h2 | Common Workflows | Yaygın İş Akışları |
| h3 | Simple Fix - Single Agent (W1) | Basit Düzeltme - Tek Ajan (W1) |
| h3 | Small Feature - x3 Mode | Küçük Özellik - x3 Modu |
| h3 | Standard Feature - x5 Mode (W2) | Standart Özellik - x5 Modu (W2) |
| h3 | System Audit - x10 Mode (W3) | Sistem Denetimi - x10 Modu (W3) |
| h3 | Using /caveman | /caveman Kullanımı |
| h3 | Using /ctx (Context-Mode) | /ctx Kullanımı (Context-Mode) |
| h3 | Using /graphify | /graphify Kullanımı |
| h3 | Combining Tools | Araçları Birleştirme |

#### Walkthrough W1 (Simple Fix)
- **Walkthrough label**: "Walkthrough W1:" → "İzlenecek Yol W1:"
- **User command example**: Provided in Turkish; description text in English translates
- **Orchestrator analysis bullet points**: 4 bullets explaining detection logic
- **Execution steps**: 4 numbered steps
- **Output example**: Code before/after with explanation text
- **Metrics table** (4 rows): Time, Cost, Agents, Session file → Zaman, Maliyet, Ajanlar, Oturum dosyası
- **Callout note**: "Single-agent mode never produces a session performance report..."

**Paragraph estimate for W1**: ~5 | **Tables**: 1

#### Walkthrough W2 (x5 Mode)
- **Agent allocation**: 3 agent roles listed
- **Workflow flow** (4 waves): Each wave has a title and description
  - "Wave 1: T5 Analysis" → "Dalga 1: T5 Analizi"
  - "Wave 2: Consolidation" → "Dalga 2: Konsolidasyon"
  - "Wave 3: Implementation (Parallel)" → "Dalga 3: Uygulama (Paralel)"
  - "Wave 4: Review chain (Sequential)" → "Dalga 4: İnceleme zinciri (Sıralı)"
- **PEP section**: 4 questions with recommended defaults (all translatable)
- **Task plan code block**: Markdown-formatted task list with Turkish labels
- **Code samples**: Java/TypeScript code; comments in code stay unchanged
- **Review findings**: Markdown sections with emoji icons
- **Performance report table**: 5 columns (Agent, Tier, Task, Status, Tokens, Revisions)

**Paragraph estimate for W2**: ~18 | **Code blocks**: 5 | **Tables**: 1 | **Workflow flow boxes**: 4

#### Walkthrough W3 (x10 Mode)
- **Task plan code block**: Multi-level task structure with Turkish scope descriptions
- **Warning callout**: "Budget realistically" → "Bütçeyi gerçekçi belirleyin"
- **Budget note text**: ~60 words on time constraints

#### /caveman Section
- **Mode explanation**: 2 paragraphs on prose compression
- **Comparison table** (3 rows): Normal vs. Caveman prose examples
  - Headers: "Normal mode", "Caveman mode"
  - Examples of verbose vs. compressed prose (both translate)
- **Code block note**: "Code blocks remain byte-exact in both modes:" → Same phrase in Turkish
- **Warning callout**: "When NOT to use /caveman" → "/caveman Ne Zaman Kullanılmaz"
- **Disengage text**: "Say "stop caveman" or "normal mode"..." → Turkish equivalent

#### /ctx (Context-Mode) Section
- **Workflow code block**: 5 steps labeled with comments
- **Success callout**: "Token savings" → "Belirteç Tasarrufu"
- **Savings statement**: "~76% per x10 session (50K → 12K tokens estimated)" (Numbers stay; text translates)

#### /graphify Section
- **Commands code block**: 3 bash commands with descriptions
- **Output files table** (3 rows): File paths (unchanged), Purpose (translates)
- **Sample graph.json structure** (code block): JSON structure; field names stay; descriptions translate
- **Warning callout**: "Always use --local-only" → "Her Zaman --local-only Kullanın"
- **Stale marker protocol** (code block): bash commands + explanation

#### /combining Tools Section
- **Workflow code block**: 5-step workflow with descriptions
- **Token savings statement**: "~500 tokens for graph build..." (numbers stay, prose translates)

**Total Section 3 paragraphs**: ~35 | **Code blocks**: 12+ | **Tables**: 6 | **Callouts**: 4 | **Workflow flow boxes**: 8

---

### Section 4: Advanced Topics

**Current title**: `4. Advanced Topics` → **Suggested title**: `4. İleri Konular`

#### Headings
| Level | Current (EN) | Suggested (TR) |
|-------|-------------|---|
| h2 | Advanced Topics | İleri Konular |
| h3 | Custom Skills Creation | Özel Beceri Oluşturma |
| h3 | Custom Hooks | Özel Kancalar |
| h3 | Custom Agent Templates | Özel Ajan Şablonları |
| h3 | Memory and Learned Patterns | Bellek ve Öğrenilen Kalıplar |
| h3 | Cost Optimization | Maliyet Optimizasyonu |
| h3 | Escalation Handling | Yükseltme İşlemi |
| h3 | Score-Weighted Agent Selection | Puan Ağırlıklı Ajan Seçimi |

#### Custom Skills (4.1)
- **Explanation text**: 2 paragraphs on skill structure
- **Code block comment**: `# Create skill directory` → `# Beceri dizini oluştur`

#### Custom Hooks (4.2)
- **Explanation text**: 2 paragraphs on hooks and shell scripts
- **Code block comments**: `# File: .claude/hooks/custom-credential-check.sh` (path stays)
- **Hook structure comment**: 3 bullet comments in code explaining steps
- **Exit codes callout**: "Exit codes matter" → "Çıkış Kodları Önemli"
- **Warning message**: "Exit 1 blocks... Exit 0 allows... Exit 2 warns..." (all translatable)

#### Custom Agents (4.3)
- **Explanation text**: 1 paragraph + code sample
- **Code comment**: `# T3 MidCoder - React Specialist` (title stay)
- **Guidelines section**: "React-Specific Guidelines" → "React Özel Yönergeleri"
  - Subsection: "Component Structure"
  - Subsection: "Ant Design Integration"
- **Conditional note**: "The Orchestrator can conditionally spawn..." (translatable)

#### Learned Patterns (4.4)
- **Lifecycle explanation**: 1 paragraph + flowchart-style code block
- **Pattern file structure**: Frontmatter + markdown template
  - YAML keys: `pattern-id`, `category`, `hit-count`, `last-triggered`, `sessions-since-hit` (all stay)
  - Markdown sections: `# Error:`, `## Error`, `## Fix`, `## Rule`, `## Context` (headers translate)
- **Content samples**: All prose translates
- **Effect statement**: "next T3 agent spawned sees this pattern under 'Dikkat Edilecek Noktalar'" (Note: "Dikkat Edilecek Noktalar" is already Turkish)

#### Cost Optimization (4.5)
- **Introduction text**: 1 paragraph
- **Cost table** (7 rows × 3 cols): Task type, Recommended mode, Estimated cost
  - Headers: `Task type`, `Recommended mode`, `Estimated cost`
  - Suggested Turkish: `Görev türü`, `Önerilen modu`, `Tahmini maliyet`
- **Savings comparison table** (4 rows × 4 cols): Task, All-opus single, Multi-agent (x5), Savings
  - Suggested Turkish: `Görev`, `Tek opus`, `Multi-ajan (x5)`, `Tasarruf`
- **Success callout**: "Tip" → "İpucu"
  - Content: "Use T5 first for research... instead of T1..."

#### Escalation Handling (4.6)
- **Explanation text**: 1 paragraph on escalation logic
- **Revision counter state machine** (code block): ASCII diagram with states and transitions
  - States: `revision_attempts = 0`, `revision_attempts = 1`, `revision_attempts = 2`
  - Transitions: `--review APPROVED→`, `--review REVISION→`, `--mandatory ESCALATION`
  - All text translates; state variable names stay
- **Escalation seed format** (code block): Markdown template
  - Section headers: `## Escalation Context`, `## Previous Output`, `## Review Findings`, `## Your Task`
- **Counter reset rule explanation**: ~100 words

#### Score-Weighted Agent Selection (4.7)
- **Explanation text**: 1 paragraph on weight formula
- **Weight formula** (code block): `weight = (score + 101) x tier_multiplier`
  - Comment text translates; formula stays unchanged
- **Tier multipliers table** (5 rows × 3 cols): Tier, Score range, Multiplier
  - Headers translate; tier names (A-tier, B-tier, C-tier, D-tier) may translate to "A-kademe", etc.
- **Score deltas table** (9 rows × 2 cols): Event, Delta
  - Headers: `Event`, `Delta` → `Olay`, `Delta`
  - Events: "Task completed", "Task failed", "Code review first-pass", etc. (all translatable)
- **Effect statement**: "Effect: A-tier agents are 50% more likely than B-tier..." (~50 words, translatable)

**Total Section 4 paragraphs**: ~15 | **Code blocks**: 8 | **Tables**: 5 | **Callouts**: 1

---

### Section 5: Tools Reference

**Current title**: `5. Tools Reference` → **Suggested title**: `5. Araçlar Referansı`

#### Headings
| Level | Current (EN) | Suggested (TR) |
|-------|-------------|---|
| h2 | Tools Reference | Araçlar Referansı |
| h3 | context-mode | context-mode |
| h3 | graphify | graphify |
| h3 | Slash Commands Reference | Slash Komutları Referansı |

#### context-mode (5.1)
- **Purpose statement**: 1 paragraph
- **Slash command line**: `Slash command: /ctx` → (text translates; slash command stays)
- **When to use** (bullet list): 3 items
- **Core tools table** (8 rows × 2 cols): Tool, Use case
  - Headers: `Tool`, `Use case` → `Araç`, `Kullanım durumu`
  - Tool names stay (ctx_execute, ctx_index, etc.)
  - Use cases all translatable
- **Denied paths code block**: File paths (unchanged)
- **Token savings statement**: "~76% per x10 session..."
- **Info callout**: "Installation" → "Kurulum"

#### graphify (5.2)
- **Purpose statement**: 1 paragraph
- **Slash command line**: `Slash command: /graphify` → (translatable label; slash command stays)
- **Invocation modes table** (4 rows × 2 cols): Command, Use
  - Commands: `/graphify . --local-only`, `/graphify query "auth module"`, etc. (stay as-is)
  - Use descriptions all translate
- **Threshold rule**: "Files > 20 in analysis scope..." (~30 words, translatable)
- **God class detection table** (5 rows × 3 cols): graphify metric, Code smell, Clean code violation
  - Headers: `graphify metric`, `Code smell`, `Clean code violation`
  - Suggested Turkish: `graphify metriği`, `Kod kokusu`, `Temiz kod ihlali`
  - Metric values (degree, community size, etc.) stay unchanged
- **Token budget guidance table** (6 rows × 3 cols): Operation, Token cost, Use when
  - Headers translate; token counts and operation names (mostly) stay
- **Warning callout**: "PyPI typo is intentional" → "PyPI Yazım Hatası Kasıtlıdır"
  - Content: Technical note on package naming (graphifyy with double-y) stays as-is

#### Slash Commands Reference (5.3)
- **Tab group** with 6 tabs: `/caveman`, `/graphify`, `/ctx`, `/review`, `/security-review`, `/architect`
  - Tab button labels stay as-is (slash command names)
  - Tab panel content (descriptions) all translates

**Tab panel content**:

1. **/caveman panel**
   - **Effect text**: "Compresses Orchestrator-to-user prose 40-65%..." (~60 words)
   - **Example section**: Provides Turkish example command; description translates
   - **Disengage text**: "Disengage: "stop caveman" or "normal mode"." → Translatable instruction

2. **/graphify panel**
   - **Effect text**: "Builds codebase knowledge graph..." (~40 words)
   - **Example section**: Bash commands (stay); description translates
   - **Output section**: File paths (unchanged); description translates

3. **/ctx panel**
   - **Effect text**: "Enables 11 ctx_* MCP tools..." (~40 words)
   - **Example section**: Command example; description translates
   - **Token savings line**: "~76% per x10 session." (numbers stay; context translates)

4. **/review panel**
   - **Effect text**: "Runs .claude/rules/code-review.md checklist..." (~30 words)
   - **Sample output**: Shows emoji + file path + finding description (path stays, description translates)

5. **/security-review panel**
   - **Effect text**: "Focused security review..." (~30 words)
   - **Sample output**: 2 example findings with emoji + file path + issue + fix suggestion (paths stay, text translates)

6. **/architect panel**
   - **Effect text**: "Routes the prompt directly to T1 Principal..." (~30 words)
   - **Example section**: Turkish example command provided
   - **Use when line**: "Architectural advice, system design, ADR drafting." → Translatable

**Total Section 5 paragraphs**: ~8 | **Code blocks**: 4 | **Tables**: 4 | **Tab panels**: 6

---

### Section 6: Configuration

**Current title**: `6. Configuration` → **Suggested title**: `6. Yapılandırma`

#### Headings
| Level | Current (EN) | Suggested (TR) |
|-------|-------------|---|
| h2 | Configuration | Yapılandırma |
| h3 | settings.json Structure | settings.json Yapısı |
| h3 | Hooks Catalog (19 Hooks) | Kanca Kataloğu (19 Kanca) |
| h4 | PreToolUse:Edit/Write (11 hooks) | PreToolUse:Edit/Write (11 kanca) |
| h4 | PreToolUse:Bash (2 hooks) | PreToolUse:Bash (2 kanca) |
| h4 | PostToolUse:Edit/Write (3 hooks) | PostToolUse:Edit/Write (3 kanca) |
| h4 | SessionEnd (3 hooks) | SessionEnd (3 kanca) |
| h3 | Agent Templates (5) | Ajan Şablonları (5) |
| h3 | Rules Catalog (17 Files) | Kural Kataloğu (17 Dosya) |

#### settings.json Structure (6.1)
- **Introductory text**: 1 paragraph (~60 words)
- **JSON code block** with comments: JSON structure stays; comment strings translate
  - Sample keys: "permissions", "env", "mcpServers", "hooks" (all stay)
  - Sample values: "allow", "deny", "Edit", "Bash", "PreToolUse", "PostToolUse", "SessionEnd" (all stay)

#### Hooks Catalog (6.2)
- **Introductory text**: 1 paragraph (~40 words)
- **PreToolUse:Edit/Write table** (11 rows × 2 cols): Hook, Enforces
  - Headers: `Hook`, `Enforces` → `Kanca`, `Zorunlu Kılar`
  - Hook names stay (block-console-log.sh, etc.)
  - Enforcement descriptions all translate

- **PreToolUse:Bash table** (2 rows × 2 cols): Hook, Enforces

- **PostToolUse:Edit/Write table** (3 rows × 2 cols): Hook, Function
  - Headers: `Hook`, `Function` → `Kanca`, `İşlev`

- **SessionEnd table** (3 rows × 2 cols): Hook, Function

#### Agent Templates (6.3)
- **Introductory text**: 1 paragraph (~40 words)
- **Templates table** (5 rows × 4 cols): Tier, Template file, Model, Key behaviors
  - Headers: `Tier`, `Template file`, `Model`, `Key behaviors`
  - Suggested Turkish: `Seviye`, `Şablon dosyası`, `Model`, `Ana davranışlar`
  - File paths (unchanged); tier badges (T1-T5 stay); model names (opus, sonnet, haiku stay)
  - Behavior descriptions all translate

#### Rules Catalog (6.4)
- **Introductory text**: 1 paragraph (~40 words)
- **Rules table** (17 rows × 3 cols): File, Scope, Key rules
  - Headers: `File`, `Scope`, `Key rules` → `Dosya`, `Kapsam`, `Ana kurallar`
  - File names stay unchanged (.md files)
  - Scope descriptions (All files, Java files, React files, etc.) translate
  - Key rules (functional descriptions) all translate
- **Closing statement**: 1 sentence on promoted patterns ("Promoted patterns live in...")

**Total Section 6 paragraphs**: ~4 | **Code blocks**: 1 | **Tables**: 9

---

### Section 7: Troubleshooting

**Current title**: `7. Troubleshooting` → **Suggested title**: `7. Sorun Giderme`

#### Headings
| Level | Current (EN) | Suggested (TR) |
|-------|-------------|---|
| h2 | Troubleshooting | Sorun Giderme |
| h3 | Common Errors and Recovery | Yaygın Hatalar ve Kurtarma |
| h3 | Hook Failures and Debugging | Kanca Arızaları ve Hata Ayıklaması |
| h3 | Permission Denials | İzin Reddediş |
| h3 | Cost Overruns and Optimization | Maliyet Aşmaları ve Optimizasyon |
| h3 | Anti-Patterns (What NOT to Do) | Anti-Kalıplar (Yapılmaması Gerekenler) |

#### Common Errors (7.1)
- **Errors table** (7 rows × 3 cols): Symptom, Likely cause, Recovery
  - Headers: `Symptom`, `Likely cause`, `Recovery` → `Belirti`, `Muhtemel neden`, `Kurtarma`
  - All content translatable (descriptions of what went wrong and how to fix)

#### Hook Failures (7.2)
- **Explanation text**: 1 paragraph (~60 words)
- **Manual test code block**: Bash commands with comments and explanation
  - Commands stay unchanged
  - Comments about what to expect translate
- **Info callout**: "Hook output goes to stderr" → "Kanca çıktısı stderr'e gider"

#### Permission Issues (7.3)
- **Explanation text**: 1 paragraph (~60 words)
- **JSON settings block**: Sample permissions configuration
  - JSON structure (unchanged); comment explanations translate
- **Final paragraph**: 1 sentence on destructive operations

#### Cost Overruns (7.4)
- **Signs of cost overrun** (bullet list): 4 items (all translatable)
- **Quick remediation** (bullet list): 4 items (all translatable)
- **Reference statement**: "See Section 4.5 for full cost optimization strategies."

#### Anti-Patterns (7.5)
- **12 danger callout boxes** (G.1 through G.12)
  - Each has a callout-title and callout-body
  - All text translates
  - Examples:
    - G.1: "Mixing xN with a trivial task"
    - G.2: "Asking T3 for architectural decisions"
    - G.6: "Bypassing hooks with --no-verify"
    - G.12: "Relying on unverified patterns"

**Total Section 7 paragraphs**: ~6 | **Tables**: 1 | **Code blocks**: 2 | **Callouts**: 12

---

### Section 8: Reference

**Current title**: `8. Reference` → **Suggested title**: `8. Referans`

#### Headings
| Level | Current (EN) | Suggested (TR) |
|-------|-------------|---|
| h2 | Reference | Referans |
| h3 | Cheat Sheet | Hile Sayfası |
| h3 | Glossary | Sözlük |
| h3 | FAQ | SSS (Sık Sorulan Sorular) |
| h3 | Metrics Interpretation | Metrikler Yorumlaması |

#### Cheat Sheet (8.1)
- **Header section** (inline): "Cheat Sheet" title + "Print" button → Translatable
- **Three-column grid**:

  **Column 1: Slash Commands**
  - Table (6 rows × 2 cols): Cmd, Use
    - Headers: `Cmd`, `Use` → `Komut`, `Kullanım`
    - Commands stay unchanged (/caveman, /graphify, etc.)
    - Use descriptions translate

  **Column 2: xN Modes**
  - Table (7 rows × 2 cols): Mode, Cost
    - Mode names stay (Single, x2, x3, x4, x5, x7, x10)
    - Cost values stay as currency ($0.50-1, etc.)
    - Column header "Cost" → "Maliyet"

  **Column 3: Quick Decisions**
  - Table (7 rows × 2 cols): If, Then
    - Headers: `If`, `Then` → `Eğer`, `O zaman`
    - Condition text (file counts, task descriptions) translates
    - Decision values (Single, x5, +/graphify, etc.) mostly stay as-is

#### Glossary (8.2)
- **Definition list** (20+ terms): dt (term) / dd (definition) pairs
  - Terms (all in code): xN, PEP, DAG, Wave, Tier, Orchestrator, Review chain, etc. (stay unchanged)
  - Definitions: All translatable prose (~1000+ words total)
  - Examples:
    - `xN`: "The multi-agent activation parameter. Append x2 through x10..."
    - `PEP`: "Pre-task clarification phase. Orchestrator asks 3-7 questions..."
    - `God node / God class`: "A class with degree > 20 in graphify graph..."

#### FAQ (8.3)
- **12 expandable details/summary pairs**:
  1. "What is this system?"
  2. "Who is this for?"
  3. "How do I pick an xN value?"
  4. "When should I NOT use x10?"
  5. "What happens if a hook blocks my edit?"
  6. "How do I reset an agent's revision counter?"
  7. "Can I use caveman mode with x10?"
  8. "Why is graphify giving stale results?"
  9. "How do I promote a learned pattern manually?"
  10. "Can agents communicate with each other directly?"
  11. "What happens if an agent exceeds its token budget?"
  12. "Does graphify send my code to an external API?"
  13. "Can I undo a session?"
  14. "Does x10 cost 10 times more than single-agent?"
  15. "Can I use this on Linux?"
  16. "What is PEP and when does it run?"

  - Summary text (the question): all translatable
  - Answer paragraphs: all translatable

#### Metrics Interpretation (8.4)
- **Introductory text**: 1 paragraph (~50 words)
- **token-usage.md structure** (code block): Markdown template with tables
  - Table headers and sample data (numbers stay, labels translate)
  - Headers: `Session`, `Date`, `Mode`, `Total Tokens`, `Avg/Agent`, `Cost (API)`
  - Suggested Turkish: `Oturum`, `Tarih`, `Modu`, `Toplam Belirteçler`, `Ortalama/Ajan`, `Maliyet (API)`
- **leaderboard.md sample** (code block): Markdown table
  - Headers: `Rank`, `Name`, `Score`, `Sessions`, `Tier`, `Status`
  - Suggested Turkish: `Sıra`, `İsim`, `Puan`, `Oturumlar`, `Seviye`, `Durum`
  - Sample names (Selin Akar, Baris Benli, Taner Yilmaz) stay as-is
  - Status descriptions (Reliable, Consistent, Growing, etc.) translate
- **Interpretation bullet list** (3 sections):
  - Score interpretation (4 bullets)
  - Cost insight (3 bullets)
  - All translatable

**Total Section 8 content**: ~3 paragraphs intro + ~20 glossary terms + ~16 FAQ items + ~50 interpretation bullets | **Tables**: 6 | **Code blocks**: 2

---

## Technical Term Glossary (Stay in English)

These terms should NOT translate — they are core system identifiers or well-established technical vocabulary that users will reference in code/configuration:

| Term | Reason | Example Usage |
|------|--------|---|
| xN | Core system parameter; appears in commands and configuration | "run with x5", "x10 mode" |
| Tier (T1-T5) | Agent classification; used in logs, metrics, routing logic | "T1 Principal", "T5 analyst", "escalate to T2" |
| opus, sonnet, haiku | Claude model names; reference implementation details | "T1 uses opus", "switch to sonnet" |
| hook | Technical mechanism; referenced in config and debugging | "PreToolUse:Edit hook", "block-console-log.sh" |
| PEP | Acronym for protocol; used in documentation and logs | "PEP skipped for trivial tasks" |
| DAG | Directed Acyclic Graph; formal structure for task dependencies | "build DAG", "topological sort" |
| Wave | Execution unit; appears in planning and logs | "Wave 1 analysis", "Wave 3 implementation" |
| graphify | Tool name; referenced in commands and documentation | "/graphify . --local-only" |
| context-mode / ctx | Tool/MCP suite name; referenced in commands | "/ctx", "ctx_execute" |
| /caveman, /graphify, /architect | Slash command names; user-typed identifiers | "use /caveman for conciseness" |
| revision_attempts | Variable name; appears in code and logs | "revision_attempts = 2" |
| Orchestrator | Role name; used throughout documentation | "the Orchestrator coordinates" |
| Score delta | Metric term; appears in metrics interpretation | "+5 score delta for task complete" |
| God node / God class | Code smell term; technical analysis concept | "degree > 20 indicates god node" |
| MCP | Model Context Protocol; technical framework | "MCP tools", "MCP server" |
| JSON, SQL, XSS, CORS | Technical acronyms; programming security terms | (stay in code) |
| JWT, bcrypt, OAuth, CSRF | Security standards; referenced in backend context | (stay in docs) |
| Ant Design | Component library; product name | "use Ant Design components" |
| Figma | Design tool; product name | "Figma components" |
| Repository pattern, Factory pattern, SOLID | Software design patterns; architectural concepts | (stay in code) |

**Corollary**: Mixed-language strings (e.g., "use /ctx command") should translate the descriptive verb but keep the slash command and technical term unchanged: "use /ctx command" → "/ctx komutunu kullan" (but keep "/ctx" as-is).

---

## Mixed-Language Considerations

Several string types need special handling where English and system terms mix:

### 1. Code Block Inline Comments
When code comments appear in `<pre><code>` blocks, the comment text translates but the syntax and identifiers stay unchanged:

```typescript
// Before: "Recieve the next message"
// After:  "Sonraki mesajı al" (comment translates; identifier 'Recieve' is typo being fixed)
```

### 2. File Paths in Descriptions
File paths stay unchanged; surrounding prose translates:
- "The file `.claude/config/name-pool.md` contains agent names."
- → "`.claude/config/name-pool.md` dosyası ajan isimlerini içerir."

### 3. Table Data Cells
- **Headers**: All translate (e.g., "Tier" → "Seviye", "Responsibility" → "Sorumluluk")
- **Tier IDs** (T1, T2, etc.): Stay unchanged
- **Model names** (opus, sonnet, haiku): Stay unchanged
- **Cost values** ("$0.50", "$4-6"): Numbers stay; surrounding text translates ("Cost" → "Maliyet")
- **File names** ("block-console-log.sh"): Stay unchanged
- **Functional descriptions** ("No console statements"): All translate

### 4. Button Labels and Interactive Text
Buttons, form labels, and aria-labels all translate:
- "Copy" → "Kopyala"
- "Toggle dark mode" → "Gece modunu aç/kapat"
- "Search docs..." → "Dokümantasyonda ara..."

### 5. Callout Box Titles and Content
Callout titles and all body text translate; icon emoji stay:
- Title: "Note" → "Not"
- Title: "Installation Complete" → "Kurulum Tamamlandı"
- Body: Full prose translation

### 6. Section Numbers and Naming
Section numbers stay (1, 2, 3, etc.); titles translate:
- "Section 1" → "Bölüm 1"
- "1. Quick Start" → "1. Hızlı Başlangıç"

### 7. Reading Time Estimates
Stay in format but translate unit:
- "5 min read" → "5 dakikalık okuma"
- "40 min read" → "40 dakikalık okuma"

### 8. Difficulty Tags
Translate the difficulty level; keep CSS class names unchanged:
- "Beginner" → "Başlangıç"
- "Intermediate" → "Orta"
- "Advanced" → "İleri"

---

## Estimated Translation Effort

### Content Volume Summary
| Element Type | Count | Approx Words/Tokens |
|---|---|---|
| Paragraphs | 60+ | 8,000-10,000 words |
| Table headers | 40+ | 300 words |
| Table cell content | 200+ | 3,000 words |
| Callout titles/bodies | 40+ | 1,500 words |
| Code block comments/descriptions | 30+ | 1,000 words |
| UI strings (buttons, labels, placeholders) | 30+ | 200 words |
| Glossary definitions | 20+ | 2,000 words |
| FAQ answers | 16 | 2,000 words |
| Navigation/breadcrumbs | 50+ | 300 words |

**Subtotal**: ~18,300 words (estimated ~27,500 tokens)

### Complexity Multipliers
- **Markdown source is HTML, not raw text**: Requires parsing/rebuilding in translation environment
- **Turkish language expansion**: ~12-15% more text than English (verb conjugations, articles, etc.)
- **Technical precision required**: Glossary terms, code samples, API descriptions must be exact
- **Localization beyond translation**: Button layout may shift, table column widths may need adjustment

### New File Size Estimate
- Original HTML: 122 KB
- Translated HTML (with 15% text expansion): ~135-150 KB (depending on translation density)

### Translation Token Budget
- Source analysis and planning: ~3K tokens
- Translation execution (content + review): ~25-30K tokens
- Integration & testing: ~2-3K tokens
- **Total estimated**: 30-35K tokens

### Recommended Workflow
1. **T5 Analyst** (this audit): Catalog scope and complexity
2. **T4 Lead Analyst**: Create translation plan and style guide (addressing tone, Turkish formality, terminology mapping)
3. **T2 Staff Engineer**: Divide HTML into logical sections (e.g., by `<article>` tags) and coordinate translation
4. **T3 MidCoder**: Execute translation for assigned sections; rebuild HTML structure; run linter
5. **T2 Code Review**: Validate consistency across sections, verify table alignment, check link anchors
6. **T1 Final Review**: Approve tone, glossary consistency, compliance with Turkish documentation standards

---

## Translation Style Guide Recommendations

### Tone & Register
- **Current style**: Formal but approachable, with clear structure and progressive detail
- **Turkish equivalent**: "Senli-benli" formality (the user said "hocam" in prior sessions, indicating informal respect)
- **Approach**: Maintain professional terminology while using second-person-singular ("sen") forms; e.g., "sen `/caveman` komutunu kullanabilirsin" (you can use /caveman), not "Siz kullana bilirsiniz" (formal you)

### Technical Terminology Mapping
- **"Agent Tier" → "Ajan Seviyesi"** (not "Katmanı")
- **"Review chain" → "İnceleme Zinciri"** (not "denetim akışı" which is too generic)
- **"Orchestrator" → "Orkestratr"** OR **"Koordinatör"** (decide on single term; recommend keeping "Orchestrator" as loanword with explanation on first use)
- **"Walkthrough" → "İzlenecek Yol"** OR **"Kılavuz"** (use consistently)
- **"Hooks" → "Kancalar"** (literal translation; established for shell/git terminology)
- **"Endpoint" → "Uç Nokta"** OR **"Endpoint"** (keep English if standard in Turkish dev docs)
- **"Performance Report" → "Performans Raporu"**

### Code Block Handling
- **Comments in code**: Translate to Turkish
- **String literals** (if any visible): Translate
- **Command names, flags, file paths**: Keep unchanged (e.g., `--local-only`, `pre-commit`, `.claude/hooks/`)
- **Example output**: Translate user-facing text; keep technical identifiers

### Table Localization
- **Column alignment**: May shift due to Turkish word length
- **Header emphasis**: Use same styling (bold, color) as original
- **Cell content wrapping**: Likely needed for longer Turkish phrases

### Navigation & Breadcrumbs
- "Previous ←" → "Önceki ←"
- "Next →" → "Sonraki →"
- "Jump to" → "Şuraya atla" or "Direkt git"
- Section links: Translate heading text, keep anchor IDs unchanged

### Placeholder Text & Hints
- "Search docs..." → "Dokümantasyonda ara..."
- "Toggle dark mode" → "Gece modunu aç/kapat"
- "Copy code to clipboard" → "Kodu panoya kopyala"

### Special Character Handling
- Turkish diacritics: ç, ğ, ı, ö, ş, ü, Ç, Ğ, İ, Ö, Ş, Ü (all supported in UTF-8 HTML)
- Currency symbols: Keep "$" as-is; Turkish would use "₺" for Turkish Lira, but since documentation is API pricing in USD, keep "$"
- Math symbols: Keep as-is (>, <, =, ×, →, etc.)
- Emoji icons: Keep unchanged (ℹ️, ✅, ⚠️, etc.)

### Glossary Localization Strategy
- **Define all technical terms on first occurrence** with both English and Turkish
- **Create separate glossary section** with Turkish term → English equivalent (reverse lookup)
- **Example**: "Seviye (İngilizce: Tier) — T1'den T5'e kadar ajan yeteneği derecesi"

### Line Length & Wrapping
- Consider that Turkish text, especially with technical terms, may run longer
- Test HTML rendering with translated content to ensure:
  - Table columns don't overflow
  - Button labels fit in mobile view
  - Code snippets maintain monospace alignment

---

## Validation Checklist for Translators

- [ ] All H1, H2, H3, H4 headings translated
- [ ] All paragraph body text translated
- [ ] All table headers translated
- [ ] All table cell content translated (except identifiers/paths)
- [ ] All callout titles and bodies translated
- [ ] All button labels and aria-labels translated
- [ ] All placeholder text translated
- [ ] All navigation breadcrumbs translated
- [ ] Slash commands preserved unchanged (/caveman, /graphify, etc.)
- [ ] Tier names preserved (T1-T5)
- [ ] Model names preserved (opus, sonnet, haiku)
- [ ] File paths preserved unchanged
- [ ] Code block comments translated
- [ ] Technical terms translated consistently per style guide
- [ ] Turkish diacritics correctly encoded (UTF-8)
- [ ] No hardcoded English strings left in generated prose
- [ ] All linked anchors still functional (IDs unchanged)
- [ ] HTML structure unchanged (only text content modified)
- [ ] Visual testing: page renders correctly with translated content
- [ ] Searchability: page search still works on Turkish text

---

## Files and Artifacts Generated

1. **This audit report**: `.claude/analysis/raw/H01-html-english-audit.md` (this file)
2. **Deliverables for T4-A consolidation**:
   - Translation scope summary (total strings, complexity rating)
   - Glossary of technical terms (Turkish ↔ English mapping)
   - UI string list for internationalization framework
3. **Deliverables for T2-A planning**:
   - Section-by-section breakdown for parallel work allocation
   - Translation tone and style guide
   - Test plan outline

---

## Key Insights for Project Stakeholders

1. **This is not a trivial translation**: ~18K+ words across 8 distinct sections with heavy technical, procedural, and reference content. Estimated 30-35K tokens for T2 design + T3 execution.

2. **Glossary consistency is critical**: 20+ technical terms must be translated once and used consistently throughout. Example: choosing between "Orkestratr" (loanword) or "Koordinatör" (translation) for "Orchestrator" must be decided upfront.

3. **HTML rebuild required**: The source is HTML with inline CSS and JavaScript; translation requires either:
   - Manual HTML rebuild with care to preserve structure, or
   - Automated extraction/reinjection tool (possible time-saver)

4. **Mixed-language strings are common**: Phrases like "use /ctx command", "T1 Principal", "/graphify . --local-only" mix English and system terms; translation must be precise and preserve clarity.

5. **Polish phase needed**: After translation, visual testing to verify:
   - Table column widths accommodate Turkish text
   - Button labels fit on mobile (text likely 10-20% longer)
   - Code block alignment intact
   - Search functionality works on Turkish content

6. **Audience is multi-lingual**: Users familiar with command-line tools, Git, and Anthropic APIs. Preserve technical precision; Turkish phrasing should match developer documentation standards in Turkish tech community.

---

## Conclusion

The `docs/index.html` file is a comprehensive, well-structured English documentation site requiring full translation into Turkish. With 487+ translatable strings across headings, prose, tables, callouts, and UI elements, the scope is substantial but manageable. Recommended next steps:

1. T4-A consolidates this audit into a master translation glossary and style guide
2. T2-A designs the translation and coordination workflow (parallel by section)
3. T3-A executes section-by-section translation with HTML rebuild
4. T2-A reviews for consistency and tone
5. T1-A approves final deliverable

**Ready for consolidation by T4-A.**

