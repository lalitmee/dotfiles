vim.o.background = 'dark' -- or light if you so prefer
require('gruvqueen').setup({
  config = {
    disable_bold = false,
    italic_comments = true,
    italic_keywords = true,
    italic_functions = false,
    italic_variables = false,
    invert_selection = false,
    style = 'mix', -- possible values: 'original', 'mix', 'material'
    -- transparent_background = true,
    -- bg_color = "black",
  },
})
