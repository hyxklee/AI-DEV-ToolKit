# Debugging Prompt

Use this prompt when something fails during a live coding interview.

## Workflow

1. Identify the failing layer: browser/UI, API client, controller, application logic, domain logic, persistence, build/tooling.
2. State the exact symptom and expected behavior.
3. Form 3 likely hypotheses in priority order.
4. Verify the cheapest hypothesis first.
5. Make the smallest fix.
6. Re-run the narrowest verification.
7. Search for the same pattern if the bug may repeat.

## Fast Checks

Backend:

- Controller path and HTTP method match frontend call.
- Request DTO validation matches submitted JSON.
- `@RequestBody`, `@PathVariable`, and `@RequestParam` are correct.
- Transaction boundary exists on the write Service/UseCase entry point.
- Repository method name or query matches entity field names.

Frontend:

- API base URL is correct.
- Response wrapper is unwrapped correctly.
- Submit button is not disabled forever after an exception.
- State is updated or refetched after mutation.
- Controlled inputs have correct `value` and `onChange`.
