local M = {}
local map = lk.map

local map_opts = { noremap = false, silent = true }

----------------------------------------------------------------------
-- NOTE: servers config {{{
----------------------------------------------------------------------
local autocmds = require("lk/plugins/lsp/autocmds")
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: on attach function {{{
----------------------------------------------------------------------
M.on_attach = function(client, bufnr)
  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
  autocmds.setup_autocommands(client)

  -- mappings
  M.mappings()

  -- capabilities
  M.capabilities(client, bufnr)

  -- navic
  M.navic(client, bufnr)
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: mappings {{{
----------------------------------------------------------------------
M.mappings = function()
  local nmap = lk.nmap
  local imap = lk.imap

  -- lsp mapping for the client
  nmap("gd", "<cmd>Telescope lsp_definitions<CR>", map_opts)
  nmap("ge", "<cmd>Telescope diagnostics<CR>", map_opts)
  nmap("gr", "<cmd>Telescope lsp_references<CR>", map_opts)
  nmap("gw", "<cmd>Telescope lsp_document_symbols<CR>", map_opts)
  nmap("gW", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", map_opts)
  nmap("K", vim.lsp.buf.hover, map_opts)
  nmap("gD", vim.lsp.buf.declaration, map_opts)
  nmap("gy", vim.lsp.buf.type_definition, map_opts)
  imap("<C-h>", vim.lsp.buf.signature_help, map_opts)
  nmap("gi", vim.lsp.buf.implementation, map_opts)
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: format on save {{{
----------------------------------------------------------------------
---Common format-on-save for lsp servers that implements formatting
---@param client table
---@param buf integer
M.fmt_on_save = function(client, buf)
  if client.supports_method("textDocument/formatting") then
    lk.augroup("format_on_save_au", {
      event = { "BufWritePre" },
      buffer = buf,
      command = function()
        vim.lsp.buf.format({
          timeout_ms = 3000,
          buffer = buf,
        })
      end,
    })
  end
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: capabilities {{{
----------------------------------------------------------------------
M.capabilities = function(client, bufnr)
  client.server_capabilities.document_formatting = false
  if client.server_capabilities.document_highlight then
    vim.cmd([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd! CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]])
  end
  if client.server_capabilities.goto_definition == true then
    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
  end

  if client.server_capabilities.document_formatting == true then
    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    -- Add this <leader> bound mapping so formatting the entire document is easier.
    map("n", "<leader>gq", "<cmd>lua vim.lsp.buf.formatting()<CR>", map_opts)
  end
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: nvim-navic setup {{{
----------------------------------------------------------------------
M.navic = function(client, bufnr)
  local navic_ok, navic = lk.require("nvim-navic")
  if navic_ok then
    local skipNavicLsps = { "ltex", "cssls", "eslint", "html", "remark_ls", "bashls", "tailwindcss" }
    if lk.has_value(skipNavicLsps, client.name) == false then
      navic.attach(client, bufnr)
    end
  end
end
-- }}}
----------------------------------------------------------------------

return M