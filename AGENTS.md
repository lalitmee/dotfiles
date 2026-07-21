# Repository Guidelines

## Project Structure & Module Organization
This repository is a personal dotfiles tree. Main areas:
- `scripts/` for installer, backup, and validation helpers
- `bin/.config/bin/` for user-facing shell commands
- `tmux/`, `zsh/`, `nvim/`, `git/`, `kitty/`, `alacritty/`, `sxhkd/`, `i3/` for app configs
- `opencode/.config/opencode/command/` and `.agents/skills/` for assistant workflows

## Build, Test, and Development Commands
- `./install.sh` installs the dotfiles with GNU Stow
- `./scripts/install/main-installer.zsh` runs the interactive installer
- `./clean-env` removes stowed symlinks
- `./scripts/test/docker-test.sh setup/full/validate` runs the full Docker install check
- `./scripts/test/docker-test.sh phase <0-8>` runs one installer phase
- `pre-commit run --all-files` runs repo hooks, including gitleaks

## Coding Style & Naming Conventions
- Shell scripts use 4-space indentation, quoted variables, `[[ ... ]]`, and `snake_case` functions
- Lua files use 4 spaces and double-quoted strings
- Config filenames should be `kebab-case`; scripts should be `snake_case`
- Prefer absolute paths in runtime scripts and keep sourcing conditional, for example `[[ -f ~/.file ]] && source ~/.file`

## Testing Guidelines
There is no single unit-test framework for the whole repo. Validate changes with the closest runtime:
- tmux: `tmux source-file ~/.tmux.conf` then `tmux list-keys -T <table>`
- installer changes: `./scripts/test/docker-test.sh setup/full/validate`
- individual phases: `./scripts/test/docker-test.sh phase <0-8>`
- pre-commit and security checks: `pre-commit run --all-files`

## Commit & Pull Request Guidelines
Use conventional commits such as `fix(tmux): ...` or `docs: ...`. Keep subjects imperative and lowercase, and include a short bullet list in the body when the change is non-trivial. Do not auto-commit unless explicitly asked.

PRs should describe what changed, what was tested, and any runtime reloads performed. Include screenshots for visible UI changes and link related issues when relevant.

## Agent-Specific Instructions
After editing config files, reload the affected runtime immediately. For tmux, source `~/.tmux.conf` and verify the live keymap; for i3 or sxhkd, use their normal reload commands. If new stowed files were added, rerun `./install.sh`.
