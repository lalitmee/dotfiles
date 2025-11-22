---
description: Commit and push local changes to dotfiles
agent: git
---

## Mission: Sync Dotfiles

Your task is to commit and push any local changes in the dotfiles repository.

### Workflow:

1.  **Check Status**:

    - Navigate to `~/dotfiles`.
    - Run `git status` to see changed files.

2.  **Stage and Commit**:

    - Stage all changes: `git add .`.
    - Commit with a descriptive message based on the changes. If the user provided a message in `$ARGUMENTS`, use that. Otherwise, generate a concise message summarizing the changes.

3.  **Push**:
    - Push changes to the remote: `git push`.

### QUESTION:

$ARGUMENTS
