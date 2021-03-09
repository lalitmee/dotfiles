" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-c-m> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif


" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [e <Plug>(coc-diagnostic-prev)
nmap <silent> ]e <Plug>(coc-diagnostic-next)

" " GoTo code navigation.
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> ge :CocCommand fzf-preview.CocCurrentDiagnostics<CR>
nmap <silent> gl :CocCommand fzf-preview.CocDiagnostics<CR>
nmap <silent> gi :CocCommand fzf-preview.CocImplementations<CR>
nmap <silent> gr :CocCommand fzf-preview.CocReferences<CR>
nmap <silent> gy :CocCommand fzf-preview.CocTypeDefinitions<CR>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction


" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)



" coc-snippets settings
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   coc-git                             "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " navigate chunks of current buffer
" nmap [g <Plug>(coc-git-prevchunk)
" nmap ]g <Plug>(coc-git-nextchunk)
" " navigate conflicts of current buffer
" nmap [c <Plug>(coc-git-prevconflict)
" nmap ]c <Plug>(coc-git-nextconflict)
" " show chunk diff at current position
" nmap gi <Plug>(coc-git-chunkinfo)
" " show commit contains current position
" " nmap gC <Plug>(coc-git-commit)
" " create text object for git chunks
" omap ig <Plug>(coc-git-chunk-inner)
" xmap ig <Plug>(coc-git-chunk-inner)
" omap ag <Plug>(coc-git-chunk-outer)
" xmap ag <Plug>(coc-git-chunk-outer)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   smartf                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " press <esc> to cancel.
" nmap f <Plug>(coc-smartf-forward)
" nmap F <Plug>(coc-smartf-backward)
" nmap ; <Plug>(coc-smartf-repeat)
" nmap , <Plug>(coc-smartf-repeat-opposite)

" augroup Smartf
"   autocmd User SmartfEnter :hi Conceal ctermfg=220 guifg=#6638F0
"   autocmd User SmartfLeave :hi Conceal ctermfg=239 guifg=#504945
" augroup end

" Keymapping for grep word under cursor with interactive mode
nnoremap <silent> <leader>cG :exe 'CocList -I --input='.expand('<cword>').' grep'<CR>

" grep current word in current buffer
nnoremap <silent> <leader>cg  :exe 'CocList -I --normal --input='.expand('<cword>').' words'<CR>
