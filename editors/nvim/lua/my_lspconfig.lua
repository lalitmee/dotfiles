local on_attach_vim = function(client)
  require'completion'.on_attach(client)
  require'diagnostic'.on_attach(client)
end

-- javascript and typescript
require'lspconfig'.tsserver.setup{on_attach=on_attach_vim}

-- vim lsp
require'lspconfig'.vimls.setup{on_attach=on_attach_vim}

-- yaml
require'lspconfig'.yamlls.setup{on_attach=on_attach_vim}

-- python
require'lspconfig'.pyls.setup{on_attach=on_attach_vim}

-- json
require'lspconfig'.jsonls.setup{on_attach=on_attach_vim}

-- html
require'lspconfig'.html.setup{on_attach=on_attach_vim}

-- Go
require'lspconfig'.gopls.setup{on_attach=on_attach_vim}

-- Docker
require'lspconfig'.dockerls.setup{on_attach=on_attach_vim}

-- diagnostics
require'lspconfig'.diagnosticls.setup{on_attach=on_attach_vim}

-- css
require'lspconfig'.cssls.setup{on_attach=on_attach_vim}

-- clangd
require'lspconfig'.clangd.setup{on_attach=on_attach_vim}

-- bash
require'lspconfig'.bashls.setup{on_attach=on_attach_vim}

-- angular
require'lspconfig'.angularls.setup{on_attach=on_attach_vim}
