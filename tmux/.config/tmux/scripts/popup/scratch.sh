#!/usr/bin/env zsh

width=${2:-95%}
height=${3:-95%}

# Normalize session name: replace . and _ with -
session_name=$(basename "$HOME" | tr '._' '-')

if [ "$(tmux display-message -p -F "#{session_name}")" = "$session_name" ]; then
    tmux detach-client
    exit 0
else
    tmux display-popup -d '#{pane_current_path}' -xC -yC -w"$width" -h"$height" -E "tmux attach -t $session_name || tmux new -s $session_name"
fi
