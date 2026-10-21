#!/usr/bin/env zsh
# fzf window switcher: aligned session/window/command columns + pane preview.
# Bound to prefix+Tab; runs inside a tmux display-popup.

set -euo pipefail

selection=$(
    tmux list-windows -a -F $'#{session_name}:#{window_index}\t#{window_name}\t#{pane_current_command}\t#{window_id}' |
        awk -F'\t' '
            BEGIN { printf "%-26s  %-26s  %-16s\n", "SESSION:INDEX", "WINDOW NAME", "COMMAND" }
            { printf "%-26s  %-26s  %-16s\t%s\n", $1, $2, $3, $4 }
        ' |
        fzf --delimiter='\t' --with-nth=1 --header-lines=1 \
            --prompt='🪟  ' --pointer='▸' \
            --preview='tmux capture-pane -ep -t {2}' \
            --preview-window='right:50%:wrap' \
            --bind='tab:down,btab:up' \
            --color='fg:#FFFFFF,bg:#193549,hl:#FFC600,fg+:#FFFFFF,bg+:#185294,hl+:#FF9D00,info:#8fbfdc,prompt:#3AD900,pointer:#00AAFF'
)

[[ -n "$selection" ]] || exit 0

window_id=${selection##*$'\t'}
target=$(tmux display-message -p -t "$window_id" '#{session_name}:#{window_index}')
tmux switch-client -t "$target"
