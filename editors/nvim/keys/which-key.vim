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
nnoremap <leader>/ :CocSearch <C-R>=expand("<cword>")<CR><CR>
let g:which_key_map['/'] = 'search-word'

nnoremap <leader>* *<c-o>:%s///gn<cr>
let g:which_key_map['*'] = 'count-matches'

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
let g:which_key_map[','] = [ 'w'                       , 'save' ]
let g:which_key_map['.'] = [ ':e $MYVIMRC'             , 'open-init' ]
let g:which_key_map[';'] = [ ':Telescope commands'     , 'commands' ]
let g:which_key_map['r'] = [ ':RnvimrToggle'           , 'ranger' ]
let g:which_key_map['x'] = [ 'q'                       , 'quit' ]
let g:which_key_map['z'] = [ 'Goyo'                    , 'zen' ]

 " Group mappings

" a is for actions
let g:which_key_map.a = {
      \ 'name' : '+actions'                            ,
      \ 'c' : [':ColorizerToggle'                      , 'colorizer'],
      \ 'e' : [':CocCommand explorer'                  , 'explorer'],
      \ 'f' : [':NvimTreeFindFile'                     , 'nvim-tree-find-file'],
      \ 'l' : [':Bracey'                               , 'start-live-server'],
      \ 'L' : [':BraceyStop'                           , 'stop-live-server'],
      \ 'm' : [':MarkdownPreview'                      , 'markdown-preview'],
      \ 'M' : [':MarkdownPreviewStop'                  , 'markdown-preview-stop'],
      \ 'n' : [':NvimTreeToggle'                       , 'nvim-tree-exlporer'],
      \ 'r' : [':NvimTreeRefresh'                      , 'nvim-tree-refresh'],
      \ 't' : [':FloatermToggle'                       , 'terminal'],
      \ 'w' : [':StripWhitespace'                      , 'strip-whitespace'],
      \ }

" b is for buffer
let g:which_key_map.b = {
      \ 'name' : '+buffers'                            ,
      \ 'b' : [':FzfBuffers'                           , 'fzf-buffers'],
      \ 'B' : [':Telescope buffers'                    , 'telescope-buffers'],
      \ 'c' : ['vnew'                                  , 'new-empty-buffer-vert'],
      \ 'd' : [':Bdelete'                              , 'delete-buffer'],
      \ 'D' : [':%bd'                                  , 'delete-all-buffers'],
      \ 'f' : ['bfirst'                                , 'first-buffer'],
      \ 'h' : ['Startify'                              , 'home-buffer'],
      \ 'l' : [':Telescope current_buffer_fuzzy_find'  , 'search-buffer-lines'],
      \ 'n' : [':BufferNext'                           , 'next-buffer'],
      \ 'N' : [':BufferMoveNext'                       , 'move-next-buffer'],
      \ 'p' : [':BufferPrevious'                       , 'previous-buffer'],
      \ 'P' : [':BufferMovePrevious'                   , 'move-previous-buffer'],
      \ 's' : ['new'                                   , 'new-empty-buffer'],
      \ 'o' : [':BufferOrderByDirectory'               , 'order-by-direcoty'],
      \ 'O' : [':BufferOrderByLanguage'                , 'order-by-language'],
      \ 'e' : [':BufferLast'                           , 'last-buffer'],
      \ }

" c is for coc.nvim
let g:which_key_map.c = {
      \ 'name' : '+coc'                                ,
      \ 'a' : [':CocAction'                            , 'action'],
      \ 'c' : [':CocCommand'                           , 'commands'],
      \ 'd' : [':CocDiagnostics'                       , 'diagnostics'],
      \ 'e' : [':CocConfig'                            , 'config'],
      \ 'f' : [':CocFix'                               , 'fix'],
      \ 'i' : [':CocInfo'                              , 'info'],
      \ 'r' : [':CocListResume '                       , 'list-resume'],
      \ 's' : [':CocSearch'                            , 'search'],
      \ 'x' : ['<Plug>(coc-convert-snippet)'           , 'covert-to-snippet'],
      \ }

" c.l is for CocList
let g:which_key_map.c.l = {
      \ 'name' : '+list'                               ,
      \ 'b' : [':CocList branches'                     , 'branches-list'],
      \ 'c' : [':CocList commands'                     , 'commands-list'],
      \ 'd' : [':CocList folders'                      , 'workspace-directories-list'],
      \ 'e' : [':CocList diagnostics'                  , 'diagnostics-list'],
      \ 'E' : [':CocList extensions'                   , 'extensions-list'],
      \ 'l' : [':CocList fuzzy_lines'                  , 'buffer-fuzzy-lines'],
      \ 'L' : [':CocList links'                        , 'buffer-links-list'],
      \ 'm' : [':CocList marketplace'                  , 'marketplace'],
      \ 's' : [':CocList outline'                      , 'buffer-symbols-list'],
      \ 'S' : [':CocList symbols'                      , 'workspace-symbols-list'],
      \ 't' : [':CocList floaterm'                     , 'floaterm-list'],
      \ 'w' : [':CocList words'                        , 'buffer-words-list'],
      \ }

let g:which_key_map.e = {
      \ 'name' : '+errors/warnings'                    ,
      \ 'l' : ['CocDiagnostics'                        , 'list-errors/warnings'],
      \ 'n' : ['<Plug>(coc-diagnostic-next)'           , 'next-diagnostic'],
      \ 'N' : ['<Plug>(coc-diagnostic-next-error)'     , 'next-error'],
      \ 'p' : ['<Plug>(coc-diagnostic-prev)'           , 'prev-diagnostic'],
      \ 'P' : ['<Plug>(coc-diagnostic-prev-error)'     , 'prev-error'],
      \ }

" f is for telescope
let g:which_key_map.f = {
      \ 'name' : '+telescope/files'                    ,
      \ 'a' : [':Telescope spell_suggest'              , 'spelling-suggestions'],
      \ 'L' : [':Telescope live_grep'                  , 'search-current-directory'],
      \ 's' : [':w'                                    , 'save-buffer'],
      \ 'S' : [':wa'                                   , 'save-all-buffers'],
      \ 'u' : [':Telescope grep_string'                , 'search-under-cursor'],
      \ 'w' : [':Telescope loclist'                    , 'items-current-window-location'],
      \ }

" ff is for files
let g:which_key_map.f.f = {
      \ 'name' : '+files'                              ,
      \ 'f' : [':Telescope find_files'                 , 'current-directory-files'],
      \ 'g' : [':Telescope git_files'                  , 'current-directory-git-files'],
      \ 'r' : [':Telescope oldfiles'                   , 'search-previous-files'],
      \ }

" fb is for buffers
let g:which_key_map.f.b = {
      \ 'name' : '+buffers'                            ,
      \ 'b' : [':Telescope buffers'                    , 'search-buffers'],
      \ 'f' : [':Telescope current_buffer_fuzzy_find'  , 'buffer-fuzzy-search'],
      \ 't' : [':Telescope current_buffer_tags'        , 'buffer-tags-fuzzy-search'],
      \ }

" fg is for git
let g:which_key_map.f.g = {
      \ 'name' : '+git'                                ,
      \ 'b' : [':Telescope git_branches'               , 'project-branches'],
      \ 'c' : [':Telescope git_commits'                , 'project-commits'],
      \ 'C' : [':Telescope git_bcommits'               , 'buffer-commits'],
      \ 's' : [':Telescope git_status'                 , 'git-status'],
      \ }

" fl is for lists
let g:which_key_map.f.l = {
      \ 'name' : '+lists'                              ,
      \ 'b' : [':Telescope builtin'                    , 'builtins'],
      \ 'p' : [':Telescope planets'                    , 'planets'],
      \ 'r' : [':Telescope reloader'                   , 'reloaders'],
      \ 's' : [':Telescope symbols'                    , 'symbols'],
      \ }

" fv is for vim
let g:which_key_map.f.v = {
      \ 'name' : '+vim'                                ,
      \ 'a' : [':Telescope autocommands'               , 'autocommands'],
      \ 'c' : [':Telescope commands'                   , 'commands'],
      \ 'C' : [':Telescope command_history'            , 'commands-history'],
      \ 'f' : [':Telescope filetypes'                  , 'filetypes'],
      \ 'h' : [':Telescope help_tags'                  , 'help-tags'],
      \ 'H' : [':Telescope highlights'                 , 'highlights'],
      \ 'k' : [':Telescope keymaps'                    , 'keymaps'],
      \ 'm' : [':Telescope man_pages'                  , 'man-pages'],
      \ 'M' : [':Telescope marks'                      , 'marks'],
      \ 'r' : [':Telescope registers'                  , 'vim-registers'],
      \ 's' : [':Telescope colorscheme'                , 'colorschemes'],
      \ 'v' : [':Telescope vim_options'                , 'vim-options'],
      \ }

" F is for find and replace
let g:which_key_map.F = {
      \ 'name' : '+find/replace'                       ,
      \ 'b' : [':Farr --source=vimgrep'                , 'buffer'],
      \ 'p' : [':Farr --source=rgnvim'                 , 'project'],
      \ }

" g is for git
let g:which_key_map.g = {
      \ 'name' : '+git'                                ,
      \ 'a' : [':Git add .'                            , 'add-all'],
      \ 'A' : [':Git add %'                            , 'add-current'],
      \ 'b' : [':GBrowse'                              , 'browse'],
      \ 'B' : [':Git blame'                            , 'blame'],
      \ 'C' : [':Git commit'                           , 'commit'],
      \ 'c' : [':Telescope git_branches'               , 'checkout'],
      \ 'd' : [':Git diff'                             , 'diff'],
      \ 'D' : [':Gdiffsplit'                           , 'diff-split'],
      \ 'g' : [':GGrep'                                , 'git-grep'],
      \ 'G' : [':Gstatus'                              , 'status'],
      \ 'h' : [':GitGutterLineHighlightsToggle'        , 'highlight-hunks'],
      \ 'H' : ['<Plug>(GitGutterPreviewHunk)'          , 'preview-hunk'],
      \ 'i' : [':Gist -b'                              , 'post-gist'],
      \ 'j' : ['<Plug>(GitGutterNextHunk)'             , 'next-hunk'],
      \ 'k' : ['<Plug>(GitGutterPrevHunk)'             , 'prev-hunk'],
      \ 'l' : [':Git log'                              , 'log'],
      \ 'm' : [':Magit'                                , 'magit'],
      \ 'M' : ['<Plug>(git-messenger)'                 , 'git-messenger'],
      \ 'p' : [':Git push'                             , 'push'],
      \ 'P' : [':Git pull'                             , 'pull'],
      \ 'r' : [':Telescope gh pull_request'            , 'list-pull-requests'],
      \ 'R' : [':GRemove'                              , 'remove'],
      \ 's' : [':Magit'                                , 'status'],
      \ 'S' : ['<Plug>(GitGutterStageHunk)'            , 'stage-hunk'],
      \ 't' : [':GitGutterSignsToggle'                 , 'toggle-signs'],
      \ 'u' : ['<Plug>(GitGutterUndoHunk)'             , 'undo-hunk'],
      \ 'v' : [':GV'                                   , 'view-commits'],
      \ 'V' : [':GV!'                                  , 'view-buffer-commits'],
      \ }

" G is goneovim
let g:which_key_map.G = {
      \ 'name' : '+goneovim'                           ,
      \ 'a' : [':GonvimFuzzyAg'                        , 'fuzzy-ag'],
      \ 'b' : [':GonvimFuzzyBuffers'                   , 'fuzzy-buffers'],
      \ 'f' : [':GonvimFuzzyFiles'                     , 'fuzzy-files'],
      \ 'F' : [':GonvimFilerOpen'                      , 'external-file-explorer'],
      \ 'l' : [':GonvimFuzzyBLines'                    , 'fuzzy-buffer-lines'],
      \ 'm' : [':GonvimMarkdown'                       , 'markdown-preview'],
      \ 'M' : [':GonvimMiniMap'                        , 'toggle-minimap'],
      \ 'n' : [':GonvimWorkspaceNext'                  , 'next-workspace'],
      \ 'N' : [':GonvimWorkspaceNew'                   , 'create-new-workspace'],
      \ 'p' : [':GonvimWorkspacePrevious'              , 'previous-workspace'],
      \ 'r' : [':GonvimFuzzyResume'                    , 'resume-previous-search'],
      \ 's' : [':GonvimWorkspaceSwitch '               , 'switch-workspace'],
      \ }

" m is major mode
let g:which_key_map.m = {
      \ 'name' : '+major-mode'                         ,
      \ 'a' : [':Telescope lsp_code_actions'           , 'code-actions'],
      \ 'A' : [':Telescope lsp_range_code_actions'     , 'range-code-actions'],
      \ 'c' : [':MakeTags'                             , 'make-ctags'],
      \ 'f' : [':Telescope lsp_references'             , 'references'],
      \ 'l' : ['<Plug>(JsConsoleLog)'                  , 'console-log'],
      \ 'r' : ['<Plug>(coc-rename)'                    , 'rename-symbol'],
      \ 's' : [':Telescope lsp_document_symbols'       , 'buffer-symbols'],
      \ 'S' : [':Telescope lsp_workspace_symbols'      , 'workspace-symbols'],
      \ }

" n is Neovim
let g:which_key_map.n = {
      \ 'name' : '+neovim'                             ,
      \ 'c' : [':PlugClean'                            , 'clean-packages'],
      \ 'e' : [':e $MYVIMRC'                           , 'edit-config'],
      \ 'i' : [':PlugInstall'                          , 'install-packages'],
      \ 'r' : [':so $MYVIMRC'                          , 'source-config'],
      \ 's' : [':PlugSnapshot'                         , 'plug-snapshot'],
      \ 'u' : [':PlugUpdate'                           , 'update-packages'],
      \ 'U' : [':PlugUpgrade'                          , 'upgrade-plug'],
      \ }

" p is for Project
let g:which_key_map.p = {
      \ 'name' : '+project'                            ,
      \ 'b' : [':Telescope buffers'                    , 'find-buffers'],
      \ 'f' : [':Telescope find_files'                 , 'find-files'],
      \ 'g' : [':Telescope git_files'                  , 'find-git-files'],
      \ 'p' : [':CocList project'                      , 'switch-project'],
      \ 's' : [':Telescope live_grep'                  , 'project-search'],
      \ }

" s is for search
let g:which_key_map.s = {
      \ 'name' : '+search'                             ,
      \ '/' : [':Telescope command_history'            , 'history'],
      \ ';' : [':Telescope commands'                   , 'commands'],
      \ 'a' : [':FzfAg'                                , 'text-Ag'],
      \ 'b' : [':Telescope current_buffer_fuzzy_find'  , 'current-buffer'],
      \ 'B' : [':Telescope buffers'                    , 'open-buffers'],
      \ 'c' : [':Telescope git_commits'                , 'commits'],
      \ 'C' : [':Telescope git_bcommits'               , 'buffer-commits'],
      \ 'f' : [':Telescope find_files'                 , 'files'],
      \ 'g' : [':Telescope git_files'                  , 'git-files'],
      \ 'G' : [':FzfGFiles?'                           , 'modified-git-files'],
      \ 'h' : [':Telescope help_tags'                  , 'file-history'],
      \ 'H' : [':FzfHistory:'                          , 'command-history'],
      \ 'l' : [':FzfLines'                             , 'lines'],
      \ 'm' : [':Telescope marks'                      , 'marks'],
      \ 'M' : [':FzfMaps'                              , 'normal-maps'],
      \ 'p' : [':Telescope live_grep'                  , 'project-live-grep'],
      \ 'P' : [':FzfTags'                              , 'project-tags'],
      \ 'r' : [':Telescope registers'                  , 'registers'],
      \ 's' : [':FzfSnippets'                          , 'snippets'],
      \ 'S' : [':Telescope colorscheme'                , 'color-schemes'],
      \ 't' : [':Rg'                                   , 'text-Rg'],
      \ 'T' : [':FzfBTags'                             , 'buffer-tags'],
      \ 'v' : [':Telescope vim_options'                , 'vim-options'],
      \ 'w' : [':FzfWindows'                           , 'search-windows'],
      \ 'y' : [':Telescope filetypes'                  , 'file-types'],
      \ 'z' : [':FZF'                                  , 'FZF'],
      \ }

let g:which_key_map.S = {
      \ 'name' : '+session'                            ,
      \ 'c' : [':SClose'                               , 'close-session'],
      \ 'd' : [':SDelete'                              , 'delete-session'],
      \ 'l' : [':SLoad'                                , 'load-session'],
      \ 's' : [':Startify'                             , 'start-page'],
      \ 'S' : [':SSave'                                , 'save-session'],
      \ }


" l is for language server protocol
let g:which_key_map.l = {
      \ 'name' : '+lsp'                                ,
      \ '.' : [':CocConfig'                            , 'config'],
      \ ';' : ['<Plug>(coc-refactor)'                  , 'refactor'],
      \ 'a' : ['<Plug>(coc-codeaction)'                , 'line-action'],
      \ 'A' : ['<Plug>(coc-codeaction-selected)'       , 'selected-action'],
      \ 'b' : [':CocNext'                              , 'next-action'],
      \ 'B' : [':CocPrev'                              , 'prev-action'],
      \ 'c' : [':CocList commands'                     , 'commands'],
      \ 'd' : ['<Plug>(coc-definition)'                , 'definition'],
      \ 'D' : ['<Plug>(coc-declaration)'               , 'declaration'],
      \ 'e' : [':CocList extensions'                   , 'extensions'],
      \ 'f' : ['<Plug>(coc-format-selected)'           , 'format-selected'],
      \ 'F' : ['<Plug>(coc-format)'                    , 'format'],
      \ 'h' : ['<Plug>(coc-float-hide)'                , 'hide'],
      \ 'i' : ['<Plug>(coc-implementation)'            , 'implementation'],
      \ 'I' : [':CocList diagnostics'                  , 'diagnostics'],
      \ 'j' : ['<Plug>(coc-float-jump)'                , 'float-jump'],
      \ 'l' : ['<Plug>(coc-codelens-action)'           , 'code-lens'],
      \ 'n' : ['<Plug>(coc-diagnostic-next)'           , 'next-diagnostic'],
      \ 'N' : ['<Plug>(coc-diagnostic-next-error)'     , 'next-error'],
      \ 'o' : [':Vista!!'                              , 'outline'],
      \ 'O' : [':CocList outline'                      , 'outline'],
      \ 'p' : ['<Plug>(coc-diagnostic-prev)'           , 'prev-diagnostic'],
      \ 'P' : ['<Plug>(coc-diagnostic-prev-error)'     , 'prev-error'],
      \ 'q' : ['<Plug>(coc-fix-current)'               , 'quickfix'],
      \ 'r' : ['<Plug>(coc-references)'                , 'references'],
      \ 'R' : ['<Plug>(coc-rename)'                    , 'rename'],
      \ 's' : [':CocList -I symbols'                   , 'references'],
      \ 'S' : [':CocList snippets'                     , 'snippets'],
      \ 't' : ['<Plug>(coc-type-definition)'           , 'type-definition'],
      \ 'u' : [':CocListResume'                        , 'resume-list'],
      \ 'U' : [':CocUpdate'                            , 'update-CoC'],
      \ 'z' : [':CocDisable'                           , 'disable-CoC'],
      \ 'Z' : [':CocEnable'                            , 'enable-CoC'],
      \ }
      " \ 'o' : ['<Plug>(coc-openlink)'                , 'open link'],

" t is for floaterm
let g:which_key_map.t = {
      \ 'name' : '+terminal'                           ,
      \ ';' : [':FloatermNew'                          , 'terminal'],
      \ 'a' : [':set scrolloff=999'                    , 'scrolloff'],
      \ 'd' : [':FloatermNew lazydocker'               , 'docker'],
      \ 'f' : [':FloatermNew fzf'                      , 'fzf'],
      \ 'g' : [':FloatermNew lazygit'                  , 'git'],
      \ 'h' : [':sp | te'                              , 'horizontal-split-terminal'],
      \ 'n' : [':FloatermNew node'                     , 'node'],
      \ 'p' : [':FloatermNew python'                   , 'python'],
      \ 'r' : [':FloatermNew ranger'                   , 'ranger'],
      \ 's' : [':FloatermNew ncdu'                     , 'ncdu'],
      \ 't' : [':FloatermToggle'                       , 'toggle'],
      \ 'v' : [':vs | te'                              , 'vertical-split-terminal'],
      \ 'y' : [':FloatermNew btm'                      , 'ytop'],
      \ }

" T is for tabline
let g:which_key_map.T = {
      \ 'name' : '+tabline'                            ,
      \ 'b' : [':XTabListBuffers'                      , 'list-buffers'],
      \ 'd' : [':XTabCloseBuffer'                      , 'close-buffer'],
      \ 'D' : [':XTabDeleteTab'                        , 'close-tab'],
      \ 'h' : [':XTabHideBuffer'                       , 'hide-buffer'],
      \ 'i' : [':XTabInfo'                             , 'info'],
      \ 'l' : [':XTabLock'                             , 'lock-tab'],
      \ 'm' : [':XTabMode'                             , 'toggle-mode'],
      \ 'n' : [':tabNext'                              , 'next-tab'],
      \ 'N' : [':XTabMoveBufferNext'                   , 'buffer->'],
      \ 't' : [':tabnew'                               , 'new-tab'],
      \ 'p' : [':tabprevious'                          , 'prev-tab'],
      \ 'P' : [':XTabMoveBufferPrev'                   , '<-buffer'],
      \ 'x' : [':XTabPinBuffer'                        , 'pin-buffer'],
      \ }

" u is for UI and toggle
let g:which_key_map.u = {
      \ 'name' : '+ui/toggle'                          ,
      \ 'e' : [':CocCommand clock.enable'              , 'show-clock'],
      \ 'd' : [':CocCommand clock.disable'             , 'hide-clock'],
      \ 'u' : [':UndotreeToggle'                       , 'undo-tree'],
      \ }

" w is for windows
let g:which_key_map.w = {
      \ 'name' : '+windows'                            ,
      \ '2' : ['<C-W>v'                                , 'layout-double-columns'],
      \ ';' : ['<C-W>L'                                , 'move-window-far-right'],
      \ '=' : ['<C-W>='                                , 'balance-windows'],
      \ '?' : [':FzfWindows'                           , 'fzf-window'],
      \ 'a' : ['<C-W>H'                                , 'move-window-far-left'],
      \ 'd' : ['<C-W>c'                                , 'delete-window'],
      \ 'h' : ['<C-W>h'                                , 'window-left'],
      \ 'H' : ['<C-W>5<'                               , 'expand-window-left'],
      \ 'i' : ['<C-W>K'                                , 'move-window-far-top'],
      \ 'j' : ['<C-W>j'                                , 'window-below'],
      \ 'J' : [':resize +5'                            , 'expand-window-below'],
      \ 'k' : ['<C-W>k'                                , 'window-up'],
      \ 'K' : [':resize  5'                            , 'expand-window-up'],
      \ 'l' : ['<C-W>l'                                , 'window-right'],
      \ 'L' : ['<C-W>5>'                               , 'expand-window-right'],
      \ 'm' : [':MaximizerToggle'                      , 'maximize-windows'],
      \ 'n' : ['<C-W>J'                                , 'move-window-far-down'],
      \ 's' : ['<C-W>s'                                , 'split-window-below'],
      \ 'v' : ['<C-W>v'                                , 'split-window-right'],
      \ 'u' : ['<C-W>x'                                , 'swap-window-next'],
      \ 'x' : ['call WindowSwap#EasyWindowSwap()'      , 'mark-window-for-swap'],
      \ 'y' : ['call WindowSwap#MarkWindowSwap()'      , 'mark-window-for-swap'],
      \ 'z' : ['call WindowSwap#DoWindowSwap()'        , 'do-window-swap'],
      \ }

" q is for quit
let g:which_key_map.q = {
      \ 'name' : '+quit-vim'                           ,
      \ 'q' : [':qall'                                 , 'quit-vim'],
      \ }

" Register which key map
call which_key#register('<Space>', "g:which_key_map")
