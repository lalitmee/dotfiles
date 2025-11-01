# Feature Implementation Plan: project-runner-toggle-v2

## 📋 Todo Checklist
- [x] ✅ Create a `functions.sh` file.
- [x] ✅ Create the `project-runner-toggle.sh` script with dynamic path resolution.
- [ ] ⏳ Test the new script to ensure the toggle works correctly.
- [ ] ⏳ Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
This plan involves creating two new files in the `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/` directory: `functions.sh` and `project-runner-toggle.sh`.

### Current Architecture
The existing `runner.sh` script will be replaced by the new `project-runner-toggle.sh` script. The logic for getting the `yarn` and `npm` scripts will be moved to the `functions.sh` file.

### Dependencies & Integration Points
- **tmux**: The script is designed to run inside `tmux`.
- **tmux-grimoire**: The `custom_shpell` command is used to launch the script in a popup.
- **zsh**: The script is written for `zsh`.
- **fzf**: Used for the interactive script selection menu.
- **gum**: Used for styling the output.
- **jq**: Used for parsing `package.json`.

### Considerations & Challenges
The main challenge has been making the `get_yarn_scripts` and `get_npm_scripts` functions available to the `fzf` `reload` action. This new approach solves this by explicitly sourcing the `functions.sh` file in the `reload` action, and it avoids hardcoding absolute paths by dynamically determining the script's directory.

## 📝 Implementation Plan

### Prerequisites
- Ensure `tmux`, `zsh`, `fzf`, `gum`, and `jq` are installed and available in the environment.

### Step-by-Step Implementation
1.  **Step 1**: Create a `functions.sh` file.
    -   Create a new file named `functions.sh` in the `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/` directory with the following content:
        ```bash
        #!/usr/bin/env zsh

        get_yarn_scripts() {
            (echo 'yarn install'; jq -r '.scripts | keys[]' "$package_json_path" | awk '{print "yarn " $0}')
        }

        get_npm_scripts() {
            (echo 'npm install'; jq -r '.scripts | keys[]' "$package_json_path" | awk '{print "npm run " $0}')
        }
        ```

2.  **Step 2**: Create the `project-runner-toggle.sh` script.
    -   Create a new file named `project-runner-toggle.sh` in the same directory with the following content:
        ```bash
        #!/usr/bin/env -S zsh -i

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
            exit_code=\$?

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
        ```
    -   Make the new script executable: `chmod +x project-runner-toggle.sh`

### Testing Strategy
1.  Open `tmux`.
2.  Navigate to a directory containing a `package.json` file with scripts.
3.  Trigger the `custom_shpell` that runs the `project-runner-toggle.sh` script.
4.  Verify that the `fzf` popup appears with the list of scripts from `package.json`.
5.  Press `Ctrl-Y` and `Ctrl-J` to verify that the script list toggles between `yarn` and `npm`.
6.  Select a script and verify that it runs in a new `tmux` window.

## 🎯 Success Criteria
- The `yarn`/`npm` toggle in the `fzf` menu works correctly.
- The script runs without any errors.
