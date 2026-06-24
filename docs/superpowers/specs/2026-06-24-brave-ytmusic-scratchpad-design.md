# Brave YouTube Music PWA Scratchpad Integration Design

This document details the design for replacing the Pake-packaged YouTube Music app with the Brave Browser YouTube Music PWA as an i3 scratchpad.

## Goal
To use the Brave Browser YouTube Music PWA (`crx_cinhimbnkkaeohfgghhklpknlkffjgod`) as a toggleable scratchpad window bound to `super + y` to leverage Brave's built-in ad-blocking features.

## Proposed Changes

### sxhkd

#### [MODIFY] [sxhkdrc](file:///home/lalitmee/dotfiles/sxhkd/.config/sxhkd/sxhkdrc)
- Update the keybinding for `super + y` to summon the Brave PWA via the unique instance ID:
  ```
  # >> music player -> youtube music
  super + y
      i3run --summon --instance crx_cinhimbnkkaeohfgghhklpknlkffjgod -- brave-browser --app-id=cinhimbnkkaeohfgghhklpknlkffjgod
  ```

### i3

#### [MODIFY] [scratchpads.conf](file:///home/lalitmee/dotfiles/i3/.config/i3/scratchpads.conf)
- Replace the floating window rule for `pake-youtubemusic` with a rule matching the Brave PWA instance:
  ```
  for_window [instance="crx_cinhimbnkkaeohfgghhklpknlkffjgod"] floating enable, resize set 1800 1000, move position center
  ```

---

## Verification Plan

### Automated Checks
- Reload i3 configuration to ensure no syntax errors.

### Manual Verification
- Press `super + y` to launch the Brave PWA.
- Verify the window opens as a floating scratchpad (1800x1000, centered).
- Press `super + y` again to toggle/hide the window.
- Verify that ads are successfully blocked in the Brave PWA.
