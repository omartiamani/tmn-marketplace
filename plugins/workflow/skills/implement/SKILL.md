---
name: implement
description: Implements a task identified by its number in strict TDD — red, green, refactor — managing its branch, its status in the project tracker and the update of documentation that has become wrong. Invoke when the user asks to implement, develop or fix a work item designated by its identifier.
---

# implement

Implement **one** task, designated by its identifier, with test-driven development.

The ticket is the law. It was written as a snapshot of what held true when it was created: it is what defines the scope, not what the code suggests to you along the way.

## 1. Read up

Take from `WORKFLOW.md` the statuses, the transitions, the branch and commit conventions and the documentation locations; from the "Workflow tooling" section of the `CLAUDE.md`, the commands to act on the tracker. Both are normally already in your context. Without `WORKFLOW.md`, do not start: suggest `workflow:setup`.

Retrieve the work item by its identifier and read it **in full**, comments included. Then:

- check its **blocking dependencies** — if a blocker is not finished, point it out and ask before continuing;
- read the **spec** it comes from and the **glossary**, to use the right terms;
- read the relevant **code**, and spot the existing tests that cover the area;
- read the **`CLAUDE.md` of the repository** you are going to modify, and its README. The README says which commands exist, the `CLAUDE.md` says how to run them and what must absolutely not be done — mandatory package manager, forbidden command, value never to hard-code. On a project grouping several repositories, the one in the repository being modified is not loaded automatically: go and read it.

## 2. Present the plan

Before writing anything, lay out: your understanding of the ticket, the acceptance criteria as you understood them, the files and modules you intend to touch, and the sequence of tests you are going to write — in which order.

**Wait for the go-ahead.** It is the only mandatory stop in the cycle; better to correct a misunderstanding here than after three red cycles.

## 3. Start

Move the ticket to the "in progress" status defined by `WORKFLOW.md`, and **create the branch** following the project's convention. These two actions do not require approval.

Skip the branch only if the repository's documentation says it works directly on its main branch — the common case of a documentation or scripts repository, neither built nor deployed. Follow it without debate: it is not a deviation to report.

## 4. Red, green, refactor

One behavior at a time, strictly:

**Red.** Write a test that describes the expected behavior, and **run it to show that it fails**. A test that passes on the first try proves nothing — either it does not test what you think, or the behavior already exists. In both cases, stop and understand why before continuing.

**Green.** Write the **minimal** code that makes the test pass. Not the generalization you anticipate, not the next case: just this one.

**Refactor.** Once green, improve the structure — of the code as well as the tests — while keeping the suite green. Then move on to the next behavior.

**Comments say only the non-obvious why**, briefly: a choice the code cannot show, such as `replace` rather than `push`, or a workaround and its reason. No narration of the flow, no restating of what the code and its names already say. A long comment usually means a name or the code should say it instead.

Never skip the red step, including for a bug fix: the test that reproduces the bug must fail first, otherwise nothing proves it catches it.

Test **observable behavior**, not implementation details: a test that breaks on every refactor without any behavior changing is a test to rewrite.

**Do not write a test just to have written a test.** A test is justified by the behavior it protects. A function that merely wraps a library call, an accessor, a one-line function without a branch: testing them protects against nothing and turns every refactor into a chore. Test what carries a business rule, an edge case, a decision. When in doubt, ask yourself what a test would catch that a review would not — if the answer is "nothing", do not write it.

The test and build commands are in the repository's README, and how to run them in its `CLAUDE.md` — both are read, never one without the other. **If the commands are not in the README, suggest adding them there** — a developer arriving on the project must find them there; it is not information reserved for tooling.

## 4b. Infrastructure tasks

Infrastructure as code is not done with TDD: there is no unit test to make fail before declaring a resource. Follow the loop in [INFRA.md](./INFRA.md) — plan, approval, deployment, verification with the provider.

## 5. When reality diverges from the ticket

Everything you write — commit message, description, documentation — is written **in the language declared in `WORKFLOW.md`**, whatever the language of the conversation.

**The ticket's description has become wrong or incomplete** — the behavior described no longer matches the need, a criterion is ambiguous, a constraint has changed. Show the gap, propose the **exact text** of the new description, and write it after approval.

**Existing documentation has become wrong** — README, spec, diagram, glossary. Same procedure: the gap, the proposed text, the approval, then the writing. Do not leave behind documentation that your own work has just contradicted.

**Documentation is referenced, not copied.** What a document already describes — the cross-cutting docs, another repository's README, a spec — is not written a second time: where the reader needs it, a link to the section that holds it is enough. A copy diverges at the first change, and the reader no longer knows which one to believe. Before replacing a duplicate with a link, move to the source what only the duplicate says.

**The work overflows the ticket.** Stay strictly within scope. Note what you discovered, and point it out in your report, proposing to make it a ticket. Do not widen the scope, even for an addition that seems minor: that is how a one-session task becomes three.

When the user agrees to make it a ticket, **do not write it by hand**: go through `workflow:to-tickets`. It is the one that carries the rules for writing, questioning and approval; bypassing them produces a ticket that no one has reviewed. If they only want to note it for later, go through `workflow:capture`.

## 6. Finish

Before announcing anything, verify — and show the results:

- the repository's **full test suite** is green, not only your tests;
- the **lint and the build** pass;
- **each acceptance criterion** is gone over one by one, with what proves it;
- the behavior is **observed in the real application**.

This last point is not a formality: the tests prove that the code does what you wrote, not that the feature works. Verify according to what the task touches.

- **Front end and back end** — start the local servers as the README says, open the relevant flow and observe the behavior end to end, including the error case. If the application has a login page, **ask the user to authenticate themselves**: you never enter their credentials.
- **API only** — make real **authenticated** calls, and examine the actual responses: status code, body, headers. Also verify the expected refusal — unauthenticated call, insufficient permission, invalid input.
- **UI only** — go through the screen in the browser, including the empty, loading and error states.
- **Infrastructure** — see [INFRA.md](./INFRA.md).

**Real calls are made in the local or development environment, never anywhere else.** Check which environment you are pointing at before the first call; when in doubt, ask. No verification justifies touching a staging or production environment.

**When a verification call mutates data** — creation, modification, deletion — announce it beforehand, and **ask once the verifications are done whether to roll back**. Even in development, data left behind skews the next piece of work. Never delete on your own initiative.

If one of these checks fails, say so as is, with the output obtained. A task is not finished because the code is written, nor because the tests are green.

Then, in this order, asking each time:

1. **Commit** — message following the project's convention, referencing the work item.
2. **Move the ticket to the next status** — the one defined by `WORKFLOW.md`. When the tool sets it on its own by linking the ticket to the pull request, do not touch it: it is the reference that `/workflow:to-pr` adds that moves it, once the ticket is in the pull request.

Pushing stays in the user's hands, unless explicitly asked. The pull request is opened or updated with `/workflow:to-pr`: point it out once the ticket is finished.

## Rules

- **The project's `WORKFLOW.md`, `CLAUDE.md` and `README.md` are authoritative** on everything else: they override this skill's default behaviors, and a local rule is followed without debate. But when the contradiction is **strong** — a principle of the skill and a project rule that cannot both hold — stop, lay out both, and ask what should be updated: the project's documentation, or the skill itself when the rule is meant to apply everywhere.
- **One task at a time.** If the ticket turns out to be too big for one session, say so and suggest splitting it rather than carrying it out halfway.
- **No production code without a red test first.** No exceptions, bug fixes included — except infrastructure, which follows the loop in section 4b.
- **A test must be worth its cost.** No test on trivial code or on a simple pass-through to a library.
- **Do not modify the acceptance criteria to make them pass.** If a criterion is untenable, that is a discussion, not a rewrite.
- **Never give an optimistic report.** An ignored test, a skipped verification, an uncovered criterion: it gets said.
- **Do not close the parent.** Only the work item handled changes status.
