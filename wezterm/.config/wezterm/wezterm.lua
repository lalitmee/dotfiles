-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.enable_tab_bar = false

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

config.window_background_opacity = 0.8

-- For example, changing the color scheme:
config.color_scheme = "Cobalt2"

config.font = wezterm.font("Operator Mono Lig Book")
config.font_size = 11

-- and finally, return the configuration to wezterm
return config
