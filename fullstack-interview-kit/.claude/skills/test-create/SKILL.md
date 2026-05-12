---
name: test-create
description: Generate focused tests or manual verification for the target project. Use when the user asks to write tests, create tests, add coverage, or verify behavior.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Test Create

Create tests that match the target project. Match the user's prompt language.

## Required Context

Read `.interview-context.md` and `.interview-rules.md` when they exist.

## Workflow

1. Inspect existing tests before choosing a framework or style.
2. Identify the target behavior and risk.
3. Choose the narrowest useful test:
   - pure domain/unit test
   - service/usecase orchestration test
   - controller/API contract test
   - frontend component or interaction test
   - manual verification checklist
4. Write only the tests that fit the time tier.
5. Run the narrowest available command when feasible.

## Rules

- Do not add test dependencies without explicit approval.
- Do not assume Kotest, MockK, Mockito, JUnit, Vitest, Jest, or Testing Library; inspect first.
- Do not add project-specific fixtures or base classes unless they already exist.
- In Sprint/Core, prefer manual verification unless tests are required or trivial.
- In Full/Polish, add 1-2 focused tests around the riskiest behavior.

## Output Shape

```markdown
## Test Target
- Behavior:
- Risk:
- Existing test style:

## Proposed Cases
- Happy path:
- Validation/failure:
- Boundary:

## Verification
- Command:
- Manual path:
```
