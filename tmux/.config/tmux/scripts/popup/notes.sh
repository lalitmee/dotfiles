#!/usr/bin/env zsh

width=${2:-85%}
height=${2:-85%}

if [ "$(tmux display-message -p -F "#{session_name}")" = "notes" ]; then
	tmux detach-client
else
	tmux popup -d '#{pane_current_path}' -xC -yC -w"$width" -h"$height" -E "tmux attach -t notes || tmux new -s notes"
fi
