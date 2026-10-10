# Repository Guidelines

## Project Structure & Module Organization
This repository is a personal dotfiles tree. Main areas:
- `scripts/` for installer, backup, and validation helpers
- `bin/.config/bin/` for user-facing shell commands
- `tmux/`, `zsh/`, `nvim/`, `git/`, `kitty/`, `alacritty/`, `sxhkd/`, `i3/` for app configs
- `opencode/.config/opencode/command/` and `.agents/skills/` for assistant workflows

## Build, Test, and Development Commands
- `./install.sh` bootstraps the machine and runs the interactive installer; do not run it without explicit user confirmation
- `./scripts/install/main-installer.zsh` runs the interactive installer
- `./clean-env` removes stowed symlinks
- Docker install check: run `./scripts/test/install/docker.sh setup`, then `./scripts/test/install/docker.sh full` (or `phase <0-8>`), then `./scripts/test/install/docker.sh validate`
- `pre-commit run --all-files` runs repo hooks, including gitleaks

## Coding Style & Naming Conventions
- Shell scripts use 4-space indentation, quoted variables, `[[ ... ]]`, and `snake_case` functions
- Lua files use 4 spaces and double-quoted strings
- Config filenames should be `kebab-case`; scripts should be `snake_case`
- Prefer absolute paths in runtime scripts and keep sourcing conditional, for example `[[ -f ~/.file ]] && source ~/.file`

## Testing Guidelines
There is no single unit-test framework for the whole repo. Validate changes with the closest runtime:
- tmux: `tmux source-file ~/.tmux.conf` then `tmux list-keys -T <table>`
- installer changes: use the Docker install check above or test the affected phase
- individual phases: `./scripts/test/install/docker.sh phase <0-8>`
- pre-commit and security checks: `pre-commit run --all-files`

### Adding focused tests
- Group tests by tool or subsystem under `scripts/test/`, using only as much nesting as needed (for example, `tmux/worktree/` for related checks and `bin/bluetooth/` for related commands). Keep filenames concise, kebab-case, and specific to the behavior; avoid repeating the tool name or adding a redundant `test_` prefix when the path already identifies it.
- Keep tests standalone and use the existing language/runtime. Prefer isolated temporary fixtures; do not add a framework or shared runner without a concrete need.
- Make commands runnable from the repository root, and add each focused test to `scripts/test/README.md` with its target, behavior, and exact command. Document supported modes individually.
- Keep validators, security checks, installation harnesses, and support utilities in their own README sections rather than presenting them as focused tests.
- When moving or renaming tests, update active references and path bootstrapping while preserving the test logic and behavior.

## Commit & Pull Request Guidelines
Use conventional commits such as `fix(tmux): ...` or `docs: ...`. Keep subjects imperative and lowercase, and include a short bullet list in the body when the change is non-trivial. Do not auto-commit unless explicitly asked.

PRs should describe what changed, what was tested, and any runtime reloads performed. Include screenshots for visible UI changes and link related issues when relevant.

## Agent-Specific Instructions
After editing config files, reload the affected runtime when practical. For tmux, source `~/.tmux.conf` and verify the live keymap; for i3 or sxhkd, use their normal reload commands. When changing tmux keybindings, check for conflicts and update the corresponding help table if one exists.

## Critical System Rules
- **Never run `./install.sh` without explicit user confirmation.** The system is already set up — symlinks exist and are managed directly via GNU Stow. Unnecessary installer runs may prompt for sudo or modify unrelated state.
- Configs are symlinked from the repo to their target locations via `stow`. Once linked, no further action is needed — changes to repo files are live immediately.
- Use `stow -D <pkg> && stow <pkg>` from the repo root if you ever need to relink a package.
- Nested harness files inside stow packages (for example, `opencode/.config/opencode/AGENTS.md` and `gemini-cli/.gemini/GEMINI.md`) are deployment payloads for the user's home directory, not additional repository-wide guidance. Harnesses generally discover instruction files by the working directory and its ancestors; these nested files may apply when working inside their package subtree, so avoid opening sessions there for unrelated repo work.
