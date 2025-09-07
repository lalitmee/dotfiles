#!/usr/bin/env zsh

# A script to launch a specific AI CLI tool with user-selected tmux mode.
# It is designed to be called from a tmux keybinding.
#
# Usage: ai-tool <tool_name>
# e.g.,   ai-tool gemini

set -e

# --- Configuration ---
POPUP_WIDTH="85%"
POPUP_HEIGHT="80%"
TOOL="$1"

if [ -z "$TOOL" ]; then
    echo "Usage: $0 <tool_name>" >&2
    echo "Available tools: gemini, opencode, claude" >&2
    exit 1
fi

# --- Mode Selection ---
# Check if we are inside a tmux session
if [ -z "$TMUX" ]; then
    echo "Error: This script must be run from within a tmux session" >&2
    exit 1
fi

# Use fzf to let user select the launch mode
MODE=$(echo -e "popup\nsplit\nwindow" | fzf --prompt="Select AI tool launch mode: " --height=10 --border --header="Choose how to open $TOOL:")

# Exit if no selection made
if [ -z "$MODE" ]; then
    tmux display-message "AI tool launch cancelled"
    exit 0
fi

# --- Tool Definitions ---
# Each case defines the title of the popup and the command to be executed.
# Adjust the commands to match how you have the CLIs installed.
case "$TOOL" in
    gemini)
        PANE_TITLE="🤖 Google Gemini"
        # Assuming gemini is installed and accessible in your PATH
        COMMAND="gemini"
        ;;

    opencode)
        PANE_TITLE="🧑‍💻 OpenCode"
        # Replace with the actual command for opencode
        COMMAND="opencode"
        ;;

    claude)
        PANE_TITLE="✨ Anthropic Claude"
        # Replace with the actual command for your claude client
        COMMAND="claude"
        ;;

    *)
        tmux display-message "Error: Unknown AI tool '$TOOL'"
        exit 1
        ;;
esac

# --- Execution ---
# The final command wraps the tool's command in a new shell instance.
# The `read` command keeps the session open after the main command exits,
# allowing you to read the output before it vanishes.
FULL_COMMAND="$SHELL -c 'echo \"🚀 Launching $PANE_TITLE...\"; echo; $COMMAND; echo; read -n 1 -s -r -p \"✨ AI session finished. Press any key to close...\"'"

# Execute based on selected mode
case "$MODE" in
    popup)
        # Launch in tmux popup (original behavior)
        tmux popup \
            -d '#{pane_current_path}' \
            -w "$POPUP_WIDTH" \
            -h "$POPUP_HEIGHT" \
            -E \
            -T "$PANE_TITLE" \
            "$FULL_COMMAND" || true
        ;;

    split)
        # Launch in a new split pane
        tmux split-window \
            -c '#{pane_current_path}' \
            -h \
            -p 50 \
            "$FULL_COMMAND" || true
        ;;

    window)
        # Launch in a new window
        tmux new-window \
            -c '#{pane_current_path}' \
            -n "$PANE_TITLE" \
            "$FULL_COMMAND" || true
        ;;

    *)
        tmux display-message "Error: Unknown mode '$MODE'"
        exit 1
        ;;
esac
