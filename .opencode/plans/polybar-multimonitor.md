# Plan: Polybar Multimonitor Tray Icons & Tray Fix

## Goal
1. Show system tray icons on both the middle monitor (`DP-2`, primary) and the laptop screen (`eDP-1`) to allow tray access without exiting full-screen mode on the laptop.
2. Fix tray icon cutoff by adjusting tray settings and bar height.

## Problem Analysis
- **Tray Restriction:** Currently, `polybar/.config/polybar/launch.sh` injects the `tray` module into the `RIGHT_MODULES` environment variable **only** for the primary monitor.
- **Icon Cutoff:** The current bar height (`18pt`) and the `tray-size = 60%` setting may be causing tray icons to be cut off or truncated, especially if icons vary in size.

## Proposed Solution
1.  **Modify `polybar/.config/polybar/launch.sh`**:
    *   Define a list of monitors that should have the tray (e.g., `TRAY_MONITORS="DP-2 eDP-1"`).
    *   Inside the monitor loop, check if the current monitor name matches one in the `TRAY_MONITORS` list.
    *   If it matches, set `RIGHT_MODULES="volume calendar time tray powermenu"`.
    *   If not, set `RIGHT_MODULES="volume calendar time powermenu"`.
2.  **Modify `polybar/.config/polybar/config.ini`**:
    *   Increase the bar `height` from `18pt` to `24pt` to provide more vertical space.
    *   **Remove `tray-size = 60%`** from `[module/tray]` to allow icons to use their natural size (or up to the bar height).

## Implementation Steps
1.  **Edit `polybar/.config/polybar/launch.sh`**:
    *   Add `TRAY_MONITORS="DP-2 eDP-1"` near the top.
    *   Update the loop to check for tray inclusion:
        ```bash
        if [[ "$TRAY_MONITORS" == *"$m"* ]]; then
            MONITOR=$m RIGHT_MODULES="volume calendar time tray powermenu" polybar -c "$BAR_CONFIG" $BAR_NAME 2>&1 | tee -a "$LOG_FILE" &
        else
            MONITOR=$m RIGHT_MODULES="volume calendar time powermenu" polybar -c "$BAR_CONFIG" $BAR_NAME 2>&1 | tee -a "$LOG_FILE" &
        fi
        ```
2.  **Edit `polybar/.config/polybar/config.ini`**:
    *   Change `height = 18pt` to `height = 24pt` under `[bar/mainbar]`.
    *   Remove the line `tray-size = 60%` from `[module/tray]`.

## Verification
*   Reload i3 (`Mod+Shift+r`) or run `~/.config/polybar/launch.sh`.
*   Verify system tray icons are visible on the laptop screen (`eDP-1`).
*   Verify system tray icons are visible on the middle screen (`DP-2`).
*   Verify that no tray icons are cut off and the bar height is sufficient.
