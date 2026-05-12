# AGENTS.md

This directory is a portable full-stack live coding interview kit for Claude Code, Codex, and other agentic coding tools.

## Default Stack

- Backend: Kotlin, Spring Boot, JPA, Gradle
- Frontend: React, TypeScript, Node.js
- API: REST first unless the prompt requires another style

Treat this stack as the default only. If the target interview project uses a different framework, follow the project.

## First Step

Run the setup command before implementing:

```text
/setup <interview task, constraints, time limit, required stack, evaluation criteria>
```

The setup command must inspect the target project and create or update `.interview-context.md` and `.interview-rules.md`. All later commands should read both files before planning or editing.

## Required Reading

Before implementing, read:

- `.interview-context.md` if it exists
- `.interview-rules.md` if it exists
- `prompts/00-fullstack-live-coding.md`
- `checklist/live-coding-flow.md`

When touching backend, also read `prompts/01-backend-kotlin-spring.md`.
When touching frontend, also read `prompts/02-frontend-react-ts.md`.
When debugging, read `prompts/03-debugging.md`.
Before final submission, read `prompts/04-final-review.md`.

For live-coding prompts, run context routing in the matching tool directory:

- Claude Code: `.claude/skills/interview-context-sync/SKILL.md`
- Codex: `.codex/skills/interview-context-sync/SKILL.md`

## Commands

Commands are mirrored for both tools:

- Claude Code: `.claude/commands/`
- Codex: `.codex/commands/`

Use this visible routine during interviews:

1. `/setup`: inspect project, capture requirements, write `.interview-context.md` and `.interview-rules.md`.
2. `/analyze`: clarify requirements, inputs/outputs, assumptions, and edge cases.
3. `/plan`: propose 3 or fewer implementation steps with verification for each.
4. `/implement-step`: implement only the next smallest step.
5. `/test-cases`: generate happy path, boundary, failure, and validation cases.
6. `/review`: check requirement coverage, risks, and missing validation/tests.
7. `/explain`: prepare a short interviewer-facing explanation.

## Operating Rules

- Project conventions beat kit conventions.
- Restate the requirement in 3-5 concrete bullets.
- Decide the time tier first (Sprint / Core / Full / Polish) and announce it.
- Ask only blocking questions; otherwise state assumptions and continue.
- Define the API contract before coding the UI.
- Build the smallest working vertical slice first.
- Prefer interview-readable code over clever abstractions.
- Implement one step at a time; never rewrite the solution in one large pass.
- Do not introduce new dependencies unless explicitly approved.
- Do not invent project-specific types or utilities (`CommonResponse`, `BaseException`, `UseCase`, `QueryService`, `@ApiErrorCodeExample`, TanStack Query, Redux, etc.) when the target project does not define or require them.
- End with verification and a short explanation.

## Architecture Defaults

Use the simplest architecture that matches the target project and time tier.

| Tier | Default backend shape |
|------|-----------------------|
| Sprint/Core | `Controller -> Service -> Repository`, DTOs, validation, plain exceptions or existing handler |
| Full/Polish | Existing project architecture, or richer UseCase/QueryService/Mapper only when it pays for itself |

Static project rules are intentionally not bundled. `/setup` generates `.interview-rules.md` from the target repository. If that file is missing, infer conventions from nearby code and keep the implementation minimal.

## Backend Rules

- Controller handles HTTP only.
- Service or UseCase handles orchestration and transaction boundaries, depending on the target project.
- Entity owns meaningful invariants and state changes when using JPA.
- DTOs are `data class`; JPA entities are regular `class` types.
- Prefer `val`; avoid `!!`.
- Use custom response wrappers, error-code enums, and domain exceptions only when the target project already has that pattern.

## Frontend Rules

- Type API request and response shapes.
- Handle loading, error, empty, and success states.
- Use local state for interview-sized screens unless the project already has a data-fetching library.
- Keep the first screen focused on the actual workflow.
- Disable submit buttons while pending.

## Verification

Use the narrowest useful command:

```bash
./scripts/check.sh
./scripts/test.sh
./scripts/test.sh "*TargetTest"
./gradlew test --tests "*TargetTest"
./gradlew test
npm test
npm run build
npm run dev
```

If commands cannot be run during the interview, provide a manual verification checklist.

## Output Language

Match the user's prompt language (Korean ↔ English). Code identifiers, file names, and commit messages stay English regardless.

## Hooks

Claude Code hook configuration is included in `.claude/settings.json`.
The included `ktlint-format.sh` hook formats changed Kotlin files only when the target project has an executable `./gradlew` and a `ktlintFormat` task.
The included `live-coding-guard.sh` hook blocks destructive shell commands and adds context when dependency-related commands are detected.
