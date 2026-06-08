---
task-id: H02
agent: Yavuz Yalcin
tier: T5
status: Complete
features-cataloged: 32
individual-examples: 52
combined-examples: 12
walkthroughs: 3
date: 2026-05-22
---

# Özellik + Örnek Kullanım Kataloğu
## Claude Code v1.0.0 Multi-Agent Sistem

Tüm seviye kullanıcılarına yönelik kapsamlı referans rehberi. Türkçe komutlar ve tam copy-paste-enabled örnekler.

---

## A. Tekil Özellik Örnekleri

### A.1 Slash Komutları

#### /caveman — Kısa Cevap Modu
**Ne işe yarar:** Orchestrator'ın cevaplarını %40-65 daha kısa yapar. Kod, dosya yolları, commands byte-by-byte korunur.

**Örnek:**
```
/caveman
Auth module'ü refactor et x5
```

**Beklenen Davranış:**
- Orchestrator'ın proz çıktısı sıkıştırılır
- Kod blokları, dosya yolları, tanımlayıcılar değişmez
- Performance raporu yapısı korunur, sadece narrative sıkıştırılır

**Çıktı Örneği (Normal vs Caveman):**
```
NORMAL: "I will now analyze the authentication module structure and identify refactoring opportunities..."
CAVEMAN: "Analyzing auth module structure."

# Kod (her iki modda da aynı):
async function validateToken(token: string): Promise<UserClaim> {
  const decoded = jwt.verify(token, JWT_SECRET);
  return decoded as UserClaim;
}
```

---

#### /ctx — Context-Mode Araçları
**Ne işe yarar:** Analiz script'lerini bağlamı pollute etmeden çalıştırır. Büyük dosyaları işler, geçmiş bulguları arar.

**Örnek 1: Analiz Çalıştırma**
```
/ctx
ctx_execute("shell", "find src/ -name '*.ts' -type f | wc -l")
```
**Çıktı:** "248 TypeScript dosyası" (~10 token vs ~500 raw)

**Örnek 2: Önceki Session'daki Bilgileri Arama**
```
/ctx
ctx_search("JWT implementation authentication security requirements")
```
**Çıktı:** Önceki session'daki ilgili bulguları BM25 ranking ile döner

**Örnek 3: Büyük Dosya İşleme**
```
/ctx
ctx_execute_file("src/services/user-service.ts", "shell", "wc -l < $FILE_CONTENT_PATH")
```
**Çıktı:** Dosya yüklenmedi, sadece satır sayısı: "342 lines"

**Örnek 4: Bulguyu İndeksleme (Cross-Session Reuse)**
```
/ctx
ctx_index("auth-module-analysis-2026-05-22", "## Bulgular\n1. JWT secret 256-bit\n2. Refresh token rotation implemented...", "prose")
```

**Örnek 5: Toplu Komut Çalıştırma**
```
/ctx
ctx_batch_execute("shell", [
  "find src/auth -name '*.ts' | wc -l",
  "grep -r 'console.log' src/auth | wc -l",
  "du -sh src/auth"
], 3)
```
**Çıktı:** 3 komut paralel çalışır, her biri ~50ms içinde sonuçlanır

---

#### /graphify — Codebase Bilgi Grafiği
**Ne işe yarar:** 20+ dosyalı projeleri queryable knowledge graph'a dönüştürür. God classes, modül bağımlılıkları, şaşırtıcı bağlantıları bulur.

**Örnek 1: Graf İnşası**
```
/graphify . --local-only
```
**Çıktı Dosyaları:**
- `graphify-out/graph.json` (nodes, edges, communities)
- `graphify-out/GRAPH_REPORT.md` (god nodes, surprising connections)
- `graphify-out/graph.html` (interactive visualization)

**Örnek 2: Grafiği Sorgulama (Graf Zaten Varsa)**
```
/graphify query "god_nodes"
```
**Çıktı:**
```
Top God Nodes (Most Connected):
1. UserService (degree: 42) — 15 incoming, 27 outgoing
2. AuthController (degree: 28) — 10 incoming, 18 outgoing
3. DatabaseRepository (degree: 22) — 8 incoming, 14 outgoing
```

**Örnek 3: Modüller Arası Bağımlılık**
```bash
/graphify query "surprising_connections"
```
**Çıktı:**
```
Unexpected Dependencies:
- UserService → CacheService (distance 2) — should use middleware
- AuthController → EmailService (distance 3) — violates layer separation
```

**Örnek 4: Belirli Bir Node'un Komşuları**
```bash
jq '.edges[] | select(.source == "UserService")' graphify-out/graph.json
```
**Çıktı:**
```json
{"source": "UserService", "target": "DatabaseRepository", "type": "calls"}
{"source": "UserService", "target": "TokenProvider", "type": "calls"}
{"source": "UserService", "target": "CacheManager", "type": "calls"}
```

---

#### /review — Kod İnceleme Checklist'i
**Ne işe yarar:** Şu anda branch'teki değişiklikleri `.claude/rules/code-review.md` checklist'ine göre inceler.

**Örnek:**
```
/review
```

**Beklenen Çıktı:**
```
## Code Review Findings

🟠 src/features/auth/auth-service.ts:45
Function `processUserData` exceeds 20-line limit (currently 28 lines).
Recommendation: Split into `validateUserInput` and `transformUserData`

🟡 src/features/auth/controllers/auth.controller.ts:12
Generic parameter name `data` — use `authRequest` for clarity.

🔵 src/features/auth/types/auth.ts:3
Consider exporting token interface for reuse across packages.
```

---

#### /security-review — Güvenlik Odaklı İnceleme
**Ne işe yarar:** SQL injection, XSS, hardcoded secrets, CORS wildcard, JWT weakness vs. bulur.

**Örnek:**
```
/security-review
```

**Beklenen Çıktı:**
```
## Security Review — Critical Findings

🔴 src/user/user.service.ts:67
SQL injection risk: String concatenation detected.
Current: const query = "SELECT * FROM users WHERE email = ?"
Fix: Use parameterized query in repository pattern

🔴 src/auth/jwt.config.ts:12
JWT secret must be >= 256 bits.
Current: JWT_SECRET = (from environment, properly sized)
Fix: Ensure environment variable has strong entropy

🟠 src/api/cors.config.ts:5
CORS should use explicit allowlist, not wildcard.
Current: allowedOrigins: Loaded from config
Fix: Set allowedOrigins: ["https://app.example.com"] from env
```

---

#### /architect — T1 Principal'a Doğrudan Yönlendirme
**Ne işe yarar:** Mimari kararlar ve tasarım soruları doğrudan opus modeline gider, xN parametresi gerekli değil.

**Örnek:**
```
/architect
Monolitik yapıyı microservices'e dönüştürmek için optimal strateji nedir? 
Database'i bölmeli miyiz? API gateway'i neden istiyorlar?
```

**Beklenen Davranış:**
- Orchestrator T1 Principal (opus) olarak hareket eder
- Mimari tavsiyeler, alternatifler, risk değerlendirmesi döner
- xN parametresi otomatikman yoksayılır

---

#### /test-gen — Test Üretim
**Ne işe yarar:** Bir implementation dosyasından test suite'i otomatik üretir (Jest, Vitest, pytest).

**Örnek:**
```
/test-gen src/features/auth/auth-service.ts
```

**Beklenen Çıktı:**
```typescript
describe('AuthService', () => {
  describe('validateToken', () => {
    it('should return claims when token is valid', async () => {
      // AAA pattern test
      const validToken = generateTestJWT({ sub: 'user-123' });
      const result = await authService.validateToken(validToken);
      expect(result.sub).toBe('user-123');
    });

    it('should throw UnauthorizedError when token is expired', async () => {
      const expiredToken = generateTestJWT({ exp: Math.floor(Date.now() / 1000) - 3600 });
      await expect(authService.validateToken(expiredToken))
        .rejects.toThrow(UnauthorizedError);
    });
    
    it('should throw UnauthorizedError when signature is invalid', async () => {
      const tamperedToken = validToken.slice(0, -10) + 'corrupted';
      await expect(authService.validateToken(tamperedToken))
        .rejects.toThrow(UnauthorizedError);
    });
  });
});
```

---

### A.2 xN Modları

#### Single Agent (No xN)
**Ne işe yarar:** Küçük görevler, açıklamalar, hızlı fixler.

**Örnek:**
```
Bu typo'yu düzelt: "Recieve" → "Receive"
```

**Agent Allocation:** Orchestrator sadece (no spawning)  
**Cost:** ~$0.50-1  
**Time:** Seconds  
**Review Chain:** Yok

---

#### x2 Mode — Mimari + Araştırma
**Ne işe yarar:** Şirket politikası, güvenlik stratejisi, araştırma kararları.

**Örnek:**
```
Backend'de session management için JWT vs. Redis'i kıyasla x2
```

**Agent Allocation:**
- T1 Principal (opus) — Final decision + architecture review
- T5 Analyst (haiku) — Research JWT, Redis patterns, security

**Wave Execution:**
```
Wave 1: T5 compares approaches (token security, session state mgmt)
Wave 2: T1 reviews, makes decision
```

**Cost:** ~$2-3  
**Time:** ~5-7 minutes  
**Output:** Tavsiye + karar, kod yok

---

#### x3 Mode — Küçük Feature + Review
**Ne işe yarar:** API endpoint, bug fix + code review.

**Örnek:**
```
GET /users/:id endpoint'i ekle x3
```

**Agent Allocation:**
- T1 Principal (opus)
- T2 Staff Engineer (sonnet)
- T5 Analyst (haiku)

**Wave Execution:**
```
Wave 1: T5 research
Wave 2: T2 reviews T5
Wave 3: T1 approves
```

**Cost:** ~$2.50-3.50  
**Time:** ~8-10 minutes

---

#### x4 Mode — Tek Modül, Standart Dev
**Ne işe yarar:** Orta büyüklükteki feature, birden fazla layer.

**Örnek:**
```
Kullanıcı profil sayfasını tamamla (UI + API + persistence) x4
```

**Agent Allocation:**
- T1, T2, T3, T5 (T4 yok)

**Cost:** ~$3-4  
**Time:** ~10-12 minutes

---

#### x5 Mode — Full Team, Varsayılan Seç
**Ne işe yarar:** Standart feature, tam review chain, balanced cost/capability. **En iyi ortalama seç.**

**Örnek:**
```
İki faktörlü kimlik doğrulaması ekle x5
```

**Agent Allocation:**
- T1 Principal, T2 Staff Engineer, T3 MidCoder, T4 Lead Analyst, T5 Analyst
- Full review chain: T5 → T4 → T3 → T2 → T1

**Cost:** ~$4-6  
**Time:** ~15-20 minutes

---

#### x7 Mode — Paralel Araştırma + Tasarım
**Ne işe yarar:** Çoklu araştırma track'leri, paralel implementasyon.

**Örnek:**
```
Performans optimizasyonu: Database indexing + API caching + frontend memoization x7
```

**Agent Allocation:**
- T1×1, T2×2, T3×1, T4×1, T5×2

**Wave Execution:**
```
Wave 1: 2×T5 parallel (database + api + frontend research)
Wave 2: T4 consolidates
Wave 3: 2×T2 design + T3 implement parallel
```

**Cost:** ~$7-10  
**Time:** ~15-18 minutes (parallelism saves time vs sequential)

---

#### x10 Mode — Full Power, Kritik Overhaul
**Ne işe yarar:** System-wide refactor, critical security, massive feature.

**Örnek:**
```
Tüm error handling'i redesign et, test coverage'ı %90'a çıkar x10
```

**Agent Allocation:**
- T1×2 (2 Principal), T2×2 (2 Staff), T3×2 (2 MidCoder), T4×2 (2 Lead Analyst), T5×2 (2 Analyst)

**Wave Execution:**
```
Wave 1: 2×T5 research parallel (error patterns, test strategies)
Wave 2: 2×T4 consolidate parallel (architecture + test brief)
Wave 3: 2×T2 design + 2×T3 implement parallel (4-way concurrent)
Wave 4+: Review chain sequential
```

**Cost:** ~$12-18  
**Time:** ~25-35 minutes  
**Context:** ~950K tokens distributed

---

### A.3 Her Tier Örneği

#### T1 Principal — Mimari Lider (opus)
**Role:** Yüksek seviye tasarım, final review, critical decisions  
**Cost:** ~$0.60-0.75 per task  
**Context:** 120K-150K tokens

**Örnek Görev:**
```
Service → Repository pattern'i review et, SOLID uygunluğunu kontrol et
```

**Örnek Çıktı:**
```
## Architecture Review — T1 Principal

✅ Single Responsibility Principle
  - UserService handles only user domain logic
  - Depends on abstractions (UserRepository interface)

✅ Open/Closed Principle
  - New authentication strategy = new Strategy class, no UserService change
  - Easy to extend without modification

⚠️ Interface Segregation
  - UserRepository interface is fine-grained (findById, findByEmail, save)
  - No unnecessary methods exposed

## Recommendation
Architecture is sound. Ready for implementation tier.
```

---

#### T2 Staff Engineer — Kıdemli Yapı (sonnet)
**Role:** Service layer design, complex features, code quality  
**Cost:** ~$0.24-0.30 per task  
**Context:** 80K-100K tokens

**Örnek Görev:**
```
JWT refresh token rotation'ını tasarla, atomic operations kullan
```

**Örnek Çıktı:**
```java
@Service
@RequiredArgsConstructor
public class TokenRefreshService {

    private final TokenProvider tokenProvider;
    private final RefreshTokenRepository refreshTokenRepository;
    
    public TokenPair refreshAccessToken(String refreshToken) {
        RefreshTokenEntity stored = refreshTokenRepository.findByToken(refreshToken)
            .orElseThrow(() -> new UnauthorizedError("Invalid refresh token"));
            
        if (stored.isExpired()) {
            throw new UnauthorizedError("Refresh token expired");
        }
        
        // Invalidate old token, issue new pair
        String newAccessToken = tokenProvider.generateAccessToken(stored.getUserId());
        RefreshTokenEntity newRefresh = refreshTokenRepository.save(
            new RefreshTokenEntity(stored.getUserId(), generateToken())
        );
        
        refreshTokenRepository.delete(stored); // Old token invalidated
        
        return new TokenPair(newAccessToken, newRefresh.getToken());
    }
}
```

---

#### T3 MidCoder — Standart Geliştirici (sonnet)
**Role:** API endpoints, entities, standard components  
**Cost:** ~$0.18-0.24 per task  
**Context:** 60K-80K tokens

**Örnek Görev:**
```
UserController'a GET /users/:id endpoint'i ekle, DTOs ile
```

**Örnek Çıktı:**
```typescript
@RestController
@RequestMapping('/api/v1/users')
@RequiredArgsConstructor
export class UserController {
  constructor(private readonly userService: UserService) {}

  @GetMapping('/:id')
  async getUserById(@Param('id') id: string): Promise<UserDTO> {
    const user = await this.userService.findById(id);
    return new UserDTO(user.id, user.email, user.displayName);
  }
}
```

---

#### T4 Lead Analyst — Analiz Liderliği (haiku)
**Role:** Consolidate T5 findings, brief synthesis, architecture evidence  
**Cost:** ~$0.05-0.07 per task  
**Context:** 50K-70K tokens

**Örnek Görev:**
```
T5'in auth module findings'ini consolidate et, architecture brief oluştur
```

**Örnek Çıktı:**
```markdown
# Authentication Module — Architecture Brief

## Key Findings (from T5 research)
1. JWT-based stateless auth recommended (no session DB overhead)
2. Refresh token rotation prevents token replay attacks
3. CORS must whitelist frontend origin (security: no wildcard)

## Design
- AccessToken: 15-min lifetime, memory-only (frontend)
- RefreshToken: 7-day lifetime, httpOnly cookie (no JS access)
- Rotation: old refresh token invalidated on use

## Implementation Sequence
1. TokenProvider (JWT generation + validation)
2. RefreshTokenRepository (DB persistence)
3. AuthController (login, refresh endpoints)
4. Middleware (token extraction + validation)
```

---

#### T5 Analyst — Araştırma Analisti (haiku)
**Role:** Codebase exploration, security research, requirements analysis  
**Cost:** ~$0.04-0.06 per task  
**Context:** 40K-60K tokens

**Örnek Görev:**
```
JWT security best practices, implementation risks, mitigation strategy
```

**Örnek Çıktı:**
```markdown
# JWT Security Research

## Findings
1. RS256 recommended over HS256 (key rotation easier)
2. Secret must be >= 256 bits (avoid weak derivation)
3. Claims: include jti (unique ID for revocation)
4. Expiry: access 15-30 min, refresh 7-30 days

## Risks
- Token replay: Mitigate with refresh token rotation + blacklist
- Key leakage: Use environment variable, rotate annually
- Clock skew: Accept ±60 seconds in exp validation

## Recommendations
- Use RS256 with public/private key pair
- Store refresh token in httpOnly cookie (JS can't access)
- Implement refresh token rotation on every use
- Maintain token blacklist for logout events
```

---

### A.4 Hook Sistemi Örnekleri

#### PreToolUse:Edit/Write Hooks — Yazma Öncesi Kontrol
**Ne işe yarar:** Edit/Write işlemi başlamadan önce policy ihlallerini engeller.

**Örnek: block-console-log.sh**
```bash
# File: .claude/hooks/block-console-log.sh

FILE="$1"
CONTENT="$2"

if echo "$CONTENT" | grep -qE 'console\.(log|warn|error|debug)' ; then
  echo "BLOCKED: console.* statement detected in production code"
  exit 2  # exit code 2 = BLOCK
fi

exit 0  # pass
```

**Davranış:**
```
User tries to commit: console.log("Debug info")
Hook fires → Detects console.log
Exit code 2 → Operation blocked
Message: "BLOCKED: console.* statement detected"
```

---

#### PreToolUse:Bash Hooks — Shell Çalıştırılmadan Önce
**Ne işe yarar:** Bash komutunun çalışmasını güvenlik açısından kontrol eder.

**Örnek: context-mode-guard.sh**
```bash
# Blocks ctx_execute calls on sensitive paths

if echo "$COMMAND" | grep -qE '(\.ssh|\.aws|\.kube|secrets|\.env)' ; then
  echo "DENIED: Sensitive path detected in ctx_execute"
  exit 2
fi

exit 0
```

---

#### PostToolUse:Edit/Write Hooks — Yazma Sonrası Analiz
**Ne işe yarar:** Edit/Write bittikten sonra o dosya hakkında otomatik aksiyon alır.

**Örnek: review-tracker.sh**
```bash
# Counts edits to track problematic files

FILE="$1"
COUNT_FILE=".claude/metrics/edit-counts.log"

# Increment count
CURRENT=$(grep "^$FILE:" "$COUNT_FILE" | cut -d: -f2 || echo "0")
NEW=$((CURRENT + 1))

sed -i "/^$FILE:/d" "$COUNT_FILE"
echo "$FILE:$NEW" >> "$COUNT_FILE"

# Warn at thresholds
if [ "$NEW" -eq 5 ]; then
  echo "WARNING: File edited 5 times this session"
elif [ "$NEW" -eq 10 ]; then
  echo "WARNING: File edited 10 times — possible thrashing"
fi

exit 0
```

---

#### SessionEnd Hooks — Session Bitişinde Otomatik
**Ne işe yarar:** Session bitişinde metrics güncelleme, pattern promosyon, leaderboard update.

**Örnek: update-leaderboard.sh**
```bash
# Session bitişinde agent skorlarını atomikly günceller

SESSION_FILE="$1"

# Parse agent performance table
AGENTS=$(jq -r '.agent_performance[] | .agent_name' "$SESSION_FILE")

for agent in $AGENTS; do
  status=$(jq -r ".agent_performance[] | select(.agent_name==\"$agent\") | .status" "$SESSION_FILE")
  
  case "$status" in
    "completed")
      score_delta=5
      ;;
    "failed")
      score_delta=-5
      ;;
  esac
  
  # Atomically update leaderboard with flock
  flock .claude/metrics/.leaderboard.lock \
    awk -v agent="$agent" -v delta="$score_delta" \
    'BEGIN{FS=OFS="|"} $1==agent {$3=$3+delta} 1' \
    .claude/metrics/leaderboard.md > .tmp && mv .tmp .claude/metrics/leaderboard.md
done

# Emit sentinel
touch .claude/metrics/.session-complete
```

---

### A.5 context-mode MCP Araçları

#### ctx_execute — Komut Çalıştırma (Output Sonuç)
```bash
/ctx
ctx_execute("shell", "find src/auth -name '*.ts' | wc -l")
```
**Çıktı:** "42 files" (~10 token vs ~500 raw output)

---

#### ctx_execute_file — Büyük Dosya İşleme
```bash
/ctx
ctx_execute_file("src/services/massive-service.ts", "shell", "wc -l < $FILE_CONTENT_PATH")
```
**Çıktı:** "1847 lines" (dosya context'e yüklenmedi)

---

#### ctx_batch_execute — Paralel Komut Çalıştırma
```bash
/ctx
ctx_batch_execute("shell", [
  "find src -name '*.ts' | wc -l",
  "grep -r 'TODO' src | wc -l",
  "du -sh src"
], 3)
```
**Çıktı:**
```
Results:
[0] 248 TypeScript files
[1] 12 TODO comments
[2] 3.2M src directory
```

---

#### ctx_index — Bulguları Kaydetme (Cross-Session Reuse)
```bash
/ctx
ctx_index("auth-module-analysis-2026-05-22", 
"## Bulgular\n1. JWT secret 256-bit\n2. Refresh token rotation implemented\n3. CORS wildcard kaldırılmalı", 
"prose")
```

---

#### ctx_search — Geçmiş Bulguları Arama
```bash
/ctx
ctx_search("JWT security refresh token rotation", limit=5)
```
**Çıktı:**
```
Top Results (BM25 ranked):
[1] auth-module-analysis-2026-05-22 (score: 8.4)
  "## JWT Security
   1. Refresh token rotation prevents replay attacks
   2. AccessToken 15-min, RefreshToken 7-day
   3. Invalidate old token on rotation"
   
[2] security-review-2026-05-15 (score: 6.2)
  "CORS configuration using explicit allowlist, no wildcard"
```

---

#### ctx_fetch_and_index — Web'den Fetch + İndeksleme
```bash
/ctx
ctx_fetch_and_index("https://tools.ietf.org/html/rfc7519", "jwt-rfc-7519")
```

---

#### ctx_stats — Kullanım İstatistikleri
```bash
/ctx
ctx_stats()
```
**Çıktı:**
```
Context-mode Statistics:
- Indexed sources: 12
- Total indexed tokens: ~45K
- Database size: 2.3 MB
- Last purge: 2026-05-20
```

---

#### ctx_doctor — Sağlık Kontrolü
```bash
/ctx
ctx_doctor()
```
**Çıktı:**
```
✅ MCP server running
✅ SQLite DB healthy
✅ FTS5 indexes built
⚠️ Cache dir permissions: 0755 (should be 0700)
```

---

#### ctx_upgrade — Güncelleme
```bash
/ctx
ctx_upgrade()
```

---

#### ctx_purge — Tüm Veriyi Sil
```bash
/ctx
ctx_purge()
```
**Dikkat:** Tüm indexed bilgiler silinir. Irreversible.

---

#### ctx_insight — AI Analizi
```bash
/ctx
ctx_insight()
```
**Çıktı:** "Most referenced topic: authentication (12 mentions). Recommended next action: expand JWT patterns."

---

### A.6 graphify Komutları

#### Temel Graf İnşası
```bash
/graphify . --local-only
```
**Output:** graph.json, GRAPH_REPORT.md, graph.html

---

#### Grafiği Sorgulama
```bash
/graphify query "god_nodes"
```

---

#### Deep Mode (Documents + Images)
```bash
/graphify . --mode deep
```
**Uyarı:** PDF, Markdown, Images API'ye gönderilir.

---

#### Watch Mode (Auto-Rebuild)
```bash
/graphify . --watch
```
**Davranış:** Dosya değişikliklerini dinler, otomatik rebuild eder.

---

#### jq Sorgular (graph.json)
```bash
# Top 5 god nodes
jq '.nodes | sort_by(-.degree) | .[0:5] | .[] | .id' graphify-out/graph.json

# Modüller arası calls
jq '.edges[] | select(.type == "calls")' graphify-out/graph.json | wc -l

# Community cohesion
jq '.communities | sort_by(-.cohesion) | .[0:3] | .[] | {id, cohesion}' graphify-out/graph.json
```

---

## B. Birlikte Kullanım Örnekleri (KRITIK)

Bu bölüm "/caveman + x5", "/ctx + /graphify", "graphify + T5 + T4" gibi kombinasyonları gösterir.

---

### B.1: /caveman + x5 — Hızlı Refactoring
**Senaryo:** Kısa cevaplar istenen refactoring session

**User Komutu:**
```
/caveman
Auth modülünü refactor et, JWT + OAuth 2.0 destek ekle x5
```

**Sistem Davranışı:**
1. `/caveman` flag'i ayarlanır
2. x5 multi-agent mode tetiklenir (T1, T2, T3, T4, T5)
3. PEP soruları sorulur (normal mod cevapları)
4. Task DAG'i yapılır
5. Agents paralel çalışır
6. Orchestrator çıktısı sıkıştırılır ama kod/paths değişmez

**Örnek Çıktı:**

Normal:
```
I will now analyze the authentication requirements and design a comprehensive solution that 
integrates both JWT and OAuth 2.0. Let me start by establishing the security parameters...
```

Caveman:
```
Analyzing auth requirements. JWT + OAuth 2.0 integration.

Wave 1: T5 research security standards
Wave 2: T4 consolidates findings
Wave 3: T2 design services, T3 implement endpoints
Wave 4: Reviews
```

Kod (her iki modda aynı):
```typescript
// Implemented endpoint
@PostMapping('/login')
async login(@Body() req: LoginRequest): Promise<TokenResponse> {
  const user = await this.authService.validate(req.email, req.password);
  const tokens = await this.tokenService.generateTokenPair(user.id);
  return tokens;
}
```

---

### B.2: /ctx + /graphify — Persistent Knowledge Graph
**Senaryo:** Large codebase, need to index findings for future sessions

**User Komutu:**
```
/graphify . --local-only
/ctx
ctx_index("codebase-topology-2026-05-22", graphify_report_content, "prose")
```

**Adımlar:**
1. `/graphify . --local-only` — Graph build (50+ files)
2. `cat graphify-out/GRAPH_REPORT.md` — Human-readable summary
3. `ctx_index("codebase-topology-2026-05-22", full_report_content, "prose")` — Cross-session retrieval için kaydet

**Sonuç:** Next session'da:
```
ctx_search("UserService god node architecture dependencies")
```
Dosyaları tekrar okumak yerine indexed rapordan sonuç gelir (~200 tokens vs ~5KB context).

---

### B.3: graphify + T5 + T4 — Architecture Analysis
**Senaryo:** Codebase topology, god classes, modül kuplaj analizi

**User Komutu:**
```
Codebase'deki god classes'ı tespit et ve refactoring planı oluştur x5
```

**Sistem İçinde:**

**Wave 1 (T5 Research):**
```bash
# T5 runs
/graphify . --local-only
cat graphify-out/GRAPH_REPORT.md

# Extract god nodes
jq '.nodes | map(select(.degree > 15))' graphify-out/graph.json

# Analyze communities
jq '.communities | sort_by(-.cohesion)' graphify-out/graph.json
```

**T5 Output:** `.claude/analysis/raw/T5-god-classes-analysis.md`
```markdown
# God Class Analysis

## Findings
1. **UserService** (degree: 42) — SRP violation
   - Handles: auth, profile, settings, notifications
   - Should decompose into 4 services

2. **DatabaseRepository** (degree: 28) — Feature envy
   - Used by 18 different services
   - Should extract common query patterns

3. **AuthController** (degree: 22) — Mixed concerns
   - Handles: login, registration, password reset, 2FA
   - Should split into separate endpoints
```

**Wave 2 (T4 Consolidation):**
T4 synthesizes T5 findings into refactoring blueprint:
```markdown
# Refactoring Plan — God Class Decomposition

## Priority 1: UserService
Split into:
- AuthService (login, logout, session)
- ProfileService (avatar, bio, settings)
- NotificationPreferenceService

Timeline: 1 week
Impact: Reduces cyclomatic complexity from 42 to ~12 per service
```

**Wave 3-4 (T2/T3 Implementation + Review)**

---

### B.4: /caveman + /architect — Kısa Architectural Tavsiye
**Senaryo:** Quick architectural decision, no implementation

**User Komutu:**
```
/caveman
/architect
Database migration strategy: Postgres → MongoDB? Pros/cons?
```

**Davranış:**
- `/caveman` activated (terse output)
- `/architect` routes to T1 Principal (opus)
- No xN, no other agents

**Çıktı (Compressed):**
```
Postgres advantages: ACID, relational integrity, proven at scale.
MongoDB advantages: flexible schema, horizontal sharding, developer-friendly.

Recommendation: Keep Postgres.
- Your data is relational (users, orders, products)
- ACID guarantees critical for financial transactions
- Team has Postgres expertise
- Migration cost: ~20K engineering time, unproven ROI

If moving: Use application-level migration (dual-write, gradual cutover).
```

---

### B.5: x10 + /graphify — Full System Audit
**Senaryo:** Critical audit, need graph + all agents

**User Komutu:**
```
Tüm codebase'i audit et: god classes, test gaps, security issues. x10 /graphify
```

**Sistem İçinde:**

**Wave 1 (2×T5 Research Parallel):**
```
T5-A: Topology analysis (graphify, god nodes)
T5-B: Security audit (secrets, injection, XSS)
```

**Wave 2 (2×T4 Consolidation Parallel):**
```
T4-A: Architecture brief (from T5-A findings)
T4-B: Security brief (from T5-B findings)
```

**Wave 3 (2×T2 Design + 2×T3 Implementation Parallel):**
```
T2-A: Design god class refactoring
T3-A: Implement UserService decomposition

T2-B: Design security hardening
T3-B: Implement security fixes
```

**Wave 4-6 (Review Chain Sequential)**

---

### B.6: /ctx + Long-Running Session — Knowledge Persistence
**Senaryo:** Session compaction happens mid-task, need to preserve findings

**User Komutu:**
```
/ctx
# Multiple T5 analyses happen
ctx_index("session-checkpoint-1", findings_a, "prose")
ctx_index("session-checkpoint-2", findings_b, "prose")
```

**Davranış:**
1. Session compaction triggers (context too large)
2. Old findings indexed before compaction
3. New session starts, agents call:
   ```bash
   ctx_search("prior findings about auth security")
   ```
4. Retrieved from FTS5, not from files

---

### B.7: /security-review + x3 — Focused Security Audit
**Senaryo:** Quick security-focused review, not full refactoring

**User Komutu:**
```
/security-review
```

**Agent Allocation:**
- T1 Principal (final decision)
- T2 Staff Engineer (security patterns review)
- T5 Analyst (security research)

**Wave Execution:**
```
Wave 1: T5 security research
Wave 2: T2 reviews T5 security findings
Wave 3: T1 approves critical findings only
```

---

### B.8: /review + /caveman — Hızlı Code Review
**Senaryo:** Code review isteniyor, kısa cevaplar

**User Komutu:**
```
/caveman
/review
```

**Çıktı:**
```
Review findings:

🟠 src/auth/service.ts:45
Function exceeds 20 lines. Split validation and transformation.

🟡 src/auth/controller.ts:12
Parameter name 'data' unclear. Use 'loginRequest'.

✅ Test coverage adequate
✅ Error handling complete
✅ No security issues
```

---

### B.9: graphify + ctx_index — Cross-Project Knowledge Base
**Senaryo:** Multiple projects, shared architectural patterns

**Session 1 (Project A):**
```bash
/graphify . --local-only
ctx_index("project-a-topology-2026-05", graphify_report, "prose")
```

**Session 2 (Project B):**
```bash
/ctx
ctx_search("shared module dependency patterns project-a")
# Returns patterns from Project A's graph
```

---

### B.10: /test-gen + x3 — Generate + Review Tests
**Senaryo:** Auto-generate test suite, have reviewers approve

**User Komutu:**
```
/test-gen src/features/auth/auth-service.ts x3
```

**Agent Allocation:**
- T1, T2 (review quality)
- T5 (research testing patterns)

**Wave Execution:**
```
Wave 1: T5 research testing best practices
Wave 2: T2 reviews generated tests, suggests improvements
Wave 3: T1 approves
```

**Output:** Reviewed test suite, guaranteed high quality

---

### B.11: /caveman + Plan Mode — Kısa Planlama
**Senaryo:** Complex task, planning mode activated, compressed output

**User Komutu:**
```
/caveman
Microservices mimarisinden monolithe migration x10
```

**PEP (Normal Mode):**
```
1. Target language? → Recommendation: Java (matches current)
2. Scope? → Recommendation: Start with auth, user services
3. DB strategy? → Recommendation: Single Postgres, separate schemas
4. Timeline? → Recommendation: 3 weeks, phased approach
```

**Plan (Caveman Mode):**
```
## x10 Migration Plan

Wave 1 (T5×2 parallel): Research monolith patterns, migration strategies
Wave 2 (T4×2 parallel): Consolidate architecture + migration roadmap
Wave 3-4 (T2×2, T3×2): Design + implement migration in phases
  - Phase 1: Auth service (1 week)
  - Phase 2: User service (1 week)
  - Phase 3: Order service (1 week)
Wave 5-6: Reviews

Cost: ~$15 | Time: 30 minutes
```

---

### B.12: /architect + Custom Hook — Architecture-Led Design
**Senaryo:** T1 design'ı, custom hook enforce policy

**User Komutu:**
```
/architect
Yeni API versioning stratejisi tasarla. API v1, v2, v3 destek etmeli.
```

**T1 Output:**
```
## API Versioning Strategy

### Option 1: URL Path Versioning
GET /api/v1/users
GET /api/v2/users (different schema)

Pros: Clear, RESTful, easy to deprecate
Cons: URL duplication, parameter repetition

### Option 2: Header Versioning (RECOMMENDED)
GET /api/users
Header: API-Version: 2

Pros: Single URL, backward compatible, clean
Cons: Less discoverable

Recommendation: Use header versioning with v1 sunset in 12 months.
```

**Custom Hook (Enforcement):**
```bash
# .claude/hooks/api-versioning-check.sh
# Ensures all new endpoints follow approved versioning pattern

if grep -q "api/v[0-9]" "$FILE" && ! grep -q "API-Version.*header" "$FILE" ; then
  echo "BLOCKED: Use header versioning, not URL path"
  exit 2
fi
```

---

## C. İleri Düzey Walkthrough'lar

### C.1: Başlangıç — /caveman + Basit Fix

**Senaryo:** Yeni user, typo fix, caveman mode

**User Komutu:**
```
/caveman
Hocam, comment'teki typo'yu düzelt: "usre" → "user"
Dosya: src/features/user/user-service.ts:42
```

**Orchestrator Analysis:**
- Task: Trivial (1 line, typo)
- No xN
- Single-agent mode
- Caveman mode: ON

**Execution:**
1. Read file: `src/features/user/user-service.ts`
2. Find line 42: `// Check usre ID`
3. Replace with: `// Check user ID`
4. Write file
5. No hooks triggered (comment change)

**Output (Compressed):**
```
✅ Fixed typo at src/features/user/user-service.ts:42

Before: // Check usre ID
After:  // Check user ID

Done.
```

**Metrics:**
- Cost: $0
- Time: 10 seconds
- Agents: 0 (Orchestrator only)
- Session file: Not created

---

### C.2: Orta Düzey — x5 + /ctx + API Endpoint

**Senaryo:** User profile API endpoint, context-mode enabled for knowledge retention

**User Komutu:**
```
Kullanıcı yönetim modülüne GET /users/:id/profile endpoint'i ekle.
Profile şu alanları dönmeli: email, displayName, bio, profilePictureUrl, createdAt.
Sadece profile sahibi veya admin görebilsin. x5 /ctx
```

**Orchestrator Analysis:**
- Task complexity: Medium-High
- Files affected: 3-5 (controller, service, DTO, entity)
- Not trivial: Business logic, auth required
- PEP Required: YES
- /ctx enabled: Knowledge will be indexed

**Prompt Enrichment Protocol:**

```
1. Profil resmi storage'ı nerede? (S3 pre-signed URL önerilir)
2. Cache stratejisi? (5-min Redis önerilir)
3. Profil resim upload aynı endpoint'te mi? (Ayrı PATCH önerilir)
4. Rate limiting? (100 req/min per user önerilir)
```

**User:** "Tamam, defaults'u kabul ediyorum."

---

**Task Planning (Orchestrator):**

```markdown
## x5 Multi-Agent Plan

### Wave 1: Analysis (T5 Analyst — 2 hours)
- TASK-001: Research user profile patterns, caching strategy, S3 integration

### Wave 2: Consolidation (T4 Lead Analyst — 1.5 hours)
- TASK-002: Synthesize findings into architecture brief

### Wave 3: Implementation (T2 + T3 parallel)
- TASK-003 (T2 Staff Engineer): Design ProfileService, caching layer
- TASK-004 (T3 MidCoder): Implement controller + DTOs + repository

### Wave 4: Code Review (Sequential)
- TASK-005 (T2 reviews T3): Code quality, error handling
- TASK-006 (T1 reviews T2): Architecture, final approval

### Estimated Cost: $4-6 | Time: 12-15 minutes
```

**User:** "Başla"

---

**Wave 1 Execution (T5 Analyst, ~4K tokens):**

T5 researches:
- User entity JPA mapping
- Profile data exposure patterns
- Redis caching options
- S3 pre-signed URL implementation
- Authorization patterns (owner or admin check)

**T5 Output:** `.claude/analysis/raw/T5-profile-research.md`

```markdown
# User Profile Endpoint Research

## Findings

### Data Structure
User entity has 12 fields. Expose only: id, email, displayName, bio, profilePictureUrl, createdAt
Privacy fields (password_hash, phone_number, address) remain unexposed.

### Authorization
- Owner (User.id == RequestedUserId): Can view
- Admin (User.role = ADMIN): Can view any
- Other users: 403 Forbidden

### Caching Strategy
Redis with 5-min TTL recommended. Invalidate on:
- User profile update
- Admin changes
- Picture upload

### S3 Integration
Profile picture stored in S3. Return pre-signed URL (1-hour expiry):
- Prevents direct image URL exposure
- Handles permission revocation cleanly
- Reduces bandwidth from app server

## Risks
- N+1 on related data (posts count, followers count)
  Mitigation: Use @Query with subquery count, cache separately
- S3 URL expiry mismatch with cache TTL
  Mitigation: URL 1-hour, cache 5-min (re-fetch before expiry)

## Recommendation
Safe to implement. Use @Cacheable annotation + Redis cache manager.
```

**T4 Review:** ✅ APPROVED

---

**Wave 2 Execution (T4 Lead Analyst, ~2K tokens):**

T4 consolidates T5 findings:

```markdown
# User Profile Endpoint — Architecture Brief

## Design Decision
- **Endpoint:** GET /api/v1/users/{userId}/profile
- **Response:** UserProfileDTO
- **Cache:** Redis, 5-min TTL, invalidate on update
- **Authorization:** Owner or admin
- **Picture URL:** Pre-signed S3 (1-hour expiry)

## Service Layer

### UserProfileService
```
getProfile(userId: String, requesterId: Long): UserProfile
├── Check authorization (owner or admin)
├── Load user from repository
├── Check/invalidate cache
├── Generate S3 pre-signed URL if picture exists
└── Return UserProfile DTO
```

## Error Handling
- 404: User not found
- 403: Unauthorized (not owner, not admin)
- 500: Cache/S3 failure (log + fallback to no picture)

## Testing
- Happy path: Owner/admin can view
- Auth boundary: Non-owner gets 403
- Cache: Repeated requests use cache
- S3: Picture URL expires correctly
```

**T1 Review:** ✅ APPROVED

---

**Wave 3 Execution (T2 + T3 parallel, ~7K tokens)**

**T3 Implementation (Controller + DTOs):**

```java
// UserProfileController.java
@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserProfileController {

    private final UserProfileService userProfileService;

    @GetMapping("/{userId}/profile")
    @Operation(summary = "Get user profile")
    public ResponseEntity<ApiResponse<UserProfileDTO>> getProfile(
            @PathVariable String userId,
            @RequestAttribute Long requesterId) {
        
        UserProfileDTO profile = userProfileService.getProfile(userId, requesterId);
        return ResponseEntity.ok(ApiResponse.success(profile));
    }
}
```

```java
// UserProfileDTO.java
public record UserProfileDTO(
    String id,
    String email,
    String displayName,
    String bio,
    String profilePictureUrl,
    LocalDateTime createdAt
) {}
```

**T2 Design (Service Layer):**

```java
// UserProfileService.java
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
            throw new UnauthorizedError("Cannot view this profile");
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
}
```

---

**Wave 4 Code Review (Sequential):**

**T2 Reviews T3:**
```
✅ Controller uses @Validated, proper path variable handling
✅ DTO uses record syntax (immutable, compact)
✅ Error handling comprehensive

🟡 Minor: Add @NotBlank to userId parameter

Overall: APPROVED
```

**T1 Reviews T2:**
```
✅ Architecture sound
  - Service layer isolation correct
  - Caching at right level (@Cacheable on service method)
  
✅ Authorization correct
  - Checked before data access
  - No information leakage

✅ S3 integration safe
  - Pre-signed URL expires appropriately
  - No direct S3 access credentials in response

APPROVED — Ready to merge
```

---

**Wave 5: Knowledge Indexing (context-mode):**

T5 calls (after analysis complete):
```bash
/ctx
ctx_index("user-profile-api-2026-05-22", full_analysis_content, "prose")
```

**Effect:** Next session, developer can:
```bash
ctx_search("user profile caching S3 pre-signed URL")
# Returns findings from this session without re-reading files
```

---

**Final Output (Orchestrator Consolidation):**

```markdown
## Implementation Complete ✅

### Endpoint Deployed
GET /api/v1/users/{userId}/profile

### Response Schema
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

### Authorization
- Owner: ✅ Can view
- Admin: ✅ Can view any
- Other user: ✅ Gets 403

### Caching
- Strategy: Redis, 5-min TTL
- Invalidation: On profile update
- Hit rate expected: ~80% (5-min window)

### Files Created
- src/main/java/com/example/user/controller/UserProfileController.java
- src/main/java/com/example/user/dto/UserProfileDTO.java
- src/main/java/com/example/user/service/UserProfileService.java

### Testing Scenarios
[ ] Owner views own profile → 200 + data
[ ] Admin views any profile → 200 + data
[ ] Other user views profile → 403 Forbidden
[ ] Nonexistent user → 404 Not Found
[ ] Cache hit (same user, <5 min) → 200 (from cache)
[ ] S3 URL expiry → URL valid for 1 hour

---

## Session Performance Report

### Summary
Mode: x5 | Tasks: 5 | Completed: 5 | Failed: 0

### Agent Performance
| Agent | Tier | Task | Status | Tokens | Revisions |
|-------|------|------|--------|--------|-----------|
| Onur A. (T5) | Haiku | Research | ✅ | 38K | 0 |
| Elif B. (T4) | Haiku | Consolidation | ✅ | 32K | 0 |
| Taner Y. (T3) | Sonnet | Controller + DTO | ✅ | 48K | 0 |
| Enis K. (T2) | Sonnet | Service design | ✅ | 58K | 0 |
| Selin A. (T1) | Opus | Final review | ✅ | 82K | 0 |

**Total: 258K tokens (~$1.29)**

### Learned Patterns (New This Session)
None

### Files Changed
✏️ 3 new files created
📝 0 existing files modified
```

**Time:** ~12 minutes  
**Cost:** ~$1.50  
**Knowledge Preserved:** Yes (indexed with /ctx)

---

### C.3: İleri Düzey — x10 + /graphify System Audit

**Senaryo:** Critical system audit, full team, graph analysis, knowledge persistence

**User Komutu:**
```
Tüm codebase'i audit et: 
- God classes ve refactoring ihtiyaçları
- Test coverage boşlukları  
- Security issues (injection, XSS, auth)
- Performance bottlenecks
Bulguları düzelt. x10 /graphify /ctx
```

**Orchestrator Analysis:**
- Scope: ENTIRE CODEBASE (60+ files)
- Complexity: CRITICAL
- Multi-concern: Architecture + Security + Testing + Performance
- PEP Required: YES
- /graphify: MANDATORY (>20 files)
- /ctx: ENABLED (findings will be indexed)

**PEP Questions:**

```
1. Refactoring scope? → All god classes or top 3? 
   Recommendation: Top 3 (UserService, DatabaseRepo, AuthController)

2. Test coverage target?
   Recommendation: 80% for existing, 90% for new changes

3. Security audit scope?
   Recommendation: All backend, frontend (JS) deferred to next sprint

4. Timeline?
   Recommendation: Phased (audit this week, fixes next 2 weeks)

5. Breaking changes acceptable?
   Recommendation: No (maintain API compatibility)
```

**User:** "Tamam başla"

---

**Task Planning (Orchestrator x10):**

```markdown
## x10 Codebase Audit + Refactor Plan

### Wave 1: Research (2×T5 parallel, ~1 hour)
- TASK-001 (T5 Onur): Topology analysis (graphify, god nodes, module coupling)
- TASK-002 (T5 Necati): Security audit (injection, XSS, auth, CORS, JWT)

### Wave 2: Consolidation (2×T4 parallel, ~45 min)
- TASK-003 (T4 Elif): Architecture brief (god classes + refactoring plan)
- TASK-004 (T4 Ayse): Security brief (risk assessment + prioritized fixes)

### Wave 3: Design (2×T2 parallel, ~1.5 hours)
- TASK-005 (T2 Enis): Refactoring design (UserService decomposition)
- TASK-006 (T2 Tarik): Test framework design (coverage improvements)

### Wave 4: Implementation (2×T3 parallel, ~2 hours)
- TASK-007 (T3 Taner): Implement UserService split
- TASK-008 (T3 Canan): Implement test coverage + security fixes

### Wave 5: Code Review (Sequential, ~1 hour)
- TASK-009 (T2 Enis): Review T3 Taner code
- TASK-010 (T2 Tarik): Review T3 Canan code
- TASK-011 (T1 Selin): Review T2 Enis + architecture
- TASK-012 (T1 Baris): Review T2 Tarik + tests

### Estimated Cost: $14-20 | Time: 20-30 minutes
```

---

**Wave 1 Execution (2×T5 Research Parallel)**

**T5 Onur — Topology Analysis (~5K tokens):**

```bash
# Step 1: Build graph
/graphify . --local-only

# Step 2: Read GRAPH_REPORT
cat graphify-out/GRAPH_REPORT.md

# Step 3: Identify god nodes via jq
jq '.nodes | map(select(.degree > 15)) | sort_by(-.degree)' graphify-out/graph.json

# Step 4: Index findings
/ctx
ctx_index("topology-audit-2026-05-22", topology_findings, "prose")
```

**Output:** `.claude/analysis/raw/T5-topology-audit.md`

```markdown
# Codebase Topology Analysis

## God Nodes (SRP Violations)

### 1. UserService (degree: 42) — CRITICAL
- Incoming: 15 classes depend on UserService
- Outgoing: 27 method calls to other services
- Responsibilities: auth, profile, settings, notifications, password reset, 2FA
- Risk: Changes affect half the codebase
- Recommendation: Split into 4 services

### 2. DatabaseRepository (degree: 28) — HIGH
- Used by: 18 different services
- Risk: Any DB change impacts many layers
- Recommendation: Extract query patterns, create specific repositories

### 3. AuthController (degree: 22) — MEDIUM
- Mixed concerns: login, registration, password reset, 2FA
- Recommendation: Split into 2 controllers (AuthController, PasswordController)

## Community Analysis
- Community 1 (Auth): 8 classes, cohesion 0.89 (healthy)
- Community 2 (User): 12 classes, cohesion 0.76 (acceptable)
- Community 3 (Data): 15 classes, cohesion 0.62 (divergent change risk)

## Surprising Connections
- UserService → CacheService (distance 2) — should use wrapper
- AuthController → EmailService (distance 3) — violates layer separation
```

**T5 Necati — Security Audit (~4K tokens):**

```markdown
# Security Audit

## Critical Findings

### Code Security
Type: String concatenation patterns where query construction occurs
Risk: Potential injection vectors
Fix: Use parameterized approach consistently

### Secret Management
Type: Secrets from environment variables
Current: Using environment for secrets (secure approach)
Status: Verified properly configured

### CORS Configuration
Type: Configuration-based security
Current: Uses allowlist from configuration
Status: Verified proper implementation

### Rate Limiting
Type: Endpoint protection
Status: Missing on authentication endpoints
Fix: Implement rate limiting (5 req/min per IP)

## Test Coverage Gaps
- LoginService: 62% (should be 90%)
- PasswordResetService: 44% (should be 90%)
- OAuthProvider: 30% (should be 90%)
```

---

**Wave 2 Consolidation (2×T4 parallel)**

T4 synthesizes T5 findings into briefs:

**T4 Elif — Architecture Brief (~3K tokens):**

```markdown
# Architecture Refactoring Plan

## Phase 1: UserService Decomposition (Week 1)

Split UserService (degree 42) into:

### 1. AuthService
- Responsibilities: Login, logout, token generation/validation
- Dependencies: TokenProvider, UserRepository
- Expected degree: 18

### 2. ProfileService  
- Responsibilities: Avatar, bio, display name, settings
- Dependencies: UserRepository, S3Service
- Expected degree: 8

### 3. NotificationService
- Responsibilities: Email notifications, notification preferences
- Dependencies: UserRepository, EmailService
- Expected degree: 6

### 4. PasswordService
- Responsibilities: Password reset, change, validation
- Dependencies: UserRepository, EmailService
- Expected degree: 5

## Impact Assessment
- 12 files to refactor
- 8 existing tests to update
- 2 new test files to create
- Breaking changes: None (internal reorganization)
- Timeline: 1 week

## Success Metrics
- UserService degree: 42 → 4 (only local methods)
- Each new service degree: < 12 (healthy)
- Codebase cohesion improves: 0.62 → 0.78
```

**T4 Ayse — Security Brief (~3K tokens):**

```markdown
# Security Hardening Plan

## Critical Fixes (Must fix before merge)

### 1. Injection Prevention
Files: Data access layer
Change: Ensure all queries use parameterized approach
Effort: 2 hours
Verification: Code review + static analysis

### 2. Secret Management
Files: Configuration
Change: Verify secrets loaded from environment
Effort: 30 minutes
Verification: Environment variable check

### 3. CORS Configuration
Files: API config
Change: Verify allowlist properly implemented
Effort: 15 minutes
Verification: Manual test of cross-origin requests

## High Priority Fixes (Week 2)

### 4. Rate Limiting
Implement: LoginController, PasswordResetController
Limit: 5 requests/minute per IP
Effort: 3 hours
Verification: Automated tests for rate limiting

### 5. Test Coverage
Target: 90% for auth + password modules
Current: 62% + 44%
Effort: 8 hours
Verification: Coverage report

## Risk Assessment
- Current risk level: MEDIUM
- After critical fixes: LOW
```

---

**Wave 3 Design (2×T2 parallel)**

**T2 Enis — Refactoring Design (~6K tokens):**

```java
// Architecture design for UserService decomposition
// (Detailed interface definitions, transaction boundaries, error handling patterns)

public interface AuthService {
  TokenPair login(String email, String password);
  void logout(String userId);
  UserClaims validateToken(String token);
}

public interface ProfileService {
  UserProfile getProfile(String userId);
  void updateProfile(String userId, ProfileUpdateRequest req);
  void uploadProfilePicture(String userId, byte[] image);
}
// ... etc for 4 services

// Migration strategy:
// 1. Create new services alongside old UserService
// 2. Refactor callers: old UserService → specific service
// 3. Remove old UserService after all callers migrated
// 4. Timeline: 1 week for phased migration
```

**T2 Tarik — Test Framework Design (~5K tokens):**

```markdown
# Test Coverage Strategy

## Current State
- AuthService: 62% coverage (12/18 methods)
- PasswordService: 44% coverage (5/11 methods)
- LoginController: 78% coverage (7/9 endpoints)

## Target State (90%)
- All happy paths tested
- All error paths tested
- Edge cases + boundary conditions tested

## Implementation
- Testing framework: JUnit 5 + Mockito
- Fixtures: testcontainers for PostgreSQL + Redis
- Test structure: AAA pattern (Arrange-Act-Assert)
- Coverage tool: JaCoCo with 90% enforcement gate

## Effort Estimate
- Write 45 new test cases: 8 hours
- Review + refactor: 2 hours
- Total: 10 hours
```

---

**Wave 4 Implementation (2×T3 parallel, ~2.5 hours)**

**T3 Taner — Implement UserService Decomposition:**
- Create AuthService.java, ProfileService.java, etc.
- Migrate dependencies
- Update tests
- Status: ✅ APPROVED by T2 (code quality, architecture)

**T3 Canan — Implement Security Fixes + Tests:**
- Verify parameterized queries used throughout
- Update JWT configuration
- Update CORS configuration
- Add rate limiting
- Write 45 test cases
- Status: ✅ APPROVED by T2 (security verified, coverage adequate)

---

**Wave 5 Review (Sequential, ~1.5 hours)**

**T2 Reviews Code:**
- T2 Enis reviews T3 Taner (refactoring)
  - ✅ Approved (proper decomposition, low coupling)
- T2 Tarik reviews T3 Canan (security + tests)
  - ✅ Approved (injection prevented, 90% coverage achieved)

**T1 Final Review:**
- T1 Selin reviews refactoring
  - ✅ Approved (SRP upheld, future extensible)
- T1 Baris reviews security + tests
  - ✅ Approved (vulnerabilities mitigated, comprehensive test coverage)

---

**Wave 6: Knowledge Indexing**

```bash
/ctx
ctx_index("codebase-audit-2026-05-22", full_audit_report, "prose")
```

**Effect:** Next session:
```bash
ctx_search("god nodes UserService refactoring architecture")
# Returns audit findings without re-reading 60 files
```

---

**Final Output (Orchestrator Consolidation):**

```markdown
## System Audit Complete ✅

### Metrics Improved

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Max god node degree | 42 | 12 | -71% |
| Avg service degree | 18 | 8 | -56% |
| Codebase cohesion | 0.62 | 0.78 | +26% |
| Test coverage | 68% | 92% | +24% |
| Security findings | 5 issues | 0 | 100% fixed |

### Refactoring Completed
- UserService split into 4 focused services
- DatabaseRepository refactored (common query patterns extracted)
- AuthController split into 2 controllers

### Security Fixed
✅ Injection prevention (parameterized throughout)
✅ Secret management (environment-based)
✅ CORS (explicit allowlist)
✅ Rate limiting (5 req/min on auth endpoints)

### Test Coverage
✅ AuthService: 62% → 92%
✅ PasswordService: 44% → 91%
✅ LoginController: 78% → 95%

### Files Changed
✏️ 12 files refactored
✏️ 45 test cases added
✏️ 1 new security configuration file
📝 0 files deleted (backward compatible)

---

## Session Performance Report

### Summary
Mode: x10 | Tasks: 12 | Completed: 12 | Failed: 0

### Agent Performance
| Agent | Tier | Task | Status | Tokens | Revisions |
|-------|------|------|--------|--------|-----------|
| Onur A. (T5) | Haiku | Topology | ✅ | 44K | 0 |
| Necati D. (T5) | Haiku | Security | ✅ | 40K | 0 |
| Elif B. (T4) | Haiku | Arch brief | ✅ | 36K | 0 |
| Ayse M. (T4) | Haiku | Security brief | ✅ | 34K | 0 |
| Enis K. (T2) | Sonnet | Refactor design | ✅ | 68K | 0 |
| Tarik S. (T2) | Sonnet | Test design | ✅ | 62K | 0 |
| Taner Y. (T3) | Sonnet | UserService impl | ✅ | 58K | 0 |
| Canan P. (T3) | Sonnet | Security + tests | ✅ | 72K | 0 |
| Selin A. (T1) | Opus | Arch review | ✅ | 94K | 0 |
| Baris B. (T1) | Opus | Security review | ✅ | 92K | 0 |

**Total: 600K tokens (~$3.00)**

### Learned Patterns (New This Session)
None

### Files Changed
✏️ 12 new/modified files
📝 45 new test cases
```

**Time:** ~25 minutes  
**Cost:** ~$3.00  
**Knowledge Preserved:** Yes (indexed with /ctx for next audit)

---

## D. Özet

### Tekil Özellikler (32 Feature)
- 6 Slash komutları (/caveman, /ctx, /graphify, /review, /security-review, /architect)
- 7 xN modları (no xN, x2, x3, x4, x5, x7, x10)
- 5 Tier'i (T1-T5, her biri detaylı örnek)
- 4 Hook kategorisi (PreToolUse:Edit, PreToolUse:Bash, PostToolUse, SessionEnd)
- 11 context-mode MCP araçları
- 5+ graphify komutları

### Birlikte Kullanım (12 Kombinasyon)
1. /caveman + x5 — Hızlı refactoring
2. /ctx + /graphify — Persistent knowledge
3. graphify + T5 + T4 — Architecture analysis
4. /caveman + /architect — Kısa tavsiye
5. x10 + /graphify — Full audit
6. /ctx + Long session — Persistence
7. /security-review + x3 — Security audit
8. /review + /caveman — Hızlı review
9. graphify + ctx_index — Knowledge base
10. /test-gen + x3 — Test generation + review
11. /caveman + Plan — Kısa planlama
12. /architect + Hook — Architecture-led design

### İleri Walkthroughs (3)
1. **Başlangıç:** /caveman + typo fix (10 seconds, $0)
2. **Orta:** x5 + /ctx + profile API (12 min, $1.50)
3. **İleri:** x10 + /graphify + /ctx + full audit (25 min, $3.00)

---

**Document Complete**
- Katalog örnekleri: 52
- Kombinasyon örnekleri: 12
- Detaylı walkthrough'lar: 3
- Türkçe komutlar: 100% authenticity
- Copy-paste enabled: ✅ Tüm örnekler
