---
name: commit
description: Use when staging, formatting, or creating git commits for code changes in a Git repository.
---

# Commit

Guidelines for crafting structured, conventional git commit messages and obtaining user confirmation before committing.


## Overview

All commits in this repository must follow the Conventional Commits specification and adhere to character length limits. Changes should never be committed automatically.


## Triggering Conditions

- When staging modifications, untracked files, or deletions.
- When preparing to commit changes.
- When generating a commit message for git.


## Rules & Constraints

### 1. Verification of Changes

- Always check current changes using `git diff` or `git status` before writing a commit message.

### 2. Commit Message Structure

Conventional commit format:
```gitcommit
<type>(<scope>): <subject>

- <bullet point 1>
- <bullet point 2>
```

#### Subject Line
- **Type**: Must be one of: `feat`, `fix`, `docs`, `refactor`, `style`, `test`, `chore`.
- **Scope**: (Optional) Parenthesized context for the change (e.g., `feat(tmux):`).
- **Subject**:
  - Maximum 50 characters including type and scope.
  - Use imperative, present tense (e.g., "add", "fix" - NOT "added", "fixes", "fixing").
  - Start with a lowercase letter.
  - Do not use capital letters unless they are part of an abbreviation (e.g., "UI", "UX", "CLI", "PR") or a proper noun / person's name.
  - Do not end with a period.

#### Body
- Separate the subject from the body with exactly one blank line.
- Present details as concise bullet points starting with `-`.
- Start each bullet point with a lowercase letter, and do not use capital letters unless they are part of an abbreviation or a proper noun / person's name.
- Hard-wrap all body lines to a maximum of 72 characters.

### 3. User Confirmation

- Present the proposed commit message in a code block.
- Ask the user explicitly: "Would you like me to commit these changes with this message?"
- **NEVER** execute `git commit` or apply changes automatically without explicit user approval.


## Common Mistakes

- **Auto-committing**: Initiating the commit command without asking the user.
- **Subject length overflow**: Exceeding 50 characters in the first line.
- **Body length overflow**: Exceeding 72 characters per line in the body.
- **Incorrect grammatical mood**: Using past tense ("added", "fixed") or present continuous ("adding", "fixing").
- **Missing bullet format**: Writing body as a single paragraph instead of bullet points.
