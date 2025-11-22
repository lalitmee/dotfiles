---
description: Update dotfiles from remote and run install scripts
agent: run
---

## Mission: Update Dotfiles

Your task is to update the user's dotfiles repository from the remote and ensure the system is in sync.

### Workflow:

1.  **Pull Changes**:

    - Navigate to the dotfiles directory: `~/dotfiles`.
    - Run `git pull` to fetch and merge changes from the remote.

2.  **Run Installer**:

    - Execute the main installer script to apply changes: `./scripts/install/main-installer.zsh`.
    - If the installer fails, report the error to the user.

3.  **Reload Configuration**:
    - Reload shell configuration if necessary (e.g., `source ~/.zshrc`).
    - Reload tmux configuration if changes were made to tmux files: `tmux source ~/.tmux.conf`.

### QUESTION:

$ARGUMENTS
