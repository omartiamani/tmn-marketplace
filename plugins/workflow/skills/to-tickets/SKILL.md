---
name: to-tickets
description: Breaks a need or a spec down into work items (Epics, Features, User Stories, Tasks, Bugs), proposes them in batches for approval, then creates them in the configured project tracker, attaching each child to its parent. Invoke when the user asks to break down, plan, create tickets or feed the backlog.
---

# to-tickets

Turn a spec or a discussion into work items. **Nothing is written to the tool before approval**: you propose, the user approves, you publish.

A ticket is read weeks later, by someone — or a session — who did not attend the discussion. It must therefore be **self-contained**: everything needed to understand and implement it is in it, without having to open the spec. It is a snapshot of what held true at the time of its creation, and that is precisely what makes it valuable when the spec, for its part, has moved on.

## 1. Get your bearings

Take from `WORKFLOW.md` the tool, the type hierarchy, the statuses, the parent/child link mechanism and the required fields; from the "Workflow tooling" section of the `CLAUDE.md`, the identifiers and the reference commands. Both are normally already in your context, the `CLAUDE.md` importing `WORKFLOW.md`. **Without `WORKFLOW.md`, create nothing** — suggest `workflow:setup`. Creating work items with a guessed nomenclature produces a backlog that will have to be reworked by hand.

Gather the material: the subject's spec, the current discussion, the glossary, and the code for what already exists.

**Then clear up the grey areas, before writing anything.** List what is not decided — missing business rule, unhandled edge case, structural technical choice — and put these points to the user, one by one. If the subject is too broad for a few questions, suggest `workflow:specify`. A ticket written over a grey area freezes it: it will resurface during implementation, when it will cost more.

If `WORKFLOW.md` declares a **target repository per ticket type** — the case of a tracker that attaches tickets to a repository, like GitHub, on a multi-repo project — it decides, never the current directory. In the absence of this rule, the question does not arise: the tracker is independent of the repositories, or there is only one.

## 2. Look for what exists

Before breaking down, look for the work items already open on the subject. Attach to an existing parent rather than creating a new one, and **point out any duplicate or contradiction** instead of creating on top of it. A living backlog degrades quickly when two tickets describe the same work.

## 3. Break down into vertical slices

Each User Story cuts through **all the layers** — schema, API, interface, tests — and delivers a behavior that can be demonstrated end to end. A US is not "build the leases API" followed by "build the leases screen": separated, neither of the two proves anything.

A good slice is **verifiable on its own**, and fits in a single working session. If it does not fit, it is too big.

Two exceptions to verticality:

- **The technical prerequisite** that delivers nothing observable but conditions what follows — a migration, a foundation. It becomes a separate US, placed first, and declared blocking for those that depend on it.
- **The large refactor** whose blast radius cuts across the whole code — a rename, a change of shared type. It fits in no vertical slice. Sequence it: first add the new form alongside the old one, then migrate the callers in batches, finally remove the old one — each step being its own task, blocked by the previous one.

Declare the **blocking dependencies**: for each item, what must be finished before it can start. A task without a blocker can be started right away.

## 4. Write

**Write in the language declared in `WORKFLOW.md`**, whatever the language of the conversation.

**Title**: verb in the infinitive, short, in the glossary's vocabulary — "Filter leases by status". It must be readable in a board column.

**Description**:

- **Context** — the why, the current state of what is touched, and the business rules and edge cases that apply to this specific ticket. Take them from the spec: the ticket must stand on its own.
- **Goal** — what the ticket makes possible.
- **Acceptance criteria** — what must be true at the end, phrased in a verifiable way. A criterion that cannot be tested is not a criterion.
- **Technical hints** — modules involved, approach considered, points of attention spotted during the discussion. Only what was discussed.
- **Dependencies** — the blocking items.

Take from the spec only what concerns **this ticket**: self-contained does not mean copying the entire spec. And invent no acceptance criterion that was not discussed — if a criterion seems missing to you, say so in the proposed batch, not in the ticket.

**A ticket records decisions made, never an open trade-off.** If a choice comes up while writing, ask it and wait for the answer; then write only the decision taken and its reason. Writing "two options, to be decided in the ticket" shifts the burden onto the next reader instead of lifting it. And a choice that commits to nothing is not recorded at all: recording a non-structural decision clutters the ticket without protecting anything.

The ticket is dated and frozen. If the spec evolves afterwards, it does not follow automatically: the gap is noted and dealt with at implementation time.

## 5. Propose in batches

One level at a time, from top to bottom: the Epics and Features first, then the User Stories of the approved scope, then the tasks. Each level is frozen before detailing the next one.

**A single ticket is a batch of one**: it is proposed and approved like the others. The fact that there is only one exempts it from nothing.

For each batch, present a numbered list with the title, the parent, the blockers and what the item delivers. Ask explicitly: is the granularity right, are the dependencies correct, should anything be merged or split? Iterate until approved.

**The specified item is part of the batch.** When the subject is itself an existing work item — captured on the fly, before its spec — its description is updated too, to its specified state, and proposed with the batch. Like any ticket, it is self-contained.

## 6. Publish

Only after approval, and in hierarchy order: the parents first, so that the children can reference real identifiers.

For each item: create, **attach to the parent**, fill in the required fields, apply the initial status and the blocking dependencies — all according to `WORKFLOW.md`, with the commands from the `CLAUDE.md`.

**Then verify, before creating the next one.** Read the item back as the tool returns it: its type, its parent, its required fields, its status, its dependencies, and its presence on the board — read from the board itself, not from the item. A command that succeeds does not prove the result is there: a step can fail without an error. A gap counts as a failed creation.

**If a creation fails, stop immediately.** Report: what was created with the real identifiers, what remains to be created, and the exact error. Do not continue the batch — a missing parent produces orphaned children. Delete nothing to "start clean".

Once the children are created, update the description of the specified item as approved, and read it back.

Finish by playing back the tree created, with the real identifiers.

## Rules

- **The project's `WORKFLOW.md`, `CLAUDE.md` and `README.md` are authoritative** on everything else: they override this skill's default behaviors, and a local rule is followed without debate. But when the contradiction is **strong** — a principle of the skill and a project rule that cannot both hold — stop, lay out both, and ask what should be updated: the project's documentation, or the skill itself when the rule is meant to apply everywhere.
- **Nothing written without approval.** Batches are approved before publication, without exception.
- **No ticket without a parent**, except at the top of the hierarchy. Attaching is part of creating, not of a later pass.
- **A ticket is created only once verified.** Read back in the tool, not inferred from the commands' success.
- **The ticket is self-contained.** It carries the context, the rules and the criteria that concern it, and remains implementable without opening the spec — it is a snapshot, not a pointer.
- **Invent neither rule nor criterion.** What was not discussed is pointed out in the batch, never in the ticket.
