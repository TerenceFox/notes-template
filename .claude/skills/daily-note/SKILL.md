---
name: daily-note
description: Close out the previous daily note (push task status changes back to Todoist), then build today's daily note — triage the Todoist inbox, pull in calendar events, overdue/due Todoist tasks, and surface task notes/comments into the Notes section
user-invocable: true
---

# Daily Note Processor

Run this once each morning. It does two things in order: (1) **closes the previous daily note** by pushing your checkbox changes back to Todoist, then (2) **builds today's daily note** at `02 Areas/Journal/YYYY-MM-DD.md`.

There is no separate end-of-day step — you mark tasks `[x]`/`[>]`/`[~]`/`[-]` in the note as you go, and the next morning's run syncs them.

## Steps

1. **Determine today's date** from the hook-injected date in the conversation.

2. **Close the previous note.** Find the most recent daily note *before* today in `02 Areas/Journal/` (usually yesterday; over a weekend or gap, use the latest dated note before today). If none exists, skip silently to step 3.

   Parse every task line in its `## Tasks` section and push status changes back to Todoist. For each task that is **not** `[ ]`, match it to Todoist: strip the `(Project)` suffix, any time prefix (e.g. `8:00 AM — `), and any trailing wikilink, then search with `find-tasks` on the core text; if multiple results, prefer the one whose project matches the parenthetical.

   | Note status | Todoist action |
   |---|---|
   | `[x]` completed | `complete-tasks` |
   | `[~]` cancelled | `complete-tasks` (close it out) |
   | `[-]` not applicable | `complete-tasks` (close it out) |
   | `[>]` migrated | `reschedule-tasks` to **today** — the user deferred it from that day to now |
   | `[ ]` still open | No action — it stays in Todoist and resurfaces below as overdue |

   Batch where possible (e.g. complete all `[x]` in one call). If a task already looks completed in Todoist, skip it silently.

   **Port note-only tasks back.** If a non-`[ ]` task has no Todoist match, it's one the user typed straight into the note — create it with `add-tasks` so future runs can find it. Route by the `(Project)` suffix, else best-fit project from the CLAUDE.md tables, else Inbox. Set it due today, then apply the action above (`[x]`/`[~]`/`[-]` → complete it; `[>]` → leave open). Skip sub-bullets, notes, and any non-checkbox lines — only checkbox-prefixed lines in `## Tasks`.

   Report a one-line summary, e.g. "Closed yesterday: 2 completed, 3 migrated to today, 1 cancelled."

3. **Read today's daily note** at `02 Areas/Journal/YYYY-MM-DD.md`. If it doesn't exist, create it from `templates/Daily Template.md` — replace `{{date}}` with today's date in `YYYY-MM-DD` format. Then continue to populate Tasks and Events in the following steps.

4. **Triage the Todoist inbox.** Before pulling today's tasks, walk through every open inbox item one-by-one with the user. Query the inbox with `find-tasks` using `projectId: 'inbox'`. If the inbox is empty, skip silently and continue to the next step.

   For each inbox task, present its content, description (if any), and any existing metadata, then ask via `AskUserQuestion` which action to take:

   - **Move to project (with optional due date)** — follow up by asking which project/area from the CLAUDE.md project tables, plus an optional due date. Use `update-tasks` to set `projectId` and (if given) `dueString`.
   - **Set due date to today** — keeps the task in Inbox but dates it. Use `update-tasks` with `dueString: "today"`. The item will be picked up in the next step's task pull and grouped under **Inbox** in the daily note.
   - **Complete now** — use `complete-tasks`.
   - **Delete** — use `delete-object`.
   - **Leave in inbox** — no-op, move on.

   Always walk one-by-one, regardless of how many items are in the inbox.

   After every item is processed, report a summary line: e.g., "Triaged 5 inbox items: 2 moved to projects, 1 dated to today, 1 completed, 1 deleted".

5. **Fetch today's calendar events** using the Google Calendar MCP (`list_events` for today's date). Format each as a bullet under `## Events` with time and title (e.g., `- 2:00 PM — Dentist`).

6. **Fetch Todoist tasks due today or overdue** using `find-tasks-by-date` with `startDate: 'today'`. Include task content and project name. This pulls anything you dated to today during inbox triage **and the `[>]` tasks you rescheduled to today in step 2** (the migrated tasks carry forward this way — no separate step needed). Format as bullets under `## Tasks`. While fetching, also capture each task's **description (notes)** — it comes back inline with the task — and fetch any **comments** with `find-comments` for the pulled tasks. This content gets surfaced in `## Notes` (see step 8).

7. **Find relevant note links.** Before writing, look up wikilink targets to surface alongside events and task groups. This is best-effort — only link when there's a clear, high-value target. Skip silently when nothing obvious matches.

   - **Per event:** Search the vault for a call-prep, interview-prep, or meeting note tied to the event. Match by company name, attendee names, or distinctive title keywords. Use `find` and `grep` against `01 Projects/` and `02 Areas/`. If a match is found, append ` — prep: [[Note Name]]` to the event line.
   - **Per task group:** Look up a focal note in the corresponding project/area folder that's relevant to the listed tasks. Examples: Job Search bridge-income tasks → `[[Search Strategy#Revised Plan (June 2026)]]`; Sell Stuff → `[[Things to sell]]`; Eat Your Vegetables → `[[yearly-theme]]`. If a match is found, append ` — see [[Note Name]]` to the bold group heading.
   - Prefer the shortest unique wikilink; use `[[Note#Heading]]` to point at a specific section when relevant. Don't link the Inbox group or recurring-daily groups (Wellness, Journal). Don't link tasks individually — only group headings and events.

8. **Write the daily note** with the following under the bullet journal sections:

   ### ## Tasks
   - Group tasks by project/area under **bold headings** (e.g., `**Inbox**`, `**Job Search**`, `**Acclaud**`). Order groups by: **Inbox first** (freshly-triaged captures), then projects (matching CLAUDE.md project table order), then areas, then recurring daily tasks (Wellness, Journal) last.
   - Append ` — see [[Note]]` to the bold heading when step 7 found a relevant link.
   - Within each group: timed tasks first (sorted by time), then untimed tasks
   - Todoist tasks due today or overdue (including migrated tasks carried forward from step 2), formatted as `- [ ] Task content (Project Name)`
   - Preserve any tasks already written in today's note

   ### ## Events
   - Calendar events for today, formatted as `- HH:MM AM/PM — Event title`
   - Append ` — prep: [[Note]]` when step 7 found a relevant prep note.
   - Preserve any events already written in today's note

   ### ## Notes
   - For each task pulled into today that has a Todoist description (notes) or comments, drop that content here so it's visible without opening Todoist. Format: `- **<task content>:** <description / comment text>`.
   - Collapse multi-line descriptions (e.g., embedded checklists) into something readable; keep sub-items as nested bullets if useful. Attribute comments if helpful (e.g., who/when).
   - Skip tasks that have no description or comments.
   - **Preserve everything already in `## Notes`.** This section also holds the user's own free-form notes (they may type directly into it). Always append task-derived notes below existing content — never overwrite, reorder, or remove what's already there.

9. **Deduplicate**: Don't add a task or event that's already listed in today's note. For `## Notes`, don't re-add a task's description/comment if that content is already present.

## Bullet Journal Key

- `[ ]` — open task
- `[x]` — completed task
- `[>]` — migrated (deferred to next day)
- `[~]` — cancelled
- `[-]` — not applicable

## Notes

- The close step (step 2) only **pushes** status to Todoist — it never edits the previous note. Today's build steps only write **today's** note.
- Don't touch the Journal section (On my mind, A win or gratitude, Reframe) — that's for the user.
- Don't modify frontmatter properties (mood, energy, etc.) — that's for the user.
- If a Todoist task has a time, include it. If not, just list the content.
- Recurring tasks completed via the close step naturally reappear on their next recurrence in Todoist.
- When asking the user to assign a project during inbox triage, use the project/area tables in CLAUDE.md as the source of truth. Don't invent projects.
- When suggesting due dates during inbox triage, respect the no-weekend-tasks feedback memory: don't propose Saturday/Sunday, push to Monday.
