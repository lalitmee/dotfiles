#!/usr/bin/env zsh

# A robust script to launch a specific AI CLI tool in a user-selected tmux layout.
# It avoids nested shells and executes commands directly for speed and reliability.

set -e

# --- ANSI Color Definitions ---
COLOR_YELLOW=$'\033[38;5;227m'  # Cobalt2 Yellow
RESET_COLOR=$'\033[0m'

# 1. Dependency & Argument Check
# =================================
if ! command -v fzf >/dev/null 2>&1;
then
    tmux display-message "❌ Error: fzf is not installed."
    exit 1
fi

TOOL="$1"
if [ -z "$TOOL" ]; then
    tmux display-message "❌ Usage: $0 <tool_name>"
    exit 1
fi

# 2. Tool Configuration
# =======================
# Define the command and title for each tool.
# IMPORTANT: The command must be a direct executable or a full path.
# Aliases will not work here unless sourced, but direct commands are preferred.
case "$TOOL" in
    gemini)
        ICON="🤖"; PANE_TITLE="$ICON gemini"
        COMMAND="gemini"
        ;;
    opencode)
        ICON="🧑‍💻"; PANE_TITLE="$ICON openCode"
        # This command sets an environment variable just for this process.
        COMMAND="NODE_TLS_REJECT_UNAUTHORIZED=0 opencode"
        ;;
    claude)
        ICON="✨"; PANE_TITLE="$ICON claude-code"
        COMMAND="claude"
        ;;
    codex)
        ICON="🚀"; PANE_TITLE="$ICON codex"
        COMMAND="codex"
        ;;
    qwen)
        ICON="🧠"; PANE_TITLE="$ICON qwen"
        COMMAND="qwen"
        ;;
    copilot)
        ICON=" "; PANE_TITLE="$ICON copilot"
        COMMAND="copilot --banner"
        ;;
    *)
        tmux display-message "❌ Error: Unknown AI tool '$TOOL'"
        exit 1
        ;;
esac

# 3. Layout Selection
# =====================
# The script is already in a popup. Use fzf to choose the final layout.
FZF_HEADER="Choose layout for $ICON ${COLOR_YELLOW}${TOOL}${RESET_COLOR}:"
MODE=$(echo -e "popup\nsplit\nwindow" | fzf --height=5 --header="$FZF_HEADER" --ansi)

if [ -z "$MODE" ]; then
    # User pressed ESC, exit cleanly.
    exit 0
fi

# 4. Execution
# ==============
# Execute the chosen command in the selected layout.
case "$MODE" in
    popup)
        # For popup mode, we are already in the popup.
        # Replace the current shell process with the tool's process.
        # This is extremely efficient. When the tool exits, the popup will close.
        eval exec "$COMMAND"
        ;;
    split)
        # Tell tmux to create a new split and run the command within it.
        # This inherits the correct user environment.
        tmux split-window -h -c "#{pane_current_path}" "$COMMAND"
        ;;
    window)
        # Tell tmux to create a new window and run the command within it.
        tmux new-window -n "$PANE_TITLE" -c "#{pane_current_path}" "$COMMAND"
        ;;
esac
