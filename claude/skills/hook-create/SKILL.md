---
name: hook-create
description: Create Claude Code hooks for automation. Use when asked to "create hook", "add automation", "auto-run on", or when deterministic behavior should always happen (formatting, validation, blocking).
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Hook Create

Create hooks for deterministic automation that LLMs might forget.

## When to Create a Hook

- Action must ALWAYS happen (format, lint, test)
- Need to block dangerous operations
- Want to inject context automatically
- Workflow integration with external tools

**Key Insight**: LLMs can forget; hooks never forget.

## Hook Events

| Event | When | Can Block? |
|-------|------|------------|
| `PreToolUse` | Before tool executes | Yes |
| `PostToolUse` | After tool succeeds | No |
| `UserPromptSubmit` | Before Claude processes | Yes |
| `SessionStart` | Session begins | No |
| `Stop` | Claude finishes responding | Yes |

## Configuration Location

```json
// .claude/settings.json (project)
// ~/.claude/settings.json (personal)
{
  "hooks": {
    "{EventName}": [
      {
        "matcher": "{regex}",
        "hooks": [
          {
            "type": "command",
            "command": "{script}"
          }
        ]
      }
    ]
  }
}
```

## Exit Codes

| Code | Meaning | Behavior |
|------|---------|----------|
| 0 | Success | Action proceeds |
| 2 | Block | Action blocked, stderr to Claude |
| Other | Warning | Action proceeds, stderr in verbose |

## Example: Block Dangerous Commands

**.claude/settings.json:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous.sh"
          }
        ]
      }
    ]
  }
}
```

**.claude/hooks/block-dangerous.sh:**
```bash
#!/bin/bash
COMMAND=$(jq -r '.tool_input.command' < /dev/stdin)

if echo "$COMMAND" | grep -qE 'rm -rf|sudo|chmod 777'; then
  echo "Blocked: Dangerous command" >&2
  exit 2
fi

exit 0
```

## Example: Auto-Format After Edit

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write \"$CLAUDE_TOOL_INPUT_FILE_PATH\""
          }
        ]
      }
    ]
  }
}
```

## Hook Types

| Type | Use Case |
|------|----------|
| `command` | Shell script execution |
| `prompt` | LLM evaluation (yes/no) |
| `agent` | Multi-turn verification |

## Checklist

Before creating:
- [ ] Must this ALWAYS happen?
- [ ] Is it deterministic (not judgment-based)?
- [ ] Keep it fast (especially SessionStart)
- [ ] Script handles errors gracefully?

Reference: @claude/hooks/README.md for detailed patterns.