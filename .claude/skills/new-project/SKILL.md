---
name: new-project
description: Create a new project across Obsidian, Nextcloud, and Todoist with an interactive questionnaire to establish goals, plan, and definition of done.
allowed-tools: Read Write Edit Bash Glob Grep Agent mcp__todoist__add-projects mcp__todoist__add-tasks mcp__todoist__add-sections mcp__todoist__find-projects
---

Create a new project across all three systems: Obsidian vault, Nextcloud, and Todoist.

## Step 1: Interactive Questionnaire

Ask the user the following questions **one at a time**, waiting for each answer before proceeding. Adapt follow-up questions based on answers. Keep a conversational tone.

1. **Project name** — What should this project be called?
2. **Tagline** — One sentence: what is this project?
3. **Goal** — What does "done" look like? Be specific and measurable.
4. **Deadline** — When does this need to be done by?
5. **Context** — Why are you starting this now? What's the motivation?
6. **Current status** — Where are you starting from? What exists already?
7. **Approach** — How do you plan to tackle this? Key steps, phases, or strategies?
8. **Milestones** — What are the major checkpoints on the way to done? (These become Todoist tasks)
9. **Resources** — Any relevant links, repos, tools, or references?
10. **Anything else** — Anything I should know that doesn't fit the above?

After gathering all answers, summarize the project back to the user and ask for confirmation before creating anything.

## Step 2: Create Obsidian Folder

Create the folder and files at `01 Projects/<Project Name>/`.

### README.md

Follow this structure (matching existing project READMEs in the vault):

```markdown
# <Project Name>

*<Tagline>*

## Overview

<Context and motivation, written as a paragraph>

## Goal

<Specific, measurable definition of done>

**Deadline:** <date>

## Status

<Current status and starting point>

## Approach

<How the project will be tackled — steps, phases, strategies>

## Milestones

<Bulleted list of major checkpoints>

## Organization

| File | Purpose |
|---|---|
| [[README]] | This file — goals, workflow, and links |
| [[MOC]] | Map of Content — index of all notes |

## Links

**Todoist:** <Project Name> — `<Todoist Project ID>`
**Nextcloud:** `~/Nextcloud/01 Projects/<Project Name>/`
<Any other resources/links provided>

## Related
- [[MOC]]
```

### MOC.md

```markdown
# <Project Name> — Map of Content

> Index of all notes in this project. For goals and workflow, see [[README]].

## Notes

_(No notes yet)_

## Related
- [[README]]
```

## Step 3: Create Nextcloud Folder

Create the folder at `~/Nextcloud/01 Projects/<Project Name>/`. The Nextcloud client will sync it automatically.

## Step 4: Create Todoist Project

Use `mcp__todoist__add-projects` to create the project with:
- **name**: The project name
- **color**: `mint_green` (all projects are mint green)

Then use `mcp__todoist__add-tasks` to create tasks from the milestones gathered in the questionnaire, with due dates if the user provided them.

## Step 5: Update CLAUDE.md

Add the new project to the **Projects (01 Projects)** table in `/home/terence/notes/CLAUDE.md` with:
- Vault Folder
- Todoist Project name
- Todoist ID (from the created project)
- Definition of Done (with deadline)

Maintain the existing table format.

## Step 6: Confirm

Present a summary of everything created:
- Obsidian folder path + files
- Nextcloud folder path
- Todoist project name + ID + number of milestone tasks created
- CLAUDE.md updated
