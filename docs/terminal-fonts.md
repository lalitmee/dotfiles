# Terminal fonts

Foot and Ghostty are Stow packages. Their shared configs are:

- `foot/.config/foot/foot.ini` (Wayland/Linux only, 9pt)
- `ghostty/.config/ghostty/config` (Linux and macOS, 10pt fallback)

Both request `MonoLisa Nerd Font`. Install the licensed, fully patched font
separately; font binaries are not part of these dotfiles.

## Ghostty machine-specific settings

The shared config loads `config-file = ?config.local` last. Included files
override the shared values, and a missing optional file is ignored.

Create `config.local` alongside the active Ghostty config on each machine.
On Linux, use `~/.config/ghostty/config.local`:

```ini
font-size = 9
```

On the work Mac, use the same location if Ghostty loads the Stow config there.
If Ghostty uses a different config directory, put the override beside that
active config instead. For example, choose a larger size:

```ini
font-size = 14
```

Adjust 14 to taste. `config.local` is Git-ignored; do not force-add it.
When the config directory is symlinked by Stow, this file can physically live
inside the repo while remaining untracked. Avoid stowing it onto another machine.

Ghostty's local spacing is configured in its ignored `config.local`:

Ghostty:

```ini
font-size = 9
adjust-cell-width = -1
```

Foot loads `~/.config/foot/config.local` through its tracked `include` directive:

```ini
[main]
letter-spacing=-1px
```

This file is also Git-ignored. Unlike Ghostty's optional include, Foot requires
the file to exist: create it (an empty file is sufficient for default spacing)
on each Linux machine before using the tracked config.

Ghostty can reload with the configured Super+R binding. Foot reads its config
in new windows. Ghostty's shared config keeps neutral spacing; the local file
overrides it on this Linux machine without changing the Mac's spacing.

## Omarchy font changes and symlinks

The installed `omarchy font set` command edits Foot and Ghostty with `sed -i`,
which can replace a config symlink with a regular file. After a font switch,
check the links before assuming the changes are tracked:

```sh
ls -l ~/.config/foot/foot.ini ~/.config/ghostty/config
```

If either is no longer a symlink, compare the live file with its tracked config,
back up the live file outside `~/.config`, and merge any intended shared changes
into the repo. Move the regular file out of the way, then relink from the repo:

```sh
stow --no-folding --target="$HOME" foot ghostty
```

Do not blindly overwrite the live file or use `stow --adopt`: preserve local
changes and keep each machine's Ghostty size in `config.local`.
