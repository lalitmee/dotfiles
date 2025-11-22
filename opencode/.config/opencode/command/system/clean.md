---
description: Clean up system caches and orphan packages
agent: run
---

## Mission: System Clean

Your task is to clean up the system to free up space and remove unused packages.

### Workflow:

1.  **Clean Package Cache**:

    - Run `sudo pacman -Sc` (if on Arch Linux) or equivalent.

2.  **Remove Orphans**:

    - Find and remove orphan packages: `sudo pacman -Rns $(pacman -Qtdq)`.
    - **Caution**: Ask for user confirmation before removing orphans if not explicitly authorized.

3.  **Clean Dotfiles Temp**:
    - Check for and remove temporary files in `~/dotfiles` (e.g., `*.swp`, `*~`).

### QUESTION:

$ARGUMENTS
