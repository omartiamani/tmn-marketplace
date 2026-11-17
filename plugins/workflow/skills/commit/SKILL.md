---
name: commit
description: "Commits then pushes the current work, repository by repository — limited to what the conversation produced, one commit per subject, messages following the project's convention — without asking for approval again, and stops only on a real doubt: file of uncertain origin, secret in the diff, branch contrary to the convention, failing hook or push. Invoke on the /workflow:commit command."
disable-model-invocation: true
---

# commit

Commit and push the current work.

**The command is an order.** It is the explicit approval to commit and to push: you do not ask for it again. You stop only on one of the doubts in section 3.

## 1. Get your bearings

Take from `WORKFLOW.md` the format of commit messages, their language, the branching model and the strategy for updating a branch; from the `CLAUDE.md`, the rules for using git and the attribution lines to add. Both are normally already in your context. **Without `WORKFLOW.md`, commit nothing** — suggest `workflow:setup`.

Identify **the repositories the current work has touched**. On a project that groups several repositories, it is not only the current directory. Read the `CLAUDE.md` of each one: it may carry its own rules, such as working directly on the main branch.

## 2. Scope

For each repository, look at the complete state of the working tree and of the index, then at the diff of each modified or new file.

- **Commit only what the current work produced.** A file the conversation did not touch stays out of the commit, and the report points it out. Look at the index too: a change staged before you enters the commit despite a targeted add — unstage it without losing it.
- **One commit per subject.** When the work mixes several subjects or several tickets, make several commits, each with its own files.
- **The message follows the format of `WORKFLOW.md` exactly**, in its language, with the ticket reference it requires. Also take your cue from the repository's latest commits: scope, tone, length. The subject says what the commit does; the body, when useful, says why. Add the expected attribution lines.

## 3. Stop on a doubt

In the following cases, commit nothing in the repository concerned: lay out the case and wait for the answer. The other repositories are handled normally.

- **A file may or may not belong to the current work.** Better a question than a commit that carries off someone else's work.
- **The diff contains what looks like a secret**: key, password, token, connection string, environment file.
- **The current branch contradicts the convention**: a commit on the integration or production branch of a repository that works with feature branches. A repository whose documentation says it works directly on its main branch is not a deviation. When the history shows this practice without the documentation saying so, ask, and suggest writing it in the repository's `CLAUDE.md` so that the question does not come up again.
- **A hook fails.** Fix it if the cause lies in the current work, otherwise report. Never `--no-verify`.
- **The push is rejected**, or updating the branch produces a conflict.

## 4. Commit and push

Commit, then push the current branch to its remote, with tracking if it is its first push.

**If the remote has moved ahead**, update the branch according to the strategy in `WORKFLOW.md` — rebase if nothing is specified — then push. Only your still-local commits are replayed; nothing already pushed is rewritten.

**Then verify** that the local branch is aligned with the remote. A push that seems successful does not prove the commits are there.

## 5. Report

Per repository: the branch, each commit (short hash and message), the remote it is pushed to, and the files left out of the commit with their reason.

If the branch follows a pull request's cycle, point to `/workflow:to-pr`. Touch neither the tracker nor the pull request.

## Rules

- **The project's `WORKFLOW.md`, `CLAUDE.md` and `README.md` are authoritative** on everything else: they override this skill's default behaviors, and a local rule is followed without debate. But when the contradiction is **strong** — a principle of the skill and a project rule that cannot both hold — stop, lay out both, and ask what should be updated: the project's documentation, or the skill itself when the rule is meant to apply everywhere.
- **No routine confirmation.** The command is the approval; only the doubts in section 3 justify a question.
- **Nothing outside the current work.** What you did not produce does not go out with your commit.
- **No rewriting of shared history**: no force push, no amend of an already pushed commit.
- **Neither tracker nor pull request.** Statuses belong to `workflow:implement`, the pull request to `workflow:to-pr`.
