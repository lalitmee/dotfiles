# AGENTS.md: AI Contributor Guide

## Build/Test Commands
- **Install dotfiles**: `./install.sh` (POSIX shell) or `./scripts/install/main-installer.zsh` (interactive Zsh)
- **Clean environment**: `./clean-env` (removes stowed symlinks)
- **Test installation**: `./scripts/test/docker-test.sh setup/full/validate` (Docker-based testing)
- **Run single test**: `./scripts/test/docker-test.sh phase <0-8>` (test individual installation phases)
- **Pre-commit checks**: `pre-commit run --all-files` (gitleaks security scanning)

## Code Style Guidelines

### Shell Scripts (.sh, .zsh)
- **Indentation**: 4 spaces (no tabs), POSIX compliance where possible
- **Shebangs**: `#!/usr/bin/env bash` or `#!/usr/bin/env zsh`
- **Variables**: Quote all: `"$VARIABLE"`, use `[[ ]]` for conditionals
- **Functions**: `snake_case` with descriptive names, group related code
- **Error handling**: Check file existence before sourcing, validate required variables
- **Imports**: Source conditionally: `[[ -f ~/.file ]] && source ~/.file`

### Lua Files (.lua)
- **Indentation**: 4 spaces, double quotes for strings
- **Style**: Follow EmmyLua conventions, keep call argument parentheses
- **Formatting**: Use .editorconfig settings for consistency

### Configuration Files
- **Naming**: `kebab-case` for config files, group settings with comments
- **Paths**: Use absolute paths when possible, document complex configs

### Tmux Configuration
- **Auto-reload after edits**: After editing ANY tmux config file (`tmux/*.conf`, `tmux/*.local`), immediately run `tmux source-file ~/.config/tmux/.tmux.conf` to apply changes
- **Test changes**: Verify tmux functionality works correctly after reload
- **NEVER kill tmux server**: NEVER run `tmux kill-server` or similar destructive commands
- **Binding verification**: After changing a tmux binding, inspect the live keymap with `tmux list-keys -T <table>` and confirm the exact command that will run
- **Shell compatibility**: Before introducing or editing tmux-launched scripts, verify the script runs under the machine's actual `/bin/sh` or `/bin/bash` version, not just a newer local shell
- **Runtime paths**: Prefer explicit absolute paths for tmux-launched binaries and scripts when PATH may differ inside tmux
- **Keybinding migration**: The `tmux-floax` plugin (previously bound to `C-a m`) has been removed and replaced with a `tmux-tpad` scratchpad instance bound to `C-a C-d s` (under the `dev-mode` key table)

### Development and Debugging
- **Use debugging logs**: Always include debugging logs when building tmux, zsh, or dotfiles features
- **Error detection**: Use logs to identify errors and mistakes during initial testing runs
- **Stability confirmation**: Continue debugging until stable, then get user confirmation before removing logs
- **Reproduce first**: Capture the exact failing command, key sequence, or script invocation before changing code
- **Trace the entrypoint**: Verify the live config source, the binding table, and the launched script path before assuming the failure is in the script body
- **Check version-sensitive syntax**: Look for Bash, Zsh, tmux, or GNU/BSD differences when a script works in one shell but fails from tmux
- **Minimal proof**: Re-run the smallest possible command path after each change to confirm the failure moved or disappeared

### Git Commits
- **Format**: `type(scope): subject` — imperative mood, 50 chars max, lowercase only
- **Body**: Required — at least one bullet point (`-`), hard-wrapped at 72 chars/line max
- **Body style**: Lowercase for general text; capitalize proper nouns, code, and acronyms
- **Types**: feat, fix, docs, refactor, test, chore
- **Policy**: NEVER auto-commit — always ask user first (except context files)

### Naming Conventions
- **Functions**: `snake_case` (descriptive names)
- **Variables**: `UPPER_CASE` for environment, `lower_case` for locals
- **Files**: `kebab-case` for configs, `snake_case` for scripts

### Error Handling
- Validate file/directory existence before operations
- Check required variables: `[[ -z $VARIABLE ]] && echo "Error"`
- Use `>/dev/null 2>&1` to suppress output when appropriate</content>
<parameter name="filePath">AGENTS.md
