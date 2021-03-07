local base16 = require('base16')
local theme_names = base16.theme_names()

Base16_position = 1

function Cycle_theme()
  Base16_position = (Base16_position % #theme_names) + 1
  base16(base16.themes[theme_names[Base16_position]], true)
end

Cycle_theme()
