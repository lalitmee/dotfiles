# Herdr app

Public-safe Herdr desktop preferences, managed with GNU Stow.

## Included files

- `settings.json`: appearance, font, sound and zoom preferences.
- `keys.json`: UI, terminal and custom worktree keybindings.
- `mods/worktree-keys/main.js`: keyboard entry points for the worktree dialogs.
- `layouts/lalitmee-main.json`: personal main interface layout and selected theme.
- `themes/cobalt2.json`: terminal palette and interface colors based on the
  repository's Omarchy Cobalt2 palette (lalitmee/cobalt2.nvim, MIT).

## Apply

From the dotfiles repository root:

```bash
stow --no-folding --target="$HOME" herdr-app
herdr-app do layout.switch --name lalitmee-main
herdr-app do app.theme --name cobalt2
```

Back up conflicting existing files outside the repository before linking.
Do not use `stow --adopt`: it could import private local content.
Herdr live-reloads settings, keybindings and layouts.

## Worktree shortcuts

In the personal `lalitmee-main` layout:

- `Ctrl+Alt+N`: New worktree dialog.
- `Ctrl+Alt+O`: Open worktree dialog.

Both use the selected space and focused terminal folder, like the sidebar actions.
No selected space means no action. The custom `worktree-keys` mod occupies a
non-interactive one-pixel block outside the sidebar, so hiding the sidebar does
not disable it. Shipped mods and the status bar remain unchanged.
Other layouts do not mount this mod and do not receive these custom actions.
Validate the mod with `herdr-app check "$HOME/.config/herdr-app/mods/worktree-keys"`.

## Privacy boundary

The package `.gitignore` denies new files by default, allowing only the
reviewed configuration and custom mod files above and this package's documentation/ignore files.
Runtime directories remain real directories, not symlinks into this repository.
Do not copy the entire Herdr config directory or force-add ignored files.

Never track telemetry, logs, sockets, IDs, installation metadata, window/session
state, shared/view state, workspace contents, credentials or app-managed mods.
Layouts and keybindings can contain paths or shell commands: review future edits
before staging. Settings can gain new fields; the file allowlist does not prevent
sensitive values being added inside an allowed file. Review diffs before publishing.

The personal `lalitmee-main` layout is tracked. Shipped layouts, including
`main`, remain app-managed. Never link a customized layout as `main.json`:
Herdr restores shipped files at startup and moves edits to `main-edited.json`,
which leaves custom shortcut mods unloaded when the active layout is `main`.
Switch to `lalitmee-main` after linking; other layouts can retain their own
appearance.
