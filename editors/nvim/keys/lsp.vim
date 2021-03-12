" scroll down hover doc or scroll in definition preview
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
" scroll up hover doc
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>


nnoremap <silent> gd :Telescope lsp_definitions<CR>
nnoremap <silent> gr :Telescope lsp_references<CR>
nnoremap <silent> gw :Telescope lsp_document_symbols<CR>
nnoremap <silent> gwl :Telescope lsp_workspace_symbols<CR>
nnoremap <silent> ge :Telescope lsp_document_diagnostics<CR>
nnoremap <silent> gE :Telescope lsp_workspace_diagnostics<CR>

" nnoremap <silent> gd :LspDefinition<CR>
" nnoremap <silent> gr :LspReferences<CR>
" nnoremap <silent> gwl :LspWorkspaceSymbols<CR>
" nnoremap <silent> gw :LspDocumentSymbols<CR>
" nnoremap <silent> ge :LspGetAllDiagnostics<CR>
" nnoremap <silent> gE :Telescope lsp_workspace_diagnostics<CR>

inoremap <silent><expr> <C-n>     compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-c>     compe#close('<C-e>')
inoremap <silent><expr> <C-n>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-p>     compe#scroll({ 'delta': -4 })
