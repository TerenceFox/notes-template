---
name: weekly-review
description: Walk through every active project one at a time, reconcile its README against reality, and drive each to a concrete next action or a deliberate backlog decision. A per-project conversation, not a cleanup pass. Projects only — the biweekly area review is separate.
user-invocable: true
---

# Weekly Project Review

The point of this review is to keep each project moving and to surface backlog that should become active. **It is a conversation, project by project.** Tidying tasks and fixing stale docs happens along the way, but the goal is that every project exits with either a concrete dated next action or an explicit decision to leave it backlogged.

Scope is **projects only** (`01 Projects/`). Areas are handled by a separate biweekly area review.

## Hard rules (do not violate)

1. **One project at a time. Present it, then STOP and wait for the user.** Never apply an edit or advance to the next project without their input. Even an obvious, factual fix (a stale Status line) waits for a quick confirm. The review is worthless if the user isn't in it.
2. **Show, don't lecture.** Lead with the project's real state and one open question. Do not dump walls of analysis or a list of recommendations. A discussion is back-and-forth.
3. **Recommend a next action, but "leave backlogged" is a valid answer.** Prefer proposing one concrete next step; accept a deliberate park.
4. **Once the user decides, fix it completely in one pass** — Todoist task(s) + README + CLAUDE.md — wherever the change manifests. Never fix one location and then ask permission to fix the obvious matching one.
5. **Sync side effects.** If a change dates a task for today (or removes a task that was on today's list), update today's daily note (`02 Areas/Journal/YYYY-MM-DD.md`). If a deadline changes, sync both the README and the CLAUDE.md project table.
6. **Every project README must explicitly state Active or Backlogged** in its Status. Set it to match the review's outcome.

"We changed its dates earlier" is **not** "we discussed it." Every project gets its own conversation this session, even if you touched it for some other reason today.

## Steps

1. **Build the project list.** Read the **Projects (01 Projects)** table in `CLAUDE.md`. Review the projects in that order. Skip the Archived table and all Areas.

2. **For each project, one at a time:**

   **a. Gather state.**
   - `find-tasks` by the project's Todoist ID (include subtasks).
   - Read the project README: Goal, Status, Deadline, and whether it declares Active/Backlogged.

   **b. Reconcile the README against reality.** Compare the written Status to the actual world:
   - Tasks completed/closed since the Status was written
   - Due dates or deadlines that have passed
   - Deadlines that were added or removed
   - Blockers that have resolved (or new ones)
   - Milestones reached
   Note every discrepancy — the Status line is frequently stale.

   **c. Flag task issues:**
   - Undated tasks that should have a date (or backlog items that are fine undated)
   - Overdue / repeatedly-carried-over tasks
   - Duplicates
   - **Missing tasks** the README/milestones imply but Todoist doesn't have (these are the highest-value catches — e.g., a critical booking with no task)
   - Blocked tasks

   **d. Present compactly.** Show: Goal; current Active/Backlogged + Status (flag any staleness); tasks grouped by their section/layer/phase with the flags above; then **one** recommended next action. Keep it tight — this is the opening of a conversation, not a verdict.

   **e. STOP and ask** what the user wants to do with this project. Wait for their answer.

   **f. Apply the decision completely.** Update Todoist, then sync the README Status (rewrite it to reality and set the explicit **Active**/**Backlogged** marker) and CLAUDE.md if the deadline/DoD changed, and the daily note if anything landed on today — all in one pass. When setting due dates, avoid weekends (push to Monday) unless the user says otherwise.

   **g. Confirm what changed,** then ask to move to the next project. **Do not advance unprompted.**

3. **After the last project,** present a summary table (project → outcome / next action). Remind the user to check off the **Weekly project review** task in today's daily note. Note that the **biweekly area review** (the Areas) is a separate workflow, not covered here.

## README Status convention

The Status section must open with an explicit marker:

- `**Active.** <current state, what's in progress, next step>`
- `**Backlogged.** <one line: why it's parked / what would unblock it>`

Rewrite the Status to match reality during the review — never leave a point-in-time line that no longer reflects the project.

## Anti-patterns (these are the mistakes this skill exists to prevent)

- **Batching** — pushing edits across several projects without stopping for input.
- **Half-fixing** — changing Todoist but not the README (or vice versa), then asking separately.
- **Skipping** — treating a project as "done" because you touched it earlier; it still needs its conversation.
- **Lecturing** — presenting conclusions and recommendations instead of showing state and asking an open question.
