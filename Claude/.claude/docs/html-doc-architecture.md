# HTML Documentation Architecture

## ADR-003: docs/index.html as Single-File Documentation

### Status
Accepted

### Context
The Claude Code v1.0.0 multi-agent system needs user-facing documentation covering 8 main sections, 40+ subsections, 3 walkthroughs, 28 use cases, 6 slash commands, 19 hooks, 7 xN modes, and 12 anti-patterns. The target audience spans absolute beginners (zero multi-agent knowledge) to advanced operators (system customization). Distribution must work offline, on restricted corporate networks, and on any device. Build toolchains are not guaranteed in all environments.

### Decision
A single self-contained `docs/index.html` file with all CSS and JavaScript inlined. No external dependencies, no CDN references, no build step. The file opens directly in any modern browser with full functionality.

### Consequences
- **Positive**: Zero setup, offline-capable, easy to share (single file copy/paste), no version mismatch between CSS/JS/HTML
- **Positive**: Printable with a single Cmd+P / Ctrl+P
- **Negative**: File size 80–150 KB (acceptable for a documentation page; loads in <100ms on any hardware)
- **Negative**: Syntax highlighting must be implemented without a CDN library — use a lightweight inline highlighter (~3 KB custom implementation covering bash, json, typescript, java, markdown)
- **Neutral**: All fonts use system font stack — no Google Fonts dependency

---

## Visual Design System

### Color Palette

#### Light Theme
```
--color-bg-primary:        #ffffff
--color-bg-secondary:      #f8f9fa
--color-bg-tertiary:       #f1f3f5
--color-bg-sidebar:        #f8f9fa
--color-bg-code:           #f4f4f5

--color-border:            #e2e8f0
--color-border-subtle:     #edf2f7

--color-text-primary:      #1a202c
--color-text-secondary:    #4a5568
--color-text-muted:        #718096
--color-text-code:         #2d3748

--color-accent-primary:    #5b4cdb   (brand purple — agent system feel)
--color-accent-hover:      #4338ca
--color-accent-subtle:     #ede9fe

--color-success:           #10b981
--color-warning:           #f59e0b
--color-danger:            #ef4444
--color-info:              #3b82f6

--color-link:              #5b4cdb
--color-link-hover:        #4338ca
```

#### Dark Theme
```
--color-bg-primary:        #0f172a
--color-bg-secondary:      #1e293b
--color-bg-tertiary:       #263248
--color-bg-sidebar:        #1e293b
--color-bg-code:           #1a2234

--color-border:            #2d3f5e
--color-border-subtle:     #243451

--color-text-primary:      #f1f5f9
--color-text-secondary:    #94a3b8
--color-text-muted:        #64748b
--color-text-code:         #e2e8f0

--color-accent-primary:    #818cf8
--color-accent-hover:      #a5b4fc
--color-accent-subtle:     #1e1b4b

--color-success:           #34d399
--color-warning:           #fbbf24
--color-danger:            #f87171
--color-info:              #60a5fa

--color-link:              #818cf8
--color-link-hover:        #a5b4fc
```

### Tier Badge Colors (Both Themes — Saturated Enough for Dark)
```
T1 Principal:     bg #7c3aed  text #ffffff  (deep violet)
T2 Staff Eng:     bg #2563eb  text #ffffff  (blue)
T3 MidCoder:      bg #0891b2  text #ffffff  (cyan)
T4 Lead Analyst:  bg #059669  text #ffffff  (green)
T5 Analyst:       bg #d97706  text #ffffff  (amber)
```

### Severity Badge Colors
```
Critical (P0): bg #fee2e2  text #991b1b  border #fca5a5
Major    (P1): bg #fff7ed  text #92400e  border #fed7aa
Minor    (P2): bg #fefce8  text #854d0e  border #fde68a
Info     (P3): bg #eff6ff  text #1e40af  border #bfdbfe
```

Dark theme severity: darken backgrounds to 15% opacity of the light border color, keep text at 80% lightness.

### Typography Scale
```
System font stack: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto,
                   'Helvetica Neue', Arial, sans-serif
Mono stack:        'JetBrains Mono', 'Fira Code', 'Cascadia Code',
                   Consolas, 'Courier New', monospace

Font sizes (rem):
  --text-xs:   0.75rem   (12px) — badges, captions
  --text-sm:   0.875rem  (14px) — sidebar nav, table cells
  --text-base: 1rem      (16px) — body text
  --text-lg:   1.125rem  (18px) — section intro paragraphs
  --text-xl:   1.25rem   (20px) — h4
  --text-2xl:  1.5rem    (24px) — h3
  --text-3xl:  1.875rem  (30px) — h2 (section titles)
  --text-4xl:  2.25rem   (36px) — h1 (page title only)

Line heights:
  Headings: 1.25
  Body:     1.65
  Code:     1.5

Font weights:
  --weight-normal:    400
  --weight-medium:    500
  --weight-semibold:  600
  --weight-bold:      700
```

### Spacing Scale
```
--space-1:   0.25rem   (4px)
--space-2:   0.5rem    (8px)
--space-3:   0.75rem   (12px)
--space-4:   1rem      (16px)
--space-5:   1.25rem   (20px)
--space-6:   1.5rem    (24px)
--space-8:   2rem      (32px)
--space-10:  2.5rem    (40px)
--space-12:  3rem      (48px)
--space-16:  4rem      (64px)
```

### Component Styling Rules
- Border radius: `0.375rem` (6px) for cards, `0.25rem` (4px) for badges, `0.5rem` (8px) for callouts
- Box shadow (light): `0 1px 3px rgba(0,0,0,0.08), 0 1px 2px rgba(0,0,0,0.04)`
- Box shadow (dark): `0 1px 3px rgba(0,0,0,0.4)`
- Transition: `all 150ms ease` for hover/focus states
- Focus outline: `2px solid var(--color-accent-primary)` with `2px offset`

### Icon System
Use Unicode emoji for status indicators and callout icons — no external icon library.
```
✅  Success / Approved
⚠️  Warning / Revision Required
❌  Error / Rejected / Anti-pattern
🔴  Critical severity
🟠  Major severity
🟡  Minor severity
🔵  Suggestion severity
⭐  Recommended / Best practice
📋  Copy to clipboard (before copy)
✓   Copy to clipboard (after copy)
🌙  Dark mode toggle
☀️  Light mode toggle
🔍  Search
☰   Menu (mobile hamburger)
▶   Expand / Collapsed
▼   Collapse / Expanded
→   Navigation arrow
🏠  Home/Quick Start
```

---

## Layout Structure

### Desktop Layout (viewport >= 1024px)
```
┌─────────────────────────────────────────────────────────────┐
│  STICKY HEADER (height: 56px)                               │
│  Logo | "Claude Code v1.0.0" | Search bar | Dark mode btn   │
├────────────────────┬────────────────────────────────────────┤
│  SIDEBAR           │  MAIN CONTENT                          │
│  (width: 280px)    │  (max-width: 860px, centered)          │
│  position: sticky  │                                        │
│  top: 56px         │  Breadcrumb nav                        │
│  height: calc(     │  Article content (h2 → h4)             │
│   100vh - 56px)    │  Code blocks with copy buttons         │
│  overflow-y: auto  │  Tables, callouts, diagrams             │
│                    │  Prev/Next section navigation          │
│  Section TOC       │                                        │
│  (nested list)     │                                        │
└────────────────────┴────────────────────────────────────────┘
```

CSS implementation:
```css
body { display: flex; flex-direction: column; }
.site-header { position: sticky; top: 0; z-index: 100; height: 56px; }
.content-wrapper { display: flex; flex: 1; }
.sidebar { width: 280px; flex-shrink: 0; position: sticky;
           top: 56px; height: calc(100vh - 56px); overflow-y: auto; }
.main-content { flex: 1; max-width: 860px; padding: 2rem; }
```

### Mobile Layout (viewport < 768px)
```
┌────────────────────────────────────┐
│  STICKY HEADER (56px)              │
│  ☰ Menu | Title | 🌙 Dark | 🔍    │
├────────────────────────────────────┤
│  MAIN CONTENT (full width)         │
│  Breadcrumb                        │
│  Article content                   │
│  Prev/Next navigation              │
└────────────────────────────────────┘

Sidebar: Off-canvas drawer, slides in from left on ☰ tap.
Overlay: Semi-transparent backdrop, click to close.
```

CSS implementation:
```css
@media (max-width: 767px) {
  .sidebar { position: fixed; left: -280px; top: 0; height: 100vh;
             z-index: 200; transition: left 200ms ease; }
  .sidebar.open { left: 0; }
  .sidebar-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.5);
                     z-index: 199; display: none; }
  .sidebar-overlay.visible { display: block; }
}
```

### Tablet Layout (768px–1023px)
Sidebar collapses to icon-only rail (40px wide). Clicking any icon expands to full 280px overlay mode. Content area takes full width minus rail.

### Print Layout
```css
@media print {
  .site-header, .sidebar, .prev-next-nav,
  .copy-btn, .dark-toggle, .search-bar,
  .progress-bar, .sidebar-toggle { display: none !important; }
  .main-content { max-width: 100%; padding: 0; }
  a[href^="#"]::after { content: none; }
  pre, code { border: 1px solid #ccc; }
  h2 { page-break-before: always; }
  h2:first-child { page-break-before: avoid; }
  .cheat-sheet-card { page-break-inside: avoid; }
}
```

The cheat sheet in Section 8.1 gets special print treatment: `page-break-inside: avoid` and a visible border so it prints as a standalone card.

### Sticky Elements
- Header: `position: sticky; top: 0; z-index: 100`
- Sidebar: `position: sticky; top: 56px`
- Progress bar: `position: fixed; top: 56px; left: 0; height: 3px; z-index: 99`

---

## Component Catalog

### 1. Navigation Sidebar
```html
<nav class="sidebar" id="sidebar" aria-label="Documentation navigation">
  <div class="sidebar-header">
    <span class="sidebar-title">Contents</span>
    <button class="sidebar-close" aria-label="Close menu">✕</button>
  </div>
  <ul class="nav-list">
    <li class="nav-section">
      <a href="#quick-start" class="nav-link nav-section-link">
        <span class="nav-number">1</span>
        <span class="nav-text">Quick Start</span>
        <span class="reading-time">5 min</span>
      </a>
      <ul class="nav-subsection-list">
        <li><a href="#what-is-claude-code" class="nav-sublink">1.1 What is Claude Code?</a></li>
        <li><a href="#one-command-setup" class="nav-sublink">1.2 One-Command Setup</a></li>
        <li><a href="#first-task" class="nav-sublink">1.3 Your First Task</a></li>
      </ul>
    </li>
    <!-- repeat for sections 2–8 -->
  </ul>
  <div class="sidebar-quicklinks">
    <span class="quicklinks-label">Jump to</span>
    <a href="#cheat-sheet">Cheat Sheet</a>
    <a href="#faq">FAQ</a>
    <a href="#glossary">Glossary</a>
  </div>
</nav>
```

CSS notes:
- Active nav link: `background: var(--color-accent-subtle); color: var(--color-accent-primary); font-weight: 600`
- Subsection list: `padding-left: 1.5rem; font-size: 0.875rem`
- Reading time badge: `font-size: 0.7rem; color: var(--color-text-muted); margin-left: auto`

### 2. Site Header
```html
<header class="site-header" role="banner">
  <button class="sidebar-toggle" aria-label="Toggle navigation" aria-controls="sidebar">
    ☰
  </button>
  <div class="header-brand">
    <span class="header-logo">⚡</span>
    <span class="header-title">Claude Code <span class="version-badge">v1.0.0</span></span>
  </div>
  <div class="header-search">
    <label for="search-input" class="sr-only">Search documentation</label>
    <input id="search-input" type="search" placeholder="🔍 Search docs..." 
           autocomplete="off" aria-label="Search documentation">
    <div id="search-results" class="search-dropdown" role="listbox" aria-live="polite"></div>
  </div>
  <button class="dark-toggle" id="dark-toggle" aria-label="Toggle dark mode">🌙</button>
</header>
```

### 3. Breadcrumb Navigation
```html
<nav class="breadcrumb" aria-label="Breadcrumb">
  <ol class="breadcrumb-list">
    <li><a href="#quick-start">Quick Start</a></li>
    <li aria-hidden="true">→</li>
    <li aria-current="page">Your First Task</li>
  </ol>
</nav>
```

### 4. Code Block with Copy Button
```html
<div class="code-block" data-lang="bash">
  <div class="code-header">
    <span class="code-lang-label">bash</span>
    <button class="copy-btn" aria-label="Copy code to clipboard" title="Copy">
      <span class="copy-icon">📋</span>
      <span class="copy-text">Copy</span>
    </button>
  </div>
  <pre><code class="highlight-bash">bash .claude/scripts/setup.sh</code></pre>
</div>
```

CSS notes:
- `code-block`: `position: relative; background: var(--color-bg-code); border-radius: 0.5rem; border: 1px solid var(--color-border)`
- `code-header`: `display: flex; justify-content: space-between; padding: 0.5rem 1rem; border-bottom: 1px solid var(--color-border)`
- `copy-btn.copied`: text changes to "✓ Copied", green color, reverts after 2s
- Pre: `overflow-x: auto; padding: 1rem; margin: 0`

### 5. Callout Boxes
```html
<!-- Info callout -->
<aside class="callout callout-info" role="note">
  <span class="callout-icon" aria-hidden="true">ℹ️</span>
  <div class="callout-body">
    <strong class="callout-title">Note</strong>
    <p>PEP is skipped for trivial tasks (fewer than 3 lines, 1 file, no business logic).</p>
  </div>
</aside>

<!-- Warning callout -->
<aside class="callout callout-warning" role="alert">
  <span class="callout-icon" aria-hidden="true">⚠️</span>
  <div class="callout-body">
    <strong class="callout-title">Important</strong>
    <p>Always use <code>--local-only</code> with graphify to avoid sending code to external APIs.</p>
  </div>
</aside>

<!-- Success callout -->
<aside class="callout callout-success" role="note">
  <span class="callout-icon" aria-hidden="true">✅</span>
  <div class="callout-body">
    <strong class="callout-title">Best Practice</strong>
    <p>x5 is the recommended default mode for standard feature development.</p>
  </div>
</aside>

<!-- Danger callout -->
<aside class="callout callout-danger" role="alert">
  <span class="callout-icon" aria-hidden="true">🔴</span>
  <div class="callout-body">
    <strong class="callout-title">Anti-Pattern</strong>
    <p>Never use x10 for a single-file fix — $15 cost for trivial work.</p>
  </div>
</aside>
```

CSS: Each callout variant uses the severity colors from the Visual Design System. `display: flex; gap: 0.75rem; padding: 1rem 1.25rem; border-radius: 0.5rem; border-left: 4px solid`.

### 6. Tier Badge
```html
<span class="tier-badge tier-t1" title="T1 Principal — opus model">T1</span>
<span class="tier-badge tier-t2" title="T2 Staff Engineer — sonnet model">T2</span>
<span class="tier-badge tier-t3" title="T3 MidCoder — sonnet model">T3</span>
<span class="tier-badge tier-t4" title="T4 Lead Analyst — haiku model">T4</span>
<span class="tier-badge tier-t5" title="T5 Analyst — haiku model">T5</span>
```

CSS: `display: inline-flex; align-items: center; padding: 0.125rem 0.5rem; border-radius: 0.25rem; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.025em`

### 7. Agent Badge (Role + Score Display)
```html
<div class="agent-badge">
  <span class="tier-badge tier-t1">T1</span>
  <span class="agent-name">Selin Akar</span>
  <span class="agent-model" title="Model tier">opus</span>
  <span class="agent-score" title="Leaderboard score">⭐ 12</span>
</div>
```

Used in walkthrough sections to show which agent handled which task. Inline flex, small gap, muted model label.

### 8. xN Mode Card
```html
<div class="xn-card" data-xn="x5">
  <div class="xn-header">
    <span class="xn-label">x5 <span class="recommended-star">⭐</span></span>
    <span class="xn-cost">$4–6</span>
  </div>
  <div class="xn-agents">
    <span class="tier-badge tier-t1">T1</span>
    <span class="tier-badge tier-t2">T2</span>
    <span class="tier-badge tier-t3">T3</span>
    <span class="tier-badge tier-t4">T4</span>
    <span class="tier-badge tier-t5">T5</span>
  </div>
  <p class="xn-description">DEFAULT: Balanced team, full review chain. Best for standard features.</p>
  <div class="xn-review-chain">T5 → T4 → [T3→T2, T2→T1]</div>
</div>
```

Used in Section 2.2 and cheat sheet. Grid layout: `display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr))`

### 9. Workflow Diagram (ASCII-based SVG)
For the x5 Wave Execution diagram in Section 3.3:
```html
<figure class="workflow-diagram" aria-label="x5 mode wave execution diagram">
  <svg viewBox="0 0 760 280" xmlns="http://www.w3.org/2000/svg" 
       class="dag-svg" role="img" aria-label="DAG execution waves">
    <!-- Wave labels -->
    <text x="20" y="30" class="wave-label">Wave 1</text>
    <text x="20" y="110" class="wave-label">Wave 2</text>
    <text x="20" y="190" class="wave-label">Wave 3</text>
    <text x="20" y="270" class="wave-label">Wave 4</text>
    <!-- Boxes for each agent tier per wave -->
    <!-- Arrows connecting waves -->
    <!-- Use currentColor so it respects dark mode -->
  </svg>
  <figcaption>x5 execution: 4 waves, parallel where independent</figcaption>
</figure>
```

Note for T1-A: Use `currentColor` for all SVG strokes/fills — this automatically adapts to dark mode. Define CSS classes `.wave-label`, `.agent-box`, `.arrow-line` with `fill: var(--color-text-primary)` and `stroke: var(--color-border)`.

### 10. Review Chain Diagram
```html
<figure class="review-chain" aria-label="Review chain flow">
  <div class="chain-flow">
    <div class="chain-node"><span class="tier-badge tier-t5">T5</span> Output</div>
    <div class="chain-arrow">→</div>
    <div class="chain-node"><span class="tier-badge tier-t4">T4</span> Review</div>
    <div class="chain-arrow">→</div>
    <div class="chain-node"><span class="tier-badge tier-t2">T2</span> Review</div>
    <div class="chain-arrow">→</div>
    <div class="chain-node"><span class="tier-badge tier-t1">T1</span> Approve</div>
  </div>
  <p class="chain-outcomes">
    Outcomes: <span class="outcome-approved">✅ Approved</span> | 
    <span class="outcome-revision">⚠️ Revision (max 2)</span> | 
    <span class="outcome-rejected">❌ Rejected → Escalate</span>
  </p>
</figure>
```

CSS: `chain-flow` is `display: flex; align-items: center; gap: 0.5rem; flex-wrap: wrap`. On mobile, wraps vertically.

### 11. Tab System (Tool Comparisons)
```html
<div class="tab-group" data-tab-group="tools">
  <div class="tab-list" role="tablist">
    <button class="tab-btn active" role="tab" aria-selected="true" 
            data-tab="context-mode" aria-controls="tab-panel-context-mode">
      context-mode
    </button>
    <button class="tab-btn" role="tab" aria-selected="false" 
            data-tab="graphify" aria-controls="tab-panel-graphify">
      graphify
    </button>
    <button class="tab-btn" role="tab" aria-selected="false" 
            data-tab="combined" aria-controls="tab-panel-combined">
      Combined
    </button>
  </div>
  <div id="tab-panel-context-mode" class="tab-panel active" role="tabpanel">
    <!-- context-mode content -->
  </div>
  <div id="tab-panel-graphify" class="tab-panel" role="tabpanel" hidden>
    <!-- graphify content -->
  </div>
  <div id="tab-panel-combined" class="tab-panel" role="tabpanel" hidden>
    <!-- combined workflow content -->
  </div>
</div>
```

Used in Section 5 to compare tool behaviors side by side.

### 12. Collapsible Section
```html
<details class="collapsible-section">
  <summary class="collapsible-header">
    <span class="collapse-icon">▶</span>
    <span class="collapse-title">Advanced: Score Calculation Details</span>
  </summary>
  <div class="collapsible-body">
    <!-- content -->
  </div>
</details>
```

Uses native `<details>`/`<summary>` — no JS required for basic functionality. CSS adds the animated icon rotation.

### 13. Cheat Sheet Card
```html
<section id="cheat-sheet" class="cheat-sheet-card">
  <div class="cheat-sheet-header">
    <h2>Cheat Sheet</h2>
    <button class="print-btn" onclick="window.print()">🖨️ Print</button>
  </div>
  <div class="cheat-sheet-grid">
    <div class="cheat-col">
      <h3>Slash Commands</h3>
      <table class="cheat-table"><!-- commands table --></table>
    </div>
    <div class="cheat-col">
      <h3>xN Modes</h3>
      <table class="cheat-table"><!-- xN table --></table>
    </div>
    <div class="cheat-col">
      <h3>Quick Decisions</h3>
      <table class="cheat-table"><!-- decisions table --></table>
    </div>
  </div>
</section>
```

`cheat-sheet-grid`: 3-column grid on desktop, 1-column on mobile. Print stylesheet targets `.cheat-sheet-card` with `page-break-inside: avoid` so it prints as one page.

### 14. Progress Bar
```html
<div class="reading-progress" role="progressbar" 
     aria-label="Reading progress" aria-valuenow="0" 
     aria-valuemin="0" aria-valuemax="100">
  <div class="progress-fill" id="progress-fill"></div>
</div>
```

Positioned `fixed; top: 56px; left: 0; width: 100%; height: 3px; background: var(--color-bg-tertiary)`. Fill: `background: var(--color-accent-primary); transition: width 100ms linear`.

### 15. Section Header with Metadata
```html
<div class="section-meta">
  <span class="section-number">Section 2</span>
  <span class="reading-time-estimate">⏱ 15 min read</span>
  <span class="difficulty-tag difficulty-intermediate">Intermediate</span>
</div>
<h2 id="core-concepts">Core Concepts</h2>
```

### 16. Previous/Next Navigation
```html
<nav class="prev-next-nav" aria-label="Section navigation">
  <a href="#quick-start" class="prev-link">
    <span class="nav-direction">← Previous</span>
    <span class="nav-title">Quick Start</span>
  </a>
  <a href="#common-workflows" class="next-link">
    <span class="nav-direction">Next →</span>
    <span class="nav-title">Common Workflows</span>
  </a>
</nav>
```

---

## JavaScript Behaviors

### 1. Dark Mode Toggle
```
Trigger: button#dark-toggle click
Implementation:
  - On click: toggle class 'dark-mode' on <html>
  - Persist preference: localStorage.setItem('theme', 'dark'|'light')
  - On load: read localStorage, apply before first paint (inline <script> in <head>)
  - System preference: check prefers-color-scheme media query as fallback
  - Button icon: swap 🌙 ↔ ☀️ based on current mode
Note: The inline <script> in <head> that reads localStorage must run BEFORE
  any CSS class is applied to prevent flash of wrong theme (FOWT).
```

### 2. Sidebar Toggle (Mobile)
```
Trigger: button.sidebar-toggle click
Implementation:
  - Toggle class 'open' on #sidebar
  - Toggle class 'visible' on .sidebar-overlay
  - Set aria-expanded on toggle button
  - Click on overlay: close sidebar
  - Escape key: close sidebar
  - Focus trap: when sidebar open, tab stays within sidebar
```

### 3. Active Section Highlight in TOC
```
Trigger: IntersectionObserver on all h2, h3 elements
Implementation:
  - Create observer with threshold: 0.3, rootMargin: '-56px 0px -60% 0px'
  - When heading enters viewport: mark corresponding nav link as 'active'
  - Active link: add class 'nav-active', scroll into view in sidebar if needed
  - Only one active link at a time (last winner)
```

### 4. Client-Side Search
```
Trigger: input event on #search-input (debounced 200ms)
Implementation:
  - On page load: build search index from static data array:
    searchIndex = [
      { id: 'quick-start', section: 'Quick Start', text: '...all content text...', keywords: ['setup', 'install', ...] },
      ...
    ]
  - On input: filter index by query (case-insensitive contains match on text + keywords)
  - Display up to 8 results in dropdown #search-results
  - Each result: section name + snippet with matched term bolded
  - Keyboard: arrow keys navigate results, Enter navigates to section, Escape closes
  - Click result: close dropdown, smooth scroll to section anchor
  - Empty query: hide dropdown
  - No results: show "No results for 'query'" message
Search data structure: populate at build time by extracting all visible text from
each section, stripping HTML, into the inline JavaScript constant.
```

### 5. Copy Code Button
```
Trigger: click on .copy-btn within any .code-block
Implementation:
  - Read text content from sibling <code> element (strip leading/trailing whitespace)
  - navigator.clipboard.writeText(text)
  - On success: change icon to ✓, text to 'Copied', add class 'copied' (green)
  - Reset after 2000ms
  - On failure (HTTP context): fallback to document.execCommand('copy') via textarea trick
```

### 6. Smooth Scroll to Anchors
```
Implementation:
  - All internal <a href="#anchor"> links use behavior: smooth
  - Apply in CSS: html { scroll-behavior: smooth; scroll-padding-top: 72px; }
  - 72px = 56px header + 16px visual breathing room
  - For programmatic navigation (search, prev/next): element.scrollIntoView({ behavior: 'smooth', block: 'start' })
  - After scroll: update browser URL via history.replaceState (no page reload)
```

### 7. Reading Progress Bar
```
Trigger: window scroll event (throttled to 100ms via requestAnimationFrame)
Implementation:
  - Calculate: scrolled = window.scrollY / (document.body.scrollHeight - window.innerHeight)
  - Set: progressFill.style.width = Math.round(scrolled * 100) + '%'
  - Set: progressBar.setAttribute('aria-valuenow', Math.round(scrolled * 100))
```

### 8. Tab System
```
Trigger: click on .tab-btn
Implementation:
  - Within same .tab-group: deactivate all tabs (aria-selected=false, hidden panel)
  - Activate clicked tab (aria-selected=true, show panel, remove hidden)
  - Keyboard: arrow keys switch tabs (ARIA tab pattern)
```

### 9. Collapsible Sections
```
Uses native <details>/<summary> — JavaScript only needed for:
  - Icon rotation CSS: details[open] .collapse-icon { transform: rotate(90deg); }
  - Deep-link support: if URL hash points to content inside a closed <details>,
    open parent <details> on page load
```

### 10. TOC Expand/Collapse (Desktop Sidebar)
```
Trigger: click on .nav-section-link (desktop sidebar)
Implementation:
  - Toggle visibility of child .nav-subsection-list
  - Multiple sections can be open simultaneously
  - Auto-expand section containing currently active anchor on page load
  - Persist expanded state in sessionStorage
```

### 11. Estimated Reading Time
```
Computed at page load per section:
  - Count words in section text content
  - Divide by 200 (average reading speed wpm)
  - Round to nearest minute, minimum 1
  - Inject into .reading-time-estimate elements
```

### 12. Anchor Link Headers
```
On page load: for every h2, h3, h4 that has an id attribute:
  - Append <a class="anchor-link" href="#id" aria-label="Link to this section">#</a>
  - Show on hover of the heading (opacity: 0 default, 1 on :hover)
  - Clicking copies URL to clipboard and shows brief tooltip "Copied!"
```

---

## Per-Section Content Structure

### Section 1: Quick Start
- **Word count**: ~400 words
- **Estimated read time**: 5 min
- **Difficulty**: Beginner
- **Components**: callout (info × 1), code-block × 3, section-meta
- **Content blocks**:
  - h2: "Quick Start" (id="quick-start")
  - h3: "1.1 What is Claude Code?" (id="what-is-claude-code")
    - 2 paragraphs: system overview, 5-tier architecture sentence
    - Callout (info): "This is an orchestration layer — not a single AI assistant"
    - Simple text diagram: Orchestrator → [T1..T5] → Your Code
  - h3: "1.2 One-Command Setup" (id="one-command-setup")
    - Prerequisites list (Node, git, Claude Code CLI)
    - Code block (bash): setup command sequence (from A.1 use case)
    - Code block (text): expected output showing `.claude/` tree
    - Callout (success): "Installation complete — 100+ config files ready"
  - h3: "1.3 Your First Task" (id="first-task")
    - Short prose: "Try the simplest possible task"
    - Code block (text): typo fix command (from F.1 walkthrough)
    - Expected output block
    - Callout (info): cross-link → "For a full guided walkthrough, see Walkthrough W1"
    - Link to W2 and W3 walkthroughs in Section 3
- **Cross-links**: Section 3.1 (simple fix workflow), walkthroughs W1/W2/W3

### Section 2: Core Concepts
- **Word count**: ~1,200 words
- **Estimated read time**: 15 min
- **Difficulty**: Beginner–Intermediate
- **Components**: tier-badge × 5, xn-card × 7, review-chain diagram, tab-group × 1, table × 3
- **Content blocks**:
  - h2: "Core Concepts" (id="core-concepts")
  - h3: "2.1 Five Tiers Explained" (id="five-tiers")
    - Table: Tier | Role | Model | Responsibility | Cost/Task
    - Tier badges with role descriptions
    - Callout (info): "T1 opus is highest capability and highest cost — use for architecture decisions"
    - Collapsible: "Score-weighted selection mechanics" (from C.7)
  - h3: "2.2 xN Modes Quick Reference" (id="xn-modes")
    - xN cards grid (7 cards: single + x2 through x10)
    - Table: xN modes comparison with cost column
    - Callout (success): "x5 is the recommended default — balanced cost/capability"
    - Decision tree (simple if/else flowchart using styled divs, no JS):
      - "Trivial (<3 lines, 1 file)?" → Single
      - "Research only?" → x2
      - "Small feature?" → x3
      - "Standard feature?" → x5 ⭐
      - "System-wide?" → x10
  - h3: "2.3 The Review Chain" (id="review-chain")
    - Review chain diagram component
    - Review outcomes table: ✅ Approved | ⚠️ Revision | ❌ Rejected
    - Revision counter mechanic explanation (2-strike escalation)
    - Collapsible: "Escalation Seed Format" (code block, markdown lang)
  - h3: "2.4 Hooks System Overview" (id="hooks-overview")
    - Brief text: what hooks do, when they fire
    - Table: Hook event | Purpose | Count (PreToolUse:Edit 11, PostToolUse 3, SessionEnd 3, PreToolUse:Bash 2)
    - Cross-link → Section 6.2 for full catalog
  - h3: "2.5 Skills System" (id="skills-system")
    - Table of 6 slash commands (from cheat sheet data)
    - Cross-link → Section 5.3 for extended reference
- **Cross-links**: Section 5 (tools reference), Section 6.2 (hooks), Section 4.7 (score selection)

### Section 3: Common Workflows
- **Word count**: ~2,000 words (largest section — 3 full walkthroughs + 5 brief workflow summaries)
- **Estimated read time**: 30 min
- **Difficulty**: Beginner–Intermediate
- **Components**: code-block × 12, agent-badge × 8, callout × 6, collapsible × 3, workflow-diagram × 2
- **Content blocks**:
  - h2: "Common Workflows" (id="workflows")
  - h3: "3.1 Simple Fix — Single Agent" (id="workflow-simple")
    - Full W1 walkthrough (from F.1): command → analysis → execution → output
    - Cost/time summary table
    - Callout: "No performance report in single-agent mode"
  - h3: "3.2 Small Feature — x3 Mode" (id="workflow-x3")
    - B.1 use case abridged
    - Wave execution text diagram
    - Cost/time summary
  - h3: "3.3 Standard Feature — x5 Mode" (id="workflow-x5")
    - Full W2 walkthrough (from F.2): PEP → task planning → wave execution → review chain → output
    - Workflow diagram SVG (x5 waves)
    - Agent badges for each wave
    - Code blocks: Java files from walkthrough
    - Performance report block (styled)
  - h3: "3.4 System Audit — x10 Mode" (id="workflow-x10")
    - F.3 walkthrough (condensed — summarize wave structure, show task planning, key output)
    - Callout (warning): "Budget 25–35 minutes for x10 execution"
  - h3: "3.5 Using /caveman" (id="workflow-caveman")
    - B.8 use case
    - Side-by-side Normal vs Caveman output comparison (2-column table or code blocks)
    - Cross-link → Section 5.3 caveman docs
  - h3: "3.6 Using /ctx (Context-Mode)" (id="workflow-ctx")
    - B.6 use case, step-by-step commands
    - Token savings callout: "~76% per x10 session"
    - Cross-link → Section 5.1
  - h3: "3.7 Using /graphify" (id="workflow-graphify")
    - B.5 use case: commands, output files table
    - graph.json sample (json code block)
    - Cross-link → Section 5.2
  - h3: "3.8 Combining Tools" (id="workflow-combined")
    - B.6 combined workflow
    - Step-by-step numbered list with code blocks
- **Cross-links**: Section 5.1, 5.2, 5.3, Section 2.2, Section 4

### Section 4: Advanced Topics
- **Word count**: ~1,600 words
- **Estimated read time**: 40 min
- **Difficulty**: Advanced
- **Components**: code-block × 10, callout × 5, collapsible × 4
- **Content blocks**:
  - h2: "Advanced Topics" (id="advanced")
  - h3: "4.1 Custom Skills Creation" (id="custom-skills")
    - File structure for a skill: `SKILL.md`, directory layout
    - Code block (bash): creating skill directory
    - Code block (markdown): SKILL.md template
  - h3: "4.2 Custom Hooks" (id="custom-hooks")
    - C.3 use case: full hook creation example
    - Code block (bash): custom-credential-check.sh
    - settings.json registration snippet
    - Callout (warning): "Exit 1 blocks the tool; exit 0 allows it"
  - h3: "4.3 Custom Agent Templates" (id="custom-agents")
    - C.4 use case: T3-React specialist example
    - Code block (markdown): agent template structure
    - Note on conditional spawning by Orchestrator
  - h3: "4.4 Memory and Learned Patterns" (id="learned-patterns")
    - C.2 manual pattern creation
    - C.8 promotion mechanics (hit-count >= 3 → learned-*.md)
    - Pattern file frontmatter code block (markdown)
    - Lifecycle diagram (text-based): active → promoted | active → archived
  - h3: "4.5 Cost Optimization" (id="cost-optimization")
    - C.9 metrics interpretation
    - Table: Task type → recommended mode → estimated cost
    - Callout (success): "Use T5 first for research — $0.05/task vs $0.75 for T1"
  - h3: "4.6 Escalation Handling" (id="escalation")
    - C.6 full walkthrough
    - Code block (markdown): escalation seed format
    - Revision counter state machine (text diagram)
  - h3: "4.7 Score-Weighted Agent Selection" (id="agent-selection")
    - C.7 full mechanics
    - Weight formula: `(score + 101) × tier_multiplier`
    - Table: tier_multiplier values per tier
- **Cross-links**: Section 6 (config), Section 8.4 (metrics)

### Section 5: Tools Reference
- **Word count**: ~1,000 words
- **Estimated read time**: 25 min
- **Difficulty**: Intermediate
- **Components**: tab-group × 1, code-block × 8, table × 4, callout × 3
- **Content blocks**:
  - h2: "Tools Reference" (id="tools")
  - h3: "5.1 context-mode" (id="context-mode-ref")
    - Tool table: 7 tools from TOOLS_OVERVIEW.md (ctx_execute, ctx_index, ctx_search, etc.)
    - Token savings callout: "~76% per x10 session (50K → 12K tokens)"
    - Security constraints table (denied paths)
    - Installation cross-link → .claude/docs/context-mode-install.md note
  - h3: "5.2 graphify" (id="graphify-ref")
    - Invocation modes table (4 modes from TOOLS_OVERVIEW.md)
    - Output files table (graph.json, GRAPH_REPORT.md, graph.html)
    - jq query examples (code block, bash): top god nodes, neighbors, community lookup
    - Threshold rule callout: ">20 files → mandatory graphify; <=20 → direct reads"
    - Stale marker protocol code block
    - Installation cross-link
  - h3: "5.3 Slash Commands Reference" (id="slash-commands")
    - Tab group: one tab per command (/caveman, /graphify, /ctx, /review, /security-review, /architect)
    - Each tab: trigger syntax, behavior description, example command, sample output
- **Cross-links**: Section 3.5–3.8 (workflow uses), Section 2.5 (skills overview)

### Section 6: Configuration
- **Word count**: ~900 words
- **Estimated read time**: 20 min
- **Difficulty**: Advanced
- **Components**: code-block × 6, table × 4, collapsible × 2
- **Content blocks**:
  - h2: "Configuration" (id="configuration")
  - h3: "6.1 settings.json Structure" (id="settings-json")
    - Code block (json): annotated settings.json structure showing hook registration
    - permissions, mcpServers, env vars sections
  - h3: "6.2 Hooks Catalog" (id="hooks-catalog")
    - Table: 19 hooks — name | trigger event | rule enforced | file path
    - Group by trigger: PreToolUse:Edit/Write (11), PreToolUse:Bash (2), PostToolUse (3), SessionEnd (3)
    - Callout (info): "Hooks block (exit 1) or warn (exit 0) — violations go to stderr"
  - h3: "6.3 Agent Templates" (id="agent-templates")
    - Table: 5 templates — tier | role | model | file | key behaviors
    - Collapsible: template structure (markdown code block showing sections)
  - h3: "6.4 Rules Catalog" (id="rules-catalog")
    - Table: 17 rule files — file | scope (path patterns) | key rules
    - Note on learned-*.md promotion files
- **Cross-links**: Section 4.2 (custom hooks), Section 4.3 (custom agents), Section 4.4 (learned patterns)

### Section 7: Troubleshooting
- **Word count**: ~800 words
- **Estimated read time**: 15 min
- **Difficulty**: Mixed
- **Components**: callout × 4, code-block × 4, table × 2
- **Content blocks**:
  - h2: "Troubleshooting" (id="troubleshooting")
  - h3: "7.1 Common Errors and Recovery" (id="common-errors")
    - Table: Error symptom | Likely cause | Recovery steps (from metrics-tracking.md troubleshooting table, expanded)
    - Include: hook failures, permission denied, context overflow, model fallback
  - h3: "7.2 Hook Failures and Debugging" (id="hook-debugging")
    - How to read hook error output (stderr)
    - Code block (bash): testing a hook manually
    - Callout (info): "Hooks write to stderr — check Claude's tool output panel"
  - h3: "7.3 Permission Denials and Escalation" (id="permission-issues")
    - What triggers a permission prompt
    - How to add to settings.json allowlist
    - Cross-link → settings.json section
  - h3: "7.4 Cost Overruns and Optimization" (id="cost-issues")
    - Signs of cost overrun
    - Quick remediation: cancel session, reduce xN, use /caveman
    - Cross-link → Section 4.5 cost optimization
- **Cross-links**: Section 8.3 (FAQ), Section 6.1 (settings), Section 4.5 (cost optimization)

### Section 8: Reference
- **Word count**: ~1,000 words + cheat sheet tables
- **Estimated read time**: variable (reference, not linear)
- **Difficulty**: All levels
- **Components**: cheat-sheet-card × 1, table × 6, collapsible × 12 (FAQ items)
- **Content blocks**:
  - h2: "Reference" (id="reference")
  - h3: "8.1 Cheat Sheet" (id="cheat-sheet")
    - cheat-sheet-card component (printable)
    - Three columns: slash commands table + xN modes table + quick decisions table
    - Print button
  - h3: "8.2 Glossary" (id="glossary")
    - Definition list (`<dl>`) of 20+ terms: xN, PEP, DAG, god node, wave, revision_attempts,
      hit-count, learned-pattern, escalation seed, T1–T5, opus/sonnet/haiku,
      ctx_index, ctx_search, graphify, stale marker, file ownership, review chain
    - Terms linkable by anchor (#glossary-xn, etc.)
  - h3: "8.3 FAQ" (id="faq")
    - 12 questions as native `<details>` collapsibles
    - Questions sourced from G04 FAQ notes and anti-patterns (G.1–G.12)
    - Sample questions:
      - "When should I NOT use x10?"
      - "What happens if a hook blocks my edit?"
      - "How do I reset an agent's revision counter?"
      - "Can I use caveman mode with x10?"
      - "Why is graphify giving stale results?"
      - "How do I promote a learned pattern manually?"
  - h3: "8.4 Metrics Interpretation" (id="metrics")
    - C.9 full content
    - token-usage.md structure table
    - leaderboard.md interpretation guide
    - Score deltas reference table (from metrics-tracking.md)
- **Cross-links**: Section 7 (troubleshooting), Section 4.4 (patterns), Section 4.7 (scoring)

---

## Code Snippet Inventory

| # | Language | Purpose | Source | Section |
|---|----------|---------|--------|---------|
| 1 | bash | Setup script invocation + verify | G02 A.1 | 1.2 |
| 2 | text | Expected setup output (directory tree) | G02 A.1 | 1.2 |
| 3 | text | Typo fix command (F.1 walkthrough) | G02 F.1 | 1.3, 3.1 |
| 4 | text | Typo fix output | G02 F.1 | 3.1 |
| 5 | text | xN mode decision examples (E section) | G02 E | 2.2 |
| 6 | text | x5 feature command + PEP questions | G02 F.2 | 3.3 |
| 7 | markdown | Task planning DAG (active-plan.md format) | G02 F.2 | 3.3 |
| 8 | java | UserProfileController.java | G02 F.2 | 3.3 |
| 9 | java | UserProfileDTO.java | G02 F.2 | 3.3 |
| 10 | java | UserProfileService.java | G02 F.2 | 3.3 |
| 11 | text | T2 → T3 review findings | G02 F.2 | 3.3 |
| 12 | text | T1 → T2 review findings | G02 F.2 | 3.3 |
| 13 | markdown | Session performance report | G02 F.2 | 3.3 |
| 14 | text | x10 command + PEP questions | G02 F.3 | 3.4 |
| 15 | markdown | x10 task plan (waves 1–5) | G02 F.3 | 3.4 |
| 16 | text | Normal vs Caveman output comparison | G02 B.8 | 3.5 |
| 17 | typescript | Code block (unchanged in both modes) | G02 B.8 | 3.5 |
| 18 | bash | context-mode workflow steps | G02 B.6 | 3.6 |
| 19 | bash | graphify invocation + GRAPH_REPORT | G02 B.5 | 3.7 |
| 20 | json | graph.json sample structure | G02 B.5 | 3.7, 5.2 |
| 21 | bash | Combined graphify + ctx workflow | G02 B.6 | 3.8 |
| 22 | markdown | Learned pattern file (LP-*.md template) | G02 C.2 | 4.1/4.4 |
| 23 | bash | Custom hook creation (C.3) | G02 C.3 | 4.2 |
| 24 | markdown | Custom agent template (C.4) | G02 C.4 | 4.3 |
| 25 | bash | Manual pattern creation (C.2) | G02 C.2 | 4.4 |
| 26 | markdown | Escalation seed format (C.6) | G02 C.6 | 4.6 |
| 27 | bash | Stale marker check | rules/graphify-usage.md | 5.2 |
| 28 | bash | jq god_nodes query | rules/graphify-usage.md | 5.2 |
| 29 | bash | jq neighbors query | rules/graphify-usage.md | 5.2 |
| 30 | json | settings.json hook registration (annotated) | CLAUDE.md Step 4 | 6.1 |
| 31 | bash | Manual hook test invocation | generate | 7.2 |
| 32 | text | Active-plan.md status check during x10 | G02 A.5 | 1.3, 3.4 |
| 33 | text | Leaderboard.md sample output | G02 A.6 | 8.4 |
| 34 | markdown | token-usage.md structure | G02 C.9 | 8.4 |
| 35 | bash | Security review findings sample | G02 B.4 | 5.3 |

**Syntax Highlighting Languages Needed**: `bash`, `json`, `typescript`, `java`, `markdown`, `text` (no highlighting, just mono)

**Inline Highlighter Implementation** (T1-A note): Implement a ~3 KB lightweight highlighter covering these 5 languages. Approach:
- Define token regex per language (keywords, strings, comments, numbers)
- `highlight(code, lang)` → HTML with `<span class="hl-*">` wrappers
- CSS classes: `hl-keyword`, `hl-string`, `hl-comment`, `hl-number`, `hl-function`, `hl-operator`
- Run on page load for all `<code>` elements that have a `data-lang` attribute
- Do NOT use innerHTML during highlighting — build via DOM or sanitized string

---

## Implementation Notes for T1-A

### File Size Target
- **Target**: 90–130 KB uncompressed
- **HTML + structure**: ~15 KB
- **Inline CSS**: ~20 KB
- **Inline JavaScript**: ~12 KB (search index data: ~25 KB, syntax highlighter: ~3 KB, behaviors: ~9 KB)
- **Content text**: ~40 KB
- **Total**: ~115 KB estimated

### Content Metrics
- Total estimated content: 9,000–11,000 words
- Total estimated read time: ~75 minutes (full document)
- Beginner read time (Sections 1–2 + W1): ~20 minutes
- Intermediate read time (Sections 1–3 + skills): ~50 minutes
- Advanced path (Sections 4–6 + reference): ~80 minutes

### Semantic HTML5 Requirements
```
<html> — lang="en"
<head> — meta charset, viewport, title, inline style (theme), inline script (theme preference)
<body> — no classes initially; 'dark-mode' class added by JS
<header role="banner"> — sticky site header
<nav aria-label="Documentation navigation"> — sidebar
<main id="main-content"> — skip link target
<article> — each major section
<section> — subsections within articles
<aside> — callout boxes, supplementary info
<figure> + <figcaption> — diagrams, code samples with captions
<nav aria-label="Breadcrumb"> — breadcrumb
<nav aria-label="Section navigation"> — prev/next
<footer> — minimal: version info, generated date
```

### WCAG AA Accessibility Requirements
- All color combinations must meet 4.5:1 contrast ratio (text on background)
- Tier badge text (#fff on colored backgrounds): verify each tier color passes
- Focus indicators: 2px solid accent color, 2px offset — never remove default outline
- All images/SVGs: `alt` or `aria-label` attributes
- Skip link: `<a href="#main-content" class="skip-link">Skip to main content</a>` as first element in body (visible on focus)
- ARIA live region on search results: `aria-live="polite"`
- Tab panels: full ARIA tablist/tab/tabpanel pattern
- Interactive elements: never div/span with onclick — use button or a elements
- Form controls: all inputs labeled (search input has `<label>` or `aria-label`)
- Keyboard navigation: all interactive elements reachable, logical tab order

### Search Index Build Strategy
At the bottom of the `<body>`, before closing `</body>`, include an inline `<script>` block that defines:
```javascript
const SEARCH_INDEX = [
  { id: "quick-start", section: "1. Quick Start", title: "Quick Start", 
    content: "...", keywords: ["install", "setup", "first task", ...] },
  // one entry per subsection h3
];
```
Content field: strip all HTML from the section text at index-build time. T1-A writes the HTML first, then manually (or with a small extraction script run once) populates these strings. Alternatively, T1-A generates the search index programmatically on first page load using `document.querySelectorAll('section')` to extract `.textContent`.

**Recommended approach**: Build search index on first `DOMContentLoaded` from live DOM (no manual step). Cache in `sessionStorage` to avoid re-extraction on subsequent page visits within same session.

### Anti-Patterns Section (G.1–G.12) Placement
Include all 12 anti-patterns in Section 7.1 (Common Errors) as a callout-danger series. Compact format: ❌ Pattern name → Why → Correct approach.

### Performance Considerations
- No blocking scripts in `<head>` (only the theme preference inline script is acceptable)
- All JavaScript in `<script>` tags at end of `<body>` or with `defer`
- CSS custom properties used throughout (single switch on `html.dark-mode`)
- No JavaScript required for basic content reading — all content visible without JS
- IntersectionObserver for TOC highlighting (not scroll event polling)

### Browser Support Target
Modern browsers (Chrome 90+, Firefox 88+, Safari 14+, Edge 90+). No IE support required.
Use: CSS custom properties, CSS Grid, Flexbox, IntersectionObserver, `navigator.clipboard`, `<details>/<summary>`.
Fallback for clipboard: `document.execCommand('copy')` (deprecated but widely supported).

---

## Verification Checklist

- [ ] Single file, no external dependencies (no CDN URLs, no `<link rel="stylesheet" href="...">` pointing outside)
- [ ] Works offline (open file:// protocol in browser, all features functional)
- [ ] Mobile responsive (sidebar collapses, tables scroll horizontally, code blocks scroll, font sizes appropriate)
- [ ] Dark mode toggle works (persists across refresh via localStorage)
- [ ] Search filters sections (input → results appear within 200ms, keyboard navigable)
- [ ] All 8 G04 sections covered (Quick Start, Core Concepts, Workflows, Advanced, Tools, Config, Troubleshooting, Reference)
- [ ] All 3 walkthroughs included (W1: F.1 typo fix, W2: F.2 API endpoint x5, W3: F.3 codebase audit x10)
- [ ] All 6 slash commands documented (/caveman, /graphify, /ctx, /review, /security-review, /architect)
- [ ] All 7 xN modes documented (single, x2, x3, x4, x5, x7, x10) with cost and review chain
- [ ] All 12 anti-patterns documented (G.1–G.12)
- [ ] Cheat sheet present and printable (Section 8.1, page-break-inside: avoid)
- [ ] Tier badges render in correct colors (T1 violet, T2 blue, T3 cyan, T4 green, T5 amber)
- [ ] Copy buttons work on all code blocks (clipboard API + fallback)
- [ ] TOC active section highlights as user scrolls (IntersectionObserver)
- [ ] Progress bar updates on scroll
- [ ] Prev/Next navigation links correct for all sections
- [ ] Breadcrumb updates per section
- [ ] Anchor links on all h2/h3/h4 headings
- [ ] WCAG AA color contrast passes for all text/background combinations
- [ ] Skip-to-content link present and functional
- [ ] All ARIA attributes correct (tablist, tabpanel, dialog, live regions)
- [ ] Print stylesheet hides navigation, renders cheat sheet cleanly
- [ ] File size under 150 KB
- [ ] No `console.log` statements in production JS
- [ ] Syntax highlighting works for bash, json, typescript, java, markdown
- [ ] Dark mode syntax highlighting uses appropriate dark palette

---

**Architecture designed by**: Tarik Ziya Yesilcinen (T2 Staff Engineer)  
**Session**: 2026-05-21-deep-analysis-html-docs-x10  
**Task**: G06  
**Output target**: T1-A implementation of `docs/index.html`  
**Status**: Ready for T1-A implementation
