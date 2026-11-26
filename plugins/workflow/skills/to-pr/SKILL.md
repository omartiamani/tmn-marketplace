---
name: to-pr
description: Opens then keeps up to date the pull request of a working branch — as a draft from the first finished ticket, completed with each following ticket, marked ready for review when all of them are in — with preliminary checks, title and body composed according to the project's convention, and ticket references with the right closing keywords. Invoke on the /workflow:to-pr command or on an explicit request to open or update a pull request.
disable-model-invocation: true
---

# to-pr

Open then keep up to date the pull request of a working branch, until it is marked ready for review.

On many projects, the pull request is not an end-of-the-line formality: its title becomes the commit message after a squash, and its body decides what gets closed automatically on merge. A malformed reference does not show — it closes a ticket that was meant to stay open, or leaves open the one that was meant to close. That is what this skill is there to get right.

**You open and you update; you never merge.**

## The cycle of a pull request

A branch serves a ticket, often a parent whose children are finished one by one. Its pull request follows this cycle:

1. **Opened as a draft as soon as the first child is finished.** The work is visible early.
2. **Updated with each finished child.** Its reference is added at that moment, not before: on many tools, linking a ticket to a pull request changes its status, and a ticket still in progress must not look finished.
3. **Marked ready for review when all the children are in it**, after `workflow:check-pr`.

A ticket without children goes through the same cycle in one go: opened when it is finished, marked ready for review after `workflow:check-pr`.

A ticket is **finished** when its acceptance criteria are validated and its code committed.

## 1. Get your bearings

Take from `WORKFLOW.md` the title format, the expected content of the body, the closing keywords, the branch update strategy and the merge mode — normally already in your context, imported by the `CLAUDE.md`. Without it, compose nothing — suggest `workflow:setup`.

Also read the `CLAUDE.md` of the repository concerned, and retrieve the ticket or tickets the branch serves: identifiers, types, parents, children. The branch name often carries them.

Check whether **the same branch exists in other repositories**: the feature then has one pull request per repository, and the same ticket can be served by several of them. For each ticket, note which repositories hold part of its code.

Establish **where the cycle stands**: does the branch's pull request already exist, which children are finished, which ones are already referenced in its body. What is finished cannot always be read from the tracker: when the conversation does not establish it, ask.

## 2. Check before opening or updating

Three verifications, in this order. If one fails, **stop and report** — do not open a pull request that will have to be fixed afterwards.

1. **Nothing is lying around**: the working tree is clean and the local branch is pushed. An uncommitted change is work the reviewer will not see.
2. **The branch is up to date** with the integration branch. If the latter has moved ahead, apply the strategy declared in `WORKFLOW.md` — if not specified, rebase. Never rewrite the history of an already shared branch without asking for approval first.
3. **The tests and the build pass.** Rerun them: discovering the failure in CI costs one more round trip, and a reviewer notified for nothing.

## 3. Compose

**The title** follows exactly the format declared in `WORKFLOW.md` — often a conventional commit message, with a scope that references the ticket. It describes what _this repository_ does, not the general goal of the ticket, whose branch name several repositories may share.

**The body** contains two things:

- **The references required by the convention**, with the right behavior for each one. This is the trickiest point: on most projects, some references **close** their ticket on merge and others must deliberately not do so — a parent ticket, or a cross-cutting ticket that this pull request is not enough to complete. Copy the convention to the letter; when in doubt about a reference, leave it without a closing keyword and point it out. A child not yet finished has no reference.

  **A ticket served by several pull requests is closed in only one of them**: none completes it alone. The closing keyword goes in the one that will be merged last — usually the repository that consumes the others, the application rather than the API it calls; if the order is not obvious, ask. The others reference it without a closing keyword and name the pull request that closes it. Otherwise, the first one merged closes the ticket while part of its code is not delivered.

- **A short summary of the actual work**, drawn from the branch's commits: what changes, and what deserves the reviewer's attention. Not a commit-by-commit log.

**On each update, recompose the entire body**: the references of the newly finished children are added, and the summary describes the current state of the branch, not the sequence of updates. A sentence that the latest work has made wrong disappears.

Write in the language declared in `WORKFLOW.md`.

## 4. Open or update

Open the pull request as a draft, or replace its body, without waiting for approval. Then give its URL and show the title and the body — for an update, what changed.

**When all the children are in it**, run `workflow:check-pr` and handle its report. Once the report has no problem, offer to mark the pull request ready for review, and do so only after approval.

**Do not touch the tracker.** The references do their work through the tool's automations; tickets that are closed by hand are not this skill's business. Change no status.

**Do not merge**: merging belongs to `workflow:merge`, on the user's order.

## Rules

- **The project's `WORKFLOW.md`, `CLAUDE.md` and `README.md` are authoritative** on everything else: they override this skill's default behaviors, and a local rule is followed without debate. But when the contradiction is **strong** — a principle of the skill and a project rule that cannot both hold — stop, lay out both, and ask what should be updated: the project's documentation, or the skill itself when the rule is meant to apply everywhere.
- **No closing by default.** A closing keyword is added only if the convention provides for it for this type of ticket. When in doubt, leave it out: reopening a ticket closed by mistake costs more than closing by hand.
- **No history rewriting** on a shared branch: no force push, no amend of an already pushed commit.
- **One branch, one pull request** per repository. If the branch mixes several subjects, say so rather than composing a title that covers them all.
- **No marking ready for review without a check.** Before a pull request is marked ready for review, run `workflow:check-pr` and handle its report.
