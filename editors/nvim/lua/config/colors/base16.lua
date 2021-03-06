local base16 = require('base16')
local theme_names = base16.theme_names()

base16_position = 1

function cycle_theme()
  base16_position = (base16_position % #theme_names) + 1
  base16(base16.themes[theme_names[base16_position]], true)
end

cycle_theme()
