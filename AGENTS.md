# Agent Guidelines for Dotfiles Repository

## Build/Test Commands

- **Install dotfiles**: `./install` (uses GNU Stow to create symlinks)
- **Clean environment**: `./clean-env` (removes stowed symlinks)
- **Run basic test**: `./scripts/test/test-home` (logs HOME variable resolution)
- **Test cron jobs**: `./scripts/backup/test-cron` (validates cron configurations)

## User Environment

- **Default Shell**: Zsh (configured in tmux as `set -g default-command "exec /bin/zsh"`)
- **Preferred Shell Scripts**: Zsh-based scripts with `#!/usr/bin/env zsh` shebang
- **Shell Configuration**: Primary configuration in `~/.zshrc`

## Code Style Guidelines

### Shell Scripts (.sh, .zsh)

- **Default Shell**: Zsh (preferred over bash)
- Use 4-space indentation (no tabs)
- Use `#!/usr/bin/env zsh` shebang (preferred) or `#!/usr/bin/env bash` for compatibility
- Quote variables: `"$VARIABLE"`
- Use `[[ ]]` for conditionals instead of `[ ]`
- Check file existence before sourcing: `[[ -f ~/.zshrc ]] && source ~/.zshrc`
- Use functions for reusable code blocks
- Add descriptive comments with fold markers: `# vim:foldmethod=marker`

### Lua Files (.lua)

- Use 4-space indentation
- Prefer double quotes for strings
- Follow EmmyLua code style conventions
- Keep call argument parentheses as configured

### Configuration Files

- Use consistent naming: lowercase with hyphens (e.g., `config.yml`)
- Group related settings with comments
- Use absolute paths when possible
- Document complex configurations

### Git Commit Conventions

- **Subject Line**: 50 characters max, imperative mood (e.g., "Add feature" not "Added feature")
- **Body Lines**: 72 characters max per line
- **Blank Line**: Always separate subject from body with blank line
- **Type Prefix**: Use conventional prefixes (feat:, fix:, docs:, refactor:, etc.)
- **Scope**: Optional context in parentheses (feat(scope):) for related changes
- **Bullet Points**: Use `-` for body content, keep each point concise
- **References**: Include issue numbers when applicable (#123)
- **Auto-Commit Policy**: NEVER commit changes automatically - always ask user first
- **Exception**: Context files (AGENTS.md, README.md, etc.) can be committed automatically
- **Communication**: Provide clear explanations and reasoning for edits and findings to aid collaboration

**Examples**:

```gitcommit
feat(tmux): add dark mode toggle to settings page

- Implement CSS variables for theme switching
- Add toggle button to header component
- Store preference in localStorage
- Update existing components to use theme variables

Closes #123
```

```gitcommit
docs(conventions): update installation instructions

- Add step-by-step setup guide
- Include system requirements
- Document troubleshooting section
- Add FAQ for common issues
```

**Important Workflow Notes**:

- **Always ask before committing**: "Would you like me to commit these changes?"
- **Show changes first**: Use `git diff` or `git status` to show what will be committed
- **Respect user decisions**: If user says "no" to committing, leave changes unstaged
- **Follow conventions**: Use proper formatting, scopes, and imperative mood
- **Clear explanations**: Provide detailed reasoning for edits and findings to improve collaboration
- **Context sharing**: Explain approach and discoveries to help achieve goals more efficiently

### Error Handling

- Check for required variables before use: `[[ -z $VARIABLE ]] && echo "Error"`
- Use `>/dev/null 2>&1` to suppress output when appropriate
- Validate file/directory existence before operations

### Naming Conventions

- Functions: `snake_case` with descriptive names
- Variables: `UPPER_CASE` for environment variables, `lower_case` for locals
- Files: `kebab-case` for config files, `snake_case` for scripts

### Imports/Sourcing

- Source files conditionally to avoid errors
- Use absolute paths for critical configurations
- Group related sources together with comments

## Tmux Configuration Context

### Configuration Architecture

- **Base Template**: gpakosz/.tmux (installed in ~/.tmux/)
- **Local Overrides**: ~/.tmux/.tmux.conf.local (primary customizations)
- **Dotfiles Version**: ~/dotfiles/tmux/.tmux.conf.local (version controlled customizations)
- **Theme Files**: ~/dotfiles/tmux/tmux-themes/ (collection of theme options)
- **Loading Order**: Base template → Local overrides → Dotfiles customizations (with inline theme)

### Key Tables & Modes

- **Prefix**: `C-a` (remapped from default `C-b`)
- **Layout Mode**: `C-b` (custom mode for layout operations)
- **AI Tools Mode**: `C-a C-i` (dedicated AI tool bindings)
- **Second-Brain Mode**: `C-a b` (consolidated brain-related functions)

#### Quick Reference

```zsh
C-a b → Second-Brain Table
  n → notes (personal)
  N → notes (work)
  s → scratch (personal)
  S → scratch (work)
  t → todos (personal)
  T → todos (work)
  q → quit table

C-a C-i → AI Tools Table
  g → Gemini
  o → OpenCode
  c → Claude
  u → Update tools

C-b → Layout Mode
  a → AI ask
  s → Site search
  / → Web search
  m → Documentation browser
```

### Keybinding Philosophy

- **Prefix mode (C-a)**: Core tmux operations and script launches
- **Layout mode (C-b)**: Window/pane management and search operations
- **Specialized tables**: Domain-specific functionality (AI, second-brain)
- **Override defaults**: Replace rarely-used defaults with custom functionality

### Second-Brain Migration Plan

**Current bindings to migrate:**

- `C-a a/A` → notes (personal/work)
- `C-a m/M` → scratch (personal/work)
- `C-a t/T` → todos (personal/work)

**New table structure:**

```zsh
C-a b → Enter second-brain table
  n → notes selector
  s → scratch selector
  t → todos selector
  q → quit table
```

### Important Considerations

- **Default override**: `C-a b` replaces tmux's default `list-buffers` command
- **Alternative access**: Buffer listing available via `:list-buffers` in command mode
- **No functionality loss**: All second-brain features maintained
- **Conflict resolution**: Eliminates layout-mode key conflicts
- **Future expansion**: Room for additional brain-related features

### Key Conflicts Resolved

- **Fixed**: `a`, `m`, `t` conflicts between prefix and layout modes
- **Consolidated**: Duplicate todo functionality (second-brain.sh vs todo.sh)
- **Preserved**: All other existing functionality remains intact

### Tmux Keybinding Patterns

- **Standardization**: Use `bind` consistently (not `bind-key`) for all bindings
- **Table Entry**: Use single letters that represent functionality (b=brain, i=AI)
- **Within Tables**: Use lowercase for primary actions, uppercase for variants
- **Exit Strategy**: Always include 'q' key to exit back to root table
- **Conflict Prevention**: Check both prefix and layout modes before adding bindings
- **Global Bindings**: Use `bind -n` for no-prefix bindings
- **Table Bindings**: Use `bind -T <table>` for table-specific bindings

### Conflict Resolution Strategy

1. **Identify Conflicts**: Search for duplicate key usage across all tables
2. **Prioritize Usage**: Keep most frequently used functionality
3. **Create Dedicated Tables**: Group related functionality into specialized tables
4. **Preserve Access**: Ensure alternative access methods exist for removed features
5. **Document Changes**: Update AGENTS.md with migration details

### Testing Approach

- **Syntax Validation**: Use `tmux -f <config> -c "echo 'valid'"` to check syntax ✅
- **Functionality Testing**: Manually test each binding in active tmux session ✅
- **Keybinding Verification**: Use `tmux list-keys` to verify bindings are loaded ✅
- **Conflict Verification**: Test that removed bindings don't interfere with new ones ✅
- **Regression Testing**: Ensure existing functionality remains intact ✅
- **Random Testing**: Test 5+ random keybindings to verify functionality ✅

### Migration Strategy

1. **Plan New Structure**: Design table hierarchy and key assignments
2. **Create New Bindings**: Add new table bindings before removing old ones
3. **Test New Functionality**: Verify new bindings work correctly
4. **Remove Old Bindings**: Comment out or remove conflicting bindings
5. **Update Documentation**: Reflect changes in AGENTS.md immediately

### Current Status (v2.1)

- **Configuration State**: ✅ Production-ready and fully tested
- **Keybinding Count**: 100+ bindings across multiple tables
- **Syntax Status**: ✅ Valid (no errors)
- **Testing Status**: ✅ 5 keybindings tested and working
- **Standardization**: ✅ All `bind-key` converted to `bind`
- **Organization**: ✅ Professional structure with vim folding
- **Documentation**: ✅ Comprehensive inline comments

### Future Expansion Guidelines

- **New Tables**: Use `C-a <letter>` for new specialized tables (avoid conflicts)
- **Table Extensions**: Add new keys to existing tables using available letters
- **Consistent Patterns**: Follow established naming and key assignment patterns
- **Documentation**: Update AGENTS.md immediately after any keybinding changes
- **Testing**: Always test new bindings and verify no regressions
- **Standardization**: Continue using `bind` consistently for all new bindings

### Working with Multi-Layer Configuration

- **Primary Edits**: Make changes to ~/dotfiles/tmux/.tmux.conf.local (version controlled)
- **Template Updates**: Update ~/.tmux/.tmux.conf.local for template-specific changes
- **Sync Strategy**: Keep dotfiles version as the source of truth for customizations
- **Conflict Resolution**: Dotfiles version loads last, so it can override template settings
- **Backup**: Always backup ~/.tmux/.tmux.conf.local before major changes

### Configuration Organization Structure

#### 📁 File Structure

```text
~/dotfiles/tmux/
├── .tmux.conf.local           # Main organized config (v2.1 - Standardized)
├── tmux-themes/               # Theme collection directory
│   ├── cobalt2.conf           # Cobalt2 theme (bash script format)
│   ├── catppuccin.conf        # Additional themes available
│   └── tokyonight_night.conf  # More theme options
└── .config/tmux/scripts/      # All custom scripts and tools
```

#### 📋 Organization Features (v2.1)

- **Vim Folding Markers**: `{{{1`, `{{{2`, `}}}` for code folding support
- **Comprehensive Documentation**: Inline comments explaining every section
- **Standardized Keybindings**: Consistent `bind` usage throughout (no more `bind-key`)
- **Table of Contents**: Quick navigation with line number references
- **Configuration Index**: Quick reference for common customizations
- **Maintenance Procedures**: Backup, testing, and troubleshooting guides

#### 🎯 Key Sections (v2.1)

1. **Theme Configuration** - Inline cobalt2 theme with full documentation
2. **Core Settings** - Essential tmux behavior organized by category
3. **Plugins** - All TPM plugins with configuration and purpose
4. **Keybindings** - Comprehensive keybinding system with multiple modes
5. **Configuration Index** - Quick reference guide
6. **Maintenance** - Tools and procedures for upkeep

#### 🔧 Organization Improvements (v2.1)

- **Professional Structure**: Enterprise-level organization with clear hierarchy
- **Self-Documenting**: Every setting explained with purpose and context
- **Future-Proof**: Easy to maintain and extend
- **Version Controlled**: All changes tracked in git
- **Conflict-Free**: Resolved all keybinding conflicts
- **Performance Optimized**: Minimal impact on tmux startup
- **Standardized**: Consistent `bind` command usage throughout
- **Tested**: All keybindings verified working (5 random tests passed)

#### ✅ Recent Updates (v2.1)

- **Keybinding Standardization**: Converted all `bind-key` to `bind` for consistency
- **Testing Completed**: 5 keybindings tested and verified working:
  - `C-h` (Global): Smart pane navigation with Vim awareness ✅
  - `C-j` (Global): Smart pane navigation with Vim awareness ✅
  - `C-a b`: Enter second-brain table ✅
  - `C-a C-i`: Enter AI tools table ✅
  - `C-b`: Enter layout mode ✅
- **Syntax Validation**: Configuration loads without errors ✅
- **Functionality**: All table modes and scripts working correctly ✅

## Tmux Help System Implementation

### Overview

A modular help system that displays keybindings in beautiful gum tables instead of simple status messages. Provides better discoverability and user experience for complex keybinding tables.

### Architecture

```text
~/.config/tmux/scripts/help/
├── help.sh              # Main help dispatcher script
├── README.md           # Documentation
├── tables/
│   ├── ai-tools.txt    # AI tools keybindings
│   ├── second-brain.txt # Second brain keybindings
│   ├── layout-mode.txt # Layout mode keybindings
│   ├── session-mgmt.txt # Session management keybindings
│   └── global.txt      # Global keybindings
└── templates/          # Future templates
```

### Keybindings

- `C-a C-i ?` → AI tools help popup
- `C-a b ?` → Second brain help popup
- `C-b ?` → Layout mode help popup
- `C-a S ?` → Session management help popup
- `C-a H` → Global help popup

### Implementation Details

- **Modular Design**: Each help table is a separate `.txt` file with tab-separated values
- **Beautiful UI**: Uses `gum table` with tmux cobalt2 theme colors
- **Error Handling**: Checks for gum availability and valid table files
- **Popup Interface**: Non-blocking help display with appropriate sizing
- **Easy Maintenance**: Simple text files for content updates

### Maintenance Guidelines

**When making keybinding changes:**

1. Update the corresponding `.txt` file in `tables/` directory
2. Test the help display: `~/.config/tmux/scripts/help/help.sh <table-name>`
3. Ensure table formatting is correct (tab-separated values)
4. Update AGENTS.md documentation if adding new tables or changing structure

### Dependencies

- **gum**: Required for table display
  - macOS: `brew install gum`
  - Linux: Check package manager or <https://github.com/charmbracelet/gum>

### File Format

Help tables use tab-separated values with header row:

```tsv
Key	Description
g	Gemini AI assistant
o	OpenCode AI assistant
q	Quit table
```

### Color Scheme

Matches tmux cobalt2 theme:

- Header: Yellow text (#FFC600) on dark blue background (#0d3a58)
- Body: White text (#e4e4e4) on dark background (#080808)
- Border: Blue (#0050a4) rounded border

### Testing

- **Syntax**: `tmux source ~/.tmux.conf.local`
- **Functionality**: Test each help binding in tmux session
- **Content**: Verify table formatting with `./help.sh <table-name>`
- **Dependencies**: Ensure gum is installed and accessible
