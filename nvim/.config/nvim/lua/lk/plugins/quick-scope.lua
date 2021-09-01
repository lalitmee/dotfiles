local highlight = require('lk.highlights')

-- Trigger a highlight in the appropriate direction when pressing these keys:
vim.g.qs_highlight_on_keys = { 'f', 'F', 't', 'T' }

vim.g.qs_max_chars = 150
vim.g.qs_lazy_highlight = 1
-- vim.g.qs_delay = 0

highlight.all {
  {
    'QuickScopePrimary',
    { guifg = '#00C7DF', ctermfg = 155, cterm = 'underline' }
  },
  {
    'QuickScopeSecondary',
    { guifg = '#afff5f', ctermfg = 81, cterm = 'underline' }
  }
}
