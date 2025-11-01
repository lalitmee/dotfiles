# Feature Implementation Plan: fix-runner-script

## 📋 Todo Checklist
- [x] ✅ Modify the shebang line in the runner script.
- [ ] ⏳ Test the script to ensure it runs correctly.
- [ ] ⏳ Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The relevant file is `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/runner.sh`. This script is a standalone shell script that uses `fzf`, `gum`, and `jq` to create a project runner within `tmux`.

### Current Architecture
The script is executed within a `tmux` session, likely through a keybinding that invokes `custom_shpell` from the `tmux-grimoire` plugin. The script itself is responsible for reading `package.json`, presenting a list of scripts using `fzf`, and then executing the selected script in a new `tmux` window.

### Dependencies & Integration Points
- **tmux**: The script is designed to run inside `tmux`.
- **tmux-grimoire**: The `custom_shpell` command is used to launch the script in a popup.
- **zsh**: The script is written for `zsh`.
- **fzf**: Used for the interactive script selection menu.
- **gum**: Used for styling the output.
- **jq**: Used for parsing `package.json`.

### Considerations & Challenges
The main challenge is the incorrect shebang line, which is causing the script to fail. The error messages clearly indicate that `env` is not parsing the shebang correctly. The fix is straightforward and involves adding the `-S` option to the `env` command in the shebang.

It is important to keep the `-i` flag in the shebang (`#!/usr/bin/env -S zsh -i`). This flag ensures that `zsh` runs as an interactive shell, which means it will source the user's `.zshrc` and other startup files. This is crucial because the script depends on `fzf`, `gum`, and `jq`, and the paths to these tools are likely configured in the user's shell startup files. Without the `-i` flag, the script might fail with "command not found" errors.

## 📝 Implementation Plan

### Prerequisites
- Ensure `tmux`, `zsh`, `fzf`, `gum`, and `jq` are installed and available in the environment.

### Step-by-Step Implementation
1. **Step 1**: Modify the shebang line in the runner script.
   - Files to modify: `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/runner.sh`
   - Changes needed:
     - **From**: `#!/usr/bin/env zsh -i`
     - **To**: `#!/usr/bin/env -S zsh -i`

### Testing Strategy
1.  Open `tmux`.
2.  Navigate to a directory containing a `package.json` file with scripts.
3.  Trigger the `custom_shpell` that runs the `runner.sh` script (the user will know the keybinding).
4.  Verify that the `fzf` popup appears with the list of scripts from `package.json`.
5.  Select a script and verify that it runs in a new `tmux` window.

## 🎯 Success Criteria
The `runner.sh` script executes successfully within the `custom_shpell` popup, displaying the `fzf` menu and running the selected script without any shebang-related errors.
