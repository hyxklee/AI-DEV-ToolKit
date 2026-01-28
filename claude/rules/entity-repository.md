# Entity & Repository Rules

## Entity Base Class

**Java:**
```java
@MappedSuperclass
@Getter
@SuperBuilder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class)
public abstract class BaseEntity {
    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    private LocalDateTime updatedAt;
}
```

**Kotlin:**
```kotlin
@MappedSuperclass
@EntityListeners(AuditingEntityListener::class)
abstract class BaseEntity {
    @CreatedDate
    @Column(updatable = false)
    var createdAt: LocalDateTime? = null

    @LastModifiedDate
    var updatedAt: LocalDateTime? = null
}
```

## Entity Structure

**Java:**
```java
@Getter
@Entity
@SuperBuilder
@Table(
    name = "users",
    indexes = {
        @Index(name = "idx_users_email", columnList = "email"),
        @Index(name = "idx_users_created_deleted", columnList = "created_at, deleted_at")
    }
)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class User extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private UserStatus status;

    private LocalDateTime deletedAt;

    // Business methods
    public void delete() {
        this.deletedAt = LocalDateTime.now();
    }

    public void updateName(String name) {
        this.name = name;
    }

    public boolean isDeleted() {
        return this.deletedAt != null;
    }
}
```

**Kotlin:**
```kotlin
@Entity
@Table(
    name = "users",
    indexes = [
        Index(name = "idx_users_email", columnList = "email"),
        Index(name = "idx_users_created_deleted", columnList = "created_at, deleted_at")
    ]
)
class User(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @Column(nullable = false, length = 100)
    var name: String,

    @Column(nullable = false, unique = true)
    val email: String,

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    var status: UserStatus,

    var deletedAt: LocalDateTime? = null
) : BaseEntity() {

    fun delete() {
        this.deletedAt = LocalDateTime.now()
    }

    fun updateName(name: String) {
        this.name = name
    }

    val isDeleted: Boolean
        get() = this.deletedAt != null
}
```

## Entity Rules

| Rule | Implementation |
|------|---------------|
| Soft delete | Use `deletedAt` field, never hard delete |
| Timestamps | Inherit from `BaseEntity` |
| Constructors (Java) | `@NoArgsConstructor(access = PROTECTED)` |
| Building (Java) | Use `@SuperBuilder` |
| Relationships | Always `FetchType.LAZY` |
| Index naming | `idx_{table}_{columns}` |

## Relationship Patterns

**Java:**
```java
// Many-to-One (common)
@ManyToOne(fetch = FetchType.LAZY, optional = false)
@JoinColumn(name = "user_id", nullable = false, updatable = false)
private User user;

// One-to-Many (use sparingly, prefer queries)
@OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
private List<Order> orders = new ArrayList<>();
```

**Kotlin:**
```kotlin
// Many-to-One (common)
@ManyToOne(fetch = FetchType.LAZY, optional = false)
@JoinColumn(name = "user_id", nullable = false, updatable = false)
val user: User

// One-to-Many (use sparingly, prefer queries)
@OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], orphanRemoval = true)
val orders: MutableList<Order> = mutableListOf()
```

## Repository Interface

**Java:**
```java
public interface UserRepository extends JpaRepository<User, Long> {
    // Soft delete filter in queries
    @Query("SELECT u FROM User u WHERE u.deletedAt IS NULL AND u.id = :id")
    Optional<User> findActiveById(@Param("id") Long id);

    Optional<User> findByEmailAndDeletedAtIsNull(String email);

    List<User> findAllByDeletedAtIsNull();
}
```

**Kotlin:**
```kotlin
interface UserRepository : JpaRepository<User, Long> {
    // Soft delete filter in queries
    @Query("SELECT u FROM User u WHERE u.deletedAt IS NULL AND u.id = :id")
    fun findActiveById(@Param("id") id: Long): User?

    fun findByEmailAndDeletedAtIsNull(email: String): User?

    fun findAllByDeletedAtIsNull(): List<User>
}
```

## Query Patterns

### Fetch Join (avoid N+1)

**Java/Kotlin:**
```java
@Query("SELECT u FROM User u JOIN FETCH u.profile WHERE u.deletedAt IS NULL")
List<User> findAllWithProfile();
```

### Pagination with Slice

```java
@Query("SELECT u FROM User u WHERE u.deletedAt IS NULL ORDER BY u.createdAt DESC")
Slice<User> findAllActive(Pageable pageable);
```

### Filter Query

```java
@Query("SELECT u FROM User u WHERE u.deletedAt IS NULL " +
       "AND u.status = :status " +
       "ORDER BY u.createdAt DESC")
List<User> findAllByStatus(@Param("status") UserStatus status);
```

## Pessimistic Locking

For concurrent modifications:

```java
@Lock(LockModeType.PESSIMISTIC_WRITE)
@QueryHints(@QueryHint(name = "jakarta.persistence.lock.timeout", value = "2000"))
@Query("SELECT u FROM User u WHERE u.id = :id")
Optional<User> findByIdWithLock(@Param("id") Long id);
```

## Optimistic Locking

Add version field to entity:

```java
@Entity
public class User extends BaseEntity {
    @Version
    private Long version;
}
```

## Soft Delete Queries

Always include soft delete filter:

```java
// Good - filters deleted records
@Query("SELECT u FROM User u WHERE u.deletedAt IS NULL")
List<User> findAllActive();

// Bad - includes deleted records
List<User> findAll();

// Good - Spring Data method naming
List<User> findAllByDeletedAtIsNull();
```

## Index Strategy

Define indexes explicitly in `@Table`:

```java
@Table(
    name = "users",
    indexes = {
        @Index(name = "idx_users_email", columnList = "email"),
        @Index(name = "idx_users_status", columnList = "status"),
        @Index(name = "idx_users_created_deleted", columnList = "created_at, deleted_at")
    },
    uniqueConstraints = {
        @UniqueConstraint(name = "uk_users_email", columnNames = "email")
    }
)
```
