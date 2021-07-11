local map = lk_utils.map
local wk = require('whichkey_setup')

vim.cmd [[set timeoutlen=500]]

local opts = { noremap = true, silent = true }

-- NOTE: Map leader to which_key
map('n', '<leader>', [[:silent <c-u> :silent WhichKey '<Space>'<CR> ]], opts)
map('v', '<leader>', [[:silent <c-u> :silent WhichKeyVisual '<Space>'<CR> ]],
    opts)

-- NOTE: options for which key
-- let g:which_key_sep = '→'
vim.g.which_key_use_floating_win = 0
vim.g.which_key_disable_default_offset = 1
vim.g.which_key_hspace = 10
vim.g.which_key_centered = 0

vim.api.nvim_exec([[
      " highlights
      highlight default link WhichKey          Operator
      highlight default link WhichKeySeperator DiffAdded
      highlight default link WhichKeyGroup     Identifier
      highlight default link WhichKeyDesc      Function

      " Hide status line
      autocmd! FileType which_key
      autocmd  FileType which_key set laststatus=0 noshowmode noruler | autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
      ]], true)

-- NOTE: leader key mappings
local leader_key_maps = {
  -- NOTE: direct mappings
  [';'] = { ':Telescope commands<CR>', 'commands' },
  ['*'] = 'vimgrep-under-cursor',

  -- NOTE: a is for actions
  ['a'] = {
    ['name'] = '+actions',
    ['a'] = { ':Cheatsheet<CR>', 'cheatsheet' },
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
    ['['] = { ':bp<CR>', 'prev-buffer' },
    [']'] = { ':bn<CR>', 'next-buffer' },
    ['a'] = { ':JABSOpen<CR>', 'beautiful-buffer-switcher' },
    ['b'] = { ':Telescope buffers<CR>', 'telescope-buffers' },
    ['B'] = { ':FzfBuffers<CR>', 'fzf-buffers' },
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
    ['H'] = { ':Lspsaga signaute_help<CR>', 'signature-help' },
    ['o'] = { ':Lspsaga open_floatterm<CR>', 'open-floatterm' },
    ['p'] = { ':Lspsaga preview_definition<CR>', 'preview-definition' },
    ['r'] = { ':Telescope lsp_references<CR>', 'lsp-references' },
    ['R'] = { ':Lspsaga lsp_finder<CR>', 'references' },
    ['s'] = { ':SymbolsOutline<CR>', 'symbols-outline' },
    ['t'] = { ':Telescope treesitter<CR>', 'treesitter-symbols' },
    ['w'] = { ':Telescope lsp_document_symbols<CR>', 'lsp-document-symbols' },
    ['W'] = { ':Telescope lsp_workspace_symbols<CR>', 'lsp-workspace-symbols' }
  },

  -- NOTE: d is for dap
  ['d'] = {
    ['name'] = '+dap',
    ['?'] = { [[<cmd>lua require'dap.ui.variables'.scopes()<CR>]], 'scopes' },
    ['c'] = { [[<cmd>lua require'dap'.continue()<CR>]], 'continue' },
    ['o'] = { [[<cmd>lua require'dap'.step_over()<CR>]], 'step-over' },
    ['i'] = { [[<cmd>lua require'dap'.step_into()<CR>]], 'step-into' },
    ['e'] = { [[<cmd>lua require'dap'.step_out()<CR>]], 'step-out' },
    ['b'] = {
      [[<cmd>lua require'dap'.toggle_breakpoint()<CR>]],
      'toggle-breakpoint'
    },
    ['B'] = {
      [[<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>]],
      'set-breakpoint-condition'
    },
    ['l'] = {
      [[<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>]],
      'set-breakpoint-log-message'
    },
    ['r'] = { [[<cmd>lua require'dap'.repl.open()<CR>]], 'open-repl' },
    ['R'] = { [[<cmd>lua require'dap'.repl.run_last()<CR>]], 'repl-run-last' }
  },

  -- NOTE: e is for errors/warnings
  ['e'] = {
    ['name'] = '+errors/warnings',
    ['l'] = { ':Telescope coc diagnostics<CR>', 'buffer-diagnostics' },
    ['L'] = {
      ':Telescope coc workspace_diagnostics<CR>',
      'workspace_diagnostics'
    }
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
      ['n'] = { ':FzfNvimConfig<CR>', 'neovim-config' }
    },
    ['g'] = {
      ['name'] = '+git',
      ['b'] = { ':FzfBCommits<CR>', 'buffer-commits' },
      ['B'] = { ':FzfCommits<CR>', 'commits' }
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

  -- NOTE: F is for find and replace
  ['F'] = {
    ['name'] = '+search/replace',
    ['r'] = 'replace-text-object',
    ['R'] = 'replace-current-word',
    ['f'] = 'grep',
    ['F'] = 'grep-and-replace'
  },

  -- NOTE: g is for git
  ['g'] = {
    ['name'] = '+git',
    ['a'] = { ':Git add .<CR>', 'add-all' },
    ['A'] = { ':Git add %<CR>', 'add-current' },
    ['b'] = { ':GBrowse<CR>', 'browse' },
    ['C'] = { ':Git commit<CR>', 'commit' },
    ['c'] = { ':Telescope git_branches<CR>', 'checkout' },
    ['d'] = { ':Git diff<CR>', 'diff' },
    ['D'] = { ':Gdiffsplit<CR>', 'diff-split' },
    ['g'] = {
      ['name'] = '+gists',
      ['a'] = { ':Gist -a<CR>', 'create-gist-anonymously' },
      ['b'] = { ':Gist -b<CR>', 'open-gist-in-browser' },
      ['c'] = { ':Gist<CR>', 'create-new-gist' },
      ['d'] = { ':Gist -d<CR>', 'delete-gist' },
      ['e'] = { ':Gist -e<CR>', 'edit-buffer-gist' },
      ['f'] = { ':Gist -f<CR>', 'fork-gist' },
      ['l'] = { ':Gist -l<CR>', 'list-public-gists' },
      ['L'] = { ':Gist -la<CR>', 'list-everyones-gists' },
      ['o'] = { ':Gist -ls<CR>', 'list-starred-gists' },
      ['s'] = { ':Gist +1<CR>', 'star-the-gist' },
      ['S'] = { ':Gist -1<CR>', 'unstar-the-gist' },
      ['m'] = { ':Gist -m<CR>', 'create-gist-all-buffers' },
      ['p'] = { ':Gist -p<CR>', 'create-private-gist' },
      ['P'] = { ':Gist -P<CR>', 'create-public-gist' }
    },
    ['G'] = { ':Gstatus<CR>', 'status' },
    ['h'] = {
      ['name'] = '+gitsigns-hunks',
      ['a'] = { ':Gitsigns attach<CR>', 'attach' },
      ['A'] = { ':Gitsigns get_actions<CR>', 'get-actions' },
      ['b'] = { ':Gitsigns blame_line<CR>', 'blame-line' },
      ['B'] = { ':Gitsigns stage_buffer<CR>', 'stage-buffer' },
      ['c'] = { ':Gitsigns setup<CR>', 'setup' },
      ['C'] = { ':Gitsigns change_base<CR>', 'change-base' },
      ['d'] = { ':Gitsigns diffthis<CR>', 'diffthis' },
      ['D'] = { ':Gitsigns detach<CR>', 'detach' },
      ['i'] = { ':Gitsigns reset_buffer_index<CR>', 'reset-buffer-index' },
      ['n'] = { ':Gitsigns next_hunk<CR>', 'next-hunk' },
      ['p'] = { ':Gitsigns prev_hunk<CR>', 'prev-hunk' },
      ['P'] = { ':Gitsigns preview_hunk<CR>', 'preview_hunk' },
      ['r'] = { ':Gitsigns refresh<CR>', 'refresh' },
      ['R'] = { ':Gitsigns reset_buffer<CR>', 'reset-buffer' },
      ['s'] = { ':Gitsigns stage_hunk<CR>', 'stage-hunk' },
      ['S'] = { ':Gitsigns select_hunk<CR>', 'select-hunk' },
      ['u'] = { ':Gitsigns detach_all<CR>', 'detach-all' },
      ['U'] = { ':Gitsigns reset_hunk<CR>', 'reset-hunk' }
    },
    ['l'] = { ':Git log<CR>', 'log' },
    ['o'] = {
      ['name'] = '+octo.nvim',
      ['a'] = {
        ['name'] = '+reaction',
        ['c'] = { ':Octo reaction confused<CR>', 'react-confused' },
        ['d'] = { ':Octo reaction thumbs_down<CR>', 'react-thumbs_down' },
        ['e'] = { ':Octo reaction eyes<CR>', 'react-eyes' },
        ['h'] = { ':Octo reaction heart<CR>', 'react-heart' },
        ['l'] = { ':Octo reaction laugh<CR>', 'react-laugh' },
        ['r'] = { ':Octo reaction rocket<CR>', 'react-rocket' },
        ['t'] = { ':Octo reaction tada<CR>', 'react-tada' },
        ['u'] = { ':Octo reaction thumbs_up<CR>', 'react-thumbs_up' }
      },
      ['A'] = { ':Octo reviewer add<CR>', 'add-reviewer' },
      ['c'] = {
        ['name'] = '+comment',
        ['a'] = { ':Octo comment add<CR>', 'add' },
        ['d'] = { ':Octo comment delete<CR>', 'delete' }
      },
      ['g'] = { ':Octo gist list<CR>', 'list-gist' },
      ['i'] = {
        ['name'] = '+issues',
        ['a'] = { ':Octo issue create<CR>', 'create' },
        ['b'] = { ':Octo issue browser<CR>', 'browser' },
        ['c'] = { ':Octo issue close<CR>', 'close' },
        ['e'] = { ':Octo issue edit<CR>', 'edit' },
        ['l'] = { ':Octo issue list<CR>', 'list' },
        ['o'] = { ':Octo issue reopen<CR>', 'reopen' },
        ['r'] = { ':Octo issue reload<CR>', 'reload' },
        ['s'] = { ':Octo issue search<CR>', 'search' },
        ['u'] = { ':Octo issue url<CR>', 'url' }
      },
      ['l'] = {
        ['name'] = '+label',
        ['a'] = { ':Octo label add<CR>', 'add' },
        ['c'] = { ':Octo label create<CR>', 'create' },
        ['r'] = { ':Octo label remove<CR>', 'remove' }
      },
      ['p'] = {
        ['name'] = '+pull-requests',
        ['a'] = { ':Octo pr create<CR>', 'create' },
        ['b'] = { ':Octo pr browser<CR>', 'browser' },
        ['c'] = { ':Octo pr checkout<CR>', 'checkout' },
        ['C'] = { ':Octo pr close<CR>', 'close' },
        ['d'] = { ':Octo pr diff<CR>', 'diff' },
        ['D'] = { ':Octo pr checks<CR>', 'checks' },
        ['e'] = { ':Octo pr edit<CR>', 'edit' },
        ['g'] = { ':Octo pr commits<CR>', 'commits' },
        ['h'] = { ':Octo pr changes<CR>', 'changes' },
        ['l'] = { ':Octo pr list<CR>', 'list' },
        ['m'] = { ':Octo pr merge<CR>', 'merge' },
        ['o'] = { ':Octo pr reopen<CR>', 'reopen' },
        ['r'] = { ':Octo pr reload<CR>', 'reload' },
        ['R'] = { ':Octo pr ready<CR>', 'ready' },
        ['s'] = { ':Octo pr search<CR>', 'search' },
        ['u'] = { ':Octo pr url<CR>', 'url' }
      },
      ['r'] = {
        ['name'] = '+repositories',
        ['b'] = { ':Octo repo browser<CR>', 'browser' },
        ['f'] = { ':Octo repo fork<CR>', 'fork' },
        ['l'] = { ':Octo repo list<CR>', 'list' },
        ['u'] = { ':Octo repo url<CR>', 'url' }
      },
      ['R'] = {
        ['name'] = '+review',
        ['b'] = { ':Octo review start<CR>', 'start-review' },
        ['c'] = { ':Octo review comments<CR>', 'comments-review' },
        ['d'] = { ':Octo review discard<CR>', 'discard-review' },
        ['r'] = { ':Octo review resume<CR>', 'resume-review' },
        ['s'] = { ':Octo review submit<CR>', 'submit-review' }
      },
      ['t'] = {
        ['name'] = '+thread',
        ['r'] = { ':Octo thread resolve<CR>', 'resolve' },
        ['u'] = { ':Octo thread unresolve<CR>', 'unresolve' }
      }
    },
    ['p'] = { ':Git push<CR>', 'push' },
    ['P'] = { ':Git pull<CR>', 'pull' },
    ['R'] = { ':GRemove<CR>', 'remove' },
    ['s'] = { ':Neogit<CR>', 'status' },
    ['S'] = { ':GGrep<CR>', 'git-grep' },
    ['v'] = { ':GV<CR>', 'view-commits' },
    ['V'] = { ':GV!<CR>', 'view-buffer-commits' },
    ['w'] = {
      ['name'] = '+git-worktree',
      ['c'] = {
        ':Telescope git_worktree create_git_worktree<CR>',
        'create-worktree'
      },
      ['l'] = { ':Telescope git_worktree git_worktrees<CR>', 'list-worktrees' }
    }
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

  -- NOTE: h is for highlight
  ['h'] = {
    ['name'] = '+highlight',
    ['t'] = {
      ['name'] = '+todo-comments',
      ['q'] = { ':TodoQuickFix<CR>', 'todos-quickfix' },
      ['t'] = { ':TodoTelescope<CR>', 'todos-telescope' },
      ['b'] = { ':TodoTrouble<CR>', 'todos-trouble' }
    }
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

  -- NOTE: l is for lsp with lspconfig
  ['l'] = {
    ['name'] = '+Lspsaga',
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
    ['o'] = {
      ['name'] = '+outline',
      ['a'] = { ':AerialToggle<CR>', 'aerial' },
      ['c'] = { ':AerialTreeCloseAll<CR>', 'aerial-close-all' },
      ['o'] = { ':AerialTreeOpenAll<CR>', 'aerial-open-all' },
      ['s'] = { ':SymbolsOutline<CR>', 'symbols-outline' }
    },
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

  -- NOTE: L is for lspconfig
  ['L'] = {
    ['name'] = '+builtin-lsp',
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
    ['c'] = { ':PackerCompile<CR>', 'packer-compile' },
    ['d'] = { ':PackerClean<CR>', 'clean-packages' },
    ['e'] = { ':e $HOME/.config/nvim/init.lua<CR>', 'edit-config' },
    ['h'] = 'tj-help-tags',
    ['H'] = { ':checkhealth<CR>', 'check-health' },
    ['i'] = { ':PackerInstall<CR>', 'packer-install' },
    ['l'] = 'source-current',
    ['p'] = 'tj-installed-plugins',
    ['r'] = { ':luafile $HOME/.config/nvim/init.lua<CR>', 'source-config' },
    ['s'] = { ':PackerSync<CR>', 'packer-sync' },
    ['S'] = { ':PackerStatus<CR>', 'packages-status' },
    ['u'] = { ':PackerUpdate<CR>', 'packer-update' }
  },

  -- NOTE: N is for notes
  ['N'] = {
    ['name'] = '+notes',
    ['a'] = {
      ':lua require"neuron/cmd".new_edit(require"neuron".config.neuron_dir)<CR>',
      'create-new-note'
    },
    ['b'] = {
      ':lua require"neuron/telescope".find_backlinks()<CR>',
      'find-backlinks'
    },
    ['B'] = {
      ':lua require"neuron/telescope".find_backlinks{ insert = true }<CR>',
      'find-backlinks-insert'
    },
    ['e'] = { ':lua require"neuron".enter_link()<CR>', 'enter-link' },
    ['i'] = {
      ':lua require"neuron/telescope".find_zettels {insert = true}<CR>',
      'insert-note-id'
    },
    ['n'] = { ':lua require"neuron".goto_next_extmark()<CR>', 'next' },
    ['p'] = { ':lua require"neuron".goto_next_extmark()<CR>', 'prev' },
    ['s'] = {
      ':lua require"neuron".rib {address = "127.0.0.1:8200", verbose = true}<CR>',
      'serve-notes'
    },
    ['t'] = { ':lua require"neuron/telescope".find_tags()<CR>', 'find-tags' },
    ['z'] = {
      ':lua require"neuron/telescope".find_zettels()<CR>',
      'search-notes'
    }
  },

  -- NOTE: o is for telescope
  ['o'] = {
    ['name'] = '+Telescope',
    ['a'] = {
      [[:lua require('telescope.builtin').symbols{sources = {'emoji'}}<cr>]],
      'emojis'
    },
    ['b'] = {
      ['name'] = '+buffers',
      ['a'] = { ':Telescope lsp_code_actions<CR>', 'code-actions' },
      ['b'] = { ':Telescope buffers<CR>', 'buffers' },
      ['B'] = { ':Telescope tele_tabby list<CR>', 'tele-tabby-buffers' },
      ['c'] = { ':Telescope lsp_range_code_actions<CR>', 'range-code-actions' },
      ['d'] = { ':Telescope lsp_document_symbols<CR>', 'buffer-symbols' },
      ['f'] = {
        [[:lua require('telescope.builtin').buffers({ entry_maker = require('lk.plugins.telescope.my_make_entry').gen_from_buffer_like_leaderf() })<cr>]],
        'find-buffers'
      },
      ['j'] = { ':Telescope lsp_workspace_symbols<CR>', 'workspace-symbols' },
      ['l'] = { ':Telescope current_buffer_fuzzy_find<CR>', 'buffer-lines' },
      ['o'] = 'buffer-lines-dropdown-theme',
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
    ['e'] = { ':Telescope emoji search<CR>', 'emoji-search' },
    ['f'] = {
      ['name'] = '+files',
      ['a'] = 'tj-search-all-files',
      ['c'] = 'dotfiles',
      ['d'] = {
        [[:lua require('lk.plugins.telescope.finders').fd_files_dropdown()<cr>]],
        'with-dropdown'
      },
      ['e'] = { ':Telescope file_browser<CR>', 'file-browser' },
      ['f'] = { ':Telescope fzf_writer files<CR>', 'fzf-writer-files' },
      ['F'] = { ':Telescope find_files<CR>', 'find-files' },
      ['g'] = { ':Telescope git_files<CR>', 'git-files' },
      ['h'] = { ':Telescope frecency<CR>', 'telescope-frecency' },
      ['m'] = { ':Telescope media_files<CR>', 'media-files' },
      ['n'] = 'nvim-config',
      ['o'] = { ':Telescope find_files<CR>', 'find-files' },
      ['r'] = { ':Telescope oldfiles<CR>', 'recent-files' },
      ['z'] = { ':Telescope filetypes<CR>', 'filetypes' }
    },
    ['g'] = {
      ['name'] = '+git',
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
    ['o'] = {
      ['name'] = '+open',
      ['o'] = { ':Telescope openbrowser list<CR>', 'openbrowser' },
      ['b'] = { ':Telescope bookmarks<CR>', 'bookmarks' }
    },
    ['s'] = {
      ['name'] = '+search',
      ['b'] = { ':Telescope current_buffer_fuzzy_find<CR>', 'buffer-lines' },
      ['s'] = { ':Telescope fzf_writer grep<CR>', 'fzf-writer-grep' },
      ['S'] = { ':Telescope live_grep<CR>', 'live-grep' },
      ['u'] = { ':Telescope grep_string<CR>', 'grep-string' },
      ['w'] = {
        [[:lua require("telescope").extensions.arecibo.websearch()<CR>]],
        'search-web'
      }
    },
    ['t'] = {
      ['name'] = '+telescope',
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
    ['w'] = {
      [[:lua require('telescope').extensions.fzf_writer.staged_grep{}<cr>]],
      'grep-words'
    }
  },

  -- NOTE: p is for project
  ['p'] = {
    ['name'] = '+project',
    ['a'] = { ':FzfAg<CR>', 'project-search' },
    ['b'] = { ':Telescope buffers<CR>', 'find-buffers' },
    ['f'] = { ':Telescope fzf_writer files<CR>', 'find-files-fzf' },
    ['F'] = { ':Telescope find_files<CR>', 'find-files' },
    ['g'] = { ':Telescope git_files<CR>', 'find-git-files' },
    ['n'] = 'swap-parameter-next',
    ['N'] = 'swap-parameter-previous',
    ['p'] = {
      ':lua require\'telescope\'.extensions.project.project{ display_type = \'full\' }<CR>',
      'switch-project'
    },
    ['P'] = 'tj-project-search',
    ['r'] = { ':Telescope frecency<CR>', 'old-files' },
    ['s'] = { ':Telescope live_grep<CR>', 'project-search' },
    ['S'] = { ':Telescope fzf_writer grep<CR>', 'project-search-fzf' },
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

  -- NOTE: s is for search
  ['s'] = {
    ['name'] = '+search',
    ['/'] = { ':Telescope command_history<CR>', 'history' },
    [';'] = { ':Telescope commands<CR>', 'commands' },
    ['a'] = { ':FzfAg<CR>', 'text-Ag' },
    ['b'] = { ':FzfBuffers<CR>', 'current-buffer' },
    ['B'] = { ':Telescope buffers<CR>', 'open-buffers' },
    ['c'] = { ':Telescope git_commits<CR>', 'commits' },
    ['C'] = { ':Telescope git_bcommits<CR>', 'buffer-commits' },
    ['d'] = { ':Telescope git_files<CR>', 'git-files' },
    ['f'] = { ':Telescope find_files<CR>', 'files' },
    ['g'] = { ':Telescope git_status<CR>', 'modified-git-files' },
    ['h'] = { ':Telescope help_tags<CR>', 'help-tags' },
    ['H'] = { ':Telescope command_history<CR>', 'command-history' },
    ['l'] = {
      ':Telescope current_buffer_fuzzy_find<CR>',
      'telescope-buffer-lines'
    },
    ['L'] = { ':FzfLines<CR>', 'fzf-buffer-lines' },
    ['m'] = { ':Telescope marks<CR>', 'marks' },
    ['M'] = { ':Telescope keymaps<CR>', 'keymaps' },
    ['p'] = { ':Telescope fzf_writer grep<CR>', 'live-grep-fzf' },
    ['P'] = { ':Telescope live_grep<CR>', 'live-grep' },
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

  -- NOTE: t is for tabs/toggles/terminal
  ['t'] = {
    ['name'] = '+tabs/terminal/toggle',
    ['c'] = {
      ['name'] = '+colorscheme',
      ['t'] = {
        ':lua require("material.functions").toggle_style()<CR>',
        'toggle-material-style'
      }
    },
    ['f'] = {
      ['name'] = '+floaterm',
      ['G'] = { ':lua Tig()<CR>', 'tig' },
      ['a'] = { ':lua Terminal_Velocity()<CR>', 'terminal_velocity' },
      ['d'] = { ':lua LazyDocker()<CR>', 'docker' },
      ['f'] = { ':lua Fzf()<CR>', 'fzf' },
      ['g'] = { ':lua LazyGit()<CR>', 'lazygit' },
      ['n'] = { ':lua Node()<CR>', 'node' },
      ['p'] = { ':lua Python()<CR>', 'python' },
      ['r'] = { ':lua Ranger()<CR>', 'ranger' },
      ['s'] = { ':lua Ncdu()<CR>', 'ncdu' },
      ['t'] = { ':ToggleTerm<CR>', 'toggle' },
      ['v'] = { ':lua Grv()<CR>', 'grv' },
      ['w'] = { ':lua Wt()<CR>', 'weather' },
      ['y'] = { ':lua Btm()<CR>', 'ytop' }
    },
    ['g'] = {
      ['name'] = '+git',
      ['b'] = { ':Gitsigns toggle_current_line_blame<CR>', 'toggle-blame' },
      ['l'] = { ':Gitsigns toggle_linehl<CR>', 'toggle-linehl' },
      ['n'] = { ':Gitsigns toggle_numhl<CR>', 'toggle-numhl' },
      ['s'] = { ':Gitsigns toggle_signs<CR>', 'toggle-signs' },
      ['w'] = { ':Gitsigns toggle_word_diff<CR>', 'toggle-word-diff' }
    },
    ['h'] = { ':sp | te<CR>', 'horizontal-split-terminal' },
    ['s'] = {
      ['name'] = '+scrolloff',
      ['t'] = { ':set scrolloff=10<CR>', 'scrolloff=10' },
      ['h'] = { ':set scrolloff=5<CR>', 'scrolloff=5' },
      ['n'] = { ':set scrolloff=999<CR>', 'scrolloff=999' }
    },
    ['t'] = { ':ToggleTerm<CR>', 'terminal' },
    ['v'] = { ':vs | te<CR>', 'vertical-split-terminal' },
    ['w'] = {
      ['name'] = '+tabs',
      ['c'] = { ':tabclose<CR>', 'close-tab' },
      ['f'] = { ':tabfirst<CR>', 'first-tab' },
      ['l'] = { ':tablast<CR>', 'last-tab' },
      ['n'] = { ':tabnext<CR>', 'next-tab' },
      ['N'] = { ':tabnew<CR>', 'new-tab' },
      ['p'] = { ':tabprevious<CR>', 'previous-tab' }
    }
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
  ['u'] = {
    ['name'] = '+ui/toggle',
    ['u'] = { ':MundoToggle<CR>', 'mundo-tree' }
  },

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
      ['c'] = { ':PackerClean<CR>', 'clean' },
      ['i'] = { ':PackerInstall<CR>', 'install' },
      ['r'] = { ':PackerCompile<CR>', 'complie' },
      ['s'] = { ':PackerSync<CR>', 'sync' },
      ['S'] = { ':PackerStatus<CR>', 'status' },
      ['u'] = { ':PackerUpdate<CR>', 'update' }
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
    ['f'] = {
      ['name'] = '+harpoon',
      ['c'] = { ':lua require("harpoon.mark").clear_all()<CR>', 'clear-all' },
      ['f'] = {
        ['name'] = '+files',
        ['1'] = { ':lua require("harpoon.ui").nav_file(1)<CR>', 'goto-file-4' },
        ['2'] = { ':lua require("harpoon.ui").nav_file(2)<CR>', 'goto-file-1' },
        ['3'] = { ':lua require("harpoon.ui").nav_file(3)<CR>', 'goto-file-2' },
        ['4'] = { ':lua require("harpoon.ui").nav_file(4)<CR>', 'goto-file-3' },
        ['5'] = { ':lua require("harpoon.ui").nav_file(5)<CR>', 'goto-file-4' },
        ['6'] = { ':lua require("harpoon.ui").nav_file(6)<CR>', 'goto-file-6' },
        ['a'] = { ':lua require("harpoon.mark").add_file()<CR>', 'add-file' },
        ['r'] = { ':lua require("harpoon.mark").rm_file()<CR>', 'remove-file' }
      },
      ['m'] = {
        ':lua require("harpoon.ui").toggle_quick_menu()<CR>',
        'quick-menu'
      },
      ['p'] = { ':lua require("harpoon.mark").promote()<CR>', 'promote' },
      ['s'] = {
        ':lua require("harpoon.mark").shorten_list()<CR>',
        'shorten-list'
      },
      ['t'] = {
        ['name'] = '+terminals',
        ['f'] = {
          ':lua require("harpoon.term").sendCommand(1, 2)<CR>',
          'goto-terminal-1'
        },
        ['s'] = {
          ':lua require("harpoon.term").gotoTerminal(1)<CR>',
          'send-command-terminal-1'
        },
        ['S'] = {
          ':lua require("harpoon.term").sendCommand(1, 1)<CR>',
          'send-command-terminal-2'
        },
        ['t'] = {
          ':lua require("harpoon.term").gotoTerminal(2)<CR>',
          'goto-terminal-2'
        }
      }
    },
    ['h'] = { ':lua require("Navigator").left()<CR>', 'window-left' },
    ['H'] = { '<C-W>5<', 'expand-window-left' },
    ['i'] = { '<C-W>K', 'move-window-far-top' },
    ['j'] = { ':lua require("Navigator").down()<CR>', 'window-down' },
    ['J'] = { ':resize +5<CR>', 'expand-window-below' },
    ['k'] = { ':lua require("Navigator").up()<CR>', 'window-up' },
    ['K'] = { ':resize  5<CR>', 'expand-window-up' },
    ['l'] = { ':lua require("Navigator").right()<CR>', 'window-right' },
    ['L'] = { '<C-W>5>', 'expand-window-right' },
    ['m'] = { ':MaximizerToggle<CR>', 'maximize-windows' },
    ['n'] = { '<C-W>J', 'move-window-far-down' },
    ['p'] = { ':lua require("Navigator").previous()<CR>', 'window-previous' },
    ['s'] = { '<C-W>s', 'split-window-below' },
    ['t'] = { '<C-W>T', 'move-split-to-tab' },
    ['u'] = { '<C-W>x', 'swap-window-next' },
    ['v'] = { '<C-W>v', 'split-window-right' },
    ['x'] = { ':call WindowSwap#EasyWindowSwap()<CR>', 'window-swap' }
  },
  ['x'] = { ':q<CR>', 'quit' },
  ['z'] = { ':Goyo<CR>', 'zen-mode' }
}

local local_leader_key_maps = {
  -- NOTE: f is for fzf lsp
  [']'] = 'subvert-replace-1',
  ['['] = 'subvert-replace-2',
  ['f'] = {
    ['name'] = '+fzf-lsp',
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
  }
}

local local_leader_plug_keymaps = {
  ['s'] = {
    ['name'] = '+sideways',
    ['i'] = { '<Plug>(SidewaysArgumentInsertBefore)', 'insert-before' },
    ['a'] = { '<Plug>(SidewaysArgumentAppendAfter)', 'append-after' },
    ['I'] = { '<Plug>(SidewaysArgumentInsertFirst)', 'insert-first' },
    ['A'] = { '<Plug>(SidewaysArgumentAppendLast)', 'append-last' }
  }
}

local leader_plug_keymaps = {
  ['c'] = {},
  ['e'] = {
    ['name'] = '+errors/warnings',
    ['n'] = { '<Plug>(coc-diagnostic-next)', 'next-diagnostic' },
    ['p'] = { '<Plug>(coc-diagnostic-prev)', 'prev-diagnostic' }
  },
  ['h'] = {
    ['name'] = '+highlight',
    ['c'] = { '<Plug>(InYoFace_Toggle)<CR>', 'highlight-comments' }
  },
  ['g'] = { ['m'] = { '<Plug>(git-messenger)', 'git-messenger' } },
  ['j'] = {
    ['a'] = {
      ['name'] = '+aerojump',
      ['s'] = { '<Plug>(AerojumpSpace)', 'aerojump-space' },
      ['b'] = { '<Plug>(AerojumpBolt)', 'aerojump-bolt' },
      ['a'] = { '<Plug>(AerojumpFromCursorBolt)', 'aerojump-from-cursor-bolt' },
      ['d'] = { '<Plug>(AerojumpDefault)', 'aerojump-default' }
    }
  },
  ['m'] = {
    ['name'] = '+major-mode',
    ['l'] = { '<Plug>(JsConsoleLog)', 'console-log' },
    ['r'] = { '<Plug>(coc-rename)', 'rename-symbol' }
  }
}

wk.register_keymap('localleader', local_leader_key_maps, { silent = true })
wk.register_keymap('localleader', local_leader_plug_keymaps, { noremap = false })
wk.register_keymap('leader', leader_key_maps, { silent = true })
wk.register_keymap('leader', leader_plug_keymaps, { noremap = false })
