# grill-pr workflow

End-to-end: git audit → template resolution → draft → grill → commit/push → `gh pr create`.

## Invoke

`/grill-pr` or natural language: "create PR", "open PR", "raise PR", "submit for review".

## Phase 0 — Confirm repo (multi-root only)

When workspace has multiple git roots, use the **question** tool before audit — do not ask in chat prose. Set the Recommended option from cwd or branch context.

## Phase 1 — Parallel git audit

Run in **one parallel batch**:

```bash
git status
git diff
git diff --staged
git status -sb
git log --oneline -10
git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null || gh repo view --json defaultBranchRef -q .defaultBranchRef.name
git log "${BASE}..HEAD" --oneline
git diff "${BASE}...HEAD"
```

Set `BASE` from inferred default branch (confirm in grilling if ambiguous).

### Preflight summary (report to user)

```text
Repo: {owner}/{repo}
Branch: {branch} ({ahead/behind} vs {upstream})
Base (inferred): {base}
Commits in PR: {n}
Working tree: {clean | staged | unstaged | untracked}
Scope: {one-line guess}
Template: {path or "default fallback"}
```

Infer CODEOWNERS, commit style, and base branch from repo — present judgment calls via question tool in Phase 4, not open chat questions.

## Phase 2 — Resolve PR template

Follow [references/template-resolution.md](references/template-resolution.md).

## Phase 3 — Draft PR content

- **Title:** commitlint-compliant conventional commit **header only** — one line, **≤72 chars**. Follow [references/pr-title.md](references/pr-title.md); derive type/scope/subject via **conventional-commit** rules. Put all detail in the body.
- **Body:** fill resolved template from `git diff ${BASE}...HEAD` + all commit messages.
- Tick checklists only when supported by diff; use `[NEEDS INPUT]` for gaps.
- **Strip forbidden footers** before presenting draft or calling `gh pr create`: remove lines matching "Made with", "Created by", or similar AI tool attribution lines. Do not add them.

Present draft title + body before grilling.

## Phase 4 — Grilling session

Follow [references/decision-tree.md](references/decision-tree.md) and [references/ask-question.md](references/ask-question.md).

- **One question tool call per turn** — one decision-tree node; Recommended option first with `(Recommended)`.
- Do **not** ask grilling questions in chat prose, bullet lists, or lettered options.
- **REQUIRED SUB-SKILL:** `conventional-commit` when user approves commit.
- Do **not** use TodoWrite or Task tools during this workflow.

## Phase 5 — Execute (after final approval only)

Sequential:

```bash
# If approved in grilling
git push -u origin HEAD

gh pr create \
  --base "${BASE}" \
  --title "${TITLE}" \
  --body "$(cat <<'EOF'
${BODY}
EOF
)" \
  ${DRAFT_FLAG} \
  ${REVIEWER_FLAGS} \
  ${LABEL_FLAGS} \
  ${ASSIGNEE_FLAG}
```

Expand flags only when grilling resolved them:

- Draft: `--draft`
- Reviewers: `--reviewer user1,user2`
- Labels: `--label name1,name2`
- Assignee: `--assignee @me`

**Hard rules:**

- NEVER update git config
- Do NOT commit/push/create PR before grilling completes + final approval question
- Do NOT use `git add .` / `git add -A`
- Strip AI attribution footers from `${BODY}` before `gh pr create` (see Phase 3)
- Validate `${TITLE}` per [pr-title.md](references/pr-title.md) (single line, ≤72 chars, commitlint) — redraft if fail
- Return PR URL from command output

## Phase 6 — Post-create

- Markdown link to PR URL
- Base branch, draft status, reviewers/labels if set
- If draft: remind user to mark ready when appropriate

## Multi-root workspace

Phase 0 is mandatory. All git/gh commands run in the confirmed repo directory.

## Refresh template

When user says `refresh PR template`: re-run web research, update [default-pr-template.md](references/default-pr-template.md), report changes.
