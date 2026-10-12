# Global Worktree Creation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Configure the global manager's discovery roots and add a dedicated-window picker that launches the existing custom worktree creation flow for a selected main worktree.

**Architecture:** Add a small config library that reads canonical scan roots, with `~/Projects` as the missing-config default. Extend discovery and the manager to aggregate those roots while deduplicating repositories across overlapping roots. Add a create-picker action that lists main worktrees, opens a dedicated tmux window for selection, then runs the existing `git-worktree.sh create` flow in the selected repository.

**Tech Stack:** Zsh, Git worktree porcelain, fzf, tmux; standalone Zsh tests under `scripts/test/`.

**Spec:** `docs/superpowers/specs/2026-10-12-global-worktree-create-and-roots-design.md`

## Global Constraints

- Keep the manager's existing custom discovery and lifecycle actions; do not add a custom/Workmux backend toggle or integrate Workmux.
- Add `$XDG_CONFIG_HOME/worktree-manager/roots` as the user-level configuration file (defaulting to `~/.config/worktree-manager/roots`) containing scan roots, one path per line.
- When no configuration file exists, retain `~/Projects` as the default root. An existing but empty file means no roots are configured; it does not silently restore the default.
- Missing or inaccessible roots should produce a useful diagnostic without preventing valid roots from being scanned.
- Keep main worktrees hidden by default in the regular worktree list; retain the existing main visibility toggle.
- Keep current open, checkout, rename, and remove semantics and safety checks unchanged.
- Preserve paths with spaces and shell metacharacters by passing arguments safely; do not construct an unquoted command string from picker output.
- Do not alter `workmux-palette.sh`, Workmux configuration, or existing Workmux behavior.
- Do not commit changes unless explicitly asked.

## Review Focus

- Configured roots overlap or point inside one repository: aggregate discovery must emit its repository/worktrees once by canonical Git common-directory identity (Task 1 test).
- Root path has spaces, `~` prefix, or relative components: resolve without word splitting and canonicalize before deduplication (Task 1 tests).
- Config file is missing, empty, unreadable, or includes nonexistent roots: distinguish missing-default from empty-config and continue scanning valid roots (Task 1 tests).
- Picker returns a forged, stale, or linked-worktree selection: only a selected main-worktree record may launch creation (Task 2 tests).
- Repository path contains spaces or shell metacharacters, or user cancels picker: preserve argument boundaries and launch no create command on cancellation (Task 2 tests).

---

### Task 1: Configurable multi-root discovery

**Files:**
- Create: `tmux/.config/tmux/scripts/lib/worktree-manager/config.zsh`
- Modify: `tmux/.config/tmux/scripts/lib/worktree-manager/discovery.zsh`
- Modify: `tmux/.config/tmux/scripts/worktree-manager.sh`
- Test: `scripts/test/tmux/worktree/manager.zsh`

**Interfaces:**
- Produces: `worktree_manager_config_path() -> path` returns `$XDG_CONFIG_HOME/worktree-manager/roots`, or `$HOME/.config/worktree-manager/roots` when `XDG_CONFIG_HOME` is unset/empty.
- Produces: `load_worktree_roots [config_path]` writes canonical root paths as NUL-delimited records to stdout and diagnostics to stderr. Missing config emits canonical `$HOME/Projects`; an existing empty config emits no roots. Ignore blank/comment lines, expand `~` and resolve relative paths from `$HOME`, discard duplicate canonical roots, and warn/skip missing or unreadable roots.
- Produces: `discover_worktrees <root>...` accepts multiple roots and emits each repository's records once across the combined scan, keyed by canonical Git common-directory identity.
- Consumes: Existing six-field NUL records and existing one-root `manager_main <root>` test usage; preserve one-root invocation compatibility.

- [ ] **Step 1: Add failing config-loader and manager-integration tests**

Add a `config` suite to `scripts/test/tmux/worktree/manager.zsh`. Assert: the config path follows `XDG_CONFIG_HOME` or falls back to `~/.config`; missing config returns the canonical Projects root; an empty file returns no records; blank/comment lines are ignored; `~/...`, home-relative paths, and paths containing spaces resolve correctly; duplicate canonical roots appear once; missing roots are skipped with diagnostics while valid roots remain. With discovery stubbed and a temporary `XDG_CONFIG_HOME`, assert manager startup without explicit roots passes all configured roots to discovery.

- [ ] **Step 2: Run the config suite and verify it fails**

Run: `zsh scripts/test/tmux/worktree/manager.zsh config`
Expected: FAIL because the config library and loader are not implemented.

- [ ] **Step 3: Implement `worktree_manager_config_path` and `load_worktree_roots` in `config.zsh`**

Use line-by-line reads and NUL-delimited output; do not evaluate config contents as shell code. Canonicalize valid directories with zsh path modifiers after checking existence/readability.

- [ ] **Step 4: Add failing multi-root discovery assertions**

Extend the `discovery` suite with overlapping roots and roots containing spaces. Assert the combined result includes each repository/worktree once, including an outside linked worktree, and preserves the existing six-field record format.

- [ ] **Step 5: Run the discovery suite and verify it fails**

Run: `zsh scripts/test/tmux/worktree/manager.zsh discovery`
Expected: FAIL because discovery currently accepts one root and does not deduplicate across invocations.

- [ ] **Step 6: Implement multi-root discovery and manager root loading**

Refactor `discover_worktrees` to scan all supplied roots and deduplicate by canonical Git common directory across the full invocation. Update normal manager startup to load configured roots; preserve `manager_main <root>` for existing focused tests and explicit single-root use. Ensure cache identity accounts for the ordered canonical root set rather than only one root.

- [ ] **Step 7: Run config and discovery suites**

Run: `zsh scripts/test/tmux/worktree/manager.zsh config && zsh scripts/test/tmux/worktree/manager.zsh discovery`
Expected: both report PASS.

### Task 2: Main-worktree create picker

**Files:**
- Create: `tmux/.config/tmux/scripts/lib/worktree-manager/creation.zsh`
- Modify: `tmux/.config/tmux/scripts/worktree-manager.sh`
- Modify: `scripts/test/tmux/worktree/manager.zsh`
- Modify: `scripts/test/README.md`

**Interfaces:**
- Consumes: `load_worktree_roots` and `discover_worktrees <root>...` from Task 1.
- Produces: `worktree_create_picker <roots...>` lists only valid main-worktree records in fzf. On selection, it changes the dedicated picker window's directory to the selected repository and execs `tmux/.config/tmux/scripts/git/git-worktree.sh create`.
- Produces: `manager_launch_create` opens a dedicated tmux window running the picker while leaving the global manager window available.
- Existing custom `git-worktree.sh create` and `worktree-create.sh` remain the sole creation/provisioning implementation.

- [ ] **Step 1: Add failing create-picker and manager-key tests**

Extend the `interface` suite to assert: the create key is shown in the manager header and included in fzf `--expect`; selecting a main record creates one dedicated picker window; the picker sees main records from all configured roots but not linked records; selection dispatches the existing `git-worktree.sh create` script with the selected repository as cwd; a path containing spaces remains one argument; cancellation or an invalid/non-main selection launches no create command. Keep the existing main visibility toggle tests unchanged.

- [ ] **Step 2: Run the interface suite and verify it fails**

Run: `zsh scripts/test/tmux/worktree/manager.zsh interface`
Expected: FAIL because the create action is not yet present.

- [ ] **Step 3: Verify the create key against the active fzf bindings**

Use `ctrl-o`: fzf 0.59's documented defaults do not assign it, and the current `FZF_DEFAULT_OPTS` binds only `ctrl-a`, `ctrl-j`, `ctrl-k`, and `ctrl-d`. Check `fzf --man` and the configured `FZF_DEFAULT_OPTS`/`FZF_DEFAULT_OPTS_FILE` during implementation; if local configuration now assigns `ctrl-o`, choose a different unused non-navigation key. Never bind `ctrl-n` or `ctrl-p` for create. Update the manager header and `--expect` list with the verified key.

- [ ] **Step 4: Implement the creation picker and dedicated window launch**

Implement `worktree_create_picker` in `creation.zsh`; source it from the manager and route the verified key to `manager_launch_create`. The picker must resolve fzf's selected ID against its own record arrays, validate the selected record has the `main` flag, and use safely quoted arguments when launching the existing script. Run the picker in the dedicated window so the manager remains available; do not add another intermediate window.

- [ ] **Step 5: Run the interface suite and full manager test**

Run: `zsh scripts/test/tmux/worktree/manager.zsh interface && zsh scripts/test/tmux/worktree/manager.zsh all`
Expected: all manager suites report PASS.

- [ ] **Step 6: Update the focused-test catalog and run final verification**

Update the existing Global worktree manager row in `scripts/test/README.md` to mention config and create-picker coverage. Run: `zsh scripts/test/tmux/worktree/manager.zsh all`.
Expected: `PASS: global worktree discovery`, `PASS: global worktree actions`, and `PASS: global worktree interface`.
