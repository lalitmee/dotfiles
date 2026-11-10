-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Monitor scale is Hyprland's scale for the output. It sizes everything
-- Wayland-native, accepts fractions (1.6, 1.75), and applies immediately.
-- "auto" lets Hyprland pick per display.
local omarchy_monitor_scale = "auto"
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Personal monitor layout.
-- Explicit extended layout, left to right:
--   DP-1 (portrait, 1080x1920) - DP-2 (1920x1080) - eDP-1 (laptop, 1280x720)
-- Positions are in logical pixels, so they already account for scale.
-- Using a distinct position per output keeps them extended, never mirrored.

-- Left external, kept portrait (transform: 1 = 90° clockwise, 3 = 270°).
hl.monitor({ output = "DP-1", mode = "preferred", position = "0x0", scale = 1, transform = 1 })

-- Middle external, landscape, vertically centered next to the portrait monitor.
hl.monitor({ output = "DP-2", mode = "preferred", position = "1080x420", scale = 1 })

-- Laptop panel on the right, vertically centered.
hl.monitor({ output = "eDP-1", mode = "preferred", position = "3000x600", scale = 1.25 })

-- GDK scale is GDK_SCALE, the factor GTK draws its own UI at. It's what
-- sizes X11/XWayland windows, which Omarchy leaves unscaled so they stay
-- crisp instead of being stretched by the compositor. GTK only honors whole
-- numbers, so use the nearest integer to the monitor scale, and restart an
-- app for a change to reach it.
local omarchy_gdk_scale = 1
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
