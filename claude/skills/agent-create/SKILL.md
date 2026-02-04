---
name: agent-create
description: Create new Claude Code agents. Use when asked to "create agent", "new agent", "add agent", or when a complex multi-step task pattern is identified that could be automated.
allowed-tools: Read, Write, Glob, Grep
---

# Agent Create

Create specialized Claude Code agents for complex, multi-step tasks.

## When to Create an Agent

- Task requires multi-step workflow with decision points
- Needs specialized domain knowledge
- Would benefit from tool access control (autoApprove)
- Pattern repeats across projects

## File Location

```
claude/agents/{agent-name}.md
```

Naming: kebab-case, descriptive (e.g., `code-review-agent.md`, `debugger-agent.md`)

## Agent Structure

```markdown
---
name: {agent-name}
autoApprove:
  - Read
  - Grep
  - Glob
---

# {Agent Name}

## Purpose
{One-line description of what this agent does}

## When to Use
{Specific scenarios that trigger this agent}

## Workflow

### Step 1: {Phase Name}
{What to do and why}

### Step 2: {Phase Name}
{Continue workflow...}

## Decision Framework
{How to make choices during execution}

## Output Format
{Expected deliverable structure}
```

## Example

Creating a "test-coverage-agent":

```markdown
---
name: test-coverage-agent
autoApprove:
  - Read
  - Grep
  - Glob
  - Bash
---

# Test Coverage Agent

## Purpose
Analyze and improve test coverage for a codebase.

## When to Use
- Before major releases
- After significant refactoring
- When test coverage drops below threshold

## Workflow

### Step 1: Analyze Current Coverage
Run coverage tool and identify gaps.

### Step 2: Prioritize
Rank uncovered code by:
1. Business criticality
2. Complexity
3. Change frequency

### Step 3: Generate Tests
Create tests for highest priority gaps.

## Output Format
- Coverage report summary
- List of generated test files
- Remaining gaps with recommendations
```

## Checklist

Before creating:
- [ ] Is this a multi-step task? (Not just a single action)
- [ ] Does it need specialized workflow?
- [ ] Will it be reused?
- [ ] Does similar agent already exist? Check `claude/agents/`

Reference: @claude/agents/README.md for detailed patterns.
