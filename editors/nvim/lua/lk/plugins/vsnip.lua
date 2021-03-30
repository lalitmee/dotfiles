local map = lk_utils.map

-- Expand
map(
    'i', '<C-j>',
    [[vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>']],
    { expr = true }
)
map(
    's', '<C-j>',
    [[vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>']],
    { expr = true }
)

-- Expand or jump
map(
    'i', '<C-l>',
    [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']],
    { expr = true }
)
map(
    's', '<C-l>',
    [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']],
    { expr = true }
)

-- Jump forward or backward
map(
    'i', '<Tab>',
    [[vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>']],
    { expr = true }
)
map(
    's', '<Tab>',
    [[vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>']],
    { expr = true }
)
map(
    'i', '<S-Tab>',
    [[vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>']],
    { expr = true }
)
map(
    's', '<S-Tab>',
    [[vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>']],
    { expr = true }
)

-- Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
-- See https://github.com/hrsh7th/vim-vsnip/pull/50
map('n', 's', [[<Plug>(vsnip-select-text)]])
map('x', 's', [[<Plug>(vsnip-select-text)]])
map('n', 'S', [[<Plug>(vsnip-cut-text)]])
map('x', 'S', [[<Plug>(vsnip-cut-text)]])

-- If you want to use snippet for multiple filetypes, you can `g.vsnip_filetypes` for it.
vim.g.vsnip_filetypes = {}
vim.g.vsnip_filetypes = { javascriptreact = 'javascript' }
vim.g.vsnip_filetypes = { typescriptreact = 'typescript' }

vim.g.vsnip_snippet_dir = '~/.config/nvim/snippets/vsnips'
