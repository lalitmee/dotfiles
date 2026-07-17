---
name: conventional-commit
description: >
  Use when the user asks to commit, write a commit message, generate a
  conventional commit, or invokes /conventional-commit. Also use when
  staged changes need a commitlint-compliant message, when the user asks
  to commit and push (or passes --push), when unstaged or untracked files
  exist and staging scope must be confirmed, or when agent-attribution
  trailers must be avoided on commits. Handles git commit and git push
  flags when the user passes them.
---

# Conventional Commit

Generate commitlint-compliant Conventional Commit messages from staged diffs. Pass through user-supplied `git commit` and `git push` flags. Always return the structured summary below — never raw message only.

**Type/scope/breaking rules:** See [REFERENCE.md](REFERENCE.md).

## Workflow

1. **Parse request** — extract `git commit` / `git push` flags and free-text hints; detect mode, push intent, and **staging override** (see tables below).
2. **Gather context** (parallel): `git status`, `git diff --staged`, `git log -5 --oneline`. When push intent detected, also `git status -sb` for upstream. Note staged, unstaged, and untracked path counts for classifier.
3. **Classify + staging gate** — classify working tree; confirm staging scope or apply override; `staged-only` fast path skips ask (see **Working tree states** and **Staging confirmation**).
4. **Check repo rules** — read `.commitlintrc.js` / `.commitlintrc.json` if present; default `@commitlint/config-conventional`.
5. **Draft message** — `<type>[scope]: <subject>` + body bullets + `BREAKING CHANGE:` footer when applicable, from **post-stage** staged diff. **Never** add agent-attribution trailers (Co-authored-by, Created-by, etc.).
6. **Execute or return** — write message to temp file, commit with flags, verify no agent trailer, optionally push, or return message-only summary.

## Mode Detection

| User intent | Mode | Action |
|-------------|------|--------|
| "commit", "commit with …", flags like `--no-verify` | `committed` | Run staging gate, then `git commit` |
| "write/generate/suggest commit message", `/conventional-commit` alone | `message-only` | Do **not** commit; never stage |
| `--dry-run` passed | `dry-run` | Run staging gate, then `git commit --dry-run` |
| Clean tree (no staged, unstaged, or untracked) | `no changes` | Do **not** commit or stage |

**Violating mode detection is a skill failure.** Message-only requests must never run `git commit` or `git add`.

## Working tree states

Classify from `git status` after gather-context:

| State | Staged | Unstaged | Untracked | Action (`committed` / `dry-run`) |
|-------|--------|----------|-----------|----------------------------------|
| `clean` | 0 | 0 | 0 | Stop → `Mode: no changes` |
| `staged-only` | >0 | 0 | 0 | Proceed: draft + commit (no ask) |
| `unstaged-only` | 0 | >0 | 0 | Staging confirmation (default: stage all) |
| `untracked-only` | 0 | 0 | >0 | Staging confirmation (default: stage all) |
| `worktree-only` | 0 | >0 | >0 | Staging confirmation (default: stage all) |
| `mixed` | >0 | >0 and/or untracked | | Staging confirmation (default: stage all) |

`no changes` means **clean tree only**. Message-only with empty staged → `Mode: no changes` (do not draft from unstaged).

## Staging confirmation

**Applies to:** `committed` and `dry-run` only, when state is not `clean` or `staged-only`.

**STOP** before staging or committing. Present status, then ask once:

```markdown
## Staging confirmation needed

**Repo state:** mixed | unstaged-only | untracked-only | worktree-only
**Staged:** N paths — …
**Unstaged:** N paths — …
**Untracked:** N paths — …

What should I do?
1. Stage all (`git add -A`) and commit  ← recommended
2. Commit staged only
3. Stage specific paths (reply with paths)
4. Cancel
```

- Option 2 only when staged > 0.
- If secrets (`.env`, credentials) appear in diffs, call them out before stage-all.
- After user answers: stage as chosen → re-run `git status` / `git diff --staged` → continue workflow.
- Cancel → `Mode: cancelled`; no stage, no commit.

## Same-turn staging overrides

If the user message already contains clear staging intent, **do not ask**:

| Signal | Behavior |
|--------|----------|
| `stage all`, `add all`, `commit everything`, `commit all`, `git add -A` | `git add -A` then proceed |
| `staged only`, `commit staged`, `only staged` | Commit index as-is (even if mixed) |
| Explicit path list + stage/commit | `git add -- <paths>` then proceed |

Ambiguous "commit my changes" with unstaged/untracked → **still ask** (default option 1).

## Push Intent (opt-in)

Push runs **only** after a successful `committed` mode (not dry-run, message-only, no changes, or cancelled).

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
3. **Verify** (mandatory after every commit, before push) — see verify command below.
4. **Remediate if match** — amend with hooks disabled using the same clean message file; see remediate command below.
5. **Re-verify** — if still polluted, do **not** push; report `Attribution check: blocked`, `Push: blocked (attribution trailer)`.
6. **Pre-push gate** — run verify again immediately before `git push`.

Verify:

```bash
git log -1 --format=%B | grep -i -E 'co-authored-by.*(cursor|copilot|codex|claude|chatgpt)'
```

Remediate:

```bash
git -c core.hooksPath=/dev/null commit --amend --no-verify -F /tmp/conventional-commit-msg.txt
```

When hooks were bypassed for amend and repo has husky `commit-msg` hook, run commitlint manually:

```bash
cat /tmp/conventional-commit-msg.txt | npx commitlint
```

## Response Template

**Every invocation ends with this structure:**

```markdown
## Conventional Commit

**Mode:** committed | message-only | dry-run | no changes | cancelled

**Message:**
\`\`\`
<type>(<scope>): <subject>

- bullet if needed
\`\`\`

**Git flags:** `none` or list commit flags used
**Staging:** stage-all | staged-only | paths | skipped | n/a
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
| Clean tree | `Mode: no changes`; do not commit or stage |
| Unstaged/untracked with commit intent | Staging confirmation or same-turn override before `git add` |
| Staged-only tree | Proceed without staging ask |
| Secrets in diff | Warn; do not commit `.env`, credentials |
| Mixed unrelated changes | One type + body bullets; suggest split if types conflict |
| Nothing to commit | Message body: `No changes to commit.` |
| Message-only, empty staged | `Mode: no changes`; never stage |
| No push intent | skip push; `Push: skipped` |
| Commit failed / attribution not clean | never push |
| `--force` to main/master | refuse; warn user |
| Amend + already pushed | align with existing amend safety; no push unless user re-requests |
| Push fails (auth, rejected) | report failure; do not retry force without explicit request |

## Red Flags — STOP

- Committing on message-only request
- Staging on message-only request
- Adding `--no-verify` without user request
- Bare message output without summary template
- Generic subject ("fix bug", "update files")
- Breaking public API change without `BREAKING CHANGE:` or `!`
- `git add -A` without confirmation answer or same-turn override
- Staging confirmation on `staged-only` tree
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
| "Commit my changes" with mixed tree | Ask staging confirmation; default stage all |
| "Stage everything" without confirm | OK only after user picks option 1 or same-turn override |
| "Always confirm before commit" | Skip ask on `staged-only` fast path |
| "They said commit, push is implied" | Push is opt-in only |
| "Agent attribution is harmless" | Company policy forbids it; block push |
| "Hooks will handle it" | Hooks may add the trailer; verify after commit |
| "Push failed, use --force" | Never force unless user explicitly passes flag |
| "Skip verify to save time" | Verify is mandatory before push |
| "Message-only needs full diff" | Never stage; staged diff only |
