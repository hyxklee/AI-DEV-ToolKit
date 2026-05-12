# CLAUDE.md

This file is the Claude Code wrapper for this full-stack live coding interview kit.

`AGENTS.md` is the canonical source for shared rules. Follow `AGENTS.md` first for stack, required reading, backend rules, frontend rules, and verification.

## First Command

Start with:

```text
/setup <paste the interview task, constraints, time limit, required stack, and evaluation rules>
```

The setup command creates or updates `.interview-context.md` and `.interview-rules.md`. Read both before analysis, planning, implementation, review, or explanation.

## Primary Skill

Use `.claude/skills/interview-context-sync/SKILL.md` first when the prompt contains interview/live-coding intent or switches mode.

Use `.claude/skills/fullstack-interview/SKILL.md` when the user asks for:

- live coding interview help
- full-stack feature implementation
- Kotlin Spring backend implementation
- React TypeScript frontend implementation
- debugging interview code
- final review before submission

## Claude Code Workflow

1. Read `AGENTS.md`.
2. Run `/setup` when `.interview-context.md` or `.interview-rules.md` is missing, or when the task changes.
3. Invoke or follow `.claude/skills/interview-context-sync/SKILL.md`.
4. Invoke or follow `.claude/skills/fullstack-interview/SKILL.md` when implementation begins.
5. Read the prompt and rule files selected by context sync.
6. Prefer the command routine: `/setup`, `/analyze`, `/plan`, `/implement-step`, `/test-cases`, `/review`, `/explain`.
7. Execute one small step at a time.
8. Keep the final answer concise and include verification.

## Override Rule

If this file conflicts with `AGENTS.md`, prefer `AGENTS.md` unless the difference is specifically about Claude Code skill invocation.
