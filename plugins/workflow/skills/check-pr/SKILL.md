---
name: check-pr
description: Safeguard for a pull request before it is marked ready for review — does its description tell the truth about the code, do the code and the description meet the associated tickets, is the code good — that raises only proven problems and proposes their fix, without applying anything without approval. Invoke before marking a pull request ready for review, on the /workflow:check-pr command, or when the user asks to check a pull request.
---

# check-pr

A safeguard before a pull request is marked ready for review. Its goal: make sure on the one hand that the pull request meets the specs defined in its tickets, and on the other hand that the code reflects what the pull request says and that it is clean. Three questions, and only three:

1. **Does the description tell the truth?** Every claim it contains matches the code of the pull request.
2. **Does the work meet the tickets?** The code and the description do what the associated tickets expect.
3. **Is the code good?** It works, it follows the project's written rules, and its tests protect what they should.

**A safeguard, not one more review.** It raises only proven problems — what is wrong, missing or broken, and can be demonstrated. No suggestions, no preferences, no nitpicks. A pull request with no problem gets a very short report.

The description is what the reviewer reads, and what people find months later when searching for why the code is the way it is. A false claim there is worse than an omission: people believe it.

**Only the description is authoritative.** Commit messages are neither read nor checked.

**You report and you propose; you apply nothing without approval.**

## 1. Get your bearings

Take from `WORKFLOW.md` the expected format of the pull request body and of its references to tickets; from the "Workflow tooling" section of the `CLAUDE.md`, the commands to read and modify a pull request. Read the `CLAUDE.md` and the README of the repository concerned: they are what say which rules the code must follow and how to run the checks. Without `WORKFLOW.md`, point it out and suggest `workflow:setup`: checking the ticket references becomes impossible, the rest gets done.

Identify the pull request: the one passed as an argument, otherwise the one for the current branch. **When the same branch exists in several repositories**, the feature often has one pull request per repository: check each one. A claim may concern the other repository, such as "needs the matching API changes": verify it there.

Retrieve, for each pull request:

- its full title and **description**;
- its **full diff** against the integration branch — the final state, as it will be merged;
- the **associated tickets**, read in full, comments included: those the description closes or references, and those designated by the branch name according to the convention in `WORKFLOW.md`. Go up to their parent and list all its children: the pull request is judged against all the tickets of the parent it serves, not only against those it cites.

## 2. Rerun the automated checks

Run the build, the lint and the full test suite of the repository, with the commands from the README as the `CLAUDE.md` says to run them. If the pull request has automated checks on the tool (CI), read their state too.

A failure does not interrupt the check: carry on, and put it at the top of the report.

## 3. Hand the reading to a fresh eye

The checks are done **in two fresh subagents**, launched in parallel — one for the description and the tickets (A and B), the other for the code (C) — never in the context that wrote the code or the description. Whoever wrote it rereads their intent, not the code.

Each subagent receives only: the pull request identifier and the command to read its diff, the description, the full content of the associated tickets, the paths of the project rules to read, the instructions for its checks and the proof threshold below. Neither the conversation, nor your opinion of the code.

For bug hunting, launch in parallel, **for each pull request**, a subagent whose only task is to invoke Claude Code's code review skill — `code-review`, with the pull request URL as argument, the path of the local repository and the access instructions from the `CLAUDE.md` — then send its findings back to you as text, without sorting them. Invoked from a subagent, this skill runs in a separate context and returns only its findings; invoked from your context, it runs there in full.

If you cannot launch a subagent, do the checks yourself and say so in the report: the reading is then not independent.

### The proof threshold

A problem is raised only if it can be demonstrated: the line of code, the ticket criterion or the sentence of the description that proves it, and what goes wrong as a result. What is suspected without being shown is not raised. Neither is anything that comes down to taste, style, a possible improvement or a rule that no project document writes down.

Before reporting, run each finding from the subagents and from the code review through this threshold: discard those that do not clear it, merge duplicates.

### Check A — the description

Break the description down into claims — every behavior, rule, value, label, dependency version, reference to an ADR, every "no longer", and every reviewer note that asserts a fact about the code — and compare each one against the diff. Raise those the code **contradicts** and those of which it bears **no trace**. A claim about a state outside the code — a database, a verification done by hand — is not judged.

Also raise **unmentioned changes**: a change of behavior, API contract, data schema or dependency, or a test removal, present in the diff and absent from the description.

### Check B — the tickets

- **Acceptance criteria** — compare against the code each criterion of each closed ticket, and each business rule or edge case it writes down. Raise those that are **absent**, **partial** or **contradicted**.
- **Description and tickets** — raise a claim in the description that contradicts a ticket, and a closed ticket that the description does not cover. When the code and the description diverge together from a ticket, do not decide: give both outcomes — fix the code, or update the ticket.
- **References** — they follow `WORKFLOW.md`: closing keyword on each ticket the pull request completes, and on those only; a simple mention for the parent. A ticket served by several pull requests is closed only in the one that will be merged last.
- **Completeness** — a pull request is marked ready for review only when it carries all the children of the ticket it serves: raise those that are missing.

A ticket's technical hints are not requirements: departing from them is not a problem.

### Check C — the code

- **Project rules** — a rule written in the `CLAUDE.md`, the README or the repository rules, broken. Cite it, with its file.
- **Tests** — an acceptance criterion that carries a business rule or an edge case, without a test that would fail if it regressed.
- **Leftovers** — debug trace, secret, hard-coded value that the project forbids.
- **Documentation** — a README, a spec, a glossary or a diagram that the change makes wrong, or a passage it adds by copying existing documentation instead of referring to it. Cite both passages.
- **Bugs** — only if the code review could not run: a concrete scenario that produces a wrong result, a crash or a vulnerability.

## 4. Report

Get straight to the point: no preamble, no list of what complies or of what was checked.

**With no problem**, the report fits in one line: ready for review, automated checks green.

**Otherwise**, the verdict first (to fix, and the number of problems), then the problems, under **Automated checks**, **Description**, **Tickets** and **Code**; a heading with no problem does not appear. Each problem fits in one or two lines: where it is (file and line, ticket and criterion, or sentence of the description), what is wrong, and the proposed fix.

For the description or a ticket that has become wrong, the proposed fix is the passage to replace and its replacement, in the language declared in `WORKFLOW.md`. The full text is written only at the moment of applying.

## 5. Fix, after approval

The user chooses what gets applied.

- **The description** is replaced with the command from the `CLAUDE.md`, by the approved text.
- **A ticket that has become wrong** is updated the same way. Never its acceptance criteria to make the code pass: an untenable criterion is discussed, it is not rewritten.
- **The code** is fixed following `workflow:implement`: a fixed bug starts with a red test that reproduces it. The commit follows the project's convention, and is made only after asking.
- After a code fix, **rerun the affected checks**: a fix can make a sentence of the description wrong.

Do not mark the pull request ready for review yourself, unless explicitly asked. Never merge: merging belongs to `workflow:merge`.

## Rules

- **The project's `WORKFLOW.md`, `CLAUDE.md` and `README.md` are authoritative** on everything else: they override this skill's default behaviors, and a local rule is followed without debate. But when the contradiction is **strong** — a principle of the skill and a project rule that cannot both hold — stop, lay out both, and ask what should be updated: the project's documentation, or the skill itself when the rule is meant to apply everywhere.
- **Proven problems, nothing else.** What cannot be demonstrated, or is merely a matter of taste, is not raised.
- **Only the description is authoritative.** Commit messages are not checked.
- **The final diff, not the history.** What will be merged is what gets judged.
- **A fresh eye.** The reading is done outside the context that wrote the code; when that is impossible, the report says so.
- **No invented requirements.** The code is judged against the description, the tickets and the project's written rules, not against your preferences.
- **The tickets state what is expected.** Between a ticket and code that diverges from it, you do not choose: the user decides.
- **Nothing without approval.** Not the description, not the code, not a ticket — text or status.
- **An honest report.** An unverified claim is not verified, and a skipped check is stated.
