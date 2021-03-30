require('lk.plugins.nvim_lsp.handlers')
require('lk.plugins.nvim_lsp.commands')
require('lk.plugins.nvim_lsp.mappings')

-- require('lspkind').init({})

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

-- keymaps
local on_attach = function()
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
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

-- config that activates keymaps and enables snippet support
local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    -- enable snippet support
    capabilities = capabilities,
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach
  }
end

-- lsp-install
local function setup_servers()
  require('lspinstall').setup()

  -- get all installed servers
  local servers = require('lspinstall').installed_servers()

  for _, server in pairs(servers) do
    local config = make_config()

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
