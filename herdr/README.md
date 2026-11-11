# Herdr terminal app

Reviewed terminal-app configuration, managed separately from `herdr-app/`.
Includes Cobalt2 UI overrides, keybindings and pane preferences.

## Apply

From the repository root, after backing up conflicting files outside Git:

```bash
stow --no-folding --target="$HOME" herdr
herdr server reload-config
```

Do not use `stow --adopt`, which could import private local configuration.
Only `~/.config/herdr/config.toml` is symlinked; the containing directory stays
local so logs, sockets and runtime files cannot enter the repository through it.

## Privacy

The package ignores all new files by default except `config.toml` and package
documentation/ignore files. Do not force-add logs, sockets, saved machines,
credentials, session state or workspace data.

The reviewed config contains no credentials or literal hostnames/workspace paths.
`{hostname}` and `{workspace}` are runtime placeholders, not saved identities.
Future configuration edits may introduce secrets, commands or private paths:
review diffs before staging. The file allowlist does not sanitize file contents.

The theme overrides Herdr's TUI colors, not arbitrary programs running in panes.
