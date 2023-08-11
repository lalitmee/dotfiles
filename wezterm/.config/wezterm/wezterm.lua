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

config.window_background_opacity = 0.9

-- For example, changing the color scheme:
config.color_scheme = "Cobalt2"

-- -- Set background to same color as neovim
config.colors = {}
config.colors.background = "#193549"

config.font = wezterm.font_with_fallback({
    -- "Operator Mono Lig Book",
    -- "Iosevka Monaco",
    "Iosevka",
    -- "BlexMono Nerd Font",
    -- "CaskaydiaCove Nerd Font",
    -- "MonoLisa Nerd Font",
})
config.font_size = 10

-- default is true, has more "native" look
config.use_fancy_tab_bar = false
config.enable_tab_bar = false

config.tab_bar_at_bottom = true
config.freetype_load_target = "HorizontalLcd"

config.enable_scroll_bar = false
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- config.window_close_confirmation = false

-- and finally, return the configuration to wezterm
return config
