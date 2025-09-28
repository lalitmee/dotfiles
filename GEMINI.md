# Gemini Context File - Dotfiles Repository

## Project Overview

This is a comprehensive personal dotfiles repository for a developer. It is a well-organized collection of configuration files for various tools, including shells, editors, and other development utilities.

- **Primary Shell**: Zsh with Oh My Zsh and Powerlevel10k
- **Primary Editor**: Neovim (highly customized with lazy.nvim)
- **Terminal Multiplexer**: Tmux with extensive customization
- **Package Management**: GNU Stow for symlink management
- **Version Control**: Git with extensive aliases and delta for diffs

## Installation & System Management

### **Enhanced Installation System**

The primary method for setup is the enhanced interactive installer, which provides a robust, phase-based installation with error handling, rollbacks, and logging.

- **Interactive Installer**: `./scripts/install/main-installer.zsh` (RECOMMENDED)
- **Troubleshooting Guide**: `scripts/install/TROUBLESHOOTING.md`

There are several modes available:
- **Full Installation**: Complete system setup (all 8 phases).
- **Custom Installation**: Select specific phases to install.
- **Single Phase**: Install individual components.

### **Legacy Commands**

- **Legacy Install**: `./install` (uses GNU Stow - basic mode)
- **Clean**: `./clean-env` (removes symlinks)
- **Test**: `./scripts/test/test-home` and `./scripts/backup/test-cron`

**Note**: Always refer to `SYSTEM_SETUP_CONTEXT.md` for the user's current tool choices and the logic behind the installation phases. The system is tested using a Docker framework.

## Code Style & Conventions

### Shell Scripts (.sh, .zsh)

- 4-space indentation (no tabs)
- Shebangs: `#!/usr/bin/env bash` or `#!/usr/bin/env zsh`
- Quote variables: `"$VARIABLE"`
- Use `[[ ]]` for conditionals
- Check file existence: `[[ -f ~/.file ]] && source ~/.file`
- **Fold Markers**: Use fold markers for functions to improve readability and organization. Example:
  ```zsh
  # -------------------------------------------------------------------
  # NOTE: my function {{{
  # -------------------------------------------------------------------
  my_function() {
    # ...
  }
  # -------------------------------------------------------------------
  # }}}
  # -------------------------------------------------------------------
  ```

### Lua Files (.lua)

- 4-space indentation
- Double quotes for strings

### Git Commit Conventions

- **CRITICAL**: NEVER auto-commit changes. Always ask the user first: "Would you like me to commit these changes?"
- **Exception**: Context files like this one can be committed automatically if the changes are purely for context update.
- **Format**: `type(scope): description` (e.g., `feat(tmux): add new binding`)
- **Subject**: 50 characters max, imperative mood.
- **Body**: 72 characters per line.

## Development Environment & Workflow

### Primary Tools

Based on `SYSTEM_SETUP_CONTEXT.md`, the user's primary tools are:

- **Terminal**: Ghostty
- **Browser**: Brave & Firefox
- **Editor**: Neovim
- **Window Manager**: i3-wm
- **Status Bar**: Polybar
- **Launcher**: Rofi
- **Shell**: Zsh (with Oh My Zsh, Powerlevel10k)
- **Key Tools**: `pyenv`, `rbenv`, `fnm`, `zoxide`, `atuin`, `lazygit`, `ripgrep`, `bat`

### Version Control

- **Git**: Heavily used with custom aliases and `delta` for diffs.
- **Pull Strategy**: The user prefers to **rebase** when pulling changes.
- **GitHub CLI**: Integrated for authentication and workflow.

## Tmux Configuration

### Architecture

- **Base**: `gpakosz/.tmux` template.
- **Customizations**: `~/dotfiles/tmux/.tmux.conf.local` is the version-controlled source of truth.
- **Scripts**: Custom scripts are located in `~/.config/tmux/scripts/`.

### Keybindings

- **Prefix**: The prefix key is `C-a`.
- **Key Tables**: The configuration uses multiple key tables for different modes, including a layout mode (`C-b`), an AI tools mode (`C-a C-i`), and a second-brain mode (`C-a b`).
- **Help System**: A modular help system is implemented to display keybindings in `gum` tables.

### Tmux Development Workflow

After making changes to `tmux/.tmux.conf.local`, you can source the file to apply the changes immediately:

```bash
tmux source-file ~/.tmux.conf.local
```

## My Problem-Solving Workflow

1.  **Confirm My Understanding**: Before implementing a solution, I will first re-state the user's goal in my own words. This is to ensure I have not misunderstood the request. *Example: "My understanding is you want to remove the preview window, not add one. Is this correct?"*
2.  **State My Hypothesis**: Before making a change, I will briefly explain what I believe the problem is and why my proposed solution will fix it. This gives the user a chance to correct my assumptions early.
3.  **Analyze Holistically**: If a change I make results in unexpected behavior, I will stop and re-evaluate the entire context. I will avoid making a narrow assumption and instead analyze the interaction between all relevant configuration files and settings before proposing a new fix.
4.  **Make Precise Changes**: I will strive to make the smallest, most targeted change possible to solve the problem. When I must revert a change, I will be explicit about what I am reverting to avoid undoing other necessary fixes.
5.  **Verify Permissions**: After creating a script that is meant to be executed, I will always verify and set its executable permissions (e.g., `chmod +x`).
6.  **Leverage User Feedback & Direct Simulation**: When debugging complex issues, especially those involving UI or shell interpretation, actively solicit user feedback on symptoms and consider their suggestions for debugging. If possible, simulate problematic commands directly using `run_shell_command` to observe exact output, rather than relying on assumptions or indirect debugging methods.
7.  **Immediate Context Update**: Upon successful resolution of a problem, I will immediately update the relevant context files (e.g., `GEMINI.md`) with the solution and any new insights, to prevent re-debugging or loss of knowledge.

### Context Maintenance

I will proactively update this `GEMINI.md` file whenever a new rule, preference, workflow, or lesson learned is discovered during our interactions. This ensures that important context is not lost and that I continuously adapt to your way of working.

## User Preferences

- **UI/UX**: The user appreciates rich, styled terminal UI using tools like `gum` for outputting information and for providing a better user experience.

### Key System (v2.1 - Production Ready)

- **Prefix**: `C-a`
- **Layout Mode**: `C-b` (for window/pane management)
- **AI Tools**: `C-a C-i` (where I am integrated)
- **Second-Brain**: `C-a b` (for notes, todos, etc.)

### Help System

- A modular help system using `gum` displays keybindings in tables.
- **Location**: `~/.config/tmux/scripts/help/`
- **Maintenance**: When changing keybindings, the corresponding `.txt` file in the `tables/` subdirectory MUST be updated.

### Tmux Development Workflow

1.  **Edit**: Make changes in `~/dotfiles/tmux/.tmux.conf.local`.
2.  **Source**: Run `tmux source-file ~/.tmux.conf.local` to apply changes.
3.  **Test**: Manually test the new functionality and keybindings.
4.  **Update Help**: If a keybinding was changed, update the relevant file in `~/.config/tmux/scripts/help/tables/`.
5.  **Document**: Update `AGENTS.md` or other context files if necessary.

## AI Assistant Guidelines (My Role)

### Core Directives

1.  **NEVER AUTO-COMMIT**: Always ask for permission before committing changes, except for context files.
2.  **BE THOROUGH**: Read multiple files to understand the full context before making changes. Do not assume.
3.  **TEST CHANGES**: Especially for `tmux`, validate syntax and functionality before considering a task complete.
4.  **USE THE RIGHT TOOLS**: Use the enhanced installation system (`./scripts/install/main-installer.zsh`) for any system setup tasks.
5.  **RESPECT CONVENTIONS**: Adhere strictly to the coding styles, naming conventions, and workflows outlined in the context files.
6.  **UPDATE DOCUMENTATION**: When changing keybindings, update the `tmux` help tables.

### My Integration

- I am one of the integrated AI assistants.
- My keybinding is `C-a C-i g` to invoke me (Gemini).

### Important Notes for Me

- When in doubt, consult the context files: `AGENTS.md`, `CLAUDE_CONTEXT.md`, and `SYSTEM_SETUP_CONTEXT.md`.
- Use parallel tool calls to gather information efficiently.
- Provide clear explanations for your changes and findings.
- If you discover a new workflow or a better way of doing things, update the context files for future reference.

## Zsh & fzf-tab Configuration Notes

Based on our recent interaction, here are key principles for configuring Zsh, specifically with `fzf-tab` and `zoxide`:

1.  **Initialization Order is Critical**: Any `zstyle` configurations for `fzf-tab` **must** be defined *before* the `fzf-tab` plugin is loaded by Oh My Zsh (i.e., before `source $ZSH/oh-my-zsh.sh`).
2.  **Command-Specific Rules**: Some `fzf-tab` completions (like for `zoxide`'s `z` command) require at least one active `zstyle` rule for their specific completion group (e.g., `:fzf-tab:complete:z:*`) to function. If no flags are needed, an empty rule like `zstyle ':fzf-tab:complete:z:*' fzf-flags ''` should be used to ensure `fzf-tab` engages.
3.  **Layout Control**: To make the completion menu appear below the prompt (instead of full-screen), the global style `zstyle ':fzf-tab:*' fzf-down 'yes'` should be used. This is preferable to managing height with `fzf-flags`.

### Z Command Completion - Current Solution

**Problem**: No tab completions when pressing tab after the `z` command from zoxide.

**Root Cause Identified**: fzf-tab plugin had compatibility issues and was not loading properly, causing completion system conflicts.

**Final Solution Applied**:
- **Fixed fzf-tab loading order** - Load before oh-my-zsh plugins that wrap widgets
- **Proper zstyle configuration** for z command completion
- **Manual completion registration** for z command
- **Correct initialization sequence**: zoxide → compdef → fzf-tab

**Configuration Details**:
```zsh
# fzf-tab global settings
zstyle ':fzf-tab:*' fzf-down 'yes'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'ls -la $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-flags '--height=40%'

# Initialize zoxide first
eval "$(zoxide init zsh)"

# Register completion for z command BEFORE fzf-tab loads
compdef '_files -/' z

# Load fzf-tab BEFORE oh-my-zsh (critical for proper loading)
source ~/.oh-my-zsh/custom/plugins/Aloxaf/fzf-tab/fzf-tab.zsh

# Then load oh-my-zsh
source $ZSH/oh-my-zsh.sh
```

**How to Use**:
1. Type `z ` (with space)
2. Press `Ctrl+G` instead of `Tab`
3. Select directory from fzf interface
4. Press Enter to execute

**Expected Behavior**:
- `z ` + `Ctrl+G` shows fzf interface with directory previews
- Arrow keys navigate, Enter selects
- Preview pane shows directory contents
- Selected directory is inserted into command line

**Alternative**: If you prefer tab completion, you can try reinstalling fzf-tab or using a different completion plugin.

### Additional Fix for Tmux Integration

**Problem**: z command completion worked in new tmux windows but failed in subsequent windows.

**Root Cause**: Tmux was running zsh with `default-command "exec /bin/zsh"`, which prevented interactive shell initialization and .zshrc sourcing.

**Solution Applied**:
- Added `set -g default-command "${SHELL}"` to tmux configuration
- This ensures zsh runs as an interactive shell, properly sourcing .zshrc
- Location: `tmux/.tmux.conf.local` in the shell configuration section

**Result**: fzf-tab configurations now persist across all tmux windows and panes.

## My Problem-Solving Workflow

To reduce unnecessary back-and-forth and improve efficiency, I will adhere to the following workflow:

1.  **Confirm My Understanding**: Before implementing a solution, I will first re-state the user's goal in my own words. This is to ensure I have not misunderstood the request. *Example: "My understanding is you want to remove the preview window, not add one. Is this correct?"*
2.  **State My Hypothesis**: Before making a change, I will briefly explain what I believe the problem is and why my proposed solution will fix it. This gives the user a chance to correct my assumptions early.
3.  **Analyze Holistically**: If a change I make results in unexpected behavior, I will stop and re-evaluate the entire context. I will avoid making a narrow assumption and instead analyze the interaction between all relevant configuration files and settings before proposing a new fix.
4.  **Make Precise Changes**: I will strive to make the smallest, most targeted change possible to solve the problem. When I must revert a change, I will be explicit about what I am reverting to avoid undoing other necessary fixes.
5.  **Verify Syntax After Changes**: After modifying any code, I will verify its syntax to ensure correctness and prevent regressions. For shell scripts, I will use `zsh -n` or `bash -n`.
6.  **Verify Permissions**: After creating a script that is meant to be executed, I will always verify and set its executable permissions (e.g., `chmod +x`).
7.  **Leverage User Feedback & Direct Simulation**: When debugging complex issues, especially those involving UI or shell interpretation, actively solicit user feedback on symptoms and consider their suggestions for debugging. If possible, simulate problematic commands directly using `run_shell_command` to observe exact output, rather than relying on assumptions or indirect debugging methods.
8.  **Immediate Context Update**: Upon successful resolution of a problem, I will immediately update the relevant context files (e.g., `GEMINI.md`) with the solution and any new insights, to prevent re-debugging or loss of knowledge.

### Context Maintenance

I will proactively update this `GEMINI.md` file whenever a new rule, preference, workflow, or lesson learned is discovered during our interactions. This ensures that important context is not lost and that I continuously adapt to your way of working.

## User Preferences

- **UI/UX**: The user appreciates rich, styled terminal UI using tools like `gum` for outputting information and for providing a better user experience.

## User Preferences

- **Color Palette**: The user's preferred color palette is **cobalt2**. When implementing or modifying UI components, this theme should be used as the default. The primary yellow from this theme is `#ffc600` (ANSI 8-bit: `227`).