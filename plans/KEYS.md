# Keybinding Analysis & Optimization (`sxhkdrc`)

This document provides a comprehensive analysis of the keybindings defined in `~/.config/sxhkd/sxhkdrc`. Each keybinding is evaluated for its mnemonic value and ergonomic placement, with suggestions for improvement.

## Must Have

-   **Keybinding:** `super + Escape`
    -   **Command:** `~/.config/bin/sxhkd-reload`
    -   **Intention:** Reloads the `sxhkd` configuration file to apply changes.
    -   **Optimized:** yes
    -   **Suggestion:** none

-   **Keybinding:** `super + Return`
    -   **Command:** `ghostty`
    -   **Intention:** Opens a new terminal window. This is a standard and highly conventional binding.
    -   **Optimized:** yes
    -   **Suggestion:** none

## Ulauncher

-   **Keybinding:** `ctrl + space`
    -   **Command:** `gapplication launch io.ulauncher.Ulauncher`
    -   **Intention:** Opens the Ulauncher application launcher.
    -   **Optimized:** yes
    -   **Suggestion:** none

## Editors

-   **Keybinding:** `super + shift + c`
    -   **Command:** `code`
    -   **Intention:** Launches Visual Studio Code.
    -   **Optimized:** yes (C for Code)
    -   **Suggestion:** none

## Rofi / Dmenu

-   **Keybinding:** `super + o`
    -   **Command:** `~/.config/rofi/launchers/type-1/launcher.sh`
    -   **Intention:** Opens the main Rofi application launcher.
    -   **Optimized:** no
    -   **Suggestion:** `super + space`. The spacebar is a common and ergonomic choice for primary launchers (e.g., macOS Spotlight). This would require moving the current `super + space` binding (`i3-msg focus mode_toggle`) to a less premium key, such as `super + ctrl + space`.

-   **Keybinding:** `super + p`
    -   **Command:** `~/.config/rofi/applets/bin/powermenu.sh`
    -   **Intention:** Opens the power menu (shutdown, reboot, etc.).
    -   **Optimized:** yes (P for Power)
    -   **Suggestion:** none

-   **Keybinding:** `super + shift + s`
    -   **Command:** `flameshot gui`
    -   **Intention:** Takes a screenshot using Flameshot.
    -   **Optimized:** yes (S for Screenshot)
    -   **Suggestion:** none

-   **Keybinding:** `super + shift + w`
    -   **Command:** `~/.config/i3/layout-manager.sh`
    -   **Intention:** Opens the i3 layout manager.
    -   **Optimized:** no (W for Window Manager?)
    -   **Suggestion:** `super + alt + l` (L for Layout). This avoids conflict with the primary navigation key `super + l`.

## Battery

-   **Keybinding:** `super + c`
    -   **Command:** `~/.config/bin/battery-capacity`
    -   **Intention:** Shows a notification with the current battery capacity.
    -   **Optimized:** no (C for Capacity is not immediately intuitive).
    -   **Suggestion:** `super + alt + b`. This groups it with other "B" bindings (`super + b` for bottom, `super + shift + b` for Bluetooth) and clearly stands for Battery.

## Audio Controls

-   **Keybinding:** `XF86Audio...` keys, `ctrl + alt + p`, `ctrl + shift + .`, `ctrl + shift + ,`
    -   **Intention:** Standard media key controls for play/pause, next, previous, and stop.
    -   **Optimized:** yes
    -   **Suggestion:** none

-   **Keybinding:** `alt + {h,j,k,l}`
    -   **Command:** `mpc {prev,next,play,pause}`
    -   **Intention:** Controls the MPD client with Vim-like keys.
    -   **Optimized:** yes
    -   **Suggestion:** none

## i3 Window Manager

-   **Analysis:** The keybindings for i3 (workspaces, reload/exit, layout toggles, window navigation/manipulation, and gaps) follow well-established conventions for tiling window managers and are highly optimized for efficiency. No changes are recommended.
    -   **Optimized:** yes
    -   **Suggestion:** none

## Scratchpads (Summonable Applications)

-   **Keybinding:** `super + n` (neovide)
    -   **Intention:** Summons a Neovide instance for notes.
    -   **Optimized:** yes (N for Neovide/Notes)
    -   **Suggestion:** none

-   **Keybinding:** `super + t` (terminal)
    -   **Intention:** Summons a scratchpad terminal.
    -   **Optimized:** yes (T for Terminal)
    -   **Suggestion:** none

-   **Keybinding:** `super + b` (bottom)
    -   **Intention:** Summons the `btm` system monitor.
    -   **Optimized:** yes (B for Bottom)
    -   **Suggestion:** none

-   **Keybinding:** `super + shift + b` (blueman-manager)
    -   **Intention:** Summons the Bluetooth manager.
    -   **Optimized:** yes (B for Bluetooth)
    -   **Suggestion:** none

-   **Keybinding:** `super + shift + g` (bitwarden)
    -   **Intention:** Summons the Bitwarden password manager.
    -   **Optimized:** no (G for Guard?)
    -   **Suggestion:** `super + alt + p` (P for Password). This avoids conflicts with `super + p` (powermenu) and `super + shift + p` (pomodoro).

-   **Keybinding:** `super + m` (spotify)
    -   **Intention:** Summons Spotify.
    -   **Optimized:** yes (M for Music)
    -   **Suggestion:** none

-   **Keybinding:** `super + shift + m` (cmus)
    -   **Intention:** Summons the `cmus` terminal music player.
    -   **Optimized:** yes (M for Music, shift for alternative)
    -   **Suggestion:** none

-   **Keybinding:** `super + g` (todoist)
    -   **Intention:** Summons the Todoist application.
    -   **Optimized:** no (G for Goals?)
    -   **Suggestion:** `super + alt + t` (T for Todo/Task). This avoids conflict with `super + t` (terminal).

-   **Keybinding:** `super + d` (Thunar)
    -   **Intention:** Summons the Thunar file manager.
    -   **Optimized:** no (D for Directory?)
    -   **Suggestion:** `super + alt + f` (F for File Manager). This avoids conflict with `super + f` (fullscreen toggle).

-   **Keybinding:** `super + comma` (xpad)
    -   **Intention:** Summons Xpad for sticky notes.
    -   **Optimized:** no
    -   **Suggestion:** `super + alt + n` (N for Notes). This groups it with `super + n` (neovide) and `super + shift + n` (floating notes).

-   **Keybinding:** `super + shift + n` (floating-notes)
    -   **Intention:** Summons a floating terminal with a Neovim note.
    -   **Optimized:** yes (N for Notes, shift for alternative)
    -   **Suggestion:** none

-   **Keybinding:** `super + u` (telegram)
    -   **Intention:** Summons Telegram.
    -   **Optimized:** no
    -   **Suggestion:** `super + alt + c` (C for Communication/Chat). This avoids conflicts with `super + c` (battery) and `super + shift + c` (vscode).

-   **Keybinding:** `super + shift + p` (gnome-pomodoro)
    -   **Intention:** Summons the GNOME Pomodoro timer.
    -   **Optimized:** yes (P for Pomodoro)
    -   **Suggestion:** none

## Custom Scripts

-   **Pomodoro Controls:** `super + alt + {p, b, c, Up, Down, r}`
    -   **Intention:** A set of bindings to control the Polybar Pomodoro script.
    -   **Optimized:** yes (Grouped under `super + alt` modifier)
    -   **Suggestion:** none

-   **Keybinding:** `super + alt + w`
    -   **Intention:** Starts a custom Pomodoro work timer via a Rofi prompt.
    -   **Optimized:** yes (W for Work, grouped with other Pomodoro keys)
    -   **Suggestion:** none

-   **Keybinding:** `super + w`
    -   **Intention:** Toggles the Nerd Dictation (speech-to-text) service.
    -   **Optimized:** yes (W for Write/Whisper)
    -   **Suggestion:** none

## Testing

-   **Keybinding:** `super + i`
    -   **Command:** `test-noti`
    -   **Intention:** Sends a test notification.
    -   **Optimized:** yes (Acceptable for a temporary test binding)
    -   **Suggestion:** none
