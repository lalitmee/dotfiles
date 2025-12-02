#!/usr/bin/env zsh

SCRIPT_DIR=$(dirname "${(%):-%x}")
source "$SCRIPT_DIR/functions.sh"

package_json_path=$(pwd)/package.json
export package_json_path

selection=$(get_yarn_scripts | fzf --prompt="yarn> " --header="Project Runner" --header-first --height="100%" --layout=reverse --print-query \
    --bind "ctrl-y:transform:[[ ! $FZF_PROMPT =~ yarn ]] && echo \"change-prompt(yarn> )+reload(source $SCRIPT_DIR/functions.sh && get_yarn_scripts)\" || echo \"\"" \
    --bind "ctrl-j:transform:[[ ! $FZF_PROMPT =~ npm ]] && echo \"change-prompt(npm> )+reload(source $SCRIPT_DIR/functions.sh && get_npm_scripts)\" || echo \"\"")

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
    exit_code=$(echo $?)

    if [[ $exit_code -eq 0 ]]; then
        echo ""
        echo "✅ Command completed successfully"
    elif [[ $exit_code -eq 130 ]]; then
        echo ""
        echo "⚠️  Command was interrupted"
    else
        echo ""
        echo "❌ Command failed with exit code $exit_code"
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
