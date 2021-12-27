local onedarkpro = require('onedarkpro')

onedarkpro.setup({
  theme = 'onedark',
  colors = {}, -- Override default colors. Can specify colors for "onelight" or "onedark" themes
  hlgroups = {}, -- Override default highlight groups
  styles = {
    strings = 'NONE', -- Style that is applied to strings
    comments = 'italic', -- Style that is applied to comments
    keywords = 'italic', -- Style that is applied to keywords
    functions = 'NONE', -- Style that is applied to functions
    variables = 'NONE', -- Style that is applied to variables
  },
  options = {
    bold = true, -- Use the themes opinionated bold styles?
    italic = true, -- Use the themes opinionated italic styles?
    underline = false, -- Use the themes opinionated underline styles?
    undercurl = true, -- Use the themes opinionated undercurl styles?
    cursorline = true, -- Use cursorline highlighting?
    transparency = false, -- Use a transparent background?
    terminal_colors = false, -- Use the theme's colors for Neovim's :terminal?
    window_unfocussed_color = false, -- When the window is out of focus, change the normal background?
  },
})

onedarkpro.load()
