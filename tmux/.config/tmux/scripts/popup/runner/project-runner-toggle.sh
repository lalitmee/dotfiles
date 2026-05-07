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

# Create the script that will run in the new window
temp_script=$(mktemp)
cat > "$temp_script" <<EOF
    tmux setw allow-rename off 2>/dev/null
    trap 'echo ""; echo "Process interrupted. Press Enter to close the window."; read; exit' INT
    echo "Running: $command_to_run"
    echo "───────────────────────────────────"
    cd "$package_json_path:h"
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

# Create a background setup script that creates the tmux window
local setup_script=$(mktemp)
cat > "$setup_script" <<SETUPEOF
#!/usr/bin/env zsh
tmux new-window -n "$clean_name" "zsh $temp_script"
rm -f "$temp_script" "$setup_script"
SETUPEOF

chmod +x "$setup_script"
tmux run-shell -b "zsh $setup_script"
# -------------------------------------------------------------------
