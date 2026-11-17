# Template for the `CLAUDE.md` additions

The repository's `CLAUDE.md` receives two additions, and the rest does not change:

1. **at the top**, the import of the project rules: `@WORKFLOW.md`;
2. **at the end**, the "Workflow tooling" section below.

If it does not exist, create it with these two elements only.

Same rules as for `WORKFLOW.md`: language of the project's artifacts, unconfirmed values marked `TO BE DETERMINED`, no machine-specific data — no absolute path, no personal account.

If a section does not apply — a tool without identifiers, no non-working commands — delete it.

---

````markdown
@WORKFLOW.md

<existing content of the CLAUDE.md, unchanged>

## Workflow tooling

Tooling for the workflow described in `WORKFLOW.md`, for Claude's use.

### Access

- **Tool**: `az boards` CLI | `gh` CLI | MCP <server name> | `.claude/tickets/` directory
- **Authentication**: <mechanism, and environment specifics — variable to re-export, file to source>

### Identifiers

| Item | Identifier |
| ---- | ---------- |
| ...  | ...        |

### AI-specific rules

- **Status changes**: automatic | on explicit confirmation from the user

### Reference commands

Commands actually run successfully, to be reused as they are. Complete this section every time a new command or a new API call is validated during the project.

```bash
# Read a work item
<command>
# Create a work item
<command>
# Change the status
<command>
# Link a child to its parent
<command>
```

### Non-working commands

Variants tried that do not work here — not to be retried except as a last resort.

| Command | Error | Variant used instead |
| ------- | ----- | -------------------- |
| ...     | ...   | ...                  |
````

---

## Other repositories of a multi-repository project

Their `CLAUDE.md` receives a single line, at the top, which imports the steering repository's one:

```markdown
@../<steering-repository>/CLAUDE.md
```

No "Workflow tooling" section and no `WORKFLOW.md` in these repositories: the import brings them in.
