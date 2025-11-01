# Feature Implementation Plan: fix-runner-script-v8

## 📋 Todo Checklist
- [x] ✅ Create a single `get_all_scripts.sh` script.
- [x] ✅ Refactor `runner.sh` to use the new script and remove the toggle bindings.
- [ ] ⏳ Test the script to ensure it works correctly.
- [ ] ⏳ Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The relevant file is `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/runner.sh`. This script is a standalone shell script that uses `fzf`, `gum`, and `jq` to create a project runner within `tmux`.

### Current Architecture
The script is executed within a `tmux` session through a keybinding that invokes `custom_shpell` from the `tmux-grimoire` plugin. The script uses `fzf` to present a list of scripts to run.

### Dependencies & Integration Points
- **tmux**: The script is designed to run inside `tmux`.
- **tmux-grimoire**: The `custom_shpell` command is used to launch the script in a popup.
- **zsh**: The script is written for `zsh`.
- **fzf**: Used for the interactive script selection menu.
- **gum**: Used for styling the output.
- **jq**: Used for parsing `package.json`.

### Considerations & Challenges
The main issue is that the `yarn`/`npm` toggle is not working. This is because the `reload` action in `fzf` is not able to find the shell functions or scripts in the subshell it creates. The solution is to use a more robust method of calling the scripts from `fzf`.

## 📝 Implementation Plan

### Option 1: One Last Try at the Toggle (Recommended)

This approach is more robust and addresses the root cause of the problem more directly.

1.  **Step 1**: Create a single `get_scripts.sh` script.
    -   Create a new file named `get_scripts.sh` in the same directory as `runner.sh` with the following content:
        ```bash
        #!/usr/bin/env zsh

        package_json_path=$(pwd)/package.json

        if [[ "$1" == "yarn" ]]; then
          (echo 'yarn install'; jq -r '.scripts | keys[]' "$package_json_path" | awk '{print "yarn " $0}')
        elif [[ "$1" == "npm" ]]; then
          (echo 'npm install'; jq -r '.scripts | keys[]' "$package_json_path" | awk '{print "npm run " $0}')
        fi
        ```
    -   Make the new script executable: `chmod +x get_scripts.sh`

2.  **Step 2**: Refactor `runner.sh` to use the new script.
    -   Files to modify: `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/runner.sh`
    -   Changes needed:
        -   Remove the `get_yarn_scripts.sh` and `get_npm_scripts.sh` files.
        -   Update the `fzf` command to call the new `get_scripts.sh` script with the appropriate argument in the `reload` action.

### Option 2: Combine `yarn` and `npm` Scripts

If you'd prefer to abandon the toggle, this option will display all `yarn` and `npm` scripts in a single, unified list.

1.  **Step 1**: Create a single `get_all_scripts.sh` script.
    -   Create a new file named `get_all_scripts.sh` in the same directory as `runner.sh` with the following content:
        ```bash
        #!/usr/bin/env zsh

        package_json_path=$(pwd)/package.json

        (echo 'yarn install'; jq -r '.scripts | keys[]' "$package_json_path" | awk '{print "yarn " $0}')
        (echo 'npm install'; jq -r '.scripts | keys[]' "$package_json_path" | awk '{print "npm run " $0}')
        ```
    -   Make the new script executable: `chmod +x get_all_scripts.sh`

2.  **Step 2**: Refactor `runner.sh` to use the new script.
    -   Files to modify: `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/runner.sh`
    -   Changes needed:
        -   Remove the `get_yarn_scripts.sh` and `get_npm_scripts.sh` files.
        -   Update the `fzf` command to call the new `get_all_scripts.sh` script and remove the toggle bindings.

### Testing Strategy
1.  Open `tmux`.
2.  Navigate to a directory containing a `package.json` file with scripts.
3.  Trigger the `custom_shpell` that runs the `runner.sh` script.
4.  Verify that the `fzf` popup appears with the list of scripts from `package.json`.
5.  If Option 1 was chosen, press `Ctrl-Y` and `Ctrl-J` to verify that the script list toggles between `yarn` and `npm`.
6.  Select a script and verify that it runs in a new `tmux` window.

## 🎯 Success Criteria
- The script runs without any errors.
- If Option 1 was chosen, the `yarn`/`npm` toggle in the `fzf` menu works correctly.
- If Option 2 was chosen, the `fzf` menu displays a combined list of `yarn` and `npm` scripts.
