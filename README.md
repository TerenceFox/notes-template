# Work Notes Template

A PARA-based Obsidian vault template for running technical-product-management work, seeded from a personal knowledge/task system. Clone it into your work environment and fill it in there.

**Start with [[CLAUDE]] / `CLAUDE.md`** — it covers the structure, conventions, and the confidentiality/tooling ground rules.

## Quick start

1. Read `CLAUDE.md`, especially the **Confidentiality & tooling** section.
2. Confirm what your employer sanctions — editor (Obsidian or a markdown editor), AI tool, and where work data can live — **before** putting anything real in here.
3. Retarget the skills' integrations (Todoist/Calendar/Gmail → your sanctioned work tools), or use them manually.
4. Seed the ramp-up kit in `03 Resources` (systems map, glossary, who's-who, decisions log).
5. Build a daily note each morning and work from it.

## What's included

- PARA folder skeleton (`00 Inbox` → `04 Archives`), each with a short README.
- `.claude/skills/` — daily-note, weekly-review, new-project, triage-inbox.
- `templates/` — daily note + generic PM templates (epic, release, user story).
- `scripts/` — tmux dev-layout helpers (`tdl`, `tdln`) + a copy of the tmux config.
- No personal or confidential content — this is an empty scaffold.

## Dependencies

Nothing here is required just to read the notes — the vault is plain markdown.
The tooling below is only needed for the workflows that automate it.

### Editor & vault

- **Obsidian** (or any markdown editor) — to browse/edit the vault. The daily-note
  workflow assumes an Obsidian-style vault.
- **A terminal editor via `$EDITOR`** (e.g. `nvim`/`vim`) — the `scripts/` tmux
  layouts open `$EDITOR` in the editor pane.
- **`ObsidianToday`** — an editor command (e.g. a Vim command/plugin) that opens
  today's daily note. Used by the `notes` alias (`tdln … ObsidianToday`); only
  needed for that alias.

### Terminal / shell

- **tmux** (3.1+ to read `~/.config/tmux/tmux.conf`) — required by every script in
  `scripts/`; the layouts error out if not run inside a tmux session.
- **bash** (Linux) or **zsh** (macOS default) — to source the script functions.
- **git** — version control; the vault lives in a work GitHub repo.

### AI tooling

- **An AI CLI on `PATH`** — the tmux layouts launch one in the AI pane; the vault
  is set up for `claude` (Claude Code). Must be a **company-sanctioned** tool per
  `CLAUDE.md`.

### Skills integrations (retarget before use)

The `.claude/skills/` were written for a personal setup and depend on MCP
integrations that must be **retargeted to sanctioned work tools** (see `CLAUDE.md`):

- **Todoist** → your work task tracker (e.g. Jira)
- **Google Calendar** → the work calendar
- **Gmail** → the work email
- **Obsidian CLI** — used by some skills for vault operations.

> Per `CLAUDE.md`, do **not** wire this vault to personal Todoist / Gmail /
> Google Calendar. Point automation only at approved work tools.

See [`scripts/README.md`](scripts/README.md) for per-script requirements and
Mac vs Linux setup instructions.
