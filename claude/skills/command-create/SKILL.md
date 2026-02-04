---
name: command-create
description: Create Claude Code slash commands. Use when asked to "create command", "new command", "add slash command", or when a user-triggered action with side effects needs explicit control.
allowed-tools: Read, Write, Glob, Grep
---

# Command Create

Create slash commands for user-triggered actions.

## When to Create a Command

- Action has side effects (deploy, commit, publish)
- User should explicitly trigger (not auto-invoke)
- Simple single-file shortcut
- No supporting scripts needed

**Note**: For complex workflows, use skill-create instead.

## File Location

```
.claude/commands/{command-name}.md    # Project scope
~/.claude/commands/{command-name}.md  # Personal scope
```

## Command Structure

```markdown
---
description: {Brief description for autocomplete}
argument-hint: [{arg1}] [{arg2}]
allowed-tools: Bash, Write
---

{Prompt instructions}

Use $ARGUMENTS for user input.
Use !`command` for dynamic context injection.
```

## Argument Substitution

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | All arguments |
| `$0`, `$1`, `$2` | Specific argument by index |
| `${CLAUDE_SESSION_ID}` | Session ID |

## Dynamic Context

Inject shell output before prompt is sent:

```markdown
Current branch: !`git branch --show-current`
Changed files: !`git diff --name-only`
```

## Example

Creating a `/release` command:

```markdown
---
description: Create a new release tag
argument-hint: [version]
---

Create release $ARGUMENTS:

## Current State
!`git log --oneline -5`
!`git status`

## Steps
1. Verify all tests pass
2. Update version in package.json
3. Create git tag v$ARGUMENTS
4. Push tag to remote

CRITICAL: Confirm with user before pushing.
```

Usage: `/release 1.2.0`

## Checklist

Before creating:
- [ ] Has side effects? (If no, consider skill instead)
- [ ] User should control timing?
- [ ] Single file sufficient? (If no, use skill)
- [ ] Similar command exists? Check `.claude/commands/`

Reference: @claude/commands/README.md for detailed patterns.