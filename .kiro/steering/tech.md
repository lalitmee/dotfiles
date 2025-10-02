# Technology Stack

## Build System & Package Management

- **GNU Stow**: Primary configuration management via symlinks
- **Zsh**: Main installation scripting language with enhanced error handling
- **Docker**: Testing framework for safe validation of installation phases

## Core Technologies

### Shell & Terminal
- **Zsh** with Oh My Zsh framework
- **Powerlevel10k** prompt theme
- **Tmux** for terminal multiplexing
- **Ghostty** as primary terminal emulator

### Development Environment
- **Neovim** with lazy.nvim plugin manager
- **i3 window manager** with i3ass suite
- **Git** with extensive aliases and delta for diffs
- **Ripgrep**, **fzf**, **bat** for enhanced CLI tools

### Language Support & Version Management
- **Python**: pyenv for version management, pipx for isolated packages
- **Node.js**: fnm (Fast Node Manager) for version management
- **Ruby**: rbenv for version management
- **Rust**: cargo for package management
- **Go**: go install for binary installation
- **Lua**: For Neovim configuration

### Configuration Languages
- **YAML/TOML**: Configuration files
- **Lua**: Neovim configuration and styling
- **Shell scripts**: Installation and utility scripts
- **Markdown**: Documentation

## Common Commands

### Installation & Setup
```bash
# Full system installation
./install.sh                           # Bootstrap installer
./scripts/install/main-installer.zsh   # Interactive installer

# Configuration management
stow <package>                          # Symlink specific config
./clean-env                            # Remove all symlinks
```

### Testing & Validation
```bash
# Docker-based testing
./scripts/test/docker-test.sh setup     # Setup test environment
./scripts/test/docker-test.sh phase 1   # Test specific phase
./scripts/test/docker-test.sh full      # Test full installation

# Manual testing
./scripts/test/test-home                # Test HOME resolution
./scripts/backup/test-cron              # Test cron configurations
```

### Development Workflow
```bash
# Tmux session management
tmux source ~/.tmux.conf.local          # Reload tmux config
C-a C-r                                 # Launch project runner
C-a b                                   # Second-brain table
C-a C-i                                 # AI tools table

# Configuration editing
nvim ~/.config/nvim/init.lua            # Edit Neovim config
nvim ~/dotfiles/tmux/.tmux.conf.local   # Edit tmux config
```

### Code Quality & Formatting
```bash
# Lua formatting (Neovim configs)
stylua --config-path stylua.toml .

# Shell script validation
shellcheck scripts/**/*.sh
```

## Dependencies

### System Requirements
- Ubuntu 20.04+ or compatible Debian-based system
- sudo privileges
- Internet connection
- At least 5GB free disk space

### Core Dependencies (Auto-installed)
- git, curl, zsh, stow
- build-essential, unzip, fontconfig
- gum (for styled terminal output)

### Optional Dependencies
- Docker (for testing framework)
- X11 (for GUI applications in testing)