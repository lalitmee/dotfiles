local map = lk_utils.map
local wk = require('whichkey_setup')

vim.cmd [[set timeoutlen=500]]

local opts = { noremap = true, silent = true }

-- NOTE: Map leader to which_key
map('n', '<leader>', [[:silent <c-u> :silent WhichKey '<Space>'<CR> ]], opts)
map(
    'v', '<leader>', [[:silent <c-u> :silent WhichKeyVisual '<Space>'<CR> ]],
    opts
)

-- NOTE: options for which key
-- let g:which_key_sep = '→'
vim.g.which_key_use_floating_win = 0
vim.g.which_key_disable_default_offset = 1
vim.g.which_key_hspace = 10
vim.g.which_key_centered = 0

vim.api.nvim_exec(
    [[
      " highlights
      highlight default link WhichKey          Operator
      highlight default link WhichKeySeperator DiffAdded
      highlight default link WhichKeyGroup     Identifier
      highlight default link WhichKeyDesc      Function

      " Hide status line
      autocmd! FileType which_key
      autocmd  FileType which_key set laststatus=0 noshowmode noruler | autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
      ]], true
)

-- NOTE: leader key mappings
local leader_key_maps = {
  -- NOTE: direct mappings
  [','] = { ':w<CR>', 'save' },
  ['.'] = { ':e $MYVIMRC<CR>', 'open-init' },
  [';'] = { ':Telescope commands<CR>', 'commands' },

  -- NOTE: a is for actions
  ['a'] = {
    ['name'] = '+actions',
    ['c'] = { ':ColorizerToggle<CR>', 'colorizer' },
    ['e'] = { ':NvimTreeToggle<CR>', 'nvim-tree-exlporer' },
    ['f'] = { ':NvimTreeFindFile<CR>', 'nvim-tree-find-file' },
    ['h'] = { ':Telescope frecency<CR>', 'telescope-frecency' },
    ['l'] = { ':Bracey<CR>', 'start-live-server' },
    ['L'] = { ':BraceyStop<CR>', 'stop-live-server' },
    ['m'] = { ':MarkdownPreview<CR>', 'markdown-preview' },
    ['M'] = { ':MarkdownPreviewStop<CR>', 'markdown-preview-stop' },
    ['p'] = { ':PlugHelp<CR>', 'plug-help' },
    ['r'] = { ':NvimTreeRefresh<CR>', 'nvim-tree-refresh' },
    ['t'] = { ':FloatermToggle<CR>', 'terminal' },
    ['w'] = { ':StripWhitespace<CR>', 'strip-whitespace' },
    ['z'] = { ':Goyo<CR>', 'goyo' }
  },

  -- NOTE: b is for buffers
  ['b'] = {
    ['name'] = '+buffers',
    [';'] = { ':BufferCloseBuffersRight<CR>', 'close-all-right' },
    ['['] = { ':bp<CR>', 'prev-buffer' },
    [']'] = { ':bn<CR>', 'next-buffer' },
    ['a'] = { ':BufferCloseBuffersLeft<CR>', 'close-all-left' },
    ['b'] = { ':FzfBuffers<CR>', 'fzf-buffers' },
    ['B'] = { ':Telescope buffers<CR>', 'telescope-buffers' },
    ['c'] = { ':vnew<CR>', 'new-empty-buffer-vert' },
    ['C'] = { ':BufferCloseAllButCurrent<CR>', 'close-all-but-current' },
    ['d'] = { ':Sayonara!<CR>', 'delete-buffer' },
    ['D'] = { ':%bd<CR>', 'delete-all-buffers' },
    ['f'] = { ':bfirst<CR>', 'first-buffer' },
    ['g'] = { ':BufferlinePick<CR>', 'goto-buffer' },
    ['h'] = { ':Startify<CR>', 'home-buffer' },
    ['j'] = { ':BufferPick<CR>', 'buffer-pick' },
    ['l'] = { ':Telescope current_buffer_fuzzy_find<CR>', 'search-buffer-lines' },
    ['L'] = { ':blast<CR>', 'first-buffer' },
    ['m'] = { ':delm!<CR>', 'delete-marks' },
    ['n'] = { ':BufferLineCycleNext<CR>', 'next-buffer' },
    ['N'] = { ':BufferLineMoveNext<CR>', 'move-next-buffer' },
    ['o'] = { ':BufferLineSorByDirectory<CR>', 'order-by-direcoty' },
    ['O'] = { ':BufferLineSortByExtension<CR>', 'order-by-language' },
    ['p'] = { ':BufferLineCyclePrev<CR>', 'previous-buffer' },
    ['P'] = { ':BufferLineMovePrev<CR>', 'move-previous-buffer' },
    ['r'] = { ':e<CR>', 'refresh-buffer' },
    ['R'] = { ':bufdo :e<CR>', 'refresh-loaded-buffers' },
    ['s'] = { ':new<CR>', 'new-empty-buffer' },
    ['w'] = { ':Sayonara<CR>', 'close-buffer-and-window' }
  },

  -- -- NOTE: c is for code with coc.nvim
  -- ['c'] = {
  --   ['name'] = '+coc',
  --   ['a'] = { ':CocAction<CR>', 'action' },
  --   ['c'] = { ':CocCommand<CR>', 'commands' },
  --   ['d'] = { ':CocDiagnostics<CR>', 'diagnostics' },
  --   ['e'] = { ':CocConfig<CR>', 'config' },
  --   ['f'] = { ':CocFix<CR>', 'fix' },
  --   ['i'] = { ':CocInfo<CR>', 'info' },
  --   ['l'] = {
  --     ['name'] = '+list',
  --     ['"'] = { ':CocList registers<CR>', 'registers' },
  --     ['/'] = { ':CocList searchhistory<CR>', 'search-history' },
  --     [';'] = { ':CocList commands<CR>', 'commands' },
  --     ['a'] = { ':CocList sessions<CR>', 'sessions' },
  --     ['b'] = { ':CocList buffers<CR>', 'buffers' },
  --     ['c'] = { ':CocList colors<CR>', 'colorschemes' },
  --     ['d'] = { ':CocList folders<CR>', 'workspace-directories' },
  --     ['e'] = { ':CocList diagnostics<CR>', 'diagnostics' },
  --     ['E'] = { ':CocList extensions<CR>', 'extensions' },
  --     ['f'] = { ':CocList files<CR>', 'files' },
  --     ['g'] = { ':CocList branches<CR>', 'branches' },
  --     ['h'] = { ':CocList cmd_history<CR>', 'command-history' },
  --     ['H'] = { ':CocList helptags<CR>', 'help-tags' },
  --     ['j'] = { ':CocList<CR>', 'lists' },
  --     ['k'] = { ':CocList maps<CR>', 'mappings' },
  --     ['l'] = { ':CocList fuzzy_lines<CR>', 'buffer-fuzzy-lines' },
  --     ['L'] = { ':CocList links<CR>', 'buffer-links' },
  --     ['m'] = { ':CocList marketplace<CR>', 'marketplace' },
  --     ['M'] = { ':CocList marks<CR>', 'marks' },
  --     ['o'] = { ':CocList locationlist<CR>', 'location-list' },
  --     ['q'] = { ':CocList quickfix<CR>', 'quickfix-list' },
  --     ['r'] = { ':CocList mru<CR>', 'mru' },
  --     ['s'] = { ':CocList outline<CR>', 'buffer-symbols' },
  --     ['S'] = { ':CocList symbols<CR>', 'workspace-symbols' },
  --     ['t'] = { ':CocList floaterm<CR>', 'floaterm' },
  --     ['v'] = { ':CocList vimcommands<CR>', 'vim-commands' },
  --     ['w'] = { ':CocList windows<CR>', 'windows' },
  --     ['W'] = { ':CocList words<CR>', 'buffer-words' },
  --     ['z'] = { ':CocList tags<CR>', 'tag-files' }
  --   },
  --   ['m'] = {
  --     ['name'] = '+fzf-list',
  --     ['a'] = { ':CocFzfList actions<CR>', 'actions' },
  --     ['b'] = { ':CocFzfList symbols<CR>', 'symbols' },
  --     ['c'] = { ':CocFzfList commands<CR>', 'commands' },
  --     ['d'] = { ':CocFzfList diagnostics<CR>', 'diagnostics' },
  --     ['e'] = {
  --       ':CocFzfList diagnostics --current-buf<CR>',
  --       'buffer-diagnostics'
  --     },
  --     ['g'] = { ':CocFzfList issues<CR>', 'issues' },
  --     ['i'] = { ':CocFzfList snippets<CR>', 'snippets' },
  --     ['l'] = { ':CocFzfList location<CR>', 'locations' },
  --     ['o'] = { ':CocFzfList outline<CR>', 'outline' },
  --     ['r'] = { ':CocFzfListResume<CR>', 'resume-list' },
  --     ['s'] = { ':CocFzfList services<CR>', 'services' },
  --     ['u'] = { ':CocFzfList output<CR>', 'output' },
  --     ['v'] = { ':CocFzfList sources<CR>', 'sources' },
  --     ['y'] = { ':CocFzfList yank<CR>', 'yank' }
  --   },
  --   ['r'] = { ':call coc#refresh()<CR>', 'coc-refresh' },
  --   ['R'] = { ':CocListResume<CR>', 'list-resume' },
  --   ['s'] = { ':CocSearch<CR>', 'search' },
  --   ['x'] = { '<Plug>(coc-convert-snippet)', 'covert-to-snippet' }
  -- },

  -- NOTE: c is for code with lspconfig
  ['c'] = {
    ['name'] = '+code',
    ['a'] = { ':Lspsaga code_action<CR>', 'code-action' },
    ['A'] = { ':Lspsaga range_code_action<CR>', 'range-code-action' },
    ['b'] = { ':Telescope lsp_code_actions<CR>', 'lsp-code-actions' },
    ['B'] = { ':Telescope lsp_range_code_actions<CR>', 'lsp-range-code-actions' },
    ['c'] = { ':Lspsaga close_floatterm<CR>', 'close-floatterm' },
    ['d'] = { ':Telescope lsp_definitions<CR>', 'lsp-definitions' },
    ['e'] = {
      ':Telescope lsp_document_diagnostics<CR>',
      'lsp-document-diagnostics'
    },
    ['E'] = {
      ':Telescope lsp_workspace_diagnostics<CR>',
      'lsp-workspace-diagnostics'
    },
    ['h'] = { ':Lspsaga hover_doc<CR>', 'hover-doc' },
    ['o'] = { ':Lspsaga open_floatterm<CR>', 'open-floatterm' },
    ['p'] = { ':Lspsaga preview_definition<CR>', 'preview-definition' },
    ['r'] = { ':Telescope lsp_references<CR>', 'lsp-references' },
    ['R'] = { ':Lspsaga lsp_finder<CR>', 'references' },
    ['s'] = { ':Lspsaga signaute_help<CR>', 'signature-help' },
    ['t'] = { ':Telescope treesitter<CR>', 'treesitter-symbols' },
    ['w'] = { ':Telescope lsp_document_symbols<CR>', 'lsp-document-symbols' },
    ['W'] = { ':Telescope lsp_workspace_symbols<CR>', 'lsp-workspace-symbols' }
  },

  -- NOTE: d is for harpoon
  ['d'] = {
    ['name'] = '+harpoon',
    ['c'] = 'clear-all',
    ['f'] = {
      ['name'] = '+files',
      ['1'] = 'goto-file-1',
      ['2'] = 'goto-file-2',
      ['3'] = 'goto-file-3',
      ['4'] = 'goto-file-4',
      ['5'] = 'goto-file-5',
      ['6'] = 'goto-file-6',
      ['a'] = 'add-file',
      ['r'] = 'remove-file'
    },
    ['m'] = 'quick-menu',
    ['p'] = 'promote',
    ['s'] = 'shorten-list',
    ['t'] = {
      ['name'] = '+terminals',
      ['f'] = 'goto-terminal-1',
      ['s'] = 'send-command-terminal-1',
      ['S'] = 'send-command-terminal-2',
      ['t'] = 'goto-terminal-2'
    }
  },

  -- NOTE: e is for errors/warnings
  ['e'] = {
    ['name'] = '+errors/warnings',
    ['l'] = { ':Telescope lsp_workspace_diagnostics<CR>', 'list-errors/warnings' },
    ['n'] = { ':Lspsaga diagnostic_jump_next<CR>', 'next-diagnostic' },
    ['p'] = { ':Lspsaga diagnostic_jump_prev<CR>', 'prev-diagnostic' },
    ['L'] = { ':Lspsaga show-line-diagnostics<CR>', 'line-diagnostic' }
  },

  -- NOTE: f is for FZF
  ['f'] = {
    ['name'] = '+FZF',
    ['a'] = { ':FzfAg<CR>', 'ag' },
    ['b'] = {
      ['name'] = '+buffers',
      ['c'] = { ':CustomFzfBuffers<CR>', 'custom-buffers' },
      ['b'] = { ':FzfBuffers<CR>', 'jump-buffers' },
      ['l'] = { ':FzfBLines<CR>', 'buffer-lines' },
      ['L'] = { ':FzfLines<CR>', 'loaded-buffers-lines' }
    },
    ['d'] = { ':RG<CR>', 'rg' },
    ['f'] = {
      ['name'] = '+files',
      ['f'] = { ':FzfFiles<CR>', 'files' },
      ['g'] = { ':FzfGFiles<CR>', 'git-files' },
      ['s'] = { ':FzfGFiles?<CR>', 'git-status-files' },
      ['d'] = { ':FzfDotfiles<CR>', 'dotfiles' },
      ['n'] = { ':FzfNvimConfig<CR>', 'neovim-config' },
      ['p'] = { ':FzfSwitchProjectFile<CR>', 'switch-files' }
    },
    ['g'] = {
      ['name'] = '+git',
      ['b'] = { ':FzfBCommits<CR>', 'buffer-commits' },
      ['B'] = { ':FzfCommits<CR>', 'commits' },
      ['c'] = { ':FzfGBranches<CR>', 'git-branches' }
    },
    ['h'] = { ':FzfHistory<CR>', 'history' },
    ['i'] = { ':FzfSnippets<CR>', 'snippets' },
    ['j'] = {
      ['name'] = '+search',
      ['c'] = { ':RG<CR>', 'search-content' },
      ['d'] = { ':FzfRg<CR>', 'default-rg' },
      ['f'] = { ':Rg<CR>', 'custom-rg' }
    },
    ['L'] = { ':FzfLocate <CR>', 'locate' },
    ['t'] = { ':FzfBTags<CR>', 'buffer-tags' },
    ['T'] = { ':FzfTags<CR>', 'project-tags' },
    ['l'] = {
      ['name'] = '+nvim-lsp',
      ['a'] = { ':FzfCodeActions<CR>', 'code-actions' },
      ['A'] = { ':FzfRangeCodeActions<CR>', 'code-actions' },
      ['c'] = { ':FzfIncomingCalls<CR>', 'incoming-calls' },
      ['C'] = { ':FzfOutgoingCalls<CR>', 'outgoing-calls' },
      ['d'] = { ':FzfDefinitions<CR>', 'definitions' },
      ['D'] = { ':FzfDeclarations<CR>', 'delcarations' },
      ['e'] = { ':FzfDiagnostics<CR>', 'diagnostics' },
      ['i'] = { ':FzfImplementations<CR>', 'implementations' },
      ['r'] = { ':FzfReferences<CR>', 'references' },
      ['t'] = { ':FzfTypeDefinitions<CR>', 'type-definition' },
      ['w'] = { ':FzfDocumentSymbols<CR>', 'document-symbols' },
      ['W'] = { ':FzfWorkspaceSymbols<CR>', 'workspace-symbols' }
    },
    ['s'] = { ':w<CR>', 'save-buffer' },
    ['S'] = { ':wa<CR>', 'save-all-buffers' },
    ['v'] = {
      ['name'] = '+vim',
      ['/'] = { ':FzfHistory/<CR>', 'search-history' },
      [':'] = { ':FzfHistory:<CR>', 'command-history' },
      [';'] = { ':FzfCommands<CR>', 'command-history' },
      ['c'] = { ':FzfColors<CR>', 'colorschemes' },
      ['f'] = { ':FzfFiletypes<CR>', 'filetypes' },
      ['h'] = { ':FzfHelptags<CR>', 'help-tags' },
      ['m'] = { ':FzfMarks<CR>', 'marks' },
      ['M'] = { ':FzfMaps<CR>', 'maps' }
    },
    ['w'] = { ':FzfWindows<CR>', 'windows' }
  },

  ['F'] = {
    ['name'] = '+search/replace'
    -- NOTE: r = 'replace-text-object',
    -- NOTE: R = 'replace-current-word'
  },

  -- NOTE: g is for git
  ['g'] = {
    ['name'] = '+git',
    ['a'] = { ':Git add .<CR>', 'add-all' },
    ['A'] = { ':Git add %<CR>', 'add-current' },
    ['b'] = { ':GBrowse<CR>', 'browse' },
    ['B'] = { ':GitBlameToggle<CR>', 'blame' },
    ['C'] = { ':Git commit<CR>', 'commit' },
    ['c'] = { ':Telescope git_branches<CR>', 'checkout' },
    ['d'] = { ':Git diff<CR>', 'diff' },
    ['D'] = { ':Gdiffsplit<CR>', 'diff-split' },
    ['g'] = { ['name'] = '+gists' },
    ['G'] = { ':Gstatus<CR>', 'status' },
    ['h'] = {
      ['name'] = '+hunks',
      ['b'] = 'blame-hunk',
      ['n'] = 'next-hunk',
      ['p'] = 'prev-hunk',
      ['r'] = 'reset-hunk',
      ['s'] = 'stage-hunk',
      ['u'] = 'unstage-hunk',
      ['v'] = 'preview-hunk'
    },
    ['l'] = { ':Git log<CR>', 'log' },
    ['p'] = { ':Git push<CR>', 'push' },
    ['P'] = { ':Git pull<CR>', 'pull' },
    ['R'] = { ':GRemove<CR>', 'remove' },
    ['s'] = { ':Neogit<CR>', 'status' },
    ['S'] = { ':GGrep<CR>', 'git-grep' },
    ['v'] = { ':GV<CR>', 'view-commits' },
    ['V'] = { ':GV!<CR>', 'view-buffer-commits' }
  },

  ['G'] = {
    ['name'] = '+goneovim',
    ['a'] = { ':GonvimFuzzyAg<CR>', 'fuzzy-ag' },
    ['b'] = { ':GonvimFuzzyBuffers<CR>', 'fuzzy-buffers' },
    ['f'] = { ':GonvimFuzzyFiles<CR>', 'fuzzy-files' },
    ['F'] = { ':GonvimFilerOpen<CR>', 'external-file-explorer' },
    ['l'] = { ':GonvimFuzzyBLines<CR>', 'fuzzy-buffer-lines' },
    ['m'] = { ':GonvimMarkdown<CR>', 'markdown-preview' },
    ['M'] = { ':GonvimMiniMap<CR>', 'toggle-minimap' },
    ['n'] = { ':GonvimWorkspaceNext<CR>', 'next-workspace' },
    ['N'] = { ':GonvimWorkspaceNew<CR>', 'create-new-workspace' },
    ['p'] = { ':GonvimWorkspacePrevious<CR>', 'previous-workspace' },
    ['r'] = { ':GonvimFuzzyResume<CR>', 'resume-previous-search' },
    ['s'] = { ':GonvimWorkspaceSwitch <CR>', 'switch-workspace' },
    ['w'] = { ':GonvimFuzzyAgCword<CR>', 'fuzzy-word' }
  },

  -- NOTE: j is for jumping
  ['j'] = {
    ['name'] = '+jumping',
    ['l'] = { ':HopLine<CR>', 'hop-line' },
    ['p'] = { ':HopPattern<CR>', 'hop-pattern' },
    ['w'] = { ':HopWord<CR>', 'hop-word' },
    ['c'] = { ':HopChar1<CR>', 'hop-char-1' },
    ['d'] = { ':HopChar2<CR>', 'hop-char-2' }
  },

  -- NOTE: l is for lsp with coc.nvim
  -- ['l'] = {
  --   ['name'] = '+lsp',
  --   ['.'] = { ':CocConfig<CR>', 'config' },
  --   [';'] = { '<Plug>(coc-refactor)', 'refactor' },
  --   ['a'] = { '<Plug>(coc-codeaction)', 'line-action' },
  --   ['A'] = { '<Plug>(coc-codeaction-selected)', 'selected-action' },
  --   ['b'] = { ':CocNext<CR>', 'next-action' },
  --   ['B'] = { ':CocPrev<CR>', 'prev-action' },
  --   ['c'] = { ':CocList commands<CR>', 'commands' },
  --   ['d'] = { '<Plug>(coc-definition)', 'definition' },
  --   ['D'] = { '<Plug>(coc-declaration)', 'declaration' },
  --   ['e'] = { ':CocList extensions<CR>', 'extensions' },
  --   ['f'] = { '<Plug>(coc-format-selected)', 'format-selected' },
  --   ['F'] = { '<Plug>(coc-format)', 'format' },
  --   ['h'] = { '<Plug>(coc-float-hide)', 'hide' },
  --   ['i'] = { '<Plug>(coc-implementation)', 'implementation' },
  --   ['I'] = { ':CocList diagnostics<CR>', 'diagnostics' },
  --   ['j'] = { '<Plug>(coc-float-jump)', 'float-jump' },
  --   ['l'] = { '<Plug>(coc-codelens-action)', 'code-lens' },
  --   ['n'] = { '<Plug>(coc-diagnostic-next)', 'next-diagnostic' },
  --   ['N'] = { '<Plug>(coc-diagnostic-next-error)', 'next-error' },
  --   ['o'] = { ':Vista!!<CR>', 'outline' },
  --   ['O'] = { ':CocList outline<CR>', 'outline' },
  --   ['p'] = { '<Plug>(coc-diagnostic-prev)', 'prev-diagnostic' },
  --   ['P'] = { '<Plug>(coc-diagnostic-prev-error)', 'prev-error' },
  --   ['q'] = { '<Plug>(coc-fix-current)', 'quickfix' },
  --   ['R'] = { '<Plug>(coc-references)', 'references' },
  --   ['r'] = { '<Plug>(coc-rename)', 'rename-symbol' },
  --   ['s'] = { ':CocList -I symbols<CR>', 'symbols' },
  --   ['S'] = { ':CocList snippets<CR>', 'snippets' },
  --   ['t'] = { '<Plug>(coc-type-definition)', 'type-definition' },
  --   ['u'] = { ':CocListResume<CR>', 'resume-list' },
  --   ['U'] = { ':CocUpdate<CR>', 'update-CoC' },
  --   ['z'] = { ':CocDisable<CR>', 'disable-CoC' },
  --   ['Z'] = { ':CocEnable<CR>', 'enable-CoC' }
  -- },

  -- NOTE: l is for lsp with lspconfig
  ['l'] = {
    ['name'] = '+lsp',
    ['a'] = { ':Lspsaga code_action<CR>', 'code-action' },
    ['A'] = { ':Lspsaga range_code_action<CR>', 'range-code-action' },
    ['d'] = { ':Lspsaga hover_doc<CR>', 'hover-doc' },
    ['e'] = {
      ['name'] = '+diagnostics',
      ['l'] = { ':Lspsaga show_line_diagnostics<CR>', 'show-line-diagnostics' },
      ['n'] = { ':Lspsaga diagnostic_jump_next<CR>', 'next-diagnostic' },
      ['p'] = { ':Lspsaga diagnostic_jump_prev<CR>', 'prev-diagnostic' }
    },
    ['i'] = { ':LspInfo<CR>', 'lsp-info' },
    ['l'] = { ':Lspsaga lsp_finder<CR>', 'finder' },
    ['p'] = { ':Lspsaga preview_definition<CR>', 'preview-definition' },
    ['r'] = { ':LspRename<CR>', 'rename' },
    ['s'] = { ':Lspsaga signature_help<CR>', 'signature-help' },
    ['t'] = { ':Lspsaga open_floatterm<CR>', 'open-floatterm' },
    ['T'] = { ':Lspsaga close_floatterm<CR>', 'close-floatterm' },
    ['v'] = {
      ['name'] = '+vista',
      ['a'] = { ':Vista ale<CR>', 'ale' },
      ['A'] = { ':Vista finder fzf:ale<CR>', 'fzf:ale' },
      ['c'] = { ':Vista coc<CR>', 'coc' },
      ['C'] = { ':Vista finder fzf:coc<CR>', 'fzf:coc' },
      ['f'] = { ':Vista finder<CR>', 'finder' },
      ['F'] = { ':Vista finder!<CR>', 'finder!' },
      ['g'] = { ':Vista ctags<CR>', 'ctags' },
      ['G'] = { ':Vista finder skim:ctags<CR>', 'skim:ctags' },
      ['i'] = { ':Vista info<CR>', 'info' },
      ['I'] = { ':Vista info+<CR>', 'info+' },
      ['j'] = { ':Vista focus<CR>', 'focus' },
      ['n'] = { ':Vista nvim_lsp<CR>', 'nvim-lsp' },
      ['N'] = { ':Vista finder fzf:nvim_lsp<CR>', 'fzf:nvim_lsp' },
      ['s'] = { ':Vista show<CR>', 'show' },
      ['t'] = { ':Vista!!<CR>', 'toggle-vista' },
      ['u'] = { ':Vista vim_lsc<CR>', 'vim_lsc' },
      ['v'] = { ':Vista vim_lsp<CR>', 'vim_lsp' }
    },
    ['w'] = {
      ['name'] = '+workspace',
      ['a'] = { ':LspAddToWorkspaceFolder<CR>', 'add-folder-to-workspace' },
      ['l'] = { ':LspListWorkspaceFolders<CR>', 'list-workspace-folders' },
      ['r'] = { ':LspRemoveWorkspaceFolder<CR>', 'remove-workspace-folder' },
      ['s'] = { ':LspWorkspaceSymbols<CR>', 'workspace-symbols' }
    }
  },

  -- NOTE: L is for lsp
  ['L'] = {
    ['name'] = '+lsp',
    ['a'] = { ':LspCodeActions<CR>', 'code-action' },
    ['A'] = { ':LspRangeCodeActions<CR>', 'range-code-action' },
    ['e'] = {
      ['name'] = '+diagnostics',
      ['a'] = { ':LspGetAllDiagnostics<CR>', 'all-diagnostics' },
      ['l'] = { ':LspShowLineDiagnostics<CR>', 'show-line-diagnostics' },
      ['n'] = { ':LspGotoNextDiagnostic<CR>', 'next-diagnostic' },
      ['N'] = { ':LspGetNextDiagnostic<CR>', 'get-next-diagnostic' },
      ['p'] = { ':LspGotoPrevDiagnostic<CR>', 'prev-diagnostic' },
      ['P'] = { ':LspGetPrevDiagnostic<CR>', 'get-prev-diagnostic' }
    },
    ['f'] = {
      ['name'] = '+formatting',
      ['f'] = { ':LspFormatting<CR>', 'formatting' },
      ['r'] = { ':LspRangeFormatting<CR>', 'range-formatting' },
      ['s'] = { ':LspFormattingSync<CR>', 'formatting-sync' }
    },
    ['g'] = {
      ['name'] = '+definitions/references',
      ['c'] = { ':LspClearReferences<CR>', 'clear-references' },
      ['d'] = { ':LspDefinition<CR>', 'definition' },
      ['i'] = { ':LspDeclaration<CR>', 'declaration' },
      ['r'] = { ':LspReferences<CR>', 'references' },
      ['t'] = { ':LspTypeDefinition<CR>', 'type-definition' }
    },
    ['h'] = { ':LspHover<CR>', 'hover-doc' },
    ['H'] = { ':LspDocumentHighlight<CR>', 'document-highlight' },
    ['i'] = { ':LspIncomingCalls<CR>', 'incoming-calls' },
    ['o'] = { ':LspOutGoingCalls<CR>', 'outgoing-calls' },
    ['r'] = { ':LspRename<CR>', 'rename' },
    ['s'] = { ':LspDocumentSymbols<CR>', 'document-symbols' },
    ['S'] = { ':LspWorkspaceSymbols<CR>', 'document-symbols' },
    ['w'] = {
      ['name'] = '+workspace',
      ['a'] = { ':LspAddToWorkspaceFolder<CR>', 'add-folder-to-workspace' },
      ['l'] = { ':LspListWorkspaceFolders<CR>', 'list-workspace-folders' },
      ['r'] = { ':LspRemoveWorkspaceFolder<CR>', 'remove-workspace-folder' },
      ['s'] = { ':LspWorkspaceSymbols<CR>', 'workspace-symbols' }
    },
    ['y'] = { ':LspImplementation<CR>', 'implementation' }
  },

  -- NOTE: m is for major mode
  ['m'] = {
    ['name'] = '+major-mode',
    ['a'] = { ':Telescope lsp_code_actions<CR>', 'code-actions' },
    ['b'] = { ':Telescope lsp_range_code_actions<CR>', 'range-code-actions' },
    ['c'] = { ':MakeTags<CR>', 'make-ctags' },
    ['d'] = { ':Telescope lsp_document_diagnostics<CR>', 'document-diagnostics' },
    ['D'] = {
      ':Telescope lsp_workspace_diagnostics<CR>',
      'workspace-diagnostics'
    },
    ['f'] = { ':Telescope lsp_references<CR>', 'references' },
    ['j'] = { ':Telescope lsp_workspace_symbols<CR>', 'workspace-symbols' },
    ['s'] = { ':Telescope lsp_document_symbols<CR>', 'buffer-symbols' }
  },

  -- NOTE: n is for neovim
  ['n'] = {
    ['name'] = '+neovim',
    ['c'] = { ':PlugClean<CR>', 'clean-packages' },
    ['e'] = { ':e $HOME/.config/nvim/init.lua<CR>', 'edit-config' },
    ['h'] = 'tj-help-tags',
    ['H'] = { ':checkhealth<CR>', 'check-health' },
    ['i'] = { ':PlugInstall<CR>', 'install-packages' },
    ['l'] = 'source-current',
    ['p'] = 'tj-installed-plugins',
    ['r'] = { ':luafile $HOME/.config/nvim/init.lua<CR>', 'source-config' },
    ['s'] = { ':PlugSnapshot<CR>', 'plug-snapshot' },
    ['u'] = { ':PlugUpdate<CR>', 'update-packages' },
    ['U'] = { ':PlugUpgrade<CR>', 'upgrade-plug' }
  },

  -- NOTE: o is for telescope
  ['o'] = {
    ['name'] = '+Telescope',
    ['a'] = 'emojis',
    ['b'] = {
      ['name'] = '+buffers',
      ['a'] = { ':Telescope lsp_code_actions<CR>', 'code-actions' },
      ['b'] = { ':Telescope buffers<CR>', 'buffers' },
      ['c'] = { ':Telescope lsp_range_code_actions<CR>', 'range-code-actions' },
      ['d'] = { ':Telescope lsp_document_symbols<CR>', 'buffer-symbols' },
      ['f'] = 'find-buffers',
      ['j'] = { ':Telescope lsp_workspace_symbols<CR>', 'workspace-symbols' },
      ['l'] = { ':Telescope current_buffer_fuzzy_find<CR>', 'buffer-lines' },
      ['o'] = 'find-buffers-theme',
      ['r'] = { ':Telescope lsp_references<CR>', 'references' },
      ['s'] = { ':Telescope spell_suggest<CR>', 'spell_suggest' },
      ['t'] = { ':Telescope current_buffer_tags<CR>', 'buffer-tags' }
    },
    ['c'] = {
      ['name'] = '+cheat.sh',
      ['f'] = { ':Telescope cheat fd<CR>', 'cheat-find' },
      ['r'] = { ':Telescope cheat readcache<CR>', 'read-cache' }
    },
    ['d'] = {
      ['name'] = '+dap',
      ['b'] = { ':Telescope dap lsp_breakpoints<CR>', 'lsp-breakpoints' },
      ['c'] = { ':Telescope dap configurations<CR>', 'configurations' },
      ['f'] = { ':Telescope dap frames<CR>', 'frames' },
      ['o'] = { ':Telescope dap commands<CR>', 'commands' },
      ['v'] = { ':Telescope dap variables<CR>', 'variables' }
    },
    ['e'] = { ':Telescope symbols<CR>', 'symbols' },
    ['f'] = {
      ['name'] = '+files',
      ['a'] = 'tj-search-all-files',
      ['c'] = 'dotfiles',
      ['d'] = 'with-dropdown',
      ['D'] = 'tj-fd-files',
      ['e'] = { ':Telescope file_browser<CR>', 'file-browser' },
      ['E'] = 'tj-file-browser',
      ['f'] = { ':Telescope fzf_writer files<CR>', 'fzf-writer-files' },
      ['g'] = { ':Telescope git_files<CR>', 'git-files' },
      ['G'] = 'tj-git-files',
      ['h'] = { ':Telescope frecency<CR>', 'telescope-frecency' },
      ['l'] = 'tj-old-files',
      ['m'] = { ':Telescope media_files<CR>', 'media-files' },
      ['n'] = 'nvim-config',
      ['N'] = 'nvim-config-dropdown',
      ['o'] = { ':Telescope find_files<CR>', 'find-files' },
      ['r'] = { ':Telescope oldfiles<CR>', 'recent-files' },
      ['z'] = { ':Telescope filetypes<CR>', 'filetypes' }
    },
    ['g'] = {
      ['name'] = '+git',
      ['c'] = 'git-checkout',
      ['b'] = { ':Telescope git_branches<CR>', 'git-branches' },
      ['C'] = { ':Telescope git_bcommits<CR>', 'git-buffer-commits' },
      ['d'] = { ':Telescope git_commits<CR>', 'git-commits' },
      ['f'] = { ':Telescope git_files<CR>', 'git-files' },
      ['s'] = { ':Telescope git_status<CR>', 'git-status' }
    },
    ['i'] = { ':Telescope snippets snippets<CR>', 'snippets' },
    ['j'] = { ':Telescope jumps jumps<CR>', 'jumps' },
    ['l'] = { ':Telescope loclist<CR>', 'loclist' },
    ['m'] = { ':Telescope man_pages<CR>', 'man-pages' },
    ['n'] = {
      ['name'] = '+navigation/jumps',
      ['j'] = { ':Telescope jumps jumps<CR>', 'jumps' },
      ['h'] = { ':Telescope harpoon marks<CR>', 'harpoon marks' }
    },
    ['o'] = { ':Telescope openbrowser list<CR>', 'openbrowser' },
    ['s'] = {
      ['name'] = '+search',
      ['b'] = { ':Telescope current_buffer_fuzzy_find<CR>', 'buffer-lines' },
      ['f'] = 'grep-string',
      ['l'] = { ':Telescope live_grep<CR>', 'live-grep' },
      ['L'] = 'tj-live-grep',
      ['r'] = 'resume-last-search',
      ['s'] = { ':Telescope fzf_writer grep<CR>', 'fzf-writer-grep' },
      ['u'] = { ':Telescope grep_string<CR>', 'grep-string' },
      ['w'] = 'grep-word'
    },
    ['t'] = {
      ['name'] = '+telescope',
      ['B'] = 'tj-builtin',
      ['b'] = { ':Telescope builtin<CR>', 'builtins' },
      ['p'] = { ':Telescope planets<CR>', 'planets' },
      ['r'] = { ':Telescope reloader<CR>', 'reloaders' },
      ['t'] = { ':Telescope treesitter<CR>', 'reloaders' },
      ['w'] = 'change-background'
    },
    ['u'] = { ':Telescope ultisnips ultisnips<CR>', 'ultisnips' },
    ['v'] = {
      ['name'] = '+vim',
      [';'] = { ':Telescope commands<CR>', 'commands' },
      ['a'] = { ':Telescope autocommands<CR>', 'autocommands' },
      ['c'] = { ':Telescope colorscheme<CR>', 'colorschemes' },
      ['h'] = { ':Telescope command_history<CR>', 'commands-history' },
      ['H'] = { ':Telescope highlights<CR>', 'highlights' },
      ['k'] = { ':Telescope keymaps<CR>', 'keymaps' },
      ['m'] = { ':Telescope marks<CR>', 'marks' },
      ['r'] = { ':Telescope registers<CR>', 'vim-registers' },
      ['t'] = { ':Telescope help_tags<CR>', 'help-tags' },
      ['v'] = { ':Telescope vim_options<CR>', 'vim-options' }
    },
    ['w'] = 'grep-words'
  },

  -- NOTE: p is for project
  ['p'] = {
    ['name'] = '+project',
    ['a'] = { ':FzfAg<CR>', 'project-search' },
    ['b'] = { ':Telescope buffers<CR>', 'find-buffers' },
    ['f'] = { ':Telescope fzf_writer files<CR>', 'find-files' },
    ['g'] = { ':Telescope git_files<CR>', 'find-git-files' },
    ['n'] = 'swap-parameter-next',
    ['N'] = 'swap-parameter-previous',
    ['p'] = { ':Telescope project project<CR>', 'switch-project' },
    ['P'] = 'tj-project-search',
    ['r'] = { ':Telescope frecency<CR>', 'old-files' },
    ['s'] = { ':Telescope live_grep<CR>', 'project-search' },
    ['S'] = { ':Telescope fzf_writer grep<CR>', 'project-search' },
    ['w'] = { ':Telescope grep_string<CR>', 'string-search' }
  },

  -- NOTE: q is for quickfix and quit
  ['q'] = {
    ['name'] = '+quick-fix-list',
    ['c'] = { ':cclose<CR>', 'close-qf-window' },
    ['n'] = { ':cn<CR>', 'next' },
    ['o'] = { ':copen<CR>', 'open-qf-window' },
    ['p'] = { ':cp<CR>', 'previous' },
    ['q'] = { ':qall<CR>', 'quit-vim' },
    ['l'] = { ':Telescope quickfix<CR>', 'fuzzy-quickfix' }
  },

  ['r'] = 'replace-text-object',
  ['R'] = 'replace-current-word',

  -- NOTE: s is for search
  ['s'] = {
    ['name'] = '+search',
    ['/'] = { ':Telescope command_history<CR>', 'history' },
    [';'] = { ':Telescope commands<CR>', 'commands' },
    ['a'] = { ':FzfAg<CR>', 'text-Ag' },
    ['b'] = { ':Telescope current_buffer_fuzzy_find<CR>', 'current-buffer' },
    ['B'] = { ':Telescope buffers<CR>', 'open-buffers' },
    ['c'] = { ':Telescope git_commits<CR>', 'commits' },
    ['C'] = { ':Telescope git_bcommits<CR>', 'buffer-commits' },
    ['d'] = { ':Telescope git_files<CR>', 'git-files' },
    ['f'] = { ':Telescope find_files<CR>', 'files' },
    ['g'] = { ':Telescope git_status<CR>', 'modified-git-files' },
    ['h'] = { ':Telescope help_tags<CR>', 'help-tags' },
    ['H'] = { ':Telescope command_history<CR>', 'command-history' },
    ['l'] = { ':FzfLines<CR>', 'lines' },
    ['m'] = { ':Telescope marks<CR>', 'marks' },
    ['M'] = { ':Telescope keymaps<CR>', 'keymaps' },
    ['p'] = { ':Telescope live_grep<CR>', 'live-grep' },
    ['P'] = { ':Telescope fzf_writer grep<CR>', 'fzf-live-grep' },
    ['r'] = { ':Telescope registers<CR>', 'registers' },
    ['s'] = { ':Telescope ultisnips ultisnips<CR>', 'snippets' },
    ['S'] = { ':Telescope colorscheme<CR>', 'color-schemes' },
    ['t'] = { ':Telescope tags<CR>', 'project-tags' },
    ['T'] = { ':FzfBTags<CR>', 'buffer-tags' },
    ['v'] = { ':Telescope vim_options<CR>', 'vim-options' },
    ['w'] = { ':FzfWindows<CR>', 'search-windows' },
    ['y'] = { ':Telescope filetypes<CR>', 'file-types' },
    ['z'] = { ':FZF<CR>', 'FZF' }
  },

  -- NOTE: S is for sessions
  ['S'] = {
    ['name'] = '+session',
    ['c'] = { ':SClose<CR>', 'close-session' },
    ['d'] = { ':SDelete<CR>', 'delete-session' },
    ['l'] = { ':SLoad<CR>', 'load-session' },
    ['s'] = { ':SSave<CR>', 'save-session' },
    ['S'] = { ':Startify<CR>', 'start-page' }
  },

  -- NOTE: t is for toggles/terminal
  ['t'] = {
    ['name'] = '+toggle',
    ['t'] = { ':FloatermNew<CR>', 'terminal' },
    ['f'] = {
      ['name'] = '+floaterm',
      ['G'] = { ':FloatermNew tig<CR>', 'tig' },
      ['a'] = { ':FloatermNew terminal_velocity<CR>', 'terminal_velocity' },
      ['d'] = { ':FloatermNew lazydocker<CR>', 'docker' },
      ['f'] = { ':FloatermNew fzf<CR>', 'fzf' },
      ['g'] = { ':FloatermNew lazygit<CR>', 'git' },
      ['n'] = { ':FloatermNew node<CR>', 'node' },
      ['p'] = { ':FloatermNew python<CR>', 'python' },
      ['r'] = { ':FloatermNew ranger<CR>', 'ranger' },
      ['s'] = { ':FloatermNew ncdu<CR>', 'ncdu' },
      ['t'] = { ':FloatermToggle<CR>', 'toggle' },
      ['v'] = { ':FloatermNew grv<CR>', 'grv' },
      ['w'] = { ':FloatermNew wt<CR>', 'weather' },
      ['y'] = { ':FloatermNew btm<CR>', 'ytop' }
    },
    ['s'] = {
      ['name'] = '+scrolloff',
      ['t'] = { ':set scrolloff=10<CR>', 'scrolloff=10' },
      ['h'] = { ':set scrolloff=5<CR>', 'scrolloff=5' },
      ['n'] = { ':set scrolloff=999<CR>', 'scrolloff=999' }
    },
    ['h'] = { ':sp | te<CR>', 'horizontal-split-terminal' },
    ['v'] = { ':vs | te<CR>', 'vertical-split-terminal' }
  },

  -- NOTE: T is for tmux-runner
  ['T'] = {
    ['name'] = '+tmux-runner',
    ['a'] = { ':VtrAttachToPane<CR>', 'attach-pane' },
    ['c'] = { ':VtrClearRunner<CR>', 'clear-runner' },
    ['d'] = { ':VtrDetachRunner<CR>', 'detach-runner' },
    ['f'] = { ':VtrFocusRunner<CR>', 'focus-runner' },
    ['F'] = { ':VtrFlushCommand<CR>', 'flush-command' },
    ['k'] = { ':VtrKillRunner<CR>', 'kill-runner' },
    ['o'] = { ':VtrOpenRunner<CR>', 'open-runner' },
    ['r'] = { ':VtrReattachRunner<CR>', 'open-runner' },
    ['R'] = { ':VtrReorientRunner<CR>', 'reorient-runner' },
    ['s'] = {
      ['name'] = '+send-command',
      ['c'] = { ':VtrSendCtrlC<CR>', 'send-ctrl-c' },
      ['d'] = { ':VtrSendCtrlD<CR>', 'send-ctrl-d' },
      ['f'] = { ':VtrSendFile<CR>', 'send-file' },
      ['k'] = { ':VtrSendKeysRaw<CR>', 'send-keys-raw' },
      ['l'] = { ':VtrSendLinesToRunner<CR>', 'send-lines-to-runner' },
      ['s'] = { ':VtrSendCommandToRunner<CR>', 'send-command-to-runner' }
    }
  },

  -- NOTE: u is for undo
  ['u'] = { ['name'] = '+ui/toggle', ['u'] = { ':MundoToggle', 'mundo-tree' } },

  -- NOTE: v is for vim
  ['v'] = {
    ['name'] = '+vim',
    [':'] = { ':Telescope commands<CR>', 'commands' },
    ['h'] = { ':Telescope help_tags<CR>', 'help-tags' },
    ['H'] = { ':Telescope command_history<CR>', 'commands-history' },
    ['k'] = { ':Telescope keymaps<CR>', 'telescope-keymaps' },
    ['K'] = { ':FzfMaps<CR>', 'fzf-keymaps' },
    ['o'] = { ':Telescope vim_options<CR>', 'options' },
    ['p'] = {
      ['name'] = '+vim-plug',
      ['c'] = { ':PlugClean<CR>', 'clean' },
      ['d'] = { ':PlugDiff<CR>', 'diff' },
      ['h'] = { ':PlugHelp<CR>', 'help' },
      ['i'] = { ':PlugInstall<CR>', 'install' },
      ['k'] = { ':PlugSnapshot<CR>', 'snapshot' },
      ['r'] = { ':PlugUpgrade<CR>', 'upgrade' },
      ['s'] = { ':PlugStatus<CR>', 'status' },
      ['u'] = { ':PlugUpdate<CR>', 'update' }
    }
  },

  -- NOTE: w is for windows
  ['w'] = {
    ['name'] = '+windows',
    ['2'] = { '<C-W>v', 'layout-double-columns' },
    [';'] = { '<C-W>L', 'move-window-far-right' },
    ['='] = { '<C-W>=', 'balance-windows' },
    ['?'] = { ':FzfWindows<CR>', 'fzf-window' },
    ['a'] = { '<C-W>H', 'move-window-far-left' },
    ['d'] = { '<C-W>c', 'delete-window' },
    ['h'] = { '<C-W>h', 'window-left' },
    ['H'] = { '<C-W>5<', 'expand-window-left' },
    ['i'] = { '<C-W>K', 'move-window-far-top' },
    ['j'] = { '<C-W>j', 'window-below' },
    ['J'] = { ':resize +5<CR>', 'expand-window-below' },
    ['k'] = { '<C-W>k', 'window-up' },
    ['K'] = { ':resize  5<CR>', 'expand-window-up' },
    ['l'] = { '<C-W>l', 'window-right' },
    ['L'] = { '<C-W>5>', 'expand-window-right' },
    ['m'] = { ':MaximizerToggle<CR>', 'maximize-windows' },
    ['n'] = { '<C-W>J', 'move-window-far-down' },
    ['s'] = { '<C-W>s', 'split-window-below' },
    ['t'] = { '<C-W>T', 'move-split-to-tab' },
    ['u'] = { '<C-W>x', 'swap-window-next' },
    ['v'] = { '<C-W>v', 'split-window-right' },
    ['x'] = { ':call WindowSwap#EasyWindowSwap()<CR>', 'window-swap' }
  },
  ['x'] = { ':q<CR>', 'quit' },
  ['z'] = { ':Goyo<CR>', 'zen-mode' }
}

local plug_keymaps = {
  ['c'] = {},
  ['g'] = {
    ['g'] = {
      ['name'] = '+gists',
      ['c'] = { '<Plug>fov_new', 'create-new-gist' },
      ['l'] = { '<Plug>fov_list', 'list-gists' },
      ['u'] = { '<Plug>fov_update', 'update-gist' },
      ['v'] = { '<Plug>fov_visual_new', 'create-new-from-visual' }
    },
    ['m'] = { '<Plug>(git-messenger)', 'git-messenger' }
  },
  ['l'] = {
    ['name'] = '+lsp'
    -- [';'] = {'<Plug>(coc-refactor)', 'refactor'},
    -- ['a'] = {'<Plug>(coc-codeaction)', 'line-action'},
    -- ['A'] = {'<Plug>(coc-codeaction-selected)', 'selected-action'},
    -- ['d'] = {'<Plug>(coc-definition)', 'definition'},
    -- ['D'] = {'<Plug>(coc-declaration)', 'declaration'},
    -- ['f'] = {'<Plug>(coc-format-selected)', 'format-selected'},
    -- ['F'] = {'<Plug>(coc-format)', 'format'},
    -- ['h'] = {'<Plug>(coc-float-hide)', 'hide'},
    -- ['i'] = {'<Plug>(coc-implementation)', 'implementation'},
    -- ['j'] = {'<Plug>(coc-float-jump)', 'float-jump'},
    -- ['l'] = {'<Plug>(coc-codelens-action)', 'code-lens'},
    -- ['n'] = {'<Plug>(coc-diagnostic-next)', 'next-diagnostic'},
    -- ['N'] = {'<Plug>(coc-diagnostic-next-error)', 'next-error'},
    -- ['p'] = {'<Plug>(coc-diagnostic-prev)', 'prev-diagnostic'},
    -- ['P'] = {'<Plug>(coc-diagnostic-prev-error)', 'prev-error'},
    -- ['q'] = {'<Plug>(coc-fix-current)', 'quickfix'},
    -- ['R'] = {'<Plug>(coc-references)', 'references'},
    -- ['r'] = {'<Plug>(coc-rename)', 'rename-symbol'},
    -- ['t'] = {'<Plug>(coc-type-definition)', 'type-definition'}
  },
  ['m'] = {
    ['name'] = '+major-mode',
    ['l'] = { '<Plug>(JsConsoleLog)', 'console-log' }
    -- ['r'] = {'<Plug>(coc-rename)', 'rename-symbol'}
  }
}

wk.register_keymap('leader', leader_key_maps, { silent = true })
wk.register_keymap('leader', plug_keymaps, { noremap = false })
