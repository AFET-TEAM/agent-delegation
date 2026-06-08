# Knowledge Graph (Bilgi Grafiği Tabanlı Analiz)

> Kaynak ilham: [safishamsi/graphify](https://github.com/safishamsi/graphify)

## Ne İşe Yarar?

Knowledge Graph, codebase'i bir **ilişki ağı** olarak analiz etmeyi sağlayan metodolojik bir skill'dir. Dosyalar arası bağımlılıkları, kritik düğümleri (god nodes) ve gizli ilişkileri keşfeder — ve her bulguyu bir **güven seviyesi** ile etiketler.

---

## Temel Kavramlar

### 1. Query-First (Önce Sorgula)

**Kural**: Bir dosyayı okumadan önce, gerçekten o dosyayı okumanın gerekli olup olmadığını sorgula.

#### Karar Ağacı

```
İhtiyacın ne?
├── Bilinen dosya yolu → view (doğrudan oku)
├── Sembol/fonksiyon adı → grep (ara, sonra oku)
├── Dosya yapısı/listesi → glob (pattern ile bul)
├── Bağımlılık ilişkisi → grep "import" + grep "from"
└── Genel yapı anlayışı → glob + view_range (ilk 30 satır)
```

#### Örnek: "AuthService kimler tarafından kullanılıyor?"

❌ **Query-First olmadan**:
```
1. src/ altındaki tüm .ts dosyalarını listele (150 dosya)
2. Her birini oku
3. İçinde "AuthService" geçenleri not et
→ 150 dosya × ~2000 token = ~300,000 token harcandı
```

✅ **Query-First ile**:
```
1. grep "AuthService" src/ --files-with-matches
→ 8 dosya bulundu (~30 token harcandı)
2. Sadece bu 8 dosyanın ilgili satırlarını oku
→ 8 × ~200 token = ~1,600 token
```

**Tasarruf**: ~298,000 token (tek sorgu için)

---

### 2. Confidence Tagging (Güven Etiketleme)

Her analiz bulgusu bir güven seviyesi ile etiketlenir:

| Seviye | Emoji | Anlamı | Ne Zaman Kullanılır |
|--------|-------|--------|-------------------|
| EXTRACTED | 🟢 | Doğrudan kaynaktan alındı | Kod satırı, config değeri, import statement |
| INFERRED | 🟡 | Çıkarım yapıldı | Pattern eşleştirme, dolaylı ilişki, konvansiyon |
| AMBIGUOUS | 🔴 | Belirsiz | Birden fazla yorum mümkün, doğrulama gerekli |

#### INFERRED Güvenilirlik Puanı

INFERRED bulgular 0.0-1.0 arası bir puan alır:

| Puan | Anlamı | Örnek |
|------|--------|-------|
| 0.9+ | Neredeyse kesin | "Dosya adı `user-repository.ts` → Repository pattern kullanıyor" |
| 0.7-0.8 | Büyük olasılıkla | "3 test dosyası var ama coverage raporu yok → test coverage düşük olabilir" |
| 0.5-0.6 | Olası ama belirsiz | "Logger import var ama kullanım görünmüyor → dead code olabilir" |
| <0.5 | Spekülatif | "Dosya büyük → refactoring gerekebilir" |

#### Örnek Kullanım

```markdown
## Auth Modülü Analizi

🟢 EXTRACTED | `src/auth/auth.module.ts:3` | AuthService, JwtModule'e bağımlı
🟢 EXTRACTED | `src/auth/auth.service.ts:45` | bcrypt ile password hashing yapılıyor
🟡 INFERRED (0.85) | auth.guard.ts + jwt.strategy.ts | Passport.js JWT strategy kullanılıyor
🟡 INFERRED (0.6) | refresh-token yokluğu | Token rotation implementasyonu eksik olabilir
🔴 AMBIGUOUS | auth.controller.ts:78 | Rate limiting var mı belirsiz — middleware katmanı incelenmeli
```

---

### 3. God Node Detection (Kritik Düğüm Tespiti)

**Tanım**: 5 veya daha fazla gelen/giden bağlantısı olan bir dosya/modül **god node**'dur.

**Neden önemli**: God node'lar değiştirildiğinde sistemin büyük bölümü etkilenir. Refactoring'de öncelikli hedeflerdir.

#### Nasıl Tespit Edilir

```bash
# Gelen bağlantılar (kim bu dosyayı import ediyor):
grep -r "from.*user-service" src/ --files-with-matches | wc -l

# Giden bağlantılar (bu dosya kimi import ediyor):
grep "^import" src/services/user-service.ts | wc -l
```

#### Örnek God Node Raporu

```markdown
## God Node Tespiti

| Dosya | Gelen | Giden | Toplam | Risk |
|-------|-------|-------|--------|------|
| src/services/user-service.ts | 12 | 8 | 20 | 🔴 Kritik |
| src/utils/helpers.ts | 9 | 2 | 11 | 🟠 Yüksek |
| src/config/index.ts | 7 | 1 | 8 | 🟡 Orta |
| src/auth/auth.guard.ts | 6 | 3 | 9 | 🟠 Yüksek |

**Öneri**: user-service.ts SRP ihlali yapıyor — UserQueryService ve UserCommandService olarak ayrılmalı.
```

---

### 4. Progressive Disclosure (Aşamalı İfşa)

Analizi 4 aşamada derinleştir — her aşama öncekinin üzerine biner:

```
Aşama 1: SHAPE (Şekil)
  └─ Klasör yapısı, dosya sayıları, genel mimari

Aşama 2: INTERFACE (Arayüz)
  └─ Public API'ler, export edilen tipler, modül sınırları

Aşama 3: LOGIC (Mantık)
  └─ İç implementasyon, algoritmalar, veri akışı

Aşama 4: DETAIL (Detay)
  └─ Edge case'ler, performans, güvenlik, test coverage
```

#### Örnek: "Auth modülünü analiz et"

**Aşama 1 — Shape**:
```
src/auth/
├── auth.module.ts (giriş noktası)
├── auth.controller.ts (3 endpoint)
├── auth.service.ts (5 metot)
├── guards/ (2 guard)
└── strategies/ (1 strategy)
```

**Aşama 2 — Interface**:
```
Dış dünyaya açık:
- POST /auth/login → { accessToken, refreshToken }
- POST /auth/register → { user }
- POST /auth/refresh → { accessToken }

Guard'lar:
- JwtAuthGuard (global endpoint koruması)
- RolesGuard (role-based access)
```

**Aşama 3 — Logic** (sadece gerekirse):
```
Login akışı:
1. Email/password validate → bcrypt.compare()
2. User entity yükle → TypeORM findOne()
3. JWT token üret → jwtService.sign({ sub, email, roles })
4. Refresh token kaydet → refreshTokenRepository.save()
```

**Aşama 4 — Detail** (sadece istenirse):
```
Güvenlik: ✅ bcrypt rounds=12, ✅ JWT expiry 15m
Eksik: ❌ Rate limiting, ❌ Account lockout, ❌ Token blacklist
```

---

### 5. Relationship Mapping (İlişki Haritalama)

Dosyalar/modüller arasındaki ilişki türleri:

| İlişki Türü | Sembol | Açıklama | Örnek |
|-------------|--------|----------|-------|
| imports | `→` | Doğrudan bağımlılık | UserService → UserRepository |
| extends | `⊳` | Kalıtım | AdminService ⊳ UserService |
| implements | `◁` | Interface uygulama | AuthService ◁ IAuthProvider |
| calls | `⇢` | Runtime çağrı | Controller ⇢ Service |
| configures | `⚙` | Konfigürasyon | AppModule ⚙ DatabaseModule |

#### Örnek İlişki Haritası

```
AuthController ⇢ AuthService → JwtModule
                              → UserRepository → TypeORM
                              → BcryptUtil
AuthGuard → JwtStrategy → ConfigService
RolesGuard → Reflector
```

---

## Aktivasyon

### T4/T5 Analiz Ajanları İçin: Her Zaman Aktif

- Confidence Tagging **zorunlu** — her bulgu etiketlenmelidir
- Query-First **zorunlu** — dosya okumadan önce grep/glob
- Progressive Disclosure **önerilir** — büyük analizlerde aşamalı yaklaşım

### T1/T2/T3 Kodlama Ajanları İçin: Opsiyonel

- `/context-mode` aktifken tüm kurallar geçerli olur
- Normal modda sadece Query-First baseline olarak uygulanır

---

## Kullanım Senaryoları

### Senaryo 1: Yeni Geliştiricinin Projeyi Tanıması

**Komut**: "Bu projenin yapısını ve kritik noktalarını analiz et"

```markdown
## Proje Yapısı Analizi (Progressive Disclosure — Aşama 1)

### Shape
- Monorepo: 1 frontend (React), 1 backend (Spring Boot)
- Frontend: 45 component, 12 page, 8 service
- Backend: 6 module, 23 endpoint, 4 entity

### God Nodes (Dikkat Edilmesi Gerekenler)
| Dosya | Bağlantı | Risk |
|-------|----------|------|
| ApiClient.ts | 15 gelen | 🔴 Her component buna bağlı |
| AuthContext.tsx | 11 gelen | 🟠 Değişiklik her yeri etkiler |

### İlişki Haritası (Ana Akış)
App → AuthContext → ApiClient → Backend
    → Router → Pages → Components → ApiClient
```

### Senaryo 2: Refactoring Öncesi Analiz

**Komut**: "UserService refactoring için etki analizi yap"

```markdown
## UserService Etki Analizi

🟢 EXTRACTED | 12 dosya UserService'i import ediyor
🟢 EXTRACTED | UserService 8 farklı repository kullanıyor
🟡 INFERRED (0.9) | God node — SRP ihlali (user CRUD + auth + notification)
🟡 INFERRED (0.7) | Bölme önerisi: UserQueryService + UserCommandService + UserNotificationService
🔴 AMBIGUOUS | Event bus kullanımı var mı belirsiz — async operasyonlar incelenmeli

### Bölme Sonrası Beklenen İyileşme
- Dosya boyutu: 450 satır → 3 × ~150 satır
- Test coverage: %45 → tahmini %75+ (küçük dosyalar daha kolay test edilir)
- Bağlantı sayısı: 20 → max 8 (god node olmaktan çıkar)
```

### Senaryo 3: Güvenlik Auditi

**Komut**: "Auth modülünün güvenlik durumunu analiz et"

```markdown
## Auth Güvenlik Analizi

### Bulgular

🟢 EXTRACTED | auth.service.ts:23 | bcrypt.hash(password, 12) — uygun rounds değeri
🟢 EXTRACTED | jwt.strategy.ts:15 | Token expiry: 900s (15 dakika) — kabul edilebilir
🟡 INFERRED (0.8) | Refresh token rotation yok — token çalınırsa süresiz kullanılabilir
🟡 INFERRED (0.7) | Rate limiting middleware'i auth route'larında görünmüyor
🔴 AMBIGUOUS | Password reset flow'da token invalidation var mı — ayrı inceleme gerekli

### Öncelik Sıralaması
1. 🔴 P0: Rate limiting eklenmeli (brute force riski)
2. 🟠 P1: Refresh token rotation implementasyonu
3. 🟡 P2: Password reset token expiry doğrulaması
```

---

## Structured Findings Format (Yapılandırılmış Bulgu Şablonu)

Her önemli bulgu bu formatta raporlanmalıdır:

```markdown
### [Bulgu Başlığı]

| Alan | Değer |
|------|-------|
| **Güven** | 🟢/🟡/🔴 EXTRACTED/INFERRED/AMBIGUOUS |
| **Kaynak** | dosya:satır veya "pattern analizi" |
| **Etki** | Düşük / Orta / Yüksek / Kritik |
| **Öneri** | Somut aksiyon |
```

---

## Teknik Detaylar

### Skill Dosyası

Tam kurallar: `.github/skills/knowledge-graph/SKILL.md`

### İlgili Konfigürasyon Dosyaları

- `.github/instructions/shared-base.instructions.md` — Baseline (Query-First, Confidence Tagging)
- `.github/instructions/reference/context-loading.instructions.md` — Skill yükleme kuralları
- `.github/skills/analysis/SKILL.md` — Analiz ajanlarının temel skill'i (knowledge-graph bunu tamamlar)
