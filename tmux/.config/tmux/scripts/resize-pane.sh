#!/usr/bin/env zsh
# resize-pane.sh

direction_flag="$1"
session_name="$2"

# First, try to get the session-specific value set by the menu.
amount=$(tmux show-options -t "$session_name" -qv @resize-step)

# If no session-specific value is found, get the global value.
if [ -z "$amount" ]; then
  amount=$(tmux show-options -gqv @resize-step)
fi

# As a final fallback, default to 1 if no option was found at all.
if [ -z "$amount" ]; then
  amount=1
fi

tmux resize-pane "$direction_flag" "$amount"