# Claude Context File - Dotfiles Repository

## Project Overview

This is a comprehensive personal dotfiles repository managed by a developer who uses:

- **Primary Shell**: Zsh with Oh My Zsh and Powerlevel10k
- **Primary Editor**: Neovim (highly customized with lazy.nvim)
- **Terminal Multiplexer**: Tmux with extensive customization
- **Package Management**: GNU Stow for symlink management
- **Version Control**: Git with extensive aliases and delta for diffs

## Repository Structure & Management

### Installation & Testing

- **Install**: `./install` (uses GNU Stow)
- **Clean**: `./clean-env` (removes symlinks)
- **Test**: `./scripts/test/test-home` and `./scripts/backup/test-cron`

### Key Directories

- `nvim/` - Neovim configuration with lazy.nvim
- `tmux/` - Tmux configuration with custom themes and scripts
- `zsh/` - Zsh configuration and customizations
- `scripts/` - Utility scripts for installation, backup, and testing
- `bin/` - Custom executable scripts
- Various tool configs: `alacritty/`, `kitty/`, `git/`, `lazygit/`, etc.

## Code Style & Conventions

### Shell Scripts (.sh, .zsh)

- 4-space indentation (no tabs)
- Shebangs: `#!/usr/bin/env bash` or `#!/usr/bin/env zsh`
- Quote variables: `"$VARIABLE"`
- Use `[[ ]]` for conditionals
- Check file existence: `[[ -f ~/.file ]] && source ~/.file`
- Functions in `snake_case`
- Environment vars in `UPPER_CASE`, locals in `lower_case`

### Lua Files (.lua)

- 4-space indentation
- Double quotes for strings
- EmmyLua conventions

### Git Commit Conventions

- **CRITICAL**: NEVER auto-commit - always ask user first
- Subject: 50 chars max, imperative mood
- Body: 72 chars per line
- Format: `type(scope): description`
- Use conventional prefixes: feat:, fix:, docs:, refactor:
- Exception: Context files can be auto-committed

## Tmux Configuration (Critical System)

### Architecture

- **Base**: gpakosz/.tmux template in ~/.tmux/
- **Local Overrides**: ~/.tmux/.tmux.conf.local
- **Dotfiles Version**: ~/dotfiles/tmux/.tmux.conf.local (source of truth)
- **Themes**: ~/dotfiles/tmux/tmux-themes/
- **Scripts**: ~/.config/tmux/scripts/

### Key System (v2.1 - Production Ready)

- **Prefix**: `C-a` (not default `C-b`)
- **Layout Mode**: `C-b` (custom layout operations)
- **AI Tools**: `C-a C-i` (AI assistant bindings)
- **Second-Brain**: `C-a b` (notes, todos, scratch)

### Current Status

- ✅ 100+ keybindings across multiple tables
- ✅ All syntax validated and tested
- ✅ Standardized to use `bind` (not `bind-key`)
- ✅ Professional organization with vim folding
- ✅ Comprehensive help system with gum tables

### Help System

- Modular help with `~/.config/tmux/scripts/help/help.sh`
- Beautiful gum table displays
- Help bindings: `C-a C-i ?`, `C-a b ?`, `C-b ?`, etc.
- Tab-separated table files in `tables/` directory

## Development Workflow

### When Working with Tmux

1. Edit `~/dotfiles/tmux/.tmux.conf.local` (version controlled)
2. Test syntax: `tmux source ~/.tmux.conf.local`
3. Test functionality manually
4. Update help tables if keybindings change
5. Update AGENTS.md documentation

### File Editing Preferences

- Use `edit_file` for files < 2500 lines
- Use `search_replace` for larger files
- Always read files before editing if unsure of current state
- Prefer editing existing files over creating new ones

### Error Handling

- Check for required variables before use
- Validate file/directory existence
- Use conditional sourcing to avoid errors
- Provide clear error messages

## AI Assistant Integration

### Current AI Tools

- Gemini integration
- OpenCode integration
- Claude integration (me!)
- Update mechanism for tools

### Keybindings

- `C-a C-i g` → Gemini
- `C-a C-i o` → OpenCode
- `C-a C-i c` → Claude
- `C-a C-i u` → Update tools

## Important Notes for Claude

### What I Should Remember

1. **Never auto-commit** - always ask first (except context files)
2. **Test tmux changes** thoroughly before considering complete
3. **Update help tables** when changing keybindings
4. **Follow naming conventions** strictly
5. **Use parallel tool calls** when gathering information
6. **Be thorough** - read multiple files to understand context fully

### What I Should Avoid

1. Creating unnecessary new files
2. Breaking existing tmux functionality
3. Ignoring the established code style
4. Making changes without understanding the full context
5. Auto-committing any changes without explicit permission

### My Role

I'm integrated as one of the AI assistants in this developer's workflow. I should:

- Respect the existing architecture and conventions
- Provide helpful modifications and improvements
- Maintain the high quality and organization standards
- Ask for clarification when needed
- Always test changes thoroughly

## Current Git Status

- On master branch, up to date with origin
- Staged changes include AGENTS.md, GEMINI.md, and new tmux help system files
- Unstaged changes to tmux help script and config

This context helps me understand the sophisticated development environment I'm working within and ensures I maintain the high standards and conventions already established.

## Self-Updating Context Instructions

**IMPORTANT**: Whenever I discover something valuable during our collaboration that would be useful for future sessions, I should proactively update this context file. This includes:

- New workflows or patterns discovered
- Important fixes or solutions implemented
- Configuration improvements made
- Best practices learned
- Common issues and their solutions
- New integrations or tools added

## Recent Collaboration Discoveries & Improvements

### Tmux Help System Implementation (Latest)

- **Location**: `~/.config/tmux/scripts/help/help.sh`
- **Issue Found**: `gum table` parsing errors with special characters (quotes, percent signs)
- **Solution**: Remove problematic characters from help table descriptions
- **Key Learning**: Tab-separated help tables must avoid quotes and special symbols
- **Files**: Help tables in `~/.config/tmux/scripts/help/tables/*.txt`

### Global Tmux Popup Styling (Latest)

- **Implementation**: Added global cobalt2 styling for all tmux popups
- **Settings Added**:
  ```bash
  set-option -g popup-style "fg=#e4e4e4,bg=#193549"
  set-option -g popup-border-style "fg=#00AAFF,bg=#193549"
  set-option -g popup-border-lines rounded
  ```
- **Benefits**: Consistent cobalt2 theming across 20+ popups without individual updates
- **Location**: Added to transparency section in `tmux/.tmux.conf.local`

### Tmux Help System Color Coordination

- **Discovery**: Help script colors should match tmux popup global styling
- **Implementation**: Updated `help.sh` to use authentic cobalt2 colors from both:
  - Tmux config colors (`tmux_conf_theme_colour_*`)
  - Cobalt2 theme file colors (`tmux/tmux-themes/cobalt2.conf`)
- **Key Colors**:
  - Header: `#FFC600` on `#0d3a58`
  - Body: `#e4e4e4` on `#193549`
  - Border: `#00AAFF`

### Gum Table Best Practices

- **Critical**: Always use `--separator=$'\t'` for tab-separated files
- **Avoid**: `--print` with `gum pager` (causes usage display instead of content)
- **User Experience**: Add `read -n 1 -s` to keep popups open until user dismisses
- **Styling**: Use `gum style` for consistent theming of prompts

### Tmux Configuration Debugging Workflow

1. **Test syntax**: `tmux source-file ~/.tmux.conf.local`
2. **Verify settings**: `tmux show-options -g <option-name>`
3. **Test individual scripts**: Run help scripts directly before tmux integration
4. **Check for conflicts**: Search for duplicate keybindings across tables

### File Editing Patterns Discovered

- **Special Characters**: Be cautious with quotes, percent signs in tab-separated data
- **Color Consistency**: Always reference existing theme colors rather than inventing new ones
- **Documentation**: Add inline comments explaining color choices and their sources
- **Testing**: Always test scripts standalone before integrating into tmux

### Future Maintenance Notes

- **Help Tables**: When adding new keybindings, update corresponding `.txt` files in `tables/`
- **Color Updates**: If cobalt2 theme changes, update both tmux config and help script colors
- **Popup Styling**: Global popup settings automatically apply to new popups
- **Script Testing**: Always test with actual data before deploying to tmux keybindings
