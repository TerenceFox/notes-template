# scripts/

Shell helpers for working in this vault.

## `tdl.sh` — tmux dev layout for coding projects

`tdl` is the full dev layout: **editor left**, **AI pane right (30% width)**, and
a **terminal pane along the bottom (15% height)** for running commands and tests.
It originates from the Omarchy defaults
(`~/.local/share/omarchy/default/bash/fns/tmux`). `tdln` (below) is the
note-taking variant — the same layout minus the bottom terminal pane.

### Usage

```
tdl <c|cx|codex|other_ai> [<second_ai>]
```

| Arg | Meaning |
| --- | --- |
| `$1` ai | Command launched in the right pane (e.g. `claude`). Required. |
| `$2` ai2 | Optional second AI, stacked below the first in its own pane. |

The editor opens on the current directory (`$EDITOR .`). Run it from a project
root, e.g. `cd ~/code/myproject && tdl claude`.

### Setup

Source it from your shell rc (`~/.bashrc` on Linux, `~/.zshrc` on macOS):

```bash
source ~/notes/scripts/tdl.sh
```

### Requirements

- You must already be **inside a tmux session** — `tdl` errors out otherwise.
- `$EDITOR` must be set.
- The AI command (`claude` etc.) must be installed and on `PATH`.

### Related

- Omarchy ships two siblings in the same file: `tdlm` (one `tdl` window per
  subdirectory of the current dir) and `tsl` (an N-pane swarm running the same
  command in every pane).

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

## `tmux.conf` — tmux config & key bindings

A copy of the active tmux config at `~/.config/tmux/tmux.conf` — the single
source of truth for the key bindings the `notes`/`tdln` workflow relies on. (It
is a lightly customized fork of the Omarchy default; the Omarchy copy at
`~/.local/share/omarchy/config/tmux/tmux.conf` is **not** sourced.)

**Prefix:** `Ctrl-Space` (secondary: `Ctrl-b`)

Bindings below are pressed **after the prefix** unless marked _(no prefix)_.

| Key | Action |
| --- | --- |
| `q` | Reload config (`source-file`) |
| `h` | Split pane horizontally (new pane below) |
| `v` | Split pane vertically (new pane right) |
| `x` | Kill pane |
| `r` | Rename current window |
| `c` | New window (same path) |
| `k` | Kill window |
| `R` | Rename session |
| `C` | New session (same path) |
| `K` | Kill session |
| `P` / `N` | Previous / next session |

### No-prefix bindings

| Key | Action |
| --- | --- |
| `Ctrl-Alt-←/→/↑/↓` | Move focus between panes |
| `Ctrl-Alt-Shift-←/→/↑/↓` | Resize pane (5 cells) |
| `Alt-1` … `Alt-9` | Jump to window 1–9 |
| `Alt-←` / `Alt-→` | Previous / next window |
| `Alt-Shift-←` / `Alt-Shift-→` | Move current window left / right |
| `Alt-↑` / `Alt-↓` | Previous / next session |

### Copy mode (vi)

| Key | Action |
| --- | --- |
| `v` | Begin selection |
| `y` | Copy selection and exit copy mode |

### Applying it

This file is a **reference copy** for the vault. Your live config stays at
`~/.config/tmux/tmux.conf`. To make this copy the live one:

```bash
cp ~/notes/scripts/tmux.conf ~/.config/tmux/tmux.conf
tmux source-file ~/.config/tmux/tmux.conf   # or press <prefix> q
```

## Setting this up on a Mac (work laptop)

The paths differ slightly from Linux/Omarchy. Two files to place:

### 1. tmux config

Modern tmux (3.1+, which Homebrew installs) reads `~/.config/tmux/tmux.conf`,
so the same path works:

```bash
brew install tmux                       # if not already installed
mkdir -p ~/.config/tmux
cp ~/notes/scripts/tmux.conf ~/.config/tmux/tmux.conf
tmux source-file ~/.config/tmux/tmux.conf
```

If you're on an older tmux that only reads the legacy path, use `~/.tmux.conf`
instead:

```bash
cp ~/notes/scripts/tmux.conf ~/.tmux.conf
```

### 2. The `notes` alias + `tdln` function

macOS defaults to **zsh**, so these go in `~/.zshrc` (not `~/.bashrc`). The
function is zsh-compatible as written. Add to `~/.zshrc`:

```zsh
# tmux dev layout used by the `notes` alias
source ~/notes/scripts/tdln.sh
alias notes='cd ~/notes && tdln claude "" ObsidianToday'
```

Then reload: `source ~/.zshrc` (or open a new terminal).

**Caveats for the Mac setup:**

- Adjust `~/notes` in the alias/`source` line to wherever you clone this vault
  on the work laptop.
- `tdln` requires `$EDITOR` set to a Vim-like editor and an `ObsidianToday`
  editor command — set those up on the Mac too, or drop the third argument to
  just open the editor on the vault directory.
- `claude` (or whichever AI command) must be installed and on `PATH`.
- You must launch `tmux` before running `notes`; the function errors out
  otherwise.
