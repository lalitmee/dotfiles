#!/usr/bin/env zsh

# --- Script Argument Handling ---
CONTEXT_TYPE_LOWER="$1" # Get the first argument passed to the script

# If no argument is provided, default to "personal"
if [[ -z "$CONTEXT_TYPE_LOWER" ]]; then
    CONTEXT_TYPE_LOWER="personal"
    echo "No context type provided, defaulting to 'personal'." >&2
elif [[ "$CONTEXT_TYPE_LOWER" != "personal" && "$CONTEXT_TYPE_LOWER" != "work" ]]; then
    echo "Error: Invalid context type '$CONTEXT_TYPE_LOWER'. Must be 'personal' or 'work'." >&2
    exit 1
fi

# Convert the first letter to uppercase for the directory name (Zsh specific)
CONTEXT_TYPE_DIR="${(C)CONTEXT_TYPE_LOWER}"

# --- Configuration ---
PROJECTS_BASE_DIR="$HOME/Projects/$CONTEXT_TYPE_DIR/Github/second-brain/agenda/daily"
CURRENT_DATE=$(date +%Y-%m-%d)
TODO_FILE="$PROJECTS_BASE_DIR/$CURRENT_DATE.org"

TMUX_SESSION_NAME="daily_todo_${CONTEXT_TYPE_LOWER}"
NVIM_COMMAND="nvim"

# --- Tmux Popup Dimensions ---
POPUP_WIDTH="80%"
POPUP_HEIGHT="80%"
POPUP_POSITION="-xC -yC"

# --- Ensure the base directory exists ---
mkdir -p "$PROJECTS_BASE_DIR"

# --- Toggle Logic ---
# Check if the dedicated session for the popup already exists.
if tmux has-session -t "$TMUX_SESSION_NAME" 2>/dev/null; then
    # If it exists, kill the session. This will automatically close the popup.
    tmux kill-session -t "$TMUX_SESSION_NAME"
else
    # 1. Create a new, detached session that runs Neovim with the todo file.
    #    The command and its arguments are now passed separately. THIS IS THE FIX.
    tmux new-session -d -s "$TMUX_SESSION_NAME" "$NVIM_COMMAND" "$TODO_FILE"

    # 2. Display the main pane from our new session as a popup.
    tmux display-popup \
        -d "#{pane_current_path}" \
        -w "$POPUP_WIDTH" \
        -h "$POPUP_HEIGHT" \
        $POPUP_POSITION \
        -T "Daily Todo - $CONTEXT_TYPE_LOWER" \
        -t "${TMUX_SESSION_NAME}:0.0"
fi
