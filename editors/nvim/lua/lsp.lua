local lsp = require('lspconfig')
local completion = require('completion')
local buf_map = require('utils').buf_map
local buf_option = require('utils').buf_option

local on_attach = function(client)
  completion.on_attach(client)
  -- buf_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end

  local options = {
    noremap = true,
    silent = true
  }

  -- vim.api.nvim_set_keymap('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', options)
  -- vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', options)
  -- vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', options)
  -- vim.api.nvim_set_keymap('n', '1gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', options)
  -- vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', options)
  -- vim.api.nvim_set_keymap('n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', options)
  -- vim.api.nvim_set_keymap('n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', options)
  -- vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', options)

  -- vim.api.nvim_command([[setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
  -- vim.api.nvim_command([[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({ show_header = false })]])

  -- copied from https://github.com/lucastrvsn/dot/blob/master/.config/nvim/lua/lsp/on_attach.lua
  -- buf_map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  -- buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- buf_map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_map('n', '<leader>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_map('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_map('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- buf_map('n', '<space>se', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- buf_map('n', '<leader>ed', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ show_header = false })<CR>', opts)
  -- buf_map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  -- buf_map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  -- buf_map('n', '<leader>eq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  -- buf_map('i', '<Tab>', 'pumvisible() ? "<C-n>" : "<Tab>"', { expr = true, noremap = true })
  -- buf_map('i', '<S-Tab>', 'pumvisible() ? "<C-p>" : "<S-Tab>"', { expr = true, noremap = true })

  -- if client.resolved_capabilities.document_formatting then
  --   vim.api.nvim_command [[augroup Format]]
  --   vim.api.nvim_command [[autocmd! * <buffer>]]
  --   vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)]]
  --   vim.api.nvim_command [[augroup END]]
  -- end
end

-- bash
lsp.bashls.setup({
  on_attach = on_attach
})

-- css
lsp.cssls.setup({
  on_attach = on_attach
})

-- general diagnostic server
lsp.diagnosticls.setup({
  on_attach = on_attach,
  filetypes={
    'markdown',
    'javascript',
    'typescript',
    'javascriptreact',
    'typescriptreact',
    'css',
    'scss',
    'sass'
  },
  init_options = {
    linters = {
      eslint = {
        command = './node_modules/.bin/eslint',
        rootPatterns = { '.git' },
        debounce = 100,
        args = {
          '--stdin',
          '--stdin-filename',
          '%filepath',
          '--format',
          'json'
        },
        sourceName = 'eslint',
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '${message} [${ruleId}]',
          security = 'severity'
        },
        securities = {
          [2] = 'error',
          [1] = 'warning',
        },
      },
      stylelint = {
        command = './node_modules/.bin/stylelint',
        rootPatterns = { '.git' },
        debounce = 100,
        args = {
          '--formatter',
          'json',
          '--stdin-filename',
          '%filepath'
        },
        sourceName = 'stylelint',
        parseJson = {
          errorsRoot = '[0].warnings',
          line = 'line',
          column = 'column',
          message = '${text}',
          security = 'severity'
        },
        securities = {
          error = 'error',
          warning = 'warning'
        }
      },
      markdownlint = {
        command = 'markdownlint',
        isStderr = true,
        debounce = 100,
        args = { '--stdin' },
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = 'markdownlint',
        formatLines = 1,
        formatPattern = {
          '^.*?:\\s+(\\d+):\\s+(.*)(\\r|\\n)*$',
          {
            line = 1,
            column = -1,
            message = 2
          }
        }
      }
    },
    filetypes = {
      markdown = 'markdownlint',
      javascript = 'eslint',
      typescript = 'eslint',
      javascriptreact = 'eslint',
      typescriptreact = 'eslint',
      css = 'stylelint',
      scss = 'stylelint',
      sass = 'stylelint'
    },
    formatters = {
      prettier = {
        command = './node_modules/.bin/prettier',
        args = {
          '--stdin-filepath',
          '%filepath',
          '--single-quote',
          '--print-width 120'
        }
      }
    },
    formatFiletypes = {
      javascript = 'prettier',
      typescript = 'prettier',
      javascriptreact = 'prettier',
      typescriptreact = 'prettier'
    },
  }
})

-- html
lsp.html.setup({
  on_attach = on_attach
})

-- json
lsp.jsonls.setup({
  on_attach = on_attach
})

-- rust
lsp.rust_analyzer.setup({
  on_attach = on_attach
})

-- lua
lsp.sumneko_lua.setup({
  on_attach = on_attach
})

-- typescript
lsp.tsserver.setup({
  on_attach = on_attach
})

-- vim
lsp.vimls.setup({
  on_attach = on_attach
})

