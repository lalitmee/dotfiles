# GEMINI.md

## Directory Overview

This directory contains the personal dotfiles of a developer. It is a well-organized collection of configuration files for various tools, including shells, editors, and other development utilities. The dotfiles are managed using `stow`, a symlink farm manager.

## Build and Test Commands

*   **Install dotfiles**: `./install` (uses GNU Stow to create symlinks)
*   **Clean environment**: `./clean-env` (removes stowed symlinks)
*   **Run basic test**: `./scripts/test/test-home` (logs HOME variable resolution)
*   **Test cron jobs**: `./scripts/backup/test-cron` (validates cron configurations)

## Usage

To use these dotfiles, you would typically clone the repository and then run the `install` script. This will create symlinks from the files in this repository to your home directory.

```bash
git clone https://github.com/lalitmee/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install
```

## Code Style and Conventions

### Shell Scripts (.sh, .zsh)

*   Use 4-space indentation (no tabs)
*   Use `#!/usr/bin/env bash` or `#!/usr/bin/env zsh` shebangs
*   Quote variables: `"$VARIABLE"`
*   Use `[[ ]]` for conditionals instead of `[ ]`
*   Check file existence before sourcing: `[[ -f ~/.file ]] && source ~/.file`

### Lua Files (.lua)

*   Use 4-space indentation
*   Prefer double quotes for strings

### Git Commit Conventions

*   **Type Prefix**: Use conventional prefixes (feat:, fix:, docs:, refactor:, etc.)
*   **Subject Line**: 50 characters max, imperative mood (e.g., "Add feature" not "Added feature")
*   **Body Lines**: 72 characters max per line
*   **Auto-Commit Policy**: NEVER commit changes automatically - always ask user first.

**Example**:

```gitcommit
feat(tmux): add dark mode toggle to settings page

- Implement CSS variables for theme switching
- Add toggle button to header component
```

## Development Conventions

### Shell

*   **Shell:** Zsh is the primary shell, managed with Oh My Zsh.
*   **Prompt:** Powerlevel10k is used for the shell prompt.
*   **Tools:** The shell environment is configured for use with `pyenv`, `rbenv`, `fnm`, `zoxide`, and `atuin`.

### Editor

*   **Editor:** Neovim is the primary editor, with a highly customized configuration.
*   **Plugin Manager:** `lazy.nvim` is used for plugin management.
*   **Key Plugins:** The Neovim setup includes plugins for AI-assisted development, LSP, Telescope, Treesitter, and debugging.
*   **Other Editors:** The user also has configurations for Emacs, VS Code, and Sublime Text.

### Version Control

*   **Git:** Git is heavily used, with a comprehensive set of aliases and a customized diff view using `delta`.
*   **GitHub CLI:** The GitHub CLI is integrated with Git for authentication.
*   **Pull Strategy:** The user prefers to rebase when pulling changes from a remote repository.

### Tmux Configuration

*   **Architecture**: The tmux configuration is based on the `gpakosz/.tmux` template with local overrides in `~/.tmux.conf.local`.
*   **Prefix**: The prefix key is `C-a`.
*   **Key Tables**: The configuration uses multiple key tables for different modes, including a layout mode (`C-b`), an AI tools mode (`C-a C-i`), and a second-brain mode (`C-a b`).
*   **Help System**: A modular help system is implemented to display keybindings in `gum` tables.

### Tmux Development Workflow

After making changes to `tmux/.tmux.conf.local`, you can source the file to apply the changes immediately:

```bash
tmux source-file ~/.tmux.conf.local
```

### Other Tools

*   **Terminal:** The user has configurations for Alacritty, Kitty, and WezTerm.
*   **Window Manager:** There are configuration files for i3, a tiling window manager.
*   **Themes:** The user has a strong preference for a customized and aesthetically pleasing environment, with many themes for different tools.
