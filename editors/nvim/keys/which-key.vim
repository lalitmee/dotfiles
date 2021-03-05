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

let g:which_key_centered = 0

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
let g:which_key_map['r'] = [ ':RnvimrToggle'                      , 'ranger' ]
let g:which_key_map['x'] = [ 'q'                                  , 'quit' ]
let g:which_key_map['z'] = [ 'Goyo'                               , 'zen' ]
let g:which_key_map[','] = [ 'w'                                  , 'save' ]
let g:which_key_map['.'] = [ ':e $MYVIMRC'                        , 'open-init' ]
let g:which_key_map[';'] = [ ':FzfCommands'                       , 'commands' ]

 " Group mappings

" a is for actions
let g:which_key_map.a = {
      \ 'name' : '+actions'                                       ,
      \ 'c' : [':ColorizerToggle'                                 , 'colorizer'],
      \ 'e' : [':NvimTreeToggle'                                  , 'nvim-tree-exlporer'],
      \ 'f' : [':NvimTreeFindFile'                                , 'nvim-tree-find-file'],
      \ 'h' : [':Telescope frecency'                              , 'telescope-frecency'],
      \ 'l' : [':Bracey'                                          , 'start-live-server'],
      \ 'L' : [':BraceyStop'                                      , 'stop-live-server'],
      \ 'm' : [':MarkdownPreview'                                 , 'markdown-preview'],
      \ 'M' : [':MarkdownPreviewStop'                             , 'markdown-preview-stop'],
      \ 'r' : [':NvimTreeRefresh'                                 , 'nvim-tree-refresh'],
      \ 't' : [':FloatermToggle'                                  , 'terminal'],
      \ 'w' : [':StripWhitespace'                                 , 'strip-whitespace'],
      \ }
      " \ 'e' : [':CocCommand explorer'                           , 'explorer'],

" b is for buffer
let g:which_key_map.b = {
      \ 'name' : '+buffers'                                       ,
      \ 'b' : [':FzfBuffers'                                      , 'fzf-buffers'],
      \ 'B' : [':Telescope buffers'                               , 'telescope-buffers'],
      \ 'c' : ['vnew'                                             , 'new-empty-buffer-vert'],
      \ 'd' : [':Bdelete'                                         , 'delete-buffer'],
      \ 'D' : [':%bd'                                             , 'delete-all-buffers'],
      \ 'e' : [':BufferLast'                                      , 'last-buffer'],
      \ 'f' : ['bfirst'                                           , 'first-buffer'],
      \ 'h' : ['Startify'                                         , 'home-buffer'],
      \ 'l' : [':Telescope current_buffer_fuzzy_find'             , 'search-buffer-lines'],
      \ 'M' : [':delm!'                                            , 'delete-marks'],
      \ 'n' : [':BufferNext'                                      , 'next-buffer'],
      \ 'N' : [':BufferMoveNext'                                  , 'move-next-buffer'],
      \ 'o' : [':BufferOrderByDirectory'                          , 'order-by-direcoty'],
      \ 'O' : [':BufferOrderByLanguage'                           , 'order-by-language'],
      \ 'p' : [':BufferPrevious'                                  , 'previous-buffer'],
      \ 'P' : [':BufferMovePrevious'                              , 'move-previous-buffer'],
      \ 'r' : ['e'                                                , 'refresh-buffer'],
      \ 'R' : ['bufdo :e'                                         , 'refresh-loaded-buffers'],
      \ 's' : ['new'                                              , 'new-empty-buffer'],
      \ }

" c is for coc.nvim
let g:which_key_map.c = {
      \ 'name' : '+coc'                                           ,
      \ 'a' : [':CocAction'                                       , 'action'],
      \ 'c' : [':CocCommand'                                      , 'commands'],
      \ 'd' : [':CocDiagnostics'                                  , 'diagnostics'],
      \ 'e' : [':CocConfig'                                       , 'config'],
      \ 'f' : [':CocFix'                                          , 'fix'],
      \ 'i' : [':CocInfo'                                         , 'info'],
      \ 'l' : {
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
      \ },
      \ 'r' : ['coc#refresh()'                                  , 'coc-refresh'],
      \ 'R' : [':CocListResume '                                  , 'list-resume'],
      \ 's' : [':CocSearch'                                       , 'search'],
      \ 'x' : ['<Plug>(coc-convert-snippet)'                      , 'covert-to-snippet'],
      \ }

" d is for FZF
let g:which_key_map.d = {
      \ 'name' : '+FZF'                                           ,
      \ 'a' : [':FzfAg'                                           , 'ag'],
      \ 'b' : {
        \ 'name' : '+buffers'                                     ,
        \ 'j' : [':FzfBuffers'                                    , 'jump-buffers'],
        \ 'l' : [':FzfBLines'                                     , 'buffer-lines'],
        \ 'L' : [':FzfLines'                                      , 'loaded-buffers-lines'],
      \ },
      \ 'd' : [':FzfRg'                                           , 'rg'],
      \ 'f' : {
        \ 'name' : '+files'                                       ,
        \ 'f' : [':FzfFiles'                                      , 'files'],
        \ 'g' : [':FzfGFiles'                                     , 'git-files'],
        \ 's' : [':FzfGFiles?'                                    , 'git-status-files'],
      \ },
      \ 'g' : {
        \ 'name' : '+git'                                         ,
        \ 'b' : [':FzfBCommits'                                   , 'buffer-commits'],
        \ 'B' : [':FzfCommits'                                    , 'commits'],
        \ 'c' : [':FzfGBranches'                                  , 'git-branches'],
      \ },
      \ 'h' : [':FzfHistory'                                      , 'history'],
      \ 'i' : [':FzfSnippets'                                     , 'snippets'],
      \ 'l' : [':FzfLocate '                                      , 'locate'],
      \ 't' : [':FzfBTags'                                        , 'buffer-tags'],
      \ 'T' : [':FzfTags'                                         , 'project-tags'],
      \ 'v' : {
        \ 'name' : '+vim'                                         ,
        \ '/' : [':FzfHistory/'                                   , 'search-history'],
        \ ':' : [':FzfHistory:'                                   , 'command-history'],
        \ ';' : [':FzfCommands'                                   , 'command-history'],
        \ 'c' : [':FzfColors'                                     , 'colorschemes'],
        \ 'f' : [':FzfFiletypes'                                  , 'filetypes'],
        \ 'h' : [':FzfHelptags'                                   , 'help-tags'],
        \ 'm' : [':FzfMarks'                                      , 'marks'],
        \ 'M' : [':FzfMaps'                                       , 'maps'],
      \ },
      \ 'w' : [':FzfWindows'                                      , 'windows'],
      \ }

let g:which_key_map.e = {
      \ 'name' : '+errors/warnings'                               ,
      \ 'l' : ['CocDiagnostics'                                   , 'list-errors/warnings'],
      \ 'n' : ['<Plug>(coc-diagnostic-next)'                      , 'next-diagnostic'],
      \ 'N' : ['<Plug>(coc-diagnostic-next-error)'                , 'next-error'],
      \ 'p' : ['<Plug>(coc-diagnostic-prev)'                      , 'prev-diagnostic'],
      \ 'P' : ['<Plug>(coc-diagnostic-prev-error)'                , 'prev-error'],
      \ }

" f is for fzf-preview
let g:which_key_map.f = {
      \ 'name' : '+fzf-preview'                                   ,
      \ 'f' : {
        \ 'name' : '+files'                                       ,
        \ 'd' : [':FzfPreviewFromResources directory'             , 'directory-resource'],
        \ 'f' : [':FzfPreviewProjectFiles'                        , 'find-files'],
        \ 'g' : [':FzfPreviewGitFiles'                            , 'find-git-files'],
        \ 'K' : [':FzfPreviewFromResources project_mrw'           , 'project-mrw-resource'],
        \ 'm' : [':FzfPreviewFromResources project_mru'           , 'project-mru-resource'],
        \ 'o' : [':FzfPreviewFromResources project_old'           , 'project-old-resource'],
        \ 'O' : [':FzfPreviewFromResources old'                   , 'old-resource'],
        \ 'p' : [':FzfPreviewFromResources project'               , 'project-resource'],
        \ 'r' : [':FzfPreviewOldFiles'                            , 'recent-files'],
        \ 'u' : [':FzfPreviewProjectMruFiles'                     , 'dir-mru-files'],
        \ 'U' : [':FzfPreviewMruFiles'                            , 'mru-files'],
        \ 'w' : [':FzfPreviewProjectMrwFiles'                     , 'dir-mrw-files'],
        \ 'W' : [':FzfPreviewMruFiles'                            , 'mru-files'],
        \ 'z' : [':FzfPreviewFromResources mru'                   , 'mru-resource'],
        \ 'Z' : [':FzfPreviewFromResources mrw'                   , 'mrw-resource'],
      \ },
      \ 'g' : {
        \ 'name' : '+git'                                         ,
        \ 'a' : [':FzfPreviewGitActions'                          , 'git-actions'],
        \ 'c' : [':FzfPreviewChanges'                             , 'changes'],
        \ 'f' : [':FzfPreviewFromResources git'                   , 'git-resource'],
        \ 'g' : [':FzfPreviewGitStatus'                           , 'git-status'],
      \ },
      \ 'b' : {
        \ 'name' : '+buffers'                                     ,
        \ 'a' : [':FzfPreviewFromResources buffer'                , 'buffer-resource'],
        \ 'b' : [':FzfPreviewBuffers'                             , 'buffers'],
        \ 'B' : [':FzfPreviewAllBuffers'                          , 'all-buffers'],
        \ 'l' : [':FzfPreviewLines'                               , 'buffer-lines'],
        \ 'L' : [':FzfPreviewBufferLines'                         , 'loaded-buffers-lines'],
      \ },
      \ 'c' : {
        \ 'name' : '+coc'                                         ,
        \ 'd' : [':CocCommand fzf-preview.CocTypeDefinitions'     , 'coc-type-definitions-preview'],
        \ 'e' : [':CocCommand fzf-preview.CocCurrentDiagnostics'  , 'buffer-diagnostics'],
        \ 'E' : [':CocCommand fzf-preview.CocDiagnostics'         , 'diagnostics'],
        \ 'l' : [':CocCommand fzf-preview.CocImplementations'     , 'coc-implementations-preview'],
        \ 'r' : [':CocCommand fzf-preview.CocReferences'          , 'coc-references-preview'],
      \ },
      \ 'j' : {
        \ 'name' : '+jump'                                        ,
        \ 'b' : [':FzfPreviewBookmarks'                           , 'bookmarks-preview'],
        \ 'm' : [':FzfPreviewMarks'                               , 'marks'],
        \ 'j' : [':FzfPreviewJumps'                               , 'jumps'],
        \ 'l' : [':FzfPreviewLocationList'                        , 'location-list'],
      \ },
      \ 't' : {
        \ 'name' : '+tags'                                        ,
        \ 'b' : [':FzfPreviewBufferTags'                          , 'buffer-ctags'],
        \ 'c' : [':FzfPreviewVistaBufferCtags'                    , 'vista-buffer-tags'],
        \ 't' : [':FzfPreviewCtags'                               , 'ctags'],
        \ 'v' : [':FzfPreviewVistaCtags'                          , 'vista-tags'],
      \ },
      \ 'v' : {
        \ 'name' : '+vim'                                         ,
        \ 'h' : [':FzfPreviewCommandPalette'                      , 'execute-edit-commands-history'],
      \ },
      \ 'q' : [':FzfPreviewQuickFix'                              , 'quick-fix-list'],
      \ 's' : [':w'                                               , 'save-buffer'],
      \ 'S' : [':wa'                                              , 'save-all-buffers'],
      \ }


" F is for find and replace
let g:which_key_map.F = {
      \ 'name' : '+find/replace'                                  ,
      \ 'b' : [':Farr --source=vimgrep'                           , 'buffer'],
      \ 'p' : [':Farr --source=rgnvim'                            , 'project'],
      \ }

" g is for git
let g:which_key_map.g = {
      \ 'name' : '+git'                                           ,
      \ 'a' : [':Git add .'                                       , 'add-all'],
      \ 'A' : [':Git add %'                                       , 'add-current'],
      \ 'b' : [':GBrowse'                                         , 'browse'],
      \ 'B' : [':Git blame'                                       , 'blame'],
      \ 'C' : [':Git commit'                                      , 'commit'],
      \ 'c' : [':FzfGBranches'                                    , 'checkout'],
      \ 'd' : [':Git diff'                                        , 'diff'],
      \ 'D' : [':Gdiffsplit'                                      , 'diff-split'],
      \ 'g' : [':GGrep'                                           , 'git-grep'],
      \ 'G' : [':Gstatus'                                         , 'status'],
      \ 'h' : {
        \ 'name' : '+hunks'                                       ,
        \ 'c' : [':CocCommand git.copyUrl'                        , 'copy-url'],
        \ 'h' : [':GitGutterLineHighlightsToggle'                 , 'highlight-hunks'],
        \ 'i' : ['CocCommand git.chunkInfo'                       , 'chunk-info'],
        \ 'j' : ['<Plug>(coc-git-nextchunk)'                      , 'next-hunk'],
        \ 'k' : ['<Plug>(coc-git-prevchunk)'                      , 'prev-hunk'],
        \ 'o' : [':CocCommand git.browserOpen'                    , 'open-in-browser'],
        \ 'p' : ['<Plug>(GitGutterPreviewHunk)'                   , 'preview-hunk'],
        \ 's' : [':CocCommand git.chunkStage'                     , 'stage-hunk'],
        \ 'u' : [':CocCommand git.chunkUndo'                      , 'undo-hunk'],
        \ 'v' : [':CocCommand git.showCommit'                     , 'show-commit'],
      \ },
      \ 'i' : [':Gist -b'                                         , 'post-gist'],
      \ 'l' : [':Git log'                                         , 'log'],
      \ 'm' : [':Magit'                                           , 'magit'],
      \ 'M' : ['<Plug>(git-messenger)'                            , 'git-messenger'],
      \ 'p' : [':CocCommand git.push'                             , 'push'],
      \ 'P' : [':Git pull'                                        , 'pull'],
      \ 'r' : [':Telescope gh pull_request'                       , 'list-pull-requests'],
      \ 'R' : [':GRemove'                                         , 'remove'],
      \ 's' : [':Magit'                                           , 'status'],
      \ 't' : [':CocCommand git.toggleGutters'                    , 'toggle-gutters'],
      \ 'u' : [':CocCommand git.refresh'                          , 'refresh'],
      \ 'v' : [':GV'                                              , 'view-commits'],
      \ 'V' : [':GV!'                                             , 'view-buffer-commits'],
      \ }

" G is goneovim
let g:which_key_map.G = {
      \ 'name' : '+goneovim'                                      ,
      \ 'a' : [':GonvimFuzzyAg'                                   , 'fuzzy-ag'],
      \ 'b' : [':GonvimFuzzyBuffers'                              , 'fuzzy-buffers'],
      \ 'f' : [':GonvimFuzzyFiles'                                , 'fuzzy-files'],
      \ 'F' : [':GonvimFilerOpen'                                 , 'external-file-explorer'],
      \ 'l' : [':GonvimFuzzyBLines'                               , 'fuzzy-buffer-lines'],
      \ 'm' : [':GonvimMarkdown'                                  , 'markdown-preview'],
      \ 'M' : [':GonvimMiniMap'                                   , 'toggle-minimap'],
      \ 'n' : [':GonvimWorkspaceNext'                             , 'next-workspace'],
      \ 'N' : [':GonvimWorkspaceNew'                              , 'create-new-workspace'],
      \ 'p' : [':GonvimWorkspacePrevious'                         , 'previous-workspace'],
      \ 'r' : [':GonvimFuzzyResume'                               , 'resume-previous-search'],
      \ 's' : [':GonvimWorkspaceSwitch '                          , 'switch-workspace'],
      \ }

" j is AnyJump
let g:which_key_map.j = {
      \ 'name' : '+any-jump'                                      ,
      \ 'j' : [':AnyJump'                                         , 'current-word'],
      \ 'l' : [':AnyJumpBack'                                     , 'back'],
      \ 'r' : [':AnyJumpLastResults'                              , 'last-results'],
      \ 's' : [':AnyJumpRunSpecs'                                 , 'run-specs'],
      \ 'v' : [':AnyJumpVisual'                                   , 'visual-selection'],
      \ }

" l is for language server protocol
let g:which_key_map.l = {
      \ 'name' : '+lsp'                                           ,
      \ '.' : [':CocConfig'                                       , 'config'],
      \ ';' : ['<Plug>(coc-refactor)'                             , 'refactor'],
      \ 'a' : ['<Plug>(coc-codeaction)'                           , 'line-action'],
      \ 'A' : ['<Plug>(coc-codeaction-selected)'                  , 'selected-action'],
      \ 'b' : [':CocNext'                                         , 'next-action'],
      \ 'B' : [':CocPrev'                                         , 'prev-action'],
      \ 'c' : [':CocList commands'                                , 'commands'],
      \ 'd' : ['<Plug>(coc-definition)'                           , 'definition'],
      \ 'D' : ['<Plug>(coc-declaration)'                          , 'declaration'],
      \ 'e' : [':CocList extensions'                              , 'extensions'],
      \ 'f' : ['<Plug>(coc-format-selected)'                      , 'format-selected'],
      \ 'F' : ['<Plug>(coc-format)'                               , 'format'],
      \ 'h' : ['<Plug>(coc-float-hide)'                           , 'hide'],
      \ 'i' : ['<Plug>(coc-implementation)'                       , 'implementation'],
      \ 'I' : [':CocList diagnostics'                             , 'diagnostics'],
      \ 'j' : ['<Plug>(coc-float-jump)'                           , 'float-jump'],
      \ 'l' : ['<Plug>(coc-codelens-action)'                      , 'code-lens'],
      \ 'n' : ['<Plug>(coc-diagnostic-next)'                      , 'next-diagnostic'],
      \ 'N' : ['<Plug>(coc-diagnostic-next-error)'                , 'next-error'],
      \ 'o' : [':Vista!!'                                         , 'outline'],
      \ 'O' : [':CocList outline'                                 , 'outline'],
      \ 'p' : ['<Plug>(coc-diagnostic-prev)'                      , 'prev-diagnostic'],
      \ 'P' : ['<Plug>(coc-diagnostic-prev-error)'                , 'prev-error'],
      \ 'q' : ['<Plug>(coc-fix-current)'                          , 'quickfix'],
      \ 'r' : ['<Plug>(coc-references)'                           , 'references'],
      \ 'R' : ['<Plug>(coc-rename)'                               , 'rename'],
      \ 's' : [':CocList -I symbols'                              , 'symbols'],
      \ 'S' : [':CocList snippets'                                , 'snippets'],
      \ 't' : ['<Plug>(coc-type-definition)'                      , 'type-definition'],
      \ 'u' : [':CocListResume'                                   , 'resume-list'],
      \ 'U' : [':CocUpdate'                                       , 'update-CoC'],
      \ 'z' : [':CocDisable'                                      , 'disable-CoC'],
      \ 'Z' : [':CocEnable'                                       , 'enable-CoC'],
      \ }
      " \ 'o' : ['<Plug>(coc-openlink)'                           , 'open link'],

" m is major mode
let g:which_key_map.m = {
      \ 'name' : '+major-mode'                                    ,
      \ 'a' : [':Telescope lsp_code_actions'                      , 'code-actions'],
      \ 'b' : [':Telescope lsp_range_code_actions'                , 'range-code-actions'],
      \ 'c' : [':MakeTags'                                        , 'make-ctags'],
      \ 'd' : [':Telescope lsp_document_diagnostics'                  , 'document-diagnostics'],
      \ 'D' : [':Telescope lsp_workspace_diagnostics'                  , 'workspace-diagnostics'],
      \ 'f' : [':Telescope lsp_references'                        , 'references'],
      \ 'j' : [':Telescope lsp_workspace_symbols'                 , 'workspace-symbols'],
      \ 'l' : ['<Plug>(JsConsoleLog)'                             , 'console-log'],
      \ 's' : [':Telescope lsp_document_symbols'                  , 'buffer-symbols'],
      \ }
      " \ 'r' : ['<Plug>(coc-rename)'                               , 'rename-symbol'],

" n is Neovim
let g:which_key_map.n = {
      \ 'name' : '+neovim'                                        ,
      \ 'c' : [':PlugClean'                                       , 'clean-packages'],
      \ 'e' : [':e $MYVIMRC'                                      , 'edit-config'],
      \ 'i' : [':PlugInstall'                                     , 'install-packages'],
      \ 'r' : [':so $MYVIMRC'                                     , 'source-config'],
      \ 's' : [':PlugSnapshot'                                    , 'plug-snapshot'],
      \ 'u' : [':PlugUpdate'                                      , 'update-packages'],
      \ 'U' : [':PlugUpgrade'                                     , 'upgrade-plug'],
      \ }

" o is Telescope
let g:which_key_map.o = {
      \ 'name' : '+Telescope'                                     ,
      \ 'b' : {
        \ 'name' : '+buffers'                                     ,
        \ 'a' : [':Telescope lsp_code_actions'                    , 'code-actions'],
        \ 'b' : [':Telescope buffers'                             , 'buffers'],
        \ 'c' : [':Telescope lsp_range_code_actions'              , 'range-code-actions'],
        \ 'd' : [':Telescope lsp_document_symbols'                , 'buffer-symbols'],
        \ 'j' : [':Telescope lsp_workspace_symbols'               , 'workspace-symbols'],
        \ 'l' : [':Telescope current_buffer_fuzzy_find'           , 'buffer-lines'],
        \ 'r' : [':Telescope lsp_references'                      , 'references'],
        \ 's' : [':Telescope spell_suggest'                       , 'spell_suggest'],
        \ 't' : [':Telescope current_buffer_tags'                 , 'buffer-tags'],
      \ },
      \ 'd' : {
        \ 'name' : '+dap'                                         ,
        \ 'b' : [':Telescope dap lsp_breakpoints'                 , 'lsp-breakpoints'],
        \ 'c' : [':Telescope dap configurations'                  , 'configurations'],
        \ 'f' : [':Telescope dap frames'                          , 'frames'],
        \ 'o' : [':Telescope dap commands'                        , 'commands'],
        \ 'v' : [':Telescope dap variables'                       , 'variables'],
      \ },
      \ 'e' : [':Telescope symbols'                               , 'symbols'],
      \ 'f' : {
        \ 'name' : '+files'                                       ,
        \ 'e' : [':Telescope file_browser'                        , 'file-browser'],
        \ 'f' : [':Telescope fzf_writer files'                    , 'fzf-writer-files'],
        \ 'g' : [':Telescope git_files'                           , 'git-files'],
        \ 'h' : [':Telescope frecency'                            , 'telescope-frecency'],
        \ 'm' : [':Telescope media_files'                         , 'media-files'],
        \ 'o' : [':Telescope find_files'                          , 'find-files'],
        \ 'r' : [':Telescope oldfiles'                            , 'recent-files'],
        \ 'z' : [':Telescope filetypes'                           , 'filetypes'],
      \ },
      \ 'g' : {
        \ 'name' : '+git'                                         ,
        \ 'b' : [':Telescope git_branches'                        , 'git-branches'],
        \ 'c' : [':Telescope git_bcommits'                        , 'git-buffer-commits'],
        \ 'd' : [':Telescope git_commits'                         , 'git-commits'],
        \ 'f' : [':Telescope git_files'                           , 'git-files'],
        \ 's' : [':Telescope git_status'                          , 'git-status'],
      \ },
      \ 'i' : [':Telescope snippets snippets'                     , 'snippets'],
      \ 'j' : [':Telescope jumps jumps'                           , 'jumps'],
      \ 'l' : [':Telescope loclist'                               , 'loclist'],
      \ 'm' : [':Telescope man_pages'                             , 'man-pages'],
      \ 'o' : [':Telescope openbrowser list'                      , 'openbrowser'],
      \ 's' : {
        \ 'name' : '+search'                                      ,
        \ 'b' : [':Telescope current_buffer_fuzzy_find'           , 'buffer-lines'],
        \ 'l' : [':Telescope live_grep'                           , 'live-grep'],
        \ 's' : [':Telescope fzf_writer grep'                     , 'fzf-writer-grep'],
        \ 'u' : [':Telescope grep_string'                         , 'grep-string'],
      \ },
      \ 't' : {
        \ 'name' : '+telescope'                                   ,
        \ 'b' : [':Telescope builtin'                             , 'builtins'],
        \ 'p' : [':Telescope planets'                             , 'planets'],
        \ 'r' : [':Telescope reloader'                            , 'reloaders'],
      \ },
      \ 'u' : [':Telescope ultisnips ultisnips'                   , 'ultisnips'],
      \ 'v' : {
        \ 'name' : '+vim'                                         ,
        \ ';' : [':Telescope commands'                            , 'commands'],
        \ 'a' : [':Telescope autocommands'                        , 'autocommands'],
        \ 'c' : [':Telescope colorscheme'                         , 'colorschemes'],
        \ 'h' : [':Telescope command_history'                     , 'commands-history'],
        \ 'H' : [':Telescope highlights'                          , 'highlights'],
        \ 'k' : [':Telescope keymaps'                             , 'keymaps'],
        \ 'm' : [':Telescope marks'                               , 'marks'],
        \ 'r' : [':Telescope registers'                           , 'vim-registers'],
        \ 't' : [':Telescope help_tags'                           , 'help-tags'],
        \ 'v' : [':Telescope vim_options'                         , 'vim-options'],
      \ },
      \ }

" p is for Project
let g:which_key_map.p = {
      \ 'name' : '+project'                                       ,
      \ 'a' : [':FzfAg'                                           , 'project-search'],
      \ 'b' : [':FzfBuffers'                                      , 'find-buffers'],
      \ 'f' : [':Telescope fzf_writer files'                      , 'find-files'],
      \ 'g' : [':Telescope git_files'                             , 'find-git-files'],
      \ 'n' : [':Telescope node_modules list'                     , 'list-project-nodes-modules'],
      \ 'p' : [':Telescope project project'                       , 'switch-project'],
      \ 's' : [':Rg'                                              , 'project-search'],
      \ }

" s is for search
let g:which_key_map.s = {
      \ 'name' : '+search'                                        ,
      \ '/' : [':Telescope command_history'                       , 'history'],
      \ ';' : [':Telescope commands'                              , 'commands'],
      \ 'a' : [':FzfAg'                                           , 'text-Ag'],
      \ 'b' : [':Telescope current_buffer_fuzzy_find'             , 'current-buffer'],
      \ 'B' : [':Telescope buffers'                               , 'open-buffers'],
      \ 'c' : [':Telescope git_commits'                           , 'commits'],
      \ 'C' : [':Telescope git_bcommits'                          , 'buffer-commits'],
      \ 'f' : [':Telescope find_files'                            , 'files'],
      \ 'g' : [':Telescope git_files'                             , 'git-files'],
      \ 'G' : [':FzfGFiles?'                                      , 'modified-git-files'],
      \ 'h' : [':Telescope help_tags'                             , 'file-history'],
      \ 'H' : [':FzfHistory:'                                     , 'command-history'],
      \ 'l' : [':FzfLines'                                        , 'lines'],
      \ 'm' : [':Telescope marks'                                 , 'marks'],
      \ 'M' : [':FzfMaps'                                         , 'normal-maps'],
      \ 'p' : [':Telescope live_grep'                             , 'project-live-grep'],
      \ 'P' : [':FzfTags'                                         , 'project-tags'],
      \ 'r' : [':Telescope registers'                             , 'registers'],
      \ 's' : [':FzfSnippets'                                     , 'snippets'],
      \ 'S' : [':Telescope colorscheme'                           , 'color-schemes'],
      \ 't' : [':Rg'                                              , 'text-Rg'],
      \ 'T' : [':FzfBTags'                                        , 'buffer-tags'],
      \ 'v' : [':Telescope vim_options'                           , 'vim-options'],
      \ 'w' : [':FzfWindows'                                      , 'search-windows'],
      \ 'y' : [':Telescope filetypes'                             , 'file-types'],
      \ 'z' : [':FZF'                                             , 'FZF'],
      \ }

let g:which_key_map.S = {
      \ 'name' : '+session'                                       ,
      \ 'c' : [':SClose'                                          , 'close-session'],
      \ 'd' : [':SDelete'                                         , 'delete-session'],
      \ 'l' : [':SLoad'                                           , 'load-session'],
      \ 's' : [':Startify'                                        , 'start-page'],
      \ 'S' : [':SSave'                                           , 'save-session'],
      \ }

" t is for floaterm
let g:which_key_map.t = {
      \ 'name' : '+terminal'                                      ,
      \ ';' : [':FloatermNew'                                     , 'terminal'],
      \ 'a' : [':set scrolloff=999'                               , 'scrolloff'],
      \ 'd' : [':FloatermNew lazydocker'                          , 'docker'],
      \ 'f' : [':FloatermNew fzf'                                 , 'fzf'],
      \ 'g' : [':FloatermNew lazygit'                             , 'git'],
      \ 'h' : [':sp | te'                                         , 'horizontal-split-terminal'],
      \ 'n' : [':FloatermNew node'                                , 'node'],
      \ 'p' : [':FloatermNew python'                              , 'python'],
      \ 'r' : [':FloatermNew ranger'                              , 'ranger'],
      \ 's' : [':FloatermNew ncdu'                                , 'ncdu'],
      \ 't' : [':FloatermToggle'                                  , 'toggle'],
      \ 'v' : [':vs | te'                                         , 'vertical-split-terminal'],
      \ 'y' : [':FloatermNew btm'                                 , 'ytop'],
      \ }

" T is for tabline
let g:which_key_map.T = {
      \ 'name' : '+tabline'                                       ,
      \ 'b' : [':XTabListBuffers'                                 , 'list-buffers'],
      \ 'd' : [':XTabCloseBuffer'                                 , 'close-buffer'],
      \ 'D' : [':XTabDeleteTab'                                   , 'close-tab'],
      \ 'h' : [':XTabHideBuffer'                                  , 'hide-buffer'],
      \ 'i' : [':XTabInfo'                                        , 'info'],
      \ 'l' : [':XTabLock'                                        , 'lock-tab'],
      \ 'm' : [':XTabMode'                                        , 'toggle-mode'],
      \ 'n' : [':tabNext'                                         , 'next-tab'],
      \ 'N' : [':XTabMoveBufferNext'                              , 'buffer->'],
      \ 't' : [':tabnew'                                          , 'new-tab'],
      \ 'p' : [':tabprevious'                                     , 'prev-tab'],
      \ 'P' : [':XTabMoveBufferPrev'                              , '<-buffer'],
      \ 'x' : [':XTabPinBuffer'                                   , 'pin-buffer'],
      \ }

" u is for UI and toggle
let g:which_key_map.u = {
      \ 'name' : '+ui/toggle'                                     ,
      \ 'u' : [':UndotreeToggle'                                  , 'undo-tree'],
      \ }

" w is for windows
let g:which_key_map.w = {
      \ 'name' : '+windows'                                       ,
      \ '2' : ['<C-W>v'                                           , 'layout-double-columns'],
      \ ';' : ['<C-W>L'                                           , 'move-window-far-right'],
      \ '=' : ['<C-W>='                                           , 'balance-windows'],
      \ '?' : [':FzfWindows'                                      , 'fzf-window'],
      \ 'a' : ['<C-W>H'                                           , 'move-window-far-left'],
      \ 'd' : ['<C-W>c'                                           , 'delete-window'],
      \ 'h' : ['<C-W>h'                                           , 'window-left'],
      \ 'H' : ['<C-W>5<'                                          , 'expand-window-left'],
      \ 'i' : ['<C-W>K'                                           , 'move-window-far-top'],
      \ 'j' : ['<C-W>j'                                           , 'window-below'],
      \ 'J' : [':resize +5'                                       , 'expand-window-below'],
      \ 'k' : ['<C-W>k'                                           , 'window-up'],
      \ 'K' : [':resize  5'                                       , 'expand-window-up'],
      \ 'l' : ['<C-W>l'                                           , 'window-right'],
      \ 'L' : ['<C-W>5>'                                          , 'expand-window-right'],
      \ 'm' : [':MaximizerToggle'                                 , 'maximize-windows'],
      \ 'n' : ['<C-W>J'                                           , 'move-window-far-down'],
      \ 's' : ['<C-W>s'                                           , 'split-window-below'],
      \ 'v' : ['<C-W>v'                                           , 'split-window-right'],
      \ 'u' : ['<C-W>x'                                           , 'swap-window-next'],
      \ 'x' : ['call WindowSwap#EasyWindowSwap()'                 , 'mark-window-for-swap'],
      \ 'y' : ['call WindowSwap#MarkWindowSwap()'                 , 'mark-window-for-swap'],
      \ 'z' : ['call WindowSwap#DoWindowSwap()'                   , 'do-window-swap'],
      \ }

" q is quick-fix-list
let g:which_key_map.q = {
      \ 'name' : '+quick-fix-list'                                ,
      \ 'c' : [':cclose'                                          , 'close-qf-window'],
      \ 'n' : [':cn'                                              , 'next'],
      \ 'o' : [':copen'                                           , 'open-qf-window'],
      \ 'p' : [':cp'                                              , 'previous'],
      \ 'q' : [':qall'                                            , 'quit-vim'],
      \ }

" Register which key map
call which_key#register('<Space>', "g:which_key_map")
