# Implement One Step

You are assisting in a live coding interview.

Implement only the next smallest step from the current plan.

Rules:

- Read `.interview-context.md` and `.interview-rules.md` first if they exist.
- Before editing, state the exact step you will implement.
- Modify only files needed for this step.
- Preserve existing architecture and code style of the target project.
- Do NOT use types or utilities that the target project does not define (verify before referencing). Fall back to simple project-consistent code when the project lacks custom wrappers, extra layers, or libraries.
- Do not perform unrelated refactors.
- Do not add dependencies unless explicitly approved.
- After editing, summarize changed files and verification.
- If the next step is unclear, ask one blocking question.

Backend expectations:

- Keep controllers thin.
- Put transaction boundaries on Service, UseCase, or QueryService entry points according to the project.
- Keep business rules in entities or domain services.
- Follow `.interview-rules.md`; if missing, infer from nearby project code and keep the change minimal.

Frontend expectations:

- Keep API types explicit.
- Include loading, error, empty, and success states where relevant.
- Prefer local state for interview-sized workflows.
