# AI Assistant Working Guide

Concise, repo-specific instructions for AI coding agents assisting with these dotfiles. Focus on accuracy, minimal disruption, and following existing conventions.

## Core Purpose & Architecture
- This repo manages personal development environment via GNU Stow symlink deployment (`./install`) into $HOME.
- Structure = many tool-specific directories (e.g. `nvim/`, `tmux/`, `wezterm/`, `zsh/`, `alacritty/`). Files are meant to be idempotent + override defaults.
- Tmux is a major orchestrated subsystem: custom `.tmux.conf.local` (derived from gpakosz/.tmux) + theme fragments under `tmux/tmux-themes/` + custom key tables (brain + AI + layout modes).
- Scripts under `scripts/install/` perform modular provisioning (fonts, gum, tmux-latest, coding stack). They are composed—not a single monolith.
- "Second brain" + AI workflows wired through tmux key tables and `scripts/second-brain` + logs under `scripts/logs/` (naming: `second-brain[-<scope>]-<date>.log`).

## High-Value Commands
- Deploy/update symlinks: `./install` (uses GNU Stow; ensure new dirs/files follow layout for correct stowing).
- Remove symlinks: `./clean-env`.
- Validate HOME resolution: `./scripts/test/test-home`.
- Cron validation: `./scripts/backup/test-cron`.
- Tmux syntax quick check (example): `tmux -f tmux/.tmux.conf.local -c 'echo ok'`.

## Conventions
- Shell & Bash/Zsh scripts: 4-space indent, `#!/usr/bin/env bash|zsh`, quote variables, use `[[ ]]`, guard file sourcing: `[[ -f path ]] && source path`.
- Functions: snake_case; local variables lower_case; exported/env UPPER_CASE.
- Config filenames: kebab-case; scripts: snake_case.
- Prefer small focused scripts placed logically (install steps in `scripts/install/`).
- Tmux key table philosophy: single-letter entrypoints under `C-a` (prefix): `b` (brain), `C-i` (AI tools), `C-b` (layout mode). Within tables: lowercase primary, uppercase variant; always provide `q` to exit.
- All tmux bindings standardized to `bind` (not `bind-key`). Maintain that.

## When Adding/Modifying
- For new tool configs: create directory at repo root (e.g. `ghostty/`) mirroring expected dotfile path; rely on Stow by keeping relative structure.
- For tmux changes: edit `tmux/.tmux.conf.local`; keep folding markers & documentation style; ensure no key conflicts (`tmux list-keys | grep <key>` mentally if adding). Update `AGENTS.md` if key tables change.
- For install steps: add a script under `scripts/install/` and invoke from higher-level orchestrator only if necessary—avoid giant multi-purpose scripts.
- Logging: follow existing log filename patterns in `scripts/logs/`; append, don’t overwrite unless explicitly rotating.

## Safety & Quality
- NEVER auto-commit without explicit user approval (exception: updating meta instruction files if user asked explicitly).
- Before proposing commit: show concise diff summary (group by directory).
- Don’t introduce external dependencies unless clearly beneficial; shell-first mindset.
- Validate tmux config syntax after edits (see command above) if changes touch tmux.

## Style Examples
- Conditional sourcing: `[[ -f "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"`.
- Function scaffold:
  ```bash
  my_task() {
      local target="$1"
      [[ -z "$target" ]] && { echo "Error: missing target" >&2; return 1; }
      # ... logic ...
  }
  ```

## Priorities for AI Edits
1. Preserve existing behavior & key workflows (tmux modes, install flow).
2. Keep documentation parity: update `AGENTS.md` if introducing systemic change.
3. Minimize noise: limit unrelated formatting churn.
4. Provide rationale inline via comments only when non-obvious.

## Out of Scope / Avoid
- Massive refactors of personal preference files without a direct request.
- Introducing opinionated frameworks or rewriting shell in another language.
- Collapsing modular install scripts into a single file.

## Quick Checklist Before Suggesting Commit
- [ ] Follows indentation & naming conventions
- [ ] No tmux key conflicts introduced
- [ ] Install symlink path will be correct (matches target $HOME layout)
- [ ] Instructions & docs updated if behavior changed
- [ ] Diff limited to purposeful changes

Request clarifications if a desired behavior isn’t documented instead of guessing.
