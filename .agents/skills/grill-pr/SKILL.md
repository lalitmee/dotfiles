---
name: grill-pr
description: >-
  Use when the user asks to create, open, or raise a GitHub pull request,
  submit changes for review. Also when staged, committed, or unpushed work
  needs a PR via gh CLI and required PR metadata is missing (base branch,
  draft vs ready, reviewers, labels, linked issues, test plan).
---

# grill-pr

Interview the user through every PR decision, then create the pull request via `gh`.

Load and follow [WORKFLOW.md](WORKFLOW.md).

## Hard rules

1. **Grilling is mandatory** unless user says `skip grilling` — final approval is never skipped.
2. **Repo template first** — [template-resolution.md](references/template-resolution.md); fallback only if none found.
3. **Full diff** — analyze `git diff ${BASE}...HEAD`, not just the latest commit.
4. **No silent commit/push/PR** — explicit approval after grilling.
5. **Commits** — **REQUIRED SUB-SKILL:** `conventional-commit` (never invent messages inline).
6. **PR title** — single-line conventional commit header only, **≤72 chars** — [pr-title.md](references/pr-title.md); validate before create.
7. **Split** — **REQUIRED when detected:** separate PRs per concern; stop until user approves.
8. **gh only** for GitHub; NEVER update git config.
9. Do NOT use `git add .` / `git add -A`.
10. Return PR URL when done.
11. **No AI attribution in PR body** — never add "Made with", "Created by", or similar AI tool attribution lines; strip them before `gh pr create` if present in draft or template.
12. **question tool for every decision** — one question per decision-tree node; never ask in chat prose or lettered lists — [ask-question.md](references/ask-question.md).

## Quick reference

| Phase | Action |
|-------|--------|
| 0 | Confirm repo (multi-root) |
| 1 | Parallel git audit → Preflight summary |
| 2 | Resolve PR template |
| 3 | Draft title + body into template |
| 4 | Grill — [decision-tree.md](references/decision-tree.md) + [ask-question.md](references/ask-question.md) |
| 5 | Push (if approved) + `gh pr create` |
| 6 | Return PR URL |

## Red flags — STOP

- Creating PR because user said "create PR" without walking the decision tree
- Using Summary/Test plan without checking repo template
- Pushing or committing without approval
- Analyzing only the latest commit
- Web-searching PR templates every session (use [default-pr-template.md](references/default-pr-template.md))
- Appending AI attribution to PR body
- PR title with newlines, untyped prefix, or length >72 chars
- Putting summary bullets or commit bodies in `--title` instead of PR body
- Asking grilling questions in chat instead of question tool
- Treating free-text "yes" / "create PR" as final approval without question gate

## Rationalizations

| Excuse | Reality |
|--------|---------|
| "User said create PR so just do it" | Grilling mandatory unless `skip grilling` |
| "I'll ask about test plan in the body" | Test plan is decision tree node |
| "Only latest commit matters" | Must use `git diff base...HEAD` |
| "Summary + Test plan is good enough" | Repo template first; fallback only if none |
| "I'll web search every PR" | Fallback is pre-researched in references |
| "Pushing is implied for PR" | Requires explicit approval |
| "AI attribution is harmless branding" | Forbidden — strip before create; company PRs stay product-neutral |
| "Long title is more descriptive" | Body holds detail; title ≤72 chars single-line conventional header |
| "72 chars is too short" | GitHub UI wrap is worse; shorten scope/subject per pr-title.md |
| "User already answered in chat" | question tool unless they picked that option in the same question flow |
| "Body edits need open conversation" | Other option → prose edit → resume question for next node |

## Sub-skills

- **conventional-commit** — commits during the workflow
