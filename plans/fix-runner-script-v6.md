# Feature Implementation Plan: fix-runner-script-v6

## 📋 Todo Checklist
- [x] ✅ Create `get_yarn_scripts.sh` and `get_npm_scripts.sh` scripts.
- [x] ✅ Refactor the `fzf` command in `runner.sh` to use the new scripts.
- [ ] ⏳ Test the script to ensure the toggle works correctly.
- [ ] ⏳ Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The relevant file is `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/runner.sh`. This script is a standalone shell script that uses `fzf`, `gum`, and `jq` to create a project runner within `tmux`.

### Current Architecture
The script is executed within a `tmux` session through a keybinding that invokes `custom_shpell` from the `tmux-grimoire` plugin. The script itself is responsible for reading `package.json`, presenting a list of scripts using `fzf`, and then executing the selected script in a new `tmux` window.

### Dependencies & Integration Points
- **tmux**: The script is designed to run inside `tmux`.
- **tmux-grimoire**: The `custom_shpell` command is used to launch the script in a popup.
- **zsh**: The script is written for `zsh`.
- **fzf**: Used for the interactive script selection menu.
- **gum**: Used for styling the output.
- **jq**: Used for parsing `package.json`.

### Considerations & Challenges
The main issue is that the `yarn`/`npm` toggle is not working. This is because the `reload` action in `fzf` is not able to find the shell functions defined in the `runner.sh` script. The solution is to create separate scripts for the `yarn` and `npm` commands and call them from the `fzf` `reload` action.

## 📝 Implementation Plan

### Prerequisites
- Ensure `tmux`, `zsh`, `fzf`, `gum`, and `jq` are installed and available in the environment.

### Step-by-Step Implementation
1.  **Step 1**: Create `get_yarn_scripts.sh` and `get_npm_scripts.sh` scripts.
    -   Create a new file named `get_yarn_scripts.sh` in the same directory as `runner.sh` with the following content:
        ```bash
        #!/usr/bin/env zsh
        package_json_path=$(pwd)/package.json
        (echo 'yarn install'; jq -r '.scripts | keys[]' "$package_json_path" | awk '{print "yarn " $0}')
        ```
    -   Create a new file named `get_npm_scripts.sh` in the same directory as `runner.sh` with the following content:
        ```bash
        #!/usr/bin/env zsh
        package_json_path=$(pwd)/package.json
        (echo 'npm install'; jq -r '.scripts | keys[]' "$package_json_path" | awk '{print "npm run " $0}')
        ```
    -   Make the new scripts executable: `chmod +x get_yarn_scripts.sh get_npm_scripts.sh`

2.  **Step 2**: Refactor the `fzf` command in `runner.sh` to use the new scripts.
    -   Files to modify: `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/runner.sh`
    -   Changes needed:
        -   Remove the `get_yarn_scripts` and `get_npm_scripts` functions from the script.
        -   Update the `fzf` command to call the new scripts in the `reload` action.

### Testing Strategy
1.  Open `tmux`.
2.  Navigate to a directory containing a `package.json` file with scripts.
3.  Trigger the `custom_shpell` that runs the `runner.sh` script.
4.  Verify that the `fzf` popup appears with the list of scripts from `package.json`.
5.  Press `Ctrl-Y` and `Ctrl-J` to verify that the script list toggles between `yarn` and `npm`.
6.  Select a script and verify that it runs in a new `tmux` window.

## 🎯 Success Criteria
- The `yarn`/`npm` toggle in the `fzf` menu works correctly.
