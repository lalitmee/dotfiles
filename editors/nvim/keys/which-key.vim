" Leader Key Maps

" Map leader to which_key
nnoremap <silent> <leader> :silent <c-u> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>

" Create map to add keys to
let g:which_key_map =  {}
" Define a separator
let g:which_key_sep = '→'
" set timeoutlen=100

" Coc Search & refactor
" nnoremap <leader>? :CocSearch <C-R>=expand("<cword>")<CR><CR>
" let g:which_key_map['?'] = 'search word'

" Lalit Lalit

" Not a fan of floating windows for this
let g:which_key_use_floating_win = 0

" Change the colors if you want
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function

" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

" Single mappings
let g:which_key_map[','] = [ 'w'                                   , 'save' ]
let g:which_key_map['.'] = [ ':e $MYVIMRC'                         , 'open-init' ]
let g:which_key_map[';'] = [ ':FzfCommands'                        , 'commands' ]
let g:which_key_map['='] = [ '<C-W>='                              , 'balance-windows' ]
let g:which_key_map['e'] = [ ':CocCommand explorer'                , 'explorer' ]
let g:which_key_map['r'] = [ ':RnvimrToggle'                       , 'ranger' ]
let g:which_key_map['u'] = [ ':UndotreeToggle'                     , 'undo-tree']
let g:which_key_map['x'] = [ 'q'                                   , 'quit' ]
let g:which_key_map['z'] = [ 'Goyo'                                , 'zen' ]

 " Group mappings

" a is for actions
let g:which_key_map.a = {
      \ 'name' : '+actions'                                        ,
      \ 'L' : [':BraceyStop'                                       , 'stop-live-server'],
      \ 'M' : [':MarkdownPreviewStop'                              , 'markdown-preview-stop'],
      \ 'c' : [':ColorizerToggle'                                  , 'colorizer'],
      \ 'e' : [':CocCommand explorer'                              , 'explorer'],
      \ 'l' : [':Bracey'                                           , 'start-live-server'],
      \ 'm' : [':MarkdownPreview'                                  , 'markdown-preview'],
      \ 't' : [':FloatermToggle'                                   , 'terminal'],
      \ 'w' : [':StripWhitespace'                                  , 'strip-whitespace'],
      \ }

" b is for buffer
let g:which_key_map.b = {
      \ 'name' : '+buffers'                                        ,
      \ '?' : [':FzfBuffers'                                       , 'fzf-buffer'],
      \ 'L' : [':FzfBLines'                                        , 'fzf-buffer-lines'],
      \ 'd' : [':Bdelete'                                          , 'delete-buffer'],
      \ 'f' : ['bfirst'                                            , 'first-buffer'],
      \ 'h' : ['Startify'                                          , 'home-buffer'],
      \ 'l' : ['blast'                                             , 'last-buffer'],
      \ 'n' : ['bnext'                                             , 'next-buffer'],
      \ 'p' : ['bprev'                                             , 'previous-buffer'],
      \ }

" c is for coc.nvim
let g:which_key_map.c = {
      \ 'name' : '+coc'                                            ,
      \ 'a' : [':CocAction'                                        , 'action'],
      \ 'c' : [':CocCommand'                                       , 'commands'],
      \ 'd' : [':CocDiagnostics'                                   , 'diagnostics'],
      \ 'e' : [':CocConfig'                                        , 'config'],
      \ 'f' : [':CocFix'                                           , 'fix'],
      \ 'i' : [':CocInfo'                                          , 'info'],
      \ 'r' : [':CocListResume '                                   , 'list-resume'],
      \ 's' : [':CocSearch'                                        , 'search'],
      \ }

" c.l is for CocList
let g:which_key_map.c.l = {
      \ 'name' : '+list'                                           ,
      \ 'S' : [':CocList symbols'                                  , 'workspace-symbols-list'],
      \ 'b' : [':CocList branches'                                 , 'branches-list'],
      \ 'c' : [':CocList commands'                                 , 'commands-list'],
      \ 'd' : [':CocList folders'                                  , 'workspace-directories-list'],
      \ 'E' : [':CocList extensions'                               , 'extensions-list'],
      \ 'e' : [':CocList diagnostics'                              , 'diagnostics-list'],
      \ 'l' : [':CocList links'                                    , 'buffer-links-list'],
      \ 'm' : [':CocList marketplace'                              , 'marketplace'],
      \ 's' : [':CocList outline'                                  , 'buffer-symbols-list'],
      \ 't' : [':CocList floaterm'                                 , 'floaterm-list'],
      \ 'w' : [':CocList words'                                    , 'buffer-words-list'],
      \ }

let g:which_key_map.e = {
      \ 'name' : '+erros/warnings'                                 ,
      \ 'l' : ['CocList diagnostics'                               , 'list-erros/warnings'],
      \ }

" f is for find and replace
let g:which_key_map.f = {
      \ 'name' : '+files'                                          ,
      \ 's' : [':w'                                                , 'save-file'],
      \ 'd' : [':Delete'                                           , 'delete-file'],
      \ 'u' : [':Unlink'                                           , 'delete-with-open-window'],
      \ 'm' : [':Move'                                             , 'rename-file'],
      \ 'r' : [':Rename'                                           , 'relative-rename-file'],
      \ 'c' : [':Chmod'                                            , 'change-permissions-of-file'],
      \ 'n' : [':Mkdir'                                            , 'create-directory'],
      \ 'w' : [':Wall'                                             , 'save-all-open-buffers'],
      \ 'W' : [':SudoWrite'                                        , 'sudo-save'],
      \ 'E' : [':SudoEdit'                                         , 'sudo-edit'],
      \ }

" f is for find and replace
let g:which_key_map.f.f = {
      \ 'name' : '+find-files'                                     ,
      \ 'b' : [':FzfBuffers'                                       , 'find-buffers'],
      \ 'f' : [':FzfFiles'                                         , 'fzf-files'],
      \ 'g' : [':FzfGFiles'                                        , 'fzf-git-files'],
      \ 'c' : [':Cfind'                                            , 'cfind-with-quickfix'],
      \ 'd' : [':Clocate'                                          , 'clocate-with-quickfix'],
      \ 'l' : [':Lfind'                                            , 'lfind-with-location-list'],
      \ 'm' : [':Llocate'                                          , 'llocate-with-location-list'],
      \ }

" F is for find and replace
let g:which_key_map.F = {
      \ 'name' : '+find/replace'                                   ,
      \ 'b' : [':Farr --source=vimgrep'                            , 'buffer'],
      \ 'p' : [':Farr --source=rgnvim'                             , 'project'],
      \ }

" g is for git
let g:which_key_map.g = {
      \ 'name' : '+git'                                            ,
      \ 'A' : [':Git add %'                                        , 'add-current'],
      \ 'B' : [':GBrowse'                                          , 'browse'],
      \ 'C' : [':FzfGBranches'                                     , 'checkout'],
      \ 'D' : [':Gdiffsplit'                                       , 'diff-split'],
      \ 'G' : [':Gstatus'                                          , 'status'],
      \ 'H' : ['<Plug>(GitGutterPreviewHunk)'                      , 'preview-hunk'],
      \ 'P' : [':Git pull'                                         , 'pull'],
      \ 'S' : [':!git status'                                      , 'status'],
      \ 'V' : [':GV!'                                              , 'view-buffer-commits'],
      \ 'a' : [':Git add .'                                        , 'add-all'],
      \ 'b' : [':Git blame'                                        , 'blame'],
      \ 'c' : [':Git commit'                                       , 'commit'],
      \ 'd' : [':Git diff'                                         , 'diff'],
      \ 'g' : [':GGrep'                                            , 'git-grep'],
      \ 'h' : [':GitGutterLineHighlightsToggle'                    , 'highlight-hunks'],
      \ 'i' : [':Gist -b'                                          , 'post-gist'],
      \ 'j' : ['<Plug>(GitGutterNextHunk)'                         , 'next-hunk'],
      \ 'k' : ['<Plug>(GitGutterPrevHunk)'                         , 'prev-hunk'],
      \ 'l' : [':Git log'                                          , 'log'],
      \ 'm' : [':Magit'                                            , 'magit'],
      \ 'M' : ['<Plug>(git-messenger)'                             , 'git-messenger'],
      \ 'p' : [':Git push'                                         , 'push'],
      \ 'r' : [':GRemove'                                          , 'remove'],
      \ 's' : ['<Plug>(GitGutterStageHunk)'                        , 'stage-hunk'],
      \ 't' : [':GitGutterSignsToggle'                             , 'toggle-signs'],
      \ 'u' : ['<Plug>(GitGutterUndoHunk)'                         , 'undo-hunk'],
      \ 'v' : [':GV'                                               , 'view-commits'],
      \ }

" G is goneovim
let g:which_key_map.G = {
      \ 'name' : '+goneovim'                                       ,
      \ 'f' : [':GonvimFuzzyFiles'                                 , 'fuzzy-files'],
      \ 'l' : [':GonvimFuzzyBLines'                                , 'fuzzy-buffer-lines'],
      \ 'a' : [':GonvimFuzzyAg'                                    , 'fuzzy-ag'],
      \ 'b' : [':GonvimFuzzyBuffers'                               , 'fuzzy-buffers'],
      \ 'r' : [':GonvimFuzzyResume'                                , 'resume-previous-search'],
      \ 'N' : [':GonvimWorkspaceNew'                               , 'create-new-workspace'],
      \ 'n' : [':GonvimWorkspaceNext'                              , 'next-workspace'],
      \ 'p' : [':GonvimWorkspacePrevious'                          , 'previous-workspace'],
      \ 's' : [':GonvimWorkspaceSwitch '                           , 'switch-workspace'],
      \ 'm' : [':GonvimMarkdown'                                   , 'markdown-preview'],
      \ 'F' : [':GonvimFilerOpen'                                  , 'external-file-explorer'],
      \ 'M' : [':GonvimMiniMap'                                    , 'toggle-minimap'],
      \ }

" m is major mode
let g:which_key_map.m = {
      \ 'name' : '+major-mode'                                     ,
      \ 'r' : ['<Plug>(coc-rename)'                                , 'rename-symbol'],
      \ 'l' : ['<Plug>(JsConsoleLog)'                              , 'console-log'],
      \ }

" n is Neovim
let g:which_key_map.n = {
      \ 'name' : '+neovim'                                         ,
      \ 'U' : [':PlugUpgrade'                                      , 'upgrade-plug'],
      \ 'c' : [':PlugClean'                                        , 'clean-packages'],
      \ 'e' : [':e $MYVIMRC'                                       , 'edit-config'],
      \ 'i' : [':PlugInstall'                                      , 'install-packages'],
      \ 'r' : [':so $MYVIMRC'                                      , 'source-config'],
      \ 's' : [':PlugSnapshot'                                     , 'plug-snapshot'],
      \ 'u' : [':PlugUpdate'                                       , 'update-packages'],
      \ }

" p is for Project
let g:which_key_map.p = {
      \ 'name' : '+project'                                        ,
      \ 'b' : [':FzfBuffers'                                       , 'find-buffers'],
      \ 'f' : [':FzfFiles'                                         , 'find-files'],
      \ 'g' : [':FzfGFiles'                                        , 'find-git-files'],
      \ 'l' : [':FzfLines'                                         , 'find-lines'],
      \ 'G' : [':lua require"telescope.builtin".git_files{}'       , 'find-lines'],
      \ 'F' : [':lua require"telescope.builtin".find_files{}'      , 'find-lines'],
      \ 'R' : [':lua require"telescope.builtin".lsp_references{}'  , 'find-lines'],
      \ }

" s is for search
let g:which_key_map.s = {
      \ 'name' : '+search'                                         ,
      \ '/' : [':FzfHistory/'                                      , 'history'],
      \ ';' : [':FzfCommands'                                      , 'commands'],
      \ 'B' : [':FzfBuffers'                                       , 'open-buffers'],
      \ 'C' : [':FzfBCommits'                                      , 'buffer-commits'],
      \ 'G' : [':FzfGFiles?'                                       , 'modified-git-files'],
      \ 'H' : [':FzfHistory:'                                      , 'command-history'],
      \ 'M' : [':FzfMaps'                                          , 'normal-maps'],
      \ 'P' : [':FzfTags'                                          , 'project-tags'],
      \ 'S' : [':FzfColors'                                        , 'color-schemes'],
      \ 'T' : [':FzfBTags'                                         , 'buffer-tags'],
      \ 'a' : [':FzfAg'                                            , 'text-Ag'],
      \ 'b' : [':FzfBLines'                                        , 'current-buffer'],
      \ 'c' : [':FzfCommits'                                       , 'commits'],
      \ 'f' : [':FzfFiles'                                         , 'files'],
      \ 'g' : [':FzfGFiles'                                        , 'git-files'],
      \ 'h' : [':FzfHistory'                                       , 'file-history'],
      \ 'l' : [':FzfLines'                                         , 'lines'],
      \ 'm' : [':FzfMarks'                                         , 'marks'],
      \ 'p' : [':FzfHelptags'                                      , 'help-tags'],
      \ 's' : [':CocList snippets'                                 , 'snippets'],
      \ 't' : [':FzfRg'                                            , 'text-Rg'],
      \ 'w' : [':FzfWindows'                                       , 'search-windows'],
      \ 'y' : [':FzfFiletypes'                                     , 'file-types'],
      \ 'z' : [':FZF'                                              , 'FZF'],
      \ }
      " \ 's' : [':Snippets'                                       , 'snippets'],

let g:which_key_map.S = {
      \ 'name' : '+session'                                        ,
      \ 'c' : [':SClose'                                           , 'close-session'],
      \ 'd' : [':SDelete'                                          , 'delete-session'],
      \ 'l' : [':SLoad'                                            , 'load-session'],
      \ 's' : [':Startify'                                         , 'start-page'],
      \ 'S' : [':SSave'                                            , 'save-session'],
      \ }


" l is for language server protocol
let g:which_key_map.l = {
      \ 'name' : '+lsp'                                            ,
      \ '.' : [':CocConfig'                                        , 'config'],
      \ ';' : ['<Plug>(coc-refactor)'                              , 'refactor'],
      \ 'a' : ['<Plug>(coc-codeaction)'                            , 'line-action'],
      \ 'A' : ['<Plug>(coc-codeaction-selected)'                   , 'selected-action'],
      \ 'b' : [':CocNext'                                          , 'next-action'],
      \ 'B' : [':CocPrev'                                          , 'prev-action'],
      \ 'c' : [':CocList commands'                                 , 'commands'],
      \ 'd' : ['<Plug>(coc-definition)'                            , 'definition'],
      \ 'D' : ['<Plug>(coc-declaration)'                           , 'declaration'],
      \ 'e' : [':CocList extensions'                               , 'extensions'],
      \ 'f' : ['<Plug>(coc-format-selected)'                       , 'format-selected'],
      \ 'F' : ['<Plug>(coc-format)'                                , 'format'],
      \ 'h' : ['<Plug>(coc-float-hide)'                            , 'hide'],
      \ 'i' : ['<Plug>(coc-implementation)'                        , 'implementation'],
      \ 'I' : [':CocList diagnostics'                              , 'diagnostics'],
      \ 'j' : ['<Plug>(coc-float-jump)'                            , 'float-jump'],
      \ 'l' : ['<Plug>(coc-codelens-action)'                       , 'code-lens'],
      \ 'n' : ['<Plug>(coc-diagnostic-next)'                       , 'next-diagnostic'],
      \ 'N' : ['<Plug>(coc-diagnostic-next-error)'                 , 'next-error'],
      \ 'o' : [':Vista!!'                                          , 'outline'],
      \ 'O' : [':CocList outline'                                  , 'outline'],
      \ 'p' : ['<Plug>(coc-diagnostic-prev)'                       , 'prev-diagnostic'],
      \ 'P' : ['<Plug>(coc-diagnostic-prev-error)'                 , 'prev-error'],
      \ 'q' : ['<Plug>(coc-fix-current)'                           , 'quickfix'],
      \ 'r' : ['<Plug>(coc-references)'                            , 'references'],
      \ 'R' : ['<Plug>(coc-rename)'                                , 'rename'],
      \ 's' : [':CocList -I symbols'                               , 'references'],
      \ 'S' : [':CocList snippets'                                 , 'snippets'],
      \ 't' : ['<Plug>(coc-type-definition)'                       , 'type-definition'],
      \ 'u' : [':CocListResume'                                    , 'resume-list'],
      \ 'U' : [':CocUpdate'                                        , 'update-CoC'],
      \ 'z' : [':CocDisable'                                       , 'disable-CoC'],
      \ 'Z' : [':CocEnable'                                        , 'enable-CoC'],
      \ }
      " \ 'o' : ['<Plug>(coc-openlink)'                            , 'open link'],

" t is for floaterm
let g:which_key_map.t = {
      \ 'name' : '+terminal'                                       ,
      \ ';' : [':FloatermNew --wintype=popup --height=6'           , 'terminal'],
      \ 'f' : [':FloatermNew fzf'                                  , 'fzf'],
      \ 'g' : [':FloatermNew lazygit'                              , 'git'],
      \ 'd' : [':FloatermNew lazydocker'                           , 'docker'],
      \ 'n' : [':FloatermNew node'                                 , 'node'],
      \ 'p' : [':FloatermNew python'                               , 'python'],
      \ 'r' : [':FloatermNew ranger'                               , 'ranger'],
      \ 't' : [':FloatermToggle'                                   , 'toggle'],
      \ 'y' : [':FloatermNew btm'                                  , 'ytop'],
      \ 's' : [':FloatermNew ncdu'                                 , 'ncdu'],
      \ }

" T is for tabline
let g:which_key_map.T = {
      \ 'name' : '+tabline'                                        ,
      \ 'b' : [':XTabListBuffers'                                  , 'list-buffers'],
      \ 'd' : [':XTabCloseBuffer'                                  , 'close-buffer'],
      \ 'D' : [':XTabDeleteTab'                                    , 'close-tab'],
      \ 'h' : [':XTabHideBuffer'                                   , 'hide-buffer'],
      \ 'i' : [':XTabInfo'                                         , 'info'],
      \ 'l' : [':XTabLock'                                         , 'lock-tab'],
      \ 'm' : [':XTabMode'                                         , 'toggle-mode'],
      \ 'n' : [':tabNext'                                          , 'next-tab'],
      \ 'N' : [':XTabMoveBufferNext'                               , 'buffer->'],
      \ 't' : [':tabnew'                                           , 'new-tab'],
      \ 'p' : [':tabprevious'                                      , 'prev-tab'],
      \ 'P' : [':XTabMoveBufferPrev'                               , '<-buffer'],
      \ 'x' : [':XTabPinBuffer'                                    , 'pin-buffer'],
      \ }

" w is for windows
let g:which_key_map.w = {
      \ 'name' : '+windows'                                        ,
      \ 'w' : ['<C-W>w'                                            , 'other-window'],
      \ 'd' : ['<C-W>c'                                            , 'delete-window'],
      \ ' ' : ['<C-W>s'                                            , 'split-window-below'],
      \ '\' : ['<C-W>v'                                            , 'split-window-right'],
      \ '2' : ['<C-W>v'                                            , 'layout-double-columns'],
      \ 'h' : ['<C-W>h'                                            , 'window-left'],
      \ 'j' : ['<C-W>j'                                            , 'window-below'],
      \ 'l' : ['<C-W>l'                                            , 'window-right'],
      \ 'k' : ['<C-W>k'                                            , 'window-up'],
      \ 'H' : ['<C-W>5<'                                           , 'expand-window-left'],
      \ 'J' : [':resize +5'                                        , 'expand-window-below'],
      \ 'L' : ['<C-W>5>'                                           , 'expand-window-right'],
      \ 'K' : [':resize  5'                                        , 'expand-window-up'],
      \ '=' : ['<C-W>='                                            , 'balance-window'],
      \ '?' : [':FzfWindows'                                       , 'fzf-window'],
      \ }

" Register which key map
call which_key#register('<Space>', "g:which_key_map")
