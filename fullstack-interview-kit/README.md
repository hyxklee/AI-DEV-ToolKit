# Fullstack Interview Kit

A portable development-assistant kit for full-stack live coding interviews.

The default is not a project-specific architecture. The default is:

- inspect the target project first
- capture interview requirements into a local context file
- generate project-specific rules from the target repository
- follow the target project's existing conventions
- build the smallest high-quality vertical slice
- verify with the narrowest useful command

Primary target stack:

- Backend: Kotlin, Spring Boot, JPA, Gradle
- Frontend: React, TypeScript, Node.js
- Tools: Claude Code, Codex, ChatGPT, Gemini

## Recommended Use

Copy the kit contents into the interview project root:

```bash
cp -R fullstack-interview-kit/. /path/to/interview-project/
```

Then run the AI tool from the interview project root:

```bash
cd /path/to/interview-project
claude
```

or:

```bash
cd /path/to/interview-project
codex
```

Start every interview with the setup command:

```text
/setup <paste the interview task, constraints, time limit, required stack, and evaluation rules>
```

The setup command creates or updates `.interview-context.md` and `.interview-rules.md`. Later commands read those files so task-specific requirements and project-specific conventions keep shaping the implementation.

### Use As A Prompt Pack

If only ChatGPT or Gemini is available, paste these files in order:

1. `prompts/00-fullstack-live-coding.md`
2. `prompts/01-backend-kotlin-spring.md`
3. `prompts/02-frontend-react-ts.md`

Use `prompts/03-debugging.md` when something fails.
Use `prompts/04-final-review.md` before submitting.

## What Is Included

```text
AGENTS.md
CLAUDE.md
.interview-context template in templates/
.claude/skills/fullstack-interview/SKILL.md
.claude/skills/interview-context-sync/SKILL.md
.claude/commands/
.claude/rules/README.md
.claude/hooks/
.claude/settings.json
.codex/skills/fullstack-interview/SKILL.md
.codex/skills/interview-context-sync/SKILL.md
.codex/skills/live-coding/SKILL.md
.codex/commands/
.codex/rules/README.md
.codex-plugin/plugin.json
prompts/
checklist/
templates/
scripts/
```

## Command Workflow

Use this routine in the interview:

1. `/setup` to capture requirements, project layout, project rules, commands, and constraints.
2. `/analyze` to structure requirements and edge cases.
3. `/plan` to choose 3 or fewer implementation steps.
4. `/implement-step` to make one small change.
5. `/test-cases` to decide what to verify.
6. `/review` to find gaps before submission.
7. `/explain` to prepare the spoken summary.

Commands are mirrored under `.claude/commands/` and `.codex/commands/`.

## Design Principle

The kit does not ship static project rules. `/setup` extracts the target project's actual conventions into `.interview-rules.md`. If the target project already has `UseCase`, `CommonResponse`, `BaseException`, custom error codes, TanStack Query, or any other project-specific utilities, reuse them. If it does not, use the simplest idiomatic project pattern.

## Scripts

- `scripts/check.sh`: runs available backend and/or frontend lint/build checks.
- `scripts/test.sh`: runs available backend and/or frontend tests, optionally with a target pattern.

## Interview Rule

Build the smallest working vertical slice first. Keep the implementation explainable, keep the UI usable, and verify the end-to-end flow before polishing.
