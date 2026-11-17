---
name: setup
description: Detects the project tracker and the versioning conventions, then writes the project rules to a versioned `WORKFLOW.md` at the repository root, imported by the `CLAUDE.md`, which also holds the tooling details. Invoke to initialize or reconfigure the workflow, when `WORKFLOW.md` is missing, or when it no longer matches the reality of the tools.
---

# setup

Discover once and for all how the project is run, and set the result in stone in the repository. Two goals: no session should ever again have to rediscover the statuses, the work item types or the branch conventions; and the configuration must be **versioned and replayable** — the same for everyone who develops on the project, and reproducible from one project to another.

## Location

Two files at the repository root, committed like everything else:

- **`WORKFLOW.md`** — the project rules, valid for anyone who develops on it, human or AI: the tracker and the ticket lifecycle, the language, the Git conventions, the documentation location, the repositories.
- **`CLAUDE.md`** — imports `WORKFLOW.md` with an `@WORKFLOW.md` line, and adds a **"Workflow tooling"** section reserved for tooling: access to the tool, identifiers, validated commands, non-working commands. A human goes through the tool's interface; these details only serve Claude.

Claude Code loads the `CLAUDE.md` in every session, and with it whatever it imports: the plugin's other skills find the configuration already in their context.

Never in the plugin directory: the skills are shared between projects, the configuration is specific to each one. **Never outside a repository** either: a file placed in a parent folder grouping several repositories is not versioned, and cannot be replayed.

### Multi-repository project

A single configuration for all the repositories. It lives in the **steering repository** — the one that holds the cross-cutting documentation. If it is not obvious, ask which one; create none.

Claude Code loads only the `CLAUDE.md` of the working directory and its parents. So add to the `CLAUDE.md` of **every other repository** a line that imports the steering repository's one — `@../<steering-repository>/CLAUDE.md` — without which a session opened in a code repository would ignore the rules. This import assumes the repositories are cloned side by side: record it in `WORKFLOW.md`. In the first session, Claude Code may ask to approve this import located outside the repository: that is expected.

## Process

### 1. Check what exists

If `WORKFLOW.md` already exists: read it, along with the "Workflow tooling" section of the `CLAUDE.md`, announce what they contain, and ask whether the user wants to **complete**, **re-probe** (refresh from the tool) or **abort**. Never overwrite them without approval.

If you find a **`.claude/workflow.md`** — the location used by earlier versions of the plugin — this is a migration. Split its content between `WORKFLOW.md` and the "Workflow tooling" section, without re-probing what it already establishes unless asked, and drop what has no place in a versioned file (see the rules). Once the new files are written, offer to delete the old one.

### 2. Find the existing documentation

Before any question, look for what the project already documents: `CLAUDE.md` (root, subdirectories, and the user's global one), `AGENTS.md`, `README.md`, `CONTRIBUTING.md`, `docs/`. Many project management rules and Git conventions are often already written there.

**Never duplicate this information.** When a rule is already documented in a file read by everyone — `README.md`, `CONTRIBUTING.md`, `docs/` — `WORKFLOW.md` merely **points to the file** — path and section — instead of copying its content. The existing documentation remains the source of truth; a copy would diverge at the first change.

**Exception: project rules written in a `CLAUDE.md` or an `AGENTS.md`.** Only the AI reads them. When they belong in `WORKFLOW.md` — Git conventions, language, ticket lifecycle — suggest **moving** them there, so that they apply to everyone; the `CLAUDE.md` keeps only what concerns tooling.

Copy a piece of information only if it exists nowhere, or if it is contradicted by what you probed — in that case point out the contradiction to the user and ask which version is authoritative.

### 3. Detect the project tracker

Look for clues before asking:

- git remote (`git -C <repo> remote -v`) → `dev.azure.com`/`visualstudio.com` = Azure DevOps, `github.com` = GitHub
- available CLIs: `az` + `azure-devops` extension, `gh`
- connected MCP servers exposing Jira/Azure/GitHub tools
- existing `.claude/tickets/` directory = local files mode

Announce the detected tool and have it **confirmed**. If nothing is detected or if several candidates coexist, ask — do not guess.

### 4. Probe the tool

Run the discovery commands from [PROBES.md](./PROBES.md) for the chosen tool. Probing is **read-only**: no create or modify command during the init.

What to bring back:

- the project's identity (organization, project, repo, board, area path, current iteration)
- the **actual hierarchy** of types (e.g. Epic → Feature → User Story → Task/Bug) as the tool names it
- the **exact statuses** of each type, with their exact spelling (`New`, `Active`, `Resolved`, `Closed`…)
- the **automations** that change a status on their own — closing a ticket, merging a pull request
- the **parent/child link** mechanism (Parent link, sub-issue, epic link, custom field)
- the **required fields** at creation
- the available labels / tags if they are used for sorting
- the **identifiers** the commands will need — project, status field, options

If a command fails (not authenticated, missing extension, insufficient permissions), say so explicitly, give the command to run to fix it, and continue with an interview on that part rather than inventing.

`PROBES.md` is only a starting point. Record in the "Workflow tooling" section of the `CLAUDE.md` any command from that file that turned out not to work (with the error and the variant used instead), as well as any command or API call missing from the list but needed by the project.

### 5. Complete with an interview

What cannot be probed, ask about. One question at a time, grouped by theme:

- **Transitions**: which status when a ticket is created, when a task starts, when the code is ready, at the end? What does each status mean — when does a ticket enter it? Who makes the final transition — you or the user?
- **Language**: in which language are the repository's artifacts written — specs, tickets, commits, documentation? First look for the rule in the `CLAUDE.md` or the `README` before asking; many projects have already settled it.
- **Steering repository** — only on a multi-repository project: which one holds the configuration and the cross-cutting documentation?
- **Target repository** — only if the tracker attaches tickets to a repository, like GitHub, **and** the project has several: which ticket type is created in which repository? On a repository-independent tracker or on a mono-repo, do not bring it up.
- **Documentation**: where do the specs, the `CONTEXT.md` and the ADRs live?
- **Git**: branching model, branch format, commit convention, merge/rebase strategy, integration branch.

Never present a value as given. If you have an assumption (drawn from the project's `CLAUDE.md`, for example), present it as an assumption to be confirmed.

### 6. Play it back before writing

Present a compact summary of what is going to be written: the content of `WORKFLOW.md`, that of the "Workflow tooling" section and, on a multi-repository project, the imports added in each repository. The user approves or corrects. **Only then** write, following [WORKFLOW-TEMPLATE.md](./WORKFLOW-TEMPLATE.md) and [CLAUDE-TEMPLATE.md](./CLAUDE-TEMPLATE.md).

An existing `CLAUDE.md` is not rewritten: add the import at the top and the "Workflow tooling" section at the end, and touch the rest only for the moves approved in step 2.

### 7. Confirm

List the files written or modified, repository by repository, and remind the user that they can be edited by hand — the skills of the `workflow` plugin will read them back as they are. **Propose the commit without making it**: the configuration is only shared once versioned, but it is up to the user to decide.

## Divergences between the documented workflow and the reality of the tools

This rule applies during the init **and at any time afterwards**: as soon as a gap is found between what `WORKFLOW.md`, the `CLAUDE.md` or the project's documentation describe and what the tool actually returns, point it out immediately instead of adapting silently.

Examples of gaps: a documented status that no longer exists, a renamed work item type, a moved area path or project, a field that has become required, a branch convention the repository no longer follows.

Procedure:

1. **Announce the gap** by showing both versions: what is documented (with the file and the section) and what is observed (with the command and its output).
2. **Propose a precise update** — the file to modify, the current line, the proposed line. If the gap concerns referenced documentation (`README.md`, `CONTRIBUTING.md`…), the update applies to that file, not to a copy in `WORKFLOW.md`.
3. **Wait for the user's approval.** They may decide the other way: it is the tool that is misconfigured, and the documentation that is authoritative.
4. **Apply the change only after approval.** Without an answer, continue the current task using the observed value and point out that the gap remains unresolved.

Never correct documentation on your own initiative, and never modify the tool's configuration to make it match the documentation.

## Rules

- **The project's `WORKFLOW.md`, `CLAUDE.md` and `README.md` are authoritative** on everything else: they override this skill's default behaviors, and a local rule is followed without debate. But when the contradiction is **strong** — a principle of the skill and a project rule that cannot both hold — stop, lay out both, and ask what should be updated: the project's documentation, or the skill itself when the rule is meant to apply everywhere.
- **Nothing invented.** A field whose value has been neither probed nor confirmed stays marked `TO BE DETERMINED` in the file rather than filled in by guesswork.
- **Exact spelling.** Status, type and field names are copied as the tool returns them, case included. A transition fails on a capital letter.
- **Read-only.** The init creates, modifies and closes no work item.
- **Zero duplication.** Any rule already written in a `README.md`, a `CONTRIBUTING.md` or a project doc is referenced by its path, not copied. Those in a `CLAUDE.md` or an `AGENTS.md` are moved into `WORKFLOW.md`, after approval.
- **Versioned and replayable.** Nothing that describes the project is written outside a repository. No machine-specific data in the files: no absolute path, no personal account, no local state (stash, current branch).
- **Only what is established.** The files describe what is established. A point still to be decided is raised in the conversation or becomes a ticket — never a list of open points in a versioned file.
- **Gaps reported, never absorbed.** A divergence between documentation and tool is reported and decided by the user.
- **Conciseness.** The `CLAUDE.md` and what it imports are loaded in every session: get to the point, no explanatory prose.
