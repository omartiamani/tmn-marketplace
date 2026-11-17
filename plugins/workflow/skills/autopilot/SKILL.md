---
name: autopilot
description: "Autonomous variant of workflow:implement — implements a task and all its child tasks in one go, without any question or approval: each batch handed to the implementer agent (plan, TDD, verification in the application, commits), then push, pull request updated, checked by workflow:check-pr and marked ready for review. Never trigger on your own: only on the /workflow:autopilot command or on an explicit request to work autonomously."
disable-model-invocation: true
---

# autopilot

The autonomous variant of `workflow:implement`. It goes in one go from the ticket to the pull request: the user judges the work only by reviewing the pull request.

**You orchestrate; the tasks are implemented elsewhere.** Each batch of tasks goes to the [`workflow:implementer`](../../agents/implementer.md) agent, which applies `workflow:implement` autonomously up to the commits. You maintain the pull request following [workflow:to-pr](../to-pr/SKILL.md) and check it with [workflow:check-pr](../check-pr/SKILL.md), with only the differences described here. Wherever one of them expects approval or asks a question, this skill's rule applies, and you carry on. Your context must hold an entire feature: it keeps only the tree, the batch reports and the pull request, never the code.

Autonomy applies to approvals, not to rigor: it is the back-and-forth that goes away.

## The run

1. **The scope**: the complete tree under the given identifier, the order of its blocking dependencies, the repositories involved, the working branch — and its split into batches.
2. **Each batch, handed to the `workflow:implementer` agent**, in dependency order. When it returns: judging its report, then pushing the branch, updating the pull request following `workflow:to-pr` for each finished task, and their next status. A batch is finished and verified before the next one starts.
3. **Once the scope is finished**: `workflow:check-pr` on each pull request, the fixes it calls for, then marking those that are ready as ready for review.
4. **The final report.**

## The batches

**First split the scope into batches.** A batch groups the tasks that are better done in one go than by handing off to each other: dependent on one another, they touch the same code, and are small enough to fit together in a single context. Separated, the second would have to rediscover what the first has just written. A task that shares nothing with the others forms a batch on its own, as does one that would fill a context by itself. Decide from the tickets — dependencies, technical hints, named modules — without reading the code yourself, and show the split before launching the first batch.

Batches follow one another, never in parallel, even when independent: they would share the branch, the working tree, the servers and the verification simulator.

Give the agent what its definition expects: the identifiers of the tasks in the batch in order, the repositories and the working branch, and from previous batches only what binds it. It returns a report task by task: show the plans and verdicts it reports as you go.

**Judge each report before touching the pull request**, without rereading the code:

- each acceptance criterion of the ticket — read again in the ticket, not in the report — appears in it, with what proves it;
- the announced commits exist on the branch;
- a task reported as finished has no red test, lint or build, and no verification skipped without a reason.

A gap sends the task back to the agent, with the gap to close. It enters the pull request only once consistent; if the gap persists, it goes into the reviewer notes and the task stays out of the pull request.

## What changes

**What was decided without the user is shown where they review.** For a decision that `workflow:to-pr` would leave to them, choose the most reasonable assumption. The decisions, the gaps with the tickets and the skipped verifications — yours as well as those the agent reports — go to two places: in the pull request's reviewer notes, and in the final report.

**Git.** Push the working branch when each batch returns, without asking. A repository that works directly on its main branch receives its commits without a push: point them out.

**The pull request.** Open it or update it following `workflow:to-pr` when each batch returns. **Mark it ready for review without asking** as soon as `workflow:to-pr` allows it — all the children of its parent are in it — and `check-pr` leaves no unfixed problem. Otherwise, it stays a draft, and the report says what is missing.

**The check.** Once the scope is finished, run `workflow:check-pr`, even if the pull request does not yet have all the children of its parent: it is the fresh eye that comes before the user's. Apply its fixes without approval:

- the code, through the `workflow:implementer` agent, the problems to fix standing in for tickets, then push;
- the description, by recomposing the body following `workflow:to-pr`.

A ticket that diverges from the code is not fixed: the gap goes into the reviewer notes. After each fix, rerun the affected checks. A problem that survives its fix is not retried in a loop: it goes into the reviewer notes. Completeness only matters when marking ready for review: an out-of-scope child missing from the pull request is not a problem to fix.

**Statuses.** Move each finished task to the next status, as `workflow:implement` does — often simply through the reference that `workflow:to-pr` adds. **Do not push any final transition**: closing belongs to the human review.

## When to stop anyway

Autonomy does not go as far as delivering red. Stop and report if:

- the `workflow:implementer` agent cannot be launched — a session opened before the plugin was installed does not see it;
- a batch comes back stopped;
- a preliminary check of `workflow:to-pr` fails and cannot be resolved within the limits below — an already pushed branch that would need rebasing, for example;
- a principle of the workflow and a project rule cannot both hold;
- a hard limit is reached.

What is already finished and green stays committed, pushed and in the pull request; nothing red gets pushed. An honest stop halfway is better than a report that declares finished what is not.

## Hard limits

The [agent's hard limits](../../agents/implementer.md#hard-limits) apply to you too, and no autonomy lifts them. For you, the one on work items also lets the next status through, never the final transition. Added to them: **no merge, and no push to the integration branch.**

## Final report

All at once, at the end: the link to each pull request, ready for review or draft and why, the tasks handled and their state, what `check-pr` raised and what was fixed, the decisions made autonomously, the documentation files modified, the verifications skipped and why, the data left in place, the scope overflow encountered, and the unpushed commits.
