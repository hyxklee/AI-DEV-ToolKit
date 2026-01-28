# Backend Convention Rules

Reusable backend conventions for Spring Boot projects.

## Quick Reference

| File | Content |
|------|---------|
| [architecture.md](./architecture.md) | Package structure, DDD patterns, layer rules |
| [code-style.md](./code-style.md) | Naming, formatting, Lombok |
| [api-design.md](./api-design.md) | Controller patterns, response format, validation |
| [exception-handling.md](./exception-handling.md) | Error codes, exception hierarchy |
| [entity-repository.md](./entity-repository.md) | Entity patterns, soft delete, queries |
| [mapper-dto.md](./mapper-dto.md) | DTO patterns, mapper conventions |
| [testing.md](./testing.md) | Test frameworks, fixtures, patterns |
| [transaction-concurrency.md](./transaction-concurrency.md) | Transactions, locking |
| [commit-convention.md](./commit-convention.md) | Commit format, branch naming |

## Key Patterns

### Service Split (Single Responsibility)
```
{Entity}GetService    - Read operations (queries)
{Entity}SaveService   - Create operations
{Entity}UpdateService - Update operations
{Entity}DeleteService - Delete operations
```

### Response Wrapper
```java
// Java
CommonResponse.success(ResponseCode.SUCCESS, data);
```
```kotlin
// Kotlin
CommonResponse.success(ResponseCode.SUCCESS, data)
```

### Soft Delete
```java
// Java
private LocalDateTime deletedAt;

public void delete() {
    this.deletedAt = LocalDateTime.now();
}
```
```kotlin
// Kotlin
var deletedAt: LocalDateTime? = null

fun delete() {
    this.deletedAt = LocalDateTime.now()
}
```

### Exception Pattern
```java
// Java
throw new EntityNotFoundException();
// Extends BaseException with ErrorCode
```
```kotlin
// Kotlin
throw EntityNotFoundException()
// Extends BaseException with ErrorCode
```

## Quick Commands

```bash
# Gradle
./gradlew build          # Build
./gradlew bootRun        # Run
./gradlew test           # Test
./gradlew ktlintFormat   # Format Kotlin code
./gradlew ktlintCheck    # Check Kotlin style

# Maven
mvn clean install        # Build
mvn spring-boot:run      # Run
mvn test                 # Test
```
