# Research: Omarchy and Hyprland autostart and workspace routing
Generated: 2026-11-17

## Executive Summary

The current Omarchy Lua configuration uses the supported `hyprland.start` event to launch desktop apps and static window rules to assign their workspaces. The repeated failure is a Hyprland process crash, with the first crash on this boot inside cursor handling. Eight concurrent app launches may increase startup load, but the available crash trace does not identify them as the cause. Preserve the startup layout while investigating the cursor crash; staggering apps is a separate reliability experiment only if crashes persist after that issue is addressed.

## Best Practices

- [official] Put personal startup commands in `~/.config/hypr/autostart.lua`; use `o.launch_on_start` for simple Omarchy app launches or `hl.on("hyprland.start", ...)` when startup logic is needed.
- [official] Use `hl.exec_cmd(command, { workspace = "N silent" })` for silent initial placement and window rules keyed by class when apps fork or reuse an existing process.
- [official] Bind numbered workspaces to monitors with workspace rules; keep app routing separate from launch timing.
- [version specific] Omarchy 4.5 uses Lua config. Older `autostart.conf` examples do not apply to this installation.

## Trends & Patterns

- [community consensus] Browser and Electron app process reuse can make launch-time workspace targeting unreliable; class based window rules are a common fallback.
- [debated] Delaying each app can reduce startup contention, but fixed sleeps add latency and do not repair compositor faults.

## Real-World Examples

- Omarchy's current default autostart uses `hyprland.start` and `o.launch` for session programs.
- The local configuration launches eight apps and uses `o.window` rules for seven of them. Ghostty relies on launch-time placement alone.

## Official Documentation

- Hyprland FAQ describes silent startup with `hl.exec_cmd` workspace options.
- Hyprland window rules documentation describes class matching and workspace effects.
- Omarchy manual places user login applications in `autostart.lua`.

## Community Discussion

- Reports on Hyprland startup note that Electron and browser process reuse can bypass launch-time placement.
- Other reports describe slow startup when many GUI apps start together; these are observations, not proof of this machine's crash cause.

## Local Evidence

- `omarchy/.config/hypr/autostart.lua` launches eight apps immediately during `hyprland.start`, with a guard against duplicate launches in the same Lua load.
- `journalctl --user -b` shows app scopes starting at 23:40:27–23:40:37 IST and Hyprland dumping core at 23:40:49 IST on 2026-11-17.
- `~/.cache/hyprland/hyprlandCrashReport1114.txt` identifies Hyprland 0.56.2 and a fault in `cairo_image_surface_get_stride` reached through `CCursorManager::setCursorFromName` and `CCursorShapeProtocol::onSetShape`.
- `coredumpctl list Hyprland` shows repeated crashes on November 10, 15, and 17. A later crash on November 17 is in Aquamarine cleanup during a failed restart.
- The packaged Omarchy `default/hypr/startup-cursor.lua` temporarily changes cursor state during startup. Three saved first-crash reports share the same `CCursorManager::setCursorFromName` stack. The interaction is strongly suspected, but not yet proven by a clean login after the workaround.
- `SUPER + M` in packaged Omarchy minimizes the window to the dock. It is not the Hyprland restart binding.

## Recommendations

1. Skip the packaged temporary startup cursor via the user `hyprland.lua` module cache. This leaves the normal cursor in place and is easy to reverse. Check whether the next login completes without a Hyprland crash.
2. Check whether Omarchy/Hyprland updates address the cursor fault, and report the reproducible trace upstream if it persists. Avoid editing packaged Omarchy files.
3. Keep the supported Lua autostart and static workspace routing. Verify actual window classes after a stable login, especially Ghostty and reused browser processes.
4. If startup still fails without a cursor stack, test a small stagger of heavy apps while retaining window rules and a duplicate-launch guard.

## Sources

- https://wiki.hypr.land/faq/
- https://wiki.hypr.land/Configuring/Advanced-Config/Autostart/
- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
- https://github.com/omacom/omarchy/blob/quattro/manual/31-dotfiles.md
- https://github.com/omacom/omarchy/blob/quattro/default/hypr/autostart.lua
- https://www.reddit.com/r/hyprland/comments/1u5v3uw/how_do_i_make_apps_start_silently/
- https://www.reddit.com/r/hyprland/comments/1bowo7i/hyprland_takes_a_very_long_time_to_startup_when/
