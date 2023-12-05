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

config.window_background_opacity = 0.8
config.text_background_opacity = 0.8

-- For example, changing the color scheme:
config.color_scheme = "Cobalt2"

-- Set background to same color as neovim
config.colors = {}
config.colors.background = "#193549"

config.font = wezterm.font("Operator Mono Lig Book", { weight = "Regular" })
-- config.cell_width = 1.0
-- config.line_height = 1.0
config.font_size = 12

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

-- NOTE: refer to this comment https://github.com/wez/wezterm/issues/3774#issuecomment-1629689265
config.freetype_load_flags = "NO_HINTING"

-- config.window_close_confirmation = false

-- and finally, return the configuration to wezterm
return config
