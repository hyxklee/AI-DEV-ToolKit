# Final Review Prompt

Use this prompt in the last 5-10 minutes of a live coding interview.

## Review Order

1. Does the solution satisfy `.interview-context.md` requirements and assumptions?
2. Does the main happy path work end to end?
3. Are validation errors handled?
4. Are loading, error, empty, and success UI states visible?
5. Are backend transactions placed at the project-consistent Service/UseCase/QueryService boundary?
6. Are business rules in entities, services, use cases, or clear domain functions according to the project style?
7. Are names readable enough for the interviewer?
8. Are there unused files, dead code, or console logs?
9. Can you explain the tradeoffs in under 60 seconds?

## Wrap-up Template

```text
I implemented the vertical slice first: API contract, backend persistence/use case, and frontend workflow.
The backend keeps HTTP concerns in the controller and business invariants in the entity.
The frontend handles loading, error, empty, and success states.
If I had more time, I would add broader tests, refine edge cases, and improve accessibility details.
```
