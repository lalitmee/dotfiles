let g:coc_global_extensions = [
    \ 'coc-actions',
    \ 'coc-alternate-files',
    \ 'coc-angular',
    \ 'coc-bootstrap-classname',
    \ 'coc-browser',
    \ 'coc-css',
    \ 'coc-css-block-comments',
    \ 'coc-cssmodules',
    \ 'coc-diagnostic',
    \ 'coc-docker',
    \ 'coc-emmet',
    \ 'coc-emoji',
    \ 'coc-eslint',
    \ 'coc-floaterm',
    \ 'coc-format-json',
    \ 'coc-fs-lists',
    \ 'coc-gist',
    \ 'coc-git',
    \ 'coc-go',
    \ 'coc-grammarly',
    \ 'coc-highlight',
    \ 'coc-html',
    \ 'coc-html-css-support',
    \ 'coc-htmlhint',
    \ 'coc-import-cost',
    \ 'coc-jira-cplt',
    \ 'coc-json',
    \ 'coc-lines',
    \ 'coc-lists',
    \ 'coc-lit-html',
    \ 'coc-lua',
    \ 'coc-markdownlint',
    \ 'coc-marketplace',
    \ 'coc-pairs',
    \ 'coc-prettier',
    \ 'coc-project',
    \ 'coc-pyright',
    \ 'coc-python',
    \ 'coc-react-refactor',
    \ 'coc-rust-analyzer',
    \ 'coc-sh',
    \ 'coc-snippets',
    \ 'coc-svg',
    \ 'coc-syntax',
    \ 'coc-tabnine',
    \ 'coc-tag',
    \ 'coc-terminal',
    \ 'coc-translator',
    \ 'coc-tsserver',
    \ 'coc-ultisnips',
    \ 'coc-vimlsp',
    \ 'coc-xml',
    \ 'coc-yaml',
    \ 'coc-yank',
    \ 'coc-zi',
    \ ]

" Prettier command for coc-prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Better display for messages
set cmdheight=2

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   coc-list                                    "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" grep word under cursor
command! -nargs=+ -complete=custom,s:GrepArgs Rg exe 'CocList grep '.<q-args>

function! s:GrepArgs(...)
  let list = ['-S', '-smartcase', '-i', '-ignorecase', '-w', '-word',
        \ '-e', '-regex', '-u', '-skip-vcs-ignores', '-t', '-extension']
  return join(list, "\n")
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   coc-fzf                                    "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:coc_fzf_opts = ['--layout=reverse', '--inline-info']
let g:coc_fzf_preview = "right:60%"
