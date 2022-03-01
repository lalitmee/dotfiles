local oslib = require("lk/utils/oslib")

local lspconfig_util = require("lspconfig.util")

require("lk/plugins/nvim_lsp/commands")
require("lk/plugins/nvim_lsp/handlers")
require("lk/plugins/nvim_lsp/servers/gopls")

local autocommands = require("lk/plugins/nvim_lsp/autocommands")
local mappings = require("lk/plugins/nvim_lsp/mappings")
local status = require("lk/plugins/nvim_lsp/status")

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

-- on_atthach
local function on_attach(client, bufnr)
  vim.notify(
    string.format("[LSP] %s\n[CWD] %s", client.name, oslib.get_cwd()),
    "info",
    { title = "[LSP] Active", timeout = 250 }
  )
  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
  autocommands.setup_autocommands(client)
  mappings.setup_mappings(client, bufnr)

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
