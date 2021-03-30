vim.lsp.set_log_level('debug')

USER = vim.fn.expand('$USER')

local lsp_config = require('lspconfig')
local lsp_status = require('lsp-status')
local map = lk_utils.map
local telescope_mapper = require('lk.plugins.telescope.mappings')
require('lk.plugins.nvim_lsp.handlers')
require('lk.plugins.nvim_lsp.commands')

-- lsp kind symbols
require('vim.lsp.protocol').CompletionItemKind =
    {
      ' [Text]', -- Text
      ' [Method]', -- Method
      'ƒ [Function]', -- Function
      ' [Constructor]', -- Constructor
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

-- }}}

local custom_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local custom_attach = function(client)
  local opts = { noremap = false, silent = true }
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

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

  if client.resolved_capabilities.goto_definition then
    map('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  end
  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    map('n', 'gff', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  elseif client.resolved_capabilities.document_range_formatting then
    map('n', 'gfr', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
        [[
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false
    )
  end
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities.textDocument.codeLens = { dynamicRegistration = false }
updated_capabilities = vim.tbl_extend(
                           'keep', updated_capabilities, lsp_status.capabilities
                       )

-- lua lsp
local system_name
if vim.fn.has('mac') == 1 then
  system_name = 'macOS'
elseif vim.fn.has('unix') == 1 then
  system_name = 'Linux'
elseif vim.fn.has('win32') == 1 then
  system_name = 'Windows'
else
  print('Unsupported system for sumneko')
end

local sumneko_root_path = '/home/' .. USER .. '/data/Github/lua-language-server'
local sumneko_binary = sumneko_root_path .. '/bin/' .. system_name ..
                           '/lua-language-server'

lsp_config.sumneko_lua.setup(
    {
      cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
      on_attach = custom_attach,
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
          diagnostics = {
            globals = {
              'vim',
              'describe',
              'it',
              'before_each',
              'after_each',
              'awesome',
              'theme',
              'client'
            }
          },
          workspace = {
            library = {
              [vim.fn.expand('$VIMRUNTIME/lua')] = true,
              [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
            },
            maxPreload = 1000,
            preloadFileSize = 1000
          }
        }
      }
    }
)

-- yaml
lsp_config.yamlls.setup { on_init = custom_init, on_attach = custom_attach }

-- python
lsp_config.pyls.setup {
  plugins = { pyls_mypy = { enabled = true, live_mode = false } },
  on_init = custom_init,
  on_attach = custom_attach
}

lsp_config.vimls.setup { on_init = custom_init, on_attach = custom_attach }

lsp_config.gopls.setup {
  on_init = custom_init,
  on_attach = custom_attach,
  capabilities = updated_capabilities,
  settings = { gopls = { codelenses = { test = true } } }
}

lsp_config.gdscript.setup { on_init = custom_init, on_attach = custom_attach }

lsp_config.tsserver.setup(
    {
      cmd = { 'typescript-language-server', '--stdio' },
      filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx'
      },
      on_init = custom_init,
      on_attach = custom_attach
    }
)

lsp_config.clangd.setup(
    {
      filetypes = { 'c', 'cpp' },
      cmd = {
        'clangd',
        '--background-index',
        '--suggest-missing-includes',
        '--clang-tidy',
        '--header-insertion=iwyu'
      },
      on_init = custom_init,
      on_attach = custom_attach,

      -- Required for lsp-status
      init_options = { clangdFileStatus = true },
      handlers = lsp_status.extensions.clangd.setup(),
      capabilities = lsp_status.capabilities
    }
)

lsp_config.cmake.setup { on_init = custom_init, on_attach = custom_attach }

lsp_config.rust_analyzer.setup(
    {
      cmd = { 'rust-analyzer' },
      filetypes = { 'rust' },
      on_init = custom_init,
      on_attach = custom_attach
    }
)

lsp_config.diagnosticls.setup {
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
