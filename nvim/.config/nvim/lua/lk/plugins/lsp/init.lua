local oslib = require("lk/utils/oslib")
local fn = vim.fn
local fmt = string.format
local icons = lk.style.icons.lsp
local map = lk.map

----------------------------------------------------------------------
-- NOTE: automatic setting up commands and handlers {{{
----------------------------------------------------------------------
require("lk/plugins/lsp/commands")
require("lk/plugins/lsp/handlers")
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: servers config {{{
----------------------------------------------------------------------
local gopls = require("lk/plugins/lsp/servers/gopls")
local sumneko = require("lk/plugins/lsp/servers/sumneko")
local autocommands = require("lk/plugins/lsp/autocommands")
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: diagnostic signs {{{
----------------------------------------------------------------------
local diagnostic_types = {
  { "Error", icon = icons.error },
  { "Warn", icon = icons.warn },
  { "Hint", icon = icons.hint },
  { "Info", icon = icons.info },
}

fn.sign_define(vim.tbl_map(function(t)
  local hl = "DiagnosticSign" .. t[1]
  return {
    name = hl,
    text = t.icon,
    texthl = hl,
    linehl = fmt("%sLine", hl),
  }
end, diagnostic_types))
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: on attach function {{{
----------------------------------------------------------------------
local function on_attach(client, bufnr)
  local nmap = lk.nmap
  local imap = lk.imap
  local opts = { noremap = false, silent = true, buffer = bufnr }

  -- lsp mapping for the client
  nmap("gd", "<cmd>Telescope lsp_definitions<CR>", opts)
  nmap("ge", "<cmd>Telescope diagnostics<CR>", opts)
  nmap("gr", "<cmd>Telescope lsp_references<CR>", opts)
  nmap("gw", "<cmd>Telescope lsp_document_symbols<CR>", opts)
  nmap("gW", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts)
  nmap("K", vim.lsp.buf.hover, opts)
  nmap("gD", vim.lsp.buf.declaration, opts)
  nmap("gy", vim.lsp.buf.type_definition, opts)
  imap("<C-h>", vim.lsp.buf.signature_help, opts)

  local mapping_opts = { buffer = bufnr }
  if client.server_capabilities.implementation then
    nmap("gi", vim.lsp.buf.implementation, mapping_opts)
  end

  vim.notify(
    string.format("[LSP] %s\n[CWD] %s", client.name, oslib.get_cwd()),
    "info",
    { title = "[LSP] Active", timeout = 250 }
  )
  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
  autocommands.setup_autocommands(client)

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
    map("n", "<leader>gq", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: capabilities {{{
----------------------------------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: servers {{{
----------------------------------------------------------------------
local servers = {
  -- NOTE: not using these servers
  bashls = true,
  cssls = true,
  dockerls = true,
  emmet_ls = true,
  eslint = true,
  gopls = true,
  jsonls = true,
  pyright = true,
  remark_ls = true,
  rust_analyzer = true,
  sumneko_lua = sumneko,
  tsserver = true,
  vimls = true,
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: get servers config {{{
----------------------------------------------------------------------
local custom_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local function get_server_config(server)
  local ok, cmp_nvim_lsp = lk.safe_require("cmp_nvim_lsp")
  if not ok then
    return nil
  end
  local conf = servers[server.name]
  local conf_type = type(conf)
  local config = conf_type == "table" and conf or conf_type == "function" and conf() or {}
  config.flags = { debounce_text_changes = 500 }
  config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
  cmp_nvim_lsp.update_capabilities(config.capabilities)
  config = vim.tbl_deep_extend("force", {
    on_init = custom_init,
    on_attach = on_attach,
    capabilities = config.capabilities,
    flags = {
      debounce_text_changes = nil,
    },
  }, config)
  return config
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: setting servers {{{
----------------------------------------------------------------------
local function set_servers()
  local lsp_installer = require("nvim-lsp-installer")
  lsp_installer.on_server_ready(function(server)
    server:setup(get_server_config(server))
    vim.cmd([[ do User LspAttachBuffers ]])
  end)
end

set_servers()
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: autocommands {{{
----------------------------------------------------------------------
-- NOTE: not using these since we are using virtual text
-- lk.augroup("au_diagnostics", {
--   {
--     event = { "CursorHold", "CursorHoldI" },
--     command = function()
--       vim.diagnostic.open_float(nil, { focus = false })
--     end,
--   },
--   {
--     event = { "CursorHold", "CursorHoldI" },
--     command = function()
--       vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
--     end,
--   },
-- })
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
