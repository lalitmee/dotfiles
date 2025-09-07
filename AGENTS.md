# Agent Guidelines for Dotfiles Repository

## Build/Test Commands
- **Install dotfiles**: `./install` (uses GNU Stow to create symlinks)
- **Clean environment**: `./clean-env` (removes stowed symlinks)
- **Run basic test**: `./scripts/test/test-home` (logs HOME variable resolution)
- **Test cron jobs**: `./scripts/backup/test-cron` (validates cron configurations)

## Code Style Guidelines

### Shell Scripts (.sh, .zsh)
- Use 4-space indentation (no tabs)
- Use `#!/usr/bin/env bash` or `#!/usr/bin/env zsh` shebangs
- Quote variables: `"$VARIABLE"`
- Use `[[ ]]` for conditionals instead of `[ ]`
- Check file existence before sourcing: `[[ -f ~/.file ]] && source ~/.file`
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
- **Loading Order**: Base template → Local overrides → Dotfiles customizations

### Key Tables & Modes
- **Prefix**: `C-a` (remapped from default `C-b`)
- **Layout Mode**: `C-b` (custom mode for layout operations)
- **AI Tools Mode**: `C-i` (dedicated AI tool bindings)
- **Second-Brain Mode**: `C-a b` (consolidated brain-related functions)

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
```
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
- **Table Entry**: Use single letters that represent functionality (b=brain, i=AI)
- **Within Tables**: Use lowercase for primary actions, uppercase for variants
- **Exit Strategy**: Always include 'q' key to exit back to root table
- **Conflict Prevention**: Check both prefix and layout modes before adding bindings

### Conflict Resolution Strategy
1. **Identify Conflicts**: Search for duplicate key usage across all tables
2. **Prioritize Usage**: Keep most frequently used functionality
3. **Create Dedicated Tables**: Group related functionality into specialized tables
4. **Preserve Access**: Ensure alternative access methods exist for removed features
5. **Document Changes**: Update AGENTS.md with migration details

### Testing Approach
- **Syntax Validation**: Use `tmux -f <config> -c "echo 'valid'"` to check syntax
- **Functionality Testing**: Manually test each binding in active tmux session
- **Conflict Verification**: Test that removed bindings don't interfere with new ones
- **Regression Testing**: Ensure existing functionality remains intact

### Migration Strategy
1. **Plan New Structure**: Design table hierarchy and key assignments
2. **Create New Bindings**: Add new table bindings before removing old ones
3. **Test New Functionality**: Verify new bindings work correctly
4. **Remove Old Bindings**: Comment out or remove conflicting bindings
5. **Update Documentation**: Reflect changes in AGENTS.md immediately

### Future Expansion Guidelines
- **New Tables**: Use `C-a <letter>` for new specialized tables (avoid conflicts)
- **Table Extensions**: Add new keys to existing tables using available letters
- **Consistent Patterns**: Follow established naming and key assignment patterns
- **Documentation**: Update AGENTS.md immediately after any keybinding changes
- **Testing**: Always test new bindings and verify no regressions

### Working with Multi-Layer Configuration
- **Primary Edits**: Make changes to ~/dotfiles/tmux/.tmux.conf.local (version controlled)
- **Template Updates**: Update ~/.tmux/.tmux.conf.local for template-specific changes
- **Sync Strategy**: Keep dotfiles version as the source of truth for customizations
- **Conflict Resolution**: Dotfiles version loads last, so it can override template settings
- **Backup**: Always backup ~/.tmux/.tmux.conf.local before major changes