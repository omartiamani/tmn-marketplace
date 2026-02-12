---
name: commit
description: Commit and push changes following conventions
invocation: /commit
---

# Commit Changes

Use the **committer** agent to commit and push changes.

## Usage

```
/commit [repo_name]
```

## Examples

```
/commit $PROJECT_NAME
/commit $PROJECT_NAME-api
/commit              # Auto-detect repo with changes
```

## What This Does

1. Analyzes staged/unstaged changes in the specified repo
2. Checks recent commits for Work Item context (feature_id.us_id)
3. If no context found, queries Azure DevOps for active Work Items
4. Creates a Conventional Commits formatted message
5. Stages, commits, and pushes changes

## Agent Instructions

Launch the **committer** agent with the repo name as context.

If repo is specified, focus on that repo.
If no repo specified, detect which repo has uncommitted changes.
