# Work Vault — TPM

A work knowledge + task vault organized with PARA, adapted from a personal "personal OS" template. It's for running technical-product-management work: platform knowledge, specs, roadmaps, meeting notes, and day-to-day tracking.

## ⚠️ Confidentiality & tooling (read first)

This vault holds work material and lives in a **work GitHub repo**.

- Keep it **fully separate from any personal vault or accounts**. No personal data in here; no work data in personal tools.
- Only store confidential/internal info here if **this repo and every connected tool are approved for it**. Follow the employer's data-handling and AI-tool policy.
- Point any automation (daily note, task sync, email/calendar pulls) at **sanctioned work tools** — e.g. Jira, the work calendar/email, the company-approved AI. **Do not** wire this vault to personal Todoist / Gmail / Google Calendar.
- When in doubt about whether something can live here, ask before adding it.

## Structure (PARA)

- **00 Inbox** — capture point for unsorted notes; triage into Projects/Areas/Resources.
- **01 Projects** — finite initiatives with a definition of done (an epic, a launch, a migration). Move to `04 Archives` when done.
- **02 Areas** — ongoing responsibilities with no end date (e.g. Platform Roadmap, Standups & Rituals, Stakeholders, On-Call/Ops).
- **03 Resources** — reference material (systems map, glossary, runbooks, API/spec docs, process templates).
- **04 Archives** — finished projects and stale material.

## Conventions

- Every project and area folder has a **README.md** (goal/scope, status, links) and a **MOC.md** (index of the folder's notes).
- **Rule:** when you create a new file in a project/area folder, add an entry to that folder's `MOC.md`.
- **Atomic notes:** keep each note focused on one topic; link related notes with `[[wikilinks]]`.
- **The daily note is the frontend.** Each morning, build a daily note (what's due, meetings, follow-ups) and work from it.

## Ramp-up kit (first weeks in the role)

Seed these in `03 Resources` / `02 Areas` as you learn the platform:

- **Systems map** — services, APIs, data flows, ownership.
- **Glossary** — acronyms and internal names.
- **Who's-who** — people, roles, what they own, how they work.
- **Decisions & open-questions log** — decisions made + questions to raise in 1:1s.

## Skills (`.claude/skills/`)

- **daily-note** — build the day's note (what's due, meetings, follow-ups).
- **weekly-review** — walk initiatives one at a time, drive each to a next action.
- **new-project** — scaffold a new initiative (folder + README/MOC).
- **triage-inbox** — sort inbox captures into PARA.

> These skills were written for a personal setup that used Todoist + Google Calendar + Gmail over MCP. **Before relying on them, retarget the integrations** to whatever your employer sanctions (Jira, work calendar/email, approved AI) — or run them in a lighter, manual mode. Edit the `SKILL.md` files to match your actual tools.

## Templates (`templates/`)

- **Daily Template** — the daily note.
- **Epic Project / Epic checklist / Release Notes / Release Steps / User Story** — PM process templates. Review and adapt them to your team's actual Jira/workflow before using.
