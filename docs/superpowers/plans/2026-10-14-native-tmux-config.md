# Native tmux config migration Implementation Plan

**Required subskill:** `superpowers:executing-plans` (inline execution, as requested by “lets go”).

## Goal

Replace the upstream Oh My Tmux startup path with the repository-owned native tmux configuration while preserving the user's effective configuration and a tested rollback path.

## Architecture

- `tmux/.tmux.conf` is the native entry point and owns base options, source order, TPM initialization, and final theme loading.
- `tmux/.tmux.conf.local` remains the personal configuration, converted from OMT shell-variable syntax to native tmux commands.
- `tmux/.config/tmux/themes/cobalt2.conf` becomes native tmux syntax and is loaded last.
- A small standalone test under `scripts/test/tmux/` exercises the candidate config on a private socket; any OMT-only behavior that cannot be compared mechanically is reviewed explicitly against a captured baseline.
- The active `~/.tmux.conf` remains untouched until isolated checks pass and the user approves the documented behavior differences and cutover.

## Tech Stack

tmux configuration syntax, Zsh standalone test script, existing TPM installation, GNU Stow-managed dotfiles.

## Spec

[`docs/superpowers/specs/2026-10-14-native-tmux-config-design.md`](../specs/2026-10-14-native-tmux-config-design.md)

## Global Constraints

- Preserve the complete effective keymap and relevant option values, including all 18 active key tables and OMT/tmux/plugin defaults; do not infer inherited behavior is unused.
- Preserve the declared plugin set and options. Initialize TPM after plugin declarations. Do not reintroduce OMT update-on-reload implicitly.
- Replace OMT-only status aliases/helper expansion with native formats or the smallest repo-owned helper; do not depend on `/home/lalitmee/.tmux.conf`.
- Use official Cobalt2 colors; inactive window status foreground is `#FFFFFF`, last-active foreground is `#FFC600`.
- Do not modify/reload the active OMT configuration during isolated verification. Preserve a rollback copy before any eventual cutover.
- Document and obtain user approval for any effective baseline difference before cutover.
- Do not run `./install.sh`, auto-commit, or alter files outside this worktree without authorization.

## Review Focus

1. Missing or renamed key tables/bindings from tmux-version/plugin differences — covered by Task 1 baseline manifest and Task 4 private-socket comparison.
2. OMT option defaults accidentally omitted when converting only local settings — covered by Task 1 option inventory and Task 4 global/session/window option checks.
3. TPM absent or plugin scripts running against a private test server — covered by Task 3 TPM initialization checks and Task 4 isolated plugin-binding verification.
4. OMT status placeholders unresolved or helper values unavailable — covered by Task 3 format validation and Task 4 status-format checks.
5. Invalid native syntax or unsupported option/style on installed tmux — covered by Task 2 isolated config parse and Task 4 startup test.

---

## Files and responsibilities

- `docs/superpowers/plans/2026-10-14-native-tmux-config.md` — this reviewed implementation plan.
- `brain/repo/native-tmux-config/README.md` — current phase and links for this work item.
- `docs/superpowers/specs/2026-10-14-native-tmux-config-design.md` — approved design; authoritative requirements.
- `results/tmux-native-config-baseline.md` — reviewed, sanitized baseline inventory of the live effective key tables and relevant options; no secrets or pane contents.
- `tmux/.tmux.conf` — native startup entry point and load ordering.
- `tmux/.tmux.conf.local` — converted native user settings, bindings and plugin declarations.
- `tmux/.config/tmux/themes/cobalt2.conf` — native Cobalt2 theme, loaded last.
- `tmux/.config/tmux/scripts/status/` — only if a minimal status helper is required after verifying native formats are insufficient.
- `scripts/test/tmux/config.zsh` — standalone private-socket startup and parity regression test.
- `scripts/test/README.md` — exact command and test coverage entry.
- `~/.tmux.conf` and a sibling backup — eventual cutover only after a separate explicit approval; outside this implementation worktree.

## Task 1: Capture the effective OMT baseline

**Interfaces:** consumes the live OMT server and current user config; produces a sanitized baseline inventory for Tasks 2–4.

- [x] Inspect the existing capture commands and record all live key tables and their effective bindings, plus relevant global/session/window options, plugin bindings and expanded status formats in `results/tmux-native-config-baseline.md`.
- [x] Record tmux version and distinguish OMT/plugin-generated behavior from local config; redact machine-specific or sensitive values and exclude pane contents.
- [x] Review the inventory against the approved spec; identify values that cannot be represented as stable assertions and mark them for manual parity review.
- [x] Verify the inventory includes all 595 currently reported bindings; investigate the 17-vs-18 table mismatch and document why the absent table is not recreated.

**Expected:** a complete, sanitized, reviewable baseline. No active config writes or reloads.

## Task 2: Add the failing native-config regression test

**Files:** create `scripts/test/tmux/config.zsh`; modify `scripts/test/README.md`.

**Interfaces:** consumes `tmux/.tmux.conf` and baseline from Task 1; produces a pass/fail report from an isolated socket only.

- [x] Write the standalone Zsh test first. Give it a private socket name, start tmux with `-f tmux/.tmux.conf`, use a temporary server environment, and guarantee server shutdown with `trap`.
- [x] Assert entrypoint startup/parse, all expected tables and binding identities, relevant option values, plugin initialization outcomes (without running install/update operations), status-format resolution, and theme foregrounds.
- [x] Add its exact invocation and behavior to the Tmux section of `scripts/test/README.md`.
- [x] Run `zsh scripts/test/tmux/config.zsh`; confirm the initial failure is due to the not-yet-created native entrypoint, then confirm the finished test passes.

**Expected:** clean, intentional RED on the missing entrypoint; no contact with the active tmux server.

## Task 3: Implement native entrypoint, personal config, and theme

**Files:** create `tmux/.tmux.conf`; convert `tmux/.tmux.conf.local`; convert `tmux/.config/tmux/themes/cobalt2.conf`; add a status helper only if native formats cannot preserve required content.

**Interfaces:** Task 2 test defines required assertions; Task 1 baseline defines behavior to preserve.

- [x] Create `tmux/.tmux.conf` with native base options, explicit source ordering, TPM startup after plugin declarations, and theme load last.
- [x] Convert OMT-only `tmux_conf_*` declarations in `.tmux.conf.local` to equivalent native options/bindings; retain custom tables, scripts, plugins and plugin options.
- [x] Preserve current path behavior, no-session-prompt behavior, terminal color support and clipboard integration using native tmux settings.
- [x] Preserve effective baseline bindings/options; record any differences in a dedicated section of the baseline report and do not accept unapproved behavioral changes.
- [x] Convert the theme to native `set-option`/`set-window-option` syntax and official palette values; set inactive status foreground white and last-active foreground yellow on `#193549`.
- [x] Replace OMT status aliases with native formats or the smallest required helper; keep the existing indicators and status placement/content where practical.
- [x] Run the focused test and confirm GREEN; do not reload the active server during isolated implementation.

**Expected:** native configuration parses on the installed tmux, test passes against agreed baseline assertions, and OMT-only shell syntax is absent from loaded configuration.

## Task 4: Validate parity and document differences

**Files:** modify `scripts/test/tmux/config.zsh` and, if needed, `results/tmux-native-config-baseline.md`.

**Interfaces:** compares Task 3 candidate against Task 1 baseline, using Task 2 test harness.

- [x] Run `zsh scripts/test/tmux/config.zsh` and inspect its complete output.
- [x] Compare all live key tables and relevant global/session/window options against the captured baseline; verify the plugin bindings and status formats after TPM initialization.
- [x] Confirm Cobalt2 palette/required foregrounds and absence of OMT alias dependency.
- [x] Explain each behavioral difference, including OMT-generated helper substitutions; obtain approval before cutover.
- [x] Run the focused tmux tests cataloged in `scripts/test/README.md` that are relevant to changed behavior, plus `pre-commit run --all-files` if available.

**Expected:** isolated config startup succeeds and every baseline difference is either eliminated or explicitly documented and user-approved. No normal socket reload or home config switch.

## Task 5: Cutover and rollback (separate approval gate)

**Files outside worktree:** `~/.tmux.conf` and a timestamped backup beside it. Do not execute this task until the user explicitly approves the verified comparison and cutover.

**Interfaces:** consumes the passing isolated candidate and approved Task 4 difference report; produces a repo-owned normal startup path plus recoverable OMT backup.

- [x] Confirm `~/.tmux.conf` is the expected regular OMT file and the backup target does not already exist.
- [x] Preserve the OMT file byte-for-byte as rollback before changing the active entrypoint.
- [x] Point the legacy entrypoint and required local/theme paths to the repo-owned worktree files; do not run the installer.
- [x] Verify normal startup loads the repo config without sourcing OMT; check representative key tables/options and retain the backup.
- [x] Confirm rollback files preserve the original entrypoint and dependency states.

**Expected:** cutover only after explicit approval, with verified rollback. If approval is not provided, leave Task 5 unexecuted.

## Handoff

The design and plan were approved. Tasks 1–5 were executed inline; Task 5 ran only after separate explicit cutover approval. The active entrypoint and dependencies now resolve to the feature worktree, so keep this worktree available until its native config is moved to the primary checkout or the documented backups are restored.
