require('lk/plugins/nvim_lsp/handlers')
require('lk/plugins/nvim_lsp/commands')
require('lk/plugins/nvim_lsp/mappings')
require('lk/plugins/nvim_lsp/diagnostics')
-- require('lk/plugins/nvim_lsp/highlights')

local autocommands = require('lk/plugins/nvim_lsp/autocommands')
local mappings = require('lk/plugins/nvim_lsp/mappings')

-- lsp kind symbols
require('vim.lsp.protocol').CompletionItemKind =
    {
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
  require('aerial').on_attach(client)
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
  autocommands.setup_autocommands(client)
  mappings.setup_mappings(client, bufnr)

  client.resolved_capabilities.document_formatting = false
  if client.resolved_capabilities.goto_definition then
    vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.Tagfunc')
  end
  require('lsp-status').on_attach(client)
  -- require("lk/plugins/nvim_lsp/formatting").setup(client, bufnr)

  -- TypeScript specific stuff
  if client.name == 'typescript' or client.name == 'tsserver' then
    require('lk/plugins/nvim_lsp/servers/ts-utils').setup(client)
  end
end

-- Configure lua language server for neovim development
local luadev = require('lua-dev').setup({})

-- lsp-install
local function setup_servers()
  require('lspinstall').setup()

  -- get all installed servers
  local servers = require('lspinstall').installed_servers()
  local status_capabilities = require('lsp-status').capabilities
  for _, server in pairs(servers) do
    local config = servers[server] or {}
    config.on_attach = on_attach
    if not config.capabilities then
      config.capabilities = vim.lsp.protocol.make_client_capabilities()
    end
    config.capabilities.textDocument.completion.completionItem.snippetSupport =
        true
    config.capabilities = lk_utils.deep_merge(config.capabilities,
                                              status_capabilities)

    -- language specific config
    if server == 'lua' then
      config = luadev
    end
    if server == 'efm' then
      config = vim.tbl_extend('force', config,
                              require('lk/plugins/nvim_lsp/servers/efm'))
    end
    -- if server == 'diagnosticls' then
    --   config = vim.tbl_extend('force', config, require(
    --                               'lk/plugins/nvim_lsp/servers/diagnosticls'))
    -- end
    if server == 'sourcekit' then
      config.filetypes = { 'swift', 'objective-c', 'objective-cpp' }; -- we don't want c and cpp!
    end
    if server == 'clangd' then
      config.filetypes = { 'c', 'cpp' }; -- we don't want objective-c and objective-cpp!
    end
    require('lspconfig')[server].setup(config)
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require('lspinstall').post_install_hook =
    function()
      setup_servers() -- reload installed servers
      vim.cmd('bufdo e') -- this triggers the FileType autocmd that starts the server
    end
