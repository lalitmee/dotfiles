set completeopt=menuone,noinsert,noselect

nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gi :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gsh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> grr :lua vim.lsp.buf.references()<CR>
nnoremap <silent> grn :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gh :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gca :lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gsd :lua vim.lsp.util.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR>
nnoremap <silent> gn :lua vim.lsp.diagnostic.goto_next()<CR>

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" lua << EOF
" local on_attach = require'completion'.on_attach
" require'lspconfig'.tsserver.setup{ on_attach=on_attach }

" require'lspconfig'.clangd.setup {
"     on_attach = on_attach,
"     root_dir = function() return vim.loop.cwd() end
" }

" require'lspconfig'.sumneko_lua.setup{ on_attach=on_attach }
" require'lspconfig'.pyls.setup{ on_attach=on_attach }
" require'lspconfig'.gopls.setup{ on_attach=on_attach }
" require'lspconfig'.rust_analyzer.setup{ on_attach=on_attach }
" EOF
