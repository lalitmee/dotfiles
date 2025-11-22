---
description: Check git status
agent: run
---

## Mission: Git Status

Your task is to provide a comprehensive status of the current git repository.

### Workflow:

1.  **Get Status**:

    - Run `git status` to see working tree status.
    - Run `git log -1 --oneline` to see the latest commit.
    - Run `git branch --show-current` to see the current branch.

2.  **Report**:
    - Present the information clearly.
    - Highlight if the branch is ahead/behind remote.

### QUESTION:

$ARGUMENTS
