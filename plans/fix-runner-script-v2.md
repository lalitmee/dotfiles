# Feature Implementation Plan: fix-runner-script-v2

## 📋 Todo Checklist
- [x] ✅ Refactor the `runner.sh` script to use functions for `fzf` reloading.
- [ ] ⏳ Advise the user on how to modify their `tmux.conf` to make the `custom_shpell` persistent.
- [ ] ⏳ Test the script and the `custom_shpell` to ensure everything works as expected.
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
There are two main issues to address:
1.  **`yarn`/`npm` toggle not working:** The `eval` command is being called outside of `fzf`'s `reload` action, which prevents the dynamic reloading of the script list. The solution is to use shell functions and pass them to `fzf`'s `reload` action.
2.  **`custom_shpell` not persisting:** The user is likely using an `ephemeral` `custom_shpell`. The solution is to change the `custom_shpell` type to `standard` in their `tmux.conf` and ensure the `--replay` flag is not being used.

## 📝 Implementation Plan

### Prerequisites
- Ensure `tmux`, `zsh`, `fzf`, `gum`, and `jq` are installed and available in the environment.

### Step-by-Step Implementation
1.  **Step 1**: Refactor the `runner.sh` script to use functions for `fzf` reloading.
    -   Files to modify: `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/runner.sh`
    -   Changes needed:
        -   Replace the `yarn_cmd` and `npm_cmd` variables with shell functions.
        -   Update the `fzf` command to use the new functions for the initial command and the `reload` bindings.

2.  **Step 2**: Advise the user on how to modify their `tmux.conf` to make the `custom_shpell` persistent.
    -   This step is for the user to perform.
    -   The user should find the `custom_shpell` command in their `tmux.conf` that is bound to `C-a C-d r`.
    -   They should change the `custom_shpell` type from `ephemeral` to `standard`.
    -   They should also ensure that the `--replay` flag is not present in the command.

### Testing Strategy
1.  Open `tmux`.
2.  Navigate to a directory containing a `package.json` file with scripts.
3.  Trigger the `custom_shpell` that runs the `runner.sh` script.
4.  Verify that the `fzf` popup appears with the list of scripts from `package.json`.
5.  Press `Ctrl-Y` and `Ctrl-J` to verify that the script list toggles between `yarn` and `npm`.
6.  Select a script and verify that it runs in a new `tmux` window.
7.  Toggle the `custom_shpell` popup off and on and verify that the output of the running script is still visible.

## 🎯 Success Criteria
- The `yarn`/`npm` toggle in the `fzf` menu works correctly.
- The `custom_shpell` popup is persistent and shows the output of the running script after being toggled off and on.