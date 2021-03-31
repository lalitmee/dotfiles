require('lk.plugins.nvim_lsp.handlers')
require('lk.plugins.nvim_lsp.commands')
require('lk.plugins.nvim_lsp.mappings')

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
      ' [Type Parameter]' -- TypeParameter
    }

-- highlights {{{
local highlight = require('lk.highlights')
local cursor_line_bg = highlight.hl_value('CursorLine', 'bg')
highlight.all {
  { 'LspReferenceText', { guibg = cursor_line_bg, gui = 'none' } },
  { 'LspReferenceRead', { guibg = cursor_line_bg, gui = 'none' } },
  { 'LspDiagnosticsSignHint', { guifg = '#fab005' } },
  { 'LspDiagnosticsDefaultHint', { guifg = '#fab005' } },
  { 'LspDiagnosticsDefaultError', { guifg = '#E06C75' } },
  { 'LspDiagnosticsDefaultWarning', { guifg = '#ff922b' } },
  { 'LspDiagnosticsDefaultInformation', { guifg = '#15aabf' } },
  {
    'LspDiagnosticsUnderlineError',
    { gui = 'undercurl', guisp = '#E06C75', guifg = 'none' }
  },
  {
    'LspDiagnosticsUnderlineHint',
    { gui = 'undercurl', guisp = '#fab005', guifg = 'none' }
  },
  {
    'LspDiagnosticsUnderlineWarning',
    { gui = 'undercurl', guisp = 'orange', guifg = 'none' }
  },
  {
    'LspDiagnosticsUnderlineInformation',
    { gui = 'undercurl', guisp = '#15aabf', guifg = 'none' }
  },
  { 'LspDiagnosticsFloatingWarning', { guibg = 'NONE' } },
  { 'LspDiagnosticsFloatingError', { guibg = 'NONE' } },
  { 'LspDiagnosticsFloatingHint', { guibg = 'NONE' } },
  { 'LspDiagnosticsFloatingInformation', { guibg = 'NONE' } }
}

-- lsp signs
vim.fn.sign_define(
    'LspDiagnosticsSignError', {
      texthl = 'LspDiagnosticsSignError',
      text = '',
      numhl = 'LspDiagnosticsSignError'
    }
)
vim.fn.sign_define(
    'LspDiagnosticsSignWarning', {
      texthl = 'LspDiagnosticsSignWarning',
      text = '',
      numhl = 'LspDiagnosticsSignWarning'
    }
)
vim.fn.sign_define(
    'LspDiagnosticsSignHint', {
      texthl = 'LspDiagnosticsSignHint',
      text = '',
      numhl = 'LspDiagnosticsSignHint'
    }
)
vim.fn.sign_define(
    'LspDiagnosticsSignInformation', {
      texthl = 'LspDiagnosticsSignInformation',
      text = '',
      numhl = 'LspDiagnosticsSignInformation'
    }
)

-- lsp autocommands
local function setup_autocommands(client)
  local autocommands = require('lk.autocommands')

  autocommands.augroup(
      'LspLocationList', {
        {
          events = { 'InsertLeave', 'BufWrite', 'BufEnter' },
          targets = { '<buffer>' },
          command = [[lua vim.lsp.diagnostic.set_loclist({open_loclist = false})]]
        }
      }
  )
  if client and client.resolved_capabilities.document_highlight then
    autocommands.augroup(
        'LspCursorCommands', {
          {
            events = { 'CursorHold' },
            targets = { '<buffer>' },
            command = 'lua vim.lsp.buf.document_highlight()'
          },
          {
            events = { 'CursorHoldI' },
            targets = { '<buffer>' },
            command = 'lua vim.lsp.buf.document_highlight()'
          },
          {
            events = { 'CursorMoved' },
            targets = { '<buffer>' },
            command = 'lua vim.lsp.buf.clear_references()'
          }
        }
    )
  end
  if client and client.resolved_capabilities.document_formatting then
    -- format on save
    autocommands.augroup(
        'LspFormat', {
          {
            events = { 'BufWritePre' },
            targets = { '<buffer>' },
            command = 'lua vim.lsp.buf.formatting_sync(nil, 1000)'
          }
        }
    )
  end
end

-- mappings
local function setup_mappings(client, bufnr)
  local nnoremap, opts = lk_utils.nnoremap, { buffer = bufnr }
  if client.resolved_capabilities.implementation then
    nnoremap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  end
  nnoremap('gI', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
end

function Tagfunc(pattern, flags)
  if flags ~= 'c' then
    return vim.NIL
  end
  local params = vim.lsp.util.make_position_params()
  local client_id_to_results, err = vim.lsp.buf_request_sync(
                                        0, 'textDocument/definition', params,
                                        500
                                    )
  assert(not err, vim.inspect(err))

  local results = {}
  for _, lsp_results in ipairs(client_id_to_results) do
    for _, location in ipairs(lsp_results.result or {}) do
      local start = location.range.start
      table.insert(
          results, {
            name = pattern,
            filename = vim.uri_to_fname(location.uri),
            cmd = string.format(
                'call cursor(%d, %d)', start.line + 1, start.character + 1
            )
          }
      )
    end
  end
  return results
end

-- keymaps
local function on_attach(client, bufnr)
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
  setup_autocommands(client)
  setup_mappings(client, bufnr)

  if client.resolved_capabilities.goto_definition then
    vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.Tagfunc')
  end
  require('lsp-status').on_attach(client)
end

-- Configure lua language server for neovim development
local lua_settings = {
  Lua = {
    runtime = {
      -- LuaJIT in the case of Neovim
      version = 'LuaJIT',
      path = vim.split(package.path, ';')
    },
    diagnostics = {
      -- Get the language server to recognize the `vim` global
      globals = { 'vim' }
    },
    workspace = {
      -- Make the server aware of Neovim runtime files
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
      }
    }
  }
}

-- diagnostic settings
local diagnostic_settings = {
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'css',
    'scss',
    'markdown',
    'pandoc'
  },
  init_options = {
    linters = {
      eslint = {
        command = 'eslint_d',
        rootPatterns = { '.git', 'package.json' },
        debounce = 100,
        args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
        sourceName = 'eslint',
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '[eslint] ${message} [${ruleId}]',
          security = 'severity'
        },
        securities = { [2] = 'error', [1] = 'warning' }
      },
      markdownlint = {
        command = 'markdownlint',
        rootPatterns = { '.git' },
        isStderr = true,
        debounce = 100,
        args = { '--stdin' },
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = 'markdownlint',
        securities = { undefined = 'hint' },
        formatLines = 1,
        formatPattern = {
          '^.*:(\\d+)\\s+(.*)$',
          { line = 1, column = -1, message = 2 }
        }
      }
    },
    filetypes = {
      javascript = 'eslint',
      javascriptreact = 'eslint',
      typescript = 'eslint',
      typescriptreact = 'eslint',
      markdown = 'markdownlint',
      pandoc = 'markdownlint'
    },
    formatters = {
      prettierEslint = {
        command = 'prettier-eslint',
        args = { '--stdin' },
        rootPatterns = { '.git' }
      },
      prettier = {
        command = 'prettier',
        args = { '--stdin-filepath', '%filename' }
      }
    },
    formatFiletypes = {
      css = 'prettier',
      javascript = 'prettierEslint',
      javascriptreact = 'prettierEslint',
      json = 'prettier',
      scss = 'prettier',
      typescript = 'prettierEslint',
      typescriptreact = 'prettierEslint'
    }
  }
}

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
    config.capabilities = lk_utils.deep_merge(
                              config.capabilities, status_capabilities
                          )

    -- language specific config
    if server == 'lua' then
      config.settings = lua_settings
    end
    if server == 'diagnosticls' then
      config = diagnostic_settings
    end
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
