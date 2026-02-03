# Claude Code Hooks Engineering Guide

## 1. Core Concepts

**Hooks** are user-defined shell commands or LLM prompts that execute automatically at specific points in Claude Code's lifecycle.

### Why Use Hooks?

| Benefit | Description |
|---------|-------------|
| **Deterministic Control** | Enforce rules that LLMs might forget |
| **Security Gates** | Block dangerous commands before execution |
| **Quality Automation** | Auto-format, lint, or test after file changes |
| **Workflow Integration** | Connect Claude to external tools and services |

**Key Insight**: LLMs can forget to run tests, but hooks never forget. Use hooks to enforce deterministic behavior that should always happen.

---

## 2. Hook Locations

Where you define a hook determines its scope:

| Location | Scope | Shareable |
|----------|-------|-----------|
| `~/.claude/settings.json` | All your projects | No, local to your machine |
| `.claude/settings.json` | Single project | Yes, can be committed to repo |
| `.claude/settings.local.json` | Single project | No, gitignored |
| Managed policy settings | Organization-wide | Yes, admin-controlled |
| Plugin `hooks/hooks.json` | When plugin is enabled | Yes, bundled with plugin |
| Skill or agent frontmatter | While component is active | Yes, defined in component file |

---

## 3. Hook Events

| Event | When It Fires | Can Block? |
|-------|---------------|------------|
| `SessionStart` | When a session begins or resumes | No |
| `UserPromptSubmit` | When user submits a prompt, before Claude processes it | Yes |
| `PreToolUse` | Before a tool call executes | Yes |
| `PermissionRequest` | When a permission dialog appears | Yes |
| `PostToolUse` | After a tool call succeeds | No |
| `PostToolUseFailure` | After a tool call fails | No |
| `Notification` | When Claude Code sends a notification | No |
| `SubagentStart` | When a subagent is spawned | No |
| `SubagentStop` | When a subagent finishes | Yes |
| `Stop` | When Claude finishes responding | Yes |
| `PreCompact` | Before context compaction | No |
| `SessionEnd` | When a session terminates | No |

---

## 4. Hook Configuration

### Basic Structure

```json
{
  "hooks": {
    "<EventName>": [
      {
        "matcher": "<regex pattern>",
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/script.sh"
          }
        ]
      }
    ]
  }
}
```

### Matcher Patterns

The `matcher` field is a regex that filters when hooks fire. Use `"*"`, `""`, or omit to match all.

| Event | What Matcher Filters | Example Values |
|-------|---------------------|----------------|
| `PreToolUse`, `PostToolUse`, `PostToolUseFailure`, `PermissionRequest` | Tool name | `Bash`, `Edit\|Write`, `mcp__.*` |
| `SessionStart` | How session started | `startup`, `resume`, `clear`, `compact` |
| `SessionEnd` | Why session ended | `clear`, `logout`, `prompt_input_exit`, `other` |
| `Notification` | Notification type | `permission_prompt`, `idle_prompt` |
| `SubagentStart`, `SubagentStop` | Agent type | `Bash`, `Explore`, `Plan`, custom names |
| `PreCompact` | What triggered | `manual`, `auto` |
| `UserPromptSubmit`, `Stop` | No matcher support | Always fires |

### Hook Handler Types

| Type | Description |
|------|-------------|
| `command` | Run a shell command. Input via stdin, output via exit code + stdout |
| `prompt` | Single-turn LLM evaluation. Returns yes/no decision |
| `agent` | Multi-turn subagent with tool access for complex verification |

---

## 5. Hook Handler Fields

### Common Fields (All Types)

| Field | Required | Description |
|-------|----------|-------------|
| `type` | Yes | `"command"`, `"prompt"`, or `"agent"` |
| `timeout` | No | Seconds before canceling. Defaults: 600 (command), 30 (prompt), 60 (agent) |
| `statusMessage` | No | Custom spinner message while hook runs |
| `once` | No | If `true`, runs only once per session (skills only) |

### Command Hook Fields

| Field | Required | Description |
|-------|----------|-------------|
| `command` | Yes | Shell command to execute |
| `async` | No | If `true`, runs in background without blocking |

### Prompt/Agent Hook Fields

| Field | Required | Description |
|-------|----------|-------------|
| `prompt` | Yes | Prompt text. Use `$ARGUMENTS` for hook input JSON |
| `model` | No | Model to use. Defaults to fast model |

---

## 6. Exit Code Behavior

| Exit Code | Meaning | Behavior |
|-----------|---------|----------|
| **0** | Success | Parse stdout for JSON output. Action proceeds |
| **2** | Blocking error | Block the action. stderr fed to Claude as error |
| **Other** | Non-blocking error | stderr shown in verbose mode. Action proceeds |

### Exit Code 2 Per Event

| Event | What Happens on Exit 2 |
|-------|----------------------|
| `PreToolUse` | Blocks the tool call |
| `PermissionRequest` | Denies the permission |
| `UserPromptSubmit` | Blocks prompt processing, erases prompt |
| `Stop` | Prevents Claude from stopping, continues conversation |
| `SubagentStop` | Prevents subagent from stopping |
| `PostToolUse`, `PostToolUseFailure` | Shows stderr to Claude (already ran) |
| Others | Shows stderr to user only |

---

## 7. JSON Output

Exit 0 and print JSON to stdout for structured control:

### Universal Fields

| Field | Default | Description |
|-------|---------|-------------|
| `continue` | `true` | If `false`, Claude stops entirely |
| `stopReason` | none | Message shown to user when `continue` is `false` |
| `suppressOutput` | `false` | If `true`, hides stdout from verbose mode |
| `systemMessage` | none | Warning message shown to user |

### Decision Control by Event

| Events | Pattern | Key Fields |
|--------|---------|------------|
| UserPromptSubmit, PostToolUse, Stop, SubagentStop | Top-level `decision` | `decision: "block"`, `reason` |
| PreToolUse | `hookSpecificOutput` | `permissionDecision` (allow/deny/ask), `permissionDecisionReason` |
| PermissionRequest | `hookSpecificOutput` | `decision.behavior` (allow/deny) |

---

## 8. Common Input Fields

All hooks receive these fields via stdin as JSON:

| Field | Description |
|-------|-------------|
| `session_id` | Current session identifier |
| `transcript_path` | Path to conversation JSON |
| `cwd` | Current working directory |
| `permission_mode` | Current permission mode |
| `hook_event_name` | Name of the event that fired |

---

## 9. Template Examples

### Block Dangerous Commands (PreToolUse)

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

# Block dangerous patterns
if echo "$COMMAND" | grep -qE 'rm -rf|sudo|chmod 777|>/dev/'; then
  echo "Blocked: Potentially dangerous command" >&2
  exit 2
fi

exit 0
```

### Auto-Format After File Changes (PostToolUse)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write \"$CLAUDE_PROJECT_DIR\""
          }
        ]
      }
    ]
  }
}
```

### Run Tests in Background (Async Hook)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "npm test",
            "async": true,
            "timeout": 300
          }
        ]
      }
    ]
  }
}
```

### Validate Stop Conditions (Prompt Hook)

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Evaluate if Claude should stop: $ARGUMENTS. Check if all tasks are complete. Respond with JSON: {\"ok\": true} to allow stopping, or {\"ok\": false, \"reason\": \"explanation\"} to continue.",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### Load Context on Session Start

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/load-context.sh"
          }
        ]
      }
    ]
  }
}
```

**.claude/hooks/load-context.sh:**
```bash
#!/bin/bash
# Output becomes context for Claude
echo "Recent git changes:"
git log --oneline -5 2>/dev/null || echo "Not a git repository"

echo ""
echo "Open issues:"
gh issue list --limit 3 2>/dev/null || echo "GitHub CLI not available"

exit 0
```

### Persist Environment Variables (SessionStart)

```bash
#!/bin/bash
# SessionStart hooks can write to CLAUDE_ENV_FILE

if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo 'export NODE_ENV=development' >> "$CLAUDE_ENV_FILE"
  echo 'export DEBUG=true' >> "$CLAUDE_ENV_FILE"
fi

exit 0
```

---

## 10. Hooks in Skills and Agents

Hooks can be defined in skill/agent frontmatter, scoped to component lifecycle:

```yaml
---
name: secure-operations
description: Perform operations with security checks
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/security-check.sh"
  PostToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: "./scripts/run-linter.sh"
---
```

> **Note**: For agents, `Stop` hooks in frontmatter are automatically converted to `SubagentStop`.

---

## 11. MCP Tool Hooks

MCP tools appear as `mcp__<server>__<tool>` in tool events:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "mcp__memory__.*",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Memory operation' >> ~/mcp.log"
          }
        ]
      }
    ]
  }
}
```

---

## 12. Managing Hooks

### `/hooks` Command

Type `/hooks` in Claude Code to:
- View all hooks (labeled by source: User, Project, Local, Plugin)
- Add new hooks interactively
- Delete existing hooks
- Toggle all hooks on/off

### Disable Hooks

- **Temporarily disable all**: Set `"disableAllHooks": true` in settings
- **Remove individual**: Delete from settings JSON or use `/hooks` menu

> **Note**: Hook changes require session restart. Claude Code captures a snapshot at startup.

---

## 13. Debugging

Run `claude --debug` to see hook execution details:

```
[DEBUG] Executing hooks for PostToolUse:Write
[DEBUG] Found 1 hook commands to execute
[DEBUG] Hook command completed with status 0: <output>
```

Toggle verbose mode with `Ctrl+O` to see hook progress in transcript.

---

## 14. Security Considerations

**Hooks run with your full user permissions.**

### Best Practices

| Practice | Description |
|----------|-------------|
| **Validate inputs** | Never trust input data blindly |
| **Quote shell variables** | Use `"$VAR"` not `$VAR` |
| **Block path traversal** | Check for `..` in file paths |
| **Use absolute paths** | Specify full paths, use `"$CLAUDE_PROJECT_DIR"` |
| **Skip sensitive files** | Avoid `.env`, `.git/`, keys |

---

## 15. Best Practices Summary

| Practice | Description |
|----------|-------------|
| **Deterministic Control** | Use hooks for rules that must always execute (tests, formatting) |
| **Exit Code 2** | Return exit code 2 to block actions and provide feedback |
| **Async for Long Tasks** | Use `async: true` for tests/deployments to avoid blocking |
| **Scope Appropriately** | Use project hooks for team rules, user hooks for personal preferences |
| **Keep Hooks Fast** | Especially SessionStart hooks that run on every session |

---

## References

- [Official Claude Code Hooks Reference](https://code.claude.com/docs/en/hooks)
- [Automate Workflows with Hooks Guide](https://code.claude.com/docs/en/hooks-guide)
- [Claude Code Settings Documentation](https://code.claude.com/docs/en/settings)