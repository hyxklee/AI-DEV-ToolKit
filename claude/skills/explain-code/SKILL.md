---
name: explain-code
description: Explain code using diagrams and analogies. Use when understanding code logic or architecture.
user-invocable: true
allowed-tools: Read, Glob, Grep
---

# Code Explainer

Code explanation target: $ARGUMENTS

## Explanation Order

### 1. Start with Analogy
Explain the core idea using familiar everyday concepts.

Examples:
- Repository → "Librarian" (finds and retrieves data)
- Service → "Chef" (processes ingredients into dishes)
- Controller → "Waiter" (takes orders, delivers results)
- UseCase → "Recipe" (orchestrates steps to achieve outcome)
- DTO → "Order form" (structured data transfer)
- Entity → "Ingredients" (raw domain objects)
- Mapper → "Kitchen prep" (transforms between formats)

### 2. Draw ASCII Diagram

#### Sequence Diagram
```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│Controller│     │ UseCase  │     │ Service  │     │Repository│
└────┬─────┘     └────┬─────┘     └────┬─────┘     └────┬─────┘
     │   request      │                │                │
     │───────────────>│                │                │
     │                │   execute()    │                │
     │                │───────────────>│                │
     │                │                │   findById()   │
     │                │                │───────────────>│
     │                │                │    Entity      │
     │                │                │<───────────────│
     │                │    Entity      │                │
     │                │<───────────────│                │
     │   Response     │                │                │
     │<───────────────│                │                │
     │                │                │                │
```

#### Architecture Diagram
```
┌─────────────────────────────────────────────────────────┐
│                      Presentation                        │
│  ┌───────────────────────────────────────────────────┐  │
│  │                   Controller                       │  │
│  │  @RestController  @RequestMapping("/api/v1/...")  │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                      Application                         │
│  ┌───────────────┐  ┌───────────────┐  ┌─────────────┐  │
│  │    UseCase    │  │      DTO      │  │   Mapper    │  │
│  └───────────────┘  └───────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                        Domain                            │
│  ┌───────────────┐  ┌───────────────┐  ┌─────────────┐  │
│  │    Entity     │  │   Service     │  │ Repository  │  │
│  └───────────────┘  └───────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                    Infrastructure                        │
│  ┌───────────────┐  ┌───────────────┐  ┌─────────────┐  │
│  │   JPA Impl    │  │   Database    │  │  External   │  │
│  └───────────────┘  └───────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────┘
```

#### Data Flow Diagram
```
[Client]
     │
     │ POST /api/v1/users
     │ { "name": "John", "email": "john@example.com" }
     ▼
┌─────────────┐
│ Controller  │ ─── @Valid validation
└─────────────┘
     │
     │ CreateUserRequest
     ▼
┌─────────────┐
│   UseCase   │ ─── Orchestrates business logic
└─────────────┘
     │
     │ User Entity
     ▼
┌─────────────┐
│   Service   │ ─── Applies domain rules
└─────────────┘
     │
     │ save()
     ▼
┌─────────────┐
│ Repository  │ ─── Persists to DB
└─────────────┘
     │
     │ User (with ID)
     ▼
[UserResponse returned]
```

### 3. Code Walkthrough
Explain step by step how the code executes.

```
1. Client sends POST /api/v1/users request
2. Spring converts @RequestBody to CreateUserRequest
3. @Valid performs DTO validation
4. @AuthenticationPrincipal extracts userId from JWT
5. Controller calls UseCase.execute()
6. UseCase calls Service.save()
7. Service calls Repository.save()
8. Entity is saved to DB, returned with ID
9. Response DTO is built and returned to client
```

### 4. Gotchas (Common Mistakes)
Explain common mistakes or things to watch out for.

Examples:
- "Use `findByIdAndDeletedAtIsNull` instead of `findById` for soft delete"
- "Missing `@Transactional` can cause LazyInitializationException"
- "Service naming convention: Split into GetService, SaveService, etc."
- "Always validate input at Controller level with @Valid"

## Output Format

```markdown
# [Code Name] Explanation

## One-line Summary
[What this code does in one sentence]

## Analogy
[Everyday analogy to explain the concept]

## Diagram
[ASCII art diagram]

## Step-by-step Explanation
1. [First step]
2. [Second step]
...

## Gotchas
- [Common mistake 1]
- [Common mistake 2]

## Related Files
- `path/to/file1.kt` - [Role]
- `path/to/file2.java` - [Role]
```
