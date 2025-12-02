#!/usr/bin/env -S zsh -i

# -------------------------------------------------------------------
# Prerequisites
# -------------------------------------------------------------------
# This script requires `jq`, `fzf`, and `gum` to be installed.
# brew install jq fzf gum
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Configuration
# -------------------------------------------------------------------



# Removed status emojis and registry
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Helper Functions
# -------------------------------------------------------------------








# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Script Logic
# -------------------------------------------------------------------

# Check if running inside tmux
if [[ -z "$TMUX" ]]; then
    gum_style "❌ Error: This script must be run inside a tmux session."
    exit 1
fi

if [[ ! -f "package.json" ]]; then
    gum_style "❌ Error: package.json not found in the current directory."
    sleep 2
    exit 1
fi

current_pane_path=$(tmux display-message -p '#{pane_current_path}' 2>/dev/null || pwd)
package_json_path="$current_pane_path/package.json"
export package_json_path current_pane_path

# Source the functions for script retrieval
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/functions.sh"

selection=$(get_all_scripts | fzf --prompt="Select a script to run > " --height="100%" --layout=reverse --print-query)

if [[ -z $selection ]]; then
    exit 0
fi

query=$(echo "$selection" | head -n 1)
command_to_run=$(echo "$selection" | tail -n 1)

if [[ -z $command_to_run && -n $query ]]; then
    command_to_run=$query
fi

# Get names
clean_name="${command_to_run// /-}"

# Display what we're doing
clear
gum_style "🚀 Creating window for: $command_to_run"

# Create persistent window for the process
temp_script=$(mktemp)
cat > "$temp_script" <<EOF
    tmux setw allow-rename off 2>/dev/null
    trap 'echo ""; echo "Process interrupted. Press Enter to close the window."; read; exit' INT
    echo "Running: $command_to_run"
    echo "Directory: $current_pane_path"
    echo "───────────────────────────────────"
    $command_to_run
    exit_code=\$?

    if [[ \$exit_code -eq 0 ]]; then
        echo ""
        echo "✅ Command completed successfully"
    elif [[ \$exit_code -eq 130 ]]; then
        echo ""
        echo "⚠️  Command was interrupted"
    else
        echo ""
        echo "❌ Command failed with exit code \$exit_code"
    fi
    echo ""
    echo "Press Ctrl-D or 'exit' to close this window..."
    exec zsh
EOF

tmux new-window "zsh $temp_script"

local window_id=$(tmux display-message -p '#I')
local final_name="$clean_name"
tmux rename-window -t "$window_id" "$final_name"

gum style --bold --foreground="green" "✅ Window created: $final_name"

echo ""
gum style --bold "Window management:"
echo "• Switch to window: C-a <window_index>"
echo "• List windows: C-a w"
echo "• Close window: C-a & (when in the window)"
# -------------------------------------------------------------------
