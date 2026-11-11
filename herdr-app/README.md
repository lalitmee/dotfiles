# Herdr app

Public-safe Herdr desktop preferences, managed with GNU Stow.

## Included files

- `settings.json`: appearance, font, sound and zoom preferences.
- `keys.json`: built-in UI and terminal keybindings.
- `layouts/main.json`: main interface layout and selected theme.
- `themes/cobalt2.json`: terminal palette and interface colors based on the
  repository's Omarchy Cobalt2 palette (lalitmee/cobalt2.nvim, MIT).

## Apply

From the dotfiles repository root:

```bash
stow --no-folding --target="$HOME" herdr-app
herdr-app do app.theme --name cobalt2
```

Back up conflicting existing files outside the repository before linking.
Do not use `stow --adopt`: it could import private local content.
Herdr live-reloads settings, keybindings and layouts.

## Privacy boundary

The package `.gitignore` denies new files by default, allowing only the four
reviewed configuration files above and this package's documentation/ignore files.
Runtime directories remain real directories, not symlinks into this repository.
Do not copy the entire Herdr config directory or force-add ignored files.

Never track telemetry, logs, sockets, IDs, installation metadata, window/session
state, shared/view state, workspace contents, credentials or app-managed mods.
Layouts and keybindings can contain paths or shell commands: review future edits
before staging. Settings can gain new fields; the file allowlist does not prevent
sensitive values being added inside an allowed file. Review diffs before publishing.

The main layout is tracked; other shipped layouts remain app-managed and can
retain their own appearance.
