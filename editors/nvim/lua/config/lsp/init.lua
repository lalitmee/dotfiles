require('config.lsp.handlers')

local nvim_lsp = require('lspconfig')
local nvim_status = require('lsp-status')

local telescope_mapper = require('config.telescope.mappings')

local codelens_capabilities = vim.lsp.protocol.make_client_capabilities()

codelens_capabilities.textDocument.codeLens = {
  dynamicRegistration = false,
}

local mapper = function(mode, key, result)
  vim.api.nvim_buf_set_keymap(0, mode, key, "<cmd>lua " .. result .. "<CR>", {noremap = true, silent = true})
end

-- custom_attach
local custom_attach = function(client)
  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

  if client.config.flags then
    -- It doesn't seem like clang likes this very much.
    if filetype ~= 'c' then
      client.config.flags.allow_incremental_sync = true
    end
  end

  mapper('n',  'gen', vim.lsp.diagnostic.goto_next({buffer = 0}))
  mapper('n', 'gep', vim.lsp.diagnostic.goto_prev({buffer = 0}))
  mapper('n', 'gel', vim.lsp.diagnostic.show_line_diagnostics({buffer = 0}))
  mapper('n', 'gd', vim.lsp.buf.definition({buffer = 0}))
  mapper('n', 'gD', vim.lsp.buf.declaration({buffer = 0}))
  mapper('n', 'grn', 'MyLspRename()')

  telescope_mapper('grr', 'lsp_references', {
    layout_strategy = "vertical",
    sorting_strategy = "ascending",
    prompt_position = "top",
    ignore_filename = true,
  }, true)
  -- TODO: I don't like these combos
  telescope_mapper('gls', 'lsp_document_symbols', { ignore_filename = true }, true)
  telescope_mapper('glw', 'lsp_workspace_symbols', { ignore_filename = true }, true)
  telescope_mapper('gca', 'lsp_code_actions', nil, true)

  if filetype ~= 'lua' then
    mapper('n', 'K', 'vim.lsp.buf.hover()')
  end

  mapper('i', 'gh', 'vim.lsp.buf.signature_help()')
  -- mapper('n', '<space>rr', 'vim.lsp.stop_client(vim.lsp.get_active_clients()); vim.cmd [[e]]')

  -- Rust is currently the only thing w/ inlay hints
  if filetype == 'rust' then
    vim.cmd(
      [[autocmd BufEnter,BufWritePost <buffer> :lua require('lsp_extensions.inlay_hints').request { ]]
        .. [[aligned = true, prefix = " » " ]]
      .. [[} ]]
    )
  end

  if vim.tbl_contains({"go", "rust"}, filetype) then
    vim.cmd [[autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync()]]
  end

  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
end

nvim_lsp.sumneko_lua.setup({
  -- An example of settings for an LSP server.
  --    For more options, see nvim-lspconfig
  -- settings = {
  --   Lua = {
  --     diagnostics = {
  --       enable = true,
  --       globals = { "vim" },
  --     },
  --   }
  -- },
  cmd = {"lua-language-server"},
  on_attach = on_attach
})

nvim_lsp.tsserver.setup({
  cmd = {"typescript-language-server", "--stdio"},
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx"
  },
  on_attach = on_attach
})

nvim_lsp.clangd.setup({
  cmd = {
    "clangd",
    "--background-index",
    "--suggest-missing-includes",
    "--clang-tidy",
    "--header-insertion=iwyu",
  },
  on_attach = on_attach,

  -- Required for lsp-status
  init_options = {
    clangdFileStatus = true
  },
  handlers = nvim_status.extensions.clangd.setup(),
  capabilities = nvim_status.capabilities,
})

if 1 == vim.fn.executable('cmake-language-server') then
  nvim_lsp.cmake.setup {
    on_attach = on_attach,
  }
end

nvim_lsp.rust_analyzer.setup({
  cmd = {"rust-analyzer"},
  filetypes = {"rust"},
  on_attach = on_attach,
})

nvim_lsp.vimls.setup({
  cmd = {"vim-language-server"},
  filetypes = {"vim"},
  on_attach = on_attach,
})


nvim_lsp.gopls.setup {
  on_attach = custom_attach,

  capabilities = codelens_capabilities,

  settings = {
    gopls = {
      codelenses = { test = true },
    }
  }
}

