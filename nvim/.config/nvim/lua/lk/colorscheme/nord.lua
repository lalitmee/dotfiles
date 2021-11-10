-- vim.g.nord_contrast = true
-- vim.g.nord_borders = true
-- vim.g.nord_disable_background = true
-- vim.g.nord_italic = true
-- require('nord').set()
require('onenord').setup({
  borders = true, -- Split window borders
  italics = {
    comments = true, -- Italic comments
    strings = false, -- Italic strings
    keywords = true, -- Italic keywords
    functions = false, -- Italic functions
    variables = false -- Italic variables
  },
  disable = {
    background = false, -- Disable setting the background color
    cursorline = true, -- Disable the cursorline
    eob_lines = true -- Hide the end-of-buffer lines
  },
  custom_highlights = {} -- Overwrite default highlight groups
})
vim.cmd([[colorscheme onenord]])
