---
name: MayaCore Integration
description: >
  MayaCore ecosystem integration — Config Server, Common Library,
  API Gateway, Session Library, and OpenShift deployment standards.
used-by:
  - Tier 1 (Principal)
  - Tier 1.5 (Staff Engineer)
  - Tier 2 (MidCoder)
estimated-tokens: 4500
---

# MayaCore Integration Skill

> Scope: MayaCore ecosystem integration — Config Server, Common Library, API Gateway, Session Library, OpenShift deployment.

---

## 1. Config Server Integration

All configuration is stored centrally in the `MAYA_CORE.CLOUD_CONFIG` database table and served to microservices via Spring Cloud Config Server.

### CLOUD_CONFIG Table Schema

| Column | Type | Description |
|--------|------|-------------|
| APPLICATION | VARCHAR2(100) | Microservice name (e.g. `mayacore-customer`) |
| ENV | VARCHAR2(100) | Environment (`dev`, `integration`, `prod`) |
| PROFILE | VARCHAR2(100) | Spring profile (`default`, `dev`, `integration`) |
| CONF_KEY | VARCHAR2(500) | Config key (e.g. `spring.datasource.url`) |
| CONF_VALUE | VARCHAR2(4000) | Config value |
| STATUS | NUMBER(1) | `1` = active, `0` = inactive |

### Profile Hierarchy

- **default** profile: shared across all environments (server settings, JPA, logging, OpenAPI, external service URLs).
- **Environment** profile (`dev`, `integration`, `prod`): environment-specific values (datasource, Redis, Kafka, log levels).
- Environment profile **overrides** any key with the same name from the default profile.

### Property Naming Convention

YAML nested structures are flattened to dot notation:

```yaml
app:
  external-services:
    services:
      mernis:
        base-url: http://mernis-service
```

Becomes the CONF_KEY: `app.external-services.services.mernis.base-url`

### SQL Insert Template

```sql
INSERT INTO MAYA_CORE.CLOUD_CONFIG (APPLICATION, ENV, PROFILE, CONF_KEY, CONF_VALUE, STATUS)
VALUES ('mayacore-customer', 'dev', 'default', 'spring.application.name', 'mayacore-customer', 1);
```

### Datasource Config Example (Environment Profile)

```sql
INSERT INTO MAYA_CORE.CLOUD_CONFIG (APPLICATION, ENV, PROFILE, CONF_KEY, CONF_VALUE, STATUS)
VALUES ('mayacore-customer', 'dev', 'dev', 'spring.datasource.url', 'jdbc:oracle:thin:@dev-db:1521/DEV', 1);

INSERT INTO MAYA_CORE.CLOUD_CONFIG (APPLICATION, ENV, PROFILE, CONF_KEY, CONF_VALUE, STATUS)
VALUES ('mayacore-customer', 'dev', 'dev', 'spring.datasource.username', 'udb', 1);

INSERT INTO MAYA_CORE.CLOUD_CONFIG (APPLICATION, ENV, PROFILE, CONF_KEY, CONF_VALUE, STATUS)
VALUES ('mayacore-customer', 'dev', 'dev', 'spring.datasource.password', 's_udb', 1);
```

### Bootstrap application.yml

Local dev uses explicit URIs; integration/prod uses OpenShift environment variables:

```yaml
spring:
  application:
    name: mayacore-customer
  config:
    import: "configserver:"
    fail-fast: true
    retry:
      max-attempts: 4
      initial-interval: 2000
      multiplier: 1.5
  cloud:
    config:
      uri: ${CM_CONFIG_SERVER_URI:http://mayacore-config-server-integration-test-mayacore.apps.tocpbmt1.tcs.turkcell.tgc}
      profile: ${SPRING_ACTIVE_PROFILES:dev}
      label: ${SPRING_ACTIVE_PROFILES:dev}
      username: ${SC_CONFIG_SERVER_USERNAME:user}
      password: ${SC_CONFIG_SERVER_PASSWORD:password}
```

---

## 2. Common Library

### Dynamic OpenFeign via CommonClientFactory

Common Library provides a dynamic Feign Client mechanism. Configurations are read from `MAYA_CORE.CLIENT_CONFIG` — no code change required to update.

#### CLIENT_CONFIG Table Schema

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| APPLICATION | VARCHAR2(100) | Yes | Microservice name |
| NAME | VARCHAR2(100) | Yes | Feign client name (e.g. `mernis.citizen-query`) |
| ENV | VARCHAR2(100) | Yes | Environment |
| URL | VARCHAR2(500) | Yes | Service URL |
| EXTERNAL | NUMBER(1) | Yes | `1` = external, `0` = internal |
| READ_TIMEOUT | NUMBER | No | Response timeout ms (default: 5000) |
| CONNECT_TIMEOUT | NUMBER | No | Connection timeout ms (default: 3000) |
| WRITE_TIMEOUT | NUMBER | No | Request timeout ms (default: 5000) |
| MAX_IDLE_CONNECTIONS | NUMBER | No | Pool idle connections (default: 5) |
| KEEP_ALIVE_TIME_IN_MIN | NUMBER | No | Connection TTL in minutes (default: 5) |
| STATUS | NUMBER(1) | Yes | `1` = active, `0` = inactive |
| LOG_MODE | VARCHAR2(50) | No | `ACCESS` / `REQUEST` / `RESPONSE` / `REQUEST_RESPONSE` |

#### Feign Interface

```java
@FeignClient(name = "mernis.citizen-query")
public interface MernisCitizenClient {

    @PostMapping(
        value = "/queryCitizen",
        produces = MediaType.APPLICATION_JSON_VALUE,
        consumes = MediaType.APPLICATION_JSON_VALUE
    )
    MernisResponseDTO queryCitizen(@RequestBody MernisRequestDTO request);
}
```

#### Service Usage

```java
@Service
@RequiredArgsConstructor
public class MernisServiceImpl implements MernisService {

    private final CommonClientFactory commonClientFactory;

    @Override
    public MernisResponseDTO queryCitizen(MernisRequestDTO request) {
        MernisCitizenClient client = commonClientFactory.getClient(
            ClientCommand.of(MernisCitizenClient.class)
        );
        return client.queryCitizen(request);
    }
}
```

#### Custom Headers

```java
Map<String, String> headers = Map.of(
    "X-Request-ID", UUID.randomUUID().toString(),
    "X-User-ID", userId
);

MernisCitizenClient client = commonClientFactory.getClient(
    ClientCommand.of(MernisCitizenClient.class)
        .withHeaders(() -> headers)
);
```

#### External vs Internal

- **EXTERNAL = 1**: Services outside MayaCore (INKA, GAO). Sensitive headers are filtered automatically.
- **EXTERNAL = 0**: Internal MayaCore microservices. All headers propagated including JWT.

### Caffeine Caching

Enable via CLOUD_CONFIG:

```sql
INSERT INTO MAYA_CORE.CLOUD_CONFIG (APPLICATION, ENV, PROFILE, CONF_KEY, CONF_VALUE, STATUS)
VALUES ('mayacore-customer', 'dev', 'dev', 'common.cache-enabled', 'true', 1);
```

| Parameter | Default | Description |
|-----------|---------|-------------|
| `maximumSize` | 10000 | Max cache entries |
| `maximumWeightKb` | 10000 (10 MB) | Total cache capacity in KB |
| `expireAfterWriteInMinutes` | 10 | Entry TTL in minutes |

Per-cache overrides use the cache name instead of `default`:

```sql
INSERT INTO MAYA_CORE.CLOUD_CONFIG (APPLICATION, ENV, PROFILE, CONF_KEY, CONF_VALUE, STATUS)
VALUES ('mayacore-customer', 'dev', 'dev', 'common.cache.customerCache.maximumSize', '5000', 1);
```

### DataSource Configuration

Common Library features (HTTP Client, Cache, Application Config) require a dedicated datasource:

```sql
INSERT INTO MAYA_CORE.CLOUD_CONFIG (APPLICATION, ENV, PROFILE, CONF_KEY, CONF_VALUE, STATUS)
VALUES ('mayacore-customer', 'dev', 'dev', 'common.datasource.url',
        'jdbc:oracle:thin:@10.220.15.181:1521/BSCSSTABLE.TURKCELL', 1);

INSERT INTO MAYA_CORE.CLOUD_CONFIG (APPLICATION, ENV, PROFILE, CONF_KEY, CONF_VALUE, STATUS)
VALUES ('mayacore-customer', 'integration', 'integration', 'common.datasource.url',
        '${CM_BSCS_DB_URL}', 1);

INSERT INTO MAYA_CORE.CLOUD_CONFIG (APPLICATION, ENV, PROFILE, CONF_KEY, CONF_VALUE, STATUS)
VALUES ('mayacore-customer', 'integration', 'integration', 'common.datasource.username',
        '${SC_BSCS_DB_USERNAME}', 1);
```

HikariCP defaults: `minimumIdle=2`, `maximumPoolSize=10`, `idleTimeout=30000`, `connectionTimeout=30000`.

---

## 3. API Gateway

### Route Registration

Routes are registered in the `MAYA_CORE.ROUTE_DEFINITION` and `MAYA_CORE.ROUTE_DEFINITION_DETAIL` tables. Each microservice defines its own path mappings.

### External vs Internal Routes

- **External routes**: Exposed through the public gateway, require JWT validation and SecureUrl filters.
- **Internal routes**: Accessible only within the cluster, used for inter-service communication.

### Health Checks

Every microservice must expose Actuator health endpoints:

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info
  endpoint:
    health:
      show-details: when_authorized
```

Health check verification:

```
GET /api/actuator/health
```

Expected response: `{ "status": "UP" }`

---

## 4. Session Library

### Session Integration

MayaCore Session Library provides shared and external session management backed by Redis.

- **Shared Session**: Shared across MayaCore microservices via Redis.
- **External Session**: Isolated per microservice.

### JWT Handling

- Internal services propagate JWT tokens automatically when `EXTERNAL = 0` in CLIENT_CONFIG.
- API Gateway validates JWT on every incoming request before forwarding to microservices.
- Token claims (`sub`, `iat`, `exp`, `roles`) are propagated via request headers.

---

## 5. OpenShift Deployment

### ConfigMap (CM_ prefix)

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mayacore-customer-config
data:
  CM_CONFIG_SERVER_URI: "http://mayacore-config-server:8888"
  CM_BSCS_DB_URL: "jdbc:oracle:thin:@integration-db:1521/INTEGRATION"
```

### Secret (SC_ prefix)

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mayacore-customer-secret
type: Opaque
stringData:
  SC_CONFIG_SERVER_USERNAME: "config-user"
  SC_CONFIG_SERVER_PASSWORD: "config-password"
  SC_BSCS_DB_USERNAME: "maya_core"
  SC_BSCS_DB_PASSWORD: "secure-password"
```

### Environment Injection

```yaml
spec:
  containers:
    - name: mayacore-customer
      env:
        - name: SPRING_ACTIVE_PROFILES
          value: "integration"
        - name: CM_CONFIG_SERVER_URI
          valueFrom:
            configMapKeyRef:
              name: mayacore-customer-config
              key: CM_CONFIG_SERVER_URI
        - name: SC_CONFIG_SERVER_USERNAME
          valueFrom:
            secretKeyRef:
              name: mayacore-customer-secret
              key: SC_CONFIG_SERVER_USERNAME
```

### Security Rules by Environment

| Environment | Sensitive Data Storage |
|-------------|----------------------|
| `dev` (local) | Plain text in CLOUD_CONFIG is acceptable |
| `integration`, `prod` | Must use OpenShift Secret (`SC_`) and ConfigMap (`CM_`) |

---

## 6. Integration Checklist

| # | Task | Where |
|---|------|-------|
| 1 | Add `spring-cloud-starter-config` to `pom.xml` | Maven |
| 2 | Configure `application.yml` with Config Server URI | `src/main/resources` |
| 3 | Insert default + environment profile rows into `CLOUD_CONFIG` | Database |
| 4 | Enable Common Library (`common.client.enabled=true`) | `CLOUD_CONFIG` |
| 5 | Add `com.turkcell.mayacore` to component scan | Main class |
| 6 | Define Feign clients in `CLIENT_CONFIG` | Database |
| 7 | Configure `common.datasource.*` for Common Library | `CLOUD_CONFIG` |
| 8 | Enable Caffeine cache (`common.cache-enabled=true`) | `CLOUD_CONFIG` |
| 9 | Register routes in API Gateway tables | Database |
| 10 | Create ConfigMap (`CM_`) and Secret (`SC_`) | OpenShift |
| 11 | Inject env vars in Deployment manifest | OpenShift |
| 12 | Expose and verify `/api/actuator/health` returns `UP` | Runtime |

---

## 7. Anti-Patterns

| Anti-Pattern | Why It Fails | Correct Approach |
|-------------|-------------|-----------------|
| Modifying another service's CLOUD_CONFIG rows | Breaks ownership boundaries | Each service manages only its own APPLICATION rows |
| UPDATE/DELETE without WHERE on config tables | Corrupts shared config data | Always filter by APPLICATION + ENV + PROFILE |
| Storing frequently changing values in CLOUD_CONFIG | Not designed for runtime state | Use `APPLICATION_CONFIG` for dynamic parameters |
| Plain text secrets in CLOUD_CONFIG for prod | Security violation | Use OpenShift Secrets with `SC_` prefix |
| Using `RestTemplate` instead of CommonClientFactory | Bypasses centralized client management | Use `CommonClientFactory.getClient(ClientCommand.of(...))` |
| Hard-coding service URLs in source code | Cannot update without redeployment | Store URLs in `CLIENT_CONFIG` table |
| Specifying Feign dependency versions manually | Conflicts with Common Library versions | Omit version — Common Library manages it |
| Disabling `fail-fast: true` for Config Server | App starts with missing config | Keep `fail-fast: true`; fix connectivity instead |
| Setting `maximumWeightKb` AND `maximumSize` together | Only one can be active at a time | Choose one eviction strategy per cache |
| `REQUEST_RESPONSE` log mode in prod high-traffic | Severe performance degradation | Use `ACCESS` in prod; verbose only for debug |
