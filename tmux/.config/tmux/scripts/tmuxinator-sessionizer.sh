#!/bin/zsh

# Directory containing tmuxinator configurations
tmuxinator_dir="$HOME/.config/tmuxinator"

# List tmuxinator projects and pass them to fzf
selected=$(ls "$tmuxinator_dir" | sed 's/\.yml$//' | fzf)

# Exit if nothing is selected
if [[ -z $selected ]]; then
    exit 0  # Exit script if no project is selected
fi

# Check if tmux is running
tmux_running=$(pgrep tmux)

# If tmux is not running and not inside a tmux session, start a new one
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmuxinator start "$selected"
    exit 0  # Exit script after starting tmux session
fi

# Check if the tmux session with the given name already exists
if ! tmux has-session -t="$selected" 2>/dev/null; then
    tmuxinator start "$selected"  # Start the tmuxinator project
fi

# Switch to the selected tmux session
tmux switch-client -t "$selected"
