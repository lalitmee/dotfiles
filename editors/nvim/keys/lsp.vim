" scroll down hover doc or scroll in definition preview
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
" scroll up hover doc
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>


" nnoremap <silent> gd :Telescope lsp_definitions<CR>
" nnoremap <silent> gr :Telescope lsp_references<CR>
" nnoremap <silent> gw :Telescope lsp_document_symbols<CR>
" nnoremap <silent> gwl :Telescope lsp_workspace_symbols<CR>
" nnoremap <silent> ge :Telescope lsp_document_diagnostics<CR>
" nnoremap <silent> gE :Telescope lsp_workspace_diagnostics<CR>

" nnoremap <silent> gd  :LspDefinition<CR>
" nnoremap <silent> gr  :LspReferences<CR>
" nnoremap <silent> gwl :LspWorkspaceSymbols<CR>
" nnoremap <silent> gw  :LspDocumentSymbols<CR>
" nnoremap <silent> ge  :LspGetAllDiagnostics<CR>
" nnoremap <silent> gE  :Telescope lsp_workspace_diagnostics<CR>

inoremap <silent><expr> <C-n>     compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-c>     compe#close('<C-e>')
inoremap <silent><expr> <C-n>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-p>     compe#scroll({ 'delta': -4 })

" nmap <silent> <leader>c/ <Plug>(Luadev-RunLine)
vmap <silent> <leader>c/ <Plug>(Luadev-Run)

command! LspAddToWorkspaceFolder   lua require 'lsp-wrapper'.add_to_workspace_folder()
command! LspClearReferences        lua require 'lsp-wrapper'.clear_references()
command! LspCodeActions            lua require 'lsp-wrapper'.code_action()
command! LspDeclaration            lua require 'lsp-wrapper'.declaration()
command! LspDefinition             lua require 'lsp-wrapper'.definition()
command! LspDocumentSymbols        lua require 'lsp-wrapper'.document_symbol()
command! LspFormatting             lua require 'lsp-wrapper'.formatting()
command! LspFormattingSync         lua require 'lsp-wrapper'.formatting_sync()
command! LspGetAllDiagnostics      lua require 'lsp-wrapper'.get_all_diagnostics()
command! LspGetNextDiagnostic      lua require 'lsp-wrapper'.get_next_diagnostic()
command! LspGetPrevDiagnostic      lua require 'lsp-wrapper'.get_prev_diagnostic()
command! LspGotoNextDiagnostic     lua require 'lsp-wrapper'.goto_next_diagnostic()
command! LspGotoPrevDiagnostic     lua require 'lsp-wrapper'.goto_prev_diagnostic()
command! LspHover                  lua require 'lsp-wrapper'.hover()
command! LspImplementation         lua require 'lsp-wrapper'.implementation()
command! LspIncomingCalls          lua require 'lsp-wrapper'.incoming_calls()
command! LspListWorkspaceFolders   lua require 'lsp-wrapper'.list_workspace_folders()
command! LspOutGoingCalls          lua require 'lsp-wrapper'.outgoing_calls()
command! LspRangeCodeActions       lua require 'lsp-wrapper'.range_code_action()
command! LspRangeFormatting        lua require 'lsp-wrapper'.range_formatting()
command! LspReferences             lua require 'lsp-wrapper'.references()
command! LspRemoveWorkspaceFolder  lua require 'lsp-wrapper'.remove_workspace_folder()
command! LspRename                 lua require 'lsp-wrapper'.rename()
command! LspSetDiagnosticsLocList  lua require 'lsp-wrapper'.set_diagnostics_loclist()
command! LspShowLineDiagnostics    lua require 'lsp-wrapper'.show_line_diagnostics()
command! LspSignatureHelp          lua require 'lsp-wrapper'.signature_help()
command! LspTypeDefinition         lua require 'lsp-wrapper'.type_definition()
command! LspWorkspaceSymbols       lua require 'lsp-wrapper'.workspace_symbol()

" func! LspLocationList()
"  lua vim.lsp.diagnostic.set_loclist({open_loclist = false})
" endfun

" augroup set_buffer_diagnostics_to_loc_list
"     autocmd!
"     autocmd! BufWrite,BufEnter,InsertLeave * :call LspLocationList()
" augroup END


