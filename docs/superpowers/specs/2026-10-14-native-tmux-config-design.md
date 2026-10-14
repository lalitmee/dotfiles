# Native tmux config migration design

**Date:** 2026-10-14
**Status:** Approved

## Background and goal

The active `~/.tmux.conf` is Oh My Tmux (OMT), which loads the repository's
`~/.tmux.conf.local` and then applies OMT defaults, binding rewrites, theme
format expansion, and plugin management. The local file contains the bulk of
the user's tmux settings, custom key tables, scripts, and plugin declarations,
but it is not a complete description of current behavior. The active tmux
server has 595 bindings across 18 tables, including OMT, native tmux, local,
and plugin bindings.

The goal is to make the dotfiles repository own the tmux configuration while
preserving the user's effective keybindings, options, plugins, scripts, and
familiar status content. The Cobalt2 theme must use the palette from
`/home/lalitmee/Projects/Personal/Github/cobalt2`, with inactive window text
white (`#FFFFFF`) and last-active window text yellow (`#FFC600`).

## Proposed configuration boundary

- Add a native tmux entry point at `tmux/.tmux.conf`, deployed as
  `~/.tmux.conf`. It owns baseline options, source order, plugin initialization,
  and loading the theme.
- Retain `tmux/.tmux.conf.local` as the personal settings file, but make it
  valid native tmux configuration: migrate OMT-only `tmux_conf_*` shell
  variables to explicit tmux options or bindings and remove reliance on OMT's
  shell parsing and helper functions. Keep the user's key tables, scripts,
  plugin options, and custom commands there unless a dependency requires a
  small change.
- Preserve the current declared plugin set and plugin configuration. Initialize
  TPM explicitly from the native entry point after plugin declarations; do not
  silently remove plugins or change their settings. OMT's automatic
  update-on-reload behavior will not be recreated implicitly; updates remain an
  explicit TPM operation unless the user requests otherwise.
- Load `tmux/.config/tmux/themes/cobalt2.conf` after configuration and plugin
  declarations so the theme is the final source of appearance settings.
- Do not copy the entire OMT file. Reproduce the baseline behaviors the user
  relies on, and omit unrelated OMT helpers and defaults only when they are not
  part of the effective behavior being preserved.

## Behavior to preserve

The complete current effective keymap and option values are the migration
baseline, not just the text of `.tmux.conf.local`. Inventory all 18 active key
tables and compare their bindings with OMT's source and local configuration.
Preserve the existing effective bindings and relevant options, including the
user's custom prefix, OMT defaults, tmux defaults, mode tables, window/pane
navigation, session/window behavior, and plugin bindings. Do not assume an
inherited binding or option is unused. Any difference from the baseline must
be documented and approved before cutover.
For OMT-provided behavior that is active, provide native equivalents,
including current-path behavior for new windows and panes, the configured
session-prompt behavior, terminal color support, and clipboard integration.
Record any unavoidable binding differences and their reason rather than
silently changing them.

Keep the current status information where practical, including session dots,
prefix/mouse/pairing/synchronization indicators, uptime, and username/root
information. Replace OMT-only format aliases and shell-helper expansion with
native tmux formats or the smallest repo-owned helper needed; do not leave the
new config dependent on `/home/lalitmee/.tmux.conf`.

## Cobalt2 theme requirements

Use the official Cobalt2 palette: background `#193549`, white `#FFFFFF`,
yellow `#FFC600`, blue `#00AAFF`, dark blue `#0050A4`, green `#3AD900`, pink
`#FF00FF`, orange `#FF9A00`, black `#1C1C1C`, gray `#808080`, magenta
`#EE80E1`, red `#FF0000`, and `#9E9E9E` (`thm_black4`).
Set inactive window status text to white on the Cobalt background and explicitly
set last-active window status text to yellow on that background. Keep the
current-window styling consistent with the official theme while preserving the
user's current status-line content and placement unless a tmux-native format
requires a documented adjustment.

## Migration and rollback

Tmux currently uses the regular upstream OMT file at `~/.tmux.conf`; the XDG
`~/.config/tmux/tmux.conf` path is absent and would not supersede that legacy
file. Deployment must therefore explicitly replace or redirect the legacy
entry point to the repo-owned config. Before that switch, preserve the current
OMT file as a rollback copy. Do not edit or replace the active home config
until the implementation plan is reviewed and the new config passes isolated
testing.

Test the new entry point on a separate tmux socket. Compare effective bindings
across all tables and relevant global, session, and window options against the
captured baseline; verify plugin bindings and status formats after plugin
initialization; check the Cobalt2 inactive and last-active colors. Only then
switch the normal entry point. Keep the rollback copy until the new setup has
been used successfully.

## Non-goals

- Redesigning keybindings, changing the user's workflow, or cleaning up
  unrelated tmux scripts.
- Removing declared plugins or changing their options as opportunistic cleanup.
- Editing or reloading the live OMT configuration during design or isolated
  verification.
- Replacing tmux or its plugin manager with another tool.

## Acceptance criteria

1. Normal tmux startup reads the repo-owned native entry point and no longer
   sources or executes OMT.
2. The user's complete current effective key tables and relevant options,
   including OMT and tmux defaults, are preserved; any differences are
   documented and approved before cutover.
3. The current plugin declarations/options and custom scripts continue to
   work through TPM.
4. Status content no longer depends on OMT-only format rewriting.
5. The official Cobalt2 palette is used; inactive window foreground is
   `#FFFFFF`, and last-active window foreground is `#FFC600`.
6. An isolated tmux startup validates the config before the active entry point
   is switched, and a rollback path remains available.
