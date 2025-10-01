---
alwaysApply: false
description: "Generate Conventional Commit message from staged changes"
---

# Conventional Commits Writer

## Purpose
Create a precise commit message following Conventional Commits from current staged diff.

## Instructions
- Read staged diff via git tooling.
- Output ONLY the final commit message text (no extra prose or markdown).
- Use `<type>[optional scope]: <description>` format.
- Keep subject concise (≤50 chars when possible).
- Use bullet points in body for multiple changes.
- Add `BREAKING CHANGE:` footer if applicable.
- If nothing is staged, output: `No changes to commit.`

## Example
```
feat(api): add profiles endpoint

- Implement GET /api/users/{id}/profile
- Add queries and tests

BREAKING CHANGE: user shape changed
```
