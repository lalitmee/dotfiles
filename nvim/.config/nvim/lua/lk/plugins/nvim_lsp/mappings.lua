local map = lk_utils.map
local tele_mapper = require("lk.plugins.telescope.mappings")

local M = {}

local opts = { noremap = false, silent = true }

-- telescope mappings for lsp and more
map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
map("n", "gcA", "<cmd>Telescope lsp_range_code_actions<CR>", opts)
map("n", "gca", "<cmd>Telescope lsp_code_action<CR>", opts)
map("n", "ge", "<cmd>Telescope diagnostics<CR>", opts)
map("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
map("n", "gw", "<cmd>Telescope lsp_document_symbols<CR>", opts)
map("n", "gW", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts)
map("i", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)

-- diagnostics mappings
map("n", "geN", "<cmd>lua vim.lsp.diagnostic.get_next()<CR>", opts)
map("n", "geP", "<cmd>lua vim.lsp.diagnostic.get_prev()<CR>", opts)
map("n", "gea", "<cmd>lua vim.lsp.diagnostic.get_all()<CR>", opts)
map("n", "gel", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
map("n", "gen", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
map("n", "gep", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
map("n", "geq", "<cmd>lua vim.lsp.diagnostic.setloclist()<CR>", opts)

-- -- formaaing mappings
-- map("n", "gff", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
-- map("n", "gfs", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", opts)

-- workspace mappings
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
map("n", "grc", "<cmd>lua vim.lsp.buf.clear_references()<CR>", opts)
map("n", "grn", "<cmd>lua MyLspRename()<CR>", opts)
map("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)

-- Lspsaga mappings
map("n", "<localleader>ma", "<cmd>Lspsaga code_action<CR>", opts)
map("n", "<localleader>mA", "<cmd>Lspsaga range_code_action<CR>", opts)
map("n", "<localleader>mc", "<cmd>Lspsaga close_floaterm<CR>", opts)
map("n", "<localleader>md", "<cmd>Lspsaga lsp_finder<CR>", opts)
map("n", "<localleader>me", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
map("n", "<localleader>mh", "<cmd>Lspsaga hover_doc<CR>", opts)
map("n", "<localleader>ml", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
map("n", "<localleader>mn", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
map("n", "<localleader>mo", "<cmd>Lspsaga open_floaterm<CR>", opts)
map("n", "<localleader>mp", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
map("n", "<localleader>mr", "<cmd>Lspsaga rename<CR>", opts)
map("n", "<localleader>mv", "<cmd>Lspsaga preview_definition<CR>", opts)

local telescope_opts = { prompt_position = "top" }
tele_mapper("<localleader>ta", "lsp_code_actions", telescope_opts, true)
tele_mapper("<localleader>tA", "lsp_range_code_actions", telescope_opts, true)
tele_mapper("<localleader>td", "lsp_definitions", telescope_opts, true)
tele_mapper("<localleader>te", "diagnostics", telescope_opts, true)
tele_mapper("<localleader>tr", "lsp_references", telescope_opts, true)
tele_mapper("<localleader>tw", "lsp_document_symbols", telescope_opts, true)
tele_mapper("<localleader>tW", "lsp_workspace_symbols", telescope_opts, true)

M.setup_mappings = function(client, bufnr)
  local nnoremap, mapping_opts = lk_utils.nnoremap, { buffer = bufnr }
  if client.resolved_capabilities.implementation then
    nnoremap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", mapping_opts)
  end
  nnoremap("gI", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", mapping_opts)
end

return M

-- commented mappings
