# Omarchy integration

Stow this package with an explicit home target:

```sh
stow --no-folding --dir="$HOME/dotfiles" --target="$HOME" omarchy bat
```

`themed/fzf-colors.tpl` uses Omarchy's native user-template renderer. Each
theme switch generates `~/.local/state/omarchy/current/theme/fzf-colors`.
The Zsh package reads it at startup and before each prompt, preserving
fzf bindings/layout and falling back to Cobalt2 when it is unavailable.
Open fzf pickers keep their colors until closed and reopened.

Generated theme files belong in Omarchy state, not in this repository.

## bat, delta, and tmux

The other templates generate a shared `Omarchy.tmTheme`, bat config, delta
Git include, and tmux palette overlay. The executable `theme-set.d/cli-tools`
hook links the generated syntax theme into bat's theme directory, rebuilds
its cache, and reloads the default tmux server if it is running. It does not
start tmux or change bindings. Custom tmux socket servers are not reloaded.

Zsh selects the generated bat config at each prompt. Outside Omarchy, the
regular bat config retains Cobalt2. Delta's generated syntax palette is shared
with bat; added/deleted line backgrounds are mixed from the current palette.

The repository Git and tmux packages include their generated overrides.
On an existing machine without those packages stowed, add this at the end
of the active Git config:

```gitconfig
[include]
    path = ~/.local/state/omarchy/current/theme/delta.gitconfig
```

And at the end of the active tmux config:

```tmux
source-file -q ~/.local/state/omarchy/current/theme/tmux.conf
```

Install `git-delta` before enabling the Git include: it selects delta as the
Git pager. Missing include files are ignored on non-Omarchy hosts. Inline
colors in custom tmux status formats can override the palette styles; those
formats need palette-aware adaptation when migrating the full tmux setup.

Do not edit generated files: Omarchy replaces them on theme changes. Existing
bat/delta processes retain their colors; new invocations use the new palette.

## Full personal tmux migration

The `tmux` package uses Ctrl+A as its prefix and starts Zsh in new panes.
Stow with `--no-folding` so downloaded plugins remain outside the repository.
TPM and plugins live in `~/.config/tmux/plugins`; plugin binaries (including
tmux-fingers and tmux-expose) must be installed separately. TPM updates use
prefix + `u`, preserving prefix + `U` for tmuxinator.

`tmux-personal.conf.tpl` preserves the personal status layout with generated
colors, updates tpad popup styles, and refreshes the expose binding. Only
the personal config loads this template; the theme hook checks the
`@dotfiles-tmux` marker before reloading it. Cobalt2 remains the fallback.
Some helper scripts and the native Shift+Tab switcher retain inline colors.

Scripts sourcing `scripts/lib/popup-style.sh` read the generated fzf palette
and bat config directly, without requiring interactive Zsh. Shared header
hints use palette colors too. Sesh and the window switcher pass those colors
last so stale inherited fzf options cannot override them. Reopen a picker
after a theme change; running pickers do not recolor themselves. Some custom
ANSI-colored rows and preview labels still retain their original colors.

Optional shortcuts still require their own tools: workmux, tmuxinator,
tmux-file-picker, tsnv, gh-dash, espanso, and spotify_player. Second-brain
shortcuts require the user's repositories under `~/Projects/Personal/Github`
and `~/Projects/Work/Github`. The APT repository launcher is Ubuntu-only;
do not use it on Arch. Migrating tmux does not enable shell autostart.
