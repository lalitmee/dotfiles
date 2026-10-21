#!/usr/bin/env zsh
set -euo pipefail

# Keep session + window IDs: linked windows can belong to multiple sessions.
# Let fzf expand tabs using display widths (including emoji), not awk byte counts.
windows=$(tmux list-windows -a -F '#{session_id}:#{window_id}	#{pane_id}	#{=28:#{session_name}:#{window_index}}	#{=28:window_name}	#{pane_current_command}')
if selection=$(printf '%s\n' "$windows" | awk -F '\t' '
    BEGIN { print "SESSION:INDEX\tWINDOW NAME\tCOMMAND" }
    { printf "%s\t%s\t%s\t%s\t%s\n", $3, $4, $5, $1, $2 }
' | fzf --delimiter='\t' --with-nth=1,2,3 --tabstop=32 --no-multi \
    --header-lines=1 --layout=reverse --info=inline \
    --prompt='Window > ' --pointer='▸' \
    --header='Enter: switch   Esc: close   Ctrl-p: expand preview   Ctrl-/: hide preview' \
    --preview='tmux display-message -p -t {4} "#{session_name}:#{window_index} | #{window_name}"; tmux capture-pane -ep -t {5}' \
    --preview-window='bottom:45%:nowrap' \
    --bind='tab:down,btab:up,ctrl-/:toggle-preview,ctrl-p:change-preview-window(bottom:99%|)' \
    --color='fg:#FFFFFF,bg:#193549,hl:#FFC600,fg+:#FFFFFF,bg+:#185294,hl+:#FF9D00,info:#8fbfdc,prompt:#3AD900,pointer:#00AAFF'); then
    [[ -n "$selection" ]] || exit 0
    target=$(printf '%s\n' "$selection" | cut -f4)
    tmux switch-client -t "$target"
else
    code=$?
    # No match and user cancellation are normal exits, not popup errors.
    [[ "$code" == 1 || "$code" == 130 ]] && exit 0
    exit "$code"
fi
