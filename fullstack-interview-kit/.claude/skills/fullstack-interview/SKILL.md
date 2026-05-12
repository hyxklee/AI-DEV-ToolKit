---
name: fullstack-interview
description: Full-stack live coding interview workflow. Use when preparing for or executing live coding interviews, building a vertical slice, debugging interview code, or doing final review.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Fullstack Interview

Use this as the implementation-stage skill.

## Required Reading

1. `.interview-context.md` when it exists
2. `.interview-rules.md` when it exists
3. `prompts/00-fullstack-live-coding.md`
4. `checklist/live-coding-flow.md`
5. Backend/frontend/debug/review prompts only when those modes apply

Run `/setup` first when `.interview-context.md` or `.interview-rules.md` is missing, or when the task changes.

## Workflow

1. Decide the time tier.
2. Frame the smallest vertical slice.
3. Define the API contract before frontend work.
4. Implement one small step at a time.
5. Verify with the narrowest command or manual checklist.
6. Prepare a short explanation.

## Anti-Patterns

- Inventing project-specific utilities or architecture that the target project does not use.
- Adding extra layers during Sprint/Core when nearby code is simpler.
- Writing tests in Sprint tier unless the prompt explicitly requires them.
- Adding dependencies without explicit approval.

Match the user's prompt language. Code identifiers stay English.
