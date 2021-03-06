vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }

-- Don't show the dumb matching stuff.
vim.cmd [[set shortmess+=c]]

-- completion.nvim
-- vim.g.completion_confirm_key = ''
vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' }
-- vim.g.completion_enable_snippet = 'snippets.nvim'
vim.g.completion_enable_snippet = 'UltiSnips'

-- Decide on length
vim.g.completion_trigger_keyword_length = 2

-- vim.g.completion_chain_complete_list = {
--   default = {
--     {
--       {complete_items = {'lsp', 'snippet'}},
--       {complete_items = {'buffer'}}, {mode = 'file'}
--     }
--   }
-- }

-- Complextras.nvim configuration
vim.api.nvim_set_keymap(
    'i', '<C-x><C-m>',
    [[<c-r>=luaeval("require('complextras').complete_matching_line()")<CR>]],
    { noremap = true }
)

vim.api.nvim_set_keymap(
    'i', '<C-x><C-d>',
    [[<c-r>=luaeval("require('complextras').complete_line_from_cwd()")<CR>]],
    { noremap = true }
)

-- local has_compe, compe = pcall(require, 'compe')
-- if has_compe then
--   compe.setup {
--     enabled = true,
--     autocomplete = true,
--     debug = false,
--     min_length = 1,
--     preselect = 'enable',
--     throttle_time = 80,
--     source_timeout = 200,
--     incomplete_delay = 400,
--     max_abbr_width = 100,
--     max_kind_width = 100,
--     max_menu_width = 100,
--     documentation = true,
--     source = {
--       buffer = true,
--       calc = true,
--       nvim_lsp = true,
--       nvim_lua = true,
--       nvim_treesitter = true,
--       omni = true,
--       path = true,
--       snippets_nvim = true,
--       spell = true,
--       tags = true,
--       ultisnips = true,
--       vsnip = false
--     }
--   }
-- end
