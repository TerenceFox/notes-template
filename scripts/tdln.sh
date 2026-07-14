# Tmux dev layout: editor left, AI right 30%, no bottom terminal pane.
#
# This is the script behind the `notes` alias:
#   alias notes='cd ~/notes && tdln claude "" ObsidianToday'
#
# Source this file from your ~/.bashrc (or copy the function in) to use it:
#   source /path/to/this/scripts/tdln.sh
#
# Usage: tdln <c|cx|codex|other_ai> [<second_ai>] [<editor_cmd>]
#   $1  ai         command to launch in the right pane (e.g. `claude`)
#   $2  ai2        optional second AI, stacked below the first
#   $3  editor_cmd optional editor command to run on open (e.g. ObsidianToday)
tdln() {
  [[ -z $1 ]] && {
    echo "Usage: tdln <c|cx|codex|other_ai> [<second_ai>] [<editor_cmd>]"
    return 1
  }
  [[ -z $TMUX ]] && {
    echo "You must start tmux to use tdln."
    return 1
  }

  local current_dir="${PWD}"
  local editor_pane ai_pane ai2_pane
  local ai="$1"
  local ai2="$2"
  local editor_cmd="$3"

  editor_pane="$TMUX_PANE"
  tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"

  ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')

  if [[ -n $ai2 ]]; then
    ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
    tmux send-keys -t "$ai2_pane" "$ai2" C-m
  fi

  tmux send-keys -t "$ai_pane" "$ai" C-m
  if [[ -n $editor_cmd ]]; then
    # Run the editor command directly (e.g. ObsidianToday) so it opens as the
    # sole buffer instead of behind a directory explorer buffer.
    tmux send-keys -t "$editor_pane" "$EDITOR -c \"$editor_cmd\"" C-m
  else
    tmux send-keys -t "$editor_pane" "$EDITOR ." C-m
  fi
  tmux select-pane -t "$editor_pane"
}
