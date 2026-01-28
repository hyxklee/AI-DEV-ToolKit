# Architecture Rules

## Package Structure

Follow Domain-Driven Design with layered architecture:

```
com.example.app/
├── domain/{domain-name}/
│   ├── application/          # Use cases & orchestration
│   │   ├── usecase/          # Business workflows
│   │   ├── dto/
│   │   │   ├── request/      # Input DTOs
│   │   │   └── response/     # Output DTOs
│   │   ├── mapper/           # DTO <-> Entity mappers
│   │   ├── exception/        # Domain exceptions & error codes
│   │   └── util/             # Domain utilities
│   ├── domain/               # Core business logic
│   │   ├── entity/           # JPA entities
│   │   ├── service/          # Domain services (CRUD split)
│   │   └── repository/       # Data access interfaces
│   └── presentation/         # HTTP layer
│       └── *Controller.java
└── global/                   # Cross-cutting concerns
    ├── auth/
    ├── config/
    ├── common/
```

## Layer Dependencies

```
Controller → UseCase → Domain Service → Repository
     ↓           ↓            ↓
    DTO       Mapper       Entity
```

**Rules:**
- Controllers depend ONLY on UseCases
- UseCases orchestrate multiple Domain Services
- Domain Services handle single entity operations
- Never skip layers (Controller → Repository is forbidden)

## Service Naming Convention

Split services by operation type (Single Responsibility):

| Service Type | Responsibility |
|-------------|----------------|
| `{Entity}GetService` | Read operations (queries) |
| `{Entity}SaveService` | Create operations |
| `{Entity}UpdateService` | Update operations |
| `{Entity}DeleteService` | Delete operations |

**Java Example:**
```java
@Service
@RequiredArgsConstructor
public class UserSaveService {
    private final UserRepository userRepository;

    public User save(User user) {
        return userRepository.save(user);
    }
}
```

**Kotlin Example:**
```kotlin
@Service
class UserSaveService(
    private val userRepository: UserRepository
) {
    fun save(user: User): User = userRepository.save(user)
}
```

## UseCase Pattern

UseCases orchestrate workflows across multiple services:

**Java Example:**
```java
@Service
@RequiredArgsConstructor
public class UserUsecase {
    private final UserSaveService userSaveService;
    private final UserGetService userGetService;
    private final ProfileSaveService profileSaveService;
    private final UserMapper userMapper;

    @Transactional
    public UserResponse createUser(CreateUserRequest request) {
        User user = userMapper.toEntity(request);
        User saved = userSaveService.save(user);
        profileSaveService.createDefault(saved.getId());
        return userMapper.toResponse(saved);
    }
}
```

**Kotlin Example:**
```kotlin
@Service
class UserUsecase(
    private val userSaveService: UserSaveService,
    private val userGetService: UserGetService,
    private val profileSaveService: ProfileSaveService,
    private val userMapper: UserMapper
) {
    @Transactional
    fun createUser(request: CreateUserRequest): UserResponse {
        val user = userMapper.toEntity(request)
        val saved = userSaveService.save(user)
        profileSaveService.createDefault(saved.id)
        return userMapper.toResponse(saved)
    }
}
```

## New Domain Checklist

When creating a new domain:

1. Create package structure: `domain/{name}/application`, `domain/{name}/domain`, `domain/{name}/presentation`
2. Create entity extending `BaseEntity`
3. Create repository interface
4. Create split services (Get, Save, Update, Delete)
5. Create error codes implementing `ErrorCodeInterface`
6. Create response codes implementing `ResponseCodeInterface`
7. Create request/response DTOs
8. Create mapper
9. Create usecase
10. Create controller with OpenAPI annotations
