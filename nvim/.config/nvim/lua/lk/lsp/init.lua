local fn = vim.fn
local fmt = string.format

local icons = lk.style.icons

local oslib = require("lk/utils/oslib")

local lspconfig_util = require("lspconfig.util")

require("lk/lsp/commands")
require("lk/lsp/handlers")
require("lk/lsp/servers/gopls")

local autocommands = require("lk/lsp/autocommands")
local status = require("lk/lsp/status")

status.activate()

function Tagfunc(pattern, flags)
  if flags ~= "c" then
    return vim.NIL
  end
  local params = vim.lsp.util.make_position_params()
  local client_id_to_results, err = vim.lsp.buf_request_sync(0, "textDocument/definition", params, 500)
  assert(not err, vim.inspect(err))

  local results = {}
  for _, lsp_results in ipairs(client_id_to_results) do
    for _, location in ipairs(lsp_results.result or {}) do
      local start = location.range.start
      table.insert(results, {
        name = pattern,
        filename = vim.uri_to_fname(location.uri),
        cmd = string.format("call cursor(%d, %d)", start.line + 1, start.character + 1),
      })
    end
  end
  return results
end

-----------------------------------------------------------------------------//
-- Signs
-----------------------------------------------------------------------------//
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

---Override diagnostics signs helper to only show the single most relevant sign
---@see: http://reddit.com/r/neovim/comments/mvhfw7/can_built_in_lsp_diagnostics_be_limited_to_show_a
---@param diagnostics table[]
---@param _ number buffer number
---@return table[]
local function filter_diagnostics(diagnostics, _)
  if not diagnostics then
    return {}
  end
  -- Work out max severity diagnostic per line
  local max_severity_per_line = {}
  for _, d in pairs(diagnostics) do
    local lnum = d.lnum
    if max_severity_per_line[lnum] then
      local current_d = max_severity_per_line[lnum]
      if d.severity < current_d.severity then
        max_severity_per_line[lnum] = d
      end
    else
      max_severity_per_line[lnum] = d
    end
  end

  -- map to list
  local filtered_diagnostics = {}
  for _, v in pairs(max_severity_per_line) do
    table.insert(filtered_diagnostics, v)
  end
  return filtered_diagnostics
end

--- This overwrites the diagnostic show/set_signs function to replace it with a custom function
--- that restricts nvim's diagnostic signs to only the single most severe one per line
local ns = vim.api.nvim_create_namespace("severe-diagnostics")
local show = vim.diagnostic.show
local function display_signs(bufnr)
  -- Get all diagnostics from the current buffer
  local diagnostics = vim.diagnostic.get(bufnr)
  local filtered = filter_diagnostics(diagnostics, bufnr)
  show(ns, bufnr, filtered, {
    virtual_text = false,
    underline = false,
    signs = true,
  })
end

function vim.diagnostic.show(namespace, bufnr, ...)
  show(namespace, bufnr, ...)
  display_signs(bufnr)
end

-- on_atthach
local function on_attach(client, bufnr)
  local map = vim.keymap.set
  local opts = { noremap = false, silent = true }

  -- lsp mapping for the client
  map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
  map("n", "gcA", "<cmd>Telescope lsp_range_code_actions<CR>", opts)
  map("n", "gca", "<cmd>Telescope lsp_code_action<CR>", opts)
  map("n", "ge", "<cmd>Telescope diagnostics<CR>", opts)
  map("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
  map("n", "gw", "<cmd>Telescope lsp_document_symbols<CR>", opts)
  map("n", "gW", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts)
  map("i", "<C-h>", "<cmd>Lspsaga signature_help<CR>", opts)
  map("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
  map("n", "gD", vim.lsp.buf.declaration, opts)
  map("n", "gy", vim.lsp.buf.type_definition, opts)

  local mapping_opts = { buffer = bufnr }
  if client.resolved_capabilities.implementation then
    map("n", "gi", vim.lsp.buf.implementation, mapping_opts)
  end

  vim.notify(
    string.format("[LSP] %s\n[CWD] %s", client.name, oslib.get_cwd()),
    "info",
    { title = "[LSP] Active", timeout = 250 }
  )
  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
  autocommands.setup_autocommands(client)

  client.resolved_capabilities.document_formatting = false
  if client.resolved_capabilities.document_highlight then
    vim.cmd([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd! CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]])
  end
  if client.resolved_capabilities.goto_definition then
    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.Tagfunc")
  end
  require("lsp-status").on_attach(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}

local servers = {
  cssls = true,
  gopls = {
    root_dir = function(fname)
      local Path = require("plenary.path")

      local absolute_cwd = Path:new(vim.loop.cwd()):absolute()
      local absolute_fname = Path:new(fname):absolute()

      if string.find(absolute_cwd, "/cmd/", 1, true) and string.find(absolute_fname, absolute_cwd, 1, true) then
        return absolute_cwd
      end

      return lspconfig_util.root_pattern("go.mod", ".git")(fname)
    end,

    settings = {
      gopls = {
        codelenses = { test = true },
      },
    },

    flags = {
      debounce_text_changes = 200,
    },
  },
  bashls = true,
  jsonls = true,
  tsserver = true,
  vimls = true,
  pyright = true,
  remark_ls = true,
  rust_analyzer = true,
  eslint = true,
  emmet_ls = true,
  sumneko_lua = function()
    local lua_dev = require("lua-dev")
    return lua_dev.setup({
      lspconfig = {
        settings = {
          Lua = {
            diagnostics = {
              globals = {
                "vim",
                "describe",
                "it",
                "before_each",
                "after_each",
                "pending",
                "teardown",
                "packer_plugins",
              },
            },
            completion = { keywordSnippet = "Replace", callSnippet = "Replace" },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),

              maxPreload = 2000,
              preloadFileSize = 50000,
              checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
          },
        },
      },
    })
  end,
}

local function get_server_config(server)
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local status_capabilities = require("lsp-status").capabilities
  local conf = servers[server.name]
  local conf_type = type(conf)
  local config = conf_type == "table" and conf or conf_type == "function" and conf() or {}
  config.flags = { debounce_text_changes = 500 }
  config.on_attach = on_attach
  config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
  cmp_nvim_lsp.update_capabilities(config.capabilities)
  config.capabilities = lk.deep_merge(status_capabilities, config.capabilities)
  return config
end

local function set_servers()
  local lsp_installer = require("nvim-lsp-installer")
  lsp_installer.on_server_ready(function(server)
    server:setup(get_server_config(server))
    vim.cmd([[ do User LspAttachBuffers ]])
  end)
end

set_servers()

-- vim:foldmethod=marker