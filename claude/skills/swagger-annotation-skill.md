---
name: swagger-annotation
description: Swagger/OpenAPI 어노테이션 작성 가이드. Java/Kotlin DTO 및 Controller에 @Schema, @Operation, @ApiResponses 어노테이션을 일관되게 작성할 때 사용. SpringDoc OpenAPI 기반 프로젝트에서 API 문서화 시 활용.
---

# Swagger 어노테이션 가이드

## 기본 원칙

- 모든 DTO 필드에 `@Schema` 필수
- description은 한국어로 명확하게
- example은 실제 사용 예시와 유사하게
- Validation 어노테이션과 함께 사용

## Request DTO 패턴

```java
public record FeedUpdateRequest(
        @Schema(description = "피드 설명", example = "행복한 링크 생활 (수정할 값만 보내주세요)")
        @Size(max = 100)
        String description,

        @Schema(description = "미디어 목록")
        @Valid
        @Size(min = 1, max = 3)
        List<FeedMediaRequest> media,

        @Schema(description = "함께한 사용자 목록 (수정할 값만 보내주세요)")
        List<Long> userIds
) { }
```

## Response DTO 패턴

```java
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public record FeedCommentResponse(
        @Schema(description = "댓글 id", example = "1")
        long commentId,

        @JsonUnwrapped
        @Schema(implementation = UserProfileResponse.class)
        UserProfileResponse user,

        @Schema(description = "댓글", example = "오 좋은데??")
        String comment,

        @Schema(description = "댓글 작성 시간", example = "2025-06-30T00:00:00")
        LocalDateTime createdAt
) { }
```

## @Schema 속성

**필수:**
| 속성 | 조건 | 설명 |
|------|------|------|
| description | 항상 | 필드 설명 (한국어) |
| example | 항상 | 실제와 유사한 예시 값 |
| implementation | @JsonUnwrapped 시 | 펼쳐질 클래스 타입 |

**선택:** hidden, deprecated, nullable, defaultValue

## 타입별 example

```java
// String
@Schema(description = "피드 설명", example = "오늘의 일상")
String description;

// Long, Integer
@Schema(description = "피드 ID", example = "1")
long feedId;

// Boolean
@Schema(description = "좋아요 여부", example = "true")
boolean liked;

// LocalDateTime
@Schema(description = "생성 시간", example = "2025-06-30T14:30:00")
LocalDateTime createdAt;

// LocalDate
@Schema(description = "생성 날짜", example = "2025-06-30")
LocalDate createdDate;

// Enum
@Schema(description = "피드 상태", example = "ACTIVE")
FeedStatus status;

// List<Long>
@Schema(description = "사용자 ID 목록", example = "[1, 2, 3]")
List<Long> userIds;

// List<String>
@Schema(description = "태그 목록", example = "[\"일상\", \"여행\"]")
List<String> tags;
```

## Controller 어노테이션

```java
@Operation(
    summary = "피드 수정",
    description = "피드의 설명, 미디어, 태그된 사용자를 수정합니다. 수정할 필드만 전송하면 됩니다."
)
@ApiResponses({
    @ApiResponse(responseCode = "200", description = "수정 성공"),
    @ApiResponse(responseCode = "400", description = "잘못된 요청"),
    @ApiResponse(responseCode = "401", description = "인증 필요"),
    @ApiResponse(responseCode = "403", description = "수정 권한 없음"),
    @ApiResponse(responseCode = "404", description = "피드를 찾을 수 없음")
})
@PatchMapping("/{feedId}")
public ApiResponse<FeedResponse> update(
        @Parameter(description = "피드 ID", example = "1")
        @PathVariable Long feedId,
        
        @RequestBody @Valid FeedUpdateRequest request
) { ... }
```

## 페이징 Response 패턴

```java
public record PageResponse<T>(
        @Schema(description = "데이터 목록")
        List<T> content,
        
        @Schema(description = "현재 페이지 번호", example = "0")
        int pageNumber,
        
        @Schema(description = "페이지 크기", example = "20")
        int pageSize,
        
        @Schema(description = "전체 요소 수", example = "100")
        long totalElements,
        
        @Schema(description = "전체 페이지 수", example = "5")
        int totalPages,
        
        @Schema(description = "마지막 페이지 여부", example = "false")
        boolean last
) { }
```

## 자주 하는 실수

```java
// ❌ description 또는 example 누락
@Schema(example = "1")
long feedId;

// ❌ 의미 없는 example
@Schema(description = "사용자 이름", example = "test")
String userName;

// ❌ @JsonUnwrapped에 implementation 누락
@JsonUnwrapped
@Schema
UserProfileResponse user;

// ✅ 올바른 사용
@Schema(description = "피드 ID", example = "1")
long feedId;

@Schema(description = "사용자 이름", example = "홍길동")
String userName;

@JsonUnwrapped
@Schema(implementation = UserProfileResponse.class)
UserProfileResponse user;
```

## 체크리스트

**DTO:**
- [ ] 모든 필드에 @Schema(description, example)가 있는가?
- [ ] @JsonUnwrapped 사용 시 implementation을 지정했는가?

**Controller:**
- [ ] @Operation(summary, description)이 있는가?
- [ ] @ApiResponses로 모든 응답 코드를 문서화했는가?
- [ ] @Parameter로 PathVariable, RequestParam을 설명했는가?
