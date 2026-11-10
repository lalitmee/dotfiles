# Portable Theme Fallbacks Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Preserve Cobalt2 on macOS and non-Omarchy hosts while allowing installed Omarchy themes to override appearance.

**Architecture:** Keep portable configuration Cobalt2-first. Use existing generated Omarchy state and supported machine-local settings for optional overrides; do not copy Omarchy-only theme names into shared defaults. Preserve existing layouts, bindings, and explicit user styling arguments.

**Tech Stack:** Bash, Zsh, JSON, Python standalone tests, existing Omarchy templates/hooks.

**Spec:** Approved in-chat recommendation: Cobalt2 defaults everywhere, optional Omarchy overlay; do not change the user's Cobalt2 palette.

## Global Constraints

- No new dependencies, automatic commits, pushes, or installer runs.
- No edits to packaged files under `/usr/share/omarchy`.
- Preserve Cobalt2 theme files and existing non-Omarchy appearance.
- Do not invoke real AI backends during tests.
- Existing tmux, fzf, Neovim, bat, and delta fallback behavior must remain intact.

## Review Focus

- Missing Omarchy files must select Cobalt2, not an unavailable theme name.
- Malformed or incomplete palettes must retain valid fallback colors.
- Explicit Gum style arguments must win over automatic defaults.
- Theme changes must not leave stale inherited Gum backgrounds.
- Machine-local overrides must not overwrite unrelated user settings.

### Task 1: Portable agent theme selection

**Files:**
- Modify: `claude/.claude/settings.json`, `pi/.pi/agent/settings.json`, `opencode/.config/opencode/cli.json`.
- Modify: `scripts/test/config/omarchy-agents.py`, `omarchy/README.md`.
- Potentially modify: `omarchy/.config/omarchy/hooks/theme-set.d/cli-tools`, only if supported local overrides require it.

**Interfaces:**
- Consumes: shipped Cobalt2 theme files and locally installed Omarchy theme files.
- Produces: shared defaults that select shipped Cobalt2 themes, with documented machine-local Omarchy selection.

- [ ] Read full affected files and current official documentation for each application's theme precedence. Confirm supported local override paths before implementing; stop and ask if a tool cannot support the agreed split without a launcher or extension.
- [ ] Extend the isolated deployment test with a clean home containing no Omarchy theme files. Assert portable defaults select shipped Cobalt2 themes and remain valid after repeated Stow runs.
- [ ] Run `python3 scripts/test/config/omarchy-agents.py`; confirm the new portable-default assertions fail before changing config.
- [ ] Set shared Claude/Pi defaults to their shipped Cobalt2 themes and OpenCode to its shipped `cobalt2-custom` theme. Apply Omarchy only through documented local overrides; preserve unrelated settings.
- [ ] Test both missing and present local Omarchy themes, preserving unrelated local settings and the existing system-managed theme files.
- [ ] Rerun the deployment test and validate edited JSON. Document how each local override is selected and updated.

### Task 2: Theme-aware Gum and quote rendering

**Files:**
- Modify: `bin/.config/bin/gum-input`, `bin/.config/bin/gum_style`, `bin/.config/bin/quote`.
- Modify: `zsh/.zsh_plugins_config/gum.zsh`, `tmux/.config/tmux/scripts/popup/ai/tool.sh`.
- Test: `scripts/test/bin/gum/input.py`; add focused quote/style checks alongside it and document commands in `scripts/test/README.md`.

**Interfaces:**
- Consumes: active Omarchy palette at `${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/current/theme/colors.toml`, when readable.
- Produces: existing Gum helper command interfaces and submitted values, unchanged; only automatic styling changes on Omarchy hosts.

- [ ] Reproduce the greenish text background using a terminal-only diagnostic, comparing inherited Gum backgrounds, explicit flags, and ANSI resets. Do not guess its cause.
- [ ] Add mocked-Gum tests for absent, complete, partial, and malformed Omarchy palettes; explicit style overrides; inherited backgrounds; and unchanged cancellation/stdout behavior.
- [ ] Run `TMPDIR=/tmp/opencode python3 scripts/test/bin/gum/input.py` and the new focused checks; confirm new theme assertions fail first.
- [ ] Make the smallest shared styling change that reads valid active palette colors and otherwise retains the exact Cobalt2 defaults. Reuse existing palette handling where practical; do not add an application-wide theme framework.
- [ ] Remove conflicting hard-coded overrides from the AI launcher's filter/spinner only where the shared theme-aware defaults replace them. Keep its behavior and arguments unchanged.
- [ ] Fix the verified background cause and quote/helper argument mismatch without changing quote selection or box layout.
- [ ] Run mocked tests, Bash/Zsh syntax checks, and focused quote checks. Never run the existing AI launcher suite until all installed backend commands are reliably isolated by its fixtures.

### Task 3: Verify the existing fallback integrations

**Files:**
- Add: `scripts/test/config/theme-fallbacks.py`.
- Modify: `scripts/test/README.md`, `omarchy/README.md`.
- Change existing integration code only if a regression check demonstrates a failure within this scope.

**Interfaces:**
- Consumes: existing tmux overlays, fzf refresh function, popup styling, Neovim theme loader, bat config, and delta Git include.
- Produces: standalone isolated checks runnable with `python3 scripts/test/config/theme-fallbacks.py`.

- [ ] Use temporary HOME/XDG directories to assert missing Omarchy state preserves Cobalt2 for each integration; mock external runtimes where necessary.
- [ ] Assert available overlays take precedence, absent generated Git includes are harmless, and stale generated bat paths are cleared where the integration owns them.
- [ ] Run focused checks and repository `pre-commit run --all-files` if available. Report unrelated or unavailable checks rather than expanding scope.
- [ ] Inspect the final diff, reload affected runtimes only where safe, and report which behavior was simulated versus tested on this Linux host. Do not claim macOS runtime verification.

## Execution

Recommended: native execution in this session. The changes share one fallback policy, and isolated checks can cover both environments without dispatching agents or running AI backends. No commits are authorized.

## Execution outcome

Implemented in the main checkout at the user's request. Claude/Pi automatic
selection was explicitly dropped in favor of portable Cobalt2 defaults and
manual theme selection. OpenCode uses Cobalt2 with a documented inline override.
Gum helpers share a validated optional palette reader. Quote color/width argument
mix-up and stale popup bat paths are fixed. Focused tests, mocked AI launcher,
shell syntax, repository hooks, and diff whitespace checks passed. Native macOS
and the original screenshot were not verified. Tests assume `/tmp/opencode` exists.
