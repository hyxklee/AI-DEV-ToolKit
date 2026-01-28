# Code Style Rules

## Language

- Primary: Java 17+, Kotlin
- Build: Gradle (Kotlin DSL) or Maven

## Formatting

- **Java**: Use IDE formatter or Checkstyle
- **Kotlin**: Use ktlint
- Run formatter before committing

## Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Classes | PascalCase | `UserController`, `UserSaveService` |
| Methods | camelCase | `getUserDetail`, `createUser` |
| Constants | SCREAMING_SNAKE_CASE | `MAX_PAGE_SIZE` |
| Packages | lowercase | `com.example.domain.user` |
| DTOs | Suffix with purpose | `CreateUserRequest`, `UserResponse` |
| Test Fixtures | `{Entity}TestFixture` | `UserTestFixture` |

## Lombok Usage (Java)

| Annotation | Usage |
|-----------|-------|
| `@Getter` | All entities and services |
| `@RequiredArgsConstructor` | Dependency injection |
| `@SuperBuilder` | Entities extending BaseEntity |
| `@NoArgsConstructor(access = PROTECTED)` | JPA entities |
| `@Builder` | DTOs and non-entity classes |

## Records vs Classes vs Data Class

**Java:**
```java
// Request DTO - Use Record
public record CreateUserRequest(
    @NotBlank String name,
    @Email String email
) {}

// Response DTO - Use Record with Builder
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public record UserResponse(
    long id,
    String name
) {}

// Entity - Use Class with Lombok
@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class User extends BaseEntity { }
```

**Kotlin:**
```kotlin
// Request DTO - Use data class
data class CreateUserRequest(
    @field:NotBlank val name: String,
    @field:Email val email: String
)

// Response DTO - Use data class
data class UserResponse(
    val id: Long,
    val name: String
)

// Entity - Use class
@Entity
class User(
    @Id @GeneratedValue
    val id: Long = 0,
    var name: String
) : BaseEntity()
```

## Import Organization

1. Java/Kotlin standard library
2. Third-party libraries
3. Spring framework
4. Project classes

## Constants

**Java:**
```java
private static final int MAX_PAGE_SIZE = 20;
private static final int DEFAULT_PAGE_SIZE = 10;
```

**Kotlin:**
```kotlin
companion object {
    private const val MAX_PAGE_SIZE = 20
    private const val DEFAULT_PAGE_SIZE = 10
}
```

## Null Handling

**Java:**
```java
// Use Optional for repository return types
public User getUser(Long userId) {
    return userRepository.findById(userId)
        .orElseThrow(UserNotFoundException::new);
}
```

**Kotlin:**
```kotlin
// Use nullable types and Elvis operator
fun getUser(userId: Long): User =
    userRepository.findByIdOrNull(userId)
        ?: throw UserNotFoundException()
```
