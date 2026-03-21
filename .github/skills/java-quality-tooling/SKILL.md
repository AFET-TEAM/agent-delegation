---
name: Java Quality Tooling
description: >
  Maven quality plugin configuration and enforcement for Java projects.
  Covers Checkstyle, SpotBugs, JaCoCo, and SonarQube integration.
  Defines quality gates, coverage targets, and IDE setup requirements.
estimated-tokens: 2400
used-by: [T1, T1.5, T2]
tiers:
  T1: optional
  T1.5: optional
  T2: optional
---

# Java Quality Tooling Skill

## Scope

Maven quality plugins — **Checkstyle**, **SpotBugs**, **JaCoCo**, **SonarQube**.
Every build must pass the quality gate before merge.

---

## 1. Quality Gates

| Metric | Target | Build Fails? |
| --- | --- | --- |
| Line Coverage | ≥ 80 % | ✅ Yes |
| Branch Coverage | ≥ 70 % | ✅ Yes |
| Code Duplication | ≤ 3 % | ⚠️ Warning |
| Blocker Issues | 0 | ✅ Yes |
| Critical Issues | 0 | ✅ Yes |

Run all checks: `mvn clean verify`

---

## 2. Checkstyle Rules

Reference configuration: `.github/config/checkstyle.xml`

### Key Rules

| Rule | Constraint |
| --- | --- |
| `LineLength` | Max 120 characters (import/package lines excluded) |
| `MethodLength` | Max 80 lines per method |
| `ParameterNumber` | Max 7 parameters per method |
| `AvoidStarImport` | Wildcard imports are forbidden |
| `UnusedImports` | Must be removed |
| `ConstantName` | `UPPER_SNAKE_CASE` |
| `MemberName` | `camelCase` |
| `TypeName` | `PascalCase` |
| `MagicNumber` | Only `-1, 0, 1, 2` allowed inline |
| `NeedBraces` | Braces required for `if`, `for`, `while` |
| `EqualsHashCode` | Must override both together |
| `MissingSwitchDefault` | `default` case is mandatory |
| `FileLength` | Max 2000 lines per file |
| `FileTabCharacter` | Tabs forbidden — use spaces |

> **Checkstyle vs team standard**: These Checkstyle limits (MethodLength=80, FileLength=2000) are build-failure gates — the absolute maximum before CI fails. The team's quality standard is stricter: 20-line functions and 250-line files (`clean-code/SKILL.md`). Checkstyle prevents extreme violations; code review enforces the team standard.

### @Autowired Ban

Field injection via `@Autowired` is **forbidden**. The Checkstyle rule
`RegexpSinglelineJava` rejects any line matching `^\s*@Autowired`.
Use constructor injection with `@RequiredArgsConstructor` instead.

```java
@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;
    private final PaymentClient paymentClient;
}
```

---

## 3. SpotBugs

Reference configuration: `.github/config/spotbugs-exclude.xml`

### Excluded Patterns

| Pattern | Bug Filter | Reason |
| --- | --- | --- |
| `~.*\.generated\..*`, `~.*MapperImpl` | All | Generated classes (MapStruct, Lombok) |
| `~.*Test.*` | All | Test classes |
| `~.*Config.*` | All | Spring configuration classes |
| `~.*Controller`, `~.*Service`, `~.*Repository.*` | `EI_EXPOSE_REP2` | Spring DI managed beans |
| `~.*\.dto\..*`, `~.*\.entity\..*`, `~.*\.model\..*` | `EI_EXPOSE_REP/2` | Mutable object exposure accepted |
| `~.*\.common\..*`, `~.*(Request\|Response)` | `EI_EXPOSE_REP/2` | Wrapper / Request / Response DTOs |

### Common Bug Patterns

| Bug Pattern | Fix |
| --- | --- |
| `NP_NULL_ON_SOME_PATH` | Add null check or use `Optional` |
| `OBL_UNSATISFIED_OBLIGATION` | Use try-with-resources |
| `SQL_INJECTION` | Use `PreparedStatement` or JPA |

---

## 4. JaCoCo Coverage

The following packages are excluded from coverage enforcement:

| Package Pattern | Reason |
| --- | --- |
| `**/dto/**` | Data Transfer Objects |
| `**/model/**` | Domain model POJOs |
| `**/entity/**` | JPA entities |
| `**/config/**` | Spring configuration |
| `**/mapper/*Impl.java` | MapStruct generated mappers |
| `**/*Application.java` | Spring Boot main class |

### Coverage Rule

```xml
<rules>
    <rule>
        <limits>
            <limit>
                <counter>LINE</counter>
                <value>COVEREDRATIO</value>
                <minimum>0.80</minimum>
            </limit>
            <limit>
                <counter>BRANCH</counter>
                <value>COVEREDRATIO</value>
                <minimum>0.70</minimum>
            </limit>
        </limits>
    </rule>
</rules>
```

Generate and view the report: `mvn test jacoco:report && open target/site/jacoco/index.html`

---

## 5. SonarQube Integration

### Required Environment Variables

| Variable | Description |
| --- | --- |
| `SONAR_HOST_URL` | SonarQube server URL |
| `SONAR_TOKEN` | Authentication token |
| `SONAR_PROJECT_KEY` | Unique project identifier |

### Execution

```bash
mvn sonar:sonar \
  -Dsonar.host.url=${SONAR_HOST_URL} \
  -Dsonar.token=${SONAR_TOKEN} \
  -Dsonar.projectKey=${SONAR_PROJECT_KEY}
```

---

## 6. Maven Plugin Setup

Reference template: `.github/config/pom-quality-plugins.xml.template`

### Property Convention

Define a shared property for quality configuration paths:

```xml
<properties>
    <quality.dir>${project.basedir}/.github/config</quality.dir>
</properties>
```

### Quality-Checks Profile

Activate via `mvn clean verify -Pquality-checks`.
Full plugin configuration is in `.github/config/pom-quality-plugins.xml.template`.

| Plugin | Version | Config Source |
| --- | --- | --- |
| `maven-checkstyle-plugin` | 3.3.1 | `${quality.dir}/checkstyle.xml` |
| `spotbugs-maven-plugin` | 4.8.6 | `${quality.dir}/spotbugs-exclude.xml` |
| `jacoco-maven-plugin` | 0.8.12 | Inline rules (see Section 4) |

Profile skeleton:

```xml
<profile>
    <id>quality-checks</id>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-checkstyle-plugin</artifactId>
                <version>3.3.1</version>
                <configuration>
                    <configLocation>${quality.dir}/checkstyle.xml</configLocation>
                    <consoleOutput>true</consoleOutput>
                    <failsOnError>true</failsOnError>
                </configuration>
            </plugin>
        </plugins>
    </build>
</profile>
```

---

## 7. IDE Setup

### IntelliJ IDEA — Required Plugins

| Plugin | Purpose |
| --- | --- |
| **SonarLint** | Real-time code quality feedback |
| **CheckStyle-IDEA** | In-editor Checkstyle validation |
| **Lombok** | Annotation processing support |

### CheckStyle-IDEA Configuration

1. Open **File → Settings → Tools → Checkstyle**.
2. Add configuration file: `${quality.dir}/checkstyle.xml`.
3. Set as the active configuration.

### SonarLint Configuration

1. Open **File → Settings → Tools → SonarLint**.
2. Add the SonarQube server connection.
3. Bind the project to the remote project key.

---

## 8. Quality Checklist

Run through this checklist before every push:

| # | Check | Command |
| --- | --- | --- |
| 1 | Code compiles without warnings | `mvn compile` |
| 2 | All tests pass | `mvn test` |
| 3 | Checkstyle passes | `mvn checkstyle:check` |
| 4 | SpotBugs passes | `mvn spotbugs:check` |
| 5 | Coverage ≥ 80 % line / ≥ 70 % branch | `mvn test jacoco:report` |
| 6 | No `@Autowired`, no star imports, no magic numbers | Checkstyle enforced |
| 7 | Full verify succeeds | `mvn clean verify` |
