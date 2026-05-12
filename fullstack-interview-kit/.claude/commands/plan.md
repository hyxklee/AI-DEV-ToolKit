# Plan Live Coding Implementation

You are assisting in a live coding interview.

Do not write code yet.

Given the current task or `$ARGUMENTS`, produce:

1. Minimal implementation plan
2. Candidate files to inspect or modify
3. Backend/API contract if relevant
4. Frontend state and UI states if relevant
5. Test scenarios
6. Risks and edge cases

Rules:

- Read `.interview-context.md` and `.interview-rules.md` first if they exist.
- If either file is missing, recommend `/setup` before implementation.
- State the time tier first (Sprint/Core/Full/Polish) and scope the plan to that tier.
- Keep the plan to 3 steps or fewer.
- Include a verification method for each step (manual is fine for Sprint/Core).
- Do not introduce new dependencies.
- Preserve existing architecture and naming conventions of the target project.
- Do NOT propose types/utilities the target project does not already have (`CommonResponse`, `BaseException`, `UseCase`, `QueryService`, TanStack Query, etc.) — fall back to the simplest project-consistent pattern.
- Mark uncertain requirements as assumptions.
