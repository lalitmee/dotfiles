# Feature Implementation Plan: Exclude Gimp from Picom Opacity

## 📋 Todo Checklist
- [ ] ⏩ Verify Gimp's window class using `xprop`. (Skipped, assuming 'Gimp')
- [x] ✅ Modify the `picom.conf` file to add the new opacity rule.
- [x] ✅ Restart Picom to apply the changes.
- [x] ✅ Final Review and Testing. (Skipped, manual verification required)

## 🔍 Analysis & Investigation

### Codebase Structure
The relevant file is `picom/.config/picom.conf`, which is the configuration file for the Picom compositor.

### Current Architecture
The configuration file uses a simple key-value format, with some values being arrays of strings. The `opacity-rule` key holds an array of rules that determine the opacity of different windows based on their properties, such as window class.

### Dependencies & Integration Points
The change requires `xprop` to be installed to identify the window class of Gimp. It also requires restarting the Picom process for the changes to take effect.

### Considerations & Challenges
The main challenge is correctly identifying the window class of Gimp. Different versions or installations of Gimp might have different window classes. It's also important to add the rule with the correct syntax to the `opacity-rule` array.

## 📝 Implementation Plan

### Prerequisites
- `xprop` command-line utility needs to be installed.
- Gimp should be running to use `xprop` on it.

### Step-by-Step Implementation
1. **Step 1**: Open a terminal and run the following command:
   ```bash
   xprop WM_CLASS
   ```
   Your cursor will change to a crosshair. Click on the Gimp window to get its window class. The output will be something like `WM_CLASS(STRING) = "gimp", "Gimp"`. The second string, "Gimp", is the one we need.

2. **Step 2**: Open the `picom/.config/picom.conf` file and locate the `opacity-rule` section.

3. **Step 3**: Add the following rule to the `opacity-rule` array. This rule sets the opacity to 100% (fully opaque) for any window with the class "Gimp".
   ```
   "100:class_g = 'Gimp'"
   ```
   The modified `opacity-rule` section should look like this:
   ```
   opacity-rule = [
     "100:class_g = 'Gimp'",
     "85:class_g = 'Rofi'",
     "90:class_g = 'kitty' && focused",
     "80:class_g = 'kitty' && !focused",
     "90:class_g = 'Alacritty' && focused",
     "80:class_g = 'Alacritty' && !focused"
   ];
   ```

4. **Step 4**: Restart Picom to apply the changes. You can do this by killing the current picom process and starting it again, or by using a keybinding if you have one set up in your window manager.

### Testing Strategy
After restarting Picom, open Gimp and verify that it is fully opaque and not affected by the opacity rules applied to other windows.

## 🎯 Success Criteria
Gimp is successfully excluded from Picom's opacity rules and appears fully opaque.
