# Feature Implementation Plan: fix-runner-script-v3

## 📋 Todo Checklist
- [ ] Remove the `export -f` lines from the `runner.sh` script.
- [ ] Test the script to ensure the toggle and `ESC` key work correctly.
- [ ] Final Review and Testing

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
There are two main issues to address:
1.  **`yarn`/`npm` toggle not working and `export` error on `ESC`:** The `export -f` command is not supported in `zsh` and is causing both of these issues. In `zsh`, functions are available in subshells by default, so `export -f` is not needed. Removing these lines will fix the error and allow the `fzf` `reload` action to work correctly.

## 📝 Implementation Plan

### Prerequisites
- Ensure `tmux`, `zsh`, `fzf`, `gum`, and `jq` are installed and available in the environment.

### Step-by-Step Implementation
1.  **Step 1**: Remove the `export -f` lines from the `runner.sh` script.
    -   Files to modify: `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/runner.sh`
    -   Changes needed:
        -   Remove the lines `export -f get_yarn_scripts` and `export -f get_npm_scripts`.

### Testing Strategy
1.  Open `tmux`.
2.  Navigate to a directory containing a `package.json` file with scripts.
3.  Trigger the `custom_shpell` that runs the `runner.sh` script.
4.  Verify that the `fzf` popup appears with the list of scripts from `package.json`.
5.  Press `Ctrl-Y` and `Ctrl-J` to verify that the script list toggles between `yarn` and `npm`.
6.  Press `ESC` and verify that there are no errors.
7.  Select a script and verify that it runs in a new `tmux` window.

## 🎯 Success Criteria
- The `yarn`/`npm` toggle in the `fzf` menu works correctly.
- Pressing `ESC` in the `fzf` menu does not produce any errors.
- The `custom_shpell` popup is persistent and shows the output of the running script after being toggled off and on.
