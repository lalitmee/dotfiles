#!/bin/zsh

# ~/.config/tmux/scripts/gh-dash-popup.sh

width=${1:-95%}
height=${2:-95%}
session_name="gh-dash"

# Check if the session already exists
if tmux has-session -t "$session_name" 2>/dev/null; then
    # If the popup is already displayed, hide it
    if [ "$(tmux display-message -p -F "#{session_name}")" = "$session_name" ]; then
        tmux detach-client
    else
        # If the session exists but is not displayed, show it in a popup
        tmux display-popup -d '#{pane_current_path}' -xC -yC -w"$width" -h"$height" -E "tmux attach -t $session_name"
    fi
else
    # If the session does not exist, create it and run gh dash
    tmux new-session -d -s "$session_name" -n "gh-dash" "gh dash"
    tmux display-popup -d '#{pane_current_path}' -xC -yC -w"$width" -h"$height" -E "tmux attach -t $session_name"
fi
