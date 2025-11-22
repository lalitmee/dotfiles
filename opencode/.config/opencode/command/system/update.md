---
description: Run system updates
agent: run
---

## Mission: System Update

Your task is to update the system packages and configuration.

### Workflow:

1.  **Run Main Installer**:

    - Execute the main installer script: `~/dotfiles/scripts/install/main-installer.zsh`.
    - This script handles package updates and configuration syncing.

2.  **Package Manager Update (Optional)**:
    - If specifically requested, run `sudo pacman -Syu` (or appropriate command for the OS).
    - **Note**: Prefer the main installer as it ensures consistency.

### QUESTION:

$ARGUMENTS
