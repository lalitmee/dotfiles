# Grilling decision tree

Depth-first order. **One question tool call per turn** — see [ask-question.md](ask-question.md) for option patterns. Format: question → Resolved → next.

Skip a node only when the **Skip when** column applies.

## Nodes

| # | Question focus | Recommended default | Skip when |
|---|----------------|---------------------|-----------|
| 0 | **Which repo?** (multi-root only) | Repo matching current branch cwd | Single workspace root |
| 1 | **Scope** — one PR or split? | Single PR if one concern; else separate per concern | Obvious single concern |
| 2 | **Dirty tree** — commit before PR? | Commit staged only via conventional-commit; ask about unstaged/untracked separately | Clean working tree |
| 3 | **Unpushed** — push now? | Yes, after commits settled | Up to date with remote |
| 4 | **Base branch** | Inferred default (`main` / `staging` / `origin/HEAD`) | User named base upfront |
| 5 | **Draft vs ready** | Ready for review | User said "draft PR" |
| 6 | **PR template** | Repo template if one; pick from list if multiple | Single template already resolved |
| 7 | **Title** | Single-line conventional header from branch diff (≤72 chars) — [pr-title.md](pr-title.md) | User gave exact valid title |
| 8 | **Body sections** | Walk template section-by-section; accept/edit each | User gave complete final body |
| 9 | **Linked issues** | Add `Fixes #N` or issue URL in Reference/Related section | None / user declines |
| 10 | **Reviewers** | From CODEOWNERS if unambiguous; else ask | User says none |
| 11 | **Labels** | None unless branch/commit hints (e.g. `fix/` → bug) | User says none |
| 12 | **Assignee** | `@me` or none | User says none |
| 13 | **Final approval** | Show title, base, body preview (no AI attribution), draft/reviewers/labels; question: Create PR | Never skip |

**question tool is mandatory for every node that runs** — including #13. Do not treat chat "yes" / "create PR" as approval without the question gate.

## Node details

### #1 Scope / split

If audit shows unrelated concerns (server + unrelated UI + dependency bump):
- **Recommended:** Split into separate PRs; stop until user approves split plan.

### #2 Dirty tree

- List staged, unstaged, untracked separately.
- **Recommended:** Commit staged via **conventional-commit**; leave unstaged out unless user includes them.
- Never `git add .` / `git add -A`.

### #7 Title

- Format: `<type>[scope]: <subject>` — header only, no body, no newlines.
- **≤72 characters** total; validate with commitlint when available.
- Multiple commits → one squash-style header for full `git diff ${BASE}...HEAD`, not a list.
- If user proposes a long or untyped title: offer a shortened conventional alternative in **Recommended**.

### #8 Body sections

Walk in template order. For default fallback: Summary → Type → Test plan → Related issues → Checklist.

Use `[NEEDS INPUT: …]` for gaps. Do not create PR with unresolved `[NEEDS INPUT]` unless user explicitly accepts.

**Forbidden in body:** AI attribution lines — strip before final approval (#13) and before `gh pr create`.

### #10 Reviewers

```bash
gh pr create --reviewer user1,user2
```

Verify handles exist: `gh api repos/{owner}/{repo}/collaborators/{user}` or ask user to confirm.

## Escape hatches

| User says | Effect |
|-----------|--------|
| `skip grilling` | Skip nodes 1–12; still require #13 question with drafted content |
| `stop` / `cancel` | Abort; no commit/push/PR |

## Session end

After #13 **Create PR** selected, proceed to [WORKFLOW.md](../WORKFLOW.md) Phase 5 (execute).

Shared understanding summary (optional): bullet list of resolved decisions before `gh pr create`.
