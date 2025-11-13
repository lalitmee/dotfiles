# Feature Implementation Plan: Exclude Gimp from Picom Opacity

## 📋 Todo Checklist
- [ ] ⏩ **Investigate GIMP Window Properties**: Use `xprop` to identify the correct window properties for GIMP's main window, menus, and dialogs.
- [ ] 📝 **Update `picom.conf`**: Add new, evidence-based opacity rules to your `picom.conf`.
- [ ] 🔄 **Restart Picom**: Apply the new configuration.
- [ ] ✅ **Final Review and Testing**: Verify that GIMP and all its components are fully opaque.

## 🔍 Analysis & Investigation

### The Core Problem
The previous plan made an assumption about the window properties of GIMP's menus and dialogs. As you correctly pointed out, these can vary between GIMP versions, desktop environments, and window managers. The key to solving this is to **not assume** and instead use tools to find the exact properties of the windows on your system.

### The Tool for the Job: `xprop`
`xprop` is a command-line utility that displays window and font properties of an X server. It is the right tool to get the information we need to create the correct `picom` rules.

### Properties to Look For
When you use `xprop`, you should look for the following properties:
*   `WM_CLASS(STRING)`: This will give you the window class. It's usually a good starting point.
*   `_NET_WM_WINDOW_TYPE(ATOM)`: This is very useful for identifying specific types of windows, like menus, toolbars, and dialogs.
*   `WM_WINDOW_ROLE(STRING)`: This can also be used to differentiate between different windows of the same application.

## 📝 Implementation Plan: An Evidence-Based Approach

This plan will guide you through the process of finding the correct window properties for your GIMP installation and creating the appropriate `picom` rules.

### Step 1: Investigate with `xprop`

You will need to run `xprop` multiple times to get the properties of the different GIMP windows.

1.  **Main GIMP Window:**
    *   Open a terminal and run `xprop`.
    *   Your cursor will turn into a crosshair. Click on the main GIMP window (the one with the image).
    *   Look at the output in the terminal. Find the lines for `WM_CLASS`, `_NET_WM_WINDOW_TYPE`, and `WM_WINDOW_ROLE`.
    *   Save this output to a text file for later reference.

2.  **GIMP Menus:**
    *   Run `xprop` again.
    *   This is the tricky part: you need to click on a menu popup (e.g., the "File" menu). You might need to be quick.
    *   Again, look for `WM_CLASS`, `_NET_WM_WINDOW_TYPE`, and `WM_WINDOW_ROLE` in the output.
    *   You will likely see something like `_NET_WM_WINDOW_TYPE_DROPDOWN_MENU` or `_NET_WM_WINDOW_TYPE_POPUP_MENU`. This is the key to targeting the menus.
    *   Save this output.

3.  **GIMP Dialogs:**
    *   Run `xprop` one more time.
    *   Open a dialog in GIMP (e.g., "File" > "Open...").
    *   Click on the dialog window with the `xprop` crosshair.
    *   Look for the same properties as before. You might see `_NET_WM_WINDOW_TYPE_DIALOG`.
    *   Save this output.

### Step 2: Construct Your `opacity-rule`

Now that you have the actual properties from your system, you can construct the `opacity-rule` in your `picom/.config/picom.conf` file.

Here is an example of how you might construct the rules based on the information you gathered. **Do not copy this blindly. Use the values you found with `xprop`.**

Let's say you found the following:
*   **Main Window:** `WM_CLASS(STRING) = "gimp", "Gimp"`
*   **Menu:** `_NET_WM_WINDOW_TYPE(ATOM) = _NET_WM_WINDOW_TYPE_DROPDOWN_MENU`
*   **Dialog:** `_NET_WM_WINDOW_TYPE(ATOM) = _NET_WM_WINDOW_TYPE_DIALOG`

Your `opacity-rule` section in `picom.conf` would look something like this:

```
opacity-rule = [
  # Rules for GIMP based on your xprop investigation
  "100:class_g = 'Gimp'",
  "100:_NET_WM_WINDOW_TYPE = '_NET_WM_WINDOW_TYPE_DROPDOWN_MENU'",
  "100:_NET_WM_WINDOW_TYPE = '_NET_WM_WINDOW_TYPE_DIALOG'",

  # Your other rules
  "85:class_g = 'Rofi'",
  "90:class_g = 'kitty' && focused",
  "80:class_g = 'kitty' && !focused",
  "90:class_g = 'Alacritty' && focused",
  "80:class_g = 'Alacritty' && !focused"
];
```

You might find other properties that are more specific to your setup. The goal is to add a `"100:..."` rule for each type of GIMP window that you want to be fully opaque.

### Step 3: Restart Picom

Restart Picom to apply the changes. You can do this by killing the current picom process (`pkill picom`) and starting it again, or by using a keybinding if you have one set up in your window manager.

### Testing Strategy
After restarting Picom, open Gimp. Open various menus, dialogs, and tool windows. Verify that all parts of the GIMP application are now fully opaque. If some parts are still transparent, repeat Step 1 for those parts and add a new rule in Step 2.

## 🎯 Success Criteria
You have successfully identified the correct window properties for your GIMP installation and have created `picom` rules that make all parts of GIMP fully opaque. You have done this without making assumptions, using an evidence-based approach.
