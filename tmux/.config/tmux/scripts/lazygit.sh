#!/usr/bin/env zsh

# -------------------------------------------------------------------
# NOTE: Script Logic {{{
# -------------------------------------------------------------------

# --- Step 1: Find any existing lazygit popup pane ---
# We scan all panes across all sessions (-a) and check the command running in them.
# The -w flag on grep ensures we match the whole word 'lazygit' and not something else.
LAZYGIT_PANE_ID=$(tmux list-panes -a -F "#{pane_id} #{pane_current_command}" | grep -w lazygit | awk '{print $1}')

# --- Step 2: Execute the Toggle Logic ---
if [[ -n "$LAZYGIT_PANE_ID" ]]; then
    # --- Dismiss Action ---
    # If a lazygit pane is found, kill it directly. This closes the popup.
    tmux kill-pane -t "$LAZYGIT_PANE_ID"
else
    # --- Summon Action ---
    # Get the path from the tmux binding argument.
    PANE_PATH="$1"
    if [[ -z "$PANE_PATH" ]]; then
        exit 1
    fi

    # Check if the path is a git repository.
    is_git_repo=$(cd "$PANE_PATH" && git rev-parse --is-inside-work-tree 2>/dev/null)

    if [[ "$is_git_repo" != "true" ]]; then
        # Not a git repo: Show a message and exit.
        gum style --padding="1 2" --border=double --border-foreground=212 \
            "🤔 Whoops! Not a git repo, my friend." \
            "Try again from a project directory."
        sleep 2
        exit 0
    fi

    # If it is a git repo, create the popup running lazygit directly.
    # When you quit lazygit ('q'), this command finishes, and the popup closes.
    tmux popup -d "$PANE_PATH" -xC -yC -w"100%" -h"100%" -E "lazygit"
fi
# }}}
# -------------------------------------------------------------------
