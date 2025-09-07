#!/usr/bin/env zsh

# A script to launch a specific AI CLI tool in a tmux popup.
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
# The `read` command keeps the popup open after the main command exits,
# allowing you to read the output before it vanishes.
FULL_COMMAND="$SHELL -c 'echo \"🚀 Launching $PANE_TITLE...\"; echo; $COMMAND; echo; read -n 1 -s -r -p \"✨ AI session finished. Press any key to close...\"'"

# Check if we are inside a tmux session before trying to create a popup
if [ -n "$TMUX" ]; then
    # The '|| true' at the end is the critical fix.
    # It ensures that even if the command inside the popup exits with an error
    # (like from Ctrl+C), the script itself exits cleanly with status 0.
    tmux popup \
        -d '#{pane_current_path}' \
        -w "$POPUP_WIDTH" \
        -h "$POPUP_HEIGHT" \
        -E \
        -T "$PANE_TITLE" \
        "$FULL_COMMAND" || true
else
    # Fallback for when not in tmux
    echo "Not inside a Tmux session. Running command directly:"
    eval "$COMMAND"
fi
