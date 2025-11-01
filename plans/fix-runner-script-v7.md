# Feature Implementation Plan: fix-runner-script-v7

## 📋 Todo Checklist
- [x] ✅ Refactor `runner.sh` to use absolute paths for the scripts.
- [ ] ⏳ Test the script to ensure the toggle works correctly.
- [ ] ⏳ Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The relevant files are in `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/`. The main script is `runner.sh`, which calls `get_yarn_scripts.sh` and `get_npm_scripts.sh`.

### Current Architecture
The `runner.sh` script is executed within a `tmux` session through a keybinding that invokes `custom_shpell` from the `tmux-grimoire` plugin. The script uses `fzf` to present a list of scripts to run.

### Dependencies & Integration Points
- **tmux**: The script is designed to run inside `tmux`.
- **tmux-grimoire**: The `custom_shpell` command is used to launch the script in a popup.
- **zsh**: The script is written for `zsh`.
- **fzf**: Used for the interactive script selection menu.
- **gum**: Used for styling the output.
- **jq**: Used for parsing `package.json`.

### Considerations & Challenges
The main issue is that the `runner.sh` script is not being run from the directory where the `get_yarn_scripts.sh` and `get_npm_scripts.sh` scripts are located. This is causing a "no such file or directory" error. The solution is to use absolute paths to the scripts to ensure they can be found regardless of the working directory.

## 📝 Implementation Plan

### Prerequisites
- Ensure `tmux`, `zsh`, `fzf`, `gum`, and `jq` are installed and available in the environment.

### Step-by-Step Implementation
1.  **Step 1**: Refactor `runner.sh` to use absolute paths for the scripts.
    -   Files to modify: `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/runner.sh`
    -   Changes needed:
        -   Update the `fzf` command to use the absolute paths for `get_yarn_scripts.sh` and `get_npm_scripts.sh`.

### Testing Strategy
1.  Open `tmux`.
2.  Navigate to a directory containing a `package.json` file with scripts.
3.  Trigger the `custom_shpell` that runs the `runner.sh` script.
4.  Verify that the `fzf` popup appears with the list of scripts from `package.json`.
5.  Press `Ctrl-Y` and `Ctrl-J` to verify that the script list toggles between `yarn` and `npm`.
6.  Select a script and verify that it runs in a new `tmux` window.

## 🎯 Success Criteria
- The `yarn`/`npm` toggle in the `fzf` menu works correctly.
- The script runs without any "no such file or directory" errors.