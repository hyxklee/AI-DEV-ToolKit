# Live Coding Flow

## Time Tier (decide first)

| Time     | Tier   | Cut |
|----------|--------|-----|
| ≤ 30 min | Sprint | Vertical slice only. No tests, no extra architecture layers. |
| ≤ 60 min | Core   | Add validation + 1-2 edge cases. Manual verification is acceptable. |
| ≤ 90 min | Full   | Add 1-2 focused tests for the riskiest behavior. |
| > 90 min | Polish | Broader tests, README, accessibility/error UX polish. |

## First 3 Minutes

- Restate the problem in concrete terms.
- Identify the main entity, fields, and actions.
- Define the minimum vertical slice.
- Confirm only blocking ambiguities.

## Backend

- API contract is clear before coding.
- Request DTO has validation.
- Response DTO is typed and small.
- Entity owns invariants and state changes.
- Service or UseCase handles orchestration and transaction boundary.
- QueryService exists only if the project already uses it or read assembly is complex.
- Controller returns the project's existing response shape, or plain `ResponseEntity`.
- Custom response wrappers, error codes, Reader/Port layers, and mappers are optional, not default.

## Frontend

- API types match backend DTOs.
- The page shows the real workflow immediately.
- Loading, error, empty, and success states exist.
- Form validation prevents obvious bad submissions.
- Mutations disable controls while pending.
- State refreshes after create/update/delete.

## Final 5 Minutes

- Run the narrowest useful verification.
- Remove dead code and noisy logs.
- Check naming and readability.
- Prepare a short explanation of architecture choices.
