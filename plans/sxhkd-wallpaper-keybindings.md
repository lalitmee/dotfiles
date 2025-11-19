# Feature Implementation Plan: sxhkd-wallpaper-keybindings

## 📋 Todo Checklist
- [x] ✅ Add new keybindings to `sxhkdrc`.
- [x] ✅ Reload `sxhkd` to apply the new keybindings.
- [ ] ⏩ Test the new keybindings.

## 🔍 Analysis & Investigation

### Codebase Structure
- The `sxhkd` configuration file is located at `sxhkd/.config/sxhkd/sxhkdrc`.
- The wallpaper script is located at `bin/.config/bin/walls`.

### Current Architecture
- `sxhkd` is used to manage global keybindings.
- The `walls` script changes the wallpaper using `feh`. It accepts 'r' for a random wallpaper and 's' for selecting a wallpaper.
- The selection mode (`walls s`) uses `fzf` and therefore must be run inside a terminal emulator.

### Dependencies & Integration Points
- `sxhkd` needs to be running.
- `feh` must be installed for the `walls` script to work.
- `fzf` must be installed for the selection mode of the `walls` script.
- A terminal emulator (`ghostty` is assumed based on existing configuration) must be installed.

### Considerations & Challenges
- Many keybindings are already defined in `sxhkdrc`. It was important to find keybindings that are not already in use and are mnemonic.
- After reviewing the existing `sxhkdrc`, `super + ctrl + r` and `super + ctrl + s` have been identified as available and suitable.
- The `walls s` command must be launched within a terminal to allow `fzf` to work correctly. The plan will be updated to use `ghostty` for this purpose.

## 📝 Implementation Plan

### Prerequisites
- Ensure `sxhkd`, `feh`, `fzf`, and `ghostty` are installed and in the system's PATH.

### Step-by-Step Implementation
1. **Step 1**: Add the new keybindings to `sxhkdrc`.
   - Files to modify: `sxhkd/.config/sxhkd/sxhkdrc`
   - Changes needed: Add the following lines to the "custom scripts" section of the file. Note the change for the 'select wallpaper' command.

   ```
   #-------------------------------------------------------------------------------
   # NOTE: wallpaper changer {{{
   #-------------------------------------------------------------------------------
   # random wallpaper
   super + ctrl + r
       ~/.config/bin/walls r

   # select wallpaper
   super + ctrl + s
       ghostty -e ~/.config/bin/walls s
   #}}}
   #-------------------------------------------------------------------------------
   ```

2. **Step 2**: Reload the `sxhkd` configuration.
   - Run the following command in a terminal:
     ```bash
     pkill -USR1 -x sxhkd
     ```
   - Alternatively, use the configured reload keybinding if one exists (e.g., `super + Escape` in the provided configuration).

### Testing Strategy
- Press `super + ctrl + r` and verify that the wallpaper changes to a random one from the `~/Projects/Personal/Github/wallpapers` directory.
- Press `super + ctrl + s` and verify that a new `ghostty` terminal window opens and runs `fzf` with a list of wallpapers to choose from. Select a wallpaper and confirm it is set as the background, and the terminal closes.

## 🎯 Success Criteria
- The new keybindings are successfully added to `sxhkdrc`.
- `sxhkd` is reloaded without errors.
- Pressing `super + ctrl + r` changes the wallpaper randomly.
- Pressing `super + ctrl + s` opens a terminal and allows the user to select a wallpaper using `fzf`.
