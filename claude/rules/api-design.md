# API Design Rules

## Controller Structure

**Java:**
```java
@Tag(name = "USER")
@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserController {
    private final UserUsecase userUsecase;

    @GetMapping("/{userId}")
    @Operation(summary = "Get user by ID")
    public ResponseEntity<UserResponse> getUser(
        @PathVariable Long userId
    ) {
        return ResponseEntity.ok(userUsecase.getUser(userId));
    }
}
```

**Kotlin:**
```kotlin
@Tag(name = "USER")
@RestController
@RequestMapping("/api/v1/users")
class UserController(
    private val userUsecase: UserUsecase
) {
    @GetMapping("/{userId}")
    @Operation(summary = "Get user by ID")
    fun getUser(@PathVariable userId: Long): ResponseEntity<UserResponse> =
        ResponseEntity.ok(userUsecase.getUser(userId))
}
```

## Required Annotations

| Annotation | Purpose |
|-----------|---------|
| `@Tag(name = "DOMAIN")` | OpenAPI grouping |
| `@Operation(summary = "...")` | API description |
| `@Parameter(hidden = true)` | Hide internal params from docs |
| `@Valid` | Enable validation |

## Response Format

Wrap responses in common format (optional pattern):

**Java:**
```java
// Success with data
return CommonResponse.success(ResponseCode.GET_USER, data);

// Success without data
return CommonResponse.success(ResponseCode.DELETE_USER);
```

**Kotlin:**
```kotlin
// Success with data
return CommonResponse.success(ResponseCode.GET_USER, data)

// Success without data
return CommonResponse.success(ResponseCode.DELETE_USER)
```

## Response Codes (Example)

```java
@Getter
@AllArgsConstructor
public enum ResponseCode implements ResponseCodeInterface {
    GET_USER(1100, HttpStatus.OK, "User retrieved successfully"),
    CREATE_USER(1101, HttpStatus.CREATED, "User created successfully"),
    UPDATE_USER(1102, HttpStatus.OK, "User updated successfully"),
    DELETE_USER(1103, HttpStatus.OK, "User deleted successfully");

    private final int code;
    private final HttpStatus status;
    private final String message;
}
```

## Code Numbering (Suggested)

| Range | Category |
|-------|----------|
| 1XXX | Success responses |
| 2XXX | Domain-specific errors |
| 3XXX | Server errors |
| 4XXX | Client errors |

## HTTP Methods

| Method | Usage |
|--------|-------|
| GET | Read operations, no body |
| POST | Create resources |
| PUT | Full updates |
| PATCH | Partial updates |
| DELETE | Remove resources |

## Path Design

```
GET    /users                    # List users
GET    /users/{userId}           # Get single user
POST   /users                    # Create user
PATCH  /users/{userId}           # Update user
DELETE /users/{userId}           # Delete user
POST   /users/{userId}/activate  # Action on resource
```

## Query Parameters

- Use for filtering: `?page=0&size=10`
- Use for optional params: `?status=ACTIVE`

## Path Variables

- Use for resource identification: `/users/{userId}`
- Validate existence in service layer

## Authentication

**Java:**
```java
public ResponseEntity<T> method(
    @AuthenticationPrincipal UserDetails user,  // or custom annotation
    @RequestBody @Valid RequestDto request
) { }
```

**Kotlin:**
```kotlin
fun method(
    @AuthenticationPrincipal user: UserDetails,  // or custom annotation
    @RequestBody @Valid request: RequestDto
): ResponseEntity<T> { }
```

## Validation

Use Jakarta validation annotations in DTOs:
- `@NotNull`, `@NotEmpty`, `@NotBlank`
- `@Size(min = 1, max = 100)`
- `@Positive`, `@PositiveOrZero`
- `@Email`, `@Pattern`

## Request DTO Example

**Java:**
```java
public record CreateUserRequest(
    @Schema(description = "User name", example = "John Doe")
    @NotBlank
    @Size(max = 100)
    String name,

    @Schema(description = "Email address", example = "john@example.com")
    @NotBlank
    @Email
    String email
) {}
```

**Kotlin:**
```kotlin
data class CreateUserRequest(
    @field:Schema(description = "User name", example = "John Doe")
    @field:NotBlank
    @field:Size(max = 100)
    val name: String,

    @field:Schema(description = "Email address", example = "john@example.com")
    @field:NotBlank
    @field:Email
    val email: String
)
```

## Response DTO Example

**Java:**
```java
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public record UserResponse(
    @Schema(description = "User ID", example = "1")
    long id,

    @Schema(description = "User name", example = "John Doe")
    String name,

    @Schema(description = "Email address", example = "john@example.com")
    String email
) {}
```

**Kotlin:**
```kotlin
data class UserResponse(
    @Schema(description = "User ID", example = "1")
    val id: Long,

    @Schema(description = "User name", example = "John Doe")
    val name: String,

    @Schema(description = "Email address", example = "john@example.com")
    val email: String?
)
```
