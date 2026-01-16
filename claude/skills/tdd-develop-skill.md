---
name: red-green-refactor
description: TDD Red-Green-Refactor 사이클 가이드. 테스트 주도 개발 시 실패하는 테스트 작성(Red), 최소한의 코드로 통과(Green), 리팩토링(Refactor) 순서를 따를 때 사용. Kotest DescribeSpec 기반 Kotlin/JVM 프로젝트에서 TDD 실천 시 활용.
---

# TDD Red-Green-Refactor 사이클

## Red 단계: 실패하는 테스트 작성

1. 구현하려는 동작을 테스트로 먼저 표현
2. **한 번에 하나의 동작만** 테스트
3. 테스트 실행하여 **실패 확인 필수** (컴파일 에러도 실패로 간주)

```kotlin
// Kotest DescribeSpec 예시
class CalculatorTest : DescribeSpec({
    describe("Calculator") {
        it("두 숫자를 더한다") {
            val calculator = Calculator()
            calculator.add(2, 3) shouldBe 5
        }
    }
})
```

실패 메시지가 의도한 대로인지 확인. 엉뚱한 이유로 실패하면 테스트 자체에 문제가 있음.

## Green 단계: 테스트 통과

1. **테스트를 통과시키는 최소한의 코드만** 작성
2. 하드코딩, 중복, 지저분한 코드 허용
3. 목표는 오직 초록 막대

```kotlin
class Calculator {
    fun add(a: Int, b: Int): Int = 5  // 하드코딩도 OK
}
```

"작동하는 코드"가 먼저, "깨끗한 코드"는 다음 단계.

## Refactor 단계: 코드 개선

1. **테스트 통과 상태 유지**하며 개선
2. 중복 제거, 네이밍 개선, 패턴 적용
3. 리팩토링 후 **테스트 재실행 필수**
4. 새 기능 추가 금지 - 구조 개선만

```kotlin
class Calculator {
    fun add(a: Int, b: Int): Int = a + b  // 일반화
}
```

## 사이클 규칙

- 테스트 없이 프로덕션 코드 작성 금지
- 실패하는 테스트 없이 프로덕션 코드 수정 금지
- 테스트 통과 후 커밋 권장 (작은 커밋 단위 유지)
- 리팩토링 중 새 기능 추가 금지
- 리팩토링 중 테스트 수정은 최소화

## 체크리스트

### Red
- [ ] 테스트가 하나의 동작만 검증하는가?
- [ ] 테스트 실행하여 실패를 확인했는가?
- [ ] 실패 메시지가 의도한 대로인가?

### Green
- [ ] 가장 간단한 방법으로 통과시켰는가?
- [ ] 테스트가 초록인가?

### Refactor
- [ ] 테스트가 여전히 초록인가?
- [ ] 중복을 제거했는가?
- [ ] 의도를 드러내는 이름인가?
- [ ] 새 기능을 추가하지 않았는가?
