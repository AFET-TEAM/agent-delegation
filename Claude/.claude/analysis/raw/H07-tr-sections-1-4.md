---
task-id: H07
agent: Taner Yilmaz
tier: T3
status: Complete
sections: 1-4
total-lines: 1247
---

# Türkçe HTML İçerik — Sections 1-4

## Persistent UI Strings (Header/Nav/Footer)

```html
<!-- HTML lang attribute -->
<html lang="tr">

<!-- Head meta -->
<title>Claude Code Çoklu Agent Sistemi v1.0.0 - Dokümantasyon</title>
<meta name="description" content="Claude Code Çoklu Agent Delegasyon Sistemi için eksiksiz dokümantasyon: 5 seviye, 19 kanca, 17 kural, 7 xN modu, 3 izlenecek yol.">

<!-- Skip link -->
<a class="skip-link" href="#main-content">Ana içeriğe git</a>

<!-- Sidebar toggle -->
<button class="sidebar-toggle" aria-label="Navigasyonu aç/kapat">☰</button>

<!-- Header brand -->
<div class="header-brand">
  <span class="header-logo">🤖</span>
  Claude Code
  <span class="version-badge">v1.0.0</span>
</div>

<!-- Search -->
<input type="search" placeholder="Dokümantasyonda ara..." aria-label="Dokümantasyonda arama">

<!-- Dark mode toggle -->
<button class="dark-toggle" aria-label="Gece modunu aç/kapat" title="Gece modunu aç/kapat">☽</button>

<!-- Reading progress -->
<div class="reading-progress" role="progressbar" aria-label="Okuma ilerlemesi" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">
  <div class="progress-fill"></div>
</div>

<!-- Sidebar nav aria-label -->
<nav class="sidebar" aria-label="Bölüm navigasyonu">

<!-- Sidebar quicklinks -->
<div class="sidebar-quicklinks">
  <span class="quicklinks-label">Şuraya atla</span>
  <a href="#cheat-sheet">Kısa Referans</a>
  <a href="#faq">SSS</a>
  <a href="#glossary">Sözlük</a>
</div>

<!-- Print button -->
<button class="print-btn" onclick="window.print()">Yazdır</button>

<!-- Copy button states -->
<!-- Initial: Kopyala -->
<!-- After click: Kopyalandı -->
<!-- aria-label: Kodu panoya kopyala -->

<!-- Footer -->
<footer class="site-footer">
  <p>Claude Code Çoklu Agent Sistemi v1.0.0 - Dokümantasyon 2026-05-21'de oluşturuldu</p>
  <p>Tek dosya, çevrimdışı kullanılabilir, harici bağımlılık yok. Yazdırmak için Ctrl/Cmd+P tuşlarına basın.</p>
</footer>
```

## Section 1: Hızlı Başlangıç

```html
<article id="section-quick-start">
  <header class="section-header">
    <span class="section-meta">Bölüm 1 · ~5 dk</span>
    <span class="difficulty-tag difficulty-beginner">Zorluk: Başlangıç</span>
  </header>

  <h1>Claude Code Çoklu Agent Sistemi</h1>
  <p class="site-tagline">Mühendislik görevlerini 5 uzmanlaşmış yapay zeka seviyesi arasında dağıtan bir orkestrasyon katmanı. Özel kancalar, kurallar ve öz-öğrenme örüntüleriyle Anthropic Claude Code v1.0.0 üzerine inşa edilmiştir.</p>

  <h2 id="quick-start">1. Hızlı Başlangıç</h2>

  <h3 id="what-is-claude-code">1.1 Bu Sistem Nedir?</h3>

  <p>Claude Code Çoklu Agent Delegasyon Sistemi, yazılım mühendisliği görevlerini yapılandırılmış bir yapay zeka ajansı ekibine dağıtan bir orkestrasyon katmanıdır. Her şeyi tek bir modele yönlendirmek yerine, işler karmaşıklığa göre atanır: araştırma hızlı Haiku analistlere, uygulama Sonnet mühendislere, mimari kararlar ise Opus principallarına gider.</p>

  <p>Orkestratör (ana Claude oturumunuzdur) ekibi koordine eder, inceleme zincirini yönetir, kod kalitesi kancalarını uygular ve çıktıları nihai sonuçta birleştirir.</p>

  <div class="stat-grid">
    <div class="stat-card">
      <span class="stat-value">5</span>
      <span class="stat-label">Ajan Seviyeleri</span>
    </div>
    <div class="stat-card">
      <span class="stat-value">19</span>
      <span class="stat-label">Zorunluluk Kancaları</span>
    </div>
    <div class="stat-card">
      <span class="stat-value">17</span>
      <span class="stat-label">Kural Dosyaları</span>
    </div>
    <div class="stat-card">
      <span class="stat-value">7</span>
      <span class="stat-label">xN Modları</span>
    </div>
  </div>

  <div class="callout callout-info">
    <strong>Not:</strong> Bu bir orkestrasyon katmanıdır, tek bir yapay zeka yardımcısı değil. Orkestratör, hangi seviye(ler)in her görevi üstleneceğine karar verir ve çoklu ajan modunda uygulama kodu doğrudan yazmaz.
  </div>

  <p>Bir bakışta sistem akışı:</p>
  <pre><code>Orkestratör (ana oturum)
  ├── T1 Principal    (opus)    -- Mimari, nihai inceleme
  ├── T2 Staff Engineer (sonnet) -- Servis katmanı, tasarım
  ├── T3 MidCoder     (sonnet)  -- Uygulama
  ├── T4 Lead Analyst (haiku)   -- Konsolidasyon
  └── T5 Analyst      (haiku)   -- Araştırma, ham analiz</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>

  <h3 id="one-command-setup">1.2 Tek-Komut Kurulumu</h3>

  <p>Ön koşullar: Node.js 18+, git, Claude Code CLI kurulu.</p>

  <pre><code class="language-bash"># .claude/ dizinini de içerecek şekilde depoyu klonlayın veya kopyalayın
git clone https://github.com/your-org/project.git
cd project

# Kurulum doğrulama
ls .claude/hooks/ .claude/agents/ .claude/rules/

# Sistem hazır — tüm kancalar, kurallar ve ajan şablonları yüklendi</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>

  <div class="callout callout-success">
    <strong>Kurulum Tamamlandı:</strong> 20 Türkçe isimle ajan adı havuzu başlatıldı. Kancalar kaydedildi. Kural dosyaları yüklendi. Sistem çoklu agent görevlere hazır.
  </div>

  <p>Beklenen yapı:</p>
  <pre><code>.claude/
  ├── agents/          # Ajan istem şablonları (5 dosya)
  ├── config/          # Delegasyon kuralları, model kayıt defteri
  ├── hooks/           # Uygulama kancaları (19 script)
  ├── memory/          # Oturum dosyaları, öğrenilen örüntüler
  ├── metrics/         # Agent performance, lider tablosu
  ├── rules/           # Kodlama standartları (17 dosya)
  └── todo/            # Aktif plan takibi</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>

  <h3 id="first-task">1.3 İlk Göreviniz</h3>

  <p>Sistemi denemenin en hızlı yolu, gerçek bir düzeltme görevi ile başlamaktır. Aşağıdaki örnek, Orkestratörün önemsiz bir görevi nasıl algıladığını ve tek ajan modunda nasıl işlediğini gösterir.</p>

  <pre><code>Hocam, bu comment'teki typo'yu duzelt: 'usre' -&gt; 'user'
Dosya: src/features/user/user-service.ts, satir 42</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>

  <p>Orkestratör analizi:</p>
  <ul>
    <li>Algılandı: tek dosya, 1 satır, önemsiz (yazım hatası)</li>
    <li>xN parametresi yok</li>
    <li>PEP atlandı: EVET (önemsiz görev)</li>
    <li>Mod: tek ajan (Orkestratör doğrudan ilgilenir)</li>
  </ul>

  <p>Çalıştırma:</p>
  <ol>
    <li><code>src/features/user/user-service.ts</code> dosyasını oku</li>
    <li>42. satırdaki yorumda yazım hatasını bul</li>
    <li>"usre ID validation" değerini "user ID validation" olarak değiştir</li>
    <li>Kanca tetiklenmedi (yalnızca yorum değişikliği)</li>
    <li>Dosyayı kaydet</li>
  </ol>

  <div class="callout callout-info">
    <strong>Sonraki adım:</strong> Tam bir adım adım izlenecek yol için, Bölüm 3'teki Walkthrough W1'e (3.1) bakın.
  </div>

  <nav class="prev-next-nav" aria-label="Bölüm navigasyonu">
    <span class="prev-next-prev disabled">← Önceki</span>
    <a href="#core-concepts" class="prev-next-next">Sonraki → Temel Kavramlar</a>
  </nav>
</article>
```

## Section 2: Temel Kavramlar

```html
<article id="section-core-concepts">
  <header class="section-header">
    <span class="section-meta">Bölüm 2 · ~20 dk</span>
    <span class="difficulty-tag difficulty-intermediate">Zorluk: Orta</span>
  </header>

  <h2 id="core-concepts">2. Temel Kavramlar</h2>

  <p>Bu bölüm, sistemin beş temel bileşenini açıklar: seviyeler, xN modları, inceleme zinciri, kancalar ve beceriler. Bu kavramları öğrenmek, hangi modu ne zaman kullanacağınızı ve görev sonuçlarını nasıl yorumlayacağınızı anlamanızı sağlar.</p>

  <h3 id="five-tiers">2.1 Beş Seviye Açıklandı</h3>

  <p>Sistem, farklı model güçlerine ve maliyet profillerine sahip beş ajan seviyesi üzerinde çalışır. Orkestratör, görevi karmaşıklığa ve maliyete göre doğru seviyeye atar.</p>

  <div class="decision-table-wrapper">
    <table class="decision-table">
      <thead>
        <tr>
          <th>Seviye</th>
          <th>Rol</th>
          <th>Model</th>
          <th>Sorumluluk</th>
          <th>Maliyet/Görev</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><span class="badge badge-tier-T1">T1</span></td>
          <td>Principal</td>
          <td><code>opus</code></td>
          <td>Mimari kararlar, nihai inceleme, yükseltme hedefi</td>
          <td>~$0.60-0.75</td>
        </tr>
        <tr>
          <td><span class="badge badge-tier-T2">T2</span></td>
          <td>Staff Engineer</td>
          <td><code>sonnet</code></td>
          <td>Servis tasarımı, T3 kodunu inceler</td>
          <td>~$0.24-0.30</td>
        </tr>
        <tr>
          <td><span class="badge badge-tier-T3">T3</span></td>
          <td>MidCoder</td>
          <td><code>sonnet</code></td>
          <td>API uç noktaları, DTO'lar, standart CRUD</td>
          <td>~$0.18-0.24</td>
        </tr>
        <tr>
          <td><span class="badge badge-tier-T4">T4</span></td>
          <td>Kıdemli Analist</td>
          <td><code>haiku</code></td>
          <td>T5 ham analizini birleştirir</td>
          <td>~$0.05-0.07</td>
        </tr>
        <tr>
          <td><span class="badge badge-tier-T5">T5</span></td>
          <td>Analist</td>
          <td><code>haiku</code></td>
          <td>Kod tabanı araştırması, ham bulgular</td>
          <td>~$0.04-0.06</td>
        </tr>
      </tbody>
    </table>
  </div>

  <div class="callout callout-info">
    <strong>Anahtar İlke:</strong> T1 opus, en yüksek kapasiteye sahip ama aynı zamanda en pahalı seviyedir. Sistemi maliyet açısından verimli tutan; araştırmanın haiku'ya, tasarım çalışmasının sonnet'e ve yalnızca mimari kararların opus'a yönlendirilmesidir.
  </div>

  <h3 id="xn-modes">2.2 xN Modu Referansı</h3>

  <p>xN parametresi, çoklu ajan modunu etkinleştirir ve kaç ajanın belirlenmiş dalga düzeninde çalışacağını belirler. İsteminizin sonuna x2–x10 ekleyin.</p>

  <div class="decision-table-wrapper">
    <table class="decision-table">
      <thead>
        <tr>
          <th>Mod</th>
          <th>Açıklama</th>
          <th>Maliyet</th>
          <th>Zaman</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><span class="badge badge-mode badge-mode-single">Single</span></td>
          <td>xN yok. Tek ajan modu. Önemsiz düzeltmeler, açıklamalar, inceleme zinciri yok.</td>
          <td><span class="cost-indicator cost-free">~$0</span></td>
          <td>&lt;1 dk</td>
        </tr>
        <tr>
          <td><span class="badge badge-mode badge-mode-x3">x2</span></td>
          <td>Mimari inceleme + araştırma. Uygulama yok.</td>
          <td><span class="cost-indicator cost-low">$2-3</span></td>
          <td>5-7 dk</td>
        </tr>
        <tr>
          <td><span class="badge badge-mode badge-mode-x3">x3</span></td>
          <td>Üst düzey incelemeli küçük özellik.</td>
          <td><span class="cost-indicator cost-low">$2-3</span></td>
          <td>8-10 dk</td>
        </tr>
        <tr>
          <td><span class="badge badge-mode badge-mode-x3">x4</span></td>
          <td>Tek modül standart geliştirme.</td>
          <td><span class="cost-indicator cost-low">$3-4</span></td>
          <td>10-12 dk</td>
        </tr>
        <tr class="decision-recommended">
          <td><span class="badge badge-mode badge-mode-x5">x5</span></td>
          <td><strong>VARSAYILAN.</strong> Dengeli ekip, tam inceleme zinciri. Standart özellikler için en iyi. <span class="recommended-badge">⭐ Varsayılan</span></td>
          <td><span class="cost-indicator cost-medium">$4-6</span></td>
          <td>12-15 dk</td>
        </tr>
        <tr>
          <td><span class="badge badge-mode badge-mode-x7">x7</span></td>
          <td>Paralel özellik izleri, birden fazla modül.</td>
          <td><span class="cost-indicator cost-high">$7-10</span></td>
          <td>15-18 dk</td>
        </tr>
        <tr>
          <td><span class="badge badge-mode badge-mode-x10">x10</span></td>
          <td>Kritik sistem revizyonu, maksimum yetenek.</td>
          <td><span class="cost-indicator cost-very-high">$12-18</span></td>
          <td>25-35 dk</td>
        </tr>
      </tbody>
    </table>
  </div>

  <p>xN nasıl seçilir — hızlı karar ağacı:</p>
  <ul>
    <li>Önemsiz (&lt;3 satır, 1 dosya)? → Single (xN yok)</li>
    <li>Yalnızca araştırma, kod yok? → x2</li>
    <li>Üst düzey incelemeli küçük özellik? → x3</li>
    <li>Standart özellik, tam zincir? → x5 ⭐ (varsayılan)</li>
    <li>Birden fazla paralel iz? → x7</li>
    <li>Sistem çapında revizyon? → x10</li>
  </ul>

  <div class="callout callout-success">
    <strong>Varsayılan Öneri:</strong> Kararsız kaldığınızda x5 kullanın. Makul bir maliyetle tam inceleme zinciri sağlar. Sistemin önerilen varsayılanıdır.
  </div>

  <h3 id="review-chain">2.3 İnceleme Zinciri</h3>

  <p>Çoklu ajan modunda, tüm kod çıktıları sıralı bir inceleme zincirinden geçer. Her inceleyici onaylar, revizyon ister (maksimum 2 tur) veya çalışmayı reddeder.</p>

  <div class="review-chain-diagram">
    <div class="chain-node">T5 Çıktısı</div>
    <span class="chain-arrow">→</span>
    <div class="chain-node">T4 İncelemesi</div>
    <span class="chain-arrow">→</span>
    <div class="chain-node">T2 İncelemesi</div>
    <span class="chain-arrow">→</span>
    <div class="chain-node">T1 Onayı</div>
  </div>

  <p>İnceleme sonuçları:</p>

  <div class="decision-table-wrapper">
    <table class="decision-table">
      <thead>
        <tr>
          <th>Sonuç</th>
          <th>İşlem</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>✅ Onaylandı</td>
          <td>Birleştir ve sonraki göreve geç</td>
        </tr>
        <tr>
          <td>⚠️ Revizyon Gerekli</td>
          <td>Bulguları içeren yeni ajan başlat, maksimum 2 tur</td>
        </tr>
        <tr>
          <td>❌ Reddedildi</td>
          <td>Tohum istemiyle bir üst seviyeye yükselt</td>
        </tr>
      </tbody>
    </table>
  </div>

  <p>Revizyon sayacı: Her görev <code>revision_attempts</code> değerini (0'dan başlar) takip eder. Her uyarı yeniden başlatması 1 artırır. Aynı seviye içinde iki artış artı bir red, bir üst seviyeye zorunlu yükseltmeyi tetikler. Sayaç yalnızca daha yüksek bir seviyeye yükseltilirken sıfırlanır.</p>

  <h3 id="hooks-overview">2.4 Kanca Sistemine Genel Bakış</h3>

  <p>Kancalar, her araç çağrısından önce ve sonra otomatik olarak tetiklenen shell script'leridir. Kural ihlallerini engellerler (çıkış 1) veya uyarı verirler (çıkış 0). İhlaller atlanamaz.</p>

  <div class="decision-table-wrapper">
    <table class="decision-table">
      <thead>
        <tr>
          <th>Kanca Olayı</th>
          <th>Amaç</th>
          <th>Adet</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><code>PreToolUse:Edit/Write</code></td>
          <td>Yasaklı örüntüleri engelle (konsol ifadeleri, türsüz değerler, SQL enjeksiyonu, XSS vb.)</td>
          <td>11</td>
        </tr>
        <tr>
          <td><code>PreToolUse:Bash</code></td>
          <td>Yıkıcı git işlemlerini ve tehlikeli bash örüntülerini engelle</td>
          <td>2</td>
        </tr>
        <tr>
          <td><code>PostToolUse:Edit/Write</code></td>
          <td>Düzenlemeleri takip et, tekrarlanan örüntüleri tespit et, oturum etkinliğini kaydet</td>
          <td>3</td>
        </tr>
        <tr>
          <td><code>SessionEnd</code></td>
          <td>Lider tablosunu güncelle, öğrenilen örüntüleri işle, eski olanları arşivle</td>
          <td>3</td>
        </tr>
      </tbody>
    </table>
  </div>

  <p>Tüm 19 kancanın tam kataloğu için bkz. <a href="#hooks-catalog">Bölüm 6.2</a>.</p>

  <h3 id="skills-system">2.5 Beceri Sistemi</h3>

  <p>Beceriler, uzmanlaşmış davranışa yönlendiren yeniden kullanılabilir slash komutlarıdır. Sistemle birlikte altı komut gelir.</p>

  <div class="decision-table-wrapper">
    <table class="decision-table">
      <thead>
        <tr>
          <th>Komut</th>
          <th>Etki</th>
          <th>Ne Zaman Kullanılır</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><code>/caveman</code></td>
          <td>Sıkıştırılmış düz metin çıktısı (%40-65 daha az kelime)</td>
          <td>Hızlı hata ayıklama oturumları, hızlı iterasyon</td>
        </tr>
        <tr>
          <td><code>/graphify</code></td>
          <td>Kod tabanı bilgi grafı oluştur (AST tabanlı)</td>
          <td>Kod tabanı &gt;20 dosya, topoloji bilinmiyor</td>
        </tr>
        <tr>
          <td><code>/ctx</code></td>
          <td>Context-mode bellek araçları (<code>ctx_search</code>, <code>ctx_index</code>)</td>
          <td>Karmaşık analiz, oturumlar arası yeniden kullanım</td>
        </tr>
        <tr>
          <td><code>/review</code></td>
          <td>Kontrol listesine karşı kod incelemesi</td>
          <td>Birleştirme öncesi, PR kalite kapısı</td>
        </tr>
        <tr>
          <td><code>/security-review</code></td>
          <td>Odaklanmış güvenlik analizi</td>
          <td>Dağıtım öncesi, uyumluluk denetimi</td>
        </tr>
        <tr>
          <td><code>/architect</code></td>
          <td>Doğrudan T1 Principal'a yönlendir (opus)</td>
          <td>Mimari kararlar, sistem tasarımı</td>
        </tr>
      </tbody>
    </table>
  </div>

  <nav class="prev-next-nav" aria-label="Bölüm navigasyonu">
    <a href="#quick-start" class="prev-next-prev">← Önceki: Hızlı Başlangıç</a>
    <a href="#common-workflows" class="prev-next-next">Sonraki → Yaygın İş Akışları</a>
  </nav>
</article>
```

## Section 3: Yaygın İş Akışları

```html
<article id="section-common-workflows">
  <header class="section-header">
    <span class="section-meta">Bölüm 3 · ~30 dk</span>
    <span class="difficulty-tag difficulty-intermediate">Zorluk: Orta</span>
  </header>

  <h2 id="common-workflows">3. Yaygın İş Akışları</h2>

  <p>Bu bölüm, en sık kullanılan iş akışlarını gerçek komutlar, beklenen çıktılar ve maliyet tahminleriyle birlikte gösterir. Üç tam izlenecek yol (W1, W2, W3) ve araç kullanım örnekleri içerir.</p>

  <h3 id="workflow-simple">3.1 Basit Düzeltme - Tek Ajan (W1)</h3>

  <p>İzlenecek Yol W1: Tek yazım hatasını düzelt, tek ajan modu, yaklaşık 1 dakika.</p>

  <div class="walkthrough walkthrough-beginner" id="w1-simple-fix">
    <div class="walkthrough-header">
      <div class="walkthrough-meta">
        <span class="walkthrough-level difficulty-tag difficulty-beginner">Zorluk: Başlangıç</span>
        <span class="walkthrough-time">⏱ ~1 dk</span>
        <span class="walkthrough-cost">💰 ~$0</span>
        <span class="walkthrough-agents">🤖 0 Agent</span>
      </div>
      <h3 class="walkthrough-title">W1: Tek Ajan ile Yazım Hatası Düzeltme</h3>
      <p class="walkthrough-scenario">Yeni kullanıcının ilk görevi: basit yazım hatası düzeltme, tek ajan modu.</p>
    </div>

    <div class="walkthrough-timeline">
      <div class="timeline-step">
        <span class="timeline-time">0:00</span>
        <div class="timeline-content">
          <strong>Kullanıcı komutu:</strong>
          <pre><code>Hocam, bu comment'teki typo'yu duzelt: 'usre' -&gt; 'user'
Dosya: src/features/user/user-service.ts, satir 42</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
        </div>
      </div>

      <div class="timeline-step">
        <span class="timeline-time">0:01</span>
        <div class="timeline-content">
          <strong>Orkestratör analizi (&lt;1 sn):</strong>
          <ul>
            <li>Algılandı: tek dosya, 1 satır, önemsiz (yazım hatası)</li>
            <li>xN parametresi yok</li>
            <li>PEP atlandı: EVET (önemsiz görev)</li>
            <li>Mod: tek ajan (Orkestratör doğrudan ilgilenir)</li>
          </ul>
        </div>
      </div>

      <div class="timeline-step">
        <span class="timeline-time">0:05</span>
        <div class="timeline-content">
          <strong>Çalıştırma (anında):</strong>
          <pre><code>Read: src/features/user/user-service.ts:42
Find: // Check usre ID
Replace: // Check user ID
Write: dosya
Kanca tetiklenmedi (yorum değişikliği)</code></pre>
        </div>
      </div>

      <div class="timeline-step">
        <span class="timeline-time">0:10</span>
        <div class="timeline-content">
          <strong>Çıktı:</strong>
          <pre><code>✅ Yazım hatası düzeltildi: src/features/user/user-service.ts:42

Önce: // Check usre ID
Sonra: // Check user ID

Oturum dosyası oluşturulmadı (tek ajan modu).
Tamamlandı.</code></pre>
        </div>
      </div>
    </div>

    <div class="decision-table-wrapper" style="margin-top: var(--space-4);">
      <table class="decision-table">
        <thead>
          <tr><th>Metrik</th><th>Değer</th></tr>
        </thead>
        <tbody>
          <tr><td>Zaman</td><td>~1 dakika</td></tr>
          <tr><td>Maliyet</td><td><span class="cost-indicator cost-free">~$0</span></td></tr>
          <tr><td>Ajanlar</td><td>0 (yalnızca Orkestratör)</td></tr>
          <tr><td>Oturum dosyası</td><td>Oluşturulmadı</td></tr>
        </tbody>
      </table>
    </div>

    <div class="walkthrough-insights">
      <h4>Neler öğrendik:</h4>
      <ul>
        <li>Önemsiz görevler için tek-agent modu (xN gerekmez)</li>
        <li>/caveman proz'u sıkıştırır, kodu/yolları değil</li>
        <li>Orkestratör basit düzeltmeleri doğrudan yapar</li>
        <li>Tek ajan modu hiçbir zaman oturum performans raporu üretmez</li>
      </ul>
    </div>
  </div>

  <div class="callout callout-info">
    <strong>Performans raporu yok:</strong> Tek ajan modu hiçbir zaman oturum performans raporu üretmez. Bu artifact yalnızca çoklu ajan (xN) oturumlarına özgüdür.
  </div>

  <h3 id="workflow-x3">3.2 Küçük Özellik - x3 Modu</h3>

  <p>Kullanıcı komutu:</p>
  <pre><code>GET /users/:id endpoint'i ekle x3</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>

  <p>Ajan tahsisi:</p>
  <div class="wave-breakdown">
    <div class="wave-item">
      <span class="wave-label wave-1">Dalga 1</span>
      <span class="wave-content"><span class="badge badge-tier-T5">T5 Analyst (haiku)</span> — Giriş örüntülerini araştır, güvenlik gereksinimlerini belirle</span>
    </div>
    <div class="wave-item">
      <span class="wave-label wave-2">Dalga 2</span>
      <span class="wave-content"><span class="badge badge-tier-T2">T2 Staff Engineer (sonnet)</span> — T5 çıktısını inceler, eksik sınır durumlarını işaretler → ✅ Onaylandı</span>
    </div>
    <div class="wave-item">
      <span class="wave-label wave-3">Dalga 3</span>
      <span class="wave-content"><span class="badge badge-tier-T1">T1 Principal (opus)</span> — Nihai onay, Orkestratör birleştirilmiş çıktıyı sunar</span>
    </div>
  </div>

  <p>Maliyet: <span class="cost-indicator cost-low">~$2-3</span> &nbsp;&nbsp; Zaman: ~8-10 dakika &nbsp;&nbsp; Çıktı: Onaylı test senaryoları + uygulama önerileri.</p>

  <h3 id="workflow-x5">3.3 Standart Özellik - x5 Modu (W2)</h3>

  <p>İzlenecek Yol W2: Tam inceleme zinciriyle API uç noktası ekle. Bu, kanonik çoklu ajan akışıdır.</p>

  <div class="walkthrough walkthrough-intermediate" id="w2-x5-api">
    <div class="walkthrough-header">
      <div class="walkthrough-meta">
        <span class="walkthrough-level difficulty-tag difficulty-intermediate">Zorluk: Orta</span>
        <span class="walkthrough-time">⏱ ~12-15 dk</span>
        <span class="walkthrough-cost">💰 ~$4-6</span>
        <span class="walkthrough-agents">🤖 5 Agent</span>
      </div>
      <h3 class="walkthrough-title">W2: x5 ile Kullanıcı Profil API Uç Noktası</h3>
      <p class="walkthrough-scenario">Kullanıcı profil endpoint'i ekleme: controller, service, DTO ve Redis önbellekleme ile tam iş akışı.</p>
    </div>

    <div class="walkthrough-timeline">
      <div class="timeline-step">
        <span class="timeline-time">0:00</span>
        <div class="timeline-content">
          <strong>Kullanıcı komutu:</strong>
          <pre><code>Kullanıcı yönetim modülüne GET /users/:id/profile endpoint'i ekle.
Profile şu alanları dönmeli: email, displayName, bio, profilePictureUrl, createdAt.
Sadece profile sahibi veya admin görebilsin. x5</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
        </div>
      </div>

      <div class="timeline-step">
        <span class="timeline-time">0:01</span>
        <div class="timeline-content">
          <strong>Orkestratör analizi:</strong>
          <ul>
            <li>Görev türü: Özellik (API uç noktası)</li>
            <li>Karmaşıklık: Orta (2-3 dosya: servis + controller + DTO)</li>
            <li>Önemsiz değil: çok dosyalı, iş mantığı gerekli</li>
            <li>PEP zorunlu: EVET</li>
          </ul>
        </div>
      </div>

      <div class="timeline-step">
        <span class="timeline-time">0:02</span>
        <div class="timeline-content">
          <strong>İstem Zenginleştirme Protokolü (PEP):</strong>
          <pre><code>1. Profil resmi storage'ı nerede? (S3 pre-signed URL önerilir)
2. Cache stratejisi? (5-dk Redis önerilir)
3. Profil resim upload aynı endpoint'te mi? (Ayrı PATCH önerilir)
4. Rate limiting? (100 istek/dk per kullanıcı önerilir)</code></pre>
          <p>Kullanıcı varsayılanları onaylar. Orkestratör görev planı oluşturur:</p>
          <pre><code>### Dalga 1: Analiz
- TASK-001 (T5 Analyst): Kullanıcı profil örüntülerini, güvenliği, önbelleği araştır

### Dalga 2: Konsolidasyon
- TASK-002 (T4 Lead Analyst): T5 bulgularını mimari özetine sentezle

### Dalga 3: Uygulama (Paralel)
- TASK-003 (T2 Staff Engineer): Servis katmanı (ProfileService, önbellekleme)
- TASK-004 (T3 MidCoder): Controller uç noktası, DTO'lar, entity eşleme

### Dalga 4: Kod İncelemesi
- TASK-005 (T2, T3'ü inceler): Kod kalitesi, hata yönetimi, güvenlik
- TASK-006 (T1, T2'yi inceler): Mimari tutarlılık, servis tasarımı

### Tahmini Maliyet: $4-6
### Tahmini Süre: 12-15 dakika</code></pre>
        </div>
      </div>

      <div class="timeline-step">
        <span class="timeline-time">0:03</span>
        <div class="timeline-content">
          <strong>Dalga 1 - T5 Analizi (haiku, ~38K belirteç):</strong>
          <p>T5, kullanıcı entity'sini (12 alan), mevcut profil uç noktalarını, profil veri açığa çıkarma örüntülerini, mevcut önbellek kütüphanelerini okur. <code>.claude/analysis/raw/T5-user-profile.md</code> dosyasına çıktı verir.</p>
        </div>
      </div>

      <div class="timeline-step">
        <span class="timeline-time">0:05</span>
        <div class="timeline-content">
          <strong>Dalga 2 - T4 Konsolidasyon (haiku, ~32K belirteç):</strong>
          <p>T4, T5 bulgularını sentezler: uç nokta şekli, servis sözleşmesi, hata durumları, önbellek stratejisi. <code>.claude/analysis/consolidated/T4-profile-brief.md</code> dosyasına çıktı verir.</p>
        </div>
      </div>

      <div class="timeline-step">
        <span class="timeline-time">0:07</span>
        <div class="timeline-content">
          <strong>Dalga 3 - T2 + T3 Uygulaması (paralel, sonnet, ~146K belirteç):</strong>
          <p>T3 controller + DTO'ları uygular. T2 servis katmanını uygular. İkisi bağımsız dosyalara dokundukları için paralel çalışır.</p>

          <p>T3 uygulama alıntısı:</p>
          <pre><code class="language-java">// UserProfileController.java
@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserProfileController {

    private final UserProfileService userProfileService;

    @GetMapping("/{userId}/profile")
    @Operation(summary = "Kullanıcı profilini getir")
    public ResponseEntity&lt;ApiResponse&lt;UserProfileDTO&gt;&gt; getProfile(
            @PathVariable String userId,
            @RequestAttribute Long requesterId) {

        UserProfileDTO profile = userProfileService.getProfile(userId, requesterId);
        return ResponseEntity.ok(ApiResponse.success(profile));
    }
}</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>

          <p>T2 servis uygulaması:</p>
          <pre><code class="language-java">// UserProfileService.java
@Service
@Cacheable(cacheNames = "userProfile")
@RequiredArgsConstructor
public class UserProfileService {

    private final UserRepository userRepository;
    private final S3Service s3Service;

    public UserProfileDTO getProfile(String userId, Long requesterId) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new NotFoundError("User", userId));

        if (!isOwnerOrAdmin(userId, requesterId)) {
            throw new UnauthorizedError("Bu profili görüntüleyemezsiniz");
        }

        String pictureUrl = user.getProfilePicturePath() != null
            ? s3Service.getPresignedUrl(user.getProfilePicturePath(), 3600)
            : null;

        return new UserProfileDTO(
            user.getId().toString(),
            user.getEmail(),
            user.getDisplayName(),
            user.getBio(),
            pictureUrl,
            user.getCreatedAt()
        );
    }

    private boolean isOwnerOrAdmin(String userId, Long requesterId) {
        return userId.equals(requesterId.toString()) || checkAdminRole(requesterId);
    }
}</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
        </div>
      </div>

      <div class="timeline-step">
        <span class="timeline-time">0:12</span>
        <div class="timeline-content">
          <strong>Dalga 4 - İnceleme zinciri (sıralı, ~180K belirteç):</strong>
          <p>T2, T3 kodunu inceler (küçük sorun: <code>@Validated</code> eksik). T1, T2 mimarisini inceler (✅ onaylandı). Nihai konsolidasyon.</p>
        </div>
      </div>
    </div>

    <div class="walkthrough-insights">
      <h4>Neler öğrendik:</h4>
      <ul>
        <li>PEP soruları başlamadan önce belirsizliği giderir</li>
        <li>T4 ve T5 araştırma/konsolidasyon için haiku kullanır (ucuz), T1/T2/T3 uygulama için sonnet/opus</li>
        <li>Paralel dalgalar (T2+T3 aynı anda) toplam süreyi kısaltır</li>
        <li>İnceleme zinciri kalite güvencesini otomatikleştirir</li>
      </ul>
    </div>
  </div>

  <h3 id="workflow-x10">3.4 Sistem Denetimi - x10 Modu (W3)</h3>

  <p>İzlenecek Yol W3: Sistem genelinde güvenlik ve mimari denetimi. Bu, mevcut bir kod tabanını birden fazla paralel iz üzerinde analiz eder.</p>

  <details class="walkthrough walkthrough-advanced" id="w3-x10-audit">
    <summary>
      <div class="walkthrough-summary-content">
        <span class="walkthrough-level difficulty-tag difficulty-advanced">Zorluk: İleri</span>
        <span class="walkthrough-title">W3: x10 + /graphify + /ctx Tam Sistem Denetimi</span>
        <div class="walkthrough-summary-meta">
          <span>⏱ ~25-35 dk</span>
          <span>💰 ~$12-18</span>
          <span>🤖 10 Agent</span>
        </div>
      </div>
    </summary>
    <div class="walkthrough-body">
      <div class="walkthrough-timeline">
        <div class="timeline-step">
          <span class="timeline-time">0:00</span>
          <div class="timeline-content">
            <strong>Kullanıcı komutu:</strong>
            <pre><code>Tüm codebase'i audit et:
- God classes ve refactoring ihtiyaçları
- Test coverage boşlukları
- Security issues (injection, XSS, auth)
- Performance bottlenecks
Bulguları düzelt. x10 /graphify /ctx</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
          </div>
        </div>

        <div class="timeline-step">
          <span class="timeline-time">0:02</span>
          <div class="timeline-content">
            <strong>Görev planı (Orkestratör x10):</strong>
            <pre><code>## Çoklu Ajan Planı - x10 Modu

### Dalga 1: Paralel Analiz (2x T5)
- TASK-001 (T5-A): Kimlik doğrulama ve yetkilendirme akışlarını araştır
- TASK-002 (T5-B): Veritabanı katmanı ve N+1 sorgu örüntülerini araştır

### Dalga 2: Çift Konsolidasyon (2x T4)
- TASK-003 (T4-A): T5-A bulgularını güvenlik özetine sentezle
- TASK-004 (T4-B): T5-B bulgularını performans özetine sentezle

### Dalga 3: Uygulama (2x T3 paralel)
- TASK-005 (T3-A): Kimlik doğrulama güvenlik yamalarını uygula
- TASK-006 (T3-B): Sorgu optimizasyonlarını uygula

### Dalga 4+: İnceleme Zinciri (2x T2 → 2x T1)</code></pre>
          </div>
        </div>

        <div class="timeline-step">
          <span class="timeline-time">0:05</span>
          <div class="timeline-content">
            <strong>Dalga 1: 2×T5 Paralel Araştırma</strong>
            <p>T5-A topoloji analizi yapar (graphify, god node'lar). T5-B güvenlik denetimi yapar (injection, XSS, auth).</p>
            <pre><code class="language-bash"># T5-A çalıştırır
/graphify . --local-only
cat graphify-out/GRAPH_REPORT.md

# God node'ları çıkar
jq '.nodes | map(select(.degree > 15)) | sort_by(-.degree)' graphify-out/graph.json

# Bulguları dizinle
ctx_index("topology-audit-2026-05-22", topology_findings, "prose")</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
          </div>
        </div>

        <div class="timeline-step">
          <span class="timeline-time">0:12</span>
          <div class="timeline-content">
            <strong>Dalga 2: 2×T4 Paralel Konsolidasyon</strong>
            <p>T4-A mimari özeti oluşturur (god class ayrıştırma planı). T4-B güvenlik özeti oluşturur (öncelikli düzeltme listesi).</p>
          </div>
        </div>

        <div class="timeline-step">
          <span class="timeline-time">0:18</span>
          <div class="timeline-content">
            <strong>Dalgalar 3-4: Uygulama + İnceleme Zinciri</strong>
            <p>2×T3 paralel uygulama. Ardından 2×T2 → 2×T1 sıralı inceleme zinciri.</p>
          </div>
        </div>
      </div>

      <div class="walkthrough-insights">
        <h4>Neler öğrendik:</h4>
        <ul>
          <li>x10 modunda 2×T5 ve 2×T4 paralel çalışarak hem mimari hem güvenlik aynı anda analiz edilir</li>
          <li>/graphify god node'ları otomatik tespit eder (degree &gt; 15)</li>
          <li>/ctx bulguları bir sonraki oturumda yeniden kullanmak için dizinler</li>
          <li>İnceleme zinciri 2×T2 + 2×T1 ile güvenlik ve mimari ayrı ayrı onaylanır</li>
        </ul>
      </div>
    </div>
  </details>

  <div class="callout callout-warning">
    <strong>Uyarı — Bütçeyi gerçekçi belirleyin:</strong> Tam x10 çalıştırması için 25-35 dakika planlayın. Kurulum, paralel dalgalar ve inceleme zincirinin hepsi zaman alır. Sıkışık son teslim tarihlerinde x10 oturumu planlamayın.
  </div>

  <h3 id="workflow-caveman">3.5 /caveman Kullanımı</h3>

  <p>Caveman modu, Orkestratörden kullanıcıya giden düz metni %40-65 sıkıştırır. Kod blokları, dosya yolları, tanımlayıcılar ve güvenlik metinleri hiçbir zaman sıkıştırılmaz.</p>

  <div class="example example-single">
    <div class="example-header">
      <span class="example-icon" aria-hidden="true">⚡</span>
      <span class="example-title">/caveman</span>
      <span class="example-tag">Slash Komut</span>
    </div>
    <div class="example-body">
      <div class="example-input">
        <h4>Kullanıcı yazar:</h4>
        <pre><code class="language-bash">/caveman
Linter'ı çalıştır ve hataları düzelt x5</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
      </div>
      <div class="example-output">
        <h4>Sistem yapar:</h4>
        <ol class="example-steps">
          <li>Caveman bayrağı ayarlanır</li>
          <li>x5 modu tetiklenir (T1-T5)</li>
          <li>Orkestratör çıktısı sıkıştırılır</li>
          <li>Kod/yol/tanımlayıcılar değişmez</li>
        </ol>
      </div>
    </div>
    <div class="example-note">
      <strong>Ne zaman kullanılır:</strong> Hızlı iterasyon, debug oturumları, fazla metin istemediğinizde.
    </div>
  </div>

  <p>Yan yana karşılaştırma:</p>

  <div class="decision-table-wrapper">
    <table class="decision-table">
      <thead>
        <tr>
          <th>Normal mod</th>
          <th>Caveman modu</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>"Şimdi hata ayıklamak için log'ları inceleyecek ve kod yolunu takip edeceğim."</td>
          <td>"Hata ayıklanıyor. Log'lar ve kod yolu kontrol ediliyor."</td>
        </tr>
        <tr>
          <td>"Projedeki ihlalleri belirlemek için şimdi linter'ı çalıştıracağım."</td>
          <td>"Linter çalışıyor."</td>
        </tr>
        <tr>
          <td>"Tarama tamamlandığında, bulduğum her sorunu düzelteceğim ve nelerin değiştiğini bildireceğim."</td>
          <td>"Düzeltilecek ve bildirilecek."</td>
        </tr>
      </tbody>
    </table>
  </div>

  <p>Her iki modda da kod blokları birebir aynı kalır:</p>
  <pre><code class="language-typescript">// Her iki modda da aynı:
async function validateToken(token: string): Promise&lt;UserClaim&gt; {
  const decoded = jwt.verify(token, JWT_SECRET);
  return decoded as UserClaim;
}</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>

  <div class="callout callout-warning">
    <strong>/caveman Ne Zaman Kullanılmaz:</strong> Mimari kararlar, güvenlik uyarıları, yıkıcı eylem onayları ve git onay iletişim kutuları için caveman modundan kaçının. Bu otomatik açıklık istisnaları, moddan bağımsız olarak her zaman kapsamlı kalır.
  </div>

  <p>Devre dışı bırakma: Ayrıntılı çıktıya dönmek için <code>stop caveman</code> veya <code>normal mode</code> yazın.</p>

  <h4 id="combo-caveman-x5-heading">Örnek: /caveman + x5 Kombinasyonu</h4>

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
      Sıkıştırılmış çıktı + tam ekip modu. Orta karmaşıklıktaki refactoring'lerde hızlı iterasyon için kullanın.
    </p>

    <div class="combined-example-block">
      <div class="combined-input">
        <h4>Kullanıcı yazar:</h4>
        <pre><code class="language-bash">/caveman
Auth modülünü refactor et, JWT + OAuth 2.0 destek ekle x5</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
      </div>
      <div class="combined-response">
        <h4>Orkestratör yanıtı (sıkıştırılmış):</h4>
        <pre><code>Analyzing auth requirements. JWT + OAuth 2.0 integration.

Wave 1: T5 research security standards
Wave 2: T4 consolidates findings
Wave 3: T2 design services, T3 implement endpoints
Wave 4: Reviews

Cost: ~$4-6 | Time: 12-15 min</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
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
          <strong>Dalga 1: T5 Araştırma</strong>
          <p>OAuth 2.0 örüntülerini araştırır, JWT entegrasyonunu analiz eder.</p>
        </div>
      </div>
      <div class="step">
        <span class="step-number" aria-label="Step 3">3</span>
        <div class="step-content">
          <strong>Dalga 2: T4 Konsolidasyon</strong>
          <p>Bulguları mimari bir özete dönüştürür.</p>
        </div>
      </div>
      <div class="step">
        <span class="step-number" aria-label="Step 4">4</span>
        <div class="step-content">
          <strong>Dalga 3: T2 Tasarım + T3 Uygulama (Paralel)</strong>
          <p>T2 servisleri tasarlar, T3 endpoint'leri uygular.</p>
        </div>
      </div>
      <div class="step">
        <span class="step-number" aria-label="Step 5">5</span>
        <div class="step-content">
          <strong>Dalga 4: İnceleme Zinciri</strong>
          <p>T3→T2→T1 sıralı inceleme. Yalnızca Orkestratör çıktısı sıkıştırılır.</p>
        </div>
      </div>
    </div>

    <div class="callout callout-tip">
      <span class="callout-icon" aria-hidden="true">💡</span>
      <div class="callout-body">
        <strong class="callout-title">Neden bu kombinasyon?</strong>
        <p>Caveman modu yalnızca Orkestratör'ün düz metin çıktısını sıkıştırır (%40-65). Kod blokları, dosya yolları ve komutlar byte-by-byte korunur. x5 tam inceleme zincirini çalıştırır. Birlikte: hız + kalite.</p>
      </div>
    </div>
  </div>

  <h3 id="workflow-ctx">3.6 /ctx Kullanımı (Context-Mode)</h3>

  <p>Context-mode, bağlam penceresi dolmasını önler. Araç çıktıları izole alt süreçlerde çalışır; yalnızca sonuçlar bağlama girer. Oturum durumu, SQLite + FTS5 aracılığıyla sıkıştırma sonrasında da kalıcı olarak saklanır.</p>

  <p>Tipik iş akışı:</p>
  <pre><code class="language-bash"># Adım 1: Context-mode'u etkinleştir
/ctx

# Adım 2: Bağlamı kirletmeden ağır analiz çalıştır
ctx_execute("shell", "find src/ -name '*.ts' -type f | wc -l")
# Çıktı: "248" (~10 belirteç vs ~500 ham çıktı)

# Adım 3: Büyük dosyayı işle (yalnızca sonuç bağlama girer)
ctx_execute_file("src/services/user-service.ts", "shell", "wc -l &lt; $FILE_CONTENT_PATH")
# Çıktı: "342 lines" (dosya bağlama yüklenmedi)

# Adım 4: Oturumlar arası yeniden kullanım için bulguları dizinle
ctx_index("auth-module-analysis-2026-05-22", findings_content, "prose")

# Adım 5: Önceki oturumları ara
ctx_search("JWT security refresh token rotation", limit=5)</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>

  <div class="callout callout-success">
    <strong>Belirteç Tasarrufu:</strong> x10 oturumu başına yaklaşık %76 (tahmini 50.000 → 12.000 belirteç). 11 adet <code>ctx_*</code> MCP aracı toplu olarak uzun oturumlardaki bağlam baskısını azaltır.
  </div>

  <p>Tam araç referansı için bkz. <a href="#context-mode-ref">Bölüm 5.1</a>.</p>

  <h3 id="workflow-graphify">3.7 /graphify Kullanımı</h3>

  <p>Graphify, 20'den fazla dosya içeren kod tabanlarından sorgulanabilir bilgi grafları oluşturur. Mimari sorular için toplu dosya-grep işlemini ortadan kaldırır.</p>

  <p>Komutlar:</p>
  <pre><code class="language-bash"># Graf oluştur (kod yerel olarak işlenir, API çağrısı yok)
/graphify . --local-only

# Raporu oku
cat graphify-out/GRAPH_REPORT.md

# En yüksek dereceli ilk 5 tanrı-düğümünü sorgula
jq '.nodes | sort_by(-.degree) | .[0:5] | .[] | .id' graphify-out/graph.json</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>

  <p>Çıktı dosyaları:</p>
  <div class="decision-table-wrapper">
    <table class="decision-table">
      <thead>
        <tr><th>Dosya</th><th>Amaç</th></tr>
      </thead>
      <tbody>
        <tr>
          <td><code>graphify-out/graph.json</code></td>
          <td>Sorgulanabilir graf (oturumlar arasında kalıcı)</td>
        </tr>
        <tr>
          <td><code>graphify-out/GRAPH_REPORT.md</code></td>
          <td>Tanrı düğümleri + şaşırtıcı bağlantı özeti</td>
        </tr>
        <tr>
          <td><code>graphify-out/graph.html</code></td>
          <td>Etkileşimli tarayıcı görselleştirmesi</td>
        </tr>
      </tbody>
    </table>
  </div>

  <p>Örnek <code>graph.json</code> yapısı:</p>
  <pre><code class="language-json">{
  "nodes": [{"id": "UserService", "type": "class", "degree": 42, "community": 1}],
  "edges": [{"source": "UserService", "target": "DatabaseRepository", "type": "calls"}],
  "metadata": {"god_nodes": ["UserService"], "surprising_connections": []}
}</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>

  <div class="callout callout-warning">
    <strong>Uyarı — Her zaman --local-only kullanın:</strong> <code>--local-only</code> kullanılmazsa kod içeriği harici LLM API'lerine gönderilebilir. <code>--mode deep</code> seçeneğini yalnızca hangi verilerin paylaşıldığını tam olarak anlayarak kullanın.
  </div>

  <p>Bayat işaret protokolü: Graf önbelleği <code>graphify-out/.graphify-stale</code> dosyası olup olmadığını kontrol ederek doğrulanır. Bayat işaret varsa <code>/graphify . --local-only</code> ile yeniden oluşturun.</p>

  <h3 id="workflow-combined">3.8 Araçları Birleştirme</h3>

  <p>Graphify ve context-mode birbirini tamamlar: graphify topoloji farkındalığı sağlar, context-mode ise bulguları oturumlar arasında korur.</p>

  <pre><code class="language-bash"># Adım 1: Graf oluştur
/graphify . --local-only

# Adım 2: Raporu bağlama oku
cat graphify-out/GRAPH_REPORT.md

# Adım 3: Oturumlar arası yeniden kullanım için raporu dizinle
ctx_index("codebase-topology-2026-05-22", graph_report_content, "prose")

# Adım 4: Tüm dosyaları okumadan hedefli analiz çalıştır
jq '.edges[] | select(.source == "UserService")' graphify-out/graph.json

# Adım 5: Varsa önceki oturumları ara
ctx_search("UserService god node architecture dependencies")</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>

  <p>Belirteç tasarrufu: Graf oluşturma için ~500 belirteç + jq sorgusu başına ~200 = ham dosya okumaya kıyasla yaklaşık 20.000 bağlam belirteç tasarrufu.</p>

  <h4 id="combo-ctx-graphify-heading">Detaylı Örnek: /ctx + /graphify Kombinasyonu</h4>

  <div class="example example-combined" data-combo="ctx-graphify" id="combo-ctx-graphify">
    <div class="combined-header">
      <div class="combined-badges">
        <span class="badge badge-tool">/ctx</span>
        <span class="combined-plus" aria-hidden="true">+</span>
        <span class="badge badge-tool">/graphify</span>
      </div>
      <h3 class="combined-title">/ctx + /graphify — Kalıcı Bilgi Grafı</h3>
      <p class="combined-meta">
        <span class="combined-meta-item">⏱ 5-10 dk</span>
        <span class="combined-meta-item">💰 ~$1-2</span>
        <span class="combined-meta-item">🤖 2 Agent</span>
      </p>
    </div>

    <p class="combined-intro">
      Graphify topoloji farkındalığı sağlar; ctx_index bulguları sonraki oturumlar için kalıcı kılar. Büyük kod tabanlarında en güçlü birleşimdir.
    </p>

    <div class="combined-example-block">
      <div class="combined-input">
        <h4>Kullanıcı yazar:</h4>
        <pre><code class="language-bash">/graphify . --local-only
/ctx
ctx_index("codebase-topology-2026-05-22",
  graphify_report_content, "prose")</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
      </div>
      <div class="combined-response">
        <h4>Sonraki oturumda:</h4>
        <pre><code class="language-bash">ctx_search("UserService god node architecture")
# Ham dosya okumak yerine
# dizinlenmiş rapordan döner
# (~200 belirteç vs ~5KB bağlam)</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
      </div>
    </div>

    <div class="combined-walkthrough">
      <h4>Adım adım akış:</h4>
      <div class="step">
        <span class="step-number" aria-label="Step 1">1</span>
        <div class="step-content">
          <strong>Graf Oluştur</strong>
          <p><code>/graphify . --local-only</code> — ~500 belirteç. graph.json + GRAPH_REPORT.md üretilir.</p>
        </div>
      </div>
      <div class="step">
        <span class="step-number" aria-label="Step 2">2</span>
        <div class="step-content">
          <strong>Raporu Oku ve Dizinle</strong>
          <p><code>cat graphify-out/GRAPH_REPORT.md</code> ardından <code>ctx_index</code> ile FTS5 bilgi tabanına kaydet.</p>
        </div>
      </div>
      <div class="step">
        <span class="step-number" aria-label="Step 3">3</span>
        <div class="step-content">
          <strong>Sonraki Oturumda Yeniden Kullan</strong>
          <p><code>ctx_search</code> ile 60 dosyayı tekrar okumadan aynı bulguları geri getir.</p>
        </div>
      </div>
    </div>

    <div class="comparison-table-wrapper">
      <table>
        <thead>
          <tr>
            <th>Yaklaşım</th>
            <th>İlk Oturum</th>
            <th>Sonraki Oturum</th>
            <th>Tasarruf</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Ham dosya okuma</td>
            <td>~20.000 belirteç</td>
            <td>~20.000 belirteç</td>
            <td>—</td>
          </tr>
          <tr>
            <td>graphify + ctx_index</td>
            <td>~800 belirteç</td>
            <td>~200 belirteç</td>
            <td>~%99</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="callout callout-tip">
      <span class="callout-icon" aria-hidden="true">💡</span>
      <div class="callout-body">
        <strong class="callout-title">Neden bu kombinasyon?</strong>
        <p>Graf ~500 belirteç maliyetiyle oluşturulur; her sorgu yalnızca ~200 belirteç. 60 ham dosya okumak ~20.000 belirteç. İlk oturumdan itibaren kârlıdır.</p>
      </div>
    </div>
  </div>

  <h3 id="combo-test-gen-x3">3.9 /test-gen + x3 — Test Üretimi + İnceleme</h3>

  <div class="example example-combined" data-combo="test-gen-x3" id="combo-test-gen-x3">
    <div class="combined-header">
      <div class="combined-badges">
        <span class="badge badge-tool">/test-gen</span>
        <span class="combined-plus" aria-hidden="true">+</span>
        <span class="badge badge-tool">x3</span>
      </div>
      <h3 class="combined-title">/test-gen + x3 — Test Üretimi + İnceleme</h3>
      <p class="combined-meta">
        <span class="combined-meta-item">⏱ 8-10 dk</span>
        <span class="combined-meta-item">💰 ~$2-3</span>
        <span class="combined-meta-item">🤖 3 Agent</span>
      </p>
    </div>

    <p class="combined-intro">
      Uygulama dosyasından otomatik test suite üretir, ardından T1 ve T2 kaliteyi onaylar. AAA örüntüsü, mutlu yol + hata yolu + sınır koşulları garantilenir.
    </p>

    <div class="combined-example-block">
      <div class="combined-input">
        <h4>Kullanıcı yazar:</h4>
        <pre><code class="language-bash">/test-gen src/features/auth/auth-service.ts x3</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
      </div>
      <div class="combined-response">
        <h4>Üretilen test alıntısı:</h4>
        <pre><code class="language-typescript">describe('AuthService', () => {
  describe('validateToken', () => {
    it('should return claims when token is valid',
      async () =&gt; {
        const validToken = generateTestJWT(
          { sub: 'user-123' });
        const result = await authService
          .validateToken(validToken);
        expect(result.sub).toBe('user-123');
    });

    it('should throw UnauthorizedError when expired',
      async () =&gt; {
        const expiredToken = generateTestJWT(
          { exp: Date.now() / 1000 - 3600 });
        await expect(authService
          .validateToken(expiredToken))
          .rejects.toThrow(UnauthorizedError);
    });
  });
});</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
      </div>
    </div>

    <div class="combined-walkthrough">
      <h4>Adım adım akış:</h4>
      <div class="step">
        <span class="step-number" aria-label="Step 1">1</span>
        <div class="step-content">
          <strong>Dalga 1: T5 Test Örüntüsü Araştırması</strong>
          <p>AAA örüntüsü, mutlu yol + hata yolu + sınır koşulları için test senaryoları belirlenir.</p>
        </div>
      </div>
      <div class="step">
        <span class="step-number" aria-label="Step 2">2</span>
        <div class="step-content">
          <strong>Dalga 2: T2 İnceleme</strong>
          <p>Üretilen testleri inceler, eksik senaryoları işaretler. Sonuç: ✅ Onaylandı.</p>
        </div>
      </div>
      <div class="step">
        <span class="step-number" aria-label="Step 3">3</span>
        <div class="step-content">
          <strong>Dalga 3: T1 Nihai Onay</strong>
          <p>Mimari uygunluğu doğrular. Test suite kullanıma hazır.</p>
        </div>
      </div>
    </div>

    <div class="callout callout-success">
      <span class="callout-icon" aria-hidden="true">✅</span>
      <div class="callout-body">
        <strong class="callout-title">Sonuç</strong>
        <p>İncelenmiş test suite. Mutlu yol, hata yolu ve sınır koşulları garantili. Manuel test yazımına kıyasla %80+ zaman tasarrufu.</p>
      </div>
    </div>
  </div>

  <nav class="prev-next-nav" aria-label="Bölüm navigasyonu">
    <a href="#core-concepts" class="prev-next-prev">← Önceki: Temel Kavramlar</a>
    <a href="#advanced-topics" class="prev-next-next">Sonraki → İleri Konular</a>
  </nav>
</article>
```

## Section 4: İleri Düzey Konular

```html
<article id="section-advanced-topics">
  <header class="section-header">
    <span class="section-meta">Bölüm 4 · ~40 dk</span>
    <span class="difficulty-tag difficulty-advanced">Zorluk: İleri</span>
  </header>

  <h2 id="advanced-topics">4. İleri Konular</h2>

  <p>Bu bölüm, sistemi özelleştiren ileri düzey yapılandırmaları kapsar: özel beceriler, kancalar, ajan şablonları, öz-öğrenme döngüsü, maliyet optimizasyonu ve yükseltme yönetimi.</p>

  <h3 id="custom-skills">4.1 Özel Beceri Oluşturma</h3>

  <p>Beceriler, <code>.claude/skills/{isim}/</code> dizinlerinde saklanan yeniden kullanılabilir slash komutlarıdır. Her becerinin tetikleyici koşulları ve davranışı belirten bir <code>SKILL.md</code> dosyası vardır.</p>

  <pre><code class="language-bash"># Beceri dizini oluştur
mkdir -p .claude/skills/myteam-deploy

# Ön yüz (frontmatter) ve gövdeyle SKILL.md oluştur
cat &gt; .claude/skills/myteam-deploy/SKILL.md &lt;&lt;'EOF'
---
name: myteam-deploy
description: Ekip dağıtım politikası
triggers:
  - /myteam-deploy
---

# Tetikleyici: /myteam-deploy slash komutu aracılığıyla çağrılır
# Gövde: Orkestratöre ekibin dağıtım politikasını bildirir

Bu beceri çağrıldığında:
1. Staging ortamında testleri doğrula
2. Güvenlik taramasını çalıştır
3. Onay için bekle
4. Production'a dağıt
EOF</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>

  <p>Beceriler, Skill aracının kullanılabilir listesinde otomatik olarak görünür. Orkestratör, kullanıcı isteği üzerine onlara yönlendirebilir.</p>

  <h3 id="custom-hooks">4.2 Özel Kancalar</h3>

  <p>Kancalar, Claude Code platformu tarafından belirli araç olaylarında tetiklenen shell script'leridir. Araç girdisi argüman olarak verilmek üzere proje çalışma dizininde çalışırlar.</p>

  <p>Kanca yapısı:</p>
  <pre><code class="language-bash"># Dosya: .claude/hooks/custom-credential-check.sh
# Ön-Edit kancası: sabit kodlu değerleri engeller

#!/bin/bash
# 1. JSON stdin'den file_path ve içeriği oku
INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
CONTENT=$(echo "$INPUT" | jq -r '.tool_input.new_content // empty')

# 2. Yasaklı örüntülere karşı regex denetimi uygula
if echo "$CONTENT" | grep -qE '(password|secret|api_key)\s*=\s*"[^"]{8,}"'; then
  echo "BLOCKED: Sabit kodlu kimlik bilgisi tespit edildi" &gt;&amp;2
  exit 1  # 3. Engellemek için stderr mesajıyla 1 çık
fi

exit 0  # izin vermek için 0 çık</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>

  <pre><code class="language-bash"># Çalıştırılabilir yap
chmod +x .claude/hooks/custom-credential-check.sh

# .claude/settings.json içindeki hooks.PreToolUse.Edit'e kaydet</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>

  <div class="callout callout-warning">
    <strong>Uyarı — Çıkış kodları önemlidir:</strong> <code>1</code> çıkışı araç çağrısını engeller. <code>0</code> çıkışı buna izin verir. <code>2</code> çıkışı uyarır ama devam eder. <code>stderr</code>, Claude'a hata mesajı olarak gösterilir.
  </div>

  <h3 id="custom-agents">4.3 Özel Ajan Şablonları</h3>

  <p>Her seviyenin <code>.claude/agents/{rol}.md</code> içinde varsayılan bir şablonu vardır. Yeni şablonlar oluşturup delegasyon kurallarını güncelleyerek alana özgü varyantlar (örneğin T3-React) ekleyebilirsiniz.</p>

  <pre><code class="language-markdown"># Dosya: .claude/agents/mid-coder-react.md
# T3 MidCoder - React Uzmanı

[Standart T3 şablon başlığı]

## React Özel Yönergeleri

### Bileşen Yapısı
- Dosya başına bir bileşen
- İşlevsel bileşenler + kancalar
- Sunum ve container bileşenleri ayırın

### Ant Design Entegrasyonu
- antd'den içe aktarın (antd/es değil)
- Renkler için theme.useToken() kullanın
- Boşluklar için rem birimiyle css kullanın</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>

  <p>Orkestratör, görev <code>*.tsx</code> dosyalarına dokunduğunda standart T3 yerine <code>mid-coder-react</code>'ı koşullu olarak başlatabilir.</p>

  <h3 id="learned-patterns">4.4 Bellek ve Öğrenilen Kalıplar</h3>

  <p>Öz-öğrenme döngüsü, tekrarlanan inceleme reddedilmelerini kalıcı örüntülere dönüştürür. Örüntü dosyaları <code>.claude/memory/learned-patterns/</code> içinde yaşar ve bir sonraki başlatmada ajan istemlerine enjekte edilir.</p>

  <p>Yaşam döngüsü:</p>
  <pre><code>hata oluşur -&gt; self-learning-collector.sh aynı dosyaya 2+ düzenleme tespit eder
              -&gt; hit-count: 0 ile LP-{id}.md oluşturur
              |
              v
        aktif örüntü, ajan istemlerine enjekte edilir
              |
              v
hit-count &gt;= 3 -&gt; .claude/rules/learned-{kategori}.md'ye yükseltilir
                  (işaretleyicili yıkıcı olmayan ekleme)

sessions-since-hit &gt;= 5 VE hit-count == 0
            -&gt; .claude/memory/learned-patterns/archive/'ye arşivlenir
               (kurtarılabilir, silinmez)</code></pre>

  <p>Örüntü dosyası yapısı (ön yüz + gövde):</p>
  <pre><code class="language-markdown">---
pattern-id: LP-0042
category: react
hit-count: 0
last-triggered: null
sessions-since-hit: 0
---

# Hata: useEffect'te Eksik Bağımlılıklar

## Hata
Harici durum değişkenleriyle useEffect kullanan ama bunları bağımlılık
dizisine dahil etmeyen kod (eski kapanış riski).

## Düzeltme
Tüm harici değişkenleri bağımlılık dizisine dahil edin ya da işlev
referanslarını sabitlemek için useCallback kullanın.

## Kural
Harici değişken referansları olan her useEffect, bu değişkenleri bağımlılık
dizisinde listelemelidir.

## Bağlam
React 18+, eski kapanışları ve sonsuz döngüleri önlemek için bağımlılık
dizileri gerektirir.</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>

  <p>Etki: başlatılan sonraki T3 ajanı bu örüntüyü "Dikkat Edilecek Noktalar" altında görür.</p>

  <h4 id="combo-ctx-long-session-heading">Örnek: /ctx + Uzun Session Kombinasyonu</h4>

  <div class="example example-combined" data-combo="ctx-long-session" id="combo-ctx-long-session">
    <div class="combined-header">
      <div class="combined-badges">
        <span class="badge badge-tool">/ctx</span>
        <span class="combined-plus" aria-hidden="true">+</span>
        <span class="badge badge-tool">Uzun Session</span>
      </div>
      <h3 class="combined-title">/ctx + Uzun Session — Bilgi Kalıcılığı</h3>
      <p class="combined-meta">
        <span class="combined-meta-item">⏱ Çok günlük</span>
        <span class="combined-meta-item">💰 Değişken</span>
        <span class="combined-meta-item">🤖 Değişken</span>
      </p>
    </div>

    <p class="combined-intro">
      Çok günlük migrasyon projesinde bağlam dolup taştığında, ctx_index ile bulgular korunur ve sonraki oturumda ctx_search ile geri alınır. Hiçbir analiz kaybolmaz.
    </p>

    <div class="combined-example-block">
      <div class="combined-input">
        <h4>Session 1 (bağlam dolmadan önce):</h4>
        <pre><code class="language-bash"># Bulguları dizinle
ctx_index("session-checkpoint-1",
  auth_findings, "prose")
ctx_index("session-checkpoint-2",
  security_findings, "prose")</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
      </div>
      <div class="combined-response">
        <h4>Session 2 (yeni oturum):</h4>
        <pre><code class="language-bash"># Önceki bulguları geri al
ctx_search(
  "auth security findings prior session",
  limit=5)
# FTS5'ten döner, dosyalardan değil
# ~10 belirteç vs ~5.000 belirteç</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
      </div>
    </div>

    <div class="combined-walkthrough">
      <h4>3 maddelik protokol:</h4>
      <div class="step">
        <span class="step-number" aria-label="Step 1">1</span>
        <div class="step-content">
          <strong>Her önemli bulguyu dizinleyin</strong>
          <p>T5 analiz raporunu tamamladıktan sonra <code>ctx_index</code> ile FTS5 bilgi tabanına kaydedin.</p>
        </div>
      </div>
      <div class="step">
        <span class="step-number" aria-label="Step 2">2</span>
        <div class="step-content">
          <strong>Session sıkıştırma öncesi kontrol noktası</strong>
          <p>Bağlam büyükse <code>ctx_index("session-checkpoint-N", ...)</code> ile ara kayıt yapın.</p>
        </div>
      </div>
      <div class="step">
        <span class="step-number" aria-label="Step 3">3</span>
        <div class="step-content">
          <strong>Yeni oturumda ctx_search ile geri alın</strong>
          <p>Dosyaları yeniden okumak yerine <code>ctx_search</code> ile BM25 sıralı arama yapın.</p>
        </div>
      </div>
    </div>

    <div class="callout callout-info">
      <span class="callout-icon" aria-hidden="true">ℹ️</span>
      <div class="callout-body">
        <strong class="callout-title">Belirteç Tasarrufu</strong>
        <p>Session 1: 100 belirteç (ctx_index) → Session 2: 10 belirteç (ctx_search) vs 5.000 belirteç (dosya yeniden okuma). Uzun projeler için kritik.</p>
      </div>
    </div>
  </div>

  <h3 id="cost-optimization">4.5 Maliyet Optimizasyonu</h3>

  <p>Belirteç maliyetleri, haiku ile opus arasında ~12 kat farklılık gösterir. Orkestrasyon sistemi, ortalama maliyeti düşük tutmak için bilinçli bir şekilde delegasyon yapar.</p>

  <div class="decision-table-wrapper">
    <table class="decision-table">
      <thead>
        <tr>
          <th>Görev türü</th>
          <th>Önerilen mod</th>
          <th>Tahmini maliyet</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Yazım hatası düzeltme, tek satır</td>
          <td><span class="badge badge-mode badge-mode-single">Tek ajan</span></td>
          <td><span class="cost-indicator cost-free">~$0.05</span></td>
        </tr>
        <tr>
          <td>Açıklama / Soru-Cevap</td>
          <td><span class="badge badge-mode badge-mode-single">Tek ajan</span></td>
          <td><span class="cost-indicator cost-free">~$0.20-0.50</span></td>
        </tr>
        <tr>
          <td>Hata düzeltme, 2-3 dosya</td>
          <td><span class="badge badge-mode badge-mode-x3">x3</span></td>
          <td><span class="cost-indicator cost-low">~$2-3</span></td>
        </tr>
        <tr>
          <td>Küçük özellik (tek modül)</td>
          <td><span class="badge badge-mode badge-mode-x3">x4</span></td>
          <td><span class="cost-indicator cost-low">~$3-4</span></td>
        </tr>
        <tr class="decision-recommended">
          <td>Standart özellik (tam zincir)</td>
          <td><span class="badge badge-mode badge-mode-x5">x5</span></td>
          <td><span class="cost-indicator cost-medium">~$4-6</span></td>
        </tr>
        <tr>
          <td>Paralel özellik izleri</td>
          <td><span class="badge badge-mode badge-mode-x7">x7</span></td>
          <td><span class="cost-indicator cost-high">~$7-10</span></td>
        </tr>
        <tr>
          <td>Kritik sistem revizyonu</td>
          <td><span class="badge badge-mode badge-mode-x10">x10</span></td>
          <td><span class="cost-indicator cost-very-high">~$12-18</span></td>
        </tr>
      </tbody>
    </table>
  </div>

  <div class="decision-table-wrapper">
    <table class="decision-table">
      <thead>
        <tr>
          <th>Görev</th>
          <th>Tek opus</th>
          <th>Çoklu ajan (x5)</th>
          <th>Tasarruf</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Küçük API uç noktası</td>
          <td>$8-10</td>
          <td>$1-2</td>
          <td>%80-90</td>
        </tr>
        <tr>
          <td>Özellik (500 satır)</td>
          <td>$15-20</td>
          <td>$4-6</td>
          <td>%70-80</td>
        </tr>
        <tr>
          <td>Sistem yeniden tasarımı</td>
          <td>$35-50</td>
          <td>$12-18</td>
          <td>%65-75</td>
        </tr>
      </tbody>
    </table>
  </div>

  <div class="callout callout-success">
    <strong>İpucu:</strong> Araştırma için T1 ($0.75/görev) yerine önce T5 kullanın ($0.05/görev). T5 ham bulgular üretir; T4 bunları birleştirir; yalnızca bundan sonra tasarım çalışması daha yüksek seviyelere ulaşır.
  </div>

  <h3 id="escalation">4.6 Yükseltme İşlemi</h3>

  <p>Bir seviye incelemeyi iki kez geçemediğinde (<code>revision_attempts</code> = 2), görev otomatik olarak bir üst seviyeye yükseltilir. Yeni ajan, tam bağlamla birlikte yapılandırılmış bir tohum istem alır.</p>

  <p>Revizyon sayacı durum makinesi:</p>
  <pre><code>T3 ilk girişim
  ├── ✅ Onaylandı → tamamlandı
  ├── ⚠️ Revizyon Gerekli (revision_attempts = 1) → T3 yeniden başlatıldı
  │     ├── ✅ Onaylandı → tamamlandı
  │     └── ⚠️ Revizyon Gerekli (revision_attempts = 2) → ZORUNLU YÜKSELTME
  │           └── ❌ Reddedildi → T2'ye yükselt (sayaç sıfırlanır)
  └── ❌ Reddedildi → T2'ye yükselt (sayaç sıfırlanır)</code></pre>

  <p>Yükseltme tohum formatı (zorunlu):</p>
  <pre><code class="language-markdown">## Yükseltme Bağlamı
Önceki ajan: T{n} | Revizyon turları: 2

## Önceki Çıktı
{başarısız ajanın son çıktısı}

## İnceleme Bulguları
{önem derecesiyle etiketlenmiş tüm inceleyici yorumları}

## Göreviniz
{orijinal görev açıklaması}</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>

  <p>Sayaç sıfırlama kuralı: <code>revision_attempts</code> yalnızca T{n+1}'e yükseltilirken sıfırlanır. Aynı seviye içindeki yeniden başlatmalar sayacın artmaya devam etmesine neden olur.</p>

  <h3 id="agent-selection">4.7 Puan Ağırlıklı Ajan Seçimi</h3>

  <p>Her seviyenin adlandırılmış ajanlardan oluşan bir havuzu vardır. Seçim, yüksek performanslı kişilerin daha fazla yüksek görünürlüklü görev almasını sağlarken tüm ajanların çalışmaya devam etmesini sağlayan puan ağırlıklı rastgele örnekleme kullanır.</p>

  <p>Ağırlık formülü: <code>weight = base_score × tier_multiplier</code></p>

  <p>Seviye çarpanları:</p>
  <div class="decision-table-wrapper">
    <table class="decision-table">
      <thead>
        <tr>
          <th>Kademe</th>
          <th>Puan aralığı</th>
          <th>Çarpan</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>A-kademe</td>
          <td>&gt; 20</td>
          <td>1.5x</td>
        </tr>
        <tr>
          <td>B-kademe</td>
          <td>0–19</td>
          <td>1.0x</td>
        </tr>
        <tr>
          <td>C-kademe</td>
          <td>-20 ile -1 arası</td>
          <td>0.8x</td>
        </tr>
        <tr>
          <td>D-kademe</td>
          <td>&lt; -20</td>
          <td>0.6x</td>
        </tr>
      </tbody>
    </table>
  </div>

  <p>Puan değişimleri:</p>
  <div class="decision-table-wrapper">
    <table class="decision-table">
      <thead>
        <tr>
          <th>Olay</th>
          <th>Değişim</th>
        </tr>
      </thead>
      <tbody>
        <tr><td>Görev tamamlandı</td><td>+5</td></tr>
        <tr><td>Görev başarısız</td><td>-5</td></tr>
        <tr><td>Kod incelemesi ilk geçişte</td><td>+3</td></tr>
        <tr><td>İnceleme ikinci geçişte</td><td>+1</td></tr>
        <tr><td>İnceleme 3+ tur</td><td>-3</td></tr>
        <tr><td>P0/P1 sorun bulundu</td><td>+4</td></tr>
        <tr><td>Yanlış pozitif</td><td>-2</td></tr>
        <tr><td>Gereksiz yükseltme</td><td>-2</td></tr>
        <tr><td>Model yedeği</td><td>-1</td></tr>
      </tbody>
    </table>
  </div>

  <p>Etki: A-kademe ajanları B-kademe'ye kıyasla %50, D-kademe'ye kıyasla ~3.4 kat daha fazla seçilme olasılığına sahiptir. Tüm ajanlar zaman içinde çalışmaya devam eder.</p>

  <h3 id="combo-graphify-t5-t4">4.8 graphify + T5 + T4 — Mimari Analiz</h3>

  <div class="example example-combined" data-combo="graphify-t5-t4" id="combo-graphify-t5-t4">
    <div class="combined-header">
      <div class="combined-badges">
        <span class="badge badge-tool">/graphify</span>
        <span class="combined-plus" aria-hidden="true">+</span>
        <span class="badge badge-tier-T5">T5</span>
        <span class="combined-plus" aria-hidden="true">+</span>
        <span class="badge badge-tier-T4">T4</span>
      </div>
      <h3 class="combined-title">graphify + T5 + T4 — Mimari Analiz</h3>
      <p class="combined-meta">
        <span class="combined-meta-item">⏱ 8-12 dk</span>
        <span class="combined-meta-item">💰 ~$1-2</span>
        <span class="combined-meta-item">🤖 2 Agent</span>
      </p>
    </div>

    <p class="combined-intro">
      60 dosyalı kod tabanında tanrı sınıflarını tespit eder ve refactoring planı oluşturur. T5 graphify çıktısını analiz eder, T4 bulgulardan somut eylem planı çıkarır.
    </p>

    <div class="combined-example-block">
      <div class="combined-input">
        <h4>Kullanıcı yazar:</h4>
        <pre><code class="language-bash">Codebase'deki god classes'ı tespit et
ve refactoring planı oluştur x5</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
      </div>
      <div class="combined-response">
        <h4>T5 ham bulgu özeti:</h4>
        <pre><code># Tanrı Sınıfı Analizi

1. UserService (degree: 42) — KRİTİK
   - SRP ihlali: auth, profil, ayarlar,
     bildirimler
   - 4 servise ayrılması önerilir

2. DatabaseRepository (degree: 28) — YÜKSEK
   - 18 farklı servis tarafından kullanılıyor

3. AuthController (degree: 22) — ORTA
   - Karışık sorumluluklar</code></pre>
      </div>
    </div>

    <div class="combined-walkthrough">
      <h4>Adım adım akış:</h4>
      <div class="step">
        <span class="step-number" aria-label="Step 1">1</span>
        <div class="step-content">
          <strong>Dalga 1: T5 Grafı Oluşturur ve Sorgular</strong>
          <pre><code class="language-bash">/graphify . --local-only
jq '.nodes | map(select(.degree > 15))
  | sort_by(-.degree)' graphify-out/graph.json</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
        </div>
      </div>
      <div class="step">
        <span class="step-number" aria-label="Step 2">2</span>
        <div class="step-content">
          <strong>Dalga 2: T4 Refactoring Planı Oluşturur</strong>
          <p>T5 bulgularını somut ayrıştırma planına dönüştürür: hangi sınıf nereye bölünür, bağımlılıklar nasıl güncellenir.</p>
        </div>
      </div>
    </div>

    <div class="comparison-table-wrapper">
      <table>
        <thead>
          <tr>
            <th>Sınıf</th>
            <th>Derece (degree)</th>
            <th>Risk</th>
            <th>Eylem</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>UserService</td>
            <td>42</td>
            <td>🔴 Kritik</td>
            <td>4 servise böl</td>
          </tr>
          <tr>
            <td>DatabaseRepository</td>
            <td>28</td>
            <td>🟠 Yüksek</td>
            <td>Sorgu örüntülerini çıkar</td>
          </tr>
          <tr>
            <td>AuthController</td>
            <td>22</td>
            <td>🟡 Orta</td>
            <td>2 controller'a böl</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="callout callout-tip">
      <span class="callout-icon" aria-hidden="true">💡</span>
      <div class="callout-body">
        <strong class="callout-title">Pro İpucu: Graf yalnızca ilk çalıştırmada oluşturulur</strong>
        <p>Aynı oturumda birden fazla graphify sorgusu yapıyorsanız yeniden oluşturmaya gerek yoktur. <code>graphify-out/.graphify-stale</code> yoksa mevcut grafiği kullanın.</p>
      </div>
    </div>
  </div>

  <h3 id="combo-x10-graphify">4.9 x10 + /graphify — Tam Sistem Denetimi</h3>

  <div class="example example-combined" data-combo="x10-graphify" id="combo-x10-graphify">
    <div class="combined-header">
      <div class="combined-badges">
        <span class="badge badge-tool">x10</span>
        <span class="combined-plus" aria-hidden="true">+</span>
        <span class="badge badge-tool">/graphify</span>
      </div>
      <h3 class="combined-title">x10 + /graphify — Tam Sistem Denetimi</h3>
      <p class="combined-meta">
        <span class="combined-meta-item">⏱ 20-30 dk</span>
        <span class="combined-meta-item">💰 ~$14-20</span>
        <span class="combined-meta-item">🤖 10 Agent</span>
      </p>
    </div>

    <p class="combined-intro">
      Tüm sistemi denetler: tanrı sınıfları, güvenlik açıkları, test coverage boşlukları, performans darboğazları. 2×T5 paralel araştırma + 2×T4 konsolidasyon + 2×T2+2×T3 uygulama + tam inceleme zinciri.
    </p>

    <div class="combined-example-block">
      <div class="combined-input">
        <h4>Kullanıcı yazar:</h4>
        <pre><code class="language-bash">Tüm codebase'i audit et:
- God classes ve refactoring
- Test coverage boşlukları
- Security issues
- Bulguları düzelt.
x10 /graphify /ctx</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
      </div>
      <div class="combined-response">
        <h4>Sonuç metrikleri:</h4>
        <pre><code>| Metrik         | Önce | Sonra |
|----------------|------|-------|
| Max god degree | 42   | 12    |
| Test coverage  | 68%  | 92%   |
| Security issues| 5    | 0     |
| Cohesion score | 0.62 | 0.78  |</code></pre>
      </div>
    </div>

    <div class="wave-breakdown">
      <h4>Dalga yapısı:</h4>
      <div class="wave-item">
        <span class="wave-label wave-1">Dalga 1</span>
        <span class="wave-content">2×T5 paralel: T5-A topoloji analizi (graphify), T5-B güvenlik denetimi</span>
      </div>
      <div class="wave-item">
        <span class="wave-label wave-2">Dalga 2</span>
        <span class="wave-content">2×T4 paralel: T4-A mimari özeti, T4-B güvenlik özeti</span>
      </div>
      <div class="wave-item">
        <span class="wave-label wave-3">Dalga 3</span>
        <span class="wave-content">2×T2 tasarım + 2×T3 uygulama paralel (4 ajan eş zamanlı)</span>
      </div>
      <div class="wave-item">
        <span class="wave-label wave-4">Dalga 4+</span>
        <span class="wave-content">İnceleme zinciri: 2×T2 → 2×T1 sıralı onay</span>
      </div>
    </div>

    <div class="comparison-table-wrapper">
      <table>
        <thead>
          <tr>
            <th>Metrik</th>
            <th>Önce</th>
            <th>Sonra</th>
            <th>Değişim</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Max god node degree</td>
            <td>42</td>
            <td>12</td>
            <td>-71%</td>
          </tr>
          <tr>
            <td>Ortalama servis degree</td>
            <td>18</td>
            <td>8</td>
            <td>-56%</td>
          </tr>
          <tr>
            <td>Codebase cohesion</td>
            <td>0.62</td>
            <td>0.78</td>
            <td>+26%</td>
          </tr>
          <tr>
            <td>Test coverage</td>
            <td>68%</td>
            <td>92%</td>
            <td>+24%</td>
          </tr>
          <tr>
            <td>Güvenlik bulguları</td>
            <td>5</td>
            <td>0</td>
            <td>%100 düzeltildi</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="callout callout-warning">
      <span class="callout-icon" aria-hidden="true">⚠️</span>
      <div class="callout-body">
        <strong class="callout-title">Uyarı — Maliyet ve Süre</strong>
        <p>x10 + /graphify kombinasyonu $14-20 maliyetle 20-30 dakika sürer. Sıkışık son teslim tarihlerinde planlamayın. Önce x5 ile küçük kapsamda test edin.</p>
      </div>
    </div>
  </div>

  <h3 id="combo-ctx-long-session-2">4.10 /ctx + Uzun Session — Bilgi Kalıcılığı</h3>

  <p>Bu kombinasyon <a href="#learned-patterns">Bölüm 4.4</a>'te detaylı örnekle ele alınmıştır. Kısa referans için:</p>

  <div class="example example-combined" data-combo="ctx-long-session" id="combo-ctx-long-session-2">
    <div class="combined-header">
      <div class="combined-badges">
        <span class="badge badge-tool">/ctx</span>
        <span class="combined-plus" aria-hidden="true">+</span>
        <span class="badge badge-tool">Uzun Session</span>
      </div>
      <h3 class="combined-title">/ctx + Uzun Session — Protokol Özeti</h3>
      <p class="combined-meta">
        <span class="combined-meta-item">Session 1: 100 belirteç</span>
        <span class="combined-meta-item">Session 2: 10 belirteç</span>
        <span class="combined-meta-item">Tasarruf: ~%99</span>
      </p>
    </div>

    <p class="combined-intro">
      Çok günlük projelerde bağlam yönetimi için temel protokol.
    </p>

    <div class="combined-example-block">
      <div class="combined-input">
        <h4>Session 1 — Dizinle:</h4>
        <pre><code class="language-bash">ctx_index(
  "migrasyon-session-1",
  analiz_bulgulari,
  "prose"
)</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
      </div>
      <div class="combined-response">
        <h4>Session 2 — Ara:</h4>
        <pre><code class="language-bash">ctx_search(
  "migrasyon auth güvenlik bulgular",
  limit=5
)
# Dosya yeniden okuma YOK
# BM25 sıralı sonuçlar</code><button class="copy-btn" onclick="copyToClipboard(this)" aria-label="Kodu panoya kopyala">📋 Kopyala</button></pre>
      </div>
    </div>

    <div class="callout callout-tip">
      <span class="callout-icon" aria-hidden="true">💡</span>
      <div class="callout-body">
        <strong class="callout-title">3 Maddelik Protokol</strong>
        <ul>
          <li>Her T5 analiz raporunu tamamladıktan sonra <code>ctx_index</code> ile kaydedin</li>
          <li>Bağlam büyükse ara kontrol noktaları oluşturun</li>
          <li>Yeni oturumda dosya okumak yerine <code>ctx_search</code> kullanın</li>
        </ul>
      </div>
    </div>
  </div>

  <nav class="prev-next-nav" aria-label="Bölüm navigasyonu">
    <a href="#common-workflows" class="prev-next-prev">← Önceki: Yaygın İş Akışları</a>
    <a href="#tools-reference" class="prev-next-next">Sonraki → Araçlar Referansı</a>
  </nav>
</article>
```

## Sidebar Nav Updates (Section 3 and 4)

```html
<!-- Section 3 nav-sublist additions -->
<li><a href="#combo-test-gen-x3" class="nav-sublink">3.9 /test-gen + x3</a></li>

<!-- Section 4 nav-sublist additions -->
<li><a href="#combo-graphify-t5-t4" class="nav-sublink">4.8 graphify + T5 + T4</a></li>
<li><a href="#combo-x10-graphify" class="nav-sublink">4.9 x10 + /graphify</a></li>
<li><a href="#combo-ctx-long-session" class="nav-sublink">4.10 /ctx + Uzun Session</a></li>
```
