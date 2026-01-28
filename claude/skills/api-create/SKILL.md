---
name: api-create
description: Generate new API endpoints following DDD architecture. Creates Controller, UseCase, DTO, Service, and Repository layers.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep
---

# API Endpoint Generator

Generate new API endpoint: $ARGUMENTS

## Project Architecture

```
com.example.app/
└── domain/{domain-name}/
    ├── application/
    │   ├── usecase/          # UseCase classes
    │   ├── dto/              # Request/Response DTOs
    │   ├── mapper/           # Entity ↔ DTO mapping
    │   └── exception/        # Domain exceptions
    ├── domain/
    │   ├── entity/           # Domain entities
    │   ├── repository/       # Repository interfaces
    │   └── service/          # Domain services
    └── presentation/         # Controllers
```

## Generation Order

### 1. Create DTOs (application/dto/)

**Java:**
```java
// CreateEntityRequest.java
public record CreateEntityRequest(
    @Schema(description = "Field description", example = "example value")
    @NotBlank
    String field1,

    @Schema(description = "Field description", example = "123")
    @NotNull
    Long field2
) {}

// EntityResponse.java
@Builder
public record EntityResponse(
    @Schema(description = "Entity ID", example = "1")
    long id,

    @Schema(description = "Field description")
    String field1
) {
    public static EntityResponse from(Entity entity) {
        return EntityResponse.builder()
            .id(entity.getId())
            .field1(entity.getField1())
            .build();
    }
}
```

**Kotlin:**
```kotlin
// CreateEntityRequest.kt
data class CreateEntityRequest(
    @field:Schema(description = "Field description", example = "example value")
    @field:NotBlank
    val field1: String,

    @field:Schema(description = "Field description", example = "123")
    @field:NotNull
    val field2: Long
)

// EntityResponse.kt
data class EntityResponse(
    @Schema(description = "Entity ID", example = "1")
    val id: Long,

    @Schema(description = "Field description")
    val field1: String
) {
    companion object {
        fun from(entity: Entity) = EntityResponse(
            id = entity.id,
            field1 = entity.field1
        )
    }
}
```

### 2. Create UseCase (application/usecase/)

**Java:**
```java
@Component
@RequiredArgsConstructor
public class CreateEntityUsecase {
    private final EntitySaveService entitySaveService;
    private final EntityMapper entityMapper;

    @Transactional
    public EntityResponse execute(CreateEntityRequest request, Long userId) {
        Entity entity = entityMapper.toEntity(request, userId);
        Entity saved = entitySaveService.save(entity);
        return EntityResponse.from(saved);
    }
}
```

**Kotlin:**
```kotlin
@Component
class CreateEntityUsecase(
    private val entitySaveService: EntitySaveService,
    private val entityMapper: EntityMapper
) {
    @Transactional
    fun execute(request: CreateEntityRequest, userId: Long): EntityResponse {
        val entity = entityMapper.toEntity(request, userId)
        val saved = entitySaveService.save(entity)
        return EntityResponse.from(saved)
    }
}
```

### 3. Create Domain Services (domain/service/)

Service naming convention (Single Responsibility):
- `{Entity}GetService` - Read operations (findById, findAll, search)
- `{Entity}SaveService` - Create operations (save, create)
- `{Entity}UpdateService` - Update operations (update, modify)
- `{Entity}DeleteService` - Delete operations (delete, soft delete)

**Java:**
```java
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class EntityGetService {
    private final EntityRepository repository;

    public Entity findById(Long id) {
        return repository.findByIdAndDeletedAtIsNull(id)
            .orElseThrow(EntityNotFoundException::new);
    }
}

@Service
@RequiredArgsConstructor
public class EntitySaveService {
    private final EntityRepository repository;

    @Transactional
    public Entity save(Entity entity) {
        return repository.save(entity);
    }
}
```

**Kotlin:**
```kotlin
@Service
@Transactional(readOnly = true)
class EntityGetService(
    private val repository: EntityRepository
) {
    fun findById(id: Long): Entity =
        repository.findByIdAndDeletedAtIsNull(id)
            ?: throw EntityNotFoundException()
}

@Service
class EntitySaveService(
    private val repository: EntityRepository
) {
    @Transactional
    fun save(entity: Entity): Entity = repository.save(entity)
}
```

### 4. Create Repository (domain/repository/)

**Java:**
```java
public interface EntityRepository extends JpaRepository<Entity, Long> {
    Optional<Entity> findByIdAndDeletedAtIsNull(Long id);
    List<Entity> findAllByDeletedAtIsNull();
}
```

**Kotlin:**
```kotlin
interface EntityRepository : JpaRepository<Entity, Long> {
    fun findByIdAndDeletedAtIsNull(id: Long): Entity?
    fun findAllByDeletedAtIsNull(): List<Entity>
}
```

### 5. Create Controller (presentation/)

**Java:**
```java
@Tag(name = "ENTITY")
@RestController
@RequestMapping("/api/v1/entities")
@RequiredArgsConstructor
public class EntityController {
    private final CreateEntityUsecase createEntityUsecase;
    private final GetEntityUsecase getEntityUsecase;

    @PostMapping
    @Operation(summary = "Create entity")
    public ResponseEntity<EntityResponse> create(
        @AuthenticationPrincipal UserDetails user,
        @Valid @RequestBody CreateEntityRequest request
    ) {
        return ResponseEntity.ok(createEntityUsecase.execute(request, getUserId(user)));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get entity by ID")
    public ResponseEntity<EntityResponse> getById(
        @PathVariable Long id
    ) {
        return ResponseEntity.ok(getEntityUsecase.execute(id));
    }
}
```

**Kotlin:**
```kotlin
@Tag(name = "ENTITY")
@RestController
@RequestMapping("/api/v1/entities")
class EntityController(
    private val createEntityUsecase: CreateEntityUsecase,
    private val getEntityUsecase: GetEntityUsecase
) {
    @PostMapping
    @Operation(summary = "Create entity")
    fun create(
        @AuthenticationPrincipal user: UserDetails,
        @Valid @RequestBody request: CreateEntityRequest
    ): ResponseEntity<EntityResponse> =
        ResponseEntity.ok(createEntityUsecase.execute(request, user.userId))

    @GetMapping("/{id}")
    @Operation(summary = "Get entity by ID")
    fun getById(@PathVariable id: Long): ResponseEntity<EntityResponse> =
        ResponseEntity.ok(getEntityUsecase.execute(id))
}
```

### 6. Create Exception (application/exception/)

**Java:**
```java
@Getter
@AllArgsConstructor
public enum EntityErrorCode implements ErrorCodeInterface {
    ENTITY_NOT_FOUND(2001, HttpStatus.NOT_FOUND, "Entity not found"),
    ENTITY_ACCESS_DENIED(2002, HttpStatus.FORBIDDEN, "Access denied");

    private final int code;
    private final HttpStatus status;
    private final String message;
}

public class EntityNotFoundException extends BaseException {
    public EntityNotFoundException() {
        super(EntityErrorCode.ENTITY_NOT_FOUND);
    }
}
```

**Kotlin:**
```kotlin
enum class EntityErrorCode(
    override val code: Int,
    override val status: HttpStatus,
    override val message: String
) : ErrorCodeInterface {
    ENTITY_NOT_FOUND(2001, HttpStatus.NOT_FOUND, "Entity not found"),
    ENTITY_ACCESS_DENIED(2002, HttpStatus.FORBIDDEN, "Access denied")
}

class EntityNotFoundException : BaseException(EntityErrorCode.ENTITY_NOT_FOUND)
```

## Rules

1. **Authentication**: Use `@AuthenticationPrincipal` or custom annotation for user ID
2. **Validation**: Apply `@Valid`, `@NotNull`, `@NotBlank` on Request DTOs
3. **Soft Delete**: Include `deletedAt IS NULL` in queries
4. **Transaction**:
   - GetService: `@Transactional(readOnly = true)`
   - Save/Update/DeleteService: `@Transactional`
5. **Response Format**: Use Response DTO's factory method (`from()`)

## Checklist

- [ ] Create DTOs (Request, Response)
- [ ] Create UseCase
- [ ] Create Services (following naming convention)
- [ ] Create Repository (with soft delete queries)
- [ ] Create Controller (with OpenAPI annotations)
- [ ] Create Exception/ErrorCode
- [ ] Run linter
