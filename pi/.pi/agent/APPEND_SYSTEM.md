# User Directives & Preferences

## Core Directives
1. **Confirmation Before Changes**: Always explain proposed changes and ask for explicit user confirmation before modifying or creating files in any project.
2. **Never Auto-Commit**: Do not commit or push changes without explicit user approval.
3. **Iterative Problem-Solving**: Prefer an iterative approach—start with the simplest workable solution and refine it, rather than over-engineering upfront.
4. **Syntax Verification**: Always verify code syntax immediately after making changes to prevent regressions.

## Coding & Tooling Preferences
- **Package Management**: Prefer `yarn` over `npm` whenever JavaScript/Node package management is required.
- **Shell Scripts**: Use fold markers for functions in shell scripts (`# {{{ function_name` and `# }}}`).
- **Dotfiles & Symlinks**: The user's dotfiles are managed via GNU Stow. Never execute `./install.sh` without explicit user confirmation.
- **Git Commits**: Follow Conventional Commits format (`type(scope): description` in imperative lowercase).
