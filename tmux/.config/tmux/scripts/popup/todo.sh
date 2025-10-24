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

NVIM_COMMAND="nvim"

# --- Ensure the base directory exists ---
mkdir -p "$PROJECTS_BASE_DIR"

# --- Execute Neovim ---
exec "$NVIM_COMMAND" "$TODO_FILE"
