# Mapper & DTO Rules

## Mapper Pattern

Mappers are Spring components that convert between entities and DTOs.

**Java:**
```java
@Component
@RequiredArgsConstructor
public class UserMapper {
    private final ProfileMapper profileMapper;

    public UserResponse toResponse(User user) {
        return UserResponse.builder()
            .id(user.getId())
            .name(user.getName())
            .email(user.getEmail())
            .profile(profileMapper.toResponse(user.getProfile()))
            .build();
    }

    public User toEntity(CreateUserRequest request) {
        return User.builder()
            .name(request.name().trim())
            .email(request.email().toLowerCase())
            .status(UserStatus.ACTIVE)
            .build();
    }
}
```

**Kotlin:**
```kotlin
@Component
class UserMapper(
    private val profileMapper: ProfileMapper
) {
    fun toResponse(user: User) = UserResponse(
        id = user.id,
        name = user.name,
        email = user.email,
        profile = profileMapper.toResponse(user.profile)
    )

    fun toEntity(request: CreateUserRequest) = User(
        name = request.name.trim(),
        email = request.email.lowercase(),
        status = UserStatus.ACTIVE
    )
}
```

## Mapper Naming

| Method Pattern | Purpose |
|---------------|---------|
| `toResponse` | Entity → Response DTO |
| `toEntity` | Request DTO → Entity |
| `toDto` | Entity → Generic DTO |
| `from{Source}` | Convert from specific source type |

## Request DTO

Located in `application/dto/request/`:

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
    String email,

    @Schema(description = "Profile settings")
    @Valid
    @NotNull
    ProfileRequest profile
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
    val email: String,

    @field:Schema(description = "Profile settings")
    @field:Valid
    @field:NotNull
    val profile: ProfileRequest
)
```

### Validation Annotations

| Annotation | Usage |
|-----------|-------|
| `@NotNull` | Field must not be null |
| `@NotEmpty` | Collection must have elements |
| `@NotBlank` | String must not be empty/whitespace |
| `@Size(min, max)` | Length/size constraints |
| `@Positive` | Number must be > 0 |
| `@Valid` | Validate nested objects |

## Response DTO

Located in `application/dto/response/`:

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
    String email,

    @Schema(description = "Profile information")
    ProfileResponse profile,

    @Schema(description = "Active status", example = "true")
    Boolean isActive
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
    val email: String,

    @Schema(description = "Profile information")
    val profile: ProfileResponse? = null,

    @Schema(description = "Active status", example = "true")
    val isActive: Boolean? = null
)
```

### Response DTO Rules

- Use `@Builder` for flexible construction (Java)
- Use `@JsonInclude(NON_NULL)` to exclude null fields
- Use `@Schema` for OpenAPI documentation
- Use primitives (`long`) for required fields
- Use wrappers (`Boolean`, `Long`) for optional fields

## List Response with Pagination

**Java:**
```java
@Builder
public record UserListResponse(
    @Schema(description = "User list")
    List<UserResponse> users,

    @Schema(description = "Pagination info")
    PageResponse page
) {}

@Builder
public record PageResponse(
    int pageNumber,
    int pageSize,
    long totalElements,
    int totalPages,
    boolean hasNext
) {
    public static PageResponse from(Page<?> page) {
        return PageResponse.builder()
            .pageNumber(page.getNumber())
            .pageSize(page.getSize())
            .totalElements(page.getTotalElements())
            .totalPages(page.getTotalPages())
            .hasNext(page.hasNext())
            .build();
    }
}
```

**Kotlin:**
```kotlin
data class UserListResponse(
    @Schema(description = "User list")
    val users: List<UserResponse>,

    @Schema(description = "Pagination info")
    val page: PageResponse
)

data class PageResponse(
    val pageNumber: Int,
    val pageSize: Int,
    val totalElements: Long,
    val totalPages: Int,
    val hasNext: Boolean
) {
    companion object {
        fun from(page: Page<*>) = PageResponse(
            pageNumber = page.number,
            pageSize = page.size,
            totalElements = page.totalElements,
            totalPages = page.totalPages,
            hasNext = page.hasNext()
        )
    }
}
```

## Nested DTOs

**Java:**
```java
@Builder
public record ProfileResponse(
    @Schema(description = "Profile ID")
    long id,

    @Schema(description = "Bio")
    String bio,

    @Schema(description = "Avatar URL")
    String avatarUrl
) {}
```

**Kotlin:**
```kotlin
data class ProfileResponse(
    @Schema(description = "Profile ID")
    val id: Long,

    @Schema(description = "Bio")
    val bio: String?,

    @Schema(description = "Avatar URL")
    val avatarUrl: String?
)
```

## Utility Methods in Mappers

**Java:**
```java
@Component
public class UserMapper {

    private String normalizeEmail(String email) {
        return email == null ? null : email.toLowerCase().trim();
    }

    private String getAvatarUrl(User user) {
        if (user.getProfile() == null) {
            return null;
        }
        return user.getProfile().getAvatarUrl();
    }
}
```

**Kotlin:**
```kotlin
@Component
class UserMapper {

    private fun normalizeEmail(email: String?): String? =
        email?.lowercase()?.trim()

    private fun getAvatarUrl(user: User): String? =
        user.profile?.avatarUrl
}
```

## Mapper Dependencies

Mappers can inject other mappers:

**Java:**
```java
@Component
@RequiredArgsConstructor
public class UserMapper {
    private final ProfileMapper profileMapper;
    private final AddressMapper addressMapper;
}
```

**Kotlin:**
```kotlin
@Component
class UserMapper(
    private val profileMapper: ProfileMapper,
    private val addressMapper: AddressMapper
)
```

## Mapper Testing

**Java:**
```java
@ExtendWith(MockitoExtension.class)
class UserMapperTest {
    @Mock
    private ProfileMapper profileMapper;

    @InjectMocks
    private UserMapper userMapper;

    @Test
    void toResponse_shouldMapAllFields() {
        // given
        User user = UserTestFixture.createUser(1L, "test@example.com");
        when(profileMapper.toResponse(any()))
            .thenReturn(ProfileResponse.builder().id(1L).build());

        // when
        UserResponse response = userMapper.toResponse(user);

        // then
        assertThat(response.id()).isEqualTo(1L);
        assertThat(response.email()).isEqualTo("test@example.com");
    }
}
```

**Kotlin:**
```kotlin
class UserMapperTest : StringSpec({
    val profileMapper = mockk<ProfileMapper>()
    val userMapper = UserMapper(profileMapper)

    "toResponse should map all fields" {
        // given
        val user = UserTestFixture.createUser(1L, "test@example.com")
        every { profileMapper.toResponse(any()) } returns ProfileResponse(id = 1L)

        // when
        val response = userMapper.toResponse(user)

        // then
        response.id shouldBe 1L
        response.email shouldBe "test@example.com"
    }
})
```
