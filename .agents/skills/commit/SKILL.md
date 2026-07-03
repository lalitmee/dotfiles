---
name: commit
description: Generates a Git commit message based on staged, modified, or untracked changes
---

# Mission: Write a Conventional Commit Message

As an expert in writing Git commit messages, your task is to generate a commit message that follows the Conventional Commits specification and the commitizen convention.

## CRITICAL FORMAT REQUIREMENTS:
1. MUST generate exactly ONE commit message, never multiple messages
2. MUST include a title line and at least one bullet point description
3. MUST analyze ALL changes in the diff as a single logical unit
4. MUST respond with ONLY the commit message, no explanations or extra text
5. MUST ask the user for confirmation before finalizing the commit message
6. MUST use the `question` tool for EVERY user interaction — never ask questions as plain text

## MANDATORY FORMAT:
```
type(scope): brief description

- detailed description point 1
- detailed description point 2 (if needed)
- detailed description point 3 (if needed)
```

## Workflow:

1.  **Check for staged changes.**
    *   **Action:** Run `git diff --staged --quiet --exit-code`.
    *   **If staged changes exist (exit code 1):**
        *   Generate a commit message based on the output of `git diff --staged`.
        *   Proceed to step 5.
    *   **If no staged changes exist (exit code 0):**
        *   Proceed to step 2.

2.  **Check for modified and untracked files.**
    *   **Action:** Run `git status --porcelain`.
    *   **If there are modified or untracked files:**
        *   Proceed to step 3.
    *   **If there are no changes:**
        *   Respond with the single phrase: `No changes to commit.`
        *   End the workflow.

3.  **Handle untracked files.**
    *   **Action:** Check the output of `git status --porcelain` for files prefixed with `??`.
    *   **If untracked files exist:**
        *   **Use the `question` tool** with: question="There are untracked files. Do you want to include them in the commit message generation?", header="Untracked files", options=[{label="Yes, include them", description="Include untracked files in the commit message analysis"}, {label="No, skip them", description="Only analyze modified/staged files"}]
        *   **If "Yes":**
            *   Generate the commit message based on the output of `git diff` and `git ls-files --others --exclude-standard`.
        *   **If "No":**
            *   Generate the commit message based on the output of `git diff`.
    *   **If no untracked files exist:**
        *   Generate the commit message based on the output of `git diff`.

4.  **Adhere to Commitizen Conventions.**
    *   **Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`
    *   **Title:** Use imperative mood ("add" not "added"), keep under 50 characters
    *   **Body:** At least ONE bullet point describing the changes
    *   **For large diffs:** Focus on the most significant changes, group related changes
    *   **If commit history is provided:** Follow the established patterns and style from recent commits

5.  **Confirm the commit message.**
    *   **Action:** Present the generated commit message to the user inline.
    *   **Use the `question` tool** with: question="Does this commit message look good?", header="Confirm message", options=[{label="Yes, looks good", description="Proceed to commit"}, {label="No, let me give feedback", description="Provide feedback to improve the message"}]
    *   **If "Yes":**
        *   Proceed to step 7.
    *   **If "No":**
        *   Proceed to step 6.

6.  **Iterate on the commit message.**
    *   **Action:** Use the `question` tool to ask for feedback: question="What changes would you like to make to the commit message?", header="Refine message", options=[{label="Custom feedback", description="Type your specific feedback or requested changes"}]
    *   **Generate a new commit message** based on the user's feedback.
    *   Return to step 5.

7.  **Confirm the commit.**
    *   **Action:** Use the `question` tool with: question="Do you want to commit these changes?", header="Execute commit", options=[{label="Yes, commit", description="Run git commit with the generated message"}, {label="No, cancel", description="Abort the commit workflow"}]
    *   **If "Yes, commit":**
        *   Run `git commit -m "{{generated_commit_message}}"`.
    *   **If "No, cancel":**
        *   End the workflow.

## REQUIRED EXAMPLES:

```
feat(auth): add OAuth2 integration

- implement Google OAuth provider
- update user authentication flow
- add integration tests
```

```
fix(api): resolve data validation issues

- fix null pointer exceptions in user data
- improve input validation for API endpoints
```
