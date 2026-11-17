# Probing commands (read-only)

This file is a **starting point**, not an exhaustive or guaranteed reference: CLIs and APIs evolve, and each organization exposes fields and endpoints of its own.

Rule: **record in the "Workflow tooling" section of the `CLAUDE.md` only a command you have actually run successfully.** If a command fails or does not exist in the installed version, look for the equivalent, then failing that switch to an interview on that point.

Two cases to record systematically in that section's "Reference commands", so that no later session redoes the discovery:

- **a command from here that does not work** — record it as non-working, with the error obtained and the variant that worked in its place;
- **a command missing from here but needed** — record it as you validated it (WIQL query, REST endpoint, MCP call, custom field…).

Do not modify this file to record these discoveries: they are specific to the project and go into its `CLAUDE.md`.

## Azure DevOps Boards

Prerequisites: `az` + `azure-devops` extension, authenticated (`az login`, `az devops login`).

```bash
az devops configure --list                       # default org/project
az devops project list -o table
az boards area project list --project <PROJ> -o table
az boards iteration project list --project <PROJ> -o table
az boards work-item relation list-type -o table  # link types (Parent/Child…)
# Work item types of the process
az devops invoke --area wit --resource workitemtypes \
  --route-parameters project=<PROJ> --api-version 7.1 -o json
# Statuses of a given type
az devops invoke --area wit --resource states \
  --route-parameters project=<PROJ> type=<TYPE> --api-version 7.1 -o json
# Fallback: read a real work item and observe its fields/state
az boards work-item show --id <ID> -o json
```

## GitHub Issues / Projects

Prerequisites: `gh` authenticated (`gh auth status`).

```bash
gh repo view <owner>/<repo> --json name,defaultBranchRef,hasIssuesEnabled
gh label list --repo <owner>/<repo>
gh project list --owner <owner>
gh project field-list <number> --owner <owner>   # Status field and its options
gh issue list --repo <owner>/<repo> --limit 5 --json number,title,labels,state
# Sub-issues (native parent/child relationship)
gh api repos/<owner>/<repo>/issues/<n>/sub_issues
```

Note: GitHub has only two native states (`open`/`closed`). The real lifecycle comes from the **Status** field of a Project v2 or from labels — probe `field-list` and note the exact options.

## Jira

No official CLI installed. Use, in this order: a connected Jira MCP server, otherwise the REST API with the credentials provided by the user (never ask for a token in plain text in the conversation — ask for an environment variable that is already set).

```bash
: "${JIRA_URL:?}" "${JIRA_USER:?}" "${JIRA_TOKEN:?}"
curl -su "$JIRA_USER:$JIRA_TOKEN" "$JIRA_URL/rest/api/3/project/search"
curl -su "$JIRA_USER:$JIRA_TOKEN" "$JIRA_URL/rest/api/3/issuetype"
curl -su "$JIRA_USER:$JIRA_TOKEN" "$JIRA_URL/rest/api/3/status"
curl -su "$JIRA_USER:$JIRA_TOKEN" "$JIRA_URL/rest/api/3/issue/<KEY>/transitions"
```

## Local files

Nothing to probe. Establish the convention with the user and record it:

- one file per ticket under `.claude/tickets/<ID>-<slug>.md`
- identifier, type, status, parent in YAML frontmatter
- default statuses: `todo`, `in-progress`, `review`, `done`
- parent/child link: `parent:` field referencing the parent's identifier
