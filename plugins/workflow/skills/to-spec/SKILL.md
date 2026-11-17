---
name: to-spec
description: Writes the specification document for a need from the current discussion, a ticket or notes, writing into it only what was actually decided. Invoke after a specification session, or when the user asks to formalize, write or update a spec.
---

# to-spec

Turn what was discussed into a specification document. **You do not specify here, you transcribe**: no interview question, no new decision. The questioning session is `workflow:specify`.

The value of this document rests entirely on one thing: a reader must be able to rely on it. A single invented rule slipping in and it becomes a poisoned source of truth, indistinguishable from the rest.

## 1. Gather the material

- **The current conversation** — the nominal case, the session that has just taken place.
- **A ticket, a file or notes** passed as an argument — retrieve the full content, comments included.
- **The existing code** — reread it to check the consistency of what was said, never to fill in what was not said.

**If the material is too thin to produce an honest spec, do not write it.** Say what is missing and suggest a `workflow:specify` session. A hollow document costs more than no document.

## 2. Locate the file

The location of the specs is in `WORKFLOW.md`. If it is not there, suggest `docs/specs/` of the repository concerned — or of the documentation repository when the subject is cross-cutting — and suggest recording it in `WORKFLOW.md` for next time.

One file per subject: `<location>/<subject-in-kebab-case>.md`.

**If a spec already exists for this subject, ask** before writing: update of the existing file, or new version alongside it? Do not decide alone.

## 3. Write

Cover the notions below **in this order**, and only those for which the discussion produced material. It is not a questionnaire to fill in: a notion without material does not give an empty section, it gives no section at all.

- **The problem**, from the point of view of whoever suffers from it — not the solution.
- **The goal and the value**: what it enables, and how we will know it succeeded.
- **The actors**: who, with what rights, in what context.
- **The workflows**: when a sequence of steps, a user journey or a lifecycle was described, play it back step by step — the steps, their transition conditions, the states, who triggers what, and what happens when a step fails or is abandoned. A Mermaid diagram is the right tool as soon as the sequence branches, provided it encodes only steps that were actually discussed.
- **The business rules**: the exact rules, one by one, the forbidden states, the edge cases and the error cases with the expected behavior.
- **The data, contracts and integrations**: data model touched, API contracts, external systems, what becomes of existing data.
- **The non-functional constraints**: rights, security, performance, volume, availability, i18n, compliance.
- **What is out of scope**: what the feature will not do, and why.
- **The decisions**: each one with its reason and, when they were mentioned, the rejected alternatives. Point out those that are structural and hard to reverse as ADR candidates.
- **The open points**: what was not decided, what it blocks, who must decide.

**Level of detail: decisions, not implementation.** The modules touched, the API contracts, the schema changes, the interactions: yes. File paths and code excerpts: no, they go stale within a few days. Exception: a schema, a type or a state machine that encodes a decision more precisely than a sentence would.

**Neither user stories nor acceptance criteria.** That is the role of `workflow:to-tickets`, which will produce them from this spec. Do not duplicate.

**Write in the language declared in `WORKFLOW.md`**, whatever the language of the conversation.

Use the glossary's vocabulary (`CONTEXT.md`). If a new term appeared during the discussion, point it out and suggest `workflow:modeling` — do not add it to the glossary from here.

## 4. Play back

Announce the file written, and **list separately**:

- what was marked as inferred from the code and remains to be confirmed;
- the open points;
- the structural decisions spotted as ADR candidates.

## Rules

- **The project's `WORKFLOW.md`, `CLAUDE.md` and `README.md` are authoritative** on everything else: they override this skill's default behaviors, and a local rule is followed without debate. But when the contradiction is **strong** — a principle of the skill and a project rule that cannot both hold — stop, lay out both, and ask what should be updated: the project's documentation, or the skill itself when the rule is meant to apply everywhere.
- **Adding anything is strictly forbidden.** No business rule, no edge case, no constraint that was not explicitly stated. Even if the omission looks like an obvious oversight to you, even if the spec looks incomplete because of it: you point it out in your answer, **never in the file**.
- **Mark what comes from the code.** Everything you draw from your reading of the code rather than from the discussion ends with `[inferred from code — to be confirmed]`. A reader must tell at a glance what was decided from what was observed.
- **The "Open points" section is mandatory.** It is the only one that is never deleted, even without material: then write explicitly that no point is open as of that date. A missing section would suggest an oversight.
- **Never fill a silence.** An undiscussed area goes into the open points, not into an assumption written in the present tense.
- **No imposed form.** The notions above set the order and the content, not the number of headings or their wording. Adjust the structure to the subject.
- **Split the file when a section becomes unmanageable** — when it can no longer be read in one go or deserves its own discussion. The main file then keeps the table of contents and links to the split-out files. Point out the split.
