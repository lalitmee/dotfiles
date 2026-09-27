# Agent CLI Config Secret Guard — Design

**Date:** 2026-09-27
**Status:** Draft (pending user review)

## Goal

Track useful assistant CLI, editor, and MCP configuration in dotfiles while preventing literal credentials and sensitive client-local state from being committed. The guard must apply to staged content regardless of filename, format, assistant, or future config path.

## Problem Statement

The repository exposes multiple assistant configurations and currently has inconsistent protection:

- `.gitignore` excludes the local Codex, OpenCode, and VS Code MCP configs, so those active configs are absent from fresh checkouts.
- The exposed OpenCode MCP bearer was removed from remote branch history. A complete post-push scan of remote refs and tags is still required before restoring any affected config paths.
- `.gitleaks.toml` defines no default-rule extension or custom rules, and allowlists every Markdown file. The current custom configuration may therefore lack the built-in rules, while assistant command/prompt Markdown is not scanned.
- `.pre-commit-config.yaml` already runs Gitleaks v8.18.2 and a Cursor CLI validator. The Cursor validator rejects top-level identity, cache, and model-picker fields; it does not provide repository-wide credential detection.
- `scripts/install/phases/07-config-stow.zsh` already installs pre-commit when available. In this linked-worktree setup, default `pre-commit install` writes to the shared `.git/hooks`; validate from the feature worktree with `pre-commit run` and install the shared hook from `main` only after the tested guard is integrated.

The assistant table at `tmux/.config/tmux/scripts/popup/help/tables/ai-tools.txt` lists Antigravity, Claude, Codex, OpenCode, Copilot, Plandex, Crush, Kiro, Grok, and Cursor Agent. Current tracked adjacent configs also include Gemini MCP, MCPHub, tmuxai, and Zed settings. Some listed clients have no dedicated config in this repository; absence today must not create a scanner blind spot for future files.

Inventory found environment references for several existing provider/MCP credentials and one literal/unclassified OpenCode MCP Authorization value in the ignored local copy. The active `tmuxai` `api_key` is an environment reference; earlier line-based matches were commented examples, not active settings. Credential values are intentionally omitted from this document and must not be printed in diagnostics.

The local configs also contain machine-specific paths: Codex skill selectors use a Linux `/home/.../dotfiles` root, and OpenCode local plugin entries use a Linux home path. Codex's absolute path type expands a leading `~`, and OpenCode substitutes `{env:HOME}` throughout raw config text before parsing, so both can use portable home-relative forms without changing selector/plugin semantics. The user chose to keep these OpenCode references and provision the plugin repositories separately at the same relative paths on Linux and macOS. The plugin files are currently absent under those paths on this Mac; do not clone them as part of this change.

## Options Considered

### 1. Repository-wide staged-content scan (selected)

Extend Gitleaks defaults, remove the blanket Markdown path allowlist, and add tested generic credential detection. Gitleaks scans staged content rather than a manually maintained list of assistant paths. Keep the existing Cursor-specific validator for non-secret identity/cache/model-picker fields.

**Pros:** covers listed and future clients, including Markdown and unfamiliar config formats; reuses the existing dependency and pre-commit hook.

**Cons:** requires careful false-positive tests and disciplined, narrowly scoped allowlists.

### 2. Per-client path rules

Add a scanner path for every known config location.

**Rejected:** new assistants and renamed files would silently fall outside the guard; the path list duplicates discovery data already present in the repo.

### 3. Track literal local credentials and rely on the hook

**Rejected:** credentials remain visible in Git content/history and hooks can be bypassed. This does not satisfy the security goal.

## Selected Design

### Config and credential policy

- Track active assistant/MCP configuration only after removing literal credentials and client-local identity/cache state that should not be shared.
- During each config review, classify auth/session data, device/user identifiers, caches, and other machine-specific state. Keep non-shareable state out; add a client-specific validator only when a concrete schema and testable forbidden-field list are known.
- Replace Codex `skills.config.path` values rooted at `/home/.../dotfiles` with `~/dotfiles/...` paths, preserving path-based selectors and their `enabled` flags. Replace OpenCode local plugin paths with `{env:HOME}`-based paths, preserving active versus disabled entries.
- Use each client’s documented environment-variable or external credential-provider mechanism. If a client cannot interpolate external credentials, omit the secret-bearing entry or use its supported login flow; do not substitute a real credential into the tracked file.
- Review the OpenCode Authorization value without displaying it. Confirm the active tmuxai key remains an environment reference and ignore commented examples as inactive config. If any additional literal credential is found, rotate/revoke it, include its exact value in the all-ref/tag exposure scan, and remove its path/value from affected history before tracking.
- Keep config examples and fixtures synthetic. No production token values may be copied into tests, logs, plans, or commits.

### Secret detection

- Extend Gitleaks’ built-in rules instead of replacing them.
- Remove the blanket `.*\.md$` allowlist so Cursor commands, agent instructions, and future Markdown configs are scanned.
- Add a path-agnostic generic credential rule for literal values assigned to common credential fields (for example token, API key, secret, password, and Authorization/Bearer values). Its expression and allowlist behavior will be finalized by fixture tests against the pinned Gitleaks version; it must detect high-entropy dummy values and not exempt actual values merely because the path is Markdown or unfamiliar.
- Preserve only narrow existing false-positive exceptions that pass the same fixtures and do not disable credential detection.
- Ensure hook failure output identifies the file/rule without revealing the matched credential.
- Retain the Cursor CLI validator for its separate identity/cache/model-picker policy; do not replace it with a secret regex.

### Pre-commit enforcement

Use the existing Gitleaks pre-commit hook against staged content. Run a separate Gitleaks directory scan for the full current worktree because the pre-commit hook uses `--staged`. Validate in the feature worktree with `pre-commit run`; install the shared hook from `main` only after the tested guard is integrated, and verify the installer continues to install it on normal setup. No CI gate is included in this change. A local hook can be bypassed, so the committed configuration and documented credential policy remain necessary; CI can be added later if enforcement beyond developer workstations is required.

### Config tracking and history safety

Before restoring local-only config paths:

1. Scan every fetched remote branch and tag for the exact previously exposed bearer and for the removed MCP config paths; report only counts/paths, never credential values. Extend the scan to any additional literal candidate confirmed to be a live credential.
2. Confirm the local ignored Codex, OpenCode, and VS Code copies remain intact in the original checkout. Worktrees do not automatically copy these ignored files.
3. Sanitize local copies in the feature worktree using environment/provider references, then remove only the five local-only MCP ignore patterns from `.gitignore` and add the sanitized configs.
4. Verify staged files contain no literal credentials and the full-history/remote-ref scans remain clean before publishing any resulting commits.

The local secret value must be treated as compromised until confirmed rotated or revoked. History rewriting reduces exposure in the targeted refs but does not invalidate a bearer that remains active.

## Scope

### In scope

- `.gitleaks.toml`: enable default rules, remove the all-Markdown allowlist, and add tested generic credential detection.
- `.gitignore`: stop excluding the five MCP config paths after their contents are sanitized.
- Sanitized active configs for Codex, OpenCode, and VS Code MCP, plus any existing assistant config that requires a credential correction.
- Tests/fixtures proving staged secret rejection and safe external-reference acceptance across JSON, TOML, YAML, JSONC, and Markdown.
- End-to-end verification of the existing pre-commit hook in the feature worktree, then local hook installation from `main` after integration.

### Out of scope

- CI secret scanning for this iteration.
- Creating config files for clients that are not currently configured.
- Automatically provisioning, rotating, or storing credentials in a new secret manager.
- Rewriting remote history again unless the required verification finds an actual remaining exposure.
- Removing the Cursor identity/cache validator or broadening it beyond its separate policy.

## Failure Behavior

A staged literal credential causes the pre-commit hook to fail before the commit is created. The message must point to the file and finding type while redacting the matched value. Environment/provider references and safe placeholders pass the synthetic fixtures. If a tracked config cannot function without embedding a real secret, that entry remains untracked/omitted until a supported external-auth path is established.

## Validation

- Fixture tests stage synthetic credential strings in `.json`, `.toml`, `.yaml`, `.jsonc`, and `.md`; each must fail through the actual pre-commit hook.
- Equivalent fixtures using supported environment/provider references and safe placeholders must pass.
- Parse Codex TOML after home expansion and verify the 31 disabled skill paths resolve under the current `~/dotfiles` tree. Substitute `{env:HOME}` in OpenCode config on both `/home/test` and `/Users/test` fixtures and confirm active/disabled plugin prefixes survive JSON parsing.
- Report local OpenCode plugin targets that are absent on this Mac; do not clone, delete, or disable them without the user’s choice.
- A fixture containing a built-in Gitleaks secret pattern must fail, proving built-in rules are active.
- Verify the failure output does not contain the dummy secret.
- Run `pre-commit run --all-files` on the sanitized worktree.
- Run `gitleaks detect --source . --no-git --redact --config .gitleaks.toml` to scan current worktree files; run the staged pre-commit hook separately to verify commit-time enforcement.
- Run a staged-content check for each restored MCP config and confirm all are tracked, ignored rules are removed, and no literal credential is present.
- After fetching remote refs and tags, scan exact exposed-token matches and MCP path history; require zero matches before any config restoration is committed or pushed.

## Success Criteria

- Assistant/MCP configs that contain no private local state can be tracked and work with externally supplied credentials.
- Gitleaks built-in and custom credential rules run on staged files of any path, including Markdown.
- Synthetic credential fixtures are rejected and external-reference fixtures pass without leaking values in output.
- The existing Cursor-specific validator remains active.
- Remote refs and tags pass the required pre-restoration history verification.
- No CI workflow or new scanner dependency is added.
