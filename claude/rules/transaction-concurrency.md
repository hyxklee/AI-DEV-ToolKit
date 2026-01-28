# Transaction & Concurrency Rules

## Transaction Annotations

### Read Operations
```java
@Transactional(readOnly = true)
public FeedDetailResponse getFeedDetail(Long feedId) {
    // Query operations only
}
```

### Write Operations
```java
@Transactional
public void uploadFeed(long userId, FeedUploadRequest request) {
    // Create/Update/Delete operations
}
```

## Transaction Placement

- Place `@Transactional` on **UseCase** methods
- Domain Services should NOT have `@Transactional`
- Let UseCase manage transaction boundaries

```java
@Service
@RequiredArgsConstructor
public class FeedUsecase {
    private final FeedSaveService feedSaveService;
    private final MediaSaveService mediaSaveService;

    @Transactional
    public void uploadFeed(long userId, FeedUploadRequest request) {
        // Multiple service calls in single transaction
        Feed feed = feedMapper.toFeed(user, request.description());
        feedSaveService.save(feed);
        mediaSaveService.saveAll(feed, request.media());
    }
}
```

## Pessimistic Locking

For resources that need concurrent access control:

```java
public interface FeedRepository extends JpaRepository<Feed, Long> {
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @QueryHints(@QueryHint(name = "jakarta.persistence.lock.timeout", value = "2000"))
    @Query("SELECT f FROM Feed f WHERE f.id = :id")
    Optional<Feed> findByIdWithLock(@Param("id") Long id);
}
```

## When to Use Locking

| Scenario | Lock Type |
|----------|-----------|
| Counter updates (reaction count) | PESSIMISTIC_WRITE |
| Concurrent modifications | PESSIMISTIC_WRITE |
| Read-heavy, write-rare | OPTIMISTIC (version field) |

## Lock Timeout Handling

```java
@Service
public class ReactionUsecase {
    @Transactional
    public void react(Long userId, Long feedId) {
        try {
            Feed feed = feedRepository.findByIdWithLock(feedId)
                .orElseThrow(FeedNotFoundException::new);
            // process reaction
        } catch (PessimisticLockingFailureException e) {
            throw new ResourceLockedException();
        }
    }
}
```

## Optimistic Locking

Add version field to entity:

```java
@Entity
public class Feed extends BaseEntity {
    @Version
    private Long version;
}
```

## Transaction Propagation

Default propagation is `REQUIRED`. Use others when needed:

```java
// New transaction (for audit logs, etc.)
@Transactional(propagation = Propagation.REQUIRES_NEW)
public void logAction(String action) { }

// No transaction
@Transactional(propagation = Propagation.NOT_SUPPORTED)
public void nonTransactionalOperation() { }
```

## Transaction Isolation

Default is database default. Adjust for specific needs:

```java
@Transactional(isolation = Isolation.SERIALIZABLE)
public void criticalOperation() { }
```

## Rollback Rules

```java
// Rollback on checked exceptions too
@Transactional(rollbackFor = Exception.class)
public void operation() throws CheckedException { }

// Don't rollback on specific exception
@Transactional(noRollbackFor = BusinessException.class)
public void operation() { }
```

## Async Operations

For async operations, transaction context is NOT propagated:

```java
@Async
@Transactional
public void asyncOperation() {
    // New transaction in async thread
}
```

## Best Practices

1. **Keep transactions short** - Don't do I/O operations inside transactions
2. **Avoid nested transactions** - Can cause unexpected behavior
3. **Lock ordering** - Always acquire locks in same order to prevent deadlocks
4. **Timeout configuration** - Always set lock timeouts
5. **Handle lock exceptions** - Convert to user-friendly errors
