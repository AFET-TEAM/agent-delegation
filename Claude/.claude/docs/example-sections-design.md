# Örnek Section HTML Tasarımı
## T2 Staff Engineer: Tarik Ziya Yesilcinen
## Session: 2026-05-22-html-tr-examples-x10 | Task: H06

Bu belge T3-B için sıfır tasarım kararı bırakmayacak şekilde hazırlanmıştır.
Her HTML şablonu, CSS kuralı ve yerleşim kararı burada açıklanmıştır.

---

## 1. Component Templates (5 Adet)

### Component 1: Single Command Example (`.example-single`)

Tekil özellik örnekleri için. Slash komutları, xN modları, MCP araçları.

```html
<div class="example example-single">
  <div class="example-header">
    <span class="example-icon" aria-hidden="true">⚡</span>
    <span class="example-title">Komut Adı</span>
    <span class="example-tag">Slash Komut</span>
  </div>
  <div class="example-body">
    <div class="example-input">
      <h4>Kullanıcı yazar:</h4>
      <pre><code class="language-bash">Kullanıcı komutu buraya</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Copy code">📋 Copy</button></pre>
    </div>
    <div class="example-output">
      <h4>Sistem yapar:</h4>
      <ol class="example-steps">
        <li>Adım 1</li>
        <li>Adım 2</li>
      </ol>
    </div>
  </div>
  <div class="example-note">
    <strong>Ne zaman kullanılır:</strong> Koşul burada açıklanır.
  </div>
</div>
```

**`example-tag` değerleri (tam liste):**
- `Slash Komut` — /caveman, /ctx, /graphify, /review, /security-review, /architect, /test-gen
- `xN Modu` — x2, x3, x4, x5, x7, x10
- `MCP Aracı` — ctx_execute, ctx_index, ctx_search, vs.
- `Tier` — T1 Principal, T2 Staff Engineer, vs.

---

### Component 2: Combined Usage Example (`.example-combined`) — FEATURED

P0 kombinasyon örnekleri için. Her kombine örnek BU component'ı kullanır — başkasını değil.

```html
<div class="example example-combined" data-combo="caveman-x5" id="combo-caveman-x5">
  <div class="combined-header">
    <div class="combined-badges">
      <span class="badge badge-tool">/caveman</span>
      <span class="combined-plus" aria-hidden="true">+</span>
      <span class="badge badge-tool">x5</span>
    </div>
    <h3 class="combined-title">/caveman + x5 — Hızlı Refactoring</h3>
    <p class="combined-meta">
      <span class="combined-meta-item">⏱ 12-15 dk</span>
      <span class="combined-meta-item">💰 ~$4-6</span>
      <span class="combined-meta-item">🤖 5 Agent</span>
    </p>
  </div>

  <p class="combined-intro">
    Sıkıştırılmış çıktı + tam ekip modu. Orta karmaşıklıktaki refactoring'lerde
    hızlı iterasyon için kullanın.
  </p>

  <div class="combined-example-block">
    <div class="combined-input">
      <h4>Kullanıcı yazar:</h4>
      <pre><code class="language-bash">/caveman
Auth modülünü refactor et, JWT + OAuth 2.0 destek ekle x5</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Copy code">📋 Copy</button></pre>
    </div>
    <div class="combined-response">
      <h4>Orchestrator yanıtı (sıkıştırılmış):</h4>
      <pre><code>Analyzing auth requirements. JWT + OAuth 2.0 integration.

Wave 1: T5 research security standards
Wave 2: T4 consolidates findings
Wave 3: T2 design services, T3 implement endpoints
Wave 4: Reviews

Cost: ~$4-6 | Time: 12-15 min</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Copy code">📋 Copy</button></pre>
    </div>
  </div>

  <div class="combined-walkthrough">
    <h4>Adım adım akış:</h4>
    <div class="step">
      <span class="step-number" aria-label="Step 1">1</span>
      <div class="step-content">
        <strong>PEP soruları (normal modda, sıkıştırılmadan)</strong>
        <p>Mimariye yönelik sorular her zaman tam uzunlukta sorulur.</p>
      </div>
    </div>
    <div class="step">
      <span class="step-number" aria-label="Step 2">2</span>
      <div class="step-content">
        <strong>Wave 1: T5 Araştırma</strong>
        <p>OAuth 2.0 pattern'larını araştırır, JWT entegrasyonunu analiz eder.</p>
      </div>
    </div>
    <div class="step">
      <span class="step-number" aria-label="Step 3">3</span>
      <div class="step-content">
        <strong>Wave 2: T4 Konsolidasyon</strong>
        <p>Bulguları mimari bir özete dönüştürür.</p>
      </div>
    </div>
    <div class="step">
      <span class="step-number" aria-label="Step 4">4</span>
      <div class="step-content">
        <strong>Wave 3: T2 Tasarım + T3 Uygulama (Paralel)</strong>
        <p>T2 servisleri tasarlar, T3 endpoint'leri uygular.</p>
      </div>
    </div>
    <div class="step">
      <span class="step-number" aria-label="Step 5">5</span>
      <div class="step-content">
        <strong>Wave 4: İnceleme Zinciri</strong>
        <p>T3→T2→T1 sıralı inceleme. Yalnızca Orchestrator çıktısı sıkıştırılır.</p>
      </div>
    </div>
  </div>

  <div class="callout callout-tip">
    <span class="callout-icon" aria-hidden="true">💡</span>
    <div class="callout-body">
      <strong class="callout-title">Neden bu kombinasyon?</strong>
      <p>Caveman modu yalnızca Orchestrator'ın proz çıktısını sıkıştırır (%40-65).
      Kod blokları, dosya yolları ve komutlar byte-by-byte korunur.
      x5 tam inceleme zincirini çalıştırır. Birlikte: hız + kalite.</p>
    </div>
  </div>
</div>
```

**`data-combo` değerleri (her kombinasyon için):**
- `caveman-x5`
- `ctx-graphify`
- `graphify-t5-t4`
- `x10-graphify`
- `test-gen-x3`
- `ctx-long-session`

---

### Component 3: Walkthrough (`.walkthrough` — Collapsible `<details>`)

W1 (Section 3.1) tam timeline, W2 (Section 3.3) tam timeline, W3 (Section 4.6) `<details>` içinde.

#### W1 ve W2 için (tam genişletilmiş, `<details>` yok):
```html
<div class="walkthrough walkthrough-beginner" id="w1-caveman-typo">
  <div class="walkthrough-header">
    <div class="walkthrough-meta">
      <span class="walkthrough-level difficulty-tag difficulty-beginner">Başlangıç</span>
      <span class="walkthrough-time">⏱ ~1 dk</span>
      <span class="walkthrough-cost">💰 ~$0</span>
      <span class="walkthrough-agents">🤖 0 Agent</span>
    </div>
    <h3 class="walkthrough-title">W1: /caveman ile Typo Düzeltme</h3>
    <p class="walkthrough-scenario">
      Yeni kullanıcının ilk görevi: basit typo fix, caveman mode ile kısa cevap.
    </p>
  </div>

  <div class="walkthrough-timeline">
    <div class="timeline-step">
      <span class="timeline-time">0:00</span>
      <div class="timeline-content">
        <strong>Kullanıcı yazar:</strong>
        <pre><code>/caveman
Hocam, comment'teki typo'yu düzelt: "usre" → "user"
Dosya: src/features/user/user-service.ts:42</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Copy code">📋 Copy</button></pre>
      </div>
    </div>

    <div class="timeline-step">
      <span class="timeline-time">0:01</span>
      <div class="timeline-content">
        <strong>Orchestrator analizi (&lt;1 sn):</strong>
        <ul>
          <li>Görev: Önemsiz (1 satır, typo)</li>
          <li>xN gerekmiyor</li>
          <li>Caveman modu: AÇIK</li>
        </ul>
      </div>
    </div>

    <div class="timeline-step">
      <span class="timeline-time">0:05</span>
      <div class="timeline-content">
        <strong>Yürütme (anında):</strong>
        <pre><code>Read: src/features/user/user-service.ts:42
Find: // Check usre ID
Replace: // Check user ID
Write: file
No hooks triggered (comment change)</code></pre>
      </div>
    </div>

    <div class="timeline-step">
      <span class="timeline-time">0:10</span>
      <div class="timeline-content">
        <strong>Çıktı (sıkıştırılmış):</strong>
        <pre><code>✅ Fixed typo at src/features/user/user-service.ts:42

Before: // Check usre ID
After:  // Check user ID

Done.</code></pre>
      </div>
    </div>
  </div>

  <div class="walkthrough-insights">
    <h4>Neler öğrendik:</h4>
    <ul>
      <li>Önemsiz görevler için tek-agent modu (xN gerekmez)</li>
      <li>/caveman proz'u sıkıştırır, kodu/yolları değil</li>
      <li>Orchestrator basit düzeltmeleri doğrudan yapar</li>
      <li>1 dakikadan kısa görevlerde session dosyası oluşturulmaz</li>
    </ul>
  </div>
</div>
```

#### W3 için (collapsible — `<details>` içinde):
```html
<details class="walkthrough walkthrough-advanced" id="w3-x10-audit">
  <summary>
    <div class="walkthrough-summary-content">
      <span class="walkthrough-level difficulty-tag difficulty-advanced">İleri Düzey</span>
      <span class="walkthrough-title">W3: x10 + /graphify + /ctx Tam Audit</span>
      <div class="walkthrough-summary-meta">
        <span>⏱ ~25 dk</span>
        <span>💰 ~$14-20</span>
        <span>🤖 10 Agent</span>
      </div>
    </div>
  </summary>
  <div class="walkthrough-body">
    <!-- Tam timeline buraya — W2 yapısıyla aynı -->
    <div class="walkthrough-timeline">
      <!-- timeline-step'ler -->
    </div>
    <div class="walkthrough-insights">
      <!-- neler öğrendik -->
    </div>
  </div>
</details>
```

---

### Component 4: Decision Table (`.decision-table`)

xN seçimi, araç seçimi, yaklaşım karşılaştırması için.

```html
<div class="decision-table-wrapper">
  <table class="decision-table">
    <thead>
      <tr>
        <th>Durum</th>
        <th>Hangi xN?</th>
        <th>Maliyet</th>
        <th>Zaman</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Trivial: 1 satır, 1 dosya</td>
        <td><span class="badge badge-mode badge-mode-single">Single</span></td>
        <td><span class="cost-indicator cost-free">~$0</span></td>
        <td>&lt;1 dk</td>
      </tr>
      <tr>
        <td>Küçük özellik + kıdemli inceleme</td>
        <td><span class="badge badge-mode badge-mode-x3">x3</span></td>
        <td><span class="cost-indicator cost-low">$2-3</span></td>
        <td>8-10 dk</td>
      </tr>
      <tr class="decision-recommended">
        <td>
          <strong>Standart özellik, tam zincir</strong>
          <span class="recommended-badge">⭐ Varsayılan</span>
        </td>
        <td><span class="badge badge-mode badge-mode-x5">x5</span></td>
        <td><span class="cost-indicator cost-medium">$4-6</span></td>
        <td>12-15 dk</td>
      </tr>
      <tr>
        <td>Paralel araştırma + tasarım</td>
        <td><span class="badge badge-mode badge-mode-x7">x7</span></td>
        <td><span class="cost-indicator cost-high">$7-10</span></td>
        <td>15-20 dk</td>
      </tr>
      <tr>
        <td>Kritik sistem denetimi</td>
        <td><span class="badge badge-mode badge-mode-x10">x10</span></td>
        <td><span class="cost-indicator cost-very-high">$12-18</span></td>
        <td>20-30 dk</td>
      </tr>
    </tbody>
  </table>
</div>
```

---

### Component 5: Tool Reference Card (`.tool-card`)

Section 5 (Araçlar Referansı) için. Her ctx_* aracı, her graphify komutu için.

```html
<article class="tool-card" id="tool-ctx-execute">
  <header class="tool-card-header">
    <div class="tool-card-title-row">
      <h4 class="tool-card-name">ctx_execute</h4>
      <span class="tool-tag">context-mode</span>
    </div>
    <p class="tool-card-signature">
      <code>ctx_execute(language, command)</code>
    </p>
  </header>

  <p class="tool-desc">
    Analiz komutlarını bağlamı kirletmeden izole bir alt süreçte çalıştırır.
    Yalnızca sonuç bağlama girer (~10 token vs ~500 raw çıktı).
  </p>

  <div class="tool-example-block">
    <span class="tool-example-label">Örnek:</span>
    <pre class="tool-example"><code class="language-bash">ctx_execute("shell", "find src/ -name '*.ts' | wc -l")</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Copy code">📋 Copy</button></pre>
    <span class="tool-example-label">Çıktı:</span>
    <pre><code>248</code></pre>
  </div>

  <div class="tool-when">
    <strong>Ne zaman kullanılır:</strong>
    <ul>
      <li>20+ dosyalı codebase analizi</li>
      <li>Büyük dizin taramaları</li>
      <li>jq sorguları graph.json üzerinde</li>
    </ul>
  </div>

  <div class="tool-when-not">
    <strong>Kullanma:</strong>
    <ul>
      <li>Tek küçük dosya okumak için (&lt;10KB)</li>
      <li>Hassas path'lere erişim için (.env, ~/.ssh)</li>
    </ul>
  </div>
</article>
```

---

## 2. CSS Additions

Mevcut `index.html`'de `</style>` kapanış etiketinden önce eklenecektir.

```css
/* ===================================================
   EXAMPLE SECTIONS — COMPONENT STYLES
   H06 addition: 2026-05-22
   =================================================== */

/* -- Component 1: Single Example -- */

.example {
  margin: var(--space-8) 0;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  background: var(--color-bg-secondary);
  overflow: hidden;
}

.example-header {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  padding: var(--space-3) var(--space-5);
  background: var(--color-bg-tertiary);
  border-bottom: 1px solid var(--color-border);
}

.example-icon {
  font-size: 1.1rem;
  line-height: 1;
}

.example-title {
  font-weight: 700;
  font-size: 0.95rem;
  color: var(--color-text-primary);
}

.example-tag {
  margin-left: auto;
  background: var(--color-accent-subtle);
  color: var(--color-accent-primary);
  font-size: 0.72rem;
  font-weight: 700;
  padding: 0.125rem 0.5rem;
  border-radius: var(--radius-sm);
  letter-spacing: 0.03em;
  text-transform: uppercase;
}

.example-body {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-4);
  padding: var(--space-4) var(--space-5);
}

@media (max-width: 767px) {
  .example-body {
    grid-template-columns: 1fr;
  }
}

.example-input h4,
.example-output h4 {
  font-size: 0.8rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--color-text-muted);
  margin: 0 0 var(--space-2) 0;
}

.example-steps {
  margin: 0;
  padding-left: var(--space-5);
  color: var(--color-text-secondary);
}

.example-steps li {
  margin: var(--space-2) 0;
  font-size: 0.9rem;
}

.example-note {
  padding: var(--space-3) var(--space-5);
  border-top: 1px solid var(--color-border-subtle);
  font-size: 0.875rem;
  color: var(--color-text-secondary);
  background: var(--color-bg-primary);
}

.example-note strong {
  color: var(--color-text-primary);
}

/* -- Component 2: Combined Usage Example (FEATURED) -- */

.example-combined {
  border: 2px solid var(--color-combined-border);
  border-radius: var(--radius-lg);
  padding: var(--space-6);
  margin: var(--space-10) 0;
  background: var(--color-bg-secondary);
  box-shadow: var(--shadow-md);
  position: relative;
}

.example-combined::before {
  content: "FEATURED COMBO";
  position: absolute;
  top: -1px;
  left: var(--space-6);
  background: var(--color-combined-border);
  color: #fff;
  font-size: 0.65rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  padding: 0.2rem 0.6rem;
  border-radius: 0 0 var(--radius-sm) var(--radius-sm);
}

.combined-header {
  margin-bottom: var(--space-5);
}

.combined-badges {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  margin-bottom: var(--space-3);
  flex-wrap: wrap;
}

.badge {
  display: inline-block;
  padding: 0.2rem 0.6rem;
  border-radius: var(--radius-sm);
  font-size: 0.8rem;
  font-weight: 700;
  letter-spacing: 0.02em;
}

.badge-tool {
  background: var(--color-accent-primary);
  color: #fff;
}

.badge-mode {
  font-family: var(--font-mono);
  font-size: 0.8rem;
}

.badge-mode-single { background: var(--color-text-muted); color: #fff; }
.badge-mode-x3     { background: var(--tier-t5);          color: #fff; }
.badge-mode-x5     { background: var(--color-success);    color: #fff; }
.badge-mode-x7     { background: var(--tier-t2);          color: #fff; }
.badge-mode-x10    { background: var(--tier-t1);          color: #fff; }

.combined-plus {
  font-size: 1.1rem;
  font-weight: 700;
  color: var(--color-text-muted);
}

.combined-title {
  font-size: 1.3rem;
  font-weight: 700;
  color: var(--color-text-primary);
  margin: 0 0 var(--space-2) 0;
}

.combined-meta {
  display: flex;
  gap: var(--space-4);
  flex-wrap: wrap;
  font-size: 0.85rem;
  color: var(--color-text-muted);
  margin: 0;
}

.combined-meta-item {
  display: inline-flex;
  align-items: center;
  gap: var(--space-1);
}

.combined-intro {
  font-size: 0.95rem;
  color: var(--color-text-secondary);
  line-height: 1.6;
  margin-bottom: var(--space-5);
  border-left: 3px solid var(--color-combined-border);
  padding-left: var(--space-4);
}

.combined-example-block {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-4);
  margin: var(--space-5) 0;
}

@media (max-width: 767px) {
  .combined-example-block {
    grid-template-columns: 1fr;
  }
}

.combined-input h4,
.combined-response h4 {
  font-size: 0.8rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--color-text-muted);
  margin: 0 0 var(--space-2) 0;
}

.combined-walkthrough {
  margin: var(--space-5) 0;
}

.combined-walkthrough h4 {
  font-size: 0.9rem;
  font-weight: 700;
  color: var(--color-text-primary);
  margin: 0 0 var(--space-3) 0;
}

.step {
  display: grid;
  grid-template-columns: 2rem 1fr;
  gap: var(--space-3);
  padding: var(--space-3) 0;
  border-bottom: 1px solid var(--color-border-subtle);
}

.step:last-child {
  border-bottom: none;
}

.step-number {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 2rem;
  height: 2rem;
  background: var(--color-combined-border);
  color: #fff;
  border-radius: 50%;
  font-size: 0.85rem;
  font-weight: 700;
  flex-shrink: 0;
  margin-top: 0.1rem;
}

.step-content {
  font-size: 0.9rem;
  color: var(--color-text-secondary);
}

.step-content strong {
  display: block;
  color: var(--color-text-primary);
  margin-bottom: var(--space-1);
}

.step-content p {
  margin: 0;
  font-size: 0.875rem;
}

/* callout-tip: Combined example explanation */
.callout-tip {
  background: var(--color-callout-tip-bg);
  border-left: 4px solid var(--color-combined-border);
}

/* -- Component 3: Walkthrough -- */

.walkthrough {
  margin: var(--space-8) 0;
}

/* Non-collapsible walkthrough header */
.walkthrough-header {
  margin-bottom: var(--space-5);
}

.walkthrough-meta {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  flex-wrap: wrap;
  margin-bottom: var(--space-3);
  font-size: 0.85rem;
  color: var(--color-text-muted);
}

.walkthrough-title {
  font-size: 1.3rem;
  font-weight: 700;
  color: var(--color-text-primary);
  margin: 0 0 var(--space-2) 0;
}

.walkthrough-scenario {
  color: var(--color-text-secondary);
  font-size: 0.9rem;
  margin: 0;
}

/* Collapsible walkthrough (W3): custom summary layout */
details.walkthrough {
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  background: var(--color-bg-secondary);
}

details.walkthrough > summary {
  padding: var(--space-4) var(--space-5);
}

.walkthrough-summary-content {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  flex-wrap: wrap;
}

.walkthrough-summary-meta {
  display: flex;
  gap: var(--space-3);
  margin-left: auto;
  font-size: 0.82rem;
  color: var(--color-text-muted);
}

.walkthrough-body {
  padding: 0 var(--space-5) var(--space-5);
}

/* Timeline */
.walkthrough-timeline {
  display: flex;
  flex-direction: column;
  gap: 0;
  margin: var(--space-4) 0;
  position: relative;
}

.walkthrough-timeline::before {
  content: "";
  position: absolute;
  left: 3.5rem;
  top: 0;
  bottom: 0;
  width: 2px;
  background: var(--color-border);
}

.timeline-step {
  display: grid;
  grid-template-columns: 7rem 1fr;
  gap: var(--space-4);
  padding: var(--space-4) 0;
  position: relative;
}

.timeline-time {
  font-family: var(--font-mono);
  font-size: 0.8rem;
  color: var(--color-text-muted);
  font-weight: 600;
  text-align: right;
  padding-right: var(--space-4);
  padding-top: 0.1rem;
  position: relative;
  z-index: 1;
}

.timeline-time::after {
  content: "";
  position: absolute;
  right: calc(var(--space-2) - 5px);
  top: 0.35rem;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: var(--color-accent-primary);
  border: 2px solid var(--color-bg-primary);
}

.timeline-content {
  font-size: 0.9rem;
  color: var(--color-text-secondary);
}

.timeline-content strong {
  display: block;
  color: var(--color-text-primary);
  margin-bottom: var(--space-2);
}

.walkthrough-insights {
  background: var(--color-bg-tertiary);
  border-radius: var(--radius-md);
  padding: var(--space-4) var(--space-5);
  margin-top: var(--space-5);
}

.walkthrough-insights h4 {
  font-size: 0.9rem;
  font-weight: 700;
  color: var(--color-text-primary);
  margin: 0 0 var(--space-2) 0;
}

.walkthrough-insights ul {
  margin: 0;
  padding-left: var(--space-5);
}

.walkthrough-insights li {
  font-size: 0.875rem;
  color: var(--color-text-secondary);
  margin: var(--space-1) 0;
}

/* -- Component 4: Decision Table -- */

.decision-table-wrapper {
  margin: var(--space-5) 0;
  overflow-x: auto;
  border-radius: var(--radius-lg);
  border: 1px solid var(--color-border);
}

.decision-table {
  margin: 0;
  border-radius: 0;
}

.decision-table th {
  background: var(--color-bg-tertiary);
  font-size: 0.85rem;
}

.decision-table td {
  font-size: 0.875rem;
  vertical-align: middle;
}

.decision-recommended {
  background: var(--color-accent-subtle);
}

.decision-recommended td {
  color: var(--color-text-primary);
  font-weight: 500;
}

.recommended-badge {
  display: inline-block;
  margin-left: var(--space-2);
  font-size: 0.72rem;
  background: var(--color-success);
  color: #fff;
  padding: 0.1rem 0.4rem;
  border-radius: var(--radius-sm);
  font-weight: 700;
  vertical-align: middle;
}

.cost-indicator {
  display: inline-block;
  padding: 0.125rem 0.5rem;
  border-radius: var(--radius-sm);
  font-size: 0.8rem;
  font-weight: 600;
  font-family: var(--font-mono);
}

.cost-free      { background: #d1fae5; color: #065f46; }
.cost-low       { background: #d1fae5; color: #065f46; }
.cost-medium    { background: #fef3c7; color: #92400e; }
.cost-high      { background: #fee2e2; color: #991b1b; }
.cost-very-high { background: #fce7f3; color: #9d174d; }

.dark-mode .cost-free      { background: #064e3b; color: #6ee7b7; }
.dark-mode .cost-low       { background: #064e3b; color: #6ee7b7; }
.dark-mode .cost-medium    { background: #78350f; color: #fcd34d; }
.dark-mode .cost-high      { background: #7f1d1d; color: #fca5a5; }
.dark-mode .cost-very-high { background: #831843; color: #f9a8d4; }

/* -- Component 5: Tool Card -- */

.tool-card {
  background: var(--color-bg-secondary);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-5);
  margin: var(--space-5) 0;
  transition: border-color 150ms ease;
}

.tool-card:hover {
  border-color: var(--color-accent-primary);
}

.tool-card-header {
  margin-bottom: var(--space-3);
}

.tool-card-title-row {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  margin-bottom: var(--space-2);
}

.tool-card-name {
  font-size: 1.1rem;
  font-weight: 700;
  color: var(--color-accent-primary);
  font-family: var(--font-mono);
  margin: 0;
}

.tool-tag {
  font-size: 0.72rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  background: var(--color-bg-tertiary);
  color: var(--color-text-muted);
  padding: 0.125rem 0.5rem;
  border-radius: var(--radius-sm);
}

.tool-card-signature {
  margin: 0;
  font-size: 0.875rem;
}

.tool-card-signature code {
  font-size: 0.85rem;
}

.tool-desc {
  font-size: 0.9rem;
  color: var(--color-text-secondary);
  margin: var(--space-3) 0;
  line-height: 1.6;
}

.tool-example-block {
  background: var(--color-bg-code);
  border: 1px solid var(--color-border-subtle);
  border-radius: var(--radius-md);
  padding: var(--space-3) var(--space-4);
  margin: var(--space-3) 0;
}

.tool-example-label {
  display: block;
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--color-text-muted);
  margin-bottom: var(--space-1);
}

.tool-example-block pre {
  margin: 0 0 var(--space-2) 0;
  background: transparent;
  border: none;
  padding: 0;
}

.tool-example-block pre:last-child {
  margin-bottom: 0;
}

.tool-when,
.tool-when-not {
  font-size: 0.875rem;
  margin: var(--space-3) 0 0 0;
}

.tool-when strong,
.tool-when-not strong {
  display: block;
  color: var(--color-text-primary);
  margin-bottom: var(--space-1);
}

.tool-when ul,
.tool-when-not ul {
  margin: 0;
  padding-left: var(--space-5);
  color: var(--color-text-secondary);
}

.tool-when-not {
  color: var(--color-text-muted);
}

/* -- Wave Breakdown (Combined examples) -- */

.wave-breakdown {
  margin: var(--space-5) 0;
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
}

.wave-breakdown h4 {
  font-size: 0.9rem;
  font-weight: 700;
  color: var(--color-text-primary);
  margin: 0 0 var(--space-2) 0;
}

.wave-item {
  background: var(--color-bg-primary);
  border: 1px solid var(--color-border-subtle);
  border-radius: var(--radius-md);
  padding: var(--space-3) var(--space-4);
}

.wave-label {
  display: inline-block;
  font-size: 0.75rem;
  font-weight: 700;
  padding: 0.1rem 0.5rem;
  border-radius: var(--radius-sm);
  margin-right: var(--space-2);
  color: #fff;
}

.wave-1 { background: var(--color-wave-1); }
.wave-2 { background: var(--color-wave-2); }
.wave-3 { background: var(--color-wave-3); }
.wave-4 { background: var(--color-wave-4); }

.wave-content {
  font-size: 0.875rem;
  color: var(--color-text-secondary);
  display: inline;
}

/* -- Comparison table wrapper for combined examples -- */
.comparison-table-wrapper {
  margin: var(--space-4) 0;
  overflow-x: auto;
  border-radius: var(--radius-md);
  border: 1px solid var(--color-border-subtle);
}

.comparison-table-wrapper table {
  margin: 0;
  font-size: 0.875rem;
}

.comparison-table-wrapper th {
  font-size: 0.8rem;
  padding: var(--space-2) var(--space-3);
}

.comparison-table-wrapper td {
  padding: var(--space-2) var(--space-3);
}
```

---

## 3. CSS Variables to Add

`index.html`'deki `:root {}` bloğuna eklenecektir.

```css
/* Combined example accent */
--color-combined-border: #5b4cdb;

/* Callout tip */
--color-callout-tip-bg: #f0edff;

/* Walkthrough background */
--color-walkthrough-bg: #f9fafb;

/* Wave colors */
--color-wave-1: #ef4444;
--color-wave-2: #10b981;
--color-wave-3: #f59e0b;
--color-wave-4: #6366f1;

/* Spacing */
--space-example: 2rem;
```

**Dark mode override (`.dark-mode {}` bloğuna):**
```css
--color-callout-tip-bg: #1e1b4b;
--color-walkthrough-bg: #1e293b;
--color-combined-border: #818cf8;
```

---

## 4. Combined Examples Placement (6 P0)

### #1: /caveman + x5 (Section 3.5)

**Mevcut anchor:** `#workflow-caveman`
**Yerleşim:** Section 3.5 (`<h3 id="workflow-caveman">3.5 Using /caveman</h3>`) sonrasında, mevcut anlatı paragrafları ve tablo korunarak, alt kısma eklenir.

**h3/h4 hiyerarşisi:**
```
<h3 id="workflow-caveman">3.5 Using /caveman</h3>
  [mevcut içerik korunur: anlatı, tablo, callout]
  
  <h4 id="combo-caveman-x5-heading">Örnek: /caveman + x5 Kombinasyonu</h4>
  <div class="example example-combined" data-combo="caveman-x5" id="combo-caveman-x5">
    [Component 2 tam yapısı]
  </div>
```

**Component kullanımı:** Component 2 (Combined) — zorunlu.

**T3-B'nin dolduracağı içerik:**
- `combined-intro`: "Sıkıştırılmış çıktı + tam ekip modu. Orta karmaşıklıktaki refactoring'lerde hızlı iterasyon için kullanın."
- Kullanıcı komutu kodu bloğu (H04'ten)
- Orchestrator cevabı kodu bloğu (H04'ten)
- 5 adımlı walkthrough (PEP → Wave1 → Wave2 → Wave3 → Review)
- callout-tip: "Neden bu kombinasyon?" açıklaması

---

### #2: /ctx + /graphify (Section 3.8)

**Mevcut anchor:** `#workflow-combined`
**Yerleşim:** Section 3.8 (`<h3 id="workflow-combined">3.8 Combining Tools</h3>`) içinde, mevcut kod bloğundan SONRA, yeni alt bölüm olarak eklenir.

**h3/h4 hiyerarşisi:**
```
<h3 id="workflow-combined">3.8 Combining Tools</h3>
  [mevcut içerik korunur: anlatı, kod bloğu, token tasarrufu notu]
  
  <h4 id="combo-ctx-graphify-heading">Detaylı Örnek: /ctx + /graphify Kombinasyonu</h4>
  <div class="example example-combined" data-combo="ctx-graphify" id="combo-ctx-graphify">
    [Component 2 tam yapısı]
  </div>
```

**Component kullanımı:** Component 2 (Combined) + Component 4 (Decision Table) iç karşılaştırma tablosu için.

**T3-B'nin dolduracağı içerik:**
- 3 adımlı iş akışı (H04'ten: Build graph → Index findings → Reuse next session)
- Her adım için kod bloğu (copy butonlu)
- Comparison table: "Raw file reading vs Graphify + ctx_index" (H04'ten)
- callout-tip: Maliyet tasarrufu açıklaması (500 token → 100 token/sorgu)

---

### #3: graphify + T5 + T4 (Section 4 — yeni 4.8)

**Mevcut:** Section 4.7 en son (`#agent-selection`).
**Yerleşim:** Section 4'ün sonunda, `prev-next-nav`'dan hemen ÖNCE eklenir. Yeni h3 başlığı.

**h3/h4 hiyerarşisi:**
```
<h3 id="combo-graphify-t5-t4">4.8 graphify + T5 + T4 — Mimari Analiz</h3>
<div class="example example-combined" data-combo="graphify-t5-t4" id="combo-graphify-t5-t4">
  [Component 2 tam yapısı]
</div>
```

**Sidebar'a eklenmesi (T3-B zorunlu):**
```html
<li><a href="#combo-graphify-t5-t4" class="nav-sublink">4.8 graphify + T5 + T4</a></li>
```

**Component kullanımı:** Component 2 (Combined) + Component 4 (Findings Table, H04'ten renk kodlu).

**T3-B'nin dolduracağı içerik:**
- Senaryo: 60 dosyalı codebase, UserService too large
- Kullanıcı komutu: "Codebase'deki god classes'ı tespit et ve refactoring planı oluştur x5"
- Wave 1 (T5) kod bloğu + Wave 2 (T4) çıktı
- Findings table: UserService (degree 42, 🔴), DatabaseRepository (degree 28, 🟠), AuthController (degree 22, 🟡)
- callout-tip: "Pro Tip: Graph is rebuilt only on first run"

---

### #4: x10 + /graphify (Section 4 — yeni 4.9)

**Yerleşim:** #3'ten SONRA, `prev-next-nav`'dan önce. Yeni h3 başlığı.

**h3/h4 hiyerarşisi:**
```
<h3 id="combo-x10-graphify">4.9 x10 + /graphify — Tam Sistem Denetimi</h3>
<div class="example example-combined" data-combo="x10-graphify" id="combo-x10-graphify">
  [Component 2 tam yapısı]
</div>
```

**Sidebar'a eklenmesi:**
```html
<li><a href="#combo-x10-graphify" class="nav-sublink">4.9 x10 + /graphify</a></li>
```

**Component kullanımı:** Component 2 (Combined) + wave-breakdown div (4 wave, renk kodlu) + metrics table.

**T3-B'nin dolduracağı içerik:**
- Wave structure: 2×T5 parallel, 2×T4 parallel, 2×T2+2×T3 parallel, review chain
- Her wave için `.wave-item` div'leri (`.wave-1` rengi #ef4444, `.wave-2` #10b981, `.wave-3` #f59e0b, `.wave-4` #6366f1)
- Metrics before/after table (H04'ten: degree 42→12, coverage 68%→92%, findings 5→0)
- callout-warning: Maliyet ve süre ($14-20, 20-30 dk)

---

### #5: /test-gen + x3 (Section 3 — yeni 3.9)

**Mevcut:** Section 3.8 en son (`#workflow-combined`).
**Yerleşim:** Section 3'ün sonunda, `prev-next-nav`'dan önce.

**h3/h4 hiyerarşisi:**
```
<h3 id="combo-test-gen-x3">3.9 /test-gen + x3 — Test Üretimi + İnceleme</h3>
<div class="example example-combined" data-combo="test-gen-x3" id="combo-test-gen-x3">
  [Component 2 tam yapısı]
</div>
```

**Sidebar'a eklenmesi:**
```html
<li><a href="#combo-test-gen-x3" class="nav-sublink">3.9 /test-gen + x3</a></li>
```

**Component kullanımı:** Component 2 (Combined).

**T3-B'nin dolduracağı içerik:**
- Kullanıcı komutu: `/test-gen src/features/auth/auth-service.ts x3`
- Wave 1 (T5) araştırma çıktısı (AAA, happy+error+edge)
- Wave 2 review çıktısı (T2 ✅ approved)
- Wave 3 (T1 final) çıktısı
- Üretilen test örneği (H04'teki `describe('AuthService'...` kodu)
- callout-success: Sonuç notu

---

### #6: /ctx + Long-Running Session (Section 4 — yeni 4.10)

**Yerleşim:** #4 (4.9)'den SONRA, `prev-next-nav`'dan önce.

**h3/h4 hiyerarşisi:**
```
<h3 id="combo-ctx-long-session">4.10 /ctx + Uzun Session — Bilgi Kalıcılığı</h3>
<div class="example example-combined" data-combo="ctx-long-session" id="combo-ctx-long-session">
  [Component 2 tam yapısı]
</div>
```

**Sidebar'a eklenmesi:**
```html
<li><a href="#combo-ctx-long-session" class="nav-sublink">4.10 /ctx + Uzun Session</a></li>
```

**Component kullanımı:** Component 2 (Combined).

**T3-B'nin dolduracağı içerik:**
- Senaryo: Çok günlük migrasyon projesi, context dolup taştı
- Session 1 kodu (ctx_index çağrıları)
- Session 2 kodu (ctx_search ile geri alma)
- callout-tip: 3 maddelik protokol
- callout-info: Token tasarrufu özeti (Session 1: 100 token → Session 2: 10 token vs 5000 token)

---

## 5. JavaScript Additions

Aşağıdaki JS mevcut script bloğuna eklenir.

### 5.1 Walkthrough Auto-Expand on Anchor Click

```javascript
// Auto-expand <details> elements when navigated to via anchor
function expandDetailsOnAnchor() {
  const hash = window.location.hash;
  if (!hash) return;
  const target = document.querySelector(hash);
  if (!target) return;
  
  // Walk up to find a details parent
  let el = target;
  while (el && el !== document.body) {
    if (el.tagName === 'DETAILS') {
      el.open = true;
    }
    el = el.parentElement;
  }
}

window.addEventListener('hashchange', expandDetailsOnAnchor);
window.addEventListener('DOMContentLoaded', expandDetailsOnAnchor);
```

### 5.2 Combined Example Hover Highlight

```javascript
// Soft highlight on combined examples when hovered
document.addEventListener('DOMContentLoaded', function() {
  const combinedExamples = document.querySelectorAll('.example-combined');
  combinedExamples.forEach(function(el) {
    el.addEventListener('mouseenter', function() {
      el.style.setProperty('--combined-shadow', '0 0 0 3px rgba(91, 76, 219, 0.12)');
      el.style.boxShadow = 'var(--shadow-md), var(--combined-shadow)';
    });
    el.addEventListener('mouseleave', function() {
      el.style.boxShadow = 'var(--shadow-md)';
    });
  });
});
```

### 5.3 Sidebar Update for New Anchors

Sidebar nav-sublist'lerine yeni anchor'lar eklenir (T3-B ayrıca bunu yapar):

Section 3 nav-sublist'e:
```html
<li><a href="#combo-test-gen-x3" class="nav-sublink">3.9 /test-gen + x3</a></li>
```

Section 4 nav-sublist'e:
```html
<li><a href="#combo-graphify-t5-t4" class="nav-sublink">4.8 graphify + T5 + T4</a></li>
<li><a href="#combo-x10-graphify"   class="nav-sublink">4.9 x10 + /graphify</a></li>
<li><a href="#combo-ctx-long-session" class="nav-sublink">4.10 /ctx + Uzun Session</a></li>
```

---

## 6. T3-B Implementation Notes

1. **Templates verbatim kullan** — yeni HTML yapısı icat etme. 5 component dışında sınıf ekleme.
2. **Combined examples ZORUNLU olarak Component 2 kullanır** (`example-combined` sınıfı). Component 1 değil.
3. **Walkthroughs ZORUNLU olarak Component 3 kullanır** — W1/W2 için `div.walkthrough`, W3 için `details.walkthrough`.
4. **Tool referansları ZORUNLU olarak Component 5 kullanır** (`tool-card` article).
5. **Decision tables ZORUNLU olarak Component 4 stilini kullanır** (`decision-table`, `.decision-recommended`).
6. **Copy buttonları mevcut JS mekanizmasını kullanır** — existing `copyToClipboard()` fonksiyonu. Her `<pre>` içinde bir `<button class="copy-btn">` bulunmalıdır.
7. **Tüm yeni CSS variables `:root {}` bloğuna eklenir** — dark-mode override'lar `.dark-mode {}` bloğuna.
8. **Sidebar nav-sublist** güncellemesi Section 3 ve Section 4 için yapılmalıdır (yeni h3 başlıkları eklendikçe).
9. **Yerleşim sırası** (`prev-next-nav`'a göre): her section'da önce mevcut içerik, sonra yeni combined example, en son `prev-next-nav`.
10. **`data-combo` attribute'u** doğru değerle doldurulmalıdır: `caveman-x5`, `ctx-graphify`, `graphify-t5-t4`, `x10-graphify`, `test-gen-x3`, `ctx-long-session`.
11. **`id` attribute'ları** anchor navigasyonu için zorunludur. Her component'ın tam id değeri yukarıda belirtilmiştir.

---

## 7. Verification Checklist (T3-B İçin)

HTML eklendikten sonra şunları doğrula:

- [ ] 6 combined example var, hepsi `example-combined` sınıfını kullanıyor
- [ ] Her combined example'da `data-combo` attribute doğru değerle dolu
- [ ] W1 ve W2 `div.walkthrough` (non-collapsible), W3 `details.walkthrough` (collapsible)
- [ ] Section 3 ve Section 4 sidebar nav-sublist'lerine yeni anchor'lar eklendi
- [ ] CSS variables (7 adet) `:root {}` bloğuna eklendi
- [ ] Dark-mode override'lar (3 adet) `.dark-mode {}` bloğuna eklendi
- [ ] Tüm `<pre>` bloklarında `<button class="copy-btn">` mevcut
- [ ] JavaScript: `expandDetailsOnAnchor` ve hover highlight fonksiyonları eklendi
- [ ] Hiçbir combined example Component 1 (`example-single`) kullanmıyor
- [ ] `decision-recommended` class'ı x5 satırında uygulandı
- [ ] Wave breakdown div'lerinde `wave-1`, `wave-2`, `wave-3`, `wave-4` renk sınıfları doğru uygulandı
- [ ] Section 4 yeni h3 başlıkları: 4.8, 4.9, 4.10 (mevcut 4.7'den sonra)
- [ ] Section 3 yeni h3 başlığı: 3.9 (mevcut 3.8'den sonra)
- [ ] Tüm `id` attribute'ları belgedeki tanımlanan değerlerle eşleşiyor
- [ ] `callout callout-tip` sınıfı — combined example açıklama callout'ları için
- [ ] Mevcut `callout callout-info/warning/success/danger` sınıfları bozulmadı

---

*T3-B bu belgeye dayanarak sıfır mimari karar alarak implementasyonu tamamlamalıdır.*
*Herhangi bir belirsizlik durumunda bu belgedeki örnek HTML'i verbatim kullan.*
