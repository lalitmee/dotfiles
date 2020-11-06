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
let g:which_key_map[','] = [ 'w'                                , 'save' ]
let g:which_key_map['.'] = [ ':e $MYVIMRC'                      , 'open-init' ]
let g:which_key_map[';'] = [ ':FzfCommands'                     , 'commands' ]
let g:which_key_map['='] = [ ':<C-W>='                          , 'balance-windows' ]
let g:which_key_map['r'] = [ ':RnvimrToggle'                    , 'ranger' ]
let g:which_key_map['x'] = [ 'q'                                , 'quit' ]
let g:which_key_map['z'] = [ 'Goyo'                             , 'zen' ]

 " Group mappings

" a is for actions
let g:which_key_map.a = {
      \ 'name' : '+actions'                                     ,
      \ 'c' : [':ColorizerToggle'                               , 'colorizer'],
      \ 'e' : [':CocCommand explorer'                           , 'explorer'],
      \ 'f' : [':CocCommand explorer --preset floating'         , 'floating-explorer'],
      \ 'l' : [':Bracey'                                        , 'start-live-server'],
      \ 'L' : [':BraceyStop'                                    , 'stop-live-server'],
      \ 'm' : [':MarkdownPreview'                               , 'markdown-preview'],
      \ 'M' : [':MarkdownPreviewStop'                           , 'markdown-preview-stop'],
      \ 't' : [':FloatermToggle'                                , 'terminal'],
      \ 'w' : [':StripWhitespace'                               , 'strip-whitespace'],
      \ }

" b is for buffer
let g:which_key_map.b = {
      \ 'name' : '+buffers'                                     ,
      \ 'b' : [':FzfBuffers'                                    , 'fzf-buffer'],
      \ 'd' : [':Bdelete'                                       , 'delete-buffer'],
      \ 'f' : ['bfirst'                                         , 'first-buffer'],
      \ 'h' : ['Startify'                                       , 'home-buffer'],
      \ 'l' : [':FzfBLines'                                     , 'fzf-buffer-lines'],
      \ 'n' : ['vnew'                                           , 'new-empty-buffer-vert'],
      \ 's' : ['new'                                            , 'new-empty-buffer'],
      \ }

" c is for coc.nvim
let g:which_key_map.c = {
      \ 'name' : '+coc'                                         ,
      \ 'a' : [':CocAction'                                     , 'action'],
      \ 'c' : [':CocCommand'                                    , 'commands'],
      \ 'd' : [':CocDiagnostics'                                , 'diagnostics'],
      \ 'e' : [':CocConfig'                                     , 'config'],
      \ 'f' : [':CocFix'                                        , 'fix'],
      \ 'i' : [':CocInfo'                                       , 'info'],
      \ 'r' : [':CocListResume '                                , 'list-resume'],
      \ 's' : [':CocSearch'                                     , 'search'],
      \ 'x' : ['<Plug>(coc-convert-snippet)'                    , 'covert-to-snippet'],
      \ }

" c.l is for CocList
let g:which_key_map.c.l = {
      \ 'name' : '+list'                                        ,
      \ 'b' : [':CocList branches'                              , 'branches-list'],
      \ 'c' : [':CocList commands'                              , 'commands-list'],
      \ 'd' : [':CocList folders'                               , 'workspace-directories-list'],
      \ 'e' : [':CocList diagnostics'                           , 'diagnostics-list'],
      \ 'E' : [':CocList extensions'                            , 'extensions-list'],
      \ 'l' : [':CocList fuzzy_lines'                           , 'buffer-fuzzy-lines'],
      \ 'L' : [':CocList links'                                 , 'buffer-links-list'],
      \ 'm' : [':CocList marketplace'                           , 'marketplace'],
      \ 's' : [':CocList outline'                               , 'buffer-symbols-list'],
      \ 'S' : [':CocList symbols'                               , 'workspace-symbols-list'],
      \ 't' : [':CocList floaterm'                              , 'floaterm-list'],
      \ 'w' : [':CocList words'                                 , 'buffer-words-list'],
      \ }

let g:which_key_map.e = {
      \ 'name' : '+errors/warnings'                             ,
      \ 'l' : ['CocDiagnostics'                                 , 'list-errors/warnings'],
      \ 'n' : ['<Plug>(coc-diagnostic-next)'                    , 'next-diagnostic'],
      \ 'N' : ['<Plug>(coc-diagnostic-next-error)'              , 'next-error'],
      \ 'p' : ['<Plug>(coc-diagnostic-prev)'                    , 'prev-diagnostic'],
      \ 'P' : ['<Plug>(coc-diagnostic-prev-error)'              , 'prev-error'],
      \ }

 " f is for fzf-preview
let g:which_key_map.f = {
      \ 'name' : '+fzf-preview'                                 ,
      \ ';' : [':FzfPreviewFromResources'                       , 'files-from-resource'],
      \ 'a' : [':FzfPreviewGitActions'                          , 'git-actions-list'],
      \ 'b' : [':FzfPreviewAllBuffers'                          , 'all-buffers'],
      \ 'B' : [':FzfPreviewBuffers'                             , 'file-buffers'],
      \ 'c' : [':FzfPreviewChanges'                             , 'changes-list'],
      \ 'C' : [':FzfPreviewBookmarks'                           , 'bookmarks-list'],
      \ 'd' : [':FzfPreviewDirectoryFiles'                      , 'directory-files'],
      \ 'D' : [':CocCommand fzf-preview.CocTypeDefinitions'     , 'coc-type-definitions'],
      \ 'e' : [':CocCommand fzf-preview.CocDiagnostics'         , 'coc-diagnostics'],
      \ 'f' : [':FzfPreviewProjectFiles'                        , 'project-files'],
      \ 'E' : [':CocCommand fzf-preview.CocCurrentDiagnostics'  , 'coc-current-diagnostics'],
      \ 'g' : [':FzfPreviewGitFiles'                            , 'git-files'],
      \ 'G' : [':FzfPreviewGitStatus'                           , 'git-status-list'],
      \ 'h' : [':FzfPreviewCommandPalette'                      , 'nvim-commands-list'],
      \ 'j' : [':FzfPreviewJumps'                               , 'jumps-list'],
      \ 'J' : [':FzfPreviewLocationList'                        , 'locations-list'],
      \ 'l' : [':FzfPreviewBufferLines'                         , 'loaded-buffer-lines'],
      \ 'L' : [':FzfPreviewLines'                               , 'current-buffer-lines'],
      \ 'm' : [':FzfPreviewMarks'                               , 'marks-list'],
      \ 'o' : [':FzfPreviewProjectOldFiles'                     , 'project-old-files'],
      \ 'O' : [':FzfPreviewOldFiles'                            , 'fzf-old-files'],
      \ 'p' : [':FzfPreviewBlamePR'                             , 'blame-PR'],
      \ 'q' : [':FzfPreviewQuickFix'                            , 'quickfix-list'],
      \ 'r' : [':CocCommand fzf-preview.CocReferences'          , 'coc-references'],
      \ 's' : [':w'                                             , 'save-buffer'],
      \ 'S' : [':wa'                                            , 'save-all-buffers'],
      \ 't' : [':FzfPreviewCtags'                               , 'tags'],
      \ 'T' : [':FzfPreviewBufferTags'                          , 'buffer-tags'],
      \ 'u' : [':FzfPreviewProjectMruFiles'                     , 'project-mru-files'],
      \ 'v' : [':FzfPreviewVistaCtags'                          , 'vista-ctags-list'],
      \ 'V' : [':FzfPreviewVistaBufferCtags'                    , 'vista-buffer-ctags-list'],
      \ 'U' : [':FzfPreviewMruFiles'                            , 'fzf-mru-files'],
      \ 'w' : [':FzfPreviewProjectMrwFiles'                     , 'project-mrw-files'],
      \ 'W' : [':FzfPreviewMrwFiles'                            , 'fzf-mrw-files'],
      \ }
      " \ 's' : [':FzfPreviewProjectGrep '                      , 'project-grep'],

" " f is for find and replace
" let g:which_key_map.f = {
"       \ 'name' : '+files'                                     ,
"       \ 's' : [':w'                                           , 'save-file'],
"       \ 'd' : [':Delete'                                      , 'delete-file'],
"       \ 'u' : [':Unlink'                                      , 'delete-with-open-window'],
"       \ 'm' : [':Move'                                        , 'rename-file'],
"       \ 'r' : [':Rename'                                      , 'relative-rename-file'],
"       \ 'c' : [':Chmod'                                       , 'change-permissions-of-file'],
"       \ 'n' : [':Mkdir'                                       , 'create-directory'],
"       \ 'w' : [':Wall'                                        , 'save-all-open-buffers'],
"       \ 'W' : [':SudoWrite'                                   , 'sudo-save'],
"       \ 'E' : [':SudoEdit'                                    , 'sudo-edit'],
"       \ }

" " f is for find and replace
" let g:which_key_map.f.f = {
"       \ 'name' : '+find-files'                                ,
"       \ 'b' : [':FzfBuffers'                                  , 'find-buffers'],
"       \ 'f' : [':FzfFiles'                                    , 'fzf-files'],
"       \ 'g' : [':FzfGFiles'                                   , 'fzf-git-files'],
"       \ 'c' : [':Cfind'                                       , 'cfind-with-quickfix'],
"       \ 'd' : [':Clocate'                                     , 'clocate-with-quickfix'],
"       \ 'l' : [':Lfind'                                       , 'lfind-with-location-list'],
"       \ 'm' : [':Llocate'                                     , 'llocate-with-location-list'],
"       \ }

" F is for find and replace
let g:which_key_map.F = {
      \ 'name' : '+find/replace'                                ,
      \ 'b' : [':Farr --source=vimgrep'                         , 'buffer'],
      \ 'p' : [':Farr --source=rgnvim'                          , 'project'],
      \ }

" g is for git
let g:which_key_map.g = {
      \ 'name' : '+git'                                         ,
      \ 'a' : [':Git add .'                                     , 'add-all'],
      \ 'A' : [':Git add %'                                     , 'add-current'],
      \ 'b' : [':GBrowse'                                       , 'browse'],
      \ 'B' : [':Git blame'                                     , 'blame'],
      \ 'C' : [':Git commit'                                    , 'commit'],
      \ 'c' : [':FzfGBranches'                                  , 'checkout'],
      \ 'd' : [':Git diff'                                      , 'diff'],
      \ 'D' : [':Gdiffsplit'                                    , 'diff-split'],
      \ 'g' : [':GGrep'                                         , 'git-grep'],
      \ 'G' : [':Gstatus'                                       , 'status'],
      \ 'h' : [':GitGutterLineHighlightsToggle'                 , 'highlight-hunks'],
      \ 'H' : ['<Plug>(GitGutterPreviewHunk)'                   , 'preview-hunk'],
      \ 'i' : [':Gist -b'                                       , 'post-gist'],
      \ 'j' : ['<Plug>(GitGutterNextHunk)'                      , 'next-hunk'],
      \ 'k' : ['<Plug>(GitGutterPrevHunk)'                      , 'prev-hunk'],
      \ 'l' : [':Git log'                                       , 'log'],
      \ 'm' : [':Magit'                                         , 'magit'],
      \ 'M' : ['<Plug>(git-messenger)'                          , 'git-messenger'],
      \ 'p' : [':Git push'                                      , 'push'],
      \ 'P' : [':Git pull'                                      , 'pull'],
      \ 'r' : [':GRemove'                                       , 'remove'],
      \ 's' : [':Magit'                                         , 'status'],
      \ 'S' : ['<Plug>(GitGutterStageHunk)'                     , 'stage-hunk'],
      \ 't' : [':GitGutterSignsToggle'                          , 'toggle-signs'],
      \ 'u' : ['<Plug>(GitGutterUndoHunk)'                      , 'undo-hunk'],
      \ 'v' : [':GV'                                            , 'view-commits'],
      \ 'V' : [':GV!'                                           , 'view-buffer-commits'],
      \ }

" G is goneovim
let g:which_key_map.G = {
      \ 'name' : '+goneovim'                                    ,
      \ 'a' : [':GonvimFuzzyAg'                                 , 'fuzzy-ag'],
      \ 'b' : [':GonvimFuzzyBuffers'                            , 'fuzzy-buffers'],
      \ 'f' : [':GonvimFuzzyFiles'                              , 'fuzzy-files'],
      \ 'F' : [':GonvimFilerOpen'                               , 'external-file-explorer'],
      \ 'l' : [':GonvimFuzzyBLines'                             , 'fuzzy-buffer-lines'],
      \ 'm' : [':GonvimMarkdown'                                , 'markdown-preview'],
      \ 'M' : [':GonvimMiniMap'                                 , 'toggle-minimap'],
      \ 'n' : [':GonvimWorkspaceNext'                           , 'next-workspace'],
      \ 'N' : [':GonvimWorkspaceNew'                            , 'create-new-workspace'],
      \ 'p' : [':GonvimWorkspacePrevious'                       , 'previous-workspace'],
      \ 'r' : [':GonvimFuzzyResume'                             , 'resume-previous-search'],
      \ 's' : [':GonvimWorkspaceSwitch '                        , 'switch-workspace'],
      \ }

" m is major mode
let g:which_key_map.m = {
      \ 'name' : '+major-mode'                                  ,
      \ 'c' : [':MakeTags'                                      , 'make-ctags'],
      \ 'l' : ['<Plug>(JsConsoleLog)'                           , 'console-log'],
      \ 'r' : ['<Plug>(coc-rename)'                             , 'rename-symbol'],
      \ }

" n is Neovim
let g:which_key_map.n = {
      \ 'name' : '+neovim'                                      ,
      \ 'c' : [':PlugClean'                                     , 'clean-packages'],
      \ 'e' : [':e $MYVIMRC'                                    , 'edit-config'],
      \ 'i' : [':PlugInstall'                                   , 'install-packages'],
      \ 'r' : [':so $MYVIMRC'                                   , 'source-config'],
      \ 's' : [':PlugSnapshot'                                  , 'plug-snapshot'],
      \ 'u' : [':PlugUpdate'                                    , 'update-packages'],
      \ 'U' : [':PlugUpgrade'                                   , 'upgrade-plug'],
      \ }

" p is for Project
let g:which_key_map.p = {
      \ 'name' : '+project'                                     ,
      \ 'b' : [':FzfBuffers'                                    , 'find-buffers'],
      \ 'f' : [':FzfFiles'                                      , 'find-files'],
      \ 'g' : [':FzfGFiles'                                     , 'find-git-files'],
      \ 'l' : [':FzfLines'                                      , 'find-lines'],
      \ 'p' : [':CocList project'                               , 'switch-project'],
      \ }

" s is for search
let g:which_key_map.s = {
      \ 'name' : '+search'                                      ,
      \ '/' : [':FzfHistory/'                                   , 'history'],
      \ ';' : [':FzfCommands'                                   , 'commands'],
      \ 'a' : [':FzfAg'                                         , 'text-Ag'],
      \ 'b' : [':FzfBLines'                                     , 'current-buffer'],
      \ 'B' : [':FzfBuffers'                                    , 'open-buffers'],
      \ 'c' : [':FzfCommits'                                    , 'commits'],
      \ 'C' : [':FzfBCommits'                                   , 'buffer-commits'],
      \ 'f' : [':FzfFiles'                                      , 'files'],
      \ 'g' : [':FzfGFiles'                                     , 'git-files'],
      \ 'G' : [':FzfGFiles?'                                    , 'modified-git-files'],
      \ 'h' : [':FzfHistory'                                    , 'file-history'],
      \ 'H' : [':FzfHistory:'                                   , 'command-history'],
      \ 'l' : [':FzfLines'                                      , 'lines'],
      \ 'm' : [':FzfMarks'                                      , 'marks'],
      \ 'M' : [':FzfMaps'                                       , 'normal-maps'],
      \ 'p' : [':FzfHelptags'                                   , 'help-tags'],
      \ 'P' : [':FzfTags'                                       , 'project-tags'],
      \ 's' : [':FzfSnippets'                                   , 'snippets'],
      \ 'S' : [':FzfColors'                                     , 'color-schemes'],
      \ 't' : [':Rg'                                            , 'text-Rg'],
      \ 'T' : [':FzfBTags'                                      , 'buffer-tags'],
      \ 'w' : [':FzfWindows'                                    , 'search-windows'],
      \ 'y' : [':FzfFiletypes'                                  , 'file-types'],
      \ 'z' : [':FZF'                                           , 'FZF'],
      \ }

let g:which_key_map.S = {
      \ 'name' : '+session'                                     ,
      \ 'c' : [':SClose'                                        , 'close-session'],
      \ 'd' : [':SDelete'                                       , 'delete-session'],
      \ 'l' : [':SLoad'                                         , 'load-session'],
      \ 's' : [':Startify'                                      , 'start-page'],
      \ 'S' : [':SSave'                                         , 'save-session'],
      \ }


" l is for language server protocol
let g:which_key_map.l = {
      \ 'name' : '+lsp'                                         ,
      \ '.' : [':CocConfig'                                     , 'config'],
      \ ';' : ['<Plug>(coc-refactor)'                           , 'refactor'],
      \ 'a' : ['<Plug>(coc-codeaction)'                         , 'line-action'],
      \ 'A' : ['<Plug>(coc-codeaction-selected)'                , 'selected-action'],
      \ 'b' : [':CocNext'                                       , 'next-action'],
      \ 'B' : [':CocPrev'                                       , 'prev-action'],
      \ 'c' : [':CocList commands'                              , 'commands'],
      \ 'd' : ['<Plug>(coc-definition)'                         , 'definition'],
      \ 'D' : ['<Plug>(coc-declaration)'                        , 'declaration'],
      \ 'e' : [':CocList extensions'                            , 'extensions'],
      \ 'f' : ['<Plug>(coc-format-selected)'                    , 'format-selected'],
      \ 'F' : ['<Plug>(coc-format)'                             , 'format'],
      \ 'h' : ['<Plug>(coc-float-hide)'                         , 'hide'],
      \ 'i' : ['<Plug>(coc-implementation)'                     , 'implementation'],
      \ 'I' : [':CocList diagnostics'                           , 'diagnostics'],
      \ 'j' : ['<Plug>(coc-float-jump)'                         , 'float-jump'],
      \ 'l' : ['<Plug>(coc-codelens-action)'                    , 'code-lens'],
      \ 'n' : ['<Plug>(coc-diagnostic-next)'                    , 'next-diagnostic'],
      \ 'N' : ['<Plug>(coc-diagnostic-next-error)'              , 'next-error'],
      \ 'o' : [':Vista!!'                                       , 'outline'],
      \ 'O' : [':CocList outline'                               , 'outline'],
      \ 'p' : ['<Plug>(coc-diagnostic-prev)'                    , 'prev-diagnostic'],
      \ 'P' : ['<Plug>(coc-diagnostic-prev-error)'              , 'prev-error'],
      \ 'q' : ['<Plug>(coc-fix-current)'                        , 'quickfix'],
      \ 'r' : ['<Plug>(coc-references)'                         , 'references'],
      \ 'R' : ['<Plug>(coc-rename)'                             , 'rename'],
      \ 's' : [':CocList -I symbols'                            , 'references'],
      \ 'S' : [':CocList snippets'                              , 'snippets'],
      \ 't' : ['<Plug>(coc-type-definition)'                    , 'type-definition'],
      \ 'u' : [':CocListResume'                                 , 'resume-list'],
      \ 'U' : [':CocUpdate'                                     , 'update-CoC'],
      \ 'z' : [':CocDisable'                                    , 'disable-CoC'],
      \ 'Z' : [':CocEnable'                                     , 'enable-CoC'],
      \ }
      " \ 'o' : ['<Plug>(coc-openlink)'                         , 'open link'],

" t is for floaterm
let g:which_key_map.t = {
      \ 'name' : '+terminal'                                    ,
      \ ';' : [':FloatermNew'                                   , 'terminal'],
      \ 'a' : [':set scrolloff=999'                             , 'scrolloff'],
      \ 'f' : [':FloatermNew fzf'                               , 'fzf'],
      \ 'g' : [':FloatermNew lazygit'                           , 'git'],
      \ 'd' : [':FloatermNew lazydocker'                        , 'docker'],
      \ 'n' : [':FloatermNew node'                              , 'node'],
      \ 'p' : [':FloatermNew python'                            , 'python'],
      \ 'r' : [':FloatermNew ranger'                            , 'ranger'],
      \ 't' : [':FloatermToggle'                                , 'toggle'],
      \ 'y' : [':FloatermNew btm'                               , 'ytop'],
      \ 's' : [':FloatermNew ncdu'                              , 'ncdu'],
      \ }

" T is for tabline
let g:which_key_map.T = {
      \ 'name' : '+tabline'                                     ,
      \ 'b' : [':XTabListBuffers'                               , 'list-buffers'],
      \ 'd' : [':XTabCloseBuffer'                               , 'close-buffer'],
      \ 'D' : [':XTabDeleteTab'                                 , 'close-tab'],
      \ 'h' : [':XTabHideBuffer'                                , 'hide-buffer'],
      \ 'i' : [':XTabInfo'                                      , 'info'],
      \ 'l' : [':XTabLock'                                      , 'lock-tab'],
      \ 'm' : [':XTabMode'                                      , 'toggle-mode'],
      \ 'n' : [':tabNext'                                       , 'next-tab'],
      \ 'N' : [':XTabMoveBufferNext'                            , 'buffer->'],
      \ 't' : [':tabnew'                                        , 'new-tab'],
      \ 'p' : [':tabprevious'                                   , 'prev-tab'],
      \ 'P' : [':XTabMoveBufferPrev'                            , '<-buffer'],
      \ 'x' : [':XTabPinBuffer'                                 , 'pin-buffer'],
      \ }

" u is for UI and toggle
let g:which_key_map.u = {
      \ 'name' : '+ui/toggle'                                   ,
      \ 'e' : [':CocCommand clock.enable'                       , 'show-clock'],
      \ 'd' : [':CocCommand clock.disable'                      , 'hide-clock'],
      \ 'u' : [':UndotreeToggle'                                , 'undo-tree'],
      \ }

" w is for windows
let g:which_key_map.w = {
      \ 'name' : '+windows'                                     ,
      \ '2' : ['<C-W>v'                                         , 'layout-double-columns'],
      \ ';' : ['<C-W>L'                                         , 'move-window-far-right'],
      \ '=' : ['<C-W>='                                         , 'balance-window'],
      \ '?' : [':FzfWindows'                                    , 'fzf-window'],
      \ 'a' : ['<C-W>H'                                         , 'move-window-far-left'],
      \ 'd' : ['<C-W>c'                                         , 'delete-window'],
      \ 'h' : ['<C-W>h'                                         , 'window-left'],
      \ 'H' : ['<C-W>5<'                                        , 'expand-window-left'],
      \ 'i' : ['<C-W>K'                                         , 'move-window-far-top'],
      \ 'j' : ['<C-W>j'                                         , 'window-below'],
      \ 'J' : [':resize +5'                                     , 'expand-window-below'],
      \ 'k' : ['<C-W>k'                                         , 'window-up'],
      \ 'K' : [':resize  5'                                     , 'expand-window-up'],
      \ 'l' : ['<C-W>l'                                         , 'window-right'],
      \ 'L' : ['<C-W>5>'                                        , 'expand-window-right'],
      \ 'm' : [':MaximizerToggle'                               , 'maximize-windows'],
      \ 'n' : ['<C-W>J'                                         , 'move-window-far-down'],
      \ 's' : ['<C-W>s'                                         , 'split-window-below'],
      \ 'v' : ['<C-W>v'                                         , 'split-window-right'],
      \ 'u' : ['<C-W>x'                                         , 'swap-window-next'],
      \ 'x' : ['call WindowSwap#EasyWindowSwap()'               , 'mark-window-for-swap'],
      \ 'y' : ['call WindowSwap#MarkWindowSwap()'               , 'mark-window-for-swap'],
      \ 'z' : ['call WindowSwap#DoWindowSwap()'                 , 'do-window-swap'],
      \ }

" Register which key map
call which_key#register('<Space>', "g:which_key_map")
