# Technology Stack

This document outlines the core technologies, tools, and environments defined for this dotfiles repository.

## Shell & Command Line Environment

- **Primary Shell**: Zsh with Oh My Zsh and Powerlevel10k theme.
- **Terminal Multiplexer**: Tmux with custom layouts, popup wrappers, and script integration.
- **CLI Utilities**:
  - `fd` / `fdfind` for fast directory and file searches.
  - `fzf` for interactive fuzzy-finding lists and previews.
  - `bat` / `batcat` for syntax-highlighted previews.
  - `zoxide` for quick directory jumping.
  - `gum` for rich, stylized terminal prompts and tables.

## Text Editors & IDEs

- **Neovim**: Highly customized text editor configured via `lazy.nvim` with LSP integration, Emmet/EmmyLua support, and custom overrides.
- **Zed Editor**: Settings and keybinding profiles configured for coding tasks.

## Window & System Management

- **Window Manager**: i3 Window Manager (customized autostart, layout rules, keybindings, and themes).
- **Status & Notifications**: Polybar for status bar info, Dunst for desktop notifications.
- **Launchers & Menus**: Rofi for power menus, app launchers, and applets.
- **Terminal Emulators**: Ghostty, Alacritty, Wezterm.

## Installation & Orchestration

- **GNU Stow**: Symlink management to install individual config modules.
- **Provisioning Scripts**: Bash and Zsh installation scripts grouped into phased modules (`scripts/install/`).
