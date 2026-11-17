---
name: capture
description: Adds to the backlog, without interrupting the current work, the idea, feature or bug that was just discussed — title, type and parent inferred from the conversation, without any question — then verifies the created ticket. Invoke on the /workflow:capture command, or when the user asks to note something in the backlog for later.
---

# capture

Note an idea in the backlog before it gets lost, without derailing the current work. The specification will come later, with `workflow:specify` then `workflow:to-tickets`.

**Capture is quick and silent.** It lands in the middle of something else: no question, no approval, no proposal. You decide alone everything that is missing, you create, you verify, you report in one line, then you pick up where you left off.

## 1. Get your bearings

Take from `WORKFLOW.md` the tool, the types, the initial status, the target repository of each type, the required fields and the language; from the "Workflow tooling" section of the `CLAUDE.md`, the identifiers and the creation commands. **Without `WORKFLOW.md`, create nothing** — say so, suggest `workflow:setup`, and resume the current work.

## 2. Infer

**What to capture is inferred from the conversation**: the idea, the defect or the need that was just discussed. Text passed with the command serves as a hint, not as a title. Several things to note make several tickets.

- **Title** — short, in the glossary's vocabulary and in the language declared in `WORKFLOW.md`.
- **Type** — an observed defect is a bug; everything else takes the type of needs to be specified, according to the hierarchy in `WORKFLOW.md`.
- **Parent** — the one that is obvious, such as the ticket of the feature where the bug occurs. At the slightest doubt, none: it will be attached during specification.
- **Description** — what the conversation established: what was observed, where, and why it needs doing. Nothing more.
- **Repository** — the one `WORKFLOW.md` designates for this type.

When a point is uncertain, take the most likely reading and carry on: the report shows it, and the user will correct it if needed.

## 3. Rule out duplicates

Search the open tickets for the same subject. An obvious duplicate is not created again: give its link instead. A mere resemblance blocks nothing: create, and cite the similar ticket in the report.

## 4. Create and verify

Create the ticket with the commands from the `CLAUDE.md`: type, parent, required fields, addition to the board, initial status — according to `WORKFLOW.md`.

**Then verify, before creating the next one.** Read the ticket back as the tool returns it: its type, its parent, its status, and its presence on the board, read from the board itself. A gap stops the capture: report what was created and the gap.

## 5. Report, then resume

One line per ticket: its identifier and link, its title, its type, its parent or the absence of one. Then resume the current work, without transition.

## Rules

- **The project's `WORKFLOW.md`, `CLAUDE.md` and `README.md` are authoritative** on everything else: they override this skill's default behaviors, and a local rule is followed without debate. But when the contradiction is **strong** — a principle of the skill and a project rule that cannot both hold — stop, lay out both, and ask what should be updated: the project's documentation, or the skill itself when the rule is meant to apply everywhere.
- **No questions.** Everything missing is inferred; the report says what was inferred.
- **Nothing invented.** The ticket carries only what the conversation established: no criterion, no technical hint, no rule.
- **Initial status only.** A captured ticket never moves to ready, even if it seems clear.
- **Read back, not assumed.** A ticket is created only once read back in the tool.
