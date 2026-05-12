---
name: test-driven-development
description: Use when the user explicitly asks for TDD or when the time tier is Full/Polish and tests are part of the plan.
---

# Test-Driven Development

Use TDD pragmatically. Match the user's prompt language.

## When To Use

- Use when the user asks for TDD.
- Use in Full/Polish tiers when behavior is risky and the project already has a test stack.
- Skip in Sprint/Core unless the interview explicitly requires tests.

## Loop

1. Pick one behavior.
2. Write or outline the smallest failing test.
3. Run the narrowest test command when feasible.
4. Implement the smallest code change.
5. Re-run the test.
6. Refactor only if time remains.

## Rules

- Follow the project's existing test framework and style.
- Do not add test dependencies without explicit approval.
- If tests are too expensive for the time tier, write a manual verification checklist instead.
- Do not delete working implementation just because it was not written test-first during Sprint/Core.
