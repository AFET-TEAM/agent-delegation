# Java Quality Tooling Standards

paths:
  - "**/*.java"
  - "**/pom.xml"
  - "**/*.gradle*"

## Quality Gates

All projects must pass these minimum thresholds before merge:

| Metric | Threshold |
|--------|----------|
| Line coverage | 80% minimum |
| Branch coverage | 70% minimum |
| Code duplication | 3% maximum |
| Critical issues | 0 (zero tolerance) |
| Major issues | 0 (zero tolerance) |
| Technical debt ratio | 5% maximum |

## Checkstyle Rules

### Formatting

| Rule | Value |
|------|-------|
| Maximum line length | 120 characters |
| Maximum method length | 80 lines |
| Maximum parameters per method | 7 |
| Maximum file length | 500 lines |
| Indentation | 4 spaces (no tabs) |
| Brace style | K&R (opening brace on same line) |

### Naming Conventions

| Element | Pattern | Example |
|---------|---------|---------|
| Classes | `^[A-Z][a-zA-Z0-9]+$` | `UserService` |
| Methods | `^[a-z][a-zA-Z0-9]+$` | `findByEmail` |
| Constants | `^[A-Z][A-Z0-9]*(_[A-Z0-9]+)*$` | `MAX_RETRY_COUNT` |
| Parameters | `^[a-z][a-zA-Z0-9]+$` | `userId` |
| Local variables | `^[a-z][a-zA-Z0-9]+$` | `userCount` |
| Type parameters | `^[A-Z]$` | `T`, `E`, `K`, `V` |

### Banned Patterns

- `@Autowired` on fields (use constructor injection)
- `System.out.println` and `System.err.println`
- Wildcard imports (`import java.util.*`)
- Unused imports
- Empty blocks without explanation

## SpotBugs Configuration

### Effort and Threshold

- Analysis effort: `max`
- Reporting threshold: `medium`

### Excluded Patterns

| Pattern | Reason |
|---------|--------|
| `**/generated/**` | Auto-generated code (MapStruct, QueryDSL) |
| `**/dto/**` | Data transfer objects (simple data carriers) |
| `**/*Test.java` | Test classes (relaxed rules for test readability) |
| `**/*IT.java` | Integration test classes |
| `**/*Config.java` | Spring configuration classes |

### Critical Bug Categories

These categories are enforced at the highest priority:

- `SECURITY`: All security-related findings
- `CORRECTNESS`: Probable bugs and incorrect behavior
- `BAD_PRACTICE`: Violations of recommended coding practice
- `PERFORMANCE`: Performance issues and inefficient code
- `MALICIOUS_CODE`: Exposure of internal data to untrusted code

## JaCoCo Coverage Configuration

### Excluded Packages

| Package Pattern | Reason |
|----------------|--------|
| `*.config.*` | Spring configuration classes |
| `*.dto.*` | Data transfer objects |
| `*.entity.*` | JPA entity classes |
| `*.exception.*` | Custom exception classes |
| `*.mapper.*` | MapStruct generated mappers |
| `*Application` | Spring Boot main class |

### Coverage Rules

```xml
<rules>
    <rule>
        <element>BUNDLE</element>
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
    <rule>
        <element>CLASS</element>
        <limits>
            <limit>
                <counter>LINE</counter>
                <value>COVEREDRATIO</value>
                <minimum>0.70</minimum>
            </limit>
        </limits>
    </rule>
</rules>
```

## SonarQube Integration

### Quality Profile

- Inherit from `Sonar way` profile
- Add custom rules matching Checkstyle configuration
- Enable all security hotspot rules
- Enable all vulnerability detection rules

### Analysis Properties

| Property | Value |
|----------|-------|
| `sonar.java.source` | 17 |
| `sonar.coverage.jacoco.xmlReportPaths` | `target/site/jacoco/jacoco.xml` |
| `sonar.java.checkstyle.reportPaths` | `target/checkstyle-result.xml` |
| `sonar.java.spotbugs.reportPaths` | `target/spotbugsXml.xml` |
| `sonar.exclusions` | `**/generated/**,**/dto/**` |

### Gate Conditions in CI

Pipeline fails if SonarQube quality gate status is not `PASSED`. No merge is allowed with a failed quality gate.

## Maven Plugin Setup

### Quality Checks Profile

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
                    <configLocation>checkstyle.xml</configLocation>
                    <violationSeverity>warning</violationSeverity>
                    <failOnViolation>true</failOnViolation>
                </configuration>
            </plugin>
            <plugin>
                <groupId>com.github.spotbugs</groupId>
                <artifactId>spotbugs-maven-plugin</artifactId>
                <version>4.8.3</version>
                <configuration>
                    <effort>Max</effort>
                    <threshold>Medium</threshold>
                    <failOnError>true</failOnError>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.jacoco</groupId>
                <artifactId>jacoco-maven-plugin</artifactId>
                <version>0.8.11</version>
            </plugin>
        </plugins>
    </build>
</profile>
```

Activate with: `mvn verify -P quality-checks`

## IDE Setup

### Required Plugins

| Plugin | Purpose |
|--------|---------|
| SonarLint | Real-time code quality analysis in IDE |
| CheckStyle-IDEA | Checkstyle integration for IntelliJ |
| SpotBugs | Static analysis in IDE |

### Recommended Configuration

- Enable auto-format on save with project Checkstyle rules
- Enable SonarLint connected mode (link to project SonarQube instance)
- Configure import optimization on save (remove unused, organize order)
- Set file encoding to UTF-8 globally
