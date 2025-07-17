#!/bin/zsh

# --- Configuration ---
LANGUAGES_FILE="$HOME/.config/tmux/scripts/cht-sh/.cht-languages"
COMMANDS_FILE="$HOME/.config/tmux/scripts/cht-sh/.cht-commands"

# --- Main Logic ---

# 1. Select the language or command using fzf.
#    2>/dev/null silences errors if a file doesn't exist.
selected=$(cat "$LANGUAGES_FILE" "$COMMANDS_FILE" 2>/dev/null | fzf --reverse --cycle --info=inline)

# Exit if fzf was cancelled.
if [[ -z $selected ]]; then
	exit 0
fi

# 2. Prompt for the query using fzf, ensuring it doesn't show a file list.
query=$(fzf --height=3 --prompt="Query for '$selected'> " --print-query < /dev/null | tail -n 1)

# 3. Determine the correct URL format based on the selection.
if grep -qs "$selected" "$LANGUAGES_FILE"; then
	# Language format: cht.sh/python/list+comprehension
	separator='+'
	query_formatted=$(echo "$query" | tr ' ' "$separator")
	final_path="$selected/$query_formatted"
else
	# Command format: cht.sh/tar~xvf
	separator='~'
	query_formatted=$(echo "$query" | tr ' ' "$separator")
	final_path="$selected~$query_formatted"
fi

# If the query was empty, just use the selected item as the path.
if [[ -z $query ]]; then
	final_path="$selected"
fi

# 4. Fetch the cheat sheet and display it with less.
curl -s "cht.sh/$final_path" | less -R
