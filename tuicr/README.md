# tuicr

Cobalt2 UI and syntax highlighting for tuicr, selected by default.
Colors and core syntax mappings come from
[lalitmee/cobalt2.nvim](https://github.com/lalitmee/cobalt2.nvim)
(`lua/cobalt2/palette.lua` and `syntax.lua`, MIT, copyright Lalit Kumar).
The package is self-contained; Neovim does not need to be installed.

## Apply

From the repository root:

```sh
stow --no-folding --target="$HOME" tuicr
```

Restart tuicr to load the config, or select it explicitly with `tuicr --theme cobalt2`.
Validated with tuicr 0.28.0. Local UI and syntax themes live in
`~/.config/tuicr/themes/`; no other Stow package is required.

## Omarchy

Stow `omarchy` and `zsh` alongside `tuicr` for automatic theme selection.
The Omarchy template generates `tuicr.toml`, and the `theme-set.d/tuicr` hook
links it and the shared `Omarchy.tmTheme` into tuicr's local themes directory.
The Zsh function selects `omarchy` when that generated theme is readable;
otherwise the config's Cobalt2 default applies. Both XDG config/state paths
are respected by the hook. Explicit `--theme` arguments override selection.

Reopen tuicr after theme changes. Outside Zsh (including `command tuicr`),
the portable Cobalt2 config applies; use `--theme omarchy` to opt in.
Generated files stay in local state, never in the tracked Cobalt2 config.

Check selection and hook behavior with:

```sh
python3 scripts/test/config/tuicr-theme.py
```
