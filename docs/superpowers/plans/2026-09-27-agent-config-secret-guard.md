# Agent CLI Config Secret Guard Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Track shareable assistant and MCP configuration while rejecting literal credentials in staged content regardless of path or file format.

**Architecture:** Reuse the pinned Gitleaks pre-commit hook, explicitly extend its built-in rules, and add a tested generic credential rule that also scans Markdown. Use a disposable-repository fixture test to exercise the actual staged hook; sanitize configs and remove local-only ignore rules only after the remote-history gate is clean.

**Tech Stack:** Gitleaks v8.18.2, pre-commit, Python 3 standard library for the fixture harness, Git.

**Spec:** `docs/superpowers/specs/2026-09-27-agent-config-secret-guard-design.md`

## Global Constraints

- Keep the existing Gitleaks hook pinned to `v8.18.2`; add no scanner dependency.
- No CI gate in this iteration.
- No real token values in fixtures, logs, plans, or commits.
- Do not restore any local-only config path until fetched remote refs and tags pass exact-value and path-history scans.
- Keep `scripts/hooks/check-cursor-cli-config.zsh` and its hook active for Cursor identity/cache/model-picker policy.
- Use supported environment/provider credential references; do not commit a real credential.
- Do not install the shared `.git/hooks/pre-commit` from this linked worktree; install it from `main` only after the tested guard is integrated.
- Never run `./install.sh` without explicit user confirmation.
- Do not commit or push implementation changes unless explicitly requested.

---

### Task 1: Pass the history and local-config safety gate

**Files:**
- Read only: `codex/.codex/config.toml`, `opencode/.config/opencode/opencode.json`, `vscode/mcp.json` in the original checkout `~/dotfiles`
- Read only: `.gitignore`, `.gitleaks.toml`, and tracked AI configs in this worktree

**Interfaces:**
- Consumes: local-only config copies in the original checkout and the fetched `origin/*` refs/tags.
- Produces: a redacted inventory of remaining exact-value and config-path history matches, plus a reviewed list of credential/session/identity fields; no tracked changes.

- [ ] **Step 1: Fetch all configured remote branches and tags**

Run in `~/dotfiles-worktrees/agent-config-secret-guard`:

```bash
git fetch --prune --tags origin
git for-each-ref --format='%(refname) %(objectname)' refs/remotes/origin refs/tags
```

Expected: the current remote branch and tag refs are present locally; record their names and object IDs in a temporary, non-committed report.

- [ ] **Step 2: Review assistant configs for secret and machine-local fields**

Inspect the local Codex, OpenCode, and VS Code MCP copies without displaying credential values. Review existing tracked configs listed in `tmux/.config/tmux/scripts/popup/help/tables/ai-tools.txt` and adjacent Gemini, MCPHub, tmuxai, Zed, and Cursor configs for auth/session values, device/user IDs, cache state, and literal keys. The active tmuxai `api_key` is currently an environment reference; distinguish commented examples from active YAML fields.

Expected: a private inventory of fields to externalize or omit. If any additional literal candidate is confirmed live, rotate/revoke it before tracking and include its exact value in the next scan.

- [ ] **Step 3: Scan exact credential values in memory across fetched refs and tags**

Read candidate values directly from the original ignored config files without printing them. Enumerate reachable blobs from every `refs/remotes/origin/*` and `refs/tags/*` ref, stream blob contents through `git cat-file --batch`, and compare values only in memory. Emit only matching ref names, paths, object IDs, and counts. Include the previously exposed bearer and any additional literal value classified as a live credential. Do not place values in shell arguments, command output, reports, or temporary files.

Run a separate path-history check:

```bash
git log --remotes=origin --tags --format='%H' --name-only -- codex/.codex/config.toml opencode/.config/opencode/opencode.json vscode/mcp.json .cursor/mcp.json cursor/.config/cursor/mcp.json
```

Expected: zero exact-value matches and no target MCP config paths in fetched branch/tag history. If either scan finds a match, stop before copying or tracking configs; report only the refs/paths/counts and obtain approval for any additional remote-history rewrite.

---

### Task 2: Add a failing staged-hook fixture test

**Files:**
- Create: `scripts/test/gitleaks_precommit_test.py`
- Read: `.gitleaks.toml`, `.pre-commit-config.yaml`

**Interfaces:**
- Consumes: the repository Gitleaks config and the existing pre-commit hook revision `v8.18.2`.
- Produces: executable `python3 scripts/test/gitleaks_precommit_test.py`, returning zero only when synthetic staged-secret cases fail safely and external-reference cases pass.

- [ ] **Step 1: Write the fixture harness using a disposable Git repository**

The Python standard-library test creates a temporary repository, copies `.gitleaks.toml`, writes a minimal pre-commit config containing the existing Gitleaks repo/revision/hook, initializes Git identity locally, commits the baseline config, installs pre-commit in the temporary repository, and stages one fixture at a time. Generate random dummy credentials at runtime with `secrets.token_urlsafe(32)` so no sample secret is stored in this repository.

For each case, attempt a real `git commit` with the fixture staged; capture hook output, assert the expected commit status, and assert that captured output never contains the generated dummy value. On assertion failure, raise a fixed diagnostic string rather than interpolating the dummy value or captured output. Cover:

```text
JSON, TOML, YAML, JSONC, Markdown: literal value under token/API-key/secret/Authorization fields -> reject
JSONC and Markdown: a secret field on the same line as an environment reference -> reject
JSON, TOML, YAML, JSONC, Markdown: environment reference or safe placeholder only -> pass
PEM private-key fixture with synthetic body -> reject through a built-in Gitleaks rule
```

Use a new staged fixture state for each case (`git reset --hard` and `git clean -fd` inside the temporary repository); never print generated values. The harness must test the installed commit hook, both the generic rule and an independent built-in rule.

The safe output check must be value-free:

```python
result = subprocess.run(["git", "commit", "-m", "fixture"], cwd=repo, capture_output=True, text=True)
output = result.stdout + result.stderr
if (result.returncode != 0) != expect_blocked:
    raise SystemExit("fixture commit had an unexpected result")
if dummy_value in output:
    raise SystemExit("hook output exposed a generated fixture value")
```

- [ ] **Step 2: Run the new harness before changing Gitleaks config**

Run:

```bash
python3 scripts/test/gitleaks_precommit_test.py
```

Expected: the test exits nonzero because the current config does not extend defaults and the Markdown allowlist lets at least the Markdown literal-secret fixture pass. Confirm the harness itself reports the failing case without printing any generated dummy value.

---

### Task 3: Enable built-in and generic credential detection

**Files:**
- Modify: `.gitleaks.toml`
- Test: `scripts/test/gitleaks_precommit_test.py`

**Interfaces:**
- Consumes: failing acceptance cases from Task 2.
- Produces: Gitleaks default rules plus a path-agnostic generic credential rule; Task 2's fixture harness passes.

- [ ] **Step 1: Extend Gitleaks defaults and remove the blanket Markdown exception**

Add the Gitleaks v8.18.2 `[extend]` setting with `useDefault = true`. Remove only the `.*\.md$` path allowlist. Preserve unrelated narrow path exceptions while confirming they do not overlap assistant configs.

- [ ] **Step 2: Add a generic rule for literal credential assignments**

Add a custom rule for common credential field names (`token`, `api_key`/`apiKey`, `secret`, `password`, and `Authorization`/`Bearer`) without any path restriction. Use a captured secret group and an entropy threshold appropriate for real credentials. Ensure values matching environment-reference syntax are not themselves captured as secrets.

Start with this Gitleaks TOML shape and adjust its regex only when a fixture proves a detection gap:

```toml
[extend]
useDefault = true

[[rules]]
id = "assistant-config-credential"
description = "Literal credential assigned to a common auth field"
regex = '''(?i)(?:authorization["']?\s*[:=]\s*["']?Bearer\s+|(?:api[_-]?key|token|client[_-]?secret|password)["']?\s*[:=]\s*["']?)([A-Za-z0-9][A-Za-z0-9._~+/-]{7,}={0,2})'''
secretGroup = 1
entropy = 3.0
keywords = ["authorization", "api_key", "token", "secret", "password"]
```

Review existing regex allowlists: remove or narrow any line-wide placeholder exception that could exempt a real credential on the same line. Keep safe examples only when the mixed-line fixture still fails.

- [ ] **Step 3: Run the fixture harness and correct only evidenced failures**

Run:

```bash
python3 scripts/test/gitleaks_precommit_test.py
```

Expected: all literal-secret fixtures and the built-in PEM fixture are rejected; safe environment-reference/placeholder fixtures pass; captured output contains no generated credential. If Gitleaks' pinned rule syntax or entropy behavior differs from the expression, adjust `.gitleaks.toml` to the v8.18.2 format and repeat.

- [ ] **Step 4: Check existing allowlist exceptions against the fixtures**

For each retained path or regex exception in `.gitleaks.toml`, add a fixture that contains the exception pattern alongside a separate synthetic credential. Keep the exception only if it does not make that credential pass. Do not replace the removed Markdown allowlist with a broad assistant/config path exemption.

- [ ] **Step 5: Check formatting and the Gitleaks configuration parse**

Run the harness above and:

```bash
git diff --check
```

Expected: successful fixture results, valid pinned-version configuration, and no whitespace errors.

---

### Task 4: Sanitize and restore shareable assistant configs

**Files:**
- Modify: `.gitignore`
- Restore and modify only after Task 1 passes: `codex/.codex/config.toml`, `opencode/.config/opencode/opencode.json`, `vscode/mcp.json`
- Review, modify only if a real credential is confirmed: `tmuxai/.config/tmuxai/config.yaml` and other tracked AI configs
- Preserve: `scripts/hooks/check-cursor-cli-config.zsh`, `.pre-commit-config.yaml`

**Interfaces:**
- Consumes: Task 1's clean history gate and Task 3's passing staged-secret detector.
- Produces: useful, sanitized assistant/MCP configs tracked in Git; non-shareable auth/session/cache state omitted or externally supplied.

- [ ] **Step 1: Copy the existing local configs into this worktree after the history gate passes**

Copy the three local-only config files from `~/dotfiles` into the matching paths under `~/dotfiles-worktrees/agent-config-secret-guard`. Do not display their contents. Keep a local backup outside the repository until the sanitized versions have been validated.

- [ ] **Step 2: Externalize or remove credential-bearing fields**

In OpenCode, replace the literal MCP Authorization value with a documented environment reference supported by OpenCode; keep the provider key's existing environment reference. For each `tmuxai` key classified as live, use its documented environment-reference mechanism; if none exists, remove/omit that credential-bearing entry and rely on the client's supported login flow. Keep VS Code and other already-safe environment references intact. Remove machine-local session, identity, and cache values that should not be shared; do not change unrelated assistant behavior.

Make the existing user-specific paths portable without changing their selectors: in `codex/.codex/config.toml`, replace the Linux `/home/.../dotfiles/.agents/skills/<skill>/SKILL.md` prefix with `~/dotfiles/.agents/skills/<skill>/SKILL.md` and preserve every `enabled = false` value. In `opencode/.config/opencode/opencode.json`, use `{env:HOME}` for the local plugin and disabled-plugin paths; OpenCode substitutes env references before parsing the plugin array. The user chose to keep these references and provision the plugin repositories separately at the same relative paths on each OS. The target plugin repositories are absent at those paths on this Mac; do not clone, remove, or disable them in this task.

Verify the Codex TOML parses and all 31 expanded skill paths resolve under the current `~/dotfiles` checkout. For OpenCode, substitute `/home/test` and `/Users/test` for `{env:HOME}`, parse the resulting JSON, and verify active and `-`-disabled plugin path entries keep their prefixes and expected suffixes.

- [ ] **Step 3: Remove only the five local-only MCP ignore entries and stage sanitized configs**

Delete exactly these ignore rules from `.gitignore`:

```text
codex/.codex/config.toml
opencode/.config/opencode/opencode.json
vscode/mcp.json
.cursor/mcp.json
cursor/.config/cursor/mcp.json
```

Do not add config files that do not exist locally (including `.cursor/mcp.json`). Stage only `.gitignore`, the three sanitized configs, and any tracked config requiring an evidenced credential correction.

- [ ] **Step 4: Prove intended files are tracked and no longer ignored**

Run:

```bash
git check-ignore codex/.codex/config.toml opencode/.config/opencode/opencode.json vscode/mcp.json
git ls-files --error-unmatch codex/.codex/config.toml opencode/.config/opencode/opencode.json vscode/mcp.json
```

Expected: `git check-ignore` reports no matching ignore rule (its nonzero result is expected), and `git ls-files --error-unmatch` lists all three staged config paths after they are added.

---

### Task 5: Verify the guard and prepare main-hook installation

**Files:**
- No additional production files expected; `.pre-commit-config.yaml` stays on the existing Gitleaks and Cursor hooks.
- Validate: `.gitleaks.toml`, `.gitignore`, assistant configs, `scripts/test/gitleaks_precommit_test.py`

**Interfaces:**
- Consumes: sanitized staged configs and the passing Task 2 fixture harness.
- Produces: passing feature-worktree hook/full-scan results and a final redacted history/ref report; installation of the shared main hook is deferred until integration is authorized.

- [ ] **Step 1: Run fixture, full-worktree, and staged-file checks**

Run:

```bash
git add -- .gitleaks.toml .gitignore scripts/test/gitleaks_precommit_test.py codex/.codex/config.toml opencode/.config/opencode/opencode.json vscode/mcp.json
python3 scripts/test/gitleaks_precommit_test.py
pre-commit run --all-files
pre-commit run --files .gitleaks.toml .gitignore codex/.codex/config.toml opencode/.config/opencode/opencode.json vscode/mcp.json
gitleaks detect --source . --no-git --redact --config .gitleaks.toml
```

If Task 1 identified another tracked config requiring correction, append only that exact path to the `git add` command. Do not use `git add -A`.

Expected: both pre-commit hooks pass; the staged-secret fixtures reject all synthetic literals and do not reveal their values; every staged config passes. `pre-commit`'s Gitleaks hook checks staged changes, so the separate `gitleaks detect --no-git` command must also pass for the full current worktree.

If the all-file run reports existing findings, capture only redacted paths and rule IDs, inspect the affected content without printing credential values, and classify each as a real credential, safe example, or false positive. Remediate real values; narrow an exception only for verified safe examples. Re-run the fixture harness after every allowlist change.

- [ ] **Step 2: Repeat exact-value and target-path history checks**

Re-run Task 1's exact-value scan over all fetched remote refs/tags and the local feature branch. Verify no literal credential is present in staged content, the five local-only ignore entries are absent, the three intended configs are tracked, and no secret values appear in output. Do not push or rewrite remote history as part of this plan without explicit user approval.

After the user authorizes integrating this branch into `main`, run `pre-commit install` from the main checkout and verify the shared hook is installed at `.git/hooks/pre-commit`. The normal installer phase already performs this setup on fresh installations.

- [ ] **Step 3: Review the final diff without committing**

Run:

```bash
git status --short
git diff --check
git diff --cached --check
git diff --cached -- .gitleaks.toml .gitignore .pre-commit-config.yaml codex/.codex/config.toml opencode/.config/opencode/opencode.json vscode/mcp.json scripts/test/gitleaks_precommit_test.py
git diff -- .gitleaks.toml .gitignore .pre-commit-config.yaml codex/.codex/config.toml opencode/.config/opencode/opencode.json vscode/mcp.json scripts/test/gitleaks_precommit_test.py
```

Expected: the diff contains only the approved scanner/test/config changes, no credential values, no unrelated Zsh changes, and no whitespace errors. Leave changes uncommitted unless the user explicitly asks to commit.
