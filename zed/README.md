# Zed Editor Configuration

Complete Zed editor configuration tracked in dotfiles with security-first design.

## Installation

### Quick Start
```bash
cd ~/dotfiles
stow zed
```

This creates symlinks:
- `~/.config/zed/settings.json` → `~/dotfiles/zed/.config/zed/settings.json`
- `~/.config/zed/keymap.json` → `~/dotfiles/zed/.config/zed/keymap.json`

### Verify Installation
```bash
ls -la ~/.config/zed/
# Should show: settings.json -> ../../../dotfiles/zed/.config/zed/settings.json
```

## Configuration Files

### Tracked ✅

**`settings.json`** - Main editor configuration
- Font sizes and families
- UI theme preferences
- Editor behavior settings
- Agent server integrations (non-sensitive)
- Language server configuration
- Feature flags

**`keymap.json`** - Custom key bindings
- Workspace-level key bindings
- Vim mode key customizations
- Currently minimal (defaults used)

**`themes/`** - Custom theme definitions
- Currently empty but directory is tracked
- Add custom `.json` theme files here if needed

### NOT Tracked ❌

These files contain sensitive data and are explicitly NOT tracked:

From `~/.local/share/zed/`:
- `copilot/` - Copilot authentication tokens
- `db/` - SQLite database with session information
- `conversations/` - AI chat conversation history
- `external_agents/` - External agent authentication
- `node/` - Node.js runtime data
- `prettier/` - Formatter cache

From `~/.config/zed/`:
- Any manually-added settings with API keys
- Personal configuration overrides

## Security

### API Keys & Secrets

**This configuration contains NO secrets by design.**

If you need to configure services with API keys (GitHub tokens, OpenAI keys, etc.):

#### Option 1: Manual Local Override (Current)
```bash
# Edit locally only - never commit to git
vi ~/.config/zed/settings.json

# Add your configuration
{
  "context_servers": {
    "my-server": {
      "settings": {
        "api_key": "sk-YOUR-KEY-HERE"
      }
    }
  }
}
```

**Note:** Changes will be overwritten when you re-stow. Keep a backup of sensitive settings.

#### Option 2: Environment Variables (Coming Soon)
Zed is working on `${env:VAR}` support in settings files.

**GitHub Issue:** [zed-industries/zed#26043](https://github.com/zed-industries/zed/discussions/26043)

When available, you'll be able to use:
```json
{
  "context_servers": {
    "my-server": {
      "settings": {
        "api_key": "${env:MY_API_KEY}"
      }
    },
    "github": {
      "settings": {
        "token": "${env:GITHUB_TOKEN}"
      }
    }
  }
}
```

Then just set environment variables before launching Zed:
```bash
export MY_API_KEY="sk-..."
export GITHUB_TOKEN="ghp_..."
zed .
```

### Pre-Commit Protection

Your dotfiles use `gitleaks` to prevent accidental secret commits:
```bash
pre-commit run --all-files
```

This scans for API keys, tokens, and other sensitive patterns.

## Workflow

### Editing Configuration

Since files are symlinked, changes in either location are reflected everywhere:

```bash
# Edit via Zed or any editor
zed ~/.config/zed/settings.json
# OR
vim ~/.config/zed/settings.json
# OR via Zed UI: cmd-, / ctrl-,
```

Changes are immediately available in both:
- `~/.config/zed/settings.json` (symlink)
- `~/dotfiles/zed/.config/zed/settings.json` (actual file)

### Committing Changes

```bash
# Verify changes
cd ~/dotfiles
git status

# Commit
git add zed/
git commit -m "config(zed): update editor settings"
git push
```

### Syncing Across Machines

On a new machine:
```bash
# Clone your dotfiles
git clone <your-repo> ~/.dotfiles
cd ~/.dotfiles

# Install Zed config
stow zed

# Manually add any secrets to ~/.config/zed/settings.json
# (Do NOT commit these)
vim ~/.config/zed/settings.json
```

## Current Configuration

### Editor Behavior
- **Theme:** Catppuccin Mocha
- **Base Keymap:** VSCode
- **Vim Mode:** Enabled
- **Font Family:** Operator Mono Lig
- **Font Size:** 14pt (buffer), 14pt (UI)
- **Font Weight:** 300 (light)

### Integrations
- **OpenCode Agent:** Enabled
  - Type: custom
  - Command: `opencode`
  - Environment: inherited from shell

### Features
- **Edit Prediction:** Copilot
- **Icon Theme:** System default (light/dark)
- **Terminal Font Weight:** 300 (light)

### Language Support
- All default Zed language servers enabled
- Custom language configurations can be added to `"languages"` key

## Power User Enhancements

### Adding Custom Tasks
Create `~/.config/zed/tasks.json` (or `~/dotfiles/zed/.config/zed/tasks.json`):
```json
[
  {
    "label": "build",
    "command": "cargo",
    "args": ["build"],
    "cwd": "${workspaceRoot}"
  }
]
```

### Custom Language Configuration
Extend `"languages"` in `settings.json`:
```json
{
  "languages": {
    "Rust": {
      "format_on_save": "on",
      "formatter": "language_server",
      "tab_size": 4
    }
  }
}
```

### LSP Configuration
Add language server settings under `"lsp"`:
```json
{
  "lsp": {
    "rust-analyzer": {
      "initialization_options": {
        "checkOnSave": {
          "command": "clippy"
        }
      }
    }
  }
}
```

### Context & MCP Servers
When adding servers with sensitive credentials, use environment variables (pending Zed support):
```json
{
  "context_servers": {
    "my-server": {
      "settings": {
        "token": "${env:MY_TOKEN}"
      }
    }
  }
}
```

## Troubleshooting

### Stow Conflicts
If stow fails due to existing files:
```bash
# Remove old symlinks
stow -D zed

# Try again
stow zed

# If conflicts persist, backup and remove
mv ~/.config/zed ~/.config/zed.backup
stow zed
```

### Settings Not Applying
```bash
# Zed needs to be restarted to pick up settings changes
# Restart Zed completely or use: cmd+shift+p > restart

# Verify symlink
ls -la ~/.config/zed/settings.json
```

### Local Overrides Being Lost
If you add secrets manually to `~/.config/zed/settings.json`:
- Keep a backup file: `~/.config/zed/settings.json.backup`
- Re-apply after stowing updates: `cat ~/.config/zed/settings.json.backup >> ~/.config/zed/settings.json`

## References

- **Zed Documentation:** https://zed.dev/docs/configuring-zed
- **Key Bindings:** https://zed.dev/docs/key-bindings
- **Environment Variables:** https://zed.dev/docs/environment
- **Env Var Support Issue:** https://github.com/zed-industries/zed/discussions/26043
- **Security Blog:** https://zed.dev/blog/secure-by-default
- **Dotfiles Stow Guide:** GNU Stow manual

## Notes

- Configuration is version-controlled for portability across machines
- Secrets are intentionally NOT tracked (manual management required for now)
- Environment variable support in settings is planned by Zed team
- Pre-commit hooks (gitleaks) prevent accidental secret commits
- Custom themes can be added to `themes/` directory

## Related

- Parent README: `../README.md`
- Dotfiles config style guide: `../AGENTS.md`
