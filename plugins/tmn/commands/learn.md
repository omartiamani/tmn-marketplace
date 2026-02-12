---
name: learn
description: Capture lessons learned from session errors and update configurations
invocation: /learn
---

# Learn from Session Errors

Use the **session-learner** agent to analyze errors from the current session and prevent their recurrence.

## Usage

```
/learn [description of error or "session summary"]
```

## Examples

```
/learn You kept using npm instead of bun
/learn session summary
/learn The tests were too coupled to implementation
```

## What This Does

1. Analyzes the described error(s) or reviews session patterns
2. Identifies root causes and appropriate fix locations
3. Proposes updates to CLAUDE.md, skills, or agents
4. Applies changes after user approval

## Agent Instructions

Launch the **session-learner** agent with the user's input as context.

If the user provided a specific error description, focus on that error.
If the user requested a "session summary", analyze the full conversation for patterns.
