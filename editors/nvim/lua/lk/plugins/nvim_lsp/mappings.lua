local map = lk_utils.map
local telescope_mapper = require('lk.plugins.telescope.mappings')

local compe_opts = { noremap = true, silent = true, expr = true }

map('i', '<C-n>', [[compe#complete()]], compe_opts)
map('i', '<CR>', [[compe#confirm('<CR>')]], compe_opts)
map('i', '<C-c>', [[compe#close('<C-e>')]], compe_opts)
map('i', '<C-f>', [[compe#scroll({ 'delta': +4 })]], compe_opts)
map('i', '<C-b>', [[compe#scroll({ 'delta': -4 })]], compe_opts)

local opts = { noremap = false, silent = true }
-- buf native lsp key maps
-- map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
-- map('n', 'ge', '<cmd>lua vim.lsp.diagnostic.get_all()<CR>', opts)
-- map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
-- map('n', 'gw', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
map('i', '<C-h>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
map('n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)

-- diagnostics mappings
map('n', 'geN', '<cmd>lua vim.lsp.diagnostic.get_next()<CR>', opts)
map('n', 'geP', '<cmd>lua vim.lsp.diagnostic.get_prev()<CR>', opts)
map('n', 'gea', '<cmd>lua vim.lsp.diagnostic.get_all()<CR>', opts)
map('n', 'gel', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
map('n', 'gen', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
map('n', 'gep', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
map('n', 'geq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

-- formaaing mappings
map('n', 'gff', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
map('n', 'gfs', '<cmd>lua vim.lsp.buf.formatting_sync()<CR>', opts)

-- workspace mappings
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
map('n', 'grc', '<cmd>lua vim.lsp.buf.clear_references()<CR>', opts)
map('n', 'grn', '<cmd>lua MyLspRename()<CR>', opts)
map('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

-- Lspsaga mappings
map('n', '<localleader>ma', '<cmd>Lspsaga code_action<CR>', opts)
map('n', '<localleader>mA', '<cmd>Lspsaga range_code_action<CR>', opts)
map('n', '<localleader>mc', '<cmd>Lspsaga close_floaterm<CR>', opts)
map('n', '<localleader>md', '<cmd>Lspsaga lsp_finder<CR>', opts)
map('n', '<localleader>me', '<cmd>Lspsaga show_cursor_diagnostics<CR>', opts)
map('n', '<localleader>mh', '<cmd>Lspsaga hover_doc<CR>', opts)
map('n', '<localleader>ml', '<cmd>Lspsaga show_line_diagnostics<CR>', opts)
map('n', '<localleader>mn', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)
map('n', '<localleader>mo', '<cmd>Lspsaga open_floaterm<CR>', opts)
map('n', '<localleader>mp', '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
map('n', '<localleader>mr', '<cmd>Lspsaga rename<CR>', opts)
map('n', '<localleader>mv', '<cmd>Lspsaga preview_definition<CR>', opts)

-- telescope mappings for lsp and more
map('n', 'gW', '<cmd>Telescope lsp_workspace_symbols<CR>', opts)
map('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
map('n', 'gcA', '<cmd>Telescope lsp_range_code_actions<CR>', opts)
map('n', 'gca', '<cmd>Telescope lsp_code_actions<CR>', opts)
map('n', 'ge', '<cmd>Telescope lsp_document_diagnostics<CR>', opts)
map('n', 'gE', '<cmd>Telescope lsp_workspace_diagnostics<CR>', opts)
map('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
map('n', 'gw', '<cmd>Telescope lsp_document_symbols<CR>', opts)
-- map(
--     'n', 'gW',
--     '<cmd>lua require("lk.plugins.telescope.lens").live_workspace_symbols()<CR>',
--     opts
-- )

local telescope_opts = { prompt_position = 'top' }
telescope_mapper('<localleader>ta', 'lsp_code_actions', telescope_opts, true)
telescope_mapper(
    '<localleader>tA', 'lsp_range_code_actions', telescope_opts, true
)
telescope_mapper('<localleader>td', 'lsp_definitions', telescope_opts, true)
telescope_mapper(
    '<localleader>te', 'lsp_document_diagnostics', telescope_opts, true
)
telescope_mapper(
    '<localleader>tE', 'lsp_workspace_diagnostics', telescope_opts, true
)
telescope_mapper('<localleader>tr', 'lsp_references', telescope_opts, true)
telescope_mapper('<localleader>tw', 'lsp_document_symbols', telescope_opts, true)
telescope_mapper(
    '<localleader>tW', 'lsp_workspace_symbols', telescope_opts, true
)
