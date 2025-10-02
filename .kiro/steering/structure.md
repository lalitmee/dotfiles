# Project Structure

## Repository Organization

The dotfiles repository follows a modular structure where each tool has its own directory containing configuration files that mirror the target system layout.

### Root Level Files
- `install.sh` - Bootstrap installer (POSIX-compliant entry point)
- `clean-env` - Removes all stowed symlinks
- `README.md` - Project overview and quick start
- `CONTEXT.md` - Comprehensive project documentation
- `SYSTEM_SETUP_CONTEXT.md` - Installation decisions and system setup guide
- `.editorconfig` - Code formatting rules for different file types
- `stylua.toml` - Lua code formatting configuration

### Core Directories

#### Installation System
```
scripts/
├── install/
│   ├── main-installer.zsh     # Interactive installer (primary)
│   ├── utils.zsh              # Shared utility functions
│   ├── phases/                # 8 installation phases (00-08)
│   └── TROUBLESHOOTING.md     # Comprehensive troubleshooting guide
├── test/                      # Testing framework
└── backup/                    # Backup and cron scripts
```

#### Configuration Packages (Stow-managed)
Each directory represents a "stow package" that can be independently symlinked:

```
nvim/                          # Neovim configuration
├── .config/nvim/
│   ├── init.lua              # Main configuration entry point
│   ├── lua/                  # Modular Lua configuration
│   └── lazy-lock.json        # Plugin version lock file

tmux/                         # Tmux configuration
├── .tmux.conf.local          # Main tmux customizations
├── .config/tmux/scripts/     # Custom tmux scripts
└── tmux-themes/              # Theme collection

zsh/                          # Zsh configuration
├── .zshrc                    # Main zsh configuration
├── .zsh_aliases              # Command aliases
├── .zsh_functions            # Custom functions
└── .p10k.zsh                 # Powerlevel10k theme config

git/                          # Git configuration
└── .config/git/
    ├── config                # Main git configuration
    └── ignore                # Global gitignore

i3/                           # i3 window manager
└── .config/i3/
    ├── config                # Main i3 configuration
    ├── keybindings/          # Modular keybinding files
    └── layouts/              # Window layout definitions
```

#### Application Configurations
```
ghostty/                      # Terminal emulator
alacritty/                    # Alternative terminal (inactive)
kitty/                        # Alternative terminal (inactive)
polybar/                      # Status bar
rofi/                         # Application launcher
picom/                        # Compositor
dunst/                        # Notification daemon
```

#### Development Tools
```
lazygit/                      # Git TUI configuration
helix/                        # Alternative editor (inactive)
bat/                          # Cat replacement with syntax highlighting
fzf/                          # Fuzzy finder
ripgrep/                      # Fast text search
```

### Directory Naming Conventions

#### Active vs Inactive Configurations
- **Active**: Configurations for currently used tools (e.g., `ghostty/`, `nvim/`)
- **Inactive**: Configurations kept for reference but not stowed (e.g., `alacritty/`, `helix/`)

#### Path Structure
Each stow package mirrors the target filesystem structure:
- `.config/` - XDG config directory files
- `.` prefixed files - Home directory dotfiles
- No prefix - System-level configurations

### File Organization Patterns

#### Configuration Files
- **Main config**: Primary configuration file (e.g., `init.lua`, `config`)
- **Modular configs**: Split into logical sections (e.g., `keybindings/`, `themes/`)
- **Lock files**: Version pinning (e.g., `lazy-lock.json`)

#### Script Organization
```
.config/tmux/scripts/
├── ai/                       # AI assistant integrations
├── help/                     # Help system with tables
├── runner/                   # Project runner system
├── sesh/                     # Session management
└── [tool-specific]/          # Other utility scripts
```

#### Documentation Structure
- **README.md**: Tool-specific documentation in each directory
- **Inline comments**: Extensive commenting in configuration files
- **Fold markers**: Vim-style folding for large configs (`{{{`, `}}}`)

### Stow Package Categories

#### Core System (Always Stowed)
- `i3`, `sxhkd`, `polybar`, `picom`, `rofi`
- `zsh`, `tmux`, `nvim`, `git`
- `fzf`, `ripgrep`, `bat`, `lazygit`

#### Desktop Applications (Selectively Stowed)
- `ghostty`, `dunst`, `thunar`
- `flameshot`, `ulauncher`, `blueman`

#### Optional/Reference (Not Auto-Stowed)
- Alternative terminals: `alacritty`, `kitty`, `wezterm`
- Alternative editors: `helix`, `spacemacs`
- Platform-specific: `hammerspoon` (macOS)

### Special Directories

#### `.kiro/` - Kiro IDE Configuration
- `steering/` - AI assistant guidance rules
- `settings/` - IDE-specific settings

#### `bin/` - Custom Scripts
- Executable scripts available system-wide after stowing
- Utility functions and helper scripts

#### `plans/` - Development Planning
- Markdown files for feature planning and implementation
- Project roadmap and task tracking

### Maintenance Guidelines

#### Adding New Configurations
1. Create directory matching the tool name
2. Mirror target filesystem structure inside
3. Add to appropriate stow category in installation scripts
4. Update documentation

#### Removing Configurations
1. Remove from stow commands in installation scripts
2. Move to "inactive" category if keeping for reference
3. Update SYSTEM_SETUP_CONTEXT.md decisions

#### File Naming
- Use lowercase with hyphens for directories (`gh-dash`)
- Follow tool's standard config names (`config.yml`, `settings.toml`)
- Use descriptive names for custom scripts (`layout-manager.sh`)