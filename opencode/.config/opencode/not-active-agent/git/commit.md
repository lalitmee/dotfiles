---
description: Generate git commit messages
agent: git
---

## Mission: Git Commit

Your task is to generate a conventional commit message based on the staged changes.

### Workflow:

1.  **Analyze Changes**:

    - Run `git diff --cached` to see staged changes.
    - If no changes are staged, ask the user to stage changes first.

2.  **Generate Message**:

    - Create a commit message following the Conventional Commits specification (e.g., `feat:`, `fix:`, `chore:`).
    - Keep the subject line under 50 characters.
    - Provide a detailed body if necessary.

3.  **Commit (Optional)**:
    - If the user approves, run `git commit -m "message"`.
    - **Default**: Just output the suggested message.

### QUESTION:

$ARGUMENTS
