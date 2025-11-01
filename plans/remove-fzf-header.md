# Feature Implementation Plan: remove-fzf-header

## 📋 Todo Checklist
- [x] ✅ Remove the `FZF_HEADER` from the `runner.sh` script.
- [ ] ⏳ Test the script to ensure the header is removed.
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
The user wants to remove the header from the `fzf` popup. This is a straightforward change that involves removing the `FZF_HEADER` variable and the `--header` option from the `fzf` command.

## 📝 Implementation Plan

### Prerequisites
- Ensure `tmux`, `zsh`, `fzf`, `gum`, and `jq` are installed and available in the environment.

### Step-by-Step Implementation
1.  **Step 1**: Remove the `FZF_HEADER` from the `runner.sh` script.
    -   Files to modify: `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/runner.sh`
    -   Changes needed:
        -   Remove the `FZF_HEADER` variable definition.
        -   Remove the `--header="$FZF_HEADER"` and `--header-first` options from the `fzf` command.

### Testing Strategy
1.  Open `tmux`.
2.  Navigate to a directory containing a `package.json` file with scripts.
3.  Trigger the `custom_shpell` that runs the `runner.sh` script.
4.  Verify that the `fzf` popup appears without the header.

## 🎯 Success Criteria
- The `fzf` popup appears without the header.