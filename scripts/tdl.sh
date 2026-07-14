# Tmux dev layout for coding projects: editor left, AI right 30%, terminal bottom 15%.
#
# This is the full layout that `tdln` (the notes variant) is derived from — the
# difference is `tdl` keeps a bottom terminal pane for running commands/tests.
# It originates from the Omarchy defaults:
#   ~/.local/share/omarchy/default/bash/fns/tmux
#
# Source this file from your shell rc (or copy the function in) to use it:
#   source /path/to/this/scripts/tdl.sh
#
# Usage: tdl <c|cx|codex|other_ai> [<second_ai>]
#   $1  ai   command to launch in the right pane (e.g. `claude`)
#   $2  ai2  optional second AI, stacked below the first
tdl() {
  [[ -z $1 ]] && { echo "Usage: tdl <c|cx|codex|other_ai> [<second_ai>]"; return 1; }
  [[ -z $TMUX ]] && { echo "You must start tmux to use tdl."; return 1; }

  local current_dir="${PWD}"
  local editor_pane ai_pane ai2_pane
  local ai="$1"
  local ai2="$2"

  # Use TMUX_PANE for the pane we're running in (stable even if active window changes)
  editor_pane="$TMUX_PANE"

  # Name the current window after the base directory name
  tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"

  # Split window vertically - top 85%, bottom 15% (target editor pane explicitly)
  tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"

  # Split editor pane horizontally - AI on right 30% (capture new pane ID directly)
  ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')

  # If second AI provided, split the AI pane vertically
  if [[ -n $ai2 ]]; then
    ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
    tmux send-keys -t "$ai2_pane" "$ai2" C-m
  fi

  # Run ai in the right pane
  tmux send-keys -t "$ai_pane" "$ai" C-m

  # Run the editor in the left pane
  tmux send-keys -t "$editor_pane" "$EDITOR ." C-m

  # Select the editor pane for focus
  tmux select-pane -t "$editor_pane"
}
