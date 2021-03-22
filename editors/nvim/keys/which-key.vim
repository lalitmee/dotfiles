" Leader Key Maps

" Map leader to which_key
nnoremap <silent> <leader> :silent <c-u> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>

" By default timeoutlen is 1000 ms
" set timeoutlen=200

" options for which key
" let g:which_key_sep = '→'
let g:which_key_use_floating_win = 0
let g:which_key_disable_default_offset = 1
let g:which_key_hspace = 10
let g:which_key_centered = 0

" Create map to add keys to
let g:which_key_map =  {}


" Change the colors if you want
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function

" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

" Direct mappings {{{

let g:which_key_map[','] = [ 'w'                            , 'save' ]
let g:which_key_map['.'] = [ ':e $MYVIMRC'                  , 'open-init' ]
let g:which_key_map[';'] = [ ':Telescope commands'          , 'commands' ]
let g:which_key_map['x'] = [ 'q'                            , 'quit' ]
let g:which_key_map['z'] = [ 'Goyo'                         , 'zen' ]

" }}}

" Group mappings {{{

" a is for actions {{{

let g:which_key_map.a = {
      \ 'name' : '+actions'                                 ,
      \ 'c' : [':ColorizerToggle'                           , 'colorizer'],
      \ 'e' : [':NvimTreeToggle'                            , 'nvim-tree-exlporer'],
      \ 'f' : [':NvimTreeFindFile'                          , 'nvim-tree-find-file'],
      \ 'h' : [':Telescope frecency'                        , 'telescope-frecency'],
      \ 'l' : [':Bracey'                                    , 'start-live-server'],
      \ 'L' : [':BraceyStop'                                , 'stop-live-server'],
      \ 'm' : [':MarkdownPreview'                           , 'markdown-preview'],
      \ 'M' : [':MarkdownPreviewStop'                       , 'markdown-preview-stop'],
      \ 'p' : [':PlugHelp'                                  , 'plug-help'],
      \ 'r' : [':NvimTreeRefresh'                           , 'nvim-tree-refresh'],
      \ 't' : [':FloatermToggle'                            , 'terminal'],
      \ 'w' : [':StripWhitespace'                           , 'strip-whitespace'],
      \ }

" }}}

" b is for buffer {{{

let g:which_key_map.b = {
      \ 'name' : '+buffers'                                 ,
      \ ';' : [':BufferCloseBuffersRight'                   , 'close-all-right'],
      \ '[' : ['bp'                                         , 'prev-buffer'],
      \ ']' : ['bn'                                         , 'next-buffer'],
      \ 'a' : [':BufferCloseBuffersLeft'                    , 'close-all-left'],
      \ 'b' : [':FzfBuffers'                                , 'fzf-buffers'],
      \ 'B' : [':Telescope buffers'                         , 'telescope-buffers'],
      \ 'c' : ['vnew'                                       , 'new-empty-buffer-vert'],
      \ 'C' : [':BufferCloseAllButCurrent'                  , 'close-all-but-current'],
      \ 'd' : [':Sayonara!'                                 , 'delete-buffer'],
      \ 'D' : [':%bd'                                       , 'delete-all-buffers'],
      \ 'f' : ['bfirst'                                     , 'first-buffer'],
      \ 'g' : [':BufferlinePick'                            , 'goto-buffer'],
      \ 'h' : ['Startify'                                   , 'home-buffer'],
      \ 'j' : [':BufferPick'                                , 'buffer-pick'],
      \ 'l' : [':Telescope current_buffer_fuzzy_find'       , 'search-buffer-lines'],
      \ 'L' : ['blast'                                      , 'first-buffer'],
      \ 'm' : [':delm!'                                     , 'delete-marks'],
      \ 'n' : [':BufferLineCycleNext'                       , 'next-buffer'],
      \ 'N' : [':BufferLineMoveNext'                        , 'move-next-buffer'],
      \ 'o' : [':BufferLineSorByDirectory'                  , 'order-by-direcoty'],
      \ 'O' : [':BufferLineSortByExtension'                 , 'order-by-language'],
      \ 'p' : [':BufferLineCyclePrev'                       , 'previous-buffer'],
      \ 'P' : [':BufferLineMovePrev'                        , 'move-previous-buffer'],
      \ 'r' : ['e'                                          , 'refresh-buffer'],
      \ 'R' : ['bufdo :e'                                   , 'refresh-loaded-buffers'],
      \ 's' : ['new'                                        , 'new-empty-buffer'],
      \ 'w' : [':Sayonara'                                  , 'close-buffer-and-window'],
      \ }

" }}}

" c is for lsp code {{{

let g:which_key_map.c = {
      \ 'name' : '+coc'                                   ,
      \ 'a' : [':CocAction'                               , 'action'],
      \ 'c' : [':CocCommand'                              , 'commands'],
      \ 'd' : [':CocDiagnostics'                          , 'diagnostics'],
      \ 'e' : [':CocConfig'                               , 'config'],
      \ 'f' : [':CocFix'                                  , 'fix'],
      \ 'i' : [':CocInfo'                                 , 'info'],
      \ 'l' : {
        \ 'name' : '+list'                                ,
        \ '"' : [':CocList registers'                     , 'registers'],
        \ '/' : [':CocList searchhistory'                 , 'search-history'],
        \ ';' : [':CocList commands'                      , 'commands'],
        \ 'a' : [':CocList sessions'                      , 'sessions'],
        \ 'b' : [':CocList buffers'                       , 'buffers'],
        \ 'c' : [':CocList colors'                        , 'colorschemes'],
        \ 'd' : [':CocList folders'                       , 'workspace-directories'],
        \ 'e' : [':CocList diagnostics'                   , 'diagnostics'],
        \ 'E' : [':CocList extensions'                    , 'extensions'],
        \ 'f' : [':CocList files'                         , 'files'],
        \ 'g' : [':CocList branches'                      , 'branches'],
        \ 'h' : [':CocList cmd_history'                   , 'command-history'],
        \ 'H' : [':CocList helptags'                      , 'help-tags'],
        \ 'j' : [':CocList'                               , 'lists'],
        \ 'k' : [':CocList maps'                          , 'mappings'],
        \ 'l' : [':CocList fuzzy_lines'                   , 'buffer-fuzzy-lines'],
        \ 'L' : [':CocList links'                         , 'buffer-links'],
        \ 'm' : [':CocList marketplace'                   , 'marketplace'],
        \ 'M' : [':CocList marks'                         , 'marks'],
        \ 'o' : [':CocList locationlist'                  , 'location-list'],
        \ 'q' : [':CocList quickfix'                      , 'quickfix-list'],
        \ 'r' : [':CocList mru'                           , 'mru'],
        \ 's' : [':CocList outline'                       , 'buffer-symbols'],
        \ 'S' : [':CocList symbols'                       , 'workspace-symbols'],
        \ 't' : [':CocList floaterm'                      , 'floaterm'],
        \ 'v' : [':CocList vimcommands'                   , 'vim-commands'],
        \ 'w' : [':CocList windows'                       , 'windows'],
        \ 'W' : [':CocList words'                         , 'buffer-words'],
        \ 'z' : [':CocList tags'                          , 'tag-files'],
      \ },
      \ 'm' : {
        \ 'name' : '+fzf-list'                            ,
        \ 'a' : [':CocFzfList actions'                    , 'actions'],
        \ 'b' : [':CocFzfList symbols'                    , 'symbols'],
        \ 'c' : [':CocFzfList commands'                   , 'commands'],
        \ 'd' : [':CocFzfList diagnostics'                , 'diagnostics'],
        \ 'e' : [':CocFzfList diagnostics --current-buf'  , 'buffer-diagnostics'],
        \ 'g' : [':CocFzfList issues'                     , 'issues'],
        \ 'i' : [':CocFzfList snippets'                   , 'snippets'],
        \ 'l' : [':CocFzfList location'                   , 'locations'],
        \ 'o' : [':CocFzfList outline'                    , 'outline'],
        \ 'r' : [':CocFzfListResume'                      , 'resume-list'],
        \ 's' : [':CocFzfList services'                   , 'services'],
        \ 'u' : [':CocFzfList output'                     , 'output'],
        \ 'v' : [':CocFzfList sources'                    , 'sources'],
        \ 'y' : [':CocFzfList yank'                       , 'yank'],
      \ },
      \ 'r' : [':call coc#refresh()'                      , 'coc-refresh'],
      \ 'R' : [':CocListResume '                          , 'list-resume'],
      \ 's' : [':CocSearch'                               , 'search'],
      \ 'x' : ['<Plug>(coc-convert-snippet)'              , 'covert-to-snippet'],
      \ }

" let g:which_key_map.c = {
"       \ 'name' : '+code'                                ,
"       \ 'a' : [':Lspsaga code_action'                   , 'code-action'],
"       \ 'A' : [':Lspsaga range_code_action'             , 'range-code-action'],
"       \ 'b' : [':Telescope lsp_code_actions'            , 'lsp-code-actions'],
"       \ 'B' : [':Telescope lsp_range_code_actions'      , 'lsp-range-code-actions'],
"       \ 'c' : [':Lspsaga close_floatterm'               , 'close-floatterm'],
"       \ 'd' : [':Telescope lsp_definitions'             , 'lsp-definitions'],
"       \ 'e' : [':Telescope lsp_document_diagnostics'    , 'lsp-document-diagnostics'],
"       \ 'E' : [':Telescope lsp_workspace_diagnostics'   , 'lsp-workspace-diagnostics'],
"       \ 'h' : [':Lspsaga hover_doc'                     , 'hover-doc'],
"       \ 'o' : [':Lspsaga open_floatterm'                , 'open-floatterm'],
"       \ 'p' : [':Lspsaga preview_definition'            , 'preview-definition'],
"       \ 'r' : [':Telescope lsp_references'              , 'lsp-references'],
"       \ 'R' : [':Lspsaga lsp_finder'                    , 'references'],
"       \ 's' : [':Lspsaga signaute_help'                 , 'signature-help'],
"       \ 't' : [':Telescope treesitter'                  , 'treesitter-symbols'],
"       \ 'w' : [':Telescope lsp_document_symbols'        , 'lsp-document-symbols'],
"       \ 'W' : [':Telescope lsp_workspace_symbols'       , 'lsp-workspace-symbols'],
"       \ }

" }}}

" e is for error and warnings with errors/warnings {{{

let g:which_key_map.e = {
      \ 'name' : '+errors/warnings'                         ,
      \ 'l' : [':Telescope lsp_workspace_diagnostics'       , 'list-errors/warnings'],
      \ 'n' : [':Lspsaga diagnostic_jump_next'              , 'next-diagnostic'],
      \ 'p' : [':Lspsaga diagnostic_jump_prev'              , 'prev-diagnostic'],
      \ 'L' : [':Lspsaga show-line-diagnostics'             , 'line-diagnostic'],
      \ }

" }}}

" f is for FZF {{{

let g:which_key_map.f = {
      \ 'name' : '+FZF'                                     ,
      \ 'a' : [':FzfAg'                                     , 'ag'],
      \ 'b' : {
        \ 'name' : '+buffers'                               ,
        \ 'c' : [':CustomFzfBuffers'                        , 'custom-buffers'],
        \ 'b' : [':FzfBuffers'                              , 'jump-buffers'],
        \ 'l' : [':FzfBLines'                               , 'buffer-lines'],
        \ 'L' : [':FzfLines'                                , 'loaded-buffers-lines'],
      \ },
      \ 'd' : [':RG'                                        , 'rg'],
      \ 'f' : {
        \ 'name' : '+files'                                 ,
        \ 'f' : [':FzfFiles'                                , 'files'],
        \ 'g' : [':FzfGFiles'                               , 'git-files'],
        \ 's' : [':FzfGFiles?'                              , 'git-status-files'],
        \ 'd' : [':FzfDotfiles'                             , 'dotfiles'],
        \ 'n' : [':FzfNvimConfig'                           , 'neovim-config'],
        \ 'p' : [':FzfSwitchProjectFile'                    , 'switch-files'],
      \ },
      \ 'g' : {
        \ 'name' : '+git'                                   ,
        \ 'b' : [':FzfBCommits'                             , 'buffer-commits'],
        \ 'B' : [':FzfCommits'                              , 'commits'],
        \ 'c' : [':FzfGBranches'                            , 'git-branches'],
      \ },
      \ 'h' : [':FzfHistory'                                , 'history'],
      \ 'i' : [':FzfSnippets'                               , 'snippets'],
      \ 'j' : {
        \ 'name' : '+search'                                ,
        \ 'c' : [':RG'                                      , 'search-content'],
        \ 'd' : [':FzfRg'                                   , 'default-rg'],
        \ 'f' : [':Rg'                                      , 'custom-rg'],
      \ },
      \ 'p' : [':FzfSwitchProject'                          , 'projects'],
      \ 'L' : [':FzfLocate '                                , 'locate'],
      \ 't' : [':FzfBTags'                                  , 'buffer-tags'],
      \ 'T' : [':FzfTags'                                   , 'project-tags'],
      \ 'l' : {
        \ 'name' : '+nvim-lsp'                              ,
        \ 'a' : [':FzfCodeActions'                          , 'code-actions'],
        \ 'A' : [':FzfRangeCodeActions'                     , 'code-actions'],
        \ 'c' : [':FzfIncomingCalls'                        , 'incoming-calls'],
        \ 'C' : [':FzfOutgoingCalls'                        , 'outgoing-calls'],
        \ 'd' : [':FzfDefinitions'                          , 'definitions'],
        \ 'D' : [':FzfDeclarations'                         , 'delcarations'],
        \ 'e' : [':FzfDiagnostics'                          , 'diagnostics'],
        \ 'i' : [':FzfImplementations'                      , 'implementations'],
        \ 'r' : [':FzfReferences'                           , 'references'],
        \ 't' : [':FzfTypeDefinitions'                      , 'type-definition'],
        \ 'w' : [':FzfDocumentSymbols'                      , 'document-symbols'],
        \ 'W' : [':FzfWorkspaceSymbols'                     , 'workspace-symbols'],
      \ },
      \ 's' : [':w'                                         , 'save-buffer'],
      \ 'S' : [':wa'                                        , 'save-all-buffers'],
      \ 'v' : {
        \ 'name' : '+vim'                                   ,
        \ '/' : [':FzfHistory/'                             , 'search-history'],
        \ ':' : [':FzfHistory:'                             , 'command-history'],
        \ ';' : [':FzfCommands'                             , 'command-history'],
        \ 'c' : [':FzfColors'                               , 'colorschemes'],
        \ 'f' : [':FzfFiletypes'                            , 'filetypes'],
        \ 'h' : [':FzfHelptags'                             , 'help-tags'],
        \ 'm' : [':FzfMarks'                                , 'marks'],
        \ 'M' : [':FzfMaps'                                 , 'maps'],
      \ },
      \ 'w' : [':FzfWindows'                                , 'windows'],
      \ }

" }}}

" g is for git {{{

let g:which_key_map.g = {
      \ 'name' : '+git'                                     ,
      \ 'a' : [':Git add .'                                 , 'add-all'],
      \ 'A' : [':Git add %'                                 , 'add-current'],
      \ 'b' : [':GBrowse'                                   , 'browse'],
      \ 'B' : [':GitBlameToggle'                            , 'blame'],
      \ 'C' : [':Git commit'                                , 'commit'],
      \ 'c' : [':Telescope git_branches'                    , 'checkout'],
      \ 'd' : [':Git diff'                                  , 'diff'],
      \ 'D' : [':Gdiffsplit'                                , 'diff-split'],
      \ 'g' : {
        \ 'name' : '+gists'                                 ,
        \ 'c' : ['<Plug>fov_new'                            , 'create-new-gist'],
        \ 'l' : ['<Plug>fov_list'                           , 'list-gists'],
        \ 'u' : ['<Plug>fov_update'                         , 'update-gist'],
        \ 'v' : ['<Plug>fov_visual_new'                     , 'create-new-from-visual'],
      \ },
      \ 'G' : [':Gstatus'                                   , 'status'],
      \ 'h' : {
        \ 'name' : '+hunks'                                 ,
      \ },
      \ 'l' : [':Git log'                                   , 'log'],
      \ 'm' : ['<Plug>(git-messenger)'                      , 'git-messenger'],
      \ 'p' : [':Git push'                                  , 'push'],
      \ 'P' : [':Git pull'                                  , 'pull'],
      \ 'R' : [':GRemove'                                   , 'remove'],
      \ 's' : [':Neogit'                                    , 'status'],
      \ 'S' : [':GGrep'                                     , 'git-grep'],
      \ 'v' : [':GV'                                        , 'view-commits'],
      \ 'V' : [':GV!'                                       , 'view-buffer-commits'],
      \ }

" }}}

" G is goneovim {{{

let g:which_key_map.G = {
      \ 'name' : '+goneovim'                                ,
      \ 'a' : [':GonvimFuzzyAg'                             , 'fuzzy-ag'],
      \ 'b' : [':GonvimFuzzyBuffers'                        , 'fuzzy-buffers'],
      \ 'f' : [':GonvimFuzzyFiles'                          , 'fuzzy-files'],
      \ 'F' : [':GonvimFilerOpen'                           , 'external-file-explorer'],
      \ 'l' : [':GonvimFuzzyBLines'                         , 'fuzzy-buffer-lines'],
      \ 'm' : [':GonvimMarkdown'                            , 'markdown-preview'],
      \ 'M' : [':GonvimMiniMap'                             , 'toggle-minimap'],
      \ 'n' : [':GonvimWorkspaceNext'                       , 'next-workspace'],
      \ 'N' : [':GonvimWorkspaceNew'                        , 'create-new-workspace'],
      \ 'p' : [':GonvimWorkspacePrevious'                   , 'previous-workspace'],
      \ 'r' : [':GonvimFuzzyResume'                         , 'resume-previous-search'],
      \ 's' : [':GonvimWorkspaceSwitch '                    , 'switch-workspace'],
      \ }

"}}}

" j is AnyJump {{{

let g:which_key_map.j = {
      \ 'name' : '+any-jump'                                ,
      \ 'j' : [':AnyJump'                                   , 'current-word'],
      \ 'l' : [':HopLine'                                   , 'hop-line'],
      \ 'L' : [':AnyJumpBack'                               , 'back'],
      \ 'p' : [':HopPattern'                                , 'hop-pattern'],
      \ 'r' : [':AnyJumpLastResults'                        , 'last-results'],
      \ 's' : [':AnyJumpRunSpecs'                           , 'run-specs'],
      \ 'v' : [':AnyJumpVisual'                             , 'visual-selection'],
      \ 'w' : [':HopWord'                                   , 'hop-word'],
      \ 'c' : [':HopChar1'                                  , 'hop-char-1'],
      \ 'd' : [':HopChar2'                                  , 'hop-char-2'],
      \ }

" }}}

" l is for language server protocol {{{

" let g:which_key_map.l = {
"       \ 'name' : '+lsp'                                 ,
"       \ 'a' : [':Lspsaga code_action'                   , 'code-action'],
"       \ 'A' : [':Lspsaga range_code_action'             , 'range-code-action'],
"       \ 'd' : [':Lspsaga hover_doc'                     , 'hover-doc'],
"       \ 'e' : {
"         \ 'name' : '+diagnostics'                       ,
"         \ 'l' : [':Lspsaga show_line_diagnostics'       , 'show-line-diagnostics'],
"         \ 'n' : [':Lspsaga diagnostic_jump_next'        , 'next-diagnostic'],
"         \ 'p' : [':Lspsaga diagnostic_jump_prev'        , 'prev-diagnostic'],
"       \ },
"       \ 'i' : [':LspInfo'                               , 'lsp-info'],
"       \ 'l' : [':Lspsaga lsp_finder'                    , 'finder'],
"       \ 'p' : [':Lspsaga preview_definition'            , 'preview-definition'],
"       \ 'r' : [':lua MyLspRename()'                     , 'rename'],
"       \ 's' : [':Lspsaga signature_help'                , 'signature-help'],
"       \ 't' : [':Lspsaga open_floatterm'                , 'open-floatterm'],
"       \ 'T' : [':Lspsaga close_floatterm'               , 'close-floatterm'],
"       \ 'v' : {
"         \ 'name' : '+vista'                             ,
"           \ 'a' : [':Vista ale'                         , 'ale'],
"           \ 'A' : [':Vista finder fzf:ale'              , 'fzf:ale'],
"           \ 'c' : [':Vista coc'                         , 'coc'],
"           \ 'C' : [':Vista finder fzf:coc'              , 'fzf:coc'],
"           \ 'f' : [':Vista finder'                      , 'finder'],
"           \ 'F' : [':Vista finder!'                     , 'finder!'],
"           \ 'g' : [':Vista ctags'                       , 'ctags'],
"           \ 'G' : [':Vista finder skim:ctags'           , 'skim:ctags'],
"           \ 'i' : [':Vista info'                        , 'info'],
"           \ 'I' : [':Vista info+'                       , 'info+'],
"           \ 'j' : [':Vista focus'                       , 'focus'],
"           \ 'n' : [':Vista nvim_lsp'                    , 'nvim-lsp'],
"           \ 'N' : [':Vista finder fzf:nvim_lsp'         , 'fzf:nvim_lsp'],
"           \ 's' : [':Vista show'                        , 'show'],
"           \ 't' : [':Vista!!'                           , 'toggle-vista'],
"           \ 'u' : [':Vista vim_lsc'                     , 'vim_lsc'],
"           \ 'v' : [':Vista vim_lsp'                     , 'vim_lsp'],
"       \ },
"       \ 'w' : {
"         \ 'name' : '+workspace'                         ,
"         \ 'a' : [':LspAddToWorkspaceFolder'             , 'add-folder-to-workspace'],
"         \ 'l' : [':LspListWorkspaceFolders'             , 'list-workspace-folders'],
"         \ 'r' : [':LspRemoveWorkspaceFolder'            , 'remove-workspace-folder'],
"         \ 's' : [':LspWorkspaceSymbols'                 , 'workspace-symbols'],
"       \ },
"       \ }

let g:which_key_map.l = {
      \ 'name' : '+lsp'                                   ,
      \ '.' : [':CocConfig'                               , 'config'],
      \ ';' : ['<Plug>(coc-refactor)'                     , 'refactor'],
      \ 'a' : ['<Plug>(coc-codeaction)'                   , 'line-action'],
      \ 'A' : ['<Plug>(coc-codeaction-selected)'          , 'selected-action'],
      \ 'b' : [':CocNext'                                 , 'next-action'],
      \ 'B' : [':CocPrev'                                 , 'prev-action'],
      \ 'c' : [':CocList commands'                        , 'commands'],
      \ 'd' : ['<Plug>(coc-definition)'                   , 'definition'],
      \ 'D' : ['<Plug>(coc-declaration)'                  , 'declaration'],
      \ 'e' : [':CocList extensions'                      , 'extensions'],
      \ 'f' : ['<Plug>(coc-format-selected)'              , 'format-selected'],
      \ 'F' : ['<Plug>(coc-format)'                       , 'format'],
      \ 'h' : ['<Plug>(coc-float-hide)'                   , 'hide'],
      \ 'i' : ['<Plug>(coc-implementation)'               , 'implementation'],
      \ 'I' : [':CocList diagnostics'                     , 'diagnostics'],
      \ 'j' : ['<Plug>(coc-float-jump)'                   , 'float-jump'],
      \ 'l' : ['<Plug>(coc-codelens-action)'              , 'code-lens'],
      \ 'n' : ['<Plug>(coc-diagnostic-next)'              , 'next-diagnostic'],
      \ 'N' : ['<Plug>(coc-diagnostic-next-error)'        , 'next-error'],
      \ 'o' : [':Vista!!'                                 , 'outline'],
      \ 'O' : [':CocList outline'                         , 'outline'],
      \ 'p' : ['<Plug>(coc-diagnostic-prev)'              , 'prev-diagnostic'],
      \ 'P' : ['<Plug>(coc-diagnostic-prev-error)'        , 'prev-error'],
      \ 'q' : ['<Plug>(coc-fix-current)'                  , 'quickfix'],
      \ 'R' : ['<Plug>(coc-references)'                   , 'references'],
      \ 'r' : ['<Plug>(coc-rename)'                       , 'rename-symbol'],
      \ 's' : [':CocList -I symbols'                      , 'symbols'],
      \ 'S' : [':CocList snippets'                        , 'snippets'],
      \ 't' : ['<Plug>(coc-type-definition)'              , 'type-definition'],
      \ 'u' : [':CocListResume'                           , 'resume-list'],
      \ 'U' : [':CocUpdate'                               , 'update-CoC'],
      \ 'z' : [':CocDisable'                              , 'disable-CoC'],
      \ 'Z' : [':CocEnable'                               , 'enable-CoC'],
      \ }

" }}}

" L is for language server protocol {{{

let g:which_key_map.L = {
      \ 'name' : '+lsp'                                     ,
      \ 'a' : [':LspCodeActions'                            , 'code-action'],
      \ 'A' : [':LspRangeCodeActions'                       , 'range-code-action'],
      \ 'e' : {
        \ 'name' : '+diagnostics'                           ,
        \ 'a' : [':LspGetAllDiagnostics'                    , 'all-diagnostics'],
        \ 'l' : [':LspShowLineDiagnostics'                  , 'show-line-diagnostics'],
        \ 'n' : [':LspGotoNextDiagnostic'                   , 'next-diagnostic'],
        \ 'N' : [':LspGetNextDiagnostic'                    , 'get-next-diagnostic'],
        \ 'p' : [':LspGotoPrevDiagnostic'                   , 'prev-diagnostic'],
        \ 'P' : [':LspGetPrevDiagnostic'                    , 'get-prev-diagnostic'],
      \ },
      \ 'f' : {
        \ 'name' : '+formatting'                            ,
        \ 'f' : [':LspFormatting'                           , 'formatting'],
        \ 'r' : [':LspRangeFormatting'                      , 'range-formatting'],
        \ 's' : [':LspFormattingSync'                       , 'formatting-sync'],
      \ },
      \ 'g' : {
        \ 'name' : '+definitions/references'                ,
        \ 'c' : [':LspClearReferences'                      , 'clear-references'],
        \ 'd' : [':LspDefinition'                           , 'definition'],
        \ 'i' : [':LspDeclaration'                          , 'declaration'],
        \ 'r' : [':LspReferences'                           , 'references'],
        \ 't' : [':LspTypeDefinition'                       , 'type-definition'],
      \ },
      \ 'h' : [':LspHover'                                  , 'hover-doc'],
      \ 'H' : [':LspDocumentHighlight'                      , 'document-highlight'],
      \ 'i' : [':LspIncomingCalls'                          , 'incoming-calls'],
      \ 'o' : [':LspOutGoingCalls'                          , 'outgoing-calls'],
      \ 'r' : [':LspRename'                                 , 'rename'],
      \ 's' : [':LspDocumentSymbols'                        , 'document-symbols'],
      \ 'S' : [':LspWorkspaceSymbols'                       , 'document-symbols'],
      \ 'w' : {
        \ 'name' : '+workspace'                             ,
        \ 'a' : [':LspAddToWorkspaceFolder'                 , 'add-folder-to-workspace'],
        \ 'l' : [':LspListWorkspaceFolders'                 , 'list-workspace-folders'],
        \ 'r' : [':LspRemoveWorkspaceFolder'                , 'remove-workspace-folder'],
        \ 's' : [':LspWorkspaceSymbols'                     , 'workspace-symbols'],
      \ },
      \ 'y' : [':LspImplementation'                         , 'implementation'],
      \ }

" }}}

" m is major mode {{{

let g:which_key_map.m = {
      \ 'name' : '+major-mode'                              ,
      \ 'a' : [':Telescope lsp_code_actions'                , 'code-actions'],
      \ 'b' : [':Telescope lsp_range_code_actions'          , 'range-code-actions'],
      \ 'c' : [':MakeTags'                                  , 'make-ctags'],
      \ 'd' : [':Telescope lsp_document_diagnostics'        , 'document-diagnostics'],
      \ 'D' : [':Telescope lsp_workspace_diagnostics'       , 'workspace-diagnostics'],
      \ 'f' : [':Telescope lsp_references'                  , 'references'],
      \ 'j' : [':Telescope lsp_workspace_symbols'           , 'workspace-symbols'],
      \ 'l' : ['<Plug>(JsConsoleLog)'                       , 'console-log'],
      \ 'r' : [':LspRename'                                 , 'rename-symbol'],
      \ 's' : [':Telescope lsp_document_symbols'            , 'buffer-symbols'],
      \ }

" }}}

" n is Neovim {{{

let g:which_key_map.n = {
      \ 'name' : '+neovim'                                  ,
      \ 'c' : [':PlugClean'                                 , 'clean-packages'],
      \ 'e' : [':e $MYVIMRC'                                , 'edit-config'],
      \ 'i' : [':PlugInstall'                               , 'install-packages'],
      \ 'r' : [':so $MYVIMRC'                               , 'source-config'],
      \ 's' : [':PlugSnapshot'                              , 'plug-snapshot'],
      \ 'u' : [':PlugUpdate'                                , 'update-packages'],
      \ 'U' : [':PlugUpgrade'                               , 'upgrade-plug'],
      \ }

" }}}

" o is Telescope {{{

let g:which_key_map.o = {
      \ 'name' : '+Telescope'                               ,
      \ 'b' : {
        \ 'name' : '+buffers'                               ,
        \ 'a' : [':Telescope lsp_code_actions'              , 'code-actions'],
        \ 'b' : [':Telescope buffers'                       , 'buffers'],
        \ 'c' : [':Telescope lsp_range_code_actions'        , 'range-code-actions'],
        \ 'd' : [':Telescope lsp_document_symbols'          , 'buffer-symbols'],
        \ 'j' : [':Telescope lsp_workspace_symbols'         , 'workspace-symbols'],
        \ 'l' : [':Telescope current_buffer_fuzzy_find'     , 'buffer-lines'],
        \ 'r' : [':Telescope lsp_references'                , 'references'],
        \ 's' : [':Telescope spell_suggest'                 , 'spell_suggest'],
        \ 't' : [':Telescope current_buffer_tags'           , 'buffer-tags'],
      \ },
      \ 'c' : {
        \ 'name' : '+cheat.sh'                              ,
        \ 'f' : [':Telescope cheat fd'                      , 'cheat-find'],
        \ 'r' : [':Telescope cheat readcache'               , 'read-cache'],
      \ },
      \ 'd' : {
        \ 'name' : '+dap'                                   ,
        \ 'b' : [':Telescope dap lsp_breakpoints'           , 'lsp-breakpoints'],
        \ 'c' : [':Telescope dap configurations'            , 'configurations'],
        \ 'f' : [':Telescope dap frames'                    , 'frames'],
        \ 'o' : [':Telescope dap commands'                  , 'commands'],
        \ 'v' : [':Telescope dap variables'                 , 'variables'],
      \ },
      \ 'e' : [':Telescope symbols'                         , 'symbols'],
      \ 'f' : {
        \ 'name' : '+files'                                 ,
        \ 'e' : [':Telescope file_browser'                  , 'file-browser'],
        \ 'f' : [':Telescope fzf_writer files'              , 'fzf-writer-files'],
        \ 'g' : [':Telescope git_files'                     , 'git-files'],
        \ 'h' : [':Telescope frecency'                      , 'telescope-frecency'],
        \ 'm' : [':Telescope media_files'                   , 'media-files'],
        \ 'o' : [':Telescope find_files'                    , 'find-files'],
        \ 'r' : [':Telescope oldfiles'                      , 'recent-files'],
        \ 'z' : [':Telescope filetypes'                     , 'filetypes'],
      \ },
      \ 'g' : {
        \ 'name' : '+git'                                   ,
        \ 'b' : [':Telescope git_branches'                  , 'git-branches'],
        \ 'C' : [':Telescope git_bcommits'                  , 'git-buffer-commits'],
        \ 'd' : [':Telescope git_commits'                   , 'git-commits'],
        \ 'f' : [':Telescope git_files'                     , 'git-files'],
        \ 's' : [':Telescope git_status'                    , 'git-status'],
      \ },
      \ 'i' : [':Telescope snippets snippets'               , 'snippets'],
      \ 'j' : [':Telescope jumps jumps'                     , 'jumps'],
      \ 'l' : [':Telescope loclist'                         , 'loclist'],
      \ 'm' : [':Telescope man_pages'                       , 'man-pages'],
      \ 'o' : [':Telescope openbrowser list'                , 'openbrowser'],
      \ 's' : {
        \ 'name' : '+search'                                ,
        \ 'b' : [':Telescope current_buffer_fuzzy_find'     , 'buffer-lines'],
        \ 'l' : [':Telescope live_grep'                     , 'live-grep'],
        \ 's' : [':Telescope fzf_writer grep'               , 'fzf-writer-grep'],
        \ 'u' : [':Telescope grep_string'                   , 'grep-string'],
      \ },
      \ 't' : {
        \ 'name' : '+telescope'                             ,
        \ 'b' : [':Telescope builtin'                       , 'builtins'],
        \ 'p' : [':Telescope planets'                       , 'planets'],
        \ 'r' : [':Telescope reloader'                      , 'reloaders'],
        \ 't' : [':Telescope treesitter'                    , 'reloaders'],
      \ },
      \ 'u' : [':Telescope ultisnips ultisnips'             , 'ultisnips'],
      \ 'v' : {
        \ 'name' : '+vim'                                   ,
        \ ';' : [':Telescope commands'                      , 'commands'],
        \ 'a' : [':Telescope autocommands'                  , 'autocommands'],
        \ 'c' : [':Telescope colorscheme'                   , 'colorschemes'],
        \ 'h' : [':Telescope command_history'               , 'commands-history'],
        \ 'H' : [':Telescope highlights'                    , 'highlights'],
        \ 'k' : [':Telescope keymaps'                       , 'keymaps'],
        \ 'm' : [':Telescope marks'                         , 'marks'],
        \ 'r' : [':Telescope registers'                     , 'vim-registers'],
        \ 't' : [':Telescope help_tags'                     , 'help-tags'],
        \ 'v' : [':Telescope vim_options'                   , 'vim-options'],
      \ },
      \ }

" }}}

" p is for Project {{{

let g:which_key_map.p = {
      \ 'name' : '+project'                                 ,
      \ 'a' : [':FzfAg'                                     , 'project-search'],
      \ 'b' : [':Telescope buffers'                         , 'find-buffers'],
      \ 'f' : [':Telescope fzf_writer files'                , 'find-files'],
      \ 'g' : [':Telescope git_files'                       , 'find-git-files'],
      \ 'r' : [':Telescope frecency'                        , 'old-files'],
      \ 'p' : [':Telescope project project'                 , 'switch-project'],
      \ 's' : [':Telescope fzf_writer grep'                 , 'project-search'],
      \ 'S' : [':Telescope live_grep'                       , 'project-search'],
      \ 'w' : [':Telescope grep_string'                     , 'string-search'],
      \ }
      " \ 'n' : [':Telescope node_modules list'             , 'list-project-nodes-modules'],
      " \ 't' : [':Telescope symbols'                       , 'symbols'],

" }}}

" q is quick-fix-list {{{

let g:which_key_map.q = {
      \ 'name' : '+quick-fix-list'                          ,
      \ 'c' : [':cclose'                                    , 'close-qf-window'],
      \ 'n' : [':cn'                                        , 'next'],
      \ 'o' : [':copen'                                     , 'open-qf-window'],
      \ 'p' : [':cp'                                        , 'previous'],
      \ 'q' : [':qall'                                      , 'quit-vim'],
      \ 'l' : [':Telescope quickfix'                        , 'fuzzy-quickfix'],
      \ }

" }}}

" s is for search {{{

let g:which_key_map.s = {
      \ 'name' : '+search'                                  ,
      \ '/' : [':Telescope command_history'                 , 'history'],
      \ ';' : [':Telescope commands'                        , 'commands'],
      \ 'a' : [':FzfAg'                                     , 'text-Ag'],
      \ 'b' : [':Telescope current_buffer_fuzzy_find'       , 'current-buffer'],
      \ 'B' : [':Telescope buffers'                         , 'open-buffers'],
      \ 'c' : [':Telescope git_commits'                     , 'commits'],
      \ 'C' : [':Telescope git_bcommits'                    , 'buffer-commits'],
      \ 'd' : [':Telescope git_files'                       , 'git-files'],
      \ 'f' : [':Telescope find_files'                      , 'files'],
      \ 'g' : {
      \ 'name' : '+goneovim'                                ,
        \ 'a' : [':GonvimFuzzyAg'                           , 'fuzzy-ag'],
        \ 'b' : [':GonvimFuzzyBuffers'                      , 'fuzzy-buffers'],
        \ 'f' : [':GonvimFuzzyFiles'                        , 'fuzzy-files'],
        \ 'F' : [':GonvimFilerOpen'                         , 'external-file-explorer'],
        \ 'l' : [':GonvimFuzzyBLines'                       , 'fuzzy-buffer-lines'],
        \ 'm' : [':GonvimMarkdown'                          , 'markdown-preview'],
        \ 'M' : [':GonvimMiniMap'                           , 'toggle-minimap'],
        \ 'n' : [':GonvimWorkspaceNext'                     , 'next-workspace'],
        \ 'N' : [':GonvimWorkspaceNew'                      , 'create-new-workspace'],
        \ 'p' : [':GonvimWorkspacePrevious'                 , 'previous-workspace'],
        \ 'r' : [':GonvimFuzzyResume'                       , 'resume-previous-search'],
        \ 's' : [':GonvimWorkspaceSwitch '                  , 'switch-workspace'],
        \ },
      \ 'G' : [':Telescope git_status'                      , 'modified-git-files'],
      \ 'h' : [':Telescope help_tags'                       , 'file-history'],
      \ 'H' : [':Telescope command_history'                 , 'command-history'],
      \ 'l' : [':FzfLines'                                  , 'lines'],
      \ 'm' : [':Telescope marks'                           , 'marks'],
      \ 'M' : [':Telescope keymaps'                         , 'keymaps'],
      \ 'p' : [':Telescope fzf_writer grep'                 , 'fzf-live-grep'],
      \ 'P' : [':Telescope live_grep'                       , 'live-grep'],
      \ 'r' : [':Telescope registers'                       , 'registers'],
      \ 's' : [':Telescope ultisnips ultisnips'             , 'snippets'],
      \ 'S' : [':Telescope colorscheme'                     , 'color-schemes'],
      \ 't' : [':Telescope tags'                            , 'project-tags'],
      \ 'T' : [':FzfBTags'                                  , 'buffer-tags'],
      \ 'v' : [':Telescope vim_options'                     , 'vim-options'],
      \ 'w' : [':FzfWindows'                                , 'search-windows'],
      \ 'y' : [':Telescope filetypes'                       , 'file-types'],
      \ 'z' : [':FZF'                                       , 'FZF'],
      \ }

" }}}

" S is for sesstions {{{

let g:which_key_map.S = {
      \ 'name' : '+session'                                 ,
      \ 'c' : [':SClose'                                    , 'close-session'],
      \ 'd' : [':SDelete'                                   , 'delete-session'],
      \ 'l' : [':SLoad'                                     , 'load-session'],
      \ 's' : [':SSave'                                     , 'save-session'],
      \ 'S' : [':Startify'                                  , 'start-page'],
      \ }

" }}}

" t is for toggle {{{

let g:which_key_map.t = {
      \ 'name' : '+toggle'                                  ,
      \ 't' : [':FloatermNew'                               , 'terminal'],
      \ 'f' : {
        \ 'name' : '+floaterm'                              ,
          \ 'G' : [':FloatermNew tig'                       , 'tig'],
          \ 'a' : [':FloatermNew terminal_velocity'         , 'terminal_velocity'],
          \ 'd' : [':FloatermNew lazydocker'                , 'docker'],
          \ 'f' : [':FloatermNew fzf'                       , 'fzf'],
          \ 'g' : [':FloatermNew lazygit'                   , 'git'],
          \ 'n' : [':FloatermNew node'                      , 'node'],
          \ 'p' : [':FloatermNew python'                    , 'python'],
          \ 'r' : [':FloatermNew ranger'                    , 'ranger'],
          \ 's' : [':FloatermNew ncdu'                      , 'ncdu'],
          \ 't' : [':FloatermToggle'                        , 'toggle'],
          \ 'v' : [':FloatermNew grv'                       , 'grv'],
          \ 'w' : [':FloatermNew wt'                        , 'weather'],
          \ 'y' : [':FloatermNew btm'                       , 'ytop'],
      \ },
      \ 's' : {
        \ 'name' : '+scrolloff'                             ,
          \ 't' : [':set scrolloff=10'                      , 'scrolloff=10'],
          \ 'h' : [':set scrolloff=5'                       , 'scrolloff=5'],
          \ 'n' : [':set scrolloff=999'                     , 'scrolloff=999'],
      \ },
      \ 'h' : [':sp | te'                                   , 'horizontal-split-terminal'],
      \ 'v' : [':vs | te'                                   , 'vertical-split-terminal'],
      \ }

" }}}

" T is for tmux-runner {{{

let g:which_key_map.T = {
      \ 'name' : '+tmux-runner'                             ,
      \ 'a' : [':VtrAttachToPane'                           , 'attach-pane'],
      \ 'c' : [':VtrClearRunner'                            , 'clear-runner'],
      \ 'd' : [':VtrDetachRunner'                           , 'detach-runner'],
      \ 'f' : [':VtrFocusRunner'                            , 'focus-runner'],
      \ 'F' : [':VtrFlushCommand'                           , 'flush-command'],
      \ 'k' : [':VtrKillRunner'                             , 'kill-runner'],
      \ 'o' : [':VtrOpenRunner'                             , 'open-runner'],
      \ 'r' : [':VtrReattachRunner'                         , 'open-runner'],
      \ 'R' : [':VtrReorientRunner'                         , 'reorient-runner'],
      \ 's' : {
        \ 'name' : '+send-command'                          ,
          \ 'c' : [':VtrSendCtrlC'                          , 'send-ctrl-c'],
          \ 'd' : [':VtrSendCtrlD'                          , 'send-ctrl-d'],
          \ 'f' : [':VtrSendFile'                           , 'send-file'],
          \ 'k' : [':VtrSendKeysRaw'                        , 'send-keys-raw'],
          \ 'l' : [':VtrSendLinesToRunner'                  , 'send-lines-to-runner'],
          \ 's' : [':VtrSendCommandToRunner'                , 'send-command-to-runner'],
      \ },
      \ }

" }}}

" u is for UI and toggle {{{

let g:which_key_map.u = {
      \ 'name' : '+ui/toggle'                               ,
      \ 'u' : [':MundoToggle'                               , 'mundo-tree'],
      \ }

" }}}

" v is for vim {{{

let g:which_key_map.v = {
      \ 'name' : '+vim'                                     ,
      \ ':' : [':Telescope commands'                        , 'commands'],
      \ 'h' : [':Telescope help_tags'                       , 'help-tags'],
      \ 'H' : [':Telescope command_history'                 , 'commands-history'],
      \ 'k' : [':Telescope keymaps'                         , 'telescope-keymaps'],
      \ 'K' : [':FzfMaps'                                   , 'fzf-keymaps'],
      \ 'o' : [':Telescope vim_options'                     , 'options'],
      \ 'p' : {
        \ 'name' : '+vim-plug'                              ,
          \ 'c' : [':PlugClean'                             , 'clean'],
          \ 'd' : [':PlugDiff'                              , 'diff'],
          \ 'h' : [':PlugHelp'                              , 'help'],
          \ 'i' : [':PlugInstall'                           , 'install'],
          \ 'k' : [':PlugSnapshot'                          , 'snapshot'],
          \ 'r' : [':PlugUpgrade'                           , 'upgrade'],
          \ 's' : [':PlugStatus'                            , 'status'],
          \ 'u' : [':PlugUpdate'                            , 'update'],
      \ },
      \ }

" }}}

" w is for windows {{{

let g:which_key_map.w = {
      \ 'name' : '+windows'                                 ,
      \ '2' : ['<C-W>v'                                     , 'layout-double-columns'],
      \ ';' : ['<C-W>L'                                     , 'move-window-far-right'],
      \ '=' : ['<C-W>='                                     , 'balance-windows'],
      \ '?' : [':FzfWindows'                                , 'fzf-window'],
      \ 'H' : ['<C-W>5<'                                    , 'expand-window-left'],
      \ 'J' : [':resize +5'                                 , 'expand-window-below'],
      \ 'K' : [':resize  5'                                 , 'expand-window-up'],
      \ 'L' : ['<C-W>5>'                                    , 'expand-window-right'],
      \ 'a' : ['<C-W>H'                                     , 'move-window-far-left'],
      \ 'd' : ['<C-W>c'                                     , 'delete-window'],
      \ 'h' : ['<C-W>h'                                     , 'window-left'],
      \ 'i' : ['<C-W>K'                                     , 'move-window-far-top'],
      \ 'j' : ['<C-W>j'                                     , 'window-below'],
      \ 'k' : ['<C-W>k'                                     , 'window-up'],
      \ 'l' : ['<C-W>l'                                     , 'window-right'],
      \ 'm' : [':MaximizerToggle'                           , 'maximize-windows'],
      \ 'n' : ['<C-W>J'                                     , 'move-window-far-down'],
      \ 's' : ['<C-W>s'                                     , 'split-window-below'],
      \ 't' : ['<C-W>T'                                     , 'move-split-to-tab'],
      \ 'u' : ['<C-W>x'                                     , 'swap-window-next'],
      \ 'v' : ['<C-W>v'                                     , 'split-window-right'],
      \ 'x' : [':call WindowSwap#EasyWindowSwap()'          , 'window-swap'],
      \ }

" }}}

" key maps defined in other files {{{

" " keybindings for c {{{

let g:which_key_map.c.G = 'grep-under-cursor'
let g:which_key_map.c.g = 'grep-under-cursor-buffer'

" " }}}

" keybindings for g = git {{{

" keybindings in nvim/lua/plugins/gitsigns.lua
let g:which_key_map.g.h.b = 'blame-hunk'
let g:which_key_map.g.h.n = 'next-hunk'
let g:which_key_map.g.h.p = 'prev-hunk'
let g:which_key_map.g.h.r = 'reset-hunk'
let g:which_key_map.g.h.s = 'stage-hunk'
let g:which_key_map.g.h.u = 'unstage-hunk'
let g:which_key_map.g.h.v = 'preview-hunk'

" }}}

" keybindings for o = telescope {{{

" keybindings defined in ~/.config/nvim/keys/telescope.vim
let g:which_key_map.o.a   = 'emojis'
let g:which_key_map.o.b.f = 'find-buffers'
let g:which_key_map.o.b.o = 'find-buffers-theme'
let g:which_key_map.o.f.D = 'tj-fd-files'
let g:which_key_map.o.f.E = 'tj-file-browser'
let g:which_key_map.o.f.G = 'tj-git-files'
let g:which_key_map.o.f.N = 'nvim-config-dropdown'
let g:which_key_map.o.f.a = 'tj-search-all-files'
let g:which_key_map.o.f.c = 'dotfiles'
let g:which_key_map.o.f.d = 'with-dropdown'
let g:which_key_map.o.f.l = 'tj-old-files'
let g:which_key_map.o.f.n = 'nvim-config'
let g:which_key_map.o.g.c = 'git-checkout'
let g:which_key_map.o.s.L = 'tj-live-grep'
let g:which_key_map.o.s.f = 'grep-string'
let g:which_key_map.o.s.r = 'resume-last-search'
let g:which_key_map.o.s.w = 'grep-word'
let g:which_key_map.o.t.B = 'tj-builtin'
let g:which_key_map.o.w   = 'grep-words'

" }}}

" keybindings for p = treesitter and telescope {{{

" keybindings defined in ~/.config/nvim/lua/plugins/treesitter.lua
let g:which_key_map.p.n = 'swap-parameter-next'
let g:which_key_map.p.N = 'swap-parameter-previous'
let g:which_key_map.p.P = 'tj-project-search'

" }}}

" keybindings for n = neovim {{{

let g:which_key_map.n.p = 'tj-installed-plugins'
let g:which_key_map.n.h = 'tj-help-tags'

" }}}

" keybindings for r = find and replace {{{

" keybindings defined in ~/.config/nvim/lua/plugins/treesitter.lua
let g:which_key_map.r = 'replace-text-object'
let g:which_key_map.R = 'replace-current-word'

" }}}

" }}}

" }}}

" Register which key map
call which_key#register('<Space>', "g:which_key_map")
