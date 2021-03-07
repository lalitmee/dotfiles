" nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> gi :lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> gsh :lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> grr :lua vim.lsp.buf.references()<CR>
" nnoremap <silent> grn :lua vim.lsp.buf.rename()<CR>
" nnoremap <silent> gh :lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> gca :lua vim.lsp.buf.code_action()<CR>
" nnoremap <silent> gsd :lua vim.lsp.util.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR>
" nnoremap <silent> gn :lua vim.lsp.diagnostic.goto_next()<CR>


inoremap <silent><expr> <C-n> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-c>     compe#close('<C-e>')
inoremap <silent><expr> <C-n>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-p>     compe#scroll({ 'delta': -4 })
