# Claude Code Commands (Slash Commands) Guide

## 1. Core Concepts

**Commands** (slash commands) are user-invoked shortcuts that execute predefined prompts or workflows. They provide a way to trigger specific actions explicitly with `/command-name`.

> **Important**: Custom slash commands have been **merged into Skills**. Files at `.claude/commands/` and skills at `.claude/skills/` both create slash commands and work the same way. **Skills are recommended** as they support additional features like supporting files, frontmatter options, and Claude auto-invocation.

---

## 2. Commands vs Skills

| Feature | Commands (`.claude/commands/`) | Skills (`.claude/skills/`) |
|---------|-------------------------------|---------------------------|
| Creates `/name` shortcut | Yes | Yes |
| Supports frontmatter | Yes | Yes |
| Supporting files (scripts, references) | No | Yes |
| Claude auto-invocation | No | Yes |
| Directory structure | Single `.md` file | Folder with `SKILL.md` |
| **Recommendation** | Legacy support | **Preferred** |

If a command and skill share the same name, **the skill takes precedence**.

---

## 3. Command File Location

| Location | Scope | Shared With |
|----------|-------|-------------|
| `~/.claude/commands/<name>.md` | All your projects | Just you |
| `.claude/commands/<name>.md` | Current project | Team via version control |

---

## 4. Command Structure

### Basic Format

```markdown
---
description: Brief description shown in autocomplete
argument-hint: [filename] [options]
---

Your prompt instructions here.

Use $ARGUMENTS to include user input.
```

### Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `description` | Recommended | Shown in `/` autocomplete menu |
| `argument-hint` | No | Hint for expected arguments, e.g., `[filename]` |
| `allowed-tools` | No | Tools allowed without permission prompts |
| `disable-model-invocation` | No | If `true`, only user can invoke (default for commands) |

### Argument Substitution

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | All arguments passed after command name |
| `$ARGUMENTS[N]` or `$N` | Specific argument by 0-based index |
| `${CLAUDE_SESSION_ID}` | Current session ID |

---

## 5. Dynamic Context Injection

Use `` !`command` `` to inject shell command output into prompts:

```markdown
---
description: Review current changes
---

Review the following changes:

Git status:
!`git status`

Git diff:
!`git diff`

Provide feedback on code quality and potential issues.
```

The shell commands execute **before** the prompt is sent to Claude.

---

## 6. Template Examples

### Refactor Command

**.claude/commands/refactor.md:**
```markdown
---
description: Refactor a file following coding standards
argument-hint: [filename]
---

Refactor the following file: $ARGUMENTS

Follow these rules:
1. Convert to functional components with hooks
2. Add TypeScript types to all variables
3. Use try-catch for error handling
4. Follow naming conventions from @.claude/rules/code-style.md
```

**Usage:**
```
/refactor src/components/UserList.tsx
```

### Code Review Command

**.claude/commands/review.md:**
```markdown
---
description: Review code changes in current branch
---

Review the current code changes:

## Changed Files
!`git diff --name-only`

## Diff
!`git diff`

Focus on:
- Code quality and readability
- Potential bugs or edge cases
- Security considerations
- Performance implications

Provide specific, actionable feedback.
```

**Usage:**
```
/review
```

### Test Generator Command

**.claude/commands/test.md:**
```markdown
---
description: Generate tests for a file
argument-hint: [filename]
---

Generate comprehensive tests for: $ARGUMENTS

Requirements:
1. Use Jest and React Testing Library
2. Cover happy path and edge cases
3. Mock external dependencies
4. Follow testing conventions from @.claude/rules/testing.md
```

**Usage:**
```
/test src/utils/validation.ts
```

### Commit Command

**.claude/commands/commit.md:**
```markdown
---
description: Create a well-formatted commit
---

Create a commit for the current changes.

## Current Status
!`git status`

## Staged Changes
!`git diff --cached`

Follow commit conventions:
- Use conventional commit format (feat:, fix:, refactor:, etc.)
- Keep subject line under 50 characters
- Add body explaining "why" not "what"
```

**Usage:**
```
/commit
```

### Deploy Command (User-Controlled)

**.claude/commands/deploy.md:**
```markdown
---
description: Deploy to specified environment
argument-hint: [environment: staging|production]
---

Deploy to $ARGUMENTS environment.

## Pre-deployment Checks
!`npm test`
!`npm run build`

## Deployment Steps
1. Verify all tests pass
2. Build production bundle
3. Deploy to $ARGUMENTS
4. Verify deployment health
5. Report deployment status

CRITICAL: Confirm with user before executing deployment commands.
```

**Usage:**
```
/deploy staging
```

### Multi-Argument Command

**.claude/commands/migrate.md:**
```markdown
---
description: Migrate component from one framework to another
argument-hint: [component] [from] [to]
---

Migrate the $0 component from $1 to $2.

Steps:
1. Read the current $1 implementation
2. Understand the component's functionality
3. Rewrite using $2 patterns and conventions
4. Preserve all existing behavior
5. Update imports and dependencies
6. Add/update tests for the new implementation
```

**Usage:**
```
/migrate SearchBar React Vue
```

---

## 7. Best Practices

| Practice | Description |
|----------|-------------|
| **Explicit Control** | Use commands for actions with side effects (deploy, commit) |
| **Clear Descriptions** | Write helpful descriptions for autocomplete |
| **Dynamic Context** | Use `` !`command` `` to include relevant state |
| **Reference Rules** | Import coding standards with `@path/to/rules.md` |
| **Argument Hints** | Provide clear hints for expected arguments |
| **Migrate to Skills** | Consider converting to skills for more features |

### When to Use Commands vs Skills

**Use Commands when:**
- Simple, single-file shortcut
- No supporting files needed
- Quick migration from existing setup

**Use Skills when:**
- Need supporting files (scripts, references)
- Want Claude to auto-invoke based on context
- Building complex workflows
- Sharing with team or community

---

## 8. Migrating to Skills

Convert a command to a skill:

**Before (`.claude/commands/review.md`):**
```markdown
---
description: Review code changes
---

Review the current changes...
```

**After (`.claude/skills/review/SKILL.md`):**
```markdown
---
name: review
description: Review code changes. Use when asked to "review code", "check changes", or "look at my PR".
---

Review the current changes...
```

Benefits of migration:
- Claude can auto-invoke when relevant
- Add supporting files (scripts, references, templates)
- More configuration options
- Better organization for complex workflows

---

## References

- [Official Claude Code Skills Documentation](https://code.claude.com/docs/en/skills)
- [Claude Code Interactive Mode](https://code.claude.com/docs/en/interactive-mode)