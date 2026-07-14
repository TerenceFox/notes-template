# scripts/

Shell helpers for working in this vault.

## `tdln.sh` — tmux dev layout for note-taking

`tdln` is the function behind the `notes` shell alias:

```bash
alias notes='cd ~/notes && tdln claude "" ObsidianToday'
```

It splits the current tmux window into an **editor pane on the left** and an
**AI pane on the right (30% width)** — no bottom terminal pane. Running `notes`
drops you into the vault with your editor open on today's note and `claude`
running alongside it.

### Usage

```
tdln <c|cx|codex|other_ai> [<second_ai>] [<editor_cmd>]
```

| Arg | Meaning |
| --- | --- |
| `$1` ai | Command launched in the right pane (e.g. `claude`). Required. |
| `$2` ai2 | Optional second AI, stacked below the first in its own pane. |
| `$3` editor_cmd | Optional editor command run on open (e.g. `ObsidianToday`). |

If `editor_cmd` is given, the editor opens directly on that command
(`$EDITOR -c "<cmd>"`) instead of on a directory listing (`$EDITOR .`).

### Setup

Source it from your `~/.bashrc`:

```bash
source ~/notes/scripts/tdln.sh
```

### Requirements

- You must already be **inside a tmux session** — `tdln` errors out otherwise.
- `$EDITOR` must be set to a Vim-like editor (it uses `-c "<cmd>"` to run a
  command on startup).
- `ObsidianToday` (or whatever you pass as `editor_cmd`) must be a command your
  editor knows — e.g. a Vim command/plugin that opens today's daily note.

### Related

- The original lives in `~/.bashrc` alongside `tdlh` (a half-width variant that
  also adds a bottom terminal pane).
