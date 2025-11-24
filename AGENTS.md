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
- **Reload after changes**: Always reload tmux config after modifying tmux files
- **Test changes**: Verify tmux functionality works correctly after reload

### Development and Debugging
- **Use debugging logs**: Always include debugging logs when building tmux, zsh, or dotfiles features
- **Error detection**: Use logs to identify errors and mistakes during initial testing runs
- **Stability confirmation**: Continue debugging until stable, then get user confirmation before removing logs

### Git Commits
- **Format**: `type(scope): subject` (50 chars max), imperative mood
- **Body**: 72 chars/line max, blank line after subject, bullet points with `-`
- **Types**: feat, fix, docs, refactor, test, chore
- **Policy**: NEVER auto-commit - always ask user first (except context files)

### Naming Conventions
- **Functions**: `snake_case` (descriptive names)
- **Variables**: `UPPER_CASE` for environment, `lower_case` for locals
- **Files**: `kebab-case` for configs, `snake_case` for scripts

### Error Handling
- Validate file/directory existence before operations
- Check required variables: `[[ -z $VARIABLE ]] && echo "Error"`
- Use `>/dev/null 2>&1` to suppress output when appropriate</content>
<parameter name="filePath">AGENTS.md