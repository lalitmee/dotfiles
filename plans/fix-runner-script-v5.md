# Feature Implementation Plan: fix-runner-script-v5

## 📋 Todo Checklist
- [x] ✅ Refactor the `fzf` command in `runner.sh` to use the `transform` action for toggling.
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
The main issue is that the `yarn`/`npm` toggle is not working. This is because the `reload` action in `fzf` is not able to find the `get_yarn_scripts` and `get_npm_scripts` functions. The solution is to use `fzf`'s `transform` action to dynamically change the prompt and the `reload` command based on the current state, which can be stored in the prompt itself.

## 📝 Implementation Plan

### Prerequisites
- Ensure `tmux`, `zsh`, `fzf`, `gum`, and `jq` are installed and available in the environment.

### Step-by-Step Implementation
1.  **Step 1**: Refactor the `fzf` command in `runner.sh` to use the `transform` action for toggling.
    -   Files to modify: `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/runner.sh`
    -   Changes needed:
        -   Update the `fzf` command to use the `transform` action for the `ctrl-y` and `ctrl-j` bindings. The prompt will be used to store the current state (`yarn` or `npm`).

### Testing Strategy
1.  Open `tmux`.
2.  Navigate to a directory containing a `package.json` file with scripts.
3.  Trigger the `custom_shpell` that runs the `runner.sh` script.
4.  Verify that the `fzf` popup appears with the list of scripts from `package.json`.
5.  Press `Ctrl-Y` and `Ctrl-J` to verify that the script list toggles between `yarn` and `npm`.
6.  Select a script and verify that it runs in a new `tmux` window.

## 🎯 Success Criteria
- The `yarn`/`npm` toggle in the `fzf` menu works correctly.