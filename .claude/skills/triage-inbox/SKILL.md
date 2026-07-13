---
name: triage-inbox
description: Triage files in the Obsidian inbox, sorting them into Projects, Areas, or Resources, flagging new folder candidates, and listing deletion candidates.
allowed-tools: Read Write Edit Bash Glob Grep Agent
---

Triage all files in `00 Inbox/`.

For each file in the inbox, read it and decide one of three outcomes:

## 1. File belongs in an existing folder

The content clearly fits an existing folder under `01 Projects/`, `02 Areas/`, or `03 Resources/`.

**Action:**
- Move the file to the appropriate folder using `mv`.
- Add a wikilink entry to that folder's `MOC.md` (create the MOC.md if it doesn't exist, following the pattern of existing MOCs in the vault).
- Update any wikilinks in the moved file if paths changed.

## 2. File suggests a new Project, Area, or Resource

The content is substantive but doesn't fit any existing folder. It could warrant a new PARA folder.

**Action:**
- Do NOT create the folder yet.
- Add it to a "Needs Discussion" list to present to the user, with:
  - The file name
  - A one-line summary of the content
  - Your suggested PARA category (Project, Area, or Resource) and proposed folder name

## 3. File is not worth keeping

The content is garbled, a brief meaningless snippet, empty, nonsensical, or otherwise not valuable.

**Action:**
- Do NOT delete it yet.
- Add it to a "Deletion Candidates" list to present to the user, with:
  - The file name
  - A one-line reason why it should be deleted (e.g., "empty file", "single word: 'test'", "garbled text")

## After processing all files

Present a summary to the user with three sections:

1. **Sorted** — files you moved, where they went, and what MOC was updated
2. **Needs Discussion** — files that may need new folders (if any)
3. **Deletion Candidates** — files you recommend deleting (if any)

Wait for the user to confirm deletions before removing anything.
