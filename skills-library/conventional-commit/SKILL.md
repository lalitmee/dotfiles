---
name: conventional-commit
description: >
  Use when the user asks to commit, write a commit message, generate a
  conventional commit, or staged changes need a commitlint-compliant message.
  Handles git commit and git push flags when the user passes them.
---

# Conventional Commit

Generate commitlint-compliant Conventional Commit messages from staged diffs. Pass through user-supplied `git commit` and `git push` flags. Always return the structured summary below — never raw message only.

**Type/scope/breaking rules:** See [REFERENCE.md](REFERENCE.md).

## Workflow

1. **Parse request** — extract `git commit` / `git push` flags and free-text hints; detect mode and push intent (see tables below).
2. **Gather context** (parallel): `git status`, `git diff --staged`, `git log -5 --oneline`. When push intent detected, also `git status -sb` for upstream.
3. **Check repo rules** — read `.commitlintrc.js` / `.commitlintrc.json` if present; default `@commitlint/config-conventional`.
4. **Draft message** — `<type>[scope]: <subject>` + body bullets + `BREAKING CHANGE:` footer when applicable. **Never** add agent-attribution trailers (Co-authored-by, Created-by, etc.).
5. **Execute or return** — write message to temp file, commit with flags, verify no agent trailer, optionally push, or return message-only summary.

## Mode Detection

| User intent | Mode | Action |
|-------------|------|--------|
| "commit", "commit with …", flags like `--no-verify` | `committed` | Run `git commit` |
| "write/generate/suggest commit message", "/conventional-commit" alone | `message-only` | Do **not** commit |
| `--dry-run` passed | `dry-run` | Run commit with `--dry-run` |
| Nothing staged | `no changes` | Do **not** commit; no staging unless user explicitly asks to stage **and** commit |

**Violating mode detection is a skill failure.** Message-only requests must never run `git commit`.

## Push Intent (opt-in)

Push runs **only** after a successful `committed` mode (not dry-run, message-only, or no changes).

| Signal | Push? |
|--------|-------|
| `commit and push`, `commit & push`, `push`, `--push` | yes |
| plain `commit`, message-only, `--dry-run` | no |
| `--no-push`, `don't push` | no (overrides push keywords) |

## Git Commit Flag Passthrough

Parse flags from the user message. Insert between `git commit` and `-F`:

| Flag | Gate |
|------|------|
| `--no-verify` / `-n` | Only when user explicitly passes it this request |
| `--amend` | Only when user explicitly passes it; enforce amend safety rules from user commit policy |
| `--signoff` / `-s`, `--allow-empty`, `--no-edit` | Pass through |
| `--author`, `--date` | Pass through with values |
| `--fixup`, `--squash` | Pass through with commit ref |
| `--dry-run` | Pass through; set `Mode: dry-run` |

Write the message to a temp file and commit with `-F` so the agent controls exact bytes:

```bash
git commit --no-verify -F /tmp/conventional-commit-msg.txt
```

Also follow the user's commit policy: parallel status/diff/log before commit, `git status` after.

## Git Push Flag Passthrough

Parse from user message; pass through to `git push`.

| Flag / form | Gate |
|-------------|------|
| `--force-with-lease` | only when user explicitly passes |
| `--force` | only when user explicitly passes; **never** to `main`/`master` |
| remote + branch (e.g. `origin my-branch`) | pass through; default `origin` + current branch |
| `-u` / `--set-upstream` | use when branch has no upstream (`git status -sb` shows no tracking) |

Default when upstream missing: `git push -u origin HEAD`.

## No Agent Attribution

**Iron rule:** Commits must never contain agent-attribution trailers (`Co-authored-by`, `Created-by`, `Made with`, or similar) naming the AI tool.

1. **Draft** — message file contains only conventional header/body/footer; no attribution lines.
2. **Commit** — `git commit … -F /tmp/conventional-commit-msg.txt`.
3. **Verify** (mandatory after every commit, before push):

```bash
git log -1 --format=%B | grep -i -E 'co-authored-by.*(cursor|copilot|codex|claude|chatgpt)'
```

4. **Remediate if match** — amend with hooks disabled using the same clean message file:

```bash
git -c core.hooksPath=/dev/null commit --amend --no-verify -F /tmp/conventional-commit-msg.txt
```

5. **Re-verify** — if still polluted, do **not** push; report `Attribution check: blocked`, `Push: blocked (attribution trailer)`.
6. **Pre-push gate** — run verify again immediately before `git push`.

When hooks were bypassed for amend and repo has husky `commit-msg` hook, run commitlint manually:

```bash
cat /tmp/conventional-commit-msg.txt | npx commitlint
```

## Response Template

**Every invocation ends with this structure:**

```markdown
## Conventional Commit

**Mode:** committed | message-only | dry-run | no changes

**Message:**
```
<type>(<scope>): <subject>

- bullet if needed
```

**Git flags:** `none` or list commit flags used
**Staged files:** N files (or `none`)
**Commit SHA:** `abc1234` (omit if not committed)
**Attribution check:** clean | amended | blocked | n/a
**Push:** skipped | pushed | failed | blocked | n/a
**Push target:** `origin/branch-name` (omit if not pushed)
```

## Safety Gates

| Situation | Rule |
|-----------|------|
| `--no-verify` | Never add unless user passed it in this request |
| `--amend` | Never unless user passed it; verify HEAD authorship + not pushed |
| No staged changes | `Mode: no changes`; do not commit |
| Secrets in diff | Warn; do not commit `.env`, credentials |
| Mixed unrelated changes | One type + body bullets; suggest split if types conflict |
| Nothing to commit | Message body: `No changes to commit.` |
| No push intent | skip push; `Push: skipped` |
| Commit failed / attribution not clean | never push |
| `--force` to main/master | refuse; warn user |
| Amend + already pushed | align with existing amend safety; no push unless user re-requests |
| Push fails (auth, rejected) | report failure; do not retry force without explicit request |

## Red Flags — STOP

- Committing on message-only request
- Adding `--no-verify` without user request
- Bare message output without summary template
- Generic subject ("fix bug", "update files")
- Breaking public API change without `BREAKING CHANGE:` or `!`
- `git add -A` without user asking to stage
- Pushing without explicit push intent
- Pushing with agent-attribution trailer present
- Adding attribution lines to the drafted message
- Force push without explicit user flag
- Skipping attribution verify before push

## Rationalizations

| Excuse | Reality |
|--------|---------|
| "They probably want it committed" | Only commit when intent is explicit |
| "Quickly" needs `--no-verify` | Time pressure ≠ skip hooks |
| "Removing dead code isn't breaking" | Public export removal is breaking |
| "Summary is redundant" | Template is required every time |
| "Stage everything for commit my changes" | Ask or require explicit stage+commit request |
| "They said commit, push is implied" | Push is opt-in only |
| "Agent attribution is harmless" | Company policy forbids it; block push |
| "Hooks will handle it" | Hooks may add the trailer; verify after commit |
| "Push failed, use --force" | Never force unless user explicitly passes flag |
| "Skip verify to save time" | Verify is mandatory before push |
