# Claude Code Subagent Engineering Guide

## 1. Core Concepts

Subagents are specialized AI assistants that handle specific types of tasks. Each subagent runs in its **own isolated context window** with a custom system prompt, specific tool access, and independent permissions.

### Why Use Subagents?

| Benefit | Description |
|---------|-------------|
| **Context Preservation** | Keep exploration and implementation out of your main conversation |
| **Cost Control** | Route simple tasks to faster, cheaper models like Haiku |
| **Permission Sandboxing** | Limit which tools a subagent can use for security |
| **Specialized Behavior** | Focused system prompts for specific domains |
| **Reusable Configurations** | Share subagents across projects with user-level definitions |

---

## 2. Built-in Subagents

Claude Code includes built-in subagents that Claude automatically uses when appropriate:

| Agent | Model | Tools | Purpose |
|-------|-------|-------|---------|
| **Explore** | Haiku | Read-only | File discovery, code search, codebase exploration |
| **Plan** | Inherits | Read-only | Codebase research for planning mode |
| **General-purpose** | Inherits | All tools | Complex research, multi-step operations |
| **Bash** | Inherits | Bash | Running terminal commands in separate context |
| **Claude Code Guide** | Haiku | Read-only | Questions about Claude Code features |

---

## 3. Subagent Scopes & Locations

Subagent definition file location determines its scope. When multiple subagents share the same name, higher-priority location wins.

| Priority | Scope | Location | Use Case |
|----------|-------|----------|----------|
| 1 (Highest) | Session (CLI) | `--agents` flag | One-time testing, CI/CD automation |
| 2 | Project | `.claude/agents/` | **[Recommended]** Team collaboration, version control |
| 3 | User | `~/.claude/agents/` | Personal tools available in all projects |
| 4 (Lowest) | Plugin | Plugin's `agents/` directory | External plugin-provided agents |

---

## 4. Frontmatter Configuration

Subagent files use YAML frontmatter for configuration, followed by the system prompt in Markdown.

### Supported Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier using lowercase letters and hyphens |
| `description` | Yes | When Claude should delegate to this subagent |
| `tools` | No | Tools the subagent can use. Inherits all tools if omitted |
| `disallowedTools` | No | Tools to deny, removed from inherited or specified list |
| `model` | No | Model to use: `sonnet`, `opus`, `haiku`, or `inherit` (default) |
| `permissionMode` | No | Permission mode (see below) |
| `skills` | No | Skills to preload into the subagent's context at startup |
| `hooks` | No | Lifecycle hooks scoped to this subagent |

### Permission Modes

| Mode | Behavior |
|------|----------|
| `default` | Standard permission checking with prompts |
| `acceptEdits` | Auto-accept file edits |
| `dontAsk` | Auto-deny permission prompts (explicitly allowed tools still work) |
| `bypassPermissions` | Skip all permission checks (use with caution) |
| `plan` | Plan mode (read-only exploration) |

### Model Options

| Option | Description |
|--------|-------------|
| `sonnet` | Balanced capability and speed |
| `opus` | Highest capability for complex tasks |
| `haiku` | Fast and low-cost for simple tasks |
| `inherit` | Use the same model as the main conversation (default) |

---

## 5. Template Examples

### Security Auditor (Read-Only Analysis)

```markdown
---
name: security-auditor
description: Analyzes codebase for security vulnerabilities. Use when asked to "check security" or "find vulnerabilities". Recommended to run in background to avoid main context pollution.
tools: Read, Grep, Glob, Bash
disallowedTools: Edit, Write
model: sonnet
permissionMode: default
skills:
  - security-guidelines
  - owasp-checklist
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/audit-safety-check.sh"
---

You are a senior security engineer.
Follow these steps based on the user's request:

1. Reference the `security-guidelines` skill loaded via `skills` to understand company security standards.
2. Use `grep` to search for hardcoded passwords or API key patterns.
3. Report discovered vulnerabilities in summary form; do not attempt to modify actual code.

This agent runs in an isolated context. Do not return lengthy log data to the main session; return only a **summary** of results.
```

### Code Reviewer (Read-Only with Proactive Use)

```markdown
---
name: code-reviewer
description: Expert code review specialist. Proactively reviews code for quality, security, and maintainability. Use immediately after writing or modifying code.
tools: Read, Grep, Glob, Bash
model: inherit
---

You are a senior code reviewer ensuring high standards of code quality and security.

When invoked:
1. Run git diff to see recent changes
2. Focus on modified files
3. Begin review immediately

Review checklist:
- Code is clear and readable
- Functions and variables are well-named
- No duplicated code
- Proper error handling
- No exposed secrets or API keys
- Input validation implemented
- Good test coverage
- Performance considerations addressed

Provide feedback organized by priority:
- Critical issues (must fix)
- Warnings (should fix)
- Suggestions (consider improving)

Include specific examples of how to fix issues.
```

### Debugger (With Edit Permissions)

```markdown
---
name: debugger
description: Debugging specialist for errors, test failures, and unexpected behavior. Use proactively when encountering any issues.
tools: Read, Edit, Bash, Grep, Glob
---

You are an expert debugger specializing in root cause analysis.

When invoked:
1. Capture error message and stack trace
2. Identify reproduction steps
3. Isolate the failure location
4. Implement minimal fix
5. Verify solution works

Debugging process:
- Analyze error messages and logs
- Check recent code changes
- Form and test hypotheses
- Add strategic debug logging
- Inspect variable states

For each issue, provide:
- Root cause explanation
- Evidence supporting the diagnosis
- Specific code fix
- Testing approach
- Prevention recommendations

Focus on fixing the underlying issue, not the symptoms.
```

### Database Query Validator (With Hook Validation)

```markdown
---
name: db-reader
description: Execute read-only database queries. Use when analyzing data or generating reports.
tools: Bash
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-readonly-query.sh"
---

You are a database analyst with read-only access. Execute SELECT queries to answer questions about the data.

When asked to analyze data:
1. Identify which tables contain the relevant data
2. Write efficient SELECT queries with appropriate filters
3. Present results clearly with context

You cannot modify data. If asked to INSERT, UPDATE, DELETE, or modify schema, explain that you only have read access.
```

---

## 6. Execution Patterns

### A. Foreground vs Background Execution

| Mode | Behavior |
|------|----------|
| **Foreground** | Blocks main conversation until complete. Permission prompts passed through to user. |
| **Background** | Runs concurrently. Permissions requested upfront before launch. Auto-denies unapproved requests. |

**How to run in background:**
- Ask Claude: "Run this in the background"
- Press **Ctrl+B** to background a running task

### B. Resuming Subagents

Subagents can be resumed to continue previous work with full context preserved:

```
User: Use the code-reviewer subagent to review the authentication module
[Agent completes]

User: Continue that code review and now analyze the authorization logic
[Claude resumes the subagent with full context from previous conversation]
```

Each subagent invocation creates a new instance by default. To continue existing work, explicitly ask Claude to resume.

### C. Parallel Execution

For independent investigations, spawn multiple subagents simultaneously:

```
Research the authentication, database, and API modules in parallel using separate subagents
```

### D. Chaining Subagents

For multi-step workflows, use subagents in sequence:

```
Use the code-reviewer subagent to find performance issues, then use the optimizer subagent to fix them
```

---

## 7. Subagent-Scoped Hooks

Define hooks directly in the subagent's frontmatter. These hooks only run while that specific subagent is active.

### Supported Hook Events

| Event | Matcher Input | When It Fires |
|-------|---------------|---------------|
| `PreToolUse` | Tool name | Before the subagent uses a tool |
| `PostToolUse` | Tool name | After the subagent uses a tool |
| `Stop` | (none) | When the subagent finishes |

### Example: Validate Commands and Run Linter

```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-command.sh"
  PostToolUse:
    - matcher: "Edit|Write"
      hooks:
        - type: command
          command: "./scripts/run-linter.sh"
```

### Project-Level Hooks (settings.json)

| Event | Matcher Input | When It Fires |
|-------|---------------|---------------|
| `SubagentStart` | Agent type name | When a subagent begins execution |
| `SubagentStop` | (none) | When any subagent completes |

---

## 8. Disabling Specific Subagents

Add subagents to the `deny` array in settings to prevent Claude from using them:

```json
{
  "permissions": {
    "deny": ["Task(Explore)", "Task(my-custom-agent)"]
  }
}
```

Or use the CLI flag:

```bash
claude --disallowedTools "Task(Explore)"
```

---

## 9. Best Practices Summary

| Practice | Description |
|----------|-------------|
| **Explicit Skill Injection** | Subagents start with a blank slate. Add required domain knowledge via the `skills` field. |
| **Minimize Permissions** | Use `disallowedTools` to prevent accidental code modifications (especially for exploration agents). |
| **Isolate Verbose Operations** | Delegate test runs, doc searches, and log analysis to subagents to keep main context clean. |
| **Write Clear Descriptions** | Claude uses the `description` field to decide when to delegate. Include trigger phrases. |
| **Design Focused Subagents** | Each subagent should excel at one specific task. |
| **Version Control Project Subagents** | Check `.claude/agents/` into git so your team can use and improve them collaboratively. |

---

## 10. When to Use Subagents vs Main Conversation

### Use Main Conversation When:
- Task needs frequent back-and-forth or iterative refinement
- Multiple phases share significant context (planning → implementation → testing)
- Making a quick, targeted change
- Latency matters (subagents start fresh and may need time to gather context)

### Use Subagents When:
- Task produces verbose output you don't need in main context
- You want to enforce specific tool restrictions or permissions
- Work is self-contained and can return a summary

### Consider Skills Instead When:
- You want reusable prompts or workflows that run in the main conversation context rather than isolated subagent context

> **Note:** Subagents cannot spawn other subagents. If your workflow requires nested delegation, use Skills or chain subagents from the main conversation.

---

## References

- [Official Claude Code Subagents Documentation](https://code.claude.com/docs/en/sub-agents)
- [Claude Code Skills Documentation](https://code.claude.com/docs/en/skills)
- [Claude Code Hooks Documentation](https://code.claude.com/docs/en/hooks)
- [Claude Code Plugins Documentation](https://code.claude.com/docs/en/plugins)