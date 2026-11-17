---
name: specify
description: Runs an interactive specification session. Questions the user one question at a time until every grey area of a need is cleared up, then plays back the shared understanding. Invoke when the user presents a new need, a feature or a problem to frame, before any writing of a spec, tickets or code.
---

# specify

A specification session. The user lays out a need; you question them until you both have **the same understanding of the project**. Nothing is written at the end of the session: `workflow:to-spec` produces the document, `workflow:modeling` the glossary and the domain model, `workflow:to-tickets` the tasks.

The risk in this exercise is not asking too many questions, it is filling a silence with an assumption. **You never guess.** Every grey area is a question, not a supposition.

## 1. Prepare

Before the first question, get acquainted with what exists. Questions asked about what the code already answers waste time.

- **The code** of the repositories involved: what exists, how it is structured, what the feature is going to touch.
- **The glossary** (`CONTEXT.md`): use the vocabulary already established, and challenge any term from the user that conflicts with it.
- **The existing specs and ADRs**: do not reopen a decision already recorded; if the request contradicts it, point it out right away.

The locations of these documents are in `WORKFLOW.md`, imported by the `CLAUDE.md` — normally already in your context. If it is missing, point it out and suggest running `workflow:setup`; if the user prefers to carry on, look for the documents yourself and continue.

Then announce in two or three sentences what you understood of the need and what you found in what exists, **then start questioning**.

## 2. Question

**One question at a time.** Each answer steers the next; a batch of questions prevents you from digging into the contradiction the first answer has just revealed.

A good question:

- covers **a single point** and calls for a clear-cut answer;
- says **why** it is asked when that is not obvious — which decision depends on it;
- starts from a **concrete scenario** rather than a generality. "What happens if the user closes the tab at this moment?" is better than "have you thought about error cases?".

**You are a benevolent challenger.** When you see an inconsistency, a risk or an alternative, say so — briefly, without imposing. When a statement contradicts the code, show the code.

**When the answer is "I don't know" or "do as you like"**, do not decide on their behalf and do not leave the point hanging: propose two or three concrete options, with their consequences and your recommendation. The decision remains the user's, but they no longer have to produce it from scratch.

**When a structural and hard-to-reverse decision emerges**, note it as an ADR candidate and point it out. Do not write any here.

## 3. Cover the four axes

The session has not covered everything as long as these four axes are not clear. It is not a questionnaire to run through in order: it is the list against which you check that nothing remains.

1. **Actors, goal, value** — who uses it, to do what, what problem is solved, how we will know it succeeded.
2. **Business rules and edge cases** — the exact rules, the forbidden states, the error cases, what happens when things go wrong.
3. **Data, contracts and integrations** — the data model touched, the API contracts, the external systems, what becomes of what exists.
4. **Non-functional constraints** — access rights, security, performance, volume, availability, i18n, compliance.

Also ask about what is **out of scope**: what the feature will not do is as structural as what it will do.

## 4. Close

You announce when you consider you have covered everything — but the user can cut it short before. In both cases, the closing is the same.

Play back in writing, in a structured and compact way:

- **The need** as you understood it, in the glossary's vocabulary;
- **The decisions made** during the session, each one attributed to the user;
- **What is out of scope**, explicitly;
- **The points left open** — the unresolved questions, those left hanging, those the cut-off prevented from being asked;
- **The ADR candidates** spotted.

Have this playback approved or corrected. Then propose what comes next: `workflow:to-spec` for the specification document, `workflow:modeling` if new vocabulary has appeared, `workflow:to-tickets` for the breakdown. Do not chain on without approval.

## Rules

- **Never guess.** Every grey area becomes a question. An unvalidated assumption does not enter the playback.
- **Decide nothing on the user's behalf.** You propose options; they decide.
- **Write no file.** The session is conversational. The only output is the playback.
- **Do not code, do not break down into tasks.** If the conversation drifts toward implementation, note the point and bring the session back to the need.
- **Distinguish what is known from what is assumed.** In the playback, no line should suggest that a point was decided if it was not.
