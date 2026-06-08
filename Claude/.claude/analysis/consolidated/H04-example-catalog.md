---
task-id: H04
agent: Ayse Demir
tier: T4
source: H02-feature-example-catalog.md (2123 lines, 32 features, 12 combined, 3 walkthroughs)
status: Complete
date: 2026-05-22
---

# Örnek Katalog Konsolidasyonu — HTML İçin

## Executive Summary

H02's 2123-line catalog contains 52 individual feature examples, 12 combined-use examples, and 3 walkthroughs. Consolidation prioritizes core features (P0), groups examples by HTML section, designs compact HTML components for each example type, and selects top 6 combined examples for prominent features. This document is the specification for T2-B's HTML implementation.

---

## Priority Matrix

Prioritization criteria:
- **P0 (Must Show):** Core features every user needs (slash commands, xN modes, basics)
- **P1 (Should Show):** Valuable but less common (advanced hooks, edge case patterns)
- **P2 (Defer to FAQ/Glossary):** Specialized cases (ctx_upgrade, ctx_purge, deep-mode graphify)

| Example ID | Type | Description | Priority | Section | Reasoning |
|---|---|---|---|---|---|
| A.1.1 | Slash | /caveman — Kısa cevap modu | P0 | 2. Temel Kavramlar | Entry-level; every user should know |
| A.1.2 | Slash | /ctx — Context-mode tools | P0 | 4. İleri Düzey | Enables large codebases; ~80% of use cases |
| A.1.3 | Slash | /graphify — Codebase graph | P0 | 4. İleri Düzey | Architectural analysis; god class detection |
| A.1.4 | Slash | /review — Code review checklist | P0 | 3. Yaygın İş Akışları | Quality gate; standard workflow |
| A.1.5 | Slash | /security-review — Security audit | P1 | 4. İleri Düzey | Specialized; backend-focused |
| A.1.6 | Slash | /architect — T1 direct routing | P1 | 4. İleri Düzey | Advanced decision-making; less frequent |
| A.1.7 | Slash | /test-gen — Test generation | P1 | 5. Araçlar Referansı | Automation; moderate use |
| A.2.1 | xN Mode | No xN (single-agent) | P0 | 1. Hızlı Başlangıç | Default mode; trivial tasks |
| A.2.2 | xN Mode | x2 (Principal + Analyst) | P1 | 2. Temel Kavramlar | Research decisions; less common |
| A.2.3 | xN Mode | x3 (small feature + review) | P0 | 2. Temel Kavramlar | First multi-agent; entry point |
| A.2.4 | xN Mode | x4 (single module, standard dev) | P1 | 3. Yaygın İş Akışları | Mid-sized feature |
| A.2.5 | xN Mode | x5 (full team, default choice) | P0 | 2. Temel Kavramlar | **Best default**; every dev should learn |
| A.2.6 | xN Mode | x7 (parallel research) | P1 | 4. İleri Düzey | Performance optimization; specialized |
| A.2.7 | xN Mode | x10 (full power, critical overhaul) | P0 | 4. İleri Düzey | System-wide refactoring; when needed |
| A.3.1 | Tier | T1 Principal (opus) | P1 | 5. Araçlar Referansı | Reference; not required to invoke directly |
| A.3.2 | Tier | T2 Staff Engineer (sonnet) | P1 | 5. Araçlar Referansı | Reference |
| A.3.3 | Tier | T3 MidCoder (sonnet) | P1 | 5. Araçlar Referansı | Reference |
| A.3.4 | Tier | T4 Lead Analyst (haiku) | P2 | FAQ | Auto-spawned; user doesn't invoke |
| A.3.5 | Tier | T5 Analyst (haiku) | P2 | FAQ | Auto-spawned; user doesn't invoke |
| A.4.1 | Hook | PreToolUse:Edit/Write | P2 | 6. Yapılandırma | System-level; advanced |
| A.4.2 | Hook | PreToolUse:Bash | P2 | 6. Yapılandırma | System-level; advanced |
| A.4.3 | Hook | PostToolUse:Edit/Write | P2 | 6. Yapılandırma | System-level; advanced |
| A.4.4 | Hook | SessionEnd | P2 | 6. Yapılandırma | System-level; advanced |
| A.5.1 | MCP Tool | ctx_execute | P0 | 4. İleri Düzey | Core context-mode tool |
| A.5.2 | MCP Tool | ctx_execute_file | P0 | 4. İleri Düzey | Core context-mode tool |
| A.5.3 | MCP Tool | ctx_batch_execute | P1 | 5. Araçlar Referansı | Optimization; moderate use |
| A.5.4 | MCP Tool | ctx_index | P0 | 4. İleri Düzey | Cross-session knowledge |
| A.5.5 | MCP Tool | ctx_search | P0 | 4. İleri Düzey | Core context-mode tool |
| A.5.6 | MCP Tool | ctx_fetch_and_index | P1 | 5. Araçlar Referansı | Web integration; less common |
| A.5.7 | MCP Tool | ctx_stats | P2 | FAQ | Diagnostic; rare use |
| A.5.8 | MCP Tool | ctx_doctor | P2 | FAQ | Diagnostic; rare use |
| A.5.9 | MCP Tool | ctx_upgrade | P2 | FAQ | System maintenance; deferred |
| A.5.10 | MCP Tool | ctx_purge | P2 | FAQ | Destructive; deferred |
| A.5.11 | MCP Tool | ctx_insight | P1 | 5. Araçlar Referansı | AI recommendation; useful |
| A.6.1 | Graphify | Basic graph build | P0 | 4. İleri Düzey | Foundation; must show |
| A.6.2 | Graphify | Query god_nodes | P0 | 4. İleri Düzey | Core use case |
| A.6.3 | Graphify | Deep mode (docs + images) | P1 | 5. Araçlar Referansı | Advanced; less common |
| A.6.4 | Graphify | Watch mode (auto-rebuild) | P1 | 5. Araçlar Referansı | DevEx; optional |
| A.6.5 | Graphify | jq queries (graph.json) | P1 | 5. Araçlar Referansı | Advanced analysis |

**Summary:**
- P0 Examples: 19 (core features, every user must learn)
- P1 Examples: 18 (valuable but less common)
- P2 Examples: 15 (specialized/deferred to FAQ/glossary)

---

## Section Mapping (HTML Insertion Points)

| HTML Section | Description | P0 Examples | P1 Examples | Combined Examples | Notes |
|---|---|---|---|---|---|
| **1. Hızlı Başlangıç** | First-time user, 5-min onboarding | A.2.1 (no xN) | — | W1 (caveman + typo fix) | Simplest walkthrough; builds confidence |
| **2. Temel Kavramlar** | Foundations: slash commands, x3/x5 explained | A.1.1, A.2.3, A.2.5 | A.2.2 | B.4 (/caveman + /architect) | Core mental model; must master |
| **3. Yaygın İş Akışları** | Common development tasks (8 workflows) | A.1.4 | A.2.4 | B.1, B.8, B.10 (/caveman+x5, /review+caveman, /test-gen+x3) | Step-by-step; real scenarios |
| **4. İleri Düzey** | Advanced: x10, /graphify, /ctx, escalation | A.1.2, A.1.3, A.2.7, A.6.1, A.6.2, A.5.1, A.5.2, A.5.4, A.5.5 | A.1.5, A.1.6, A.6.3, A.6.4, A.6.5 | B.3, B.5, B.6 (graphify+T5+T4, x10+/graphify, /ctx+long session) | Deep dives; for experienced users |
| **5. Araçlar Referansı** | Tool by tool reference (ctx_*, graphify, hooks) | A.1.7, A.5.11 | A.3.1–3.5, A.5.3, A.5.6, A.6.3–6.5 | — | Alphabetical; lookup table |
| **6. Yapılandırma** | Hook system, custom rules | — | — | B.12 (/architect + custom hook) | Show by example |
| **7. Sorun Giderme** | Common errors, recovery patterns | — | — | — | Error recovery examples (separate doc) |
| **8. Referans** | Cheat sheet, quick lookup | — | — | — | Tables, decision trees |

---

## Top 6 Combined Examples (Prominently Featured)

These 6 combinations represent the most valuable multi-feature workflows. Each gets dedicated HTML treatment with step-by-step breakdown and "When to use" guidance.

### Combined Example #1: /caveman + x5 (Section 3.1)

**What it combines:** Short responses + full team multi-agent mode

**HTML Structure:**
```
<section class="combined-example">
  <h3 id="caveman-x5">/caveman + x5 — Hızlı Refactoring</h3>
  
  <p class="intro">
    Use when: You need fast, compressed output during a medium-complexity refactoring (e.g., adding OAuth 2.0 to JWT auth).
  </p>
  
  <div class="example-block">
    <div class="code-input">
      <h4>Your Command</h4>
      <pre><code>/caveman
Auth modülünü refactor et, JWT + OAuth 2.0 destek ekle x5</code></pre>
    </div>
    
    <div class="code-output">
      <h4>System Response (Compressed)</h4>
      <pre><code>Analyzing auth requirements. JWT + OAuth 2.0 integration.

Wave 1: T5 research security standards
Wave 2: T4 consolidates findings
Wave 3: T2 design services, T3 implement endpoints
Wave 4: Reviews

Cost: ~$4-6 | Time: 12-15 min</code></pre>
    </div>
  </div>
  
  <div class="callout-info">
    <strong>Key Points:</strong>
    <ul>
      <li>Caveman mode compresses prose only (~40-65%)</li>
      <li>Code, file paths, commands stay verbatim</li>
      <li>x5 uses full review chain (T5→T4→T3→T2→T1)</li>
      <li>Best default for typical features</li>
    </ul>
  </div>
  
  <details>
    <summary>Detailed Flow (Click to expand)</summary>
    <ol>
      <li>PEP questions asked (normal mode, uncompressed)</li>
      <li>Wave 1: T5 researches OAuth 2.0 patterns</li>
      <li>Wave 2: T4 consolidates into architecture brief</li>
      <li>Wave 3: T2 designs services, T3 implements</li>
      <li>Wave 4: Code review (T3→T2→T1)</li>
      <li>Compressed Orchestrator output only</li>
    </ol>
  </details>
</section>
```

**Section Placement:** 3.1 (Yaygın İş Akışları)

---

### Combined Example #2: /ctx + /graphify (Section 4.2)

**What it combines:** Context-mode knowledge persistence + codebase graph

**HTML Structure:**
```
<section class="combined-example">
  <h3 id="ctx-graphify">/ctx + /graphify — Persistent Knowledge Graph</h3>
  
  <p class="intro">
    Use when: You have a large codebase (50+ files) and want architectural findings to persist across sessions.
  </p>
  
  <div class="step-by-step">
    <h4>Workflow:</h4>
    <ol>
      <li>
        <strong>Step 1: Build graph</strong>
        <pre><code>/graphify . --local-only</code></pre>
        Generates: graph.json, GRAPH_REPORT.md, graph.html
      </li>
      <li>
        <strong>Step 2: Index findings</strong>
        <pre><code>/ctx
ctx_index("codebase-topology-2026-05-22", graphify_report_content, "prose")</code></pre>
        Stores in cross-session knowledge base
      </li>
      <li>
        <strong>Step 3: Reuse next session</strong>
        <pre><code>/ctx
ctx_search("UserService god node dependencies")</code></pre>
        Returns findings without re-reading 50 files (~200 tokens vs ~5KB context)
      </li>
    </ol>
  </div>
  
  <div class="callout-success">
    <strong>Benefit:</strong> First session costs ~500 tokens to build graph. Every future query on same codebase costs ~100 tokens. Pays for itself after 5 queries.
  </div>
  
  <table class="comparison">
    <tr>
      <th>Approach</th>
      <th>First Session</th>
      <th>Future Sessions</th>
      <th>Best For</th>
    </tr>
    <tr>
      <td>Raw file reading</td>
      <td>~5KB context</td>
      <td>~5KB context (repeated)</td>
      <td>Small codebases (&lt;20 files)</td>
    </tr>
    <tr>
      <td>Graphify + ctx_index</td>
      <td>~500 tokens (build) + ~100 tokens (index)</td>
      <td>~100 tokens per query</td>
      <td>Large codebases (50+ files), ongoing work</td>
    </tr>
  </table>
</section>
```

**Section Placement:** 4.2 (İleri Düzey - context-mode + graphify synergy)

---

### Combined Example #3: graphify + T5 + T4 (Section 4.3)

**What it combines:** Graph analysis → T5 research → T4 consolidation

**HTML Structure:**
```
<section class="combined-example">
  <h3 id="graphify-t5-t4">graphify + T5 + T4 — Architecture Analysis</h3>
  
  <p class="intro">
    Use when: You need to identify god classes and get a refactoring plan (no implementation yet).
  </p>
  
  <div class="callout-info">
    <strong>Example Scenario:</strong> 60-file codebase, you suspect UserService is too large.
  </div>
  
  <div class="code-input">
    <h4>Your Command (as part of larger x5 task)</h4>
    <pre><code>Codebase'deki god classes'ı tespit et ve refactoring planı oluştur x5</code></pre>
  </div>
  
  <div class="step-by-step">
    <h4>Automated Flow Inside System:</h4>
    
    <strong>Wave 1: T5 Research</strong>
    <pre><code># T5 runs automatically:
/graphify . --local-only
jq '.nodes | map(select(.degree > 15))' graphify-out/graph.json
# Analyzes: degree (connections), communities, coupling</code></pre>
    <p>Output: Raw findings document (~3-4K tokens)</p>
    
    <strong>Wave 2: T4 Consolidation</strong>
    <p>T4 reads T5 output and creates architecture brief:</p>
    <pre><code># T4's synthesis:
## Priority 1: UserService (degree: 42 → should be 4)
Split into: AuthService, ProfileService, NotificationService, PasswordService
Timeline: 1 week
Impact: Reduces cyclomatic complexity 42 → ~12 per service</code></pre>
  </div>
  
  <table class="findings-table">
    <tr>
      <th>Finding</th>
      <th>Severity</th>
      <th>Action</th>
    </tr>
    <tr>
      <td>UserService (degree: 42)</td>
      <td>🔴 Critical</td>
      <td>Split into 4 focused services</td>
    </tr>
    <tr>
      <td>DatabaseRepository (degree: 28)</td>
      <td>🟠 High</td>
      <td>Extract query patterns</td>
    </tr>
    <tr>
      <td>AuthController (degree: 22)</td>
      <td>🟡 Medium</td>
      <td>Split into 2 controllers</td>
    </tr>
  </table>
  
  <div class="callout-tip">
    <strong>Pro Tip:</strong> Graph is rebuilt only on first run. Subsequent sessions reuse graph.json. Add `/graphify --watch` to auto-rebuild as you code.
  </div>
</section>
```

**Section Placement:** 4.3 (İleri Düzey - architecture analysis)

---

### Combined Example #4: x10 + /graphify (Section 4.4)

**What it combines:** Full system team + graph topology

**HTML Structure:**
```
<section class="combined-example">
  <h3 id="x10-graphify">x10 + /graphify — Full System Audit</h3>
  
  <p class="intro">
    Use when: Critical audit — you need to fix god classes, test gaps, and security issues across the entire codebase.
  </p>
  
  <div class="code-input">
    <h4>Your Command</h4>
    <pre><code>Tüm codebase'i audit et: god classes, test gaps, security issues. x10 /graphify</code></pre>
  </div>
  
  <div class="wave-breakdown">
    <h4>Wave Structure (Parallel Execution):</h4>
    
    <div class="wave">
      <strong>Wave 1: 2×T5 Analysts Research Parallel</strong>
      <ul>
        <li>T5-A: Topology analysis (graphify, god nodes)</li>
        <li>T5-B: Security audit (injection, XSS, secrets)</li>
      </ul>
    </div>
    
    <div class="wave">
      <strong>Wave 2: 2×T4 Consolidators Parallel</strong>
      <ul>
        <li>T4-A: Architecture brief (from T5-A findings)</li>
        <li>T4-B: Security brief (from T5-B findings)</li>
      </ul>
    </div>
    
    <div class="wave">
      <strong>Wave 3: 2×T2 Design + 2×T3 Implementation Parallel</strong>
      <ul>
        <li>T2-A designs god class refactoring → T3-A implements</li>
        <li>T2-B designs security hardening → T3-B implements fixes + tests</li>
      </ul>
    </div>
    
    <div class="wave">
      <strong>Wave 4-6: Review Chain Sequential</strong>
      <ul>
        <li>T2 reviews T3 outputs</li>
        <li>T1 (×2) final approval</li>
      </ul>
    </div>
  </div>
  
  <table class="metrics">
    <tr>
      <th>Metric</th>
      <th>Before</th>
      <th>After</th>
      <th>Expected Improvement</th>
    </tr>
    <tr>
      <td>Max god node degree</td>
      <td>42</td>
      <td>~12</td>
      <td>-71%</td>
    </tr>
    <tr>
      <td>Test coverage</td>
      <td>68%</td>
      <td>92%</td>
      <td>+24%</td>
    </tr>
    <tr>
      <td>Security findings</td>
      <td>5 issues</td>
      <td>0</td>
      <td>100% fixed</td>
    </tr>
  </table>
  
  <div class="callout-warning">
    <strong>Cost & Time:</strong>
    <ul>
      <li>Cost: ~$14-20</li>
      <li>Time: 20-30 minutes</li>
      <li>Context: ~950K tokens distributed across 10 agents</li>
    </ul>
  </div>
</section>
```

**Section Placement:** 4.4 (İleri Düzey - critical system overhaul)

---

### Combined Example #5: /test-gen + x3 (Section 3.2)

**What it combines:** Automatic test generation + code review

**HTML Structure:**
```
<section class="combined-example">
  <h3 id="test-gen-x3">/test-gen + x3 — Generate + Review Tests</h3>
  
  <p class="intro">
    Use when: You want to auto-generate a test suite from an implementation file and have reviewers approve it.
  </p>
  
  <div class="code-input">
    <h4>Your Command</h4>
    <pre><code>/test-gen src/features/auth/auth-service.ts x3</code></pre>
  </div>
  
  <div class="step-by-step">
    <h4>Automated Flow:</h4>
    
    <strong>Wave 1: T5 Research</strong>
    <pre><code>Researches testing best practices:
- AAA pattern (Arrange-Act-Assert)
- Happy path + error path + edge cases
- Mock boundaries (repository, HTTP client)</code></pre>
    
    <strong>Wave 2: Generation + Review</strong>
    <pre><code>T2 reviews generated test suite quality:
✅ All public methods have tests
✅ Error paths covered (invalid token, expired, tampered)
✅ Edge cases (clock skew, algorithm mismatches)
✅ No implementation detail testing
→ APPROVED</code></pre>
    
    <strong>Wave 3: T1 Final Approval</strong>
    <pre><code>T1 verifies test strategy aligns with architecture:
✅ Mocks at repository boundary (not internal methods)
✅ Test data factories used consistently
✅ Coverage meets 80%+ standard
→ APPROVED</code></pre>
  </div>
  
  <div class="code-output">
    <h4>Generated Test Example</h4>
    <pre><code>describe('AuthService', () => {
  describe('validateToken', () => {
    it('should return claims when token is valid', async () => {
      const validToken = generateTestJWT({ sub: 'user-123' });
      const result = await authService.validateToken(validToken);
      expect(result.sub).toBe('user-123');
    });
    
    it('should throw UnauthorizedError when token is expired', async () => {
      const expiredToken = generateTestJWT({ 
        exp: Math.floor(Date.now() / 1000) - 3600 
      });
      await expect(authService.validateToken(expiredToken))
        .rejects.toThrow(UnauthorizedError);
    });
  });
});</code></pre>
  </div>
  
  <div class="callout-success">
    <strong>Result:</strong> Reviewed test suite guaranteed high quality, faster than manual writing.
  </div>
</section>
```

**Section Placement:** 3.2 (Yaygın İş Akışları - testing workflow)

---

### Combined Example #6: /ctx + Long-Running Session (Section 4.5)

**What it combines:** Knowledge persistence across session compaction

**HTML Structure:**
```
<section class="combined-example">
  <h3 id="ctx-session-persistence">/ctx + Long-Running Session — Knowledge Persistence</h3>
  
  <p class="intro">
    Use when: You're working on a large task that triggers session compaction mid-way. Index findings before compaction so they survive the reset.
  </p>
  
  <div class="scenario">
    <h4>Scenario:</h4>
    <p>Multi-day migration project. Context window fills up. Session compaction triggers.</p>
  </div>
  
  <div class="code-workflow">
    <strong>Session 1 (Day 1):</strong>
    <pre><code>Multiple T5 analyses complete:
- Auth migration research
- Database schema evolution
- Data migration strategy

At session end, T5 calls:
/ctx
ctx_index("migration-checkpoint-auth-2026-05-22", 
  findings_a, "prose")
ctx_index("migration-checkpoint-db-2026-05-22", 
  findings_b, "prose")</code></pre>
    
    <strong>Session 2 (Day 2, after compaction):</strong>
    <pre><code>New context, old findings not in memory.
But T5 can recover them:
/ctx
ctx_search("JWT migration user claims", limit=3)
→ Returns: "migration-checkpoint-auth-2026-05-22" top result
→ Findings retrieved without re-reading files</code></pre>
  </div>
  
  <div class="callout-tip">
    <strong>Protocol:</strong>
    <ol>
      <li>When analysis completes, always <code>ctx_index()</code> the findings</li>
      <li>On session restart, <code>ctx_search()</code> for prior work</li>
      <li>Never re-read old session files — search the knowledge base instead</li>
    </ol>
  </div>
  
  <div class="callout-info">
    <strong>Cost Savings:</strong>
    <ul>
      <li>Session 1: Index findings (~100 tokens)</li>
      <li>Session 2, Query 1: Retrieve findings (~10 tokens)</li>
      <li>vs. Re-reading 10 analysis files (~5000 tokens)</li>
      <li>Saves 99% of tokens on repeated queries</li>
    </ul>
  </div>
</section>
```

**Section Placement:** 4.5 (İleri Düzey - session management)

---

## Walkthrough Placement (3 Walkthroughs)

### W1: Beginner — /caveman + Typo Fix (Section 1.2)

**Timing:** Show first in Hızlı Başlangıç; demonstrates simplest workflow

**HTML Component:**
```
<section class="walkthrough beginner">
  <h3 id="w1-caveman-typo">İlk Görev: /caveman ile Typo Düzeltme</h3>
  
  <div class="walkthrough-intro">
    <p>Yeni kullanıcının ilk görevi: basit typo fix, caveman mode ile kısa cevap.</p>
    <strong>Time:</strong> 10 seconds | <strong>Cost:</strong> $0 | <strong>Agents:</strong> 0 (Orchestrator only)
  </div>
  
  <div class="timeline">
    <div class="step">
      <span class="step-number">1</span>
      <strong>Your Message:</strong>
      <pre><code>/caveman
Hocam, comment'teki typo'yu düzelt: "usre" → "user"
Dosya: src/features/user/user-service.ts:42</code></pre>
    </div>
    
    <div class="step">
      <span class="step-number">2</span>
      <strong>Orchestrator Analysis (< 1 sec):</strong>
      <ul>
        <li>Task: Trivial (1 line, typo fix)</li>
        <li>No xN needed</li>
        <li>Caveman mode: ON</li>
      </ul>
    </div>
    
    <div class="step">
      <span class="step-number">3</span>
      <strong>Execution (instant):</strong>
      <pre><code>Read: src/features/user/user-service.ts:42
Find: // Check usre ID
Replace: // Check user ID
Write: file
No hooks triggered (comment change)</code></pre>
    </div>
    
    <div class="step">
      <span class="step-number">4</span>
      <strong>Output (Compressed):</strong>
      <pre><code>✅ Fixed typo at src/features/user/user-service.ts:42

Before: // Check usre ID
After:  // Check user ID

Done.</code></pre>
    </div>
  </div>
  
  <div class="key-insights">
    <h4>What You Learned:</h4>
    <ul>
      <li>Single-agent mode for trivial tasks (no xN)</li>
      <li>/caveman compresses prose, not code/paths</li>
      <li>Orchestrator acts directly for simple fixes</li>
      <li>No session file created for sub-1-minute tasks</li>
    </ul>
  </div>
</section>
```

**Placement:** Section 1.2 (Hızlı Başlangıç)

---

### W2: Intermediate — x5 + /ctx + Profile API (Section 3.3)

**Timing:** Show after mastering xN modes; demonstrate full workflow with knowledge persistence

**HTML Component:**
```
<section class="walkthrough intermediate">
  <h3 id="w2-x5-profile-api">Orta Düzey Görev: x5 + /ctx ile Profile API</h3>
  
  <div class="walkthrough-intro">
    <p>Yapı modüle GET /users/:id/profile endpoint'i ekle, caching + S3 + authorization ile.</p>
    <strong>Time:</strong> 12 minutes | <strong>Cost:</strong> ~$1.50 | <strong>Agents:</strong> 5
  </div>
  
  <div class="collapsible-timeline">
    <button class="expand-btn">Show Full Timeline (Click to expand)</button>
    
    <div class="timeline-content" style="display:none;">
      <div class="step">
        <span class="step-number">1</span>
        <strong>PEP Questions (Normal mode, ~2 min):</strong>
        <pre><code>1. Profile resim storage'ı? → S3 pre-signed URL
2. Cache stratejisi? → 5-min Redis
3. Profil resim upload endpoint? → Ayrı PATCH
4. Rate limiting? → 100 req/min per user</code></pre>
        <p><em>User approves defaults</em></p>
      </div>
      
      <div class="step">
        <span class="step-number">2</span>
        <strong>Wave 1: T5 Research (~4K tokens, 2 min):</strong>
        <pre><code>T5 Analisti Araştırması:
- User entity JPA mapping
- Profile exposure patterns
- Redis caching options
- S3 pre-signed URL implementation
- Authorization (owner or admin)

Output: .claude/analysis/raw/T5-profile-research.md</code></pre>
      </div>
      
      <div class="step">
        <span class="step-number">3</span>
        <strong>Wave 2: T4 Consolidation (~2K tokens, 1.5 min):</strong>
        <pre><code>T4 Lider Analist:
- Synthesizes T5 findings
- Creates architecture brief
- Specifies service + DTO structure
- Defines error handling

Output: T4-profile-architecture-brief.md
Review: ✅ APPROVED</code></pre>
      </div>
      
      <div class="step">
        <span class="step-number">4</span>
        <strong>Wave 3: T2 Design + T3 Implementation Parallel (~7K tokens, 3 min):</strong>
        <pre><code>T3 MidCoder:
- Creates UserProfileController.java
- Creates UserProfileDTO.java

T2 Staff Engineer:
- Designs UserProfileService.java
- Plans caching layer
- Specifies @Cacheable configuration

Status: Both outputs ready</code></pre>
      </div>
      
      <div class="step">
        <span class="step-number">5</span>
        <strong>Wave 4: Code Review (Sequential, 2 min):</strong>
        <pre><code>T2 Reviews T3:
✅ Controller uses proper validation
✅ DTO immutable (record syntax)
✅ Error handling comprehensive

T1 Reviews T2:
✅ Architecture sound
✅ Authorization secure
✅ S3 integration safe
→ APPROVED — Ready to merge</code></pre>
      </div>
      
      <div class="step">
        <span class="step-number">6</span>
        <strong>Wave 5: Knowledge Indexing (~1 min):</strong>
        <pre><code>/ctx
ctx_index("user-profile-api-2026-05-22", 
  full_analysis_content, "prose")

Effect: Next session, search for "user profile caching"
→ Returns findings without re-reading files</code></pre>
      </div>
    </div>
  </div>
  
  <div class="final-output">
    <h4>Final Result:</h4>
    <pre><code>GET /api/v1/users/{userId}/profile
Status: ✅ Deployed

Response:
{
  "success": true,
  "data": {
    "id": "user-123",
    "email": "user@example.com",
    "displayName": "John Doe",
    "bio": "Software engineer",
    "profilePictureUrl": "https://s3.amazonaws.com/...",
    "createdAt": "2026-01-15T10:30:00Z"
  }
}

Authorization:
✅ Owner: Can view
✅ Admin: Can view any
✅ Other: Gets 403

Caching:
✅ Redis 5-min TTL
✅ Invalidates on update
✅ ~80% hit rate expected</code></pre>
  </div>
  
  <div class="key-insights">
    <h4>What You Learned:</h4>
    <ul>
      <li>x5 is the default choice for typical features</li>
      <li>PEP questions guide architecture decisions</li>
      <li>Parallel waves speed up implementation</li>
      <li>/ctx indexes findings for future reuse</li>
      <li>Full review chain ensures code quality</li>
    </ul>
  </div>
</section>
```

**Placement:** Section 3.3 (Yaygın İş Akışları)

---

### W3: Advanced — x10 + /graphify + /ctx Full Audit (Section 4.6 - Collapsible)

**Timing:** Show last in İleri Düzey; demonstrate system-level work, condensed in `<details>`

**HTML Component:**
```
<section class="walkthrough advanced">
  <h3 id="w3-x10-full-audit">İleri Düzey Görev: x10 + /graphify + /ctx Tam Audit</h3>
  
  <p class="intro">
    Tüm codebase'i audit et: god classes, test gaps, security issues. Bulguları düzelt.
  </p>
  
  <details>
    <summary>
      <strong>Click to expand full walkthrough</strong> 
      (Time: ~25 min | Cost: ~$14-20 | Agents: 10)
    </summary>
    
    <div class="timeline-expanded">
      <div class="step">
        <span class="step-number">1</span>
        <strong>PEP Questions (Normal mode, ~5 min):</strong>
        <pre><code>1. Refactoring scope? → Top 3 god classes
2. Test coverage target? → 80% existing, 90% new
3. Security scope? → Backend only
4. Timeline? → Phased (fixes next 2 weeks)
5. Breaking changes? → No (maintain API)</code></pre>
        <p><em>User approves recommendations</em></p>
      </div>
      
      <div class="step">
        <span class="step-number">2</span>
        <strong>Wave 1: 2×T5 Research Parallel (~1 hour concurrent, 10 min wall-time):</strong>
        <ul>
          <li>
            <strong>T5 Onur:</strong> Topology analysis
            <pre><code>/graphify . --local-only
jq '.nodes | map(select(.degree > 15))'
→ Output: UserService (42), DatabaseRepo (28), AuthController (22)</code></pre>
          </li>
          <li>
            <strong>T5 Necati:</strong> Security audit
            <pre><code>Scan for: SQL injection, XSS, hardcoded secrets, CORS
→ Findings: Missing rate limiting, test coverage gaps (44-62%)</code></pre>
          </li>
        </ul>
      </div>
      
      <div class="step">
        <span class="step-number">3</span>
        <strong>Wave 2: 2×T4 Consolidation Parallel (~45 min concurrent, 5 min wall-time):</strong>
        <ul>
          <li>
            <strong>T4 Elif:</strong> Architecture brief
            <pre><code>UserService decomposition plan:
- AuthService (degree 18)
- ProfileService (degree 8)
- NotificationService (degree 6)
- PasswordService (degree 5)
Timeline: 1 week</code></pre>
          </li>
          <li>
            <strong>T4 Ayse:</strong> Security brief
            <pre><code>Critical fixes: Injection prevention, rate limiting
High priority: Test coverage (44% → 90%)
Risk level: MEDIUM → LOW after fixes</code></pre>
          </li>
        </ul>
      </div>
      
      <div class="step">
        <span class="step-number">4</span>
        <strong>Wave 3: 2×T2 Design + 2×T3 Implementation Parallel (~2 hours concurrent, 8 min wall-time):</strong>
        <ul>
          <li><strong>T2 Enis:</strong> Refactoring design → <strong>T3 Taner:</strong> Implement</li>
          <li><strong>T2 Tarik:</strong> Test framework design → <strong>T3 Canan:</strong> Implement + tests</li>
        </ul>
      </div>
      
      <div class="step">
        <span class="step-number">5</span>
        <strong>Wave 4: Review Chain Sequential (~1 hour, 5 min wall-time):</strong>
        <pre><code>T2 Enis → reviews T3 Taner refactoring ✅
T2 Tarik → reviews T3 Canan security + tests ✅
T1 Selin → final arch review ✅
T1 Baris → final security review ✅</code></pre>
      </div>
      
      <div class="step">
        <span class="step-number">6</span>
        <strong>Wave 5: Knowledge Indexing (~1 min):</strong>
        <pre><code">/ctx
ctx_index("codebase-audit-2026-05-22", full_audit_report, "prose")

Effect: Next audit session, retrieve findings in 10 tokens vs re-reading 60 files</code></pre>
      </div>
      
      <div class="metrics-summary">
        <h4>Before & After:</h4>
        <table>
          <tr>
            <th>Metric</th>
            <th>Before</th>
            <th>After</th>
            <th>Improvement</th>
          </tr>
          <tr>
            <td>Max god node degree</td>
            <td>42</td>
            <td>12</td>
            <td>-71%</td>
          </tr>
          <tr>
            <td>Avg service degree</td>
            <td>18</td>
            <td>8</td>
            <td>-56%</td>
          </tr>
          <tr>
            <td>Test coverage</td>
            <td>68%</td>
            <td>92%</td>
            <td>+24%</td>
          </tr>
          <tr>
            <td>Security findings</td>
            <td>5</td>
            <td>0</td>
            <td>100% fixed</td>
          </tr>
        </table>
      </div>
    </div>
  </details>
  
  <div class="key-insights">
    <h4>What You Learned:</h4>
    <ul>
      <li>x10 is for critical, system-wide work only</li>
      <li>Parallel waves save time (10 agents → 20 min vs sequential → 60 min)</li>
      <li>/graphify identifies architecture issues at scale</li>
      <li>/ctx preserves findings across sessions</li>
      <li>Full team review ensures quality at all tiers</li>
    </ul>
  </div>
</section>
```

**Placement:** Section 4.6 (İleri Düzey, condensed in `<details>`)

---

## Format Decisions (Example Type → HTML Component)

| Example Type | HTML Component | Copy Button | Interactivity | Use Case |
|---|---|---|---|---|
| Single command (e.g., `/graphify . --local-only`) | `<pre>` with syntax highlight | ✅ Yes | — | Quick reference |
| User input + expected output | Side-by-side `<pre>` boxes (left=input, right=output) | ✅ Both | Diff preview | Command → result mapping |
| Combined usage (multi-step) | `<div class="step-by-step">` with numbered steps | ✅ Each step | Expand/collapse | Workflow documentation |
| Walkthrough (user journey) | `<details>` collapsible with timeline (`<div class="step">`) | — | Click to expand | Deep dives (W1, W2, W3) |
| Decision tree | `<table>` with hover effect + decision columns | ✅ Table copy | Sort by column | Quick decision matrix |
| JSON/graph output | `<pre>` with jq syntax highlight + sample output | ✅ Yes | Copyable snippet | graphify output samples |
| Architecture diagram | ASCII art in `<pre>` or embedded SVG (optional for v2) | — | Hover labels | System topology |
| Wave/execution flow | `<div class="wave-breakdown">` with color-coded stages | — | Numbered stages | Multi-agent execution |
| Callout (info/warning/success) | `<div class="callout-{type}">` with icon | — | Highlighted text | Important notes, tips |

---

## T2-B Implementation Notes (HTML Markup Guidance)

### 1. Copy Button Implementation

Every code block and example should have a copy button. Pattern:

```html
<div class="code-block">
  <div class="code-header">
    <span class="language">bash</span>
    <button class="copy-btn" onclick="copyToClipboard(this)">📋 Copy</button>
  </div>
  <pre><code>/graphify . --local-only</code></pre>
</div>
```

### 2. Combined Example Styling

Combined examples use blue info callout box:

```html
<div class="callout-info">
  <strong>🔵 Kombinasyon:</strong> /caveman + x5
  <p>Kısa cevaplar istenen orta-büyüklükteki refactoring için</p>
</div>
```

### 3. Walkthrough Collapsible Structure

Use `<details>` for walkthroughs to reduce initial page size:

```html
<details>
  <summary>
    <strong>İleri Düzey Görev: x10 + /graphify + /ctx Tam Audit</strong>
    (Time: ~25 min | Cost: ~$14-20 | Agents: 10)
  </summary>
  [Full content here]
</details>
```

### 4. Wave Execution Visualization

Use colored stages for multi-agent parallel execution:

```html
<div class="wave-breakdown">
  <div class="wave stage-1">
    <strong style="color: #FF6B6B;">Wave 1 (Parallel):</strong> 2×T5 research
  </div>
  <div class="wave stage-2">
    <strong style="color: #4ECDC4;">Wave 2 (Parallel):</strong> 2×T4 consolidation
  </div>
  <div class="wave stage-3">
    <strong style="color: #FFE66D;">Wave 3 (Parallel):</strong> 2×T2 design + 2×T3 impl
  </div>
</div>
```

### 5. Decision Tables with Hover

Tables should support sorting and column alignment:

```html
<table class="comparison-table">
  <thead>
    <tr>
      <th onclick="sortTable(0)">Feature</th>
      <th onclick="sortTable(1)">P0 Count</th>
      <th onclick="sortTable(2)">Best Use</th>
    </tr>
  </thead>
  [rows...]
</table>
```

### 6. Maximum One Walkthrough Per Section

Walkthroughs are verbose. Maximum placement:
- Section 1: W1 (Hızlı Başlangıç) — full
- Section 3: W2 (Yaygın İş Akışları) — full
- Section 4: W3 (İleri Düzey) — COLLAPSIBLE with `<details>`

---

## Estimated Added Content

### Additions to HTML:

| Content Type | Quantity | Est. Tokens |
|---|---|---|
| Section headings (h3, h4) | ~40 | 200 |
| Callout boxes (info/warning/tip) | ~25 | 300 |
| Code blocks (`<pre>`) | ~55 | 3500 |
| Step-by-step walkthroughs | 3 full + 6 combined | 2000 |
| Tables (priority, metrics, comparison) | ~8 | 1200 |
| Copy buttons + interactivity JS | 1 | 500 |
| Total new prose (explanations) | ~80 paragraphs | 4000 |

**Total Estimated Tokens:** ~11,700 tokens  
**Estimated File Size Delta:** +30-50 KB (final ~150-170 KB)  
**Estimated HTML File:** 2500-3500 lines

### P0 Examples Prioritized First:

These 19 P0 examples get full treatment with copy buttons and detailed "When to Use" sections:

1. /caveman (Section 2)
2. /ctx (Section 4)
3. /graphify (Section 4)
4. /review (Section 3)
5. No xN mode (Section 1)
6. x3 mode (Section 2)
7. x5 mode (Section 2)
8. x10 mode (Section 4)
9. ctx_execute (Section 4)
10. ctx_execute_file (Section 4)
11. ctx_index (Section 4)
12. ctx_search (Section 4)
13. graphify basic build (Section 4)
14. graphify query god_nodes (Section 4)
15. /test-gen (Section 5)
16. W1 beginner walkthrough (Section 1)
17. W2 intermediate walkthrough (Section 3)
18. W3 advanced walkthrough (Section 4)
19. Combined #1-6 (Sections 3-4)

### P1 Examples as Expandable Reference:

18 P1 examples live in Section 5 (Araçlar Referansı) as collapsible reference, not prominent.

### P2 Examples Deferred:

15 P2 examples (ctx_stats, ctx_doctor, ctx_upgrade, ctx_purge, deep-mode graphify, T4/T5 tier details, hooks) go to FAQ/glossary doc (separate from main HTML).

---

## Quality Checklist for T2-B

Before finalizing HTML, T2-B should verify:

- [ ] Every P0 example has a copy button
- [ ] Every combined example uses blue callout box
- [ ] Every walkthrough uses `<details>` (W3 only) or full timeline (W1, W2)
- [ ] Wave execution uses color-coded stages (FF6B6B, 4ECDC4, FFE66D)
- [ ] All 8 sections present and populated
- [ ] No more than 1 walkthrough per section
- [ ] P2 examples removed from main HTML (deferred to FAQ)
- [ ] Tables have proper sorting/alignment
- [ ] Code blocks have language highlighting (bash, java, typescript, json)
- [ ] Estimated file size 150-170 KB achieved
- [ ] Accessibility: alt text for icons, semantic HTML (`<section>`, `<details>`, `<summary>`)
- [ ] Performance: lazy-load images, minimize CSS/JS

---

## Index for User Searchability

When T2-B embeds this in HTML, include a searchable index:

```
1. Hızlı Başlangıç
   1.1 No xN mode (single-agent, trivial tasks)
   1.2 W1 Walkthrough (caveman + typo fix)

2. Temel Kavramlar
   2.1 /caveman — Short response mode
   2.2 x3 Mode — First multi-agent intro
   2.3 x5 Mode — Default choice
   2.4 /architect + caveman — Quick decision

3. Yaygın İş Akışları
   3.1 /caveman + x5 — Fast refactoring
   3.2 /test-gen + x3 — Test generation + review
   3.3 W2 Walkthrough (x5 + /ctx + profile API)

4. İleri Düzey
   4.1 /ctx — Context-mode fundamentals
   4.2 /ctx + /graphify — Persistent knowledge graph
   4.3 graphify + T5 + T4 — Architecture analysis
   4.4 x10 + /graphify — Full system audit
   4.5 /ctx + Long session — Knowledge persistence
   4.6 W3 Walkthrough (x10 + /graphify + /ctx)

5. Araçlar Referansı
   5.1 ctx_* tools (execute, execute_file, batch, index, search)
   5.2 graphify commands (build, query, watch)
   5.3 /test-gen details
   5.4 Tier reference (T1-T5 examples)

6. Yapılandırma
   6.1 Hook system overview
   6.2 Custom rules example

7. Sorun Giderme
   (To be populated in next sprint)

8. Referans
   (Cheat sheets, decision trees)
```

---

## Sign-Off

**Consolidation Complete.** This document specifies:

✅ Priority matrix (19 P0, 18 P1, 15 P2)  
✅ Section mapping (8 sections, examples → sections)  
✅ Top 6 combined examples with HTML structure (detailed)  
✅ 3 walkthroughs with placement (W1 full, W2 full, W3 collapsible)  
✅ Format decisions (example type → HTML component)  
✅ Implementation notes for T2-B (copy buttons, callouts, waves, tables)  
✅ Estimated content (11.7K tokens, 30-50 KB delta, 2500-3500 lines HTML)  
✅ Quality checklist for final review  

**Ready for T2-B to build HTML section by section.**

