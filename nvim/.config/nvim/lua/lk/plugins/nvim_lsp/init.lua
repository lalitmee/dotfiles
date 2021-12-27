local lsp_status = require('lsp-status')
lsp_status.register_progress()

-- require('lk/plugins/nvim_lsp/highlights')
require('lk/plugins/nvim_lsp/commands')
require('lk/plugins/nvim_lsp/handlers')
require('lk/plugins/nvim_lsp/mappings')

-- servers config
require('lk/plugins/nvim_lsp/servers/gopls')

local autocommands = require('lk/plugins/nvim_lsp/autocommands')
local mappings = require('lk/plugins/nvim_lsp/mappings')

-- lsp kind symbols
require('vim.lsp.protocol').CompletionItemKind = {
  ' [Text]', -- Text
  ' [Method]', -- Method
  'ƒ [Function]', -- Function
  '  [Constructor]', -- Constructor
  '識 [Field]', -- Field
  ' [Variable]', -- Variable
  '\u{f0e8} [Class]', -- Class
  'ﰮ [Interface]', -- Interface
  ' [Module]', -- Module
  ' [Property]', -- Property
  ' [Unit]', -- Unit
  ' [Value]', -- Value
  '了 [Enum]', -- Enum
  ' [Keyword]', -- Keyword
  '﬌ [Snippet]', -- Snippet
  ' [Color]', -- Color
  ' [File]', -- File
  '渚 [Reference]', -- Reference
  ' [Folder]', -- Folder
  ' [Enum]', -- Enum
  ' [Constant]', -- Constant
  ' [Struct]', -- Struct
  '鬒 [Event]', -- Event
  '\u{03a8} [Operator]', -- Operator
  ' [Type Parameter]', -- TypeParameter
}

function Tagfunc(pattern, flags)
  if flags ~= 'c' then
    return vim.NIL
  end
  local params = vim.lsp.util.make_position_params()
  local client_id_to_results, err = vim.lsp.buf_request_sync(0,
                                                             'textDocument/definition',
                                                             params, 500)
  assert(not err, vim.inspect(err))

  local results = {}
  for _, lsp_results in ipairs(client_id_to_results) do
    for _, location in ipairs(lsp_results.result or {}) do
      local start = location.range.start
      table.insert(results, {
        name = pattern,
        filename = vim.uri_to_fname(location.uri),
        cmd = string.format('call cursor(%d, %d)', start.line + 1,
                            start.character + 1),
      })
    end
  end
  return results
end

-- keymaps
local function on_attach(client, bufnr)
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
  autocommands.setup_autocommands(client)
  mappings.setup_mappings(client, bufnr)

  client.resolved_capabilities.document_formatting = false
  if client.resolved_capabilities.goto_definition then
    vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.Tagfunc')
  end
  require('lsp-status').on_attach(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { 'documentation', 'detail', 'additionalTextEdits' },
}

local servers = {
  cssls = true,
  gopls = true,
  bashls = true,
  jsonls = true,
  tsserver = true,
  vimls = true,
  pyright = true,
  sumneko_lua = function()
    local lua_dev = require('lua-dev')
    return lua_dev.setup {
      lspconfig = {
        settings = {
          Lua = {
            diagnostics = {
              globals = {
                'vim',
                'describe',
                'it',
                'before_each',
                'after_each',
                'pending',
                'teardown',
                'packer_plugins',
              },
            },
            completion = { keywordSnippet = 'Replace', callSnippet = 'Replace' },
          },
        },
      },
    }
  end,

}

local function get_server_config(server)
  local cmp_nvim_lsp = require('cmp_nvim_lsp')
  local status_capabilities = require('lsp-status').capabilities
  local conf = servers[server.name]
  local conf_type = type(conf)
  local config = conf_type == 'table' and conf or conf_type == 'function' and
                     conf() or {}
  config.flags = { debounce_text_changes = 500 }
  config.on_attach = on_attach
  config.capabilities = config.capabilities or
                            vim.lsp.protocol.make_client_capabilities()
  cmp_nvim_lsp.update_capabilities(config.capabilities)
  config.capabilities = lk_utils.deep_merge(status_capabilities,
                                            config.capabilities)
  return config
end

local function set_servers()
  local lsp_installer = require 'nvim-lsp-installer'
  lsp_installer.on_server_ready(function(server)
    server:setup(get_server_config(server))
    vim.cmd [[ do User LspAttachBuffers ]]
  end)
end

set_servers()
