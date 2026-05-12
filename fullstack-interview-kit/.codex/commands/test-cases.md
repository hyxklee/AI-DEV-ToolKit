# Generate Test Cases

You are assisting in a live coding interview.

Given the current implementation or `$ARGUMENTS`, produce focused tests and verification steps.

Read `.interview-context.md` and `.interview-rules.md` first if they exist.

Include:

1. Happy path
2. Boundary cases
3. Failure cases
4. Validation cases
5. Transaction/concurrency concerns if relevant
6. Suggested narrow test command

Rules:

- Prefer tests that demonstrate behavior, not implementation details.
- For Kotlin/Spring, prefer the target project's existing test stack. Use Kotest + MockK only when the project already uses or clearly supports it.
- Use existing fixtures and package structure.
- If tests are too expensive for the interview, provide a manual verification checklist.
