#!/usr/bin/env zsh

# A script to launch a specific AI CLI tool with a user-selected tmux mode.
# It is designed to be called from a tmux keybinding.
#
# Usage: ai-tool <tool_name>
# e.g.,   ai-tool gemini

set -e

# --- Helper function to check if a command exists ---
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 1. Dependency Check
if ! command_exists fzf; then
    # Use a simple echo since this is a critical, pre-flight check
    gum_style "❌ Critical Error: 'fzf' is not installed. Please install it to use this script."
    # Use tmux display-message if possible to show the error without a popup
    if [ -n "$TMUX" ]; then
        tmux display-message "❌ Error: fzf is not installed. Please install it."
    fi
    exit 1
fi

# --- Configuration ---
POPUP_WIDTH="85%"
POPUP_HEIGHT="80%"
TOOL="$1"

# Get the current pane's working directory
CURRENT_PATH=$(tmux display-message -p "#{pane_current_path}")

if [ -z "$TOOL" ]; then
    gum_style "Usage: $0 <tool_name>" >&2
    gum_style "Available tools: gemini, opencode, claude, codex, qwen" >&2
    exit 1
fi

# --- Mode Selection ---
# Check if we are inside a tmux session
if [ -z "$TMUX" ]; then
    gum_style "Error: This script must be run from within a tmux session" >&2
    exit 1
fi

# Use fzf to let user select the launch mode
MODE=$(echo -e "popup\nsplit\nwindow" | fzf --prompt="Select AI tool launch mode: " --height=100% --header="Choose how to open $TOOL:")

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
        # Source zshrc to load aliases, then run opencode
        COMMAND="NODE_TLS_REJECT_UNAUTHORIZED=0 opencode"
        ;;

    claude)
        PANE_TITLE="✨ Anthropic Claude"
        # Replace with the actual command for your claude client
        COMMAND="claude"
        ;;

    codex)
        PANE_TITLE="🚀 GitHub Codex"
        # Replace with the actual command for your codex client
        COMMAND="codex"
        ;;

    qwen)
        PANE_TITLE="🧠 Qwen Code"
        # Replace with the actual command for your qwen client
        COMMAND="qwen"
        ;;

    *)
        tmux display-message "Error: Unknown AI tool '$TOOL'"
        exit 1
        ;;
esac

# --- Execution ---
# The final command wraps the tool's command in a new shell instance.
# Clear terminal, show launching message, run command, show closing message
FULL_COMMAND="$SHELL -c '
# Function to cleanup on exit
cleanup() {
    # Kill any background processes
    if [ ! -z \"\$TOOL_PID\" ]; then
        kill -TERM \$TOOL_PID 2>/dev/null || true
    fi
    exit
}

# Set up signal handlers
trap cleanup INT TERM EXIT

gum_style \"🚀 Launching $PANE_TITLE...\"
sleep 1
clear

# Change to the current pane directory
cd \"$CURRENT_PATH\" 2>/dev/null || true

# Handle different tools appropriately
if [ \"$TOOL\" = \"gemini\" ] || [ \"$TOOL\" = \"claude\" ] || [ \"$TOOL\" = \"codex\" ] || [ \"$TOOL\" = \"qwen\" ]; then
    # Run interactive AI tools in the foreground
    $COMMAND
else
    # For other tools, run in background with process control
    $COMMAND &
    TOOL_PID=\$!
    wait \$TOOL_PID 2>/dev/null || true
fi

echo
gum_style \"✨ AI session finished. Press any key to close...\"
read -k 1
'"

# Execute based on selected mode
case "$MODE" in
    popup)
        # Run command directly in the current popup (always the case now)
        # Function to cleanup on exit
        cleanup() {
            # Kill any background processes
            if [ ! -z "$TOOL_PID" ]; then
                kill -TERM $TOOL_PID 2>/dev/null || true
            fi
            exit
        }

        # Set up signal handlers
        trap cleanup INT TERM EXIT

        gum_style "🚀 Launching $PANE_TITLE..."
        sleep 1
        clear

        # Change to the current pane's directory
        cd "$CURRENT_PATH" 2>/dev/null || true

        # For interactive commands like Gemini and Claude, run in foreground
        if [ "$TOOL" = "gemini" ] || [ "$TOOL" = "claude" ] || [ "$TOOL" = "codex" ] || [ "$TOOL" = "qwen" ]; then
            # Run interactive AI tools in the foreground
            $COMMAND
        else
            # For other tools, run in background with process control
            $COMMAND &
            TOOL_PID=$!

            # Wait for the command to finish
            wait $TOOL_PID 2>/dev/null || true
        fi

        echo
        gum_style "✨ AI session finished. Press any key to close..."
        read -k 1
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
