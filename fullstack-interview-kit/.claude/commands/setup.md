# Setup Interview Project

Prepare the target project for a live coding interview.

Use `$ARGUMENTS` as the source of truth for the interview task, constraints, time limit, required stack, and evaluation criteria.

Do not implement the feature yet.

## Workflow

1. Inspect the repository quickly:
   - build files: `build.gradle*`, `settings.gradle*`, `pom.xml`, `package.json`
   - source roots: `src/main`, `src/test`, `src`, `app`, `pages`, `components`
   - existing similar features
   - available test/build scripts
2. Decide the time tier:
   - Sprint: ≤ 30 min
   - Core: ≤ 60 min
   - Full: ≤ 90 min
   - Polish: > 90 min
3. Capture project conventions:
   - backend architecture shape
   - frontend state/data-fetching style
   - response and error handling style
   - validation style
   - test style
4. Create or update `.interview-context.md` at the project root.
5. Create or update `.interview-rules.md` at the project root.
6. End with the recommended next command.

## `.interview-context.md` Template

```markdown
# Interview Context

## Task
- ...

## Time Tier
- Tier:
- Reason:

## Requirements
- Functional:
- Non-functional:
- Explicit constraints:
- Assumptions:

## Project Conventions
- Backend:
- Frontend:
- API/response:
- Error handling:
- Validation:
- Tests:

## Implementation Target
- Smallest vertical slice:
- Backend files likely to change:
- Frontend files likely to change:
- API contract draft:

## Verification
- Narrow check command:
- Narrow test command:
- Manual path:

## Open Questions
- Blocking:
- Non-blocking:
```

## `.interview-rules.md` Template

```markdown
# Interview Rules

## Project Shape
- Backend:
- Frontend:
- Package/source roots:
- Similar features to copy:

## Architecture
- Default implementation shape:
- Transaction boundary:
- Mapping style:
- Cross-module/domain dependency rule:
- Patterns explicitly not present:

## API
- Path prefix:
- Response style:
- Error style:
- Validation style:
- Auth/current user style:

## Frontend
- Framework/router:
- API client style:
- State/data-fetching style:
- Form style:
- Styling/component system:
- Required UI states:

## Testing
- Test framework:
- Existing test examples:
- When to write tests:
- Narrow test command:

## Verification
- Check command:
- Test command:
- Manual path:

## Constraints
- Dependencies:
- Files/areas to avoid:
- Time-tier cuts:
```

## Rules

- Preserve existing architecture and naming.
- Do not add dependencies.
- Do not create source files during setup.
- Only create or update `.interview-context.md` and `.interview-rules.md`.
- Keep generated rules factual: write what exists in the project, not what the kit prefers.
- If requirements are missing, write clear assumptions instead of stopping unless the ambiguity is blocking.
- Keep the final response concise and include the next command, usually `/analyze` or `/plan`.
