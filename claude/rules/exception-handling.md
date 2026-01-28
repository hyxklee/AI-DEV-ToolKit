# Exception Handling Rules

## Exception Hierarchy

```
RuntimeException
    └── BaseException (abstract)
            ├── UserNotFoundException
            ├── OrderNotFoundException
            └── ... (domain-specific exceptions)
```

## Base Exception

**Java:**
```java
@Getter
public abstract class BaseException extends RuntimeException {
    private final ErrorCodeInterface errorCode;

    protected BaseException(ErrorCodeInterface errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
    }

    protected BaseException(ErrorCodeInterface errorCode, String message) {
        super(message);
        this.errorCode = errorCode;
    }
}
```

**Kotlin:**
```kotlin
abstract class BaseException(
    val errorCode: ErrorCodeInterface,
    message: String? = null
) : RuntimeException(message ?: errorCode.message)
```

## Error Code Interface

**Java:**
```java
public interface ErrorCodeInterface {
    int getCode();
    HttpStatus getStatus();
    String getMessage();
}
```

**Kotlin:**
```kotlin
interface ErrorCodeInterface {
    val code: Int
    val status: HttpStatus
    val message: String
}
```

## Domain Error Codes

**Java:**
```java
@Getter
@AllArgsConstructor
public enum UserErrorCode implements ErrorCodeInterface {
    USER_NOT_FOUND(2001, HttpStatus.NOT_FOUND, "User not found"),
    USER_ALREADY_EXISTS(2002, HttpStatus.CONFLICT, "User already exists"),
    INVALID_CREDENTIALS(2003, HttpStatus.UNAUTHORIZED, "Invalid credentials");

    private final int code;
    private final HttpStatus status;
    private final String message;
}
```

**Kotlin:**
```kotlin
enum class UserErrorCode(
    override val code: Int,
    override val status: HttpStatus,
    override val message: String
) : ErrorCodeInterface {
    USER_NOT_FOUND(2001, HttpStatus.NOT_FOUND, "User not found"),
    USER_ALREADY_EXISTS(2002, HttpStatus.CONFLICT, "User already exists"),
    INVALID_CREDENTIALS(2003, HttpStatus.UNAUTHORIZED, "Invalid credentials")
}
```

## Common Error Codes

**Java:**
```java
@Getter
@AllArgsConstructor
public enum CommonErrorCode implements ErrorCodeInterface {
    // 3XXX: Server errors
    INTERNAL_SERVER_ERROR(3001, HttpStatus.INTERNAL_SERVER_ERROR, "Internal server error"),
    JSON_PROCESSING_ERROR(3002, HttpStatus.INTERNAL_SERVER_ERROR, "JSON processing error"),
    RESOURCE_LOCKED(3003, HttpStatus.CONFLICT, "Resource is locked"),

    // 4XXX: Client errors
    INVALID_ARGUMENT(4001, HttpStatus.BAD_REQUEST, "Invalid argument"),
    RESOURCE_NOT_FOUND(4003, HttpStatus.NOT_FOUND, "Resource not found"),
    METHOD_NOT_ALLOWED(4004, HttpStatus.METHOD_NOT_ALLOWED, "Method not allowed"),
    UNAUTHORIZED(4005, HttpStatus.UNAUTHORIZED, "Authentication required");

    private final int code;
    private final HttpStatus status;
    private final String message;
}
```

**Kotlin:**
```kotlin
enum class CommonErrorCode(
    override val code: Int,
    override val status: HttpStatus,
    override val message: String
) : ErrorCodeInterface {
    // 3XXX: Server errors
    INTERNAL_SERVER_ERROR(3001, HttpStatus.INTERNAL_SERVER_ERROR, "Internal server error"),
    JSON_PROCESSING_ERROR(3002, HttpStatus.INTERNAL_SERVER_ERROR, "JSON processing error"),
    RESOURCE_LOCKED(3003, HttpStatus.CONFLICT, "Resource is locked"),

    // 4XXX: Client errors
    INVALID_ARGUMENT(4001, HttpStatus.BAD_REQUEST, "Invalid argument"),
    RESOURCE_NOT_FOUND(4003, HttpStatus.NOT_FOUND, "Resource not found"),
    METHOD_NOT_ALLOWED(4004, HttpStatus.METHOD_NOT_ALLOWED, "Method not allowed"),
    UNAUTHORIZED(4005, HttpStatus.UNAUTHORIZED, "Authentication required")
}
```

## Domain Exception Classes

**Java:**
```java
public class UserNotFoundException extends BaseException {
    public UserNotFoundException() {
        super(UserErrorCode.USER_NOT_FOUND);
    }
}
```

**Kotlin:**
```kotlin
class UserNotFoundException : BaseException(UserErrorCode.USER_NOT_FOUND)
```

## Global Exception Handler

**Java:**
```java
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(BaseException.class)
    public ResponseEntity<ErrorResponse> handleBaseException(BaseException e) {
        log.error("BaseException: {}", e.getMessage());
        return ResponseEntity
            .status(e.getErrorCode().getStatus())
            .body(ErrorResponse.of(e.getErrorCode()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException e) {
        List<FieldError> errors = e.getBindingResult().getFieldErrors();
        return ResponseEntity
            .badRequest()
            .body(ErrorResponse.of(CommonErrorCode.INVALID_ARGUMENT, errors));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleException(Exception e) {
        log.error("Unexpected error: ", e);
        return ResponseEntity
            .internalServerError()
            .body(ErrorResponse.of(CommonErrorCode.INTERNAL_SERVER_ERROR));
    }
}
```

**Kotlin:**
```kotlin
@RestControllerAdvice
class GlobalExceptionHandler {
    private val log = LoggerFactory.getLogger(javaClass)

    @ExceptionHandler(BaseException::class)
    fun handleBaseException(e: BaseException): ResponseEntity<ErrorResponse> {
        log.error("BaseException: {}", e.message)
        return ResponseEntity
            .status(e.errorCode.status)
            .body(ErrorResponse.of(e.errorCode))
    }

    @ExceptionHandler(MethodArgumentNotValidException::class)
    fun handleValidation(e: MethodArgumentNotValidException): ResponseEntity<ErrorResponse> {
        val errors = e.bindingResult.fieldErrors
        return ResponseEntity
            .badRequest()
            .body(ErrorResponse.of(CommonErrorCode.INVALID_ARGUMENT, errors))
    }

    @ExceptionHandler(Exception::class)
    fun handleException(e: Exception): ResponseEntity<ErrorResponse> {
        log.error("Unexpected error: ", e)
        return ResponseEntity
            .internalServerError()
            .body(ErrorResponse.of(CommonErrorCode.INTERNAL_SERVER_ERROR))
    }
}
```

## Error Response

**Java:**
```java
@Getter
@Builder
public class ErrorResponse {
    private final int code;
    private final String message;
    private final List<FieldErrorResponse> errors;

    public static ErrorResponse of(ErrorCodeInterface errorCode) {
        return ErrorResponse.builder()
            .code(errorCode.getCode())
            .message(errorCode.getMessage())
            .build();
    }

    public static ErrorResponse of(ErrorCodeInterface errorCode, List<FieldError> fieldErrors) {
        return ErrorResponse.builder()
            .code(errorCode.getCode())
            .message(errorCode.getMessage())
            .errors(fieldErrors.stream()
                .map(FieldErrorResponse::of)
                .toList())
            .build();
    }
}

@Getter
@Builder
public class FieldErrorResponse {
    private final String field;
    private final String message;
    private final Object rejectedValue;

    public static FieldErrorResponse of(FieldError error) {
        return FieldErrorResponse.builder()
            .field(error.getField())
            .message(error.getDefaultMessage())
            .rejectedValue(error.getRejectedValue())
            .build();
    }
}
```

**Kotlin:**
```kotlin
data class ErrorResponse(
    val code: Int,
    val message: String,
    val errors: List<FieldErrorResponse>? = null
) {
    companion object {
        fun of(errorCode: ErrorCodeInterface) = ErrorResponse(
            code = errorCode.code,
            message = errorCode.message
        )

        fun of(errorCode: ErrorCodeInterface, fieldErrors: List<FieldError>) = ErrorResponse(
            code = errorCode.code,
            message = errorCode.message,
            errors = fieldErrors.map { FieldErrorResponse.of(it) }
        )
    }
}

data class FieldErrorResponse(
    val field: String,
    val message: String?,
    val rejectedValue: Any?
) {
    companion object {
        fun of(error: FieldError) = FieldErrorResponse(
            field = error.field,
            message = error.defaultMessage,
            rejectedValue = error.rejectedValue
        )
    }
}
```
