local lsp_status = require('lsp-status')
lsp_status.register_progress()

require('lk/plugins/nvim_lsp/handlers')
require('lk/plugins/nvim_lsp/commands')
require('lk/plugins/nvim_lsp/mappings')
require('lk/plugins/nvim_lsp/diagnostics')
-- require('lk/plugins/nvim_lsp/highlights')

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

-- Configure lua language server for neovim development
local luadev = require('lua-dev').setup({
  lspconfig = {
    settings = {
      Lua = { workspace = { maxPreload = 2000, preloadFileSize = 1000 } },
    },
  },
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { 'documentation', 'detail', 'additionalTextEdits' },
}

-- lsp-install
local function setup_servers()
  local lsp_installer = require('nvim-lsp-installer')
  local status_capabilities = require('lsp-status').capabilities

  lsp_installer.on_server_ready(function(server)
    local opts = { on_attach = on_attach }
    if not opts.capabilities then
      opts.capabilities = capabilities
    end
    opts.capabilities.textDocument.completion.completionItem.snippetSupport =
        true
    opts.capabilities = lk_utils.deep_merge(opts.capabilities,
                                            status_capabilities)

    -- language specific config
    if server.name == 'lua' then
      opts = luadev
    end
    if server.name == 'efm' then
      opts = vim.tbl_extend('force', opts,
                            require('lk/plugins/nvim_lsp/servers/efm'))
    end
    if server.name == 'sourcekit' then
      opts.filetypes = { 'swift', 'objective-c', 'objective-cpp' }; -- we don't want c and cpp!
    end
    if server.name == 'clangd' then
      opts.filetypes = { 'c', 'cpp' }; -- we don't want objective-c and objective-cpp!
    end

    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]
  end)
end

setup_servers()
