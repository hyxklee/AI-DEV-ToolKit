# Testing Rules

## Frameworks

| Framework | Purpose |
|-----------|---------|
| JUnit 5 | Java test runner |
| Kotest | Kotlin test framework |
| Mockito | Java mocking |
| MockK | Kotlin mocking |
| springmockk | Spring bean mocking (`@MockkBean`) |
| Testcontainers | Integration tests (DB, Redis, etc.) |

## Test Styles (Kotest)

| Style | Use Case |
|-------|----------|
| `StringSpec` | Simple tests with minimal boilerplate |
| `BehaviorSpec` | BDD-style tests (Given/When/Then) |
| `DescribeSpec` | Technical specs with describe/context/it |

## Test Structure

### Unit Test (Java)

```java
@ExtendWith(MockitoExtension.class)
class UserSaveServiceTest {
    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserSaveService userSaveService;

    @Test
    @DisplayName("should save user successfully")
    void saveUser() {
        // given
        User user = UserTestFixture.createUser(null, "test@example.com");
        when(userRepository.save(any())).thenReturn(user.toBuilder().id(1L).build());

        // when
        User result = userSaveService.save(user);

        // then
        assertThat(result.getId()).isEqualTo(1L);
        verify(userRepository).save(user);
    }
}
```

### Unit Test (Kotlin - StringSpec)

```kotlin
class UserSaveServiceTest : StringSpec({
    val userRepository = mockk<UserRepository>()
    val userSaveService = UserSaveService(userRepository)

    "should save user successfully" {
        // given
        val user = UserTestFixture.createUser(null, "test@example.com")
        every { userRepository.save(any()) } returns user.copy(id = 1L)

        // when
        val result = userSaveService.save(user)

        // then
        result.id shouldBe 1L
        verify { userRepository.save(user) }
    }
})
```

### Unit Test (Kotlin - DescribeSpec)

```kotlin
class UserGetServiceTest : DescribeSpec({
    val userRepository = mockk<UserRepository>()
    val service = UserGetService(userRepository)

    describe("findById") {
        context("when user exists") {
            it("should return user") {
                // given
                val user = UserTestFixture.createUser()
                every { userRepository.findByIdAndDeletedAtIsNull(1L) } returns user

                // when
                val result = service.findById(1L)

                // then
                result shouldBe user
            }
        }

        context("when user does not exist") {
            it("should throw UserNotFoundException") {
                // given
                every { userRepository.findByIdAndDeletedAtIsNull(999L) } returns null

                // when & then
                shouldThrow<UserNotFoundException> {
                    service.findById(999L)
                }
            }
        }
    }
})
```

### BehaviorSpec (BDD style)

```kotlin
class CreateUserUsecaseTest : BehaviorSpec({
    val userSaveService = mockk<UserSaveService>()
    val usecase = CreateUserUsecase(userSaveService)

    Given("a valid create user request") {
        val request = CreateUserRequest(name = "John", email = "john@example.com")
        val savedUser = UserTestFixture.createUser(1L, "john@example.com")

        every { userSaveService.save(any()) } returns savedUser

        When("creating user") {
            val result = usecase.execute(request)

            Then("user should be created") {
                result.id shouldBe 1L
            }

            Then("userSaveService.save should be called") {
                verify { userSaveService.save(any()) }
            }
        }
    }
})
```

## Test Fixtures

Create reusable test data:

**Java:**
```java
public class UserTestFixture {
    public static User createUser(Long id, String email) {
        return User.builder()
            .id(id)
            .name("Test User")
            .email(email)
            .status(UserStatus.ACTIVE)
            .build();
    }

    public static User createUser() {
        return createUser(1L, "test@example.com");
    }

    public static List<User> createUsers(int count) {
        return IntStream.rangeClosed(1, count)
            .mapToObj(i -> createUser((long) i, "user" + i + "@example.com"))
            .toList();
    }
}
```

**Kotlin:**
```kotlin
object UserTestFixture {
    fun createUser(
        id: Long = 1L,
        email: String = "test@example.com",
        name: String = "Test User",
        status: UserStatus = UserStatus.ACTIVE
    ) = User(
        id = id,
        name = name,
        email = email,
        status = status
    )

    fun createUsers(count: Int = 3) =
        (1..count).map { createUser(id = it.toLong(), email = "user$it@example.com") }
}
```

## Controller Test

**Java:**
```java
@WebMvcTest(UserController.class)
@Import(SecurityConfig.class)
class UserControllerTest {
    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private UserUsecase userUsecase;

    @Test
    @DisplayName("GET /users/{id} - should return user")
    void getUser() throws Exception {
        // given
        UserResponse response = UserResponse.builder()
            .id(1L)
            .name("Test User")
            .build();
        when(userUsecase.getUser(1L)).thenReturn(response);

        // when & then
        mockMvc.perform(get("/api/v1/users/{id}", 1L))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.id").value(1))
            .andExpect(jsonPath("$.name").value("Test User"));
    }
}
```

**Kotlin:**
```kotlin
@WebMvcTest(UserController::class)
@Import(SecurityConfig::class)
class UserControllerTest : DescribeSpec() {
    @Autowired
    lateinit var mockMvc: MockMvc

    @MockkBean
    lateinit var userUsecase: UserUsecase

    init {
        describe("GET /api/v1/users/{id}") {
            context("when user exists") {
                it("should return 200 OK with user") {
                    // given
                    val response = UserResponse(id = 1L, name = "Test User")
                    every { userUsecase.getUser(1L) } returns response

                    // when & then
                    mockMvc.perform(get("/api/v1/users/{id}", 1L))
                        .andExpect(status().isOk)
                        .andExpect(jsonPath("$.id").value(1))
                        .andExpect(jsonPath("$.name").value("Test User"))
                }
            }
        }
    }
}
```

## Integration Test (Testcontainers)

```kotlin
@SpringBootTest
@Testcontainers
class UserIntegrationTest {
    companion object {
        @Container
        val mysql = MySQLContainer("mysql:8.0")
            .withDatabaseName("testdb")

        @JvmStatic
        @DynamicPropertySource
        fun properties(registry: DynamicPropertyRegistry) {
            registry.add("spring.datasource.url", mysql::getJdbcUrl)
            registry.add("spring.datasource.username", mysql::getUsername)
            registry.add("spring.datasource.password", mysql::getPassword)
        }
    }

    @Autowired
    lateinit var userRepository: UserRepository

    @Test
    fun `should create and retrieve user`() {
        // given
        val user = User(name = "Test", email = "test@example.com", status = UserStatus.ACTIVE)

        // when
        val saved = userRepository.save(user)
        val found = userRepository.findById(saved.id)

        // then
        found.isPresent shouldBe true
        found.get().email shouldBe "test@example.com"
    }
}
```

## Test Commands

```bash
# Gradle
./gradlew test                           # Run all tests
./gradlew test --tests "UserServiceTest" # Specific class
./gradlew test --tests "*ServiceTest"    # Pattern match

# Maven
mvn test                                 # Run all tests
mvn test -Dtest=UserServiceTest          # Specific class
mvn test -Dtest=*ServiceTest             # Pattern match
```
