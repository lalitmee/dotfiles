local map = lk_utils.map
local telescope_mapper = require('lk.plugins.telescope.mappings')
require('lk.plugins.nvim_lsp.handlers')
require('lk.plugins.nvim_lsp.commands')

require('lspkind').init({})

-- -- lsp kind symbols
-- require('vim.lsp.protocol').CompletionItemKind =
--     {
--       ' [Text]', -- Text
--       ' [Method]', -- Method
--       'ƒ [Function]', -- Function
--       '  [Constructor]', -- Constructor
--       '識 [Field]', -- Field
--       ' [Variable]', -- Variable
--       '\u{f0e8} [Class]', -- Class
--       'ﰮ [Interface]', -- Interface
--       ' [Module]', -- Module
--       ' [Property]', -- Property
--       ' [Unit]', -- Unit
--       ' [Value]', -- Value
--       '了 [Enum]', -- Enum
--       ' [Keyword]', -- Keyword
--       '﬌ [Snippet]', -- Snippet
--       ' [Color]', -- Color
--       ' [File]', -- File
--       '渚 [Reference]', -- Reference
--       ' [Folder]', -- Folder
--       ' [Enum]', -- Enum
--       ' [Constant]', -- Constant
--       ' [Struct]', -- Struct
--       '鬒 [Event]', -- Event
--       '\u{03a8} [Operator]', -- Operator
--       ' [Type Parameter]' -- TypeParameter
--     }

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
local on_attach = function(client)
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

  local opts = { noremap = false, silent = true }
  -- buf native lsp key maps
  -- map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- map('n', 'ge', '<cmd>lua vim.lsp.diagnostic.get_all()<CR>', opts)
  -- map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- map('n', 'gw', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  map('i', '<C-h>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  map('n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)

  -- diagnostics mappings
  map('n', 'geN', '<cmd>lua vim.lsp.diagnostic.get_next()<CR>', opts)
  map('n', 'geP', '<cmd>lua vim.lsp.diagnostic.get_prev()<CR>', opts)
  map('n', 'gea', '<cmd>lua vim.lsp.diagnostic.get_all()<CR>', opts)
  map(
      'n', 'gel', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
      opts
  )
  map('n', 'gen', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  map('n', 'gep', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  map('n', 'geq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- formaaing mappings
  map('n', 'gff', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  map('n', 'gfs', '<cmd>lua vim.lsp.buf.formatting_sync()<CR>', opts)

  -- workspace mappings
  map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  map('n', 'grc', '<cmd>lua vim.lsp.buf.clear_references()<CR>', opts)
  map('n', 'grn', '<cmd>lua MyLspRename()<CR>', opts)
  map('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

  -- Lspsaga mappings
  map('n', '<localleader>ma', '<cmd>Lspsaga code_action<CR>', opts)
  map('n', '<localleader>mA', '<cmd>Lspsaga range_code_action<CR>', opts)
  map('n', '<localleader>mc', '<cmd>Lspsaga close_floaterm<CR>', opts)
  map('n', '<localleader>md', '<cmd>Lspsaga lsp_finder<CR>', opts)
  map('n', '<localleader>me', '<cmd>Lspsaga show_cursor_diagnostics<CR>', opts)
  map('n', '<localleader>mh', '<cmd>Lspsaga hover_doc<CR>', opts)
  map('n', '<localleader>ml', '<cmd>Lspsaga show_line_diagnostics<CR>', opts)
  map('n', '<localleader>mn', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)
  map('n', '<localleader>mo', '<cmd>Lspsaga open_floaterm<CR>', opts)
  map('n', '<localleader>mp', '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
  map('n', '<localleader>mr', '<cmd>Lspsaga rename<CR>', opts)
  map('n', '<localleader>mv', '<cmd>Lspsaga preview_definition<CR>', opts)

  -- telescope mappings for lsp and more
  map('n', 'gW', '<cmd>Telescope lsp_workspace_symbols<CR>', opts)
  map('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
  map('n', 'gcA', '<cmd>Telescope lsp_range_code_actions<CR>', opts)
  map('n', 'gca', '<cmd>Telescope lsp_code_actions<CR>', opts)
  map('n', 'ge', '<cmd>Telescope lsp_document_diagnostics<CR>', opts)
  map('n', 'gE', '<cmd>Telescope lsp_workspace_diagnostics<CR>', opts)
  map('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  map('n', 'gw', '<cmd>Telescope lsp_document_symbols<CR>', opts)
  -- map(
  --     'n', 'gW',
  --     '<cmd>lua require("lk.plugins.telescope.lens").live_workspace_symbols()<CR>',
  --     opts
  -- )

  local telescope_opts = { prompt_position = 'top' }
  telescope_mapper('<localleader>ta', 'lsp_code_actions', telescope_opts, true)
  telescope_mapper(
      '<localleader>tA', 'lsp_range_code_actions', telescope_opts, true
  )
  telescope_mapper('<localleader>td', 'lsp_definitions', telescope_opts, true)
  telescope_mapper(
      '<localleader>te', 'lsp_document_diagnostics', telescope_opts, true
  )
  telescope_mapper(
      '<localleader>tE', 'lsp_workspace_diagnostics', telescope_opts, true
  )
  telescope_mapper('<localleader>tr', 'lsp_references', telescope_opts, true)
  telescope_mapper(
      '<localleader>tw', 'lsp_document_symbols', telescope_opts, true
  )
  telescope_mapper(
      '<localleader>tW', 'lsp_workspace_symbols', telescope_opts, true
  )
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
