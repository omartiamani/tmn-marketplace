---
name: modeling
description: Maintains the project's domain model — the CONTEXT.md glossary and the ADRs. Invoke when a new or fuzzy business term appears, when a word is used in a sense that contradicts the glossary, when two words clearly designate the same thing, when a structural and hard-to-reverse decision is made, or when a glossary or ADR is requested.
---

# modeling

The project needs a shared vocabulary and a record of its structural decisions. This skill carries both: the `CONTEXT.md` glossary and the ADRs.

**Why it matters.** Faced with an ambiguous term, an AI does not stumble: it decides silently, often in the generic sense rather than the business one — and the code produced compiles, reads well, and models the wrong concept. A settled term fixes that meaning once and for all: no more need to redefine it in every session, nor to saturate the context with re-explanations. It becomes the real name of the thing in the code, the tickets and the tests.

`CONTEXT.md` is **a glossary, nothing else**. Not a spec, not a notepad, not a store of implementation decisions. As soon as you write in it how something works, it stops being readable at a glance and no one reads it anymore.

## Location

`WORKFLOW.md` says where the glossary and the ADRs live. If it does not, suggest a single `CONTEXT.md` in the documentation repository — the business vocabulary is cross-cutting, and one glossary per repo lets the same term diverge from one repo to another — and suggest recording the location in `WORKFLOW.md`.

Create the files lazily: `CONTEXT.md` at the first settled definition, the ADR directory at the first ADR.

## During the discussion

Three situations make you step in without being asked.

**A term conflicts with the glossary.** Point it out on the spot: "the glossary defines _Lease_ as X, you seem to mean Y — which one is it?" An unresolved vocabulary disagreement produces code that lies.

**A business term is new or fuzzy.** When a domain concept appears without a settled definition, or two words clearly designate the same thing, propose a canonical term and have it decided. Test the boundary with a concrete scenario rather than with an abstract definition: it is the edge case that reveals whether two concepts are really one.

**A structural decision is made.** Spot it and propose an ADR — see the threshold below.

## Writing the glossary

The file contains **the domain terms, their definitions, and the relationships between them**: a Lease covers Units, a Unit belongs to a Building. A definition fits in one or two sentences and says what the thing **is**, not what it does.

Record only what is **specific to the project's domain**. General technical notions — cache, retry, DTO, idempotence — have no place there, even when heavily used. Before adding a term: is it a concept specific to this business, or a general computing concept?

Two regimes, not to be confused:

- **Adding a new term** — announce the term and the definition you are recording, then write. No waiting.
- **Modifying or deleting an existing definition** — show the old one and the new one, and **wait for approval**. Someone has already written code based on the old definition.

**Write in the language declared in `WORKFLOW.md`**, whatever the language of the conversation.

Write as you go, as soon as a term is decided. Do not queue: what is postponed to the end of the session is lost.

## When the code contradicts the glossary

Show both — the definition and what the code actually does — and ask which one is authoritative. Depending on the answer: you correct the definition, or you open a renaming task. **You rename nothing yourself**.

## Writing an ADR

An ADR is justified when **all three** conditions are met:

1. the decision is **hard to reverse** — the cost of changing your mind later is real;
2. **several credible options** were weighed;
3. the **why** will be forgotten in six months.

If `WORKFLOW.md` sets its own criterion, that one applies.

This is rare by design. A decision that does not meet all three is not an ADR: it goes into the spec or the ticket. Do not turn the ADR directory into a logbook.

An ADR has a sequential number, a title that states the decision (`0003-cosmos-db-as-lease-store.md`), and contains:

- **Status** — proposed, accepted, or superseded by ADR no. X;
- **Context** — the situation and the constraints that make the decision necessary;
- **Decision** — what is decided, phrased in the active voice;
- **Rejected alternatives** — those that were actually weighed, and why they do not prevail;
- **Consequences** — what the decision makes possible, and what it costs.

**An accepted ADR is not rewritten.** When the decision changes, write a new ADR and mark the old one as superseded. The history of decisions is as valuable as the current decision.

Have the content approved before writing an ADR: unlike adding a term, it is a binding document.

## Rules

- **The project's `WORKFLOW.md`, `CLAUDE.md` and `README.md` are authoritative** on everything else: they override this skill's default behaviors, and a local rule is followed without debate. But when the contradiction is **strong** — a principle of the skill and a project rule that cannot both hold — stop, lay out both, and ask what should be updated: the project's documentation, or the skill itself when the rule is meant to apply everywhere.
- **The glossary is a glossary.** No business rule, no implementation detail, no decision. Those go into the spec, the ticket or the ADR.
- **Be decisive.** When several words designate the same thing, keep one and note the others as to be avoided. A glossary that does not arbitrate is useless.
- **Never define a term on the user's behalf.** You propose a definition; they approve or correct it.
- **Stay brief.** This file is read in full by every session that touches the domain: every superfluous sentence is paid for every time.
