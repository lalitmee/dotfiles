#!/usr/bin/env zsh -i

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

package_json_path=$(pwd)/package.json

yarn_cmd="(echo 'yarn install'; jq -r '.scripts | keys[]' \"$package_json_path\" | awk '{print \"yarn \" \$0}')"
npm_cmd="(echo 'npm install'; jq -r '.scripts | keys[]' \"$package_json_path\" | awk '{print \"npm run \" \$0}')"

FZF_HEADER="───────────────────────────────────
  ✨ Project Runner ✨
  Ctrl-Y: Yarn | Ctrl-J: Npm
  Enter: Create Window | Type & press Enter for custom command
  🚀 Long processes → Dedicated windows
  🔨 Short processes → Windows with completion status
───────────────────────────────────"

selection=$(eval "$yarn_cmd" | fzf --prompt="Select a script to run > " --header="$FZF_HEADER" --header-first --height="100%" --layout=reverse --print-query --bind "ctrl-y:reload($yarn_cmd)" --bind "ctrl-j:reload($npm_cmd)")

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