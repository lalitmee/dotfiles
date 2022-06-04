local highlight = require("lk.highlights")

-- Trigger a highlight in the appropriate direction when pressing these keys:
vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }

vim.g.qs_max_chars = 150
vim.g.qs_lazy_highlight = 1
-- vim.g.qs_delay = 0

highlight.all({
  {
    "QuickScopePrimary",
    {
      guifg = "#ff6fff",
      guibg = "#000000",
      ctermfg = 155,
      cterm = "underline",
    },
  },
  {
    "QuickScopeSecondary",
    {
      guifg = "#FF0000",
      guibg = "#000000",
      ctermfg = 81,
      cterm = "underline",
    },
  },
})
