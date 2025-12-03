---
description: Review Pull Requests
agent: review
---

## Mission: PR Review

Your task is to review a Pull Request or a specific branch against the main branch.

### Workflow:

1.  **Fetch Context**:

    - If a PR URL is provided, try to use `gh pr view` or similar tools if available.
    - If not, assume the current branch is the feature branch and compare it with `main` (or `master`).
    - Run `git diff main...HEAD` to get the changes.

2.  **Review**:

    - Analyze the diff for bugs, style issues, and logic errors.
    - Check for test coverage if applicable.

3.  **Report**:
    - Summarize the changes.
    - List specific feedback.

### QUESTION:

$ARGUMENTS
