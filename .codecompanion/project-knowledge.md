### Project Overview

This repository manages a personal development environment using GNU Stow for dotfile deployment. It contains configurations for various development tools and custom scripts for environment setup and maintenance.

**Key Features:**
- Automated dotfile deployment via GNU Stow
- Modular tool configurations (nvim, tmux, wezterm, zsh, alacritty)
- Custom tmux configuration with specialized key tables
- Second brain and AI workflow integration
- Installation scripts for development tools

**Core Commands:**
- `./install` - Deploy/update symlinks using GNU Stow
- `./clean-env` - Remove symlinks
- `./scripts/test/test-home` - Validate HOME resolution
- `./scripts/backup/test-cron` - Test cron configurations

### Directory Structure

- `/` - Root contains tool-specific directories for Stow deployment
- `/nvim` - Neovim configuration
- `/tmux` - Tmux configuration and themes
- `/zsh` - Zsh shell configuration
- `/scripts/`
  - `/install/` - Modular provisioning scripts
  - `/backup/` - Backup and cron-related scripts
  - `/logs/` - System logs
  - `/second-brain/` - AI and knowledge management workflows

### Code Style

**Shell Scripts:**
- Zsh preferred, 4-space indentation
- Use `#!/usr/bin/env zsh` shebang
- Quote variables, use `[[ ]]` for conditionals
- Snake_case for functions, UPPER_CASE for env vars

**Configuration:**
- Kebab-case for config files
- Snake_case for scripts
- Maintain relative paths for Stow compatibility

### Changelog

*Recent changes will be logged here*