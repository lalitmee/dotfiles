#!/bin/zsh

# Define the directories to search
search_dirs=(
    ~/Projects/Personal/Github
    ~/Projects/Work
    ~
)

# Build the find command dynamically from search_dirs
find_cmd=""
for dir in "${search_dirs[@]}"; do
    depth_flag="-maxdepth 2"  # Default depth
    [[ "$dir" == "$HOME" ]] && depth_flag="-maxdepth 1"  # Limit home directory depth
    find_cmd+="find \"$dir\" -mindepth 1 $depth_flag -type d 2>/dev/null; "
done

# Execute the find commands and pass output to fzf
selected=$(eval "$find_cmd" | fzf)

# Exit if nothing is selected
if [[ -z $selected ]]; then
    exit 0  # Exit script if no directory is selected
fi

# Generate a session name based on the selected directory
selected_name=$(basename "$selected" | tr . _)  # Replace dots with underscores to avoid conflicts

# Check if tmux is running
tmux_running=$(pgrep tmux)

# If tmux is not running and not inside a tmux session, start a new one
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s "$selected_name" -c "$selected"
    exit 0  # Exit script after starting tmux session
fi

# Check if the tmux session with the given name already exists
if ! tmux has-session -t="$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"  # Create a detached session if not exists
fi

# Switch to the selected tmux session
tmux switch-client -t "$selected_name"
