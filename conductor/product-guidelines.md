# Product Guidelines

## Development Guidelines

- **Idempotency**: All installation, setup, and cleanup scripts must be idempotent. Running them multiple times on the same system should not cause unintended side effects or configuration corruption.
- **Safe Path Resolution**: Always resolve paths dynamically using `$HOME` or directory-relative structures. Hardcoding specific usernames or path strings is strictly discouraged.
- **No Secrets in VCS**: Secrets, API keys, credentials, or personal tokens must never be tracked in git. Use external environments or ignore files for credential configuration.

## Shell Scripting Standards

- **Error Handling**: Use `set -euo pipefail` in Bash/Zsh scripts to catch execution errors early.
- **Clean Sourcing**: Check for file existence before sourcing config overlays (e.g., `[[ -f ~/.file ]] && source ~/.file`).
- **Defensive Writing**: Validate user inputs and command existence before running them.

## UI/UX Principles

- **Rich Visuals**: Terminal UIs should leverage styled outputs (e.g., using `gum` or custom terminal themes) and keep colors consistent with the cobalt2 palette.
- **Interactive Helpers**: All complex keybinding tables (like in Tmux) should have accessible popups/help overlays to improve discoverability.
- **Non-blocking Operations**: Time-consuming actions (like script running or API calls) should execute asynchronously or in dedicated tmux panes/windows to prevent interface locks.
