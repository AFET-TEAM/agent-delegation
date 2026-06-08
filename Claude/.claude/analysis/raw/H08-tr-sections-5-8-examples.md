---
task-id: H08
agent: Canan Birsen
tier: T3
model: sonnet
session: 2026-05-22-html-tr-examples-x10
status: Complete
sections: 5-8
combined-examples: 6
walkthroughs: W3
date: 2026-05-22
---

<!-- ============================================================
     SECTION 5: ARAÇLAR REFERANSI
     ============================================================ -->

<section id="section-5" class="doc-section">
  <h2>5. Araçlar Referansı</h2>

  <!-- 5.1 context-mode MCP Araçları -->
  <h3 id="section-5-1">5.1 context-mode MCP Araçları</h3>
  <p>
    context-mode, analizleri izole bir alt süreçte çalıştırarak yalnızca sonuçların ana bağlama girmesini sağlar.
    Bu sayede büyük dosyalar veya uzun çıktılar token bütçesini tüketmez; <code>ctx_index</code> ile
    bilgiler SQLite+FTS5 tabanlı kalıcı bir bilgi tabanına yazılır ve <code>ctx_search</code> ile
    oturumlar arası erişilebilir hale gelir.
  </p>

  <div class="callout callout-tip">
    <strong>Token Tasarrufu:</strong> 10 KB üzeri dosyaları doğrudan bağlama yüklemek yerine
    <code>ctx_execute_file</code> kullanın — yalnızca özet bağlama girer, ham dosya girmez.
    Tipik tasarruf: %70–90.
  </div>

  <!-- Tool Card: ctx_execute -->
  <article class="tool-card" id="tool-ctx-execute">
    <div class="tool-card-header">
      <div class="title-row">
        <h4 class="tool-card-name">ctx_execute</h4>
        <span class="tool-tag">context-mode</span>
      </div>
    </div>
    <div class="tool-card-signature">
      <code>ctx_execute(type: "shell", command: string) → string</code>
    </div>
    <p class="tool-desc">
      Verilen kabuk komutunu izole alt süreçte çalıştırır; yalnızca stdout çıktısı bağlama döner.
      Büyük dizin taramaları, grep aramaları ve istatistik komutları için kullanılır.
    </p>
    <div class="tool-example-block">
<pre><code>// Kaynak dosya sayısını token harcamadan say
ctx_execute("shell", "find src/auth -name '*.ts' | wc -l")
// → "42 files"

// Belirli bir deseni ara
ctx_execute("shell", "grep -r 'getUserById' src/ --include='*.ts' -l")
// → "src/features/user/user-service.ts\nsrc/features/user/user-repo.ts"</code></pre>
    </div>
    <div class="tool-when">
      <strong>Ne zaman kullanılır:</strong> Çıktı 5 KB üzerindeyse, geniş dizin taramalarında,
      grep/wc/find benzeri filtreleme komutlarında.
    </div>
    <div class="tool-when-not">
      <strong>Ne zaman kullanılmaz:</strong> Sonuç küçük ve doğrudan Read aracıyla okunabiliyorsa;
      güvenilmeyen string'ler parametre olarak geçiliyorsa.
    </div>
  </article>

  <!-- Tool Card: ctx_execute_file -->
  <article class="tool-card" id="tool-ctx-execute-file">
    <div class="tool-card-header">
      <div class="title-row">
        <h4 class="tool-card-name">ctx_execute_file</h4>
        <span class="tool-tag">context-mode</span>
      </div>
    </div>
    <div class="tool-card-signature">
      <code>ctx_execute_file(filePath: string, type: "shell", command: string) → string</code>
    </div>
    <p class="tool-desc">
      Büyük bir dosyayı alt sürece yükler; <code>$FILE_CONTENT_PATH</code> ortam değişkeni
      üzerinden erişilir. Yalnızca komutun döndürdüğü çıktı bağlama girer.
    </p>
    <div class="tool-example-block">
<pre><code>// 1847 satırlık dosyadan yalnızca satır sayısını al
ctx_execute_file(
  "src/services/massive-service.ts",
  "shell",
  "wc -l < $FILE_CONTENT_PATH"
)
// → "1847 lines"

// Dosyadaki tüm export edilen fonksiyonları listele
ctx_execute_file(
  "src/features/auth/auth-service.ts",
  "shell",
  "grep -n '^export' $FILE_CONTENT_PATH"
)
// → "12:export const login = ...\n45:export const refresh = ..."</code></pre>
    </div>
    <div class="tool-when">
      <strong>Ne zaman kullanılır:</strong> T4/T5 analistleri yalnızca analiz ettiği dosyalar için;
      10 KB üzeri herhangi bir dosya için.
    </div>
    <div class="tool-when-not">
      <strong>Ne zaman kullanılmaz:</strong> T3 MidCoder düzenleyeceği dosyayı Read ile okuyabilir
      (dosya sahipliği kuralı geçerlidir).
    </div>
  </article>

  <!-- Tool Card: ctx_batch_execute -->
  <article class="tool-card" id="tool-ctx-batch-execute">
    <div class="tool-card-header">
      <div class="title-row">
        <h4 class="tool-card-name">ctx_batch_execute</h4>
        <span class="tool-tag">context-mode</span>
      </div>
    </div>
    <div class="tool-card-signature">
      <code>ctx_batch_execute(commands: Array&lt;{type, command}&gt;) → string[]</code>
    </div>
    <p class="tool-desc">
      Birden fazla bağımsız komutu paralel olarak çalıştırır; en fazla 8 eş zamanlı süreç desteklenir.
      Bağımsız metrik toplamalarını hızlandırmak için idealdir.
    </p>
    <div class="tool-example-block">
<pre><code>ctx_batch_execute([
  { type: "shell", command: "find src -name '*.ts' | wc -l" },
  { type: "shell", command: "find src -name '*.test.ts' | wc -l" },
  { type: "shell", command: "grep -r 'console.log' src --include='*.ts' | wc -l" }
])
// → ["142 files", "38 test files", "0 console.log violations"]</code></pre>
    </div>
    <div class="tool-when">
      <strong>Ne zaman kullanılır:</strong> Birbirinden bağımsız 3+ metrik aynı anda toplanacaksa.
    </div>
    <div class="tool-when-not">
      <strong>Ne zaman kullanılmaz:</strong> Komutlar birbirine bağımlıysa (sıralı çalışması gerekenler).
    </div>
  </article>

  <!-- Tool Card: ctx_index -->
  <article class="tool-card" id="tool-ctx-index">
    <div class="tool-card-header">
      <div class="title-row">
        <h4 class="tool-card-name">ctx_index</h4>
        <span class="tool-tag">context-mode</span>
      </div>
    </div>
    <div class="tool-card-signature">
      <code>ctx_index(source: string, content: string, type: "prose" | "code") → void</code>
    </div>
    <p class="tool-desc">
      Metni kalıcı SQLite+FTS5 bilgi tabanına yazar. Oturumlar arası erişilebilir; bir sonraki
      oturumda <code>ctx_search</code> ile bulunabilir. T5 analistleri raporu tamamladıktan
      sonra bu aracı çağırmalıdır.
    </p>
    <div class="tool-example-block">
<pre><code>// T5 analiz raporunu bilgi tabanına yaz
ctx_index(
  "auth-module-analysis-2026-05-22",
  "## Bulgular\n\nUserService god class tespit edildi...",
  "prose"
)

// T4 konsolidasyon raporunu indeksle
ctx_index(
  "consolidated-H07-2026-05-22",
  consolidatedReportText,
  "prose"
)</code></pre>
    </div>
    <div class="tool-when">
      <strong>Ne zaman kullanılır:</strong> T5 raporu tamamlandığında, T4 konsolidasyonundan sonra,
      büyük harici döküman alındığında.
    </div>
    <div class="tool-when-not">
      <strong>Ne zaman kullanılmaz:</strong> Kimlik bilgileri veya API anahtarları içeren içerik asla
      indekslenmez.
    </div>
  </article>

  <!-- Tool Card: ctx_search -->
  <article class="tool-card" id="tool-ctx-search">
    <div class="tool-card-header">
      <div class="title-row">
        <h4 class="tool-card-name">ctx_search</h4>
        <span class="tool-tag">context-mode</span>
      </div>
    </div>
    <div class="tool-card-signature">
      <code>ctx_search(query: string, limit?: number) → SearchResult[]</code>
    </div>
    <p class="tool-desc">
      BM25 algoritmasıyla bilgi tabanında tam metin arama yapar. Oturumlar arası bağlam sürekliliği
      sağlar — context compaction sonrası dosya yeniden okumak yerine bu araç kullanılmalıdır.
      Hız sınırı: saniyede 10 sorgu.
    </p>
    <div class="tool-example-block">
<pre><code>// Önceki oturumdan JWT bulgularını ara
const results = ctx_search("JWT security refresh token rotation", limit=5)
// → [{ source: "auth-module-2026-05-21", score: 0.94, excerpt: "..." }, ...]

// Belirli bir modül hakkında önceki analizi bul
ctx_search("UserService god class decomposition", limit=3)</code></pre>
    </div>
    <div class="tool-when">
      <strong>Ne zaman kullanılır:</strong> Context compaction sonrasında önceki bulguları geri yüklerken;
      başka T5 ajanının bu oturumdaki bulgularını ararken.
    </div>
    <div class="tool-when-not">
      <strong>Ne zaman kullanılmaz:</strong> Dar döngüde (rate limit aşılır); henüz indekslenmemiş içerik için.
    </div>
  </article>

  <!-- Tool Card: ctx_fetch_and_index -->
  <article class="tool-card" id="tool-ctx-fetch-and-index">
    <div class="tool-card-header">
      <div class="title-row">
        <h4 class="tool-card-name">ctx_fetch_and_index</h4>
        <span class="tool-tag">context-mode</span>
      </div>
    </div>
    <div class="tool-card-signature">
      <code>ctx_fetch_and_index(url: string, source: string) → void</code>
    </div>
    <p class="tool-desc">
      Harici bir URL'i alır, içeriği otomatik olarak bilgi tabanına indeksler. Büyük RFC veya
      dokümantasyon sayfalarını bağlama yüklemeden referans olarak saklar.
    </p>
    <div class="tool-example-block">
<pre><code>// JWT RFC'sini bağlama yüklemeden indeksle
ctx_fetch_and_index(
  "https://tools.ietf.org/html/rfc7519",
  "jwt-rfc-7519"
)

// Kütüphane dokümantasyonunu sakla
ctx_fetch_and_index(
  "https://ant.design/components/table",
  "antd-table-docs-2026"
)</code></pre>
    </div>
    <div class="tool-when">
      <strong>Ne zaman kullanılır:</strong> 50 KB üzeri harici döküman analiz edilecekse.
    </div>
    <div class="tool-when-not">
      <strong>Ne zaman kullanılmaz:</strong> 192.168.x.x, 10.x.x.x, 127.0.0.1 gibi iç ağ adreslerine
      asla erişilemez (context-mode-guard.sh tarafından engellenir).
    </div>
  </article>

  <!-- Tool Card: ctx_stats -->
  <article class="tool-card" id="tool-ctx-stats">
    <div class="tool-card-header">
      <div class="title-row">
        <h4 class="tool-card-name">ctx_stats</h4>
        <span class="tool-tag">context-mode</span>
      </div>
    </div>
    <div class="tool-card-signature">
      <code>ctx_stats() → StatsReport</code>
    </div>
    <p class="tool-desc">
      Bilgi tabanı istatistiklerini döndürür: toplam kayıt sayısı, kaynak listesi, disk kullanımı,
      en son indeksleme zamanı.
    </p>
    <div class="tool-example-block">
<pre><code>ctx_stats()
// → {
//   records: 47,
//   sources: ["auth-analysis-2026-05-21", "jwt-rfc-7519", ...],
//   diskMB: 2.3,
//   lastIndexed: "2026-05-22T09:14:33Z"
// }</code></pre>
    </div>
    <div class="tool-when">
      <strong>Ne zaman kullanılır:</strong> Oturum başında bilgi tabanının durumunu kontrol ederken.
    </div>
    <div class="tool-when-not">
      <strong>Ne zaman kullanılmaz:</strong> Döngü içinde sürekli çağrılmaz.
    </div>
  </article>

  <!-- Tool Card: ctx_doctor -->
  <article class="tool-card" id="tool-ctx-doctor">
    <div class="tool-card-header">
      <div class="title-row">
        <h4 class="tool-card-name">ctx_doctor</h4>
        <span class="tool-tag">context-mode</span>
      </div>
    </div>
    <div class="tool-card-signature">
      <code>ctx_doctor() → DiagnosticReport</code>
    </div>
    <p class="tool-desc">
      context-mode kurulumunu doğrular: bağlantı, izinler, CTX_DENY_PATHS yapılandırması,
      rate limit durumu. Kurulum sorunlarını teşhis etmek için kullanılır.
    </p>
    <div class="tool-example-block">
<pre><code>ctx_doctor()
// → {
//   status: "healthy",
//   connection: "ok",
//   denyPaths: ["~/.ssh/", "~/.aws/", "./.env"],
//   rateLimit: "10/s (current: 2/s)",
//   warnings: []
// }</code></pre>
    </div>
    <div class="tool-when">
      <strong>Ne zaman kullanılır:</strong> context-mode araçları beklenmedik davranış gösterdiğinde.
    </div>
    <div class="tool-when-not">
      <strong>Ne zaman kullanılmaz:</strong> Rutin kullanımda gereksiz.
    </div>
  </article>

  <!-- Tool Card: ctx_upgrade -->
  <article class="tool-card" id="tool-ctx-upgrade">
    <div class="tool-card-header">
      <div class="title-row">
        <h4 class="tool-card-name">ctx_upgrade</h4>
        <span class="tool-tag">context-mode</span>
      </div>
    </div>
    <div class="tool-card-signature">
      <code>ctx_upgrade() → UpgradeResult</code>
    </div>
    <p class="tool-desc">
      context-mode MCP sunucusunu en son sürüme günceller. Çalışan bir oturumda bu araç
      çağrılırsa oturum sonlanabilir; güncellemeden önce kritik indeksleme işlemlerini tamamlayın.
    </p>
    <div class="tool-example-block">
<pre><code>ctx_upgrade()
// → { from: "1.2.1", to: "1.3.0", status: "success" }</code></pre>
    </div>
    <div class="tool-when">
      <strong>Ne zaman kullanılır:</strong> Yeni bir oturum başlamadan önce; bakım pencerelerinde.
    </div>
    <div class="tool-when-not">
      <strong>Ne zaman kullanılmaz:</strong> Aktif bir analiz oturumu sırasında.
    </div>
  </article>

  <!-- Tool Card: ctx_purge -->
  <article class="tool-card" id="tool-ctx-purge">
    <div class="tool-card-header">
      <div class="title-row">
        <h4 class="tool-card-name">ctx_purge</h4>
        <span class="tool-tag">context-mode</span>
      </div>
    </div>
    <div class="tool-card-signature">
      <code>ctx_purge(source?: string) → PurgeResult</code>
    </div>
    <p class="tool-desc">
      Belirli bir kaynağı veya tüm bilgi tabanını temizler. Gizli veri içerdiği sonradan fark
      edilen bir kaynağı kaldırmak için kullanılır. Geri alınamaz.
    </p>
    <div class="tool-example-block">
<pre><code>// Belirli kaynağı temizle
ctx_purge("auth-analysis-2026-05-21")
// → { removed: 1, records: 12 }

// Tüm bilgi tabanını sıfırla (dikkatli kullanın)
ctx_purge()
// → { removed: 47, records: 47 }</code></pre>
    </div>
    <div class="tool-when">
      <strong>Ne zaman kullanılır:</strong> Gizli veri indekslendiyse; eski/geçersiz veriler temizlenecekse.
    </div>
    <div class="tool-when-not">
      <strong>Ne zaman kullanılmaz:</strong> Rutin temizlik için — bunun yerine kaynakları iyi adlandırın.
    </div>
  </article>

  <!-- Tool Card: ctx_insight -->
  <article class="tool-card" id="tool-ctx-insight">
    <div class="tool-card-header">
      <div class="title-row">
        <h4 class="tool-card-name">ctx_insight</h4>
        <span class="tool-tag">context-mode</span>
      </div>
    </div>
    <div class="tool-card-signature">
      <code>ctx_insight(query: string) → InsightReport</code>
    </div>
    <p class="tool-desc">
      Bilgi tabanındaki verilerden özet içgörüler ve örüntüler üretir. Birden fazla analiz raporunu
      sentezleyerek üst düzey bulgular çıkarmak için kullanılır.
    </p>
    <div class="tool-example-block">
<pre><code>ctx_insight("auth modülündeki tekrarlayan güvenlik sorunları neler?")
// → {
//   topPatterns: ["JWT secret rotation missing (3 sessions)", "Rate limiting not configured (2 sessions)"],
//   confidence: "High",
//   sources: ["auth-analysis-2026-05-21", "security-audit-2026-05-20"]
// }</code></pre>
    </div>
    <div class="tool-when">
      <strong>Ne zaman kullanılır:</strong> Birden fazla oturumun bulgularını karşılaştırırken;
      tekrarlayan sorunları tespit ederken.
    </div>
    <div class="tool-when-not">
      <strong>Ne zaman kullanılmaz:</strong> Henüz yeterli veri yoksa (en az 3 indekslenmiş kaynak önerilir).
    </div>
  </article>

  <!-- 5.2 graphify Referansı -->
  <h3 id="section-5-2">5.2 graphify — Kod Bilgi Grafiği</h3>
  <p>
    graphify, projeyi AST tabanlı analiz ederek modüller ve sınıflar arasındaki bağımlılık grafiğini
    çıkarır. Sonuç <code>graphify-out/graph.json</code> dosyasına yazılır ve oturumlar arası yeniden
    kullanılabilir. 20'den fazla dosyası olan her kod tabanında kullanımı zorunludur.
  </p>

  <div class="callout callout-tip">
    <strong>Eşik Kuralı:</strong> Analiz kapsamında 20'den fazla dosya varsa graphify kullanımı
    zorunludur. İlk 3 sorguda ~500 token'lık derleme maliyeti karşılanır.
  </div>

  <h4>İnvokasyon Modları</h4>
  <table>
    <thead>
      <tr>
        <th>Komut</th>
        <th>Amaç</th>
        <th>Ne zaman kullanılır</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><code>graphify . --local-only</code></td>
        <td>Yalnızca AST analizi (API çağrısı yok)</td>
        <td>Özel/gizli kod tabanları — her zaman bu mod</td>
      </tr>
      <tr>
        <td><code>graphify . --include-docs</code></td>
        <td>AST + döküman semantik analizi</td>
        <td>Açık kaynak veya halka açık projeler</td>
      </tr>
      <tr>
        <td><code>graphify export --format json --output graphify-out/graph-$(date +%Y%m%d).json</code></td>
        <td>Tarihli snapshot</td>
        <td>Uzun vadeli sürüklenme tespiti</td>
      </tr>
      <tr>
        <td><code>ls graphify-out/.graphify-stale 2>/dev/null && echo "STALE" || echo "FRESH"</code></td>
        <td>Stale marker kontrolü</td>
        <td>Her graph.json kullanımından önce</td>
      </tr>
    </tbody>
  </table>

  <h4>God Node Tespiti</h4>
  <table>
    <thead>
      <tr>
        <th>graphify Metriği</th>
        <th>Kod Kokusu</th>
        <th>Güven</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>degree &gt; 20</td>
        <td>God Class — sınıf çok fazla şey yapıyor</td>
        <td>Yüksek</td>
      </tr>
      <tr>
        <td>degree &gt; 10 AND type=function</td>
        <td>Long Method / Feature Envy</td>
        <td>Orta</td>
      </tr>
      <tr>
        <td>community size &gt; 15</td>
        <td>Shotgun Surgery</td>
        <td>Orta</td>
      </tr>
      <tr>
        <td>cohesion_score &lt; 0.4</td>
        <td>Divergent Change</td>
        <td>Orta</td>
      </tr>
      <tr>
        <td>surprising_connections distance &gt; 3</td>
        <td>Feature Envy</td>
        <td>Düşük</td>
      </tr>
    </tbody>
  </table>

  <h4>Faydalı jq Sorguları</h4>
  <pre><code class="language-bash"># En yüksek degree'li 5 node (god class adayları)
jq '.nodes | sort_by(-.degree) | .[0:5] | .[] | .id' graphify-out/graph.json

# Belirli bir node'un tüm komşuları
jq '.edges[] | select(.source == "UserService")' graphify-out/graph.json

# Topluluk üyeleri
jq '.communities[] | select(.id == 1) | .nodes' graphify-out/graph.json

# Node tipine göre dağılım
jq '.nodes | group_by(.type) | map({type: .[0].type, count: length})' graphify-out/graph.json</code></pre>

  <h4>Token Bütçesi</h4>
  <table>
    <thead>
      <tr>
        <th>İşlem</th>
        <th>Tahmini Token</th>
        <th>Ne zaman kullanılır</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Graf derleme (yalnızca kod)</td>
        <td>~500</td>
        <td>İlk kullanım veya stale sonrası</td>
      </tr>
      <tr>
        <td>GRAPH_REPORT.md okuma</td>
        <td>~300</td>
        <td>Derlemeden sonra her zaman</td>
      </tr>
      <tr>
        <td>query_graph("god_nodes")</td>
        <td>~200</td>
        <td>Mimari soru</td>
      </tr>
      <tr>
        <td>get_neighbors("NodeName")</td>
        <td>~100</td>
        <td>Bağımlılık soruşturması</td>
      </tr>
      <tr>
        <td>Ham dosya okuma (~300 satır)</td>
        <td>~2.000</td>
        <td>Yalnızca satır numarası kanıtı gerektiğinde</td>
      </tr>
      <tr>
        <td>10 ham dosya okuma</td>
        <td>~20.000</td>
        <td>Kaçınılmalı — graphify tercih edilmeli</td>
      </tr>
    </tbody>
  </table>

  <!-- 5.3 Slash Komutları Referansı -->
  <h3 id="section-5-3">5.3 Slash Komutları Referansı</h3>

  <div class="tab-group" data-tabs="slash-commands">
    <nav class="tab-nav" role="tablist">
      <button class="tab-btn active" role="tab" data-target="tab-caveman">/caveman</button>
      <button class="tab-btn" role="tab" data-target="tab-graphify">/graphify</button>
      <button class="tab-btn" role="tab" data-target="tab-ctx">/ctx</button>
      <button class="tab-btn" role="tab" data-target="tab-review">/review</button>
      <button class="tab-btn" role="tab" data-target="tab-security-review">/security-review</button>
      <button class="tab-btn" role="tab" data-target="tab-architect">/architect</button>
      <button class="tab-btn" role="tab" data-target="tab-test-gen">/test-gen</button>
    </nav>

    <div id="tab-caveman" class="tab-panel active">
      <h5>/caveman</h5>
      <p>Orkestratör çıktısını %40–65 oranında sıkıştırır. Kod, dosya yolları, tanımlayıcılar ve
         güvenlik uyarıları hiçbir zaman sıkıştırılmaz.</p>
      <pre><code>Ekle ve commit et /caveman
// → Orkestratör kısa cümle parçalarıyla yanıt verir
//   Alt ajan görevleri değişmez — tam talimatlar gider</code></pre>
      <p><strong>Devre dışı bırakma:</strong> "stop caveman" veya "normal mode"</p>
      <p><strong>Not:</strong> "caveman" kelimesi kod bloğu içindeyse tetiklenmez.</p>
    </div>

    <div id="tab-graphify" class="tab-panel">
      <h5>/graphify</h5>
      <p>graphify'ı projeye karşı çalıştırır: stale marker kontrolü → gerekirse derleme →
         GRAPH_REPORT.md özeti. T5 analistlerine otomatik yönlendirir.</p>
      <pre><code>/graphify src/
// → graph.json oluşturuldu (veya önbellek kullanıldı)
// → 142 node, 423 edge, 7 topluluk
// → God node: UserService (degree 42)</code></pre>
      <p><strong>Güvenlik:</strong> <code>--local-only</code> bayrağı zorunludur özel kod için;
         hook tarafından uygulanır.</p>
    </div>

    <div id="tab-ctx" class="tab-panel">
      <h5>/ctx</h5>
      <p>context-mode'u etkinleştirir. Tüm uygun bash komutları <code>ctx_execute</code>
         eşdeğerlerine yönlendirilir; T4/T5 analistleri büyük dosyalar için <code>ctx_execute_file</code>
         kullanmak zorundadır.</p>
      <pre><code>/ctx
// → context-mode aktif
// → Sonraki analiz komutları izole alt süreçte çalışır
// → Yalnızca sonuçlar bağlama girer</code></pre>
    </div>

    <div id="tab-review" class="tab-panel">
      <h5>/review</h5>
      <p>Güncel değişiklikler için standart kod inceleme zincirini başlatır: T2 Staff Engineer
         kod kalitesini, T1 Principal mimariyi inceler.</p>
      <pre><code>/review src/features/auth/
// → T2: Kod kalitesi, hata işleme, test kapsamı incelendi
// → T1: SOLID uyumu, mimari uyum incelendi
// → Bulgular önem derecesiyle raporlandı</code></pre>
    </div>

    <div id="tab-security-review" class="tab-panel">
      <h5>/security-review</h5>
      <p>Güvenlik odaklı kod inceleme zincirini başlatır. SQL injection, XSS, path traversal,
         gizlenmiş kimlik bilgileri ve CORS yapılandırması kontrol edilir.</p>
      <pre><code>/security-review src/
// → SQL injection taraması: Temiz
// → XSS vektörleri: 0 bulgu
// → Hardcoded secrets: api-config.ts:23 — KRİTİK
// → CORS: Wildcard origin — YÜKSEK</code></pre>
    </div>

    <div id="tab-architect" class="tab-panel">
      <h5>/architect</h5>
      <p>Görevi doğrudan T1 Principal (opus) ajanına yönlendirir. xN parametresi gerekmez.
         Mimari kararlar, ADR yazımı veya yüksek riskli tasarım soruları için kullanılır.</p>
      <pre><code>/architect microservice migration strategy
// → T1 Principal (opus) doğrudan devralır
// → ADR taslağı + risk analizi + 3 seçenek karşılaştırması</code></pre>
      <p><strong>Not:</strong> /architect yalnızca Orkestratör tarafından yönlendirilebilir;
         alt ajanlar bu komutu kullanamaz.</p>
    </div>

    <div id="tab-test-gen" class="tab-panel">
      <h5>/test-gen</h5>
      <p>Belirtilen kaynak dosyadan kapsamlı test paketi üretir. T5 Analyst mevcut davranışı
         analiz eder; T2 Staff Engineer AAA kalıbında Jest veya pytest testleri yazar.
         Mutlu yol, hata yolları ve sınır koşullarını kapsar.</p>
      <pre><code>/test-gen src/features/auth/auth-service.ts x3
// → T5: Tüm public metotlar + hata senaryoları analiz edildi
// → T2: AAA kalıbında Jest describe bloğu üretildi
// → T1: Test kalitesi onaylandı — 23 test, %94 dal kapsamı</code></pre>
      <p><strong>Ne zaman kullanılır:</strong> Mevcut bir servis veya modül için retroaktif test
         kapsamı gerektiğinde; TDD akışında sürüm geçişlerinde.</p>
      <p><strong>Not:</strong> x3 veya üstü mod önerilir — T5 analiz dalgası olmadan yazılan
         testler yanlış beklentiler içerebilir.</p>
    </div>
  </div>
</section>

<!-- ============================================================
     SECTION 6: YAPILANDIRMA
     ============================================================ -->

<section id="section-6" class="doc-section">
  <h2>6. Yapılandırma</h2>

  <!-- 6.1 settings.json -->
  <h3 id="section-6-1">6.1 settings.json Yapısı</h3>
  <p>
    Claude Code'un hook sistemi <code>.claude/settings.json</code> dosyasıyla yapılandırılır.
    Tüm hook kayıtları bu dosyada tanımlanır; dosyada yorum satırı bulunmamalıdır.
  </p>

  <pre><code class="language-json">{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [
          { "type": "command", "command": ".claude/hooks/console-log-check.sh" },
          { "type": "command", "command": ".claude/hooks/any-type-check.sh" },
          { "type": "command", "command": ".claude/hooks/inline-comment-check.sh" },
          { "type": "command", "command": ".claude/hooks/inline-style-check.sh" },
          { "type": "command", "command": ".claude/hooks/hardcoded-color-check.sh" },
          { "type": "command", "command": ".claude/hooks/sql-injection-check.sh" },
          { "type": "command", "command": ".claude/hooks/xss-prevention-check.sh" },
          { "type": "command", "command": ".claude/hooks/path-traversal-check.sh" },
          { "type": "command", "command": ".claude/hooks/cors-wildcard-check.sh" },
          { "type": "command", "command": ".claude/hooks/field-injection-check.sh" },
          { "type": "command", "command": ".claude/hooks/secret-detection.sh" }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": ".claude/hooks/git-safety-check.sh" },
          { "type": "command", "command": ".claude/hooks/context-mode-guard.sh" }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [
          { "type": "command", "command": ".claude/hooks/review-tracker.sh" },
          { "type": "command", "command": ".claude/hooks/self-learning-collector.sh" },
          { "type": "command", "command": ".claude/hooks/analysis-scope-guard.sh" }
        ]
      }
    ],
    "SessionEnd": [
      {
        "hooks": [
          { "type": "command", "command": ".claude/hooks/update-leaderboard.sh" },
          { "type": "command", "command": ".claude/hooks/pattern-lifecycle.sh" },
          { "type": "command", "command": ".claude/hooks/graphify-rebuild.sh" }
        ]
      }
    ]
  }
}</code></pre>

  <!-- 6.2 Hook Kataloğu -->
  <h3 id="section-6-2">6.2 Hook Kataloğu (19 Hook)</h3>

  <h4>Grup 1: PreToolUse — Edit/Write/MultiEdit (11 Hook)</h4>
  <table>
    <thead>
      <tr>
        <th>Hook Dosyası</th>
        <th>Amaç</th>
        <th>Çıkış Kodu</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><code>console-log-check.sh</code></td>
        <td>console.log/warn/error/debug ifadelerini engeller</td>
        <td>exit 1 = engelle</td>
      </tr>
      <tr>
        <td><code>any-type-check.sh</code></td>
        <td>TypeScript <code>any</code> tipi kullanımını engeller</td>
        <td>exit 1 = engelle</td>
      </tr>
      <tr>
        <td><code>inline-comment-check.sh</code></td>
        <td>// ve /* */ yorum satırlarını engeller (JSDoc hariç)</td>
        <td>exit 1 = engelle</td>
      </tr>
      <tr>
        <td><code>inline-style-check.sh</code></td>
        <td>style="..." satır içi stilleri engeller</td>
        <td>exit 1 = engelle</td>
      </tr>
      <tr>
        <td><code>hardcoded-color-check.sh</code></td>
        <td>Doğrudan hex renk kodlarını engeller</td>
        <td>exit 1 = engelle</td>
      </tr>
      <tr>
        <td><code>sql-injection-check.sh</code></td>
        <td>SQL string birleştirme kalıplarını engeller</td>
        <td>exit 1 = engelle</td>
      </tr>
      <tr>
        <td><code>xss-prevention-check.sh</code></td>
        <td>XSS vektörü içeren çıktı kalıplarını engeller</td>
        <td>exit 1 = engelle</td>
      </tr>
      <tr>
        <td><code>path-traversal-check.sh</code></td>
        <td>Dosya yollarında <code>..</code> ve <code>~</code> kullanımını engeller</td>
        <td>exit 1 = engelle</td>
      </tr>
      <tr>
        <td><code>cors-wildcard-check.sh</code></td>
        <td>Production ortamında <code>*</code> CORS kökenini engeller</td>
        <td>exit 1 = engelle</td>
      </tr>
      <tr>
        <td><code>field-injection-check.sh</code></td>
        <td>Java'da <code>@Autowired</code> field enjeksiyonunu engeller</td>
        <td>exit 1 = engelle</td>
      </tr>
      <tr>
        <td><code>secret-detection.sh</code></td>
        <td>API anahtarları ve kimlik bilgisi kalıplarını engeller</td>
        <td>exit 1 = engelle</td>
      </tr>
    </tbody>
  </table>

  <h4>Grup 2: PreToolUse — Bash (2 Hook)</h4>
  <table>
    <thead>
      <tr>
        <th>Hook Dosyası</th>
        <th>Amaç</th>
        <th>Çıkış Kodu</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><code>git-safety-check.sh</code></td>
        <td>Git yazma işlemlerini (commit, push vb.) açık onay olmadan engeller</td>
        <td>exit 1 = engelle (yıkıcı için), exit 0 + uyarı (commit için)</td>
      </tr>
      <tr>
        <td><code>context-mode-guard.sh</code></td>
        <td>ctx_execute komutlarının reddedilen yollara erişimini ve veri sızdırma araçlarını engeller</td>
        <td>exit 1 = engelle</td>
      </tr>
    </tbody>
  </table>

  <h4>Grup 3: PostToolUse — Edit/Write/MultiEdit (3 Hook)</h4>
  <table>
    <thead>
      <tr>
        <th>Hook Dosyası</th>
        <th>Amaç</th>
        <th>Çıkış Kodu</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><code>review-tracker.sh</code></td>
        <td>Dosya başına düzenleme sayısını izler; 5 ve 10 düzenlemede uyarı verir</td>
        <td>exit 0 (kayıt amaçlı)</td>
      </tr>
      <tr>
        <td><code>self-learning-collector.sh</code></td>
        <td>Bir oturumda aynı dosyaya 2+ düzenleme tespit edildiğinde öğrenilen kalıp dosyası oluşturur</td>
        <td>exit 0 (kayıt amaçlı)</td>
      </tr>
      <tr>
        <td><code>analysis-scope-guard.sh</code></td>
        <td>T5 analistini .claude/analysis/raw/, T4'ü .claude/analysis/consolidated/ ile kısıtlar</td>
        <td>exit 1 = kapsam dışı yazma engellenir</td>
      </tr>
    </tbody>
  </table>

  <h4>Grup 4: SessionEnd (3 Hook)</h4>
  <table>
    <thead>
      <tr>
        <th>Hook Dosyası</th>
        <th>Amaç</th>
        <th>Çıkış Kodu</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><code>update-leaderboard.sh</code></td>
        <td>Oturum sonu puan deltalarını lider tablosuna atomik olarak uygular; .session-complete sentinel yayar</td>
        <td>exit 0</td>
      </tr>
      <tr>
        <td><code>pattern-lifecycle.sh</code></td>
        <td>Kalıp hit-count'larını günceller; hit-count ≥ 3 olanları kurallara terfi ettirir; 5+ oturum boş olanları arşivler</td>
        <td>exit 0</td>
      </tr>
      <tr>
        <td><code>graphify-rebuild.sh</code></td>
        <td>Kod değişikliği tespit edildiğinde .graphify-stale marker'ı oluşturur</td>
        <td>exit 0</td>
      </tr>
    </tbody>
  </table>

  <!-- 6.3 Ajan Şablonları -->
  <h3 id="section-6-3">6.3 Ajan Şablonları</h3>
  <table>
    <thead>
      <tr>
        <th>Şablon Dosyası</th>
        <th>Ajan Tipi</th>
        <th>Model</th>
        <th>Ana Sorumluluk</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><code>.claude/agents/principal.md</code></td>
        <td>T1 Principal</td>
        <td>opus</td>
        <td>Mimari inceleme, yüksek riskli tasarım kararları, T2 çıktılarını onaylama</td>
      </tr>
      <tr>
        <td><code>.claude/agents/staff-engineer.md</code></td>
        <td>T2 Staff Engineer</td>
        <td>sonnet</td>
        <td>Karmaşık uygulama, T3 çıktılarını inceleme, SOLID uyumu</td>
      </tr>
      <tr>
        <td><code>.claude/agents/mid-coder.md</code></td>
        <td>T3 MidCoder</td>
        <td>sonnet</td>
        <td>Standart uygulama görevleri, özellik geliştirme</td>
      </tr>
      <tr>
        <td><code>.claude/agents/lead-analyst.md</code></td>
        <td>T4 Lead Analyst</td>
        <td>haiku</td>
        <td>T5 bulgularını konsolide etme, analiz raporlarını inceleme</td>
      </tr>
      <tr>
        <td><code>.claude/agents/analyst.md</code></td>
        <td>T5 Analyst</td>
        <td>haiku</td>
        <td>Ham araştırma, kod taramaları, bağımlılık analizi, rapor yazma</td>
      </tr>
    </tbody>
  </table>

  <!-- 6.4 Kural Dosyaları -->
  <h3 id="section-6-4">6.4 Kural Dosyaları (19 Dosya)</h3>
  <table>
    <thead>
      <tr>
        <th>Kural Dosyası</th>
        <th>Kapsam</th>
        <th>Ana Kurallar</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><code>clean-code.md</code></td>
        <td>Tüm dosyalar</td>
        <td>SOLID, DRY, KISS, YAGNI; maks 20 satır fonksiyon, 250 satır dosya; yorum yasağı</td>
      </tr>
      <tr>
        <td><code>implementation.md</code></td>
        <td>TypeScript</td>
        <td>strict mod, const önceliği, optional chaining, import sıralaması</td>
      </tr>
      <tr>
        <td><code>code-architecture.md</code></td>
        <td>Proje geneli</td>
        <td>Katmanlı mimari, bağımlılık yönü, hexagonal mimari</td>
      </tr>
      <tr>
        <td><code>code-review.md</code></td>
        <td>Gözden geçirme</td>
        <td>Aşama 1-3 gözden geçirme süreci, önem seviyeleri, geri bildirim formatı</td>
      </tr>
      <tr>
        <td><code>backend-development.md</code></td>
        <td>Java/Node.js</td>
        <td>Katmanlı mimari, constructor injection, DTO/Entity ayrımı</td>
      </tr>
      <tr>
        <td><code>backend-security.md</code></td>
        <td>Java güvenlik</td>
        <td>SQL injection, XSS, input validation, JWT, rate limiting</td>
      </tr>
      <tr>
        <td><code>java-quality-tooling.md</code></td>
        <td>Java/Maven</td>
        <td>Checkstyle, SpotBugs, JaCoCo kapsam eşikleri</td>
      </tr>
      <tr>
        <td><code>pr-standards.md</code></td>
        <td>Pull request</td>
        <td>500 satır/15 dosya limiti, şablon, inceleme süresi</td>
      </tr>
      <tr>
        <td><code>commit-standards.md</code></td>
        <td>Git commit</td>
        <td>Conventional commits, 50 karakter konu, imperative mood</td>
      </tr>
      <tr>
        <td><code>analysis.md</code></td>
        <td>.claude/analysis/</td>
        <td>Rapor şablonu, yazma izni sınırları, kalite kriterleri</td>
      </tr>
      <tr>
        <td><code>metrics-tracking.md</code></td>
        <td>.claude/metrics/</td>
        <td>4 hook sorumluluğu, puanlama delta kuralları, kalıp yaşam döngüsü</td>
      </tr>
      <tr>
        <td><code>git-safety.md</code></td>
        <td>Bash komutları</td>
        <td>Git yazma işlemlerine açık onay zorunluluğu</td>
      </tr>
      <tr>
        <td><code>caveman.md</code></td>
        <td>Orkestratör çıktısı</td>
        <td>Tetikleyici tespiti, stil kuralları, değişmez içerik listesi</td>
      </tr>
      <tr>
        <td><code>graphify-usage.md</code></td>
        <td>.claude/agents/</td>
        <td>20 dosya eşiği, stale marker protokolü, god node eşleştirmesi</td>
      </tr>
      <tr>
        <td><code>context-mode-usage.md</code></td>
        <td>.claude/agents/</td>
        <td>Zorunlu yönlendirme tablosu, büyük dosya yasağı, güvenlik kısıtlamaları</td>
      </tr>
      <tr>
        <td><code>api-integration.md</code></td>
        <td>API entegrasyonları</td>
        <td>REST/GraphQL entegrasyon kalıpları, hata işleme, retry stratejileri</td>
      </tr>
      <tr>
        <td><code>react-patterns.md</code></td>
        <td>React bileşenleri</td>
        <td>Hook kalıpları, bileşen mimarisi, performans optimizasyonu</td>
      </tr>
      <tr>
        <td><code>scss-standards.md</code></td>
        <td>SCSS/CSS</td>
        <td>CSS değişkenleri, BEM notasyonu, responsive tasarım kuralları</td>
      </tr>
      <tr>
        <td><code>testing.md</code></td>
        <td>Test yazımı</td>
        <td>Jest/Vitest/pytest standartları, test kapsamı gereksinimleri, mock stratejileri</td>
      </tr>
      <tr>
        <td><code>learned-security.md</code> (oluşturulabilir)</td>
        <td>Otomatik</td>
        <td>hit-count ≥ 3 olan öğrenilen güvenlik kalıpları (pattern-lifecycle.sh tarafından eklenir)</td>
      </tr>
      <tr>
        <td><code>learned-architecture.md</code> (oluşturulabilir)</td>
        <td>Otomatik</td>
        <td>hit-count ≥ 3 olan öğrenilen mimari kalıplar (pattern-lifecycle.sh tarafından eklenir)</td>
      </tr>
    </tbody>
  </table>
</section>

<!-- ============================================================
     SECTION 7: SORUN GİDERME
     ============================================================ -->

<section id="section-7" class="doc-section">
  <h2>7. Sorun Giderme</h2>

  <!-- 7.1 Yaygın Hatalar ve Kurtarma -->
  <h3 id="section-7-1">7.1 Yaygın Hatalar ve Kurtarma</h3>

  <table>
    <thead>
      <tr>
        <th>Belirti</th>
        <th>Olası Neden</th>
        <th>Kurtarma Adımı</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Hook exit 1 — işlem engellendi</td>
        <td>İhlal tespit edildi (console.log, any tipi, yorum vb.)</td>
        <td>stderr mesajını okuyun, ihlali düzeltin, aracı yeniden çalıştırın</td>
      </tr>
      <tr>
        <td>Ajan revision_attempts = 2 — otomatik yükseltme</td>
        <td>Aynı tier'da 2 başarısız revizyon</td>
        <td>Orkestratör seed prompt ile bir üst tier'a yükseltir; manuel müdahale gerekmez</td>
      </tr>
      <tr>
        <td>graph.json STALE uyarısı</td>
        <td>.graphify-stale marker var — kod değişikliği sonrası</td>
        <td><code>graphify . --local-only</code> çalıştırın, marker'ı silin</td>
      </tr>
      <tr>
        <td>ctx_search 0 sonuç döndü</td>
        <td>İçerik henüz indekslenmemiş veya arama terimi yanlış</td>
        <td>ctx_stats ile indekslenmiş kaynakları kontrol edin; gerekirse ctx_index çalıştırın</td>
      </tr>
      <tr>
        <td>Token bütçesi aşıldı</td>
        <td>Çok büyük dosyalar doğrudan bağlama yüklendi</td>
        <td>ctx_execute_file kullanın; graphify ile ham dosya okumayı azaltın</td>
      </tr>
      <tr>
        <td>Lider tablosu puanları güncellenmedi</td>
        <td>update-leaderboard.sh settings.json'da kayıtlı değil</td>
        <td>settings.json SessionEnd kısmını doğrulayın</td>
      </tr>
      <tr>
        <td>Analiz kapsamı dışı yazma engellendi</td>
        <td>T5 consolidated/ veya T4 raw/ yazmaya çalıştı</td>
        <td>analysis-scope-guard.sh'ın doğru tier'a atanmış olduğunu kontrol edin</td>
      </tr>
    </tbody>
  </table>

  <!-- 7.2 Hook Hata Ayıklama -->
  <h3 id="section-7-2">7.2 Hook Hata Ayıklama</h3>
  <p>
    Hook'ların beklenen davranışı gösterip göstermediğini doğrulamak için her hook'u
    gerçek bir dosyayla manuel olarak test edin:
  </p>

  <pre><code class="language-bash"># Hook çıkış kodunu ve stderr çıktısını test et
echo 'console.log("test")' > /tmp/test-hook-file.ts
INPUT_CONTENT=$(cat /tmp/test-hook-file.ts) \
  INPUT_PATH="/tmp/test-hook-file.ts" \
  .claude/hooks/console-log-check.sh
echo "Çıkış kodu: $?"
# → Çıkış kodu: 1 (engellendi — beklenen davranış)

# Başarılı geçiş testi
echo 'const x = 42;' > /tmp/clean-file.ts
INPUT_CONTENT=$(cat /tmp/clean-file.ts) \
  INPUT_PATH="/tmp/clean-file.ts" \
  .claude/hooks/console-log-check.sh
echo "Çıkış kodu: $?"
# → Çıkış kodu: 0 (izin verildi — beklenen davranış)</code></pre>

  <div class="callout callout-tip">
    <strong>Hook Debug Protokolü:</strong> Hook'lar stdin'den değil ortam değişkenlerinden
    okur. <code>INPUT_CONTENT</code> ve <code>INPUT_PATH</code> değerlerini ayarlamadan
    test etmek yanlış sonuç verir.
  </div>

  <!-- 7.3 İzin Redleri -->
  <h3 id="section-7-3">7.3 İzin Redleri</h3>
  <p>
    Bir ajan izin reddedilen bir işlem yapmaya çalıştığında <code>analysis-scope-guard.sh</code>
    veya <code>context-mode-guard.sh</code> tarafından engellenir. Çözüm:
  </p>

  <ol>
    <li>Hata mesajındaki dosya yolunu kontrol edin — hangi hook engelledi?</li>
    <li>Ajanın tier'ını ve izin verilen yazma dizinini doğrulayın.</li>
    <li>
      settings.json'da hook'un doğru matcher'a (Edit|Write|MultiEdit) bağlı olduğunu kontrol edin:
      <pre><code class="language-json">{
  "matcher": "Edit|Write|MultiEdit",
  "hooks": [
    { "type": "command", "command": ".claude/hooks/analysis-scope-guard.sh" }
  ]
}</code></pre>
    </li>
    <li>
      <code>CTX_DENY_PATHS</code> ortam değişkeninin doğru ayarlı olduğunu doğrulayın:
      <pre><code class="language-bash">echo $CTX_DENY_PATHS
# → ~/.ssh/,~/.aws/,~/.kube/,~/.gnupg/,./.env,./.env.*,./secrets/</code></pre>
    </li>
  </ol>

  <!-- 7.4 Maliyet Aşımları -->
  <h3 id="section-7-4">7.4 Maliyet Aşımları</h3>
  <p>Beklenenden yüksek token tüketiminin yaygın nedenleri ve hızlı çözümleri:</p>

  <table>
    <thead>
      <tr>
        <th>Belirti</th>
        <th>Kök Neden</th>
        <th>Hızlı Düzeltme</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>T5 ajan bütçeyi aştı</td>
        <td>Doğrudan ham dosya okuma, ctx_execute kullanılmadı</td>
        <td>context-mode-usage.md zorunlu yönlendirme tablosunu uygulayın</td>
      </tr>
      <tr>
        <td>graphify her oturumda yeniden derleniyor</td>
        <td>graphify-rebuild.sh stale marker oluşturmuyor</td>
        <td>settings.json'da SessionEnd graphify-rebuild.sh kayıtlı mı kontrol edin</td>
      </tr>
      <tr>
        <td>Oturumlar arası bağlam yeniden yükleniyor</td>
        <td>ctx_index kullanılmadı; ctx_search yerine Read kullanıldı</td>
        <td>T5 rapordan sonra ctx_index, oturum başında ctx_search kullanımını zorunlu kılın</td>
      </tr>
      <tr>
        <td>x10 modu gereğinden fazla ajan spawn ediyor</td>
        <td>Görev x5 veya x7 ile yeterince işlenebilir</td>
        <td>Ajan dağıtım tablosunu gözden geçirin; görev karmaşıklığını yeniden değerlendirin</td>
      </tr>
    </tbody>
  </table>

  <!-- 7.5 Anti-Kalıplar -->
  <h3 id="section-7-5">7.5 Anti-Kalıplar — Kaçınılması Gerekenler</h3>

  <div class="callout callout-danger" id="antipattern-g01">
    <strong>G.01 — Orkestratör Uygulama Kodu Yazıyor</strong>
    <p>
      Orkestratör hiçbir zaman uygulama kodu yazmaz — yalnızca koordine eder.
      Kod yazan Orkestratör, kural dosyalarını ve review zincirini bypass eder;
      hook'lar Orkestratör'ü durdurmaz çünkü dosya sahipliği T1–T3'e aittir.
    </p>
    <p><strong>Düzeltme:</strong> Görevi en uygun tier'a devredin. Belirsizse T3'ten başlayın.</p>
  </div>

  <div class="callout callout-danger" id="antipattern-g02">
    <strong>G.02 — Review Zinciri Atlanıyor</strong>
    <p>
      Multi-agent modunda review zinciri asla atlanamaz. "Zaman kısıtlı" veya "basit görev"
      gerekçesiyle T3 çıktısı doğrudan birleştirilirse kalite geri bildirimi kaybolur
      ve öğrenilen kalıplar oluşmaz.
    </p>
    <p><strong>Düzeltme:</strong> x2 modunda bile T1 Principal doğrudan T5 çıktısını inceler.</p>
  </div>

  <div class="callout callout-danger" id="antipattern-g03">
    <strong>G.03 — Döngüsel Bağımlılık (DAG Döngüsü)</strong>
    <p>
      TASK-A → TASK-B ve TASK-B → TASK-A bağımlılığı oluşturulursa DAG döngüsel hale gelir
      ve topological sort başarısız olur. Orkestratör döngüyü asla çalıştırmamalıdır.
    </p>
    <p><strong>Düzeltme:</strong> Wave planlamasından önce döngü tespiti yapın; bağımlılığı kullanıcıya bildirin.</p>
  </div>

  <div class="callout callout-danger" id="antipattern-g04">
    <strong>G.04 — Dosya Sahipliği İhlali</strong>
    <p>
      Bir ajan başka bir ajanın atanmış dosyasını düzenlerse çakışma meydana gelir.
      Her dosya bir oturumda yalnızca bir ajana aittir.
    </p>
    <p><strong>Düzeltme:</strong> Plan yazılırken dosya sahipliği tablosu oluşturun; çakışma varsa görev bölün.</p>
  </div>

  <div class="callout callout-danger" id="antipattern-g05">
    <strong>G.05 — T5 Doğrudan Ham Dosya Okuyor (context-mode aktifken)</strong>
    <p>
      context-mode etkinken T5 analistlerinin 10 KB üzeri dosyaları <code>Read</code> ile
      doğrudan okuması yasaktır. Bu token bütçesini tüketir ve analiz kapsamını daraltır.
    </p>
    <p><strong>Düzeltme:</strong> <code>ctx_execute_file</code> kullanın; yalnızca bulgu için satır numarası
       gerektiğinde doğrudan okuma yapın.</p>
  </div>

  <div class="callout callout-danger" id="antipattern-g06">
    <strong>G.06 — graphify --local-only Bayrağı Eksik</strong>
    <p>
      Özel/gizli kod tabanlarında <code>--local-only</code> bayrağı olmadan graphify çalıştırmak
      kod içeriğini harici API'ye gönderebilir.
    </p>
    <p><strong>Düzeltme:</strong> Özel projeler için her zaman <code>graphify . --local-only</code> kullanın.
       context-mode-guard.sh bu kuralı uygulamak için yapılandırılabilir.</p>
  </div>

  <div class="callout callout-danger" id="antipattern-g07">
    <strong>G.07 — revision_attempts Sıfırlama Hatası</strong>
    <p>
      revision_attempts sayacı yalnızca tier yükseltmesinde (T3 → T2 gibi) sıfırlanır.
      Aynı tier içinde yeni T3 ajan spawn edilmesi sayacı sıfırlamaz.
      Sayaç 2'ye ulaştığında yükseltme zorunludur, bu kural esnetilemez.
    </p>
    <p><strong>Düzeltme:</strong> Aktif plan dosyasında her görevin revision_attempts değerini takip edin.</p>
  </div>

  <div class="callout callout-danger" id="antipattern-g08">
    <strong>G.08 — Genel "OK" veya "Evet" ile Git Onayı</strong>
    <p>
      "OK", "Evet", "Devam et" gibi genel ifadeler git yazma işlemi için geçerli onay değildir.
      git-safety.md onay tablosunda olmayan her ifade reddedilir.
    </p>
    <p><strong>Düzeltme:</strong> Kullanıcının "commit et", "push et" gibi git'e özgü bir ifade kullanmasını bekleyin.</p>
  </div>

  <div class="callout callout-danger" id="antipattern-g09">
    <strong>G.09 — ctx_search Dar Döngüde Çağrılıyor</strong>
    <p>
      ctx_search saniyede 10 sorgu hız sınırına sahiptir. Bir döngü içinde sürekli çağrılırsa
      rate limit aşılır ve subsequent sorgular başarısız olur.
    </p>
    <p><strong>Düzeltme:</strong> Sorguları toplu yapın; döngü içinde ctx_search kullanmaktan kaçının.</p>
  </div>

  <div class="callout callout-danger" id="antipattern-g10">
    <strong>G.10 — Kimlik Bilgileri ctx_index ile İndeksleniyor</strong>
    <p>
      API anahtarları, şifreler veya JWT secret'ları içeren içerik asla bilgi tabanına
      indekslenmemelidir. İndekslenen veri kalıcıdır ve ctx_search ile geri getirilebilir.
    </p>
    <p><strong>Düzeltme:</strong> İndekslemeden önce hassas veriyi redakle edin. secret-detection.sh
       hook'u yazma sırasında uyarır ancak ctx_index'i doğrudan denetlemez.</p>
  </div>

  <div class="callout callout-danger" id="antipattern-g11">
    <strong>G.11 — Lider Tablosu Puanları Elle Düzenleniyor</strong>
    <p>
      update-leaderboard.sh atomik kilitler (<code>flock</code>) kullandığından leaderboard.md
      manuel olarak düzenlenirse kilitlenme veya tutarsız veri oluşabilir.
    </p>
    <p><strong>Düzeltme:</strong> Puan güncelleme işlemlerini yalnızca update-leaderboard.sh'a bırakın.
       Hatalı puan varsa SessionEnd hook'unu yeniden çalıştırın.</p>
  </div>

  <div class="callout callout-danger" id="antipattern-g12">
    <strong>G.12 — graphify'ı .env veya Kimlik Bilgisi İçeren Dizinlerde Çalıştırmak</strong>
    <p>
      graphify analiz dizininde <code>.env</code>, <code>credentials.json</code> veya
      <code>.aws/</code> gibi hassas dosyalar varken çalıştırılmamalıdır.
    </p>
    <p><strong>Düzeltme:</strong> graphify çalıştırmadan önce hassas dosya içerip içermediğini kontrol edin.
       <code>graphify-out/</code> dizinini <code>chmod 0700</code> ile koruyun.</p>
  </div>
</section>

<!-- ============================================================
     SECTION 8: REFERANS
     ============================================================ -->

<section id="section-8" class="doc-section">
  <h2>8. Referans</h2>

  <!-- 8.1 Hızlı Başvuru Tablosu -->
  <h3 id="section-8-1">8.1 Hızlı Başvuru Tablosu</h3>

  <h4>Slash Komutları</h4>
  <table class="decision-table">
    <thead>
      <tr>
        <th>Komut</th>
        <th>Amaç</th>
        <th>Ne zaman kullanılır</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><code>/caveman</code></td>
        <td>Orkestratör çıktısını sıkıştırır</td>
        <td>Deneyimli kullanıcılar, kısa yanıt tercih edildiğinde</td>
      </tr>
      <tr>
        <td><code>/graphify</code></td>
        <td>Kod bilgi grafiği oluşturur/sorgular</td>
        <td>20+ dosya analizi, god class tespiti, bağımlılık haritalaması</td>
      </tr>
      <tr>
        <td><code>/ctx</code></td>
        <td>context-mode'u etkinleştirir</td>
        <td>Büyük kod tabanı analizi, uzun oturumlar, oturumlar arası bağlam</td>
      </tr>
      <tr>
        <td><code>/review</code></td>
        <td>Standart kod inceleme zinciri</td>
        <td>Kalite kontrolü, birleştirme öncesi inceleme</td>
      </tr>
      <tr>
        <td><code>/security-review</code></td>
        <td>Güvenlik odaklı inceleme</td>
        <td>Güvenlik denetimi, üretim öncesi güvenlik taraması</td>
      </tr>
      <tr>
        <td><code>/architect</code></td>
        <td>T1 Principal'a doğrudan yönlendirme</td>
        <td>Mimari kararlar, yüksek riskli tasarım, ADR yazımı</td>
      </tr>
    </tbody>
  </table>

  <h4>xN Mod Seçim Rehberi</h4>
  <table class="decision-table">
    <thead>
      <tr>
        <th>Mod</th>
        <th>Ajanlar</th>
        <th>Maliyet</th>
        <th>Görev Tipi</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Tek Ajan</td>
        <td>1</td>
        <td><span class="cost-indicator">$</span></td>
        <td>Basit, tek dosya, net kapsam</td>
      </tr>
      <tr>
        <td>x2</td>
        <td>T1 + T5</td>
        <td><span class="cost-indicator">$$</span></td>
        <td>Araştırma + mimari onay</td>
      </tr>
      <tr>
        <td>x3</td>
        <td>T1 + T2 + T5</td>
        <td><span class="cost-indicator">$$</span></td>
        <td>Standart özellik geliştirme</td>
      </tr>
      <tr>
        <td>x4</td>
        <td>T1 + T2 + T3 + T5</td>
        <td><span class="cost-indicator">$$$</span></td>
        <td>Orta karmaşıklık, paralel uygulama</td>
      </tr>
      <tr class="decision-recommended">
        <td>x5 ✓ Önerilen</td>
        <td>T1 + T2 + T3 + T4 + T5</td>
        <td><span class="cost-indicator">$$$</span></td>
        <td>Standart tam zincir — çoğu görev için ideal</td>
      </tr>
      <tr>
        <td>x7</td>
        <td>T1 + 2×T2 + T3 + T4 + 2×T5</td>
        <td><span class="cost-indicator">$$$$</span></td>
        <td>Büyük özellik, paralel araştırma gerekli</td>
      </tr>
      <tr>
        <td>x10</td>
        <td>2×T1 + 2×T2 + 2×T3 + 2×T4 + 2×T5</td>
        <td><span class="cost-indicator">$$$$$</span></td>
        <td>Tam sistem denetimi, maksimum paralellik</td>
      </tr>
    </tbody>
  </table>

  <!-- 8.2 Sözlük -->
  <h3 id="section-8-2">8.2 Sözlük</h3>
  <dl class="glossary">
    <dt id="gl-xn">xN</dt>
    <dd>Kullanıcının mesajına eklediği çarpan parametresi (x2–x10). Multi-agent modunu etkinleştirir
    ve kaç ajan spawn edileceğini belirler. x5 standart tam zincirdir.</dd>

    <dt id="gl-pep">PEP (Prompt Enrichment Protocol)</dt>
    <dd>Görevi dağıtmadan önce Orkestratör'ün 3–7 hedefli soru sorarak gereksinimleri netleştirmesi
    ve uygulama planı oluşturması protokolü. Basit görevlerde atlanır.</dd>

    <dt id="gl-dag">DAG (Directed Acyclic Graph)</dt>
    <dd>Görevler arasındaki bağımlılıkları temsil eden yönlü döngüsüz çizge. Orkestratör,
    hangi görevlerin paralel çalışabileceğini belirlemek için topological sort uygular.</dd>

    <dt id="gl-wave">Wave (Dalga)</dt>
    <dd>Aynı anda çalıştırılabilen bağımsız görevler kümesi. Wave 1 analistler, Wave 2 konsolidasyon,
    Wave 3+ kodlama olarak planlanır. Dalgalar sıralı, içlerindeki görevler paralel çalışır.</dd>

    <dt id="gl-tier">Tier</dt>
    <dd>Beş kademeli ajan hiyerarşisi: T1 Principal (opus), T2 Staff Engineer (sonnet),
    T3 MidCoder (sonnet), T4 Lead Analyst (haiku), T5 Analyst (haiku). Her tier farklı
    karmaşıklık düzeyindeki görevlerden sorumludur.</dd>

    <dt id="gl-orchestrator">Orkestratör</dt>
    <dd>Ana Claude oturumu; koordinasyon sorumluluğuna sahiptir. Uygulama kodu yazmaz;
    görevi alt ajanlara dağıtır, review zincirini yönetir ve sonuçları birleştirir.</dd>

    <dt id="gl-review-chain">Review Zinciri</dt>
    <dd>T5 → T4 → T2 → T1 sıralı onay akışı. Her ajan bir öncekinin çıktısını inceler.
    xN moduna göre zincir kısaltılabilir (x2'de T1 doğrudan T5'i inceler).</dd>

    <dt id="gl-revision-attempts">revision_attempts</dt>
    <dd>Bir görev için revizyon sayacı. 0'dan başlar, her ⚠️ yeniden spawn'da +1 artar.
    2 olduğunda tier yükseltme zorunludur. Yalnızca tier yükseltmesinde sıfırlanır.</dd>

    <dt id="gl-escalation">Yükseltme (Escalation)</dt>
    <dd>2 başarısız revizyondan sonra görevin bir üst tier'a aktarılması. T{n+1} ajanına
    seed prompt gönderilir: önceki çıktı + tüm review bulguları + orijinal görev.</dd>

    <dt id="gl-god-node">God Node</dt>
    <dd>graphify'da degree değeri yüksek node (20+). God Class kod kokusuna karşılık gelir:
    çok fazla sorumluluğu olan sınıf. Ayrıştırma önerilir.</dd>

    <dt id="gl-graphify">graphify</dt>
    <dd>AST tabanlı kod bilgi grafiği aracı. Bağımlılıkları, toplulukları ve god node'ları
    tespit eder. Özel kodlar için <code>--local-only</code> bayrağı zorunludur.</dd>

    <dt id="gl-context-mode">context-mode</dt>
    <dd>11 MCP aracı sağlayan bağlam optimizasyon katmanı. Analizleri izole alt süreçte
    çalıştırır; sonuçlar SQLite+FTS5 bilgi tabanına indekslenir.</dd>

    <dt id="gl-ctx-index">ctx_index</dt>
    <dd>Metni kalıcı bilgi tabanına yazan MCP aracı. T5 raporu tamamlandıktan sonra
    zorunlu olarak çağrılmalıdır. İndekslenen veri <code>ctx_search</code> ile bulunur.</dd>

    <dt id="gl-ctx-search">ctx_search</dt>
    <dd>BM25 algoritmasıyla bilgi tabanında arama yapan MCP aracı. Oturumlar arası bağlam
    sürekliliği sağlar. Hız sınırı: saniyede 10 sorgu.</dd>

    <dt id="gl-stale-marker">Stale Marker</dt>
    <dd><code>graphify-out/.graphify-stale</code> dosyası. graphify-rebuild.sh SessionEnd
    hook'u tarafından kod değişikliği tespit edildiğinde oluşturulur. Varlığı graph.json'ın
    yeniden derlenmesi gerektiğini gösterir.</dd>

    <dt id="gl-file-ownership">Dosya Sahipliği</dt>
    <dd>Her dosyanın bir oturumda yalnızca tek bir ajana atanması kuralı.
    Birden fazla ajan aynı dosyayı düzenleyemez.</dd>

    <dt id="gl-learned-pattern">Öğrenilen Kalıp (Learned Pattern)</dt>
    <dd>Tekrarlayan review redlerinden otomatik oluşturulan kalıp dosyası.
    <code>.claude/memory/learned-patterns/</code> dizininde saklanır.
    hit-count ≥ 3 olduğunda kalıcı kural dosyasına terfi eder.</dd>

    <dt id="gl-hit-count">hit-count</dt>
    <dd>Öğrenilen kalıbın kaç oturumda tetiklendiğini gösteren sayaç.
    3'e ulaştığında pattern-lifecycle.sh kalıbı <code>.claude/rules/learned-*.md</code>'ye ekler.</dd>

    <dt id="gl-caveman-mode">Caveman Mode</dt>
    <dd>Orkestratör çıktısını sıkıştıran opsiyonel mod. /caveman ile etkinleştirilir.
    Kod, dosya yolları ve güvenlik uyarıları hiçbir zaman sıkıştırılmaz.</dd>

    <dt id="gl-name-pool">İsim Havuzu</dt>
    <dd>Ajanlara atanan 20 Türkçe isim. Puanlara göre ağırlıklı seçim yapılır:
    A-tier (&gt;20 puan) 1.5×, B-tier (0–19) 1.0×, C-tier (−20 ile −1) 0.8×, D-tier (&lt;−20) 0.6×.</dd>

    <dt id="gl-score-deltas">Puan Deltaları</dt>
    <dd>Oturum sonu ajan performansına uygulanan puan değişimleri. Görev tamamlama +5,
    başarısız −5, ilk incelemede onay +3, gereksiz yükseltme −2.</dd>
  </dl>

  <!-- 8.3 SSS -->
  <h3 id="section-8-3">8.3 Sıkça Sorulan Sorular</h3>

  <details>
    <summary>Hangi xN modunu seçmeliyim?</summary>
    <p>
      Çoğu görev için <strong>x5</strong> önerilir — tam review zincirini çalıştırır ve
      makul maliyette kalır. Basit tek dosya değişiklikleri için tek ajan yeterlidir.
      Büyük sistem denetimleri veya tam paralellik gerektiren görevler için x7 veya x10 kullanın.
    </p>
  </details>

  <details>
    <summary>Orkestratör neden hiç kod yazmıyor?</summary>
    <p>
      Orkestratörün dosya yazma yetkisi yoktur — hook sistemi bunu uygulamaz çünkü
      Orkestratörü durduracak bir hook yoktur. Ancak koordinasyon rolü gereği kod yazmak
      review zincirini ve hook denetimlerini atlamasına yol açar. Bu nedenle mimari
      karar olarak Orkestratör yalnızca koordine eder.
    </p>
  </details>

  <details>
    <summary>revision_attempts sayacı ne zaman sıfırlanır?</summary>
    <p>
      Yalnızca tier yükseltmesinde: T3'ten T2'ye geçildiğinde sayaç sıfırlanır.
      Aynı tier içinde yeni ajan spawn edilmesi sayacı sıfırlamaz.
      İki ⚠️ revizyon + ❌ red = zorunlu yükseltme.
    </p>
  </details>

  <details>
    <summary>context-mode tüm araçları ne zaman zorunlu kılıyor?</summary>
    <p>
      T4/T5 analistleri için: 10 KB üzeri dosyalar <code>ctx_execute_file</code> ile okunmalıdır.
      Beklenen çıktısı 5 KB üzeri olan bash komutları <code>ctx_execute</code> ile çalıştırılmalıdır.
      T3 MidCoder düzenleyeceği dosyaları doğrudan Read ile okuyabilir (dosya sahipliği kuralı).
    </p>
  </details>

  <details>
    <summary>graphify graph.json ne zaman yeniden derlenmeli?</summary>
    <p>
      <code>graphify-out/.graphify-stale</code> dosyası mevcutsa yeniden derleme gereklidir.
      Bu dosya, graphify-rebuild.sh SessionEnd hook'u tarafından kod değişikliği tespit
      edildiğinde oluşturulur. Stale marker yoksa önbellek kullanılır — sıfır maliyet.
    </p>
  </details>

  <details>
    <summary>Caveman mode ne zaman otomatik kapanır?</summary>
    <p>
      Güvenlik uyarıları, yıkıcı işlem onayları, git onay diyalogları, çok adımlı koşullu
      kararlar ve yükseltme seed promptları otomatik olarak tam formatta yazılır.
      Kullanıcı "stop caveman" veya "normal mode" derse mod sonraki yanıttan itibaren kapanır.
    </p>
  </details>

  <details>
    <summary>Hook exit 1 verirse ne yapmalıyım?</summary>
    <p>
      stderr mesajını okuyun — hangi kural ihlal edildi? İhlali düzeltin ve işlemi yeniden deneyin.
      Hook'u bypass etmeye çalışmayın: hooks bir güvenlik katmanıdır, not a guideline.
      Yanlış pozitif olduğunu düşünüyorsanız hook script'i gözden geçirin ve gerekirse
      izin listesini güncelleyin.
    </p>
  </details>

  <details>
    <summary>Öğrenilen kalıp nasıl kalıcı kurala dönüşür?</summary>
    <p>
      Bir kalıp 3 farklı oturumda tetiklendiğinde (hit-count ≥ 3), pattern-lifecycle.sh
      içeriğini <code>.claude/rules/learned-{kategori}.md</code> dosyasına ekler.
      Bu otomatik bir süreçtir — Orkestratör periyodik olarak bu dosyaları incelemeli
      ve canonical kural dosyalarıyla birleştirme kararı vermelidir.
    </p>
  </details>

  <details>
    <summary>Birden fazla ajan aynı dosyayı düzenleyebilir mi?</summary>
    <p>
      Hayır. Her dosya bir oturumda yalnızca tek bir ajana atanır.
      Çakışan sahiplik tespit edilirse görev bölünmeli, farklı dosya setlerine atanmalıdır.
    </p>
  </details>

  <details>
    <summary>ctx_search neden 0 sonuç döndürdü?</summary>
    <p>
      İki olasılık: (1) İçerik henüz indekslenmemiş — ctx_stats ile indekslenmiş kaynakları
      kontrol edin ve ctx_index çalıştırın. (2) Arama terimi yeterince spesifik değil —
      kaynak adında geçen bir terim kullanmayı deneyin.
    </p>
  </details>

  <details>
    <summary>x10 modunda 2 T4 ajan nasıl çalışır?</summary>
    <p>
      x10 modunda 2 T4 Lead Analyst paralel olarak T5 çıktılarını konsolide eder.
      Her T4 ajanı farklı bir kapsam aralığını üstlenir — örneğin T4-A güvenlik bulgularını,
      T4-B mimari bulgularını birleştirir. Sonuçlar T2'de birleştirilir.
    </p>
  </details>

  <details>
    <summary>/architect komutu xN parametresiyle birlikte kullanılabilir mi?</summary>
    <p>
      /architect doğrudan T1 Principal'ı tetikler; xN parametresine gerek yoktur.
      Her ikisi birlikte kullanılırsa /architect öncelik alır.
    </p>
  </details>

  <details>
    <summary>Lider tablosu puanları nasıl hesaplanır?</summary>
    <p>
      update-leaderboard.sh oturum sonu Agent Performance tablosunu okur ve delta uygular:
      görev tamamlama +5, başarısız −5, ilk incelemede onay +3, ikinci incelemede +1,
      3+ inceleme −3, P0/P1 bulgu +4, yanlış pozitif −2, gereksiz yükseltme −2, model fallback −1.
    </p>
  </details>

  <details>
    <summary>Bir oturumda kaç öğrenilen kalıp dosyası oluşturulabilir?</summary>
    <p>
      self-learning-collector.sh bir oturumda aynı dosyaya 2+ düzenleme yapıldığında tetiklenir.
      Teorik limit yoktur ancak kalıp başına bir dosya oluşturulur.
      Arşivleme eşiği: hit-count = 0 ve sessions-since-hit ≥ 5.
    </p>
  </details>

  <details>
    <summary>Orkestratör PEP'i ne zaman atlar?</summary>
    <p>
      PEP, tüm şartlar sağlandığında atlanır: 3 satırdan az kod, en fazla 1 dosya,
      iş mantığı veya mimari karar yok, kapsam açık (yeniden adlandırma, yazım düzeltme, sürüm güncelleme).
      Kullanıcı "skip questions" derse her zaman atlanır.
    </p>
  </details>

  <details>
    <summary>graphify hangi dilleri destekler?</summary>
    <p>
      graphify AST tabanlıdır ve TypeScript, JavaScript, Python, Java, Kotlin ve Rust'ı
      destekler. Diğer diller için sembolik analiz sınırlıdır.
      <code>--local-only</code> modunda tüm diller aynı güvenlik garantisiyle çalışır.
    </p>
  </details>

  <!-- 8.4 Metrikler -->
  <h3 id="section-8-4">8.4 Metrik Yorumlama</h3>

  <h4>token-usage.md Yorumlama</h4>
  <p>
    <code>.claude/metrics/token-usage.md</code> dosyası her oturum için ajan başına
    token tüketimini kaydeder. Delta sütunu tahmini ve gerçek tüketim arasındaki farkı gösterir.
  </p>
  <ul>
    <li><strong>Delta &gt; +20%:</strong> Ajan beklenenden fazla dosya okumuş olabilir.
      context-mode-usage.md kurallarına uyum kontrol edin.</li>
    <li><strong>Delta &lt; −20%:</strong> Görev daha az karmaşıkmış — bir sonraki benzer görev
      için tier tahminini güncellemeyi düşünün.</li>
    <li><strong>T5 ajan maliyeti T3'ten yüksek:</strong> T5 büyük dosyaları doğrudan okuyor olabilir;
      ctx_execute_file kullanımını doğrulayın.</li>
  </ul>

  <h4>leaderboard.md Yorumlama</h4>
  <p>
    <code>.claude/metrics/leaderboard.md</code> dosyası ajan isimlerinin birikmiş puanlarını tutar.
    Puan, o ismin bir sonraki seçimde ne kadar ağırlık taşıyacağını belirler.
  </p>
  <ul>
    <li><strong>A-tier (&gt;20 puan):</strong> İsim 1.5× seçilme ağırlığına sahip — tutarlı başarı</li>
    <li><strong>B-tier (0–19):</strong> Normal ağırlık — standart performans</li>
    <li><strong>C-tier (−20 ile −1):</strong> 0.8× ağırlık — geçici başarısızlık veya gereksiz yükseltme</li>
    <li><strong>D-tier (&lt;−20):</strong> 0.6× ağırlık — ciddi tutarsızlık; Orkestratör dikkat etmeli</li>
  </ul>

  <div class="callout callout-tip">
    <strong>Maliyet İçgörüsü:</strong> Yüksek maliyetli oturumlarda önce token-usage.md'yi inceleyin.
    T5 ajanların tüketimi toplam maliyetin %30'undan fazlaysa context-mode entegrasyonunu güçlendirin.
    graphify kullanımı yaygınlaştıkça T5 tüketimi oturumlar arasında azalmalıdır.
  </div>
</section>

<!-- ============================================================
     COMBINED EXAMPLES — P0 (Component 2: .example-combined)
     ============================================================ -->

<section id="combined-examples" class="doc-section">
  <h2>Kombine Kullanım Örnekleri</h2>
  <p>Aşağıdaki örnekler birden fazla Claude Code özelliğinin birlikte nasıl çalıştığını gösterir.</p>

  <!-- Combined #1: caveman + x5 -->
  <div class="example-combined" id="combo-caveman-x5" data-combo="caveman-x5">
    <div class="combined-header">
      <span class="combined-badge">/caveman</span>
      <span class="combined-plus">+</span>
      <span class="combined-badge">x5</span>
      <h3 class="combined-title">Auth Servisi Refaktörü: Kısa Çıktı + Tam Zincir</h3>
    </div>
    <div class="combined-meta">
      <span>⏱ 12–15 dk</span>
      <span>💰 $4–6</span>
      <span>🤖 5 ajan</span>
    </div>
    <p class="combined-intro">
      Büyük bir auth modülünü yeniden yapılandırırken /caveman modu orkestratör çıktısını sıkıştırır;
      x5 tam review zincirini çalıştırır. Sonuç: ayrıntılı ajan çıktıları + özet orkestratör yanıtları.
    </p>

    <div class="combined-example-block">
      <div class="combined-input">
        <strong>Kullanıcı Girdisi</strong>
        <pre><code>src/features/auth/ klasöründeki UserAuthService'i
JWT rotation, rate limiting ve test kapsamıyla
yeniden yaz. x5 /caveman</code></pre>
      </div>
      <div class="combined-response">
        <strong>Orkestratör Yanıtı (Caveman Aktif)</strong>
        <pre><code>PEP: 4 soru, 2 dk.
Plan: 5 görev, 3 dalga.
T5: Auth modülü analizi başlatılıyor.
T3: JWT rotation + rate limiting uygulanıyor.
T2: İnceleme — 2 öneri, onay verildi.
T1: Mimari onay — temiz.
Tamamlandı: 847 satır yeniden yazıldı, 23 test eklendi.</code></pre>
      </div>
    </div>

    <div class="combined-walkthrough">
      <div class="step">
        <strong>Dalga 1 — Analiz:</strong> T5 Analyst (Yavuz) auth modülü yapısını ve mevcut
        sorunları tarar: JWT secret yeterince uzun değil, refresh token rotation eksik,
        rate limiting yok.
      </div>
      <div class="step">
        <strong>Dalga 2 — Uygulama:</strong> T3 MidCoder (Canan) auth-service.ts'i yeniden yazar.
        Caveman modu orkestratör mesajlarını kısaltır ancak ajan içi talimatları etkilemez.
      </div>
      <div class="step">
        <strong>Dalga 3 — İnceleme:</strong> T2 Staff Engineer (Tarik) token lifetime ve test
        kapsamını inceler. T1 Principal (Onur) mimari uyumu onaylar.
      </div>
      <div class="step">
        <strong>Sonuç:</strong> auth-service.ts refaktörü tamamlandı. /caveman sayesinde
        orkestratör mesajları %55 daha kısa, ajan çıktıları değişmedi.
      </div>
    </div>

    <div class="callout callout-tip">
      /caveman modunda bile güvenlik uyarıları ve git onay diyalogları tam formatta yazılır.
      Kod blokları, dosya yolları ve hata mesajları hiçbir zaman sıkıştırılmaz.
    </div>
  </div>

  <!-- Combined #2: ctx + graphify -->
  <div class="example-combined" id="combo-ctx-graphify" data-combo="ctx-graphify">
    <div class="combined-header">
      <span class="combined-badge">/ctx</span>
      <span class="combined-plus">+</span>
      <span class="combined-badge">/graphify</span>
      <h3 class="combined-title">Graf Oluştur → Analizi İndeksle → Sonraki Oturumda Yeniden Kullan</h3>
    </div>
    <div class="combined-meta">
      <span>⏱ 8–12 dk (ilk oturum) / 1–2 dk (sonraki oturumlar)</span>
      <span>💰 $2–4 / $0.10</span>
      <span>🤖 2 ajan</span>
    </div>
    <p class="combined-intro">
      graphify ilk oturumda kod tabanı bilgi grafiğini oluşturur; /ctx analizi bilgi tabanına indeksler.
      Sonraki oturumda ctx_search ile sıfır derleme maliyetiyle bulgulara erişilir.
    </p>

    <div class="combined-example-block">
      <div class="combined-input">
        <strong>Oturum 1</strong>
        <pre><code>/graphify src/
/ctx
// T5: ctx_index("arch-analysis-2026-05-22", bulgular, "prose")</code></pre>
      </div>
      <div class="combined-response">
        <strong>Oturum 2 (Sonraki Gün)</strong>
        <pre><code>ctx_search("mimari sorunlar god class")
// → auth-analysis-2026-05-22: "UserService degree 42..."
// graph.json: önbellekten, ~0 token</code></pre>
      </div>
    </div>

    <div class="combined-walkthrough">
      <div class="step">
        <strong>Oturum 1, Adım 1:</strong> <code>graphify . --local-only</code> çalıştırılır.
        graph.json oluşturulur — 142 node, 423 edge. ~500 token maliyet.
      </div>
      <div class="step">
        <strong>Oturum 1, Adım 2:</strong> T5 god node'ları jq ile sorgular, ham dosyalara
        bakmaz. <code>ctx_index</code> ile rapor bilgi tabanına yazılır.
      </div>
      <div class="step">
        <strong>Oturum 2, Adım 1:</strong> Stale marker yok → graph.json önbellekten.
        <code>ctx_search</code> ile önceki bulgular anında bulunur. Dosya okuma sıfır.
      </div>
      <div class="step">
        <strong>Token Tasarrufu:</strong> Oturum 2 toplam maliyeti ~100 token —
        oturum 1'in %2'si. Uzun vadeli projeler için kritik optimizasyon.
      </div>
    </div>

    <div class="callout callout-tip">
      <strong>Neden bu kombinasyon?</strong>
      graphify ilk oturumda ~500 token maliyetle kod grafiğini oluşturur ve bu maliyet ilk 3
      sorguda karşılanır. /ctx ile ctx_index bulguları kalıcı bilgi tabanına yazar; sonraki
      oturumlar ctx_search ile tüm analize ~100 token harcarken 50 dosyanın doğrudan okunması
      ~20.000 token gerektirir. İkinci oturumdan itibaren maliyet %99 düşer.
    </div>
  </div>

  <!-- Combined #3: graphify + T5 + T4 -->
  <div class="example-combined" id="combo-graphify-t5-t4" data-combo="graphify-t5-t4">
    <div class="combined-header">
      <span class="combined-badge">/graphify</span>
      <span class="combined-plus">+</span>
      <span class="combined-badge">T5</span>
      <span class="combined-plus">+</span>
      <span class="combined-badge">T4</span>
      <h3 class="combined-title">60 Dosyalık Kod Tabanı: God Class Tespiti ve Ayrıştırma Planı</h3>
    </div>
    <div class="combined-meta">
      <span>⏱ 15–20 dk</span>
      <span>💰 $3–5</span>
      <span>🤖 T5 + T4</span>
    </div>
    <p class="combined-intro">
      graphify 60 dosyalık kod tabanını analiz eder; T5 Analyst ham bulguları üretir;
      T4 Lead Analyst konsolide ederek somut ayrıştırma planı oluşturur.
    </p>

    <div class="combined-example-block">
      <div class="combined-input">
        <strong>graphify Çıktısı</strong>
        <pre><code>jq '.nodes | sort_by(-.degree) | .[0:3]' graph.json
// → [
//   { "id": "UserService", "degree": 42, "community": 1 },
//   { "id": "OrderProcessor", "degree": 28, "community": 2 },
//   { "id": "NotificationHub", "degree": 19, "community": 3 }
// ]</code></pre>
      </div>
      <div class="combined-response">
        <strong>T4 Konsolidasyon Özeti</strong>
        <pre><code>God class: UserService (degree 42) → 4 sınıfa böl:
- UserRepository (veri erişimi)
- UserAuthService (kimlik doğrulama)
- UserProfileService (profil yönetimi)
- UserNotificationService (bildirim)</code></pre>
      </div>
    </div>

    <div class="combined-walkthrough">
      <div class="step">
        <strong>graphify:</strong> <code>graphify . --local-only</code> 60 dosyayı analiz eder.
        UserService degree 42 — god class eşiğinin (20) iki katı.
      </div>
      <div class="step">
        <strong>T5 Analyst (Necati):</strong> God node'ları belgeler, topluluk uyumunu ölçer,
        her bağlantı için ham kanıt toplar. ctx_execute_file ile yalnızca gerekli satırları okur.
      </div>
      <div class="step">
        <strong>T4 Lead Analyst (Elif):</strong> T5 bulgularını konsolide eder, 4 parçaya ayrıştırma
        planı hazırlar, her parçanın sorumluluğunu tanımlar. Risk değerlendirmesi ekler.
      </div>
      <div class="step">
        <strong>Çıktı:</strong> Somut ADR taslağı + refaktör öncelik sıralaması.
        UserService ayrıştırması sonrası tahmin: degree 42 → ortalama 12.
      </div>
    </div>

    <div class="callout callout-tip">
      <strong>Neden bu kombinasyon?</strong>
      graphify 60 dosyayı ~500 token'da analiz eder; T5 ham kanıt toplar (~2.000 token dosya başı);
      T4 bulguları somut ayrıştırma planına dönüştürür. God class tespiti için doğru araç seçimi
      kritiktir: graphify olmadan T5 tüm dosyaları okur (~20.000 token); T4 olmadan T5 bulgular
      eylem planına dönüşmez. Bu zincir tanıdan plana kadar en verimli mimari analiz yolunu oluşturur.
    </div>
  </div>

  <!-- Combined #4: x10 + graphify -->
  <div class="example-combined" id="combo-x10-graphify" data-combo="x10-graphify">
    <div class="combined-header">
      <span class="combined-badge">x10</span>
      <span class="combined-plus">+</span>
      <span class="combined-badge">/graphify</span>
      <h3 class="combined-title">Tam Sistem Denetimi: Maksimum Paralellik + Graf Analizi</h3>
    </div>
    <div class="combined-meta">
      <span>⏱ 45–60 dk</span>
      <span>💰 $14–20</span>
      <span>🤖 10 ajan, 4 dalga</span>
    </div>
    <p class="combined-intro">
      x10 modu 10 ajanı 4 dalgada çalıştırır; graphify tüm sistemin bağımlılık haritasını sağlar.
      Büyük kod tabanı denetimleri için kullanılır.
    </p>

    <div class="combined-example-block">
      <div class="combined-input">
        <strong>Dalga Yapısı</strong>
        <pre><code>Dalga 1: T5-A (güvenlik) + T5-B (mimari) [paralel]
Dalga 2: T4-A (güvenlik konsolidasyon) + T4-B (mimari konsolidasyon) [paralel]
Dalga 3: T3-A (güvenlik düzeltme) + T3-B (refaktör) + T2-A + T2-B [paralel]
Dalga 4: T1-A (nihai onay) + T1-B (ADR)</code></pre>
      </div>
      <div class="combined-response">
        <strong>Denetim Sonuçları</strong>
        <pre><code>Güvenlik: 5 → 0 kritik bulgu
Mimari: degree 42 → 12 (UserService ayrıştırıldı)
Test kapsamı: %68 → %92
Teknik borç: 47 gün → 12 gün</code></pre>
      </div>
    </div>

    <div class="combined-walkthrough">
      <div class="step">
        <strong>Ön Hazırlık:</strong> graphify tüm kod tabanını analiz eder. T5 ajanları
        graph.json'dan god node listesini alır — ham dosya okumadan bağımlılık haritası hazır.
      </div>
      <div class="step">
        <strong>Dalga 1 — Paralel Araştırma:</strong> T5-A (Yavuz) güvenlik açıklarını,
        T5-B (Selin) mimari sorunları eş zamanlı tarar. Her biri ayrı kapsam alanını üstlenir.
      </div>
      <div class="step">
        <strong>Dalga 2 — Paralel Konsolidasyon:</strong> T4-A (Elif) güvenlik bulgularını,
        T4-B (Ayse) mimari bulgularını konsolide eder. İki rapor T2 tarafından birleştirilir.
      </div>
      <div class="step">
        <strong>Dalga 3 — Paralel Uygulama:</strong> T3 ve T2 ajanlar bağımsız görevleri
        eş zamanlı uygular. Dosya sahipliği çakışması olmamasına dikkat edilir.
      </div>
      <div class="step">
        <strong>Dalga 4 — Nihai Onay:</strong> T1-A nihai kodu onaylar, T1-B ADR taslağını
        tamamlar. Orkestratör oturum performans raporunu hazırlar.
      </div>
    </div>

    <div class="callout callout-tip">
      <strong>Neden bu kombinasyon?</strong>
      x10 tek ajan moduna kıyasla 4–5× daha hızlıdır çünkü araştırma, konsolidasyon ve uygulama
      dalgaları paralel çalışır. graphify tüm sistemin bağımlılık haritasını 500 token'da sağlar;
      10 T5/T4 ajanın bağımsız kapsam alanları çakışmaz. Bu kombinasyon olmadan sistemin tamamını
      doğrusal olarak taramak 3–4 kat daha fazla zaman ve maliyet gerektirir. Yalnızca üretim
      ortamına alınacak büyük denetimler veya güvenlik sertifikasyonu öncesi kullanın.
    </div>
  </div>

  <!-- Combined #5: test-gen + x3 -->
  <div class="example-combined" id="combo-test-gen-x3" data-combo="test-gen-x3">
    <div class="combined-header">
      <span class="combined-badge">Test Üretimi</span>
      <span class="combined-plus">+</span>
      <span class="combined-badge">x3</span>
      <h3 class="combined-title">auth-service.ts için Jest Test Paketi Üretimi</h3>
    </div>
    <div class="combined-meta">
      <span>⏱ 10–15 dk</span>
      <span>💰 $2–3</span>
      <span>🤖 3 ajan</span>
    </div>
    <p class="combined-intro">
      x3 modu T5 analist, T2 Staff Engineer ve T1 Principal'ı çalıştırır.
      T5 mevcut davranışı analiz eder; T2 AAA kalıbında tam Jest paketi üretir; T1 onaylar.
    </p>

    <div class="combined-example-block">
      <div class="combined-input">
        <strong>Kullanıcı Girdisi</strong>
        <pre><code>src/features/auth/auth-service.ts için
kapsamlı Jest testleri yaz. Mutlu yol, hata yolları
ve sınır koşullarını kapsasın. x3</code></pre>
      </div>
      <div class="combined-response">
        <strong>Üretilen Test Yapısı</strong>
        <pre><code>describe('AuthService', () => {
  describe('login', () => {
    it('should return JWT when credentials are valid', ...)
    it('should throw ValidationError when email is invalid', ...)
    it('should throw RateLimitError when attempts exceed 5', ...)
    it('should return new token pair on refresh', ...)
    it('should invalidate old refresh token after rotation', ...)
  })
})
// → 23 test, %94 dal kapsamı</code></pre>
      </div>
    </div>

    <div class="combined-walkthrough">
      <div class="step">
        <strong>Dalga 1 — T5 Analizi:</strong> T5 (Baris) auth-service.ts'in tüm public metodlarını
        listeler, mevcut hata senaryolarını ve sınır koşullarını çıkarır.
        ctx_execute_file ile dosyayı token-verimli şekilde okur.
      </div>
      <div class="step">
        <strong>Dalga 2 — T2 Uygulaması:</strong> T2 Staff Engineer (Tarik) AAA kalıbında
        tam Jest describe bloğu yazar. Factory fonksiyonları kullanır:
        <code>buildValidCredentials()</code>, <code>createMockUserRepository()</code>.
      </div>
      <div class="step">
        <strong>Dalga 3 — T1 İncelemesi:</strong> T1 Principal (Onur) test kalitesini inceler:
        uygulama detayı testi yapılmıyor mu, her test bağımsız mı, edge case'ler tam mı?
        Onay → tamamlandı.
      </div>
    </div>

    <div class="callout callout-tip">
      Test üretim görevlerinde T5 analiz dalgası kritiktir — mevcut davranış belgelenmeden
      yazılan testler yanlış beklentiler içerebilir.
    </div>
  </div>

  <!-- Combined #6: ctx + long-session -->
  <div class="example-combined" id="combo-ctx-long-session" data-combo="ctx-long-session">
    <div class="combined-header">
      <span class="combined-badge">/ctx</span>
      <span class="combined-plus">+</span>
      <span class="combined-badge">Çok Günlü Oturum</span>
      <h3 class="combined-title">Çok Günlü Migrasyon: Oturumlar Arası Bağlam Sürekliliği</h3>
    </div>
    <div class="combined-meta">
      <span>⏱ Çok gün</span>
      <span>💰 Oturum 1: $8–12 / Oturum 2+: $0.50–1</span>
      <span>🤖 Oturum başına 5–10 ajan</span>
    </div>
    <p class="combined-intro">
      Büyük migrasyonlarda /ctx ile bilgiler oturumlar arası kalıcı bilgi tabanına yazılır.
      Sonraki oturumlar ctx_search ile önceki bulguları anında geri yükler — dosya yeniden okuma yok.
    </p>

    <div class="combined-example-block">
      <div class="combined-input">
        <strong>Oturum 1 (Pazartesi)</strong>
        <pre><code>// T5 tamamladıktan sonra:
ctx_index(
  "migration-phase1-auth-2026-05-20",
  fullAnalysisReport,
  "prose"
)
// → 47 sayfa analiz indekslendi</code></pre>
      </div>
      <div class="combined-response">
        <strong>Oturum 2 (Salı)</strong>
        <pre><code>ctx_search("auth migration phase 1 findings", limit=5)
// → [{ source: "migration-phase1-auth-2026-05-20",
//      score: 0.97,
//      excerpt: "JWT secret rotation eksik..." }]
// Dosya okuma: 0. Token tasarrufu: %99</code></pre>
      </div>
    </div>

    <div class="combined-walkthrough">
      <div class="step">
        <strong>Oturum 1 — Analiz ve İndeksleme:</strong> T5 migrasyonun tüm kapsamını analiz eder.
        Oturum sonunda T5 ve T4 raporları ctx_index ile kalıcı bilgi tabanına yazılır.
      </div>
      <div class="step">
        <strong>Oturum 2 — Bağlam Geri Yükleme:</strong> Oturum başında ctx_stats ile
        indekslenmiş kaynaklar kontrol edilir. ctx_search ile gerekli bulgular saniyeler
        içinde geri yüklenir — .claude/memory/sessions/ dosyaları okunmaz.
      </div>
      <div class="step">
        <strong>Context Compaction Sonrası:</strong> Claude konuşma bağlamını sıkıştırdıktan sonra
        bile ctx_search önceki oturumun tüm bulgularına erişir. Bağlam kaybı yok.
      </div>
      <div class="step">
        <strong>Uzun Vadeli Getiri:</strong> 5 oturumlu bir migrasyon projesinde /ctx olmadan
        tahmini toplam maliyet: $45–60. /ctx ile: $12–18 (%70 tasarruf).
      </div>
    </div>

    <div class="callout callout-tip">
      <strong>Neden bu kombinasyon?</strong>
      Context compaction kaçınılmazdır: uzun migrasyonlarda Claude konuşma bağlamını sıkıştırır
      ve önceki bulgular kaybolabilir. /ctx + ctx_index bu sorunu kalıcı olarak çözer — her oturum
      ctx_search ile önceki tüm analize anında erişir. 5 oturumluk bir projede /ctx olmadan
      tahmin edilen yeniden okuma maliyeti ~$30; /ctx ile bu maliyet ~$1'a düşer. Çok günlü
      projeler için kullanımı zorunlu sayılabilir.
    </div>
  </div>
</section>

<!-- ============================================================
     W3 ADVANCED WALKTHROUGH
     Component 3: collapsible <details class="walkthrough walkthrough-advanced">
     ============================================================ -->

<section id="walkthroughs" class="doc-section">
  <h2>İleri Düzey Adım Adım Kılavuzlar</h2>

  <details class="walkthrough walkthrough-advanced" id="walkthrough-w3">
    <summary>
      <div class="walkthrough-summary-content">
        <span class="walkthrough-badge walkthrough-badge-advanced">W3 — İleri Düzey</span>
        <h3 class="walkthrough-title">x10 + /graphify + /ctx ile Tam Sistem Denetimi</h3>
        <p class="walkthrough-summary-desc">
          10 ajan, 6 dalga, 2 T4 paralel konsolidasyon, oturumlar arası bilgi indeksleme.
          Büyük kod tabanları için maksimum kapsamlı denetim.
        </p>
        <div class="walkthrough-meta">
          <span>⏱ 45–75 dk</span>
          <span>💰 $18–28</span>
          <span>🤖 10 ajan</span>
          <span>📋 6 dalga</span>
        </div>
      </div>
    </summary>

    <div class="walkthrough-body">

      <div class="walkthrough-overview">
        <h4>Bu Kılavuzda Ne Öğreneceksiniz</h4>
        <p>
          Bu gelişmiş walkthrough, x10 modunu graphify kod bilgi grafiği ve context-mode
          bilgi tabanıyla birleştirerek büyük bir kurumsal kod tabanının tam denetimini
          nasıl gerçekleştireceğinizi gösterir. 6 dalgada 10 ajan eş zamanlı ve sıralı
          çalışarak güvenlik, mimari ve test kapsamı konularında kapsamlı bulgular üretir.
        </p>

        <h4>Ön Koşullar</h4>
        <ul>
          <li>context-mode MCP sunucusu kurulu ve yapılandırılmış</li>
          <li>graphify kurulu (<code>pip install graphify</code> — dikkat: "graphifyy" (çift y) yanlış paket!)</li>
          <li>settings.json'da tüm 19 hook kayıtlı</li>
          <li>Analiz edilecek kod tabanı 20+ dosya içeriyor</li>
        </ul>

        <h4>Ajan Kadrosu</h4>
        <table>
          <thead>
            <tr><th>Tier</th><th>İsim</th><th>Görev</th></tr>
          </thead>
          <tbody>
            <tr><td>T1-A Principal</td><td>Onur</td><td>Nihai onay, ADR</td></tr>
            <tr><td>T1-B Principal</td><td>Necati</td><td>Güvenlik mimarisi onayı</td></tr>
            <tr><td>T2-A Staff Engineer</td><td>Enis</td><td>Güvenlik düzeltmeleri</td></tr>
            <tr><td>T2-B Staff Engineer</td><td>Tarik</td><td>Mimari refaktör</td></tr>
            <tr><td>T3-A MidCoder</td><td>Taner</td><td>Rate limiting uygulaması</td></tr>
            <tr><td>T3-B MidCoder</td><td>Canan</td><td>Test kapsamı genişletme</td></tr>
            <tr><td>T4-A Lead Analyst</td><td>Elif</td><td>Güvenlik konsolidasyon</td></tr>
            <tr><td>T4-B Lead Analyst</td><td>Ayse</td><td>Mimari konsolidasyon</td></tr>
            <tr><td>T5-A Analyst</td><td>Selin</td><td>Güvenlik araştırması</td></tr>
            <tr><td>T5-B Analyst</td><td>Baris</td><td>Mimari araştırması</td></tr>
          </tbody>
        </table>
      </div>

      <div class="walkthrough-wave" style="border-left: 4px solid #ef4444; padding-left: 1rem; margin: 1.5rem 0;">
        <h4>Dalga 0 — PEP ve Hazırlık</h4>

        <div class="step">
          <strong>Adım 1 — PEP:</strong>
          Orkestratör 5 hedefli soru sorar: Hangi dizin kapsama alınacak? Güvenlik mi mimari mi öncelikli?
          Mevcut test kapsamı nedir? Deadline var mı? Hangi bulgular P0?
        </div>

        <div class="step">
          <strong>Adım 2 — graphify Hazırlığı:</strong>
          <pre><code class="language-bash">ls graphify-out/.graphify-stale 2>/dev/null && echo "STALE" || echo "FRESH"
graphify . --local-only
# → 247 node, 891 edge, 12 topluluk
# → God nodes: UserService (42), OrderProcessor (28), PaymentGateway (24)
chmod 0700 graphify-out/</code></pre>
        </div>

        <div class="step">
          <strong>Adım 3 — context-mode Başlatma:</strong>
          <pre><code class="language-bash">ctx_stats()
# → records: 23 (önceki oturumlardan)
ctx_search("önceki güvenlik bulguları", limit=3)
# → Varsa önceki bulgular T5 ajanlarına seed olarak verilir</code></pre>
        </div>
      </div>

      <div class="walkthrough-wave" style="border-left: 4px solid #10b981; padding-left: 1rem; margin: 1.5rem 0;">
        <h4>Dalga 1 — Paralel T5 Araştırması</h4>

        <div class="step">
          <strong>T5-A Selin — Güvenlik Araştırması:</strong>
          <pre><code class="language-bash">ctx_execute("shell",
  "grep -r 'executeQuery\\|createStatement' src/ --include='*.java' -l")
# → 7 dosyada parametresiz sorgu
jq '.edges[] | select(.source == "PaymentGateway")' graphify-out/graph.json
# → 24 bağlantı — god class teyit edildi</code></pre>
          5 kritik güvenlik bulgusu belgeler. ctx_index ile raporlar.
        </div>

        <div class="step">
          <strong>T5-B Baris — Mimari Araştırması:</strong>
          <pre><code class="language-bash">jq '.nodes | sort_by(-.degree) | .[0:5] | .[] | {id, degree}' graphify-out/graph.json
# → UserService:42, OrderProcessor:28, PaymentGateway:24
jq '.communities[] | select(.cohesion &lt; 0.4)' graphify-out/graph.json
# → community 3: cohesion 0.31 (Shotgun Surgery riski)</code></pre>
          3 god class, 2 shotgun surgery belgeler. ctx_index ile raporlar.
        </div>
      </div>

      <div class="walkthrough-wave" style="border-left: 4px solid #f59e0b; padding-left: 1rem; margin: 1.5rem 0;">
        <h4>Dalga 2 — Paralel T4 Konsolidasyonu</h4>

        <div class="step">
          <strong>T4-A Elif — Güvenlik Konsolidasyonu:</strong>
          T5-A raporunu inceler. ctx_search ile önceki denetimlerle karşılaştırır.
          <pre><code>P0: SQL injection — PaymentGateway.processPayment:47
P0: Hardcoded JWT secret — UserAuthService:12
P1: Rate limiting yok — /auth/login
P1: CORS wildcard production'da
P2: Şifre geçmişi kontrolü eksik</code></pre>
        </div>

        <div class="step">
          <strong>T4-B Ayse — Mimari Konsolidasyonu:</strong>
          T5-B raporunu inceler. Ayrıştırma önceliklerini belirler.
          <pre><code>God Class P0: UserService → UserRepository + UserAuthService
             + UserProfileService + UserNotificationService
God Class P1: OrderProcessor → 3 sınıfa böl
Shotgun Surgery P1: community 3 refaktör gerekli</code></pre>
        </div>
      </div>

      <div class="walkthrough-wave" style="border-left: 4px solid #6366f1; padding-left: 1rem; margin: 1.5rem 0;">
        <h4>Dalga 3 — Paralel Uygulama</h4>

        <div class="step">
          <strong>T2-A Enis + T3-A Taner — Güvenlik Dalı (paralel):</strong>
          T3-A: PaymentGateway.java — parameterized query geçişi; rate limiting middleware.
          T2-A: JWT secret env var'a taşıma; rotation mekanizması; CORS düzeltme.
          Hook kontrolü her yazma işleminde: sql-injection-check.sh, secret-detection.sh aktif.
        </div>

        <div class="step">
          <strong>T2-B Tarik + T3-B Canan — Mimari Dalı (paralel):</strong>
          T2-B: UserService → 4 sınıf ayrıştırması. Dosya sahipliği: yalnızca T2-B.
          T3-B: Yeni 3 sınıf için AAA test paketi. Factory fonksiyonları kullanır.
          console-log-check.sh, any-type-check.sh tüm yazmalarda devreye girer.
        </div>
      </div>

      <div class="walkthrough-wave" style="border-left: 4px solid #8b5cf6; padding-left: 1rem; margin: 1.5rem 0;">
        <h4>Dalga 4 — Review Zinciri</h4>

        <div class="step">
          <strong>T1-A Onur — Mimari Onayı:</strong>
          UserService ayrıştırması SRP'ye uygun mu? Bağımlılık yönü doğru mu?
          Test kapsamı yeterli mi? Onay: ✅ — revision_attempts: 0.
        </div>

        <div class="step">
          <strong>T1-B Necati — Güvenlik Onayı:</strong>
          SQL injection düzeltmesi eksiksiz mi? JWT rotation tüm akışları kapsıyor mu?
          Rate limiting yük testinde dayanıklı mı? Onay: ✅ — Tüm P0 kapatıldı.
        </div>
      </div>

      <div class="walkthrough-wave" style="border-left: 4px solid #06b6d4; padding-left: 1rem; margin: 1.5rem 0;">
        <h4>Dalga 5 — Bilgi İndeksleme ve Oturum Sonu</h4>

        <div class="step">
          <strong>ctx_index Çağrıları:</strong>
          <pre><code class="language-javascript">ctx_index("security-audit-full-2026-05-22", securityReport, "prose")
ctx_index("arch-audit-full-2026-05-22", architectureReport, "prose")

// Sonraki oturumda:
ctx_search("PaymentGateway SQL injection fix", limit=3)
// → Anında erişim, ~0 token maliyeti</code></pre>
        </div>

        <div class="step">
          <strong>Sonuç Metrikleri:</strong>
          <ul>
            <li>Güvenlik bulguları: 5 kritik → 0 (tamamı kapatıldı)</li>
            <li>UserService degree: 42 → ortalama 12 (4 sınıfa ayrıştırıldı)</li>
            <li>Test kapsamı: %68 → %92</li>
            <li>Teknik borç: 47 gün → 12 gün</li>
            <li>context-mode token tasarrufu: ~%32</li>
            <li>graphify token tasarrufu: ~%23</li>
          </ul>
        </div>
      </div>

      <div class="callout callout-tip">
        <strong>x10 Ne Zaman Kullanılmalı:</strong> Yüksek maliyetlidir ($18–28, 45–75 dk).
        Yalnızca şu durumlar için: üretim ortamına alınacak büyük sistem denetimi,
        uzun süredir dokunulmamış legacy kod tabanı, güvenlik sertifikasyonu öncesi tam tarama.
        Rutin özellik geliştirme için x5 çoğunlukla yeterlidir.
      </div>
    </div>
  </details>
</section>

<!-- ============================================================
     SELF-REVIEW CHECKLIST (T3 iç kontrol)
     [x] Tüm 11 ctx_* araçları tool-card ile üretildi
     [x] Tüm 6 P0 kombine örnek .example-combined Component 2 stiliyle
     [x] W3 collapsible details.walkthrough.walkthrough-advanced
     [x] 12 anti-kalıp .callout-danger (G.01-G.12)
     [x] 16 SSS girdisi <details>
     [x] 21 sözlük terimi (xN, PEP, DAG, Wave, Tier, Orkestratör, Review Zinciri,
         revision_attempts, Yükseltme, God Node, graphify, context-mode, ctx_index,
         ctx_search, Stale Marker, Dosya Sahipliği, Öğrenilen Kalıp, hit-count,
         Caveman Mode, İsim Havuzu, Puan Deltaları)
     [x] Bölüm 6: 19 hook (4 grup) + 17 kural dosyası
     [x] HTML yapısı geçerli
     [x] Bileşen sınıfları H06 spesifikasyonuyla eşleşiyor
     [x] H03 bağlayıcı kararları uygulandı (Orkestratör, Tier isimleri, resmi "siz")
     [x] Hassas veri yok
============================================================ -->
