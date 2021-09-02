local wk = require('which-key')
Terminal = require('nvim-terminal').DefaultTerminal;

vim.o.timeoutlen = 500

local presets = require('which-key.plugins.presets')
presets.objects['a('] = nil
wk.setup({
  show_help = true,
  triggers = 'auto',
  plugins = {
    spelling = true,
    marks = true,
    registers = true
  },
  key_labels = {
    ['<leader>'] = 'SPC'
  },
  layout = {
    spacing = 10
  }
})

-- NOTE: leader key mappings
local leader_key_maps = {
  -- NOTE: direct mappings
  ['*'] = 'vimgrep-under-cursor',
  ['+'] = 'increase-terminal-size',
  ['-'] = 'decrease-terminal-size',
  ['1'] = {':lua Terminal:open(1)<CR>', 'toggle-terminal-1'},
  ['2'] = {':lua Terminal:open(2)<CR>', 'toggle-terminal-2'},
  ['3'] = {':lua Terminal:open(3)<CR>', 'toggle-terminal-3'},
  ['4'] = {':lua Terminal:open(4)<CR>', 'toggle-terminal-4'},
  ['5'] = {':lua Terminal:open(5)<CR>', 'toggle-terminal-5'},
  ['6'] = {':lua Terminal:open(6)<CR>', 'toggle-terminal-6'},
  [':'] = {':Telescope commands<CR>', 'commands'},
  [';'] = {':lua Terminal:toggle()<CR>', 'toggle-terminal'},
  ['<leader>'] = {'<cmd>lua require"telescope.builtin".find_files({ find_command = {"rg", "--files", "--hidden", "-g", "!.git" }})<cr>',
                  'find-files'},

  -- NOTE: a is for actions
  ['a'] = {
    ['name'] = '+actions',
    ['a'] = {':Cheatsheet<CR>', 'cheatsheet'},
    ['b'] = {':AnyJumpBack<CR>', 'any-jump-back'},
    ['c'] = {':Telescope neoclip<CR>', 'clipboard'},
    ['f'] = {':NvimTreeFindFile<CR>', 'nvim-tree-find-file'},
    ['h'] = {':Telescope frecency<CR>', 'telescope-frecency'},
    ['l'] = {':Bracey<CR>', 'start-live-server'},
    ['L'] = {':BraceyStop<CR>', 'stop-live-server'},
    ['m'] = {':MarkdownPreview<CR>', 'markdown-preview'},
    ['M'] = {':MarkdownPreviewStop<CR>', 'markdown-preview-stop'},
    ['p'] = {':PlugHelp<CR>', 'plug-help'},
    ['r'] = {':NvimTreeRefresh<CR>', 'nvim-tree-refresh'},
    ['w'] = {':StripWhitespace<CR>', 'strip-whitespace'},
    ['z'] = {':Goyo<CR>', 'goyo'}
  },

  -- NOTE: b is for buffers
  ['b'] = {
    ['name'] = '+buffers',
    ['['] = {':bp<CR>', 'prev-buffer'},
    [']'] = {':bn<CR>', 'next-buffer'},
    ['a'] = {':JABSOpen<CR>', 'beautiful-buffer-switcher'},
    ['b'] = {':Telescope buffers<CR>', 'telescope-buffers'},
    ['c'] = {':vnew<CR>', 'new-empty-buffer-vert'},
    ['C'] = {':BDelete other<CR>', 'close-all-but-current'},
    ['d'] = {':BDelete this<CR>', 'delete-buffer'},
    ['D'] = {':BDelete all<CR>', 'delete-all-buffers'},
    ['f'] = {':bfirst<CR>', 'first-buffer'},
    ['g'] = {':BufferLinePick<CR>', 'goto-buffer'},
    ['h'] = {':Startify<CR>', 'home-buffer'},
    ['j'] = {':BufferPick<CR>', 'buffer-pick'},
    ['l'] = {':Telescope current_buffer_fuzzy_find<CR>', 'search-buffer-lines'},
    ['L'] = {':blast<CR>', 'first-buffer'},
    ['m'] = {':delm!<CR>', 'delete-marks'},
    ['n'] = {':BufferLineCycleNext<CR>', 'next-buffer'},
    ['N'] = {':BufferLineMoveNext<CR>', 'move-next-buffer'},
    ['o'] = {':BufferLineSorByDirectory<CR>', 'order-by-direcoty'},
    ['O'] = {':BufferLineSortByExtension<CR>', 'order-by-language'},
    ['p'] = {':BufferLineCyclePrev<CR>', 'previous-buffer'},
    ['P'] = {':BufferLineMovePrev<CR>', 'move-previous-buffer'},
    ['r'] = {':e<CR>', 'refresh-buffer'},
    ['R'] = {':bufdo :e<CR>', 'refresh-loaded-buffers'},
    ['s'] = {':new<CR>', 'new-empty-buffer'},
    ['u'] = {':BDelete nameless<CR>', 'delete-nameless-buffers'},
    ['w'] = {':BDelete all<CR>', 'close-buffer-and-window'}
  },

  -- NOTE: c is for code with lspconfig
  ['c'] = {
    ['name'] = '+code',
    ['a'] = {':Lspsaga code_action<CR>', 'code-action'},
    ['A'] = {':Lspsaga range_code_action<CR>', 'range-code-action'},
    ['b'] = {':Telescope lsp_code_actions<CR>', 'lsp-code-actions'},
    ['B'] = {':Telescope lsp_range_code_actions<CR>', 'lsp-range-code-actions'},
    ['c'] = {':Lspsaga close_floatterm<CR>', 'close-floatterm'},
    ['d'] = {':Telescope lsp_definitions<CR>', 'lsp-definitions'},
    ['e'] = {':Telescope lsp_document_diagnostics<CR>', 'lsp-document-diagnostics'},
    ['E'] = {':Telescope lsp_workspace_diagnostics<CR>', 'lsp-workspace-diagnostics'},
    ['h'] = {':Lspsaga hover_doc<CR>', 'hover-doc'},
    ['H'] = {':Lspsaga signaute_help<CR>', 'signature-help'},
    ['o'] = {':Lspsaga open_floatterm<CR>', 'open-floatterm'},
    ['p'] = {':Lspsaga preview_definition<CR>', 'preview-definition'},
    ['r'] = {':Telescope lsp_references<CR>', 'lsp-references'},
    ['R'] = {':Lspsaga lsp_finder<CR>', 'references'},
    ['s'] = {':SymbolsOutline<CR>', 'symbols-outline'},
    ['t'] = {':Telescope treesitter<CR>', 'treesitter-symbols'},
    ['w'] = {':Telescope lsp_document_symbols<CR>', 'lsp-document-symbols'},
    ['W'] = {':Telescope lsp_workspace_symbols<CR>', 'lsp-workspace-symbols'}
  },

  -- NOTE: c is for code with coc.nvim
  -- ['c'] = {
  --   ['name'] = '+coc',
  --   ['a'] = { ':CocAction<CR>', 'action' },
  --   ['c'] = { ':CocCommand<CR>', 'commands' },
  --   ['d'] = { ':CocDiagnostics<CR>', 'diagnostics' },
  --   ['e'] = { ':CocConfig<CR>', 'config' },
  --   ['f'] = { ':CocFix<CR>', 'fix' },
  --   ['g'] = 'grep-word-current-buffer',
  --   ['G'] = 'grep-word-project',
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
  --     ['z'] = { ':CocList tags<CR>', 'tag-files' },
  --   },
  --   ['r'] = { ':call coc#refresh()<CR>', 'coc-refresh' },
  --   ['R'] = { ':CocListResume<CR>', 'list-resume' },
  --   ['s'] = { ':CocSearch<CR>', 'search' },
  --   ['t'] = {
  --     ['name'] = '+telescope',
  --     ['a'] = { ':Telescope coc code_actions<CR>', 'actions' },
  --     ['c'] = { ':Telescope coc commands<CR>', 'commands' },
  --     ['d'] = { ':Telescope coc definitions<CR>', 'definitions' },
  --     ['D'] = { ':Telescope coc declarations<CR>', 'declarations' },
  --     ['e'] = { ':Telescope coc diagnostics<CR>', 'diagnostics' },
  --     ['E'] = {
  --       ':Telescope coc workspace_diagnostics<CR>',
  --       'workspace-diagnostics',
  --     },
  --     ['g'] = { ':Telescope coc code_actions<CR>', 'code_actions' },
  --     ['i'] = { ':Telescope coc implementations<CR>', 'implementations' },
  --     ['I'] = { ':Telescope coc type_definitions<CR>', 'type_definitions' },
  --     ['l'] = { ':Telescope coc links<CR>', 'links' },
  --     ['m'] = { ':Telescope coc mru<CR>', 'mru' },
  --     ['o'] = { ':Telescope coc file_code_actions<CR>', 'file-code-actions' },
  --     ['O'] = { ':Telescope coc line_code_actions<CR>', 'line-code-actions' },
  --     ['r'] = { ':Telescope coc references<CR>', 'references' },
  --     ['w'] = { ':Telescope coc document_symbols<CR>', 'document-symbols' },
  --     ['W'] = { ':Telescope coc workspace_symbols<CR>', 'workspace-symbols' },
  --   },
  --   ['x'] = { '<Plug>(coc-convert-snippet)', 'covert-to-snippet' },
  -- },

  -- NOTE: d is for dap
  ['d'] = {
    ['name'] = '+dap',
    ['?'] = {[[<cmd>lua require'dap.ui.variables'.scopes()<CR>]], 'scopes'},
    ['c'] = {[[<cmd>lua require'dap'.continue()<CR>]], 'continue'},
    ['o'] = {[[<cmd>lua require'dap'.step_over()<CR>]], 'step-over'},
    ['i'] = {[[<cmd>lua require'dap'.step_into()<CR>]], 'step-into'},
    ['e'] = {[[<cmd>lua require'dap'.step_out()<CR>]], 'step-out'},
    ['b'] = {[[<cmd>lua require'dap'.toggle_breakpoint()<CR>]], 'toggle-breakpoint'},
    ['B'] = {[[<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>]],
             'set-breakpoint-condition'},
    ['l'] = {[[<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>]],
             'set-breakpoint-log-message'},
    ['r'] = {[[<cmd>lua require'dap'.repl.open()<CR>]], 'open-repl'},
    ['R'] = {[[<cmd>lua require'dap'.repl.run_last()<CR>]], 'repl-run-last'}
  },

  -- NOTE: e is for errors/warnings using lspconfig
  ['e'] = {
    ['name'] = '+errors/warnings',
    ['l'] = {':Telescope lsp_document_diagnostics<CR>', 'buffer-diagnostics'},
    ['L'] = {':Telescope lsp_workspace_diagnostics<CR>', 'workspace_diagnostics'},
    ['n'] = {':Lspsaga diagnostic_jump_next<CR>', 'next-diagnostic'},
    ['p'] = {':Lspsaga diagnostic_jump_prev<CR>', 'prev-diagnostic'}
  },

  -- NOTE: e is for errors/warnings using coc
  -- ['e'] = {
  --   ['name'] = '+errors/warnings',
  --   ['l'] = { ':Telescope coc diagnostics<CR>', 'buffer-diagnostics' },
  --   ['L'] = {
  --     ':Telescope coc workspace_diagnostics<CR>',
  --     'workspace_diagnostics',
  --   },
  --   ['n'] = { '<Plug>(coc-diagnostic-next)', 'next-diagnostic' },
  --   ['p'] = { '<Plug>(coc-diagnostic-prev)', 'prev-diagnostic' },
  -- },

  -- NOTE: f is for FZF
  ['f'] = {
    ['name'] = '+files',
    ['s'] = {':w<CR>', 'save-buffer'},
    ['S'] = {':wa<CR>', 'save-all-buffers'}
  },

  -- NOTE: F is for find and replace
  ['F'] = {
    ['name'] = '+search/replace',
    ['f'] = {':Tgrep<CR>', 'grep'},
    ['F'] = 'grep-and-replace',
    ['o'] = {':lua require("spectre").open()<CR>', 'spectre-open'},
    ['r'] = 'replace-text-object',
    ['R'] = 'replace-current-word',
    ['v'] = {':lua require("spectre").open_visual()<CR>', 'search-and-replace-selected'},
    ['w'] = {'viw:lua require("spectre").open_file_search()<cr>', 'search-and-replace-in-current-buffer'},
    ['W'] = {':lua require("spectre").open_visual({select_word=true})<CR>', 'search-and-replace-current-word'}

  },

  -- NOTE: g is for git
  ['g'] = {
    ['name'] = '+git',
    ['b'] = {':lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<CR>',
             'open-repo-browser'},
    ['c'] = {':Telescope git_branches<CR>', 'checkout'},
    ['d'] = {':DiffviewOpen<CR>', 'diffview-open'},
    ['D'] = {':DiffviewClose<CR>', 'diffview-close'},
    ['h'] = {
      ['name'] = '+gitsigns-hunks',
      ['a'] = {':Gitsigns attach<CR>', 'attach'},
      ['A'] = {':Gitsigns get_actions<CR>', 'get-actions'},
      ['b'] = {':Gitsigns blame_line<CR>', 'blame-line'},
      ['B'] = {':Gitsigns stage_buffer<CR>', 'stage-buffer'},
      ['c'] = {':Gitsigns setup<CR>', 'setup'},
      ['C'] = {':Gitsigns change_base<CR>', 'change-base'},
      ['d'] = {':Gitsigns diffthis<CR>', 'diffthis'},
      ['D'] = {':Gitsigns detach<CR>', 'detach'},
      ['i'] = {':Gitsigns reset_buffer_index<CR>', 'reset-buffer-index'},
      ['n'] = {':Gitsigns next_hunk<CR>', 'next-hunk'},
      ['p'] = {':Gitsigns prev_hunk<CR>', 'prev-hunk'},
      ['P'] = {':Gitsigns preview_hunk<CR>', 'preview_hunk'},
      ['r'] = {':Gitsigns refresh<CR>', 'refresh'},
      ['R'] = {':Gitsigns reset_buffer<CR>', 'reset-buffer'},
      ['s'] = {':Gitsigns stage_hunk<CR>', 'stage-hunk'},
      ['S'] = {':Gitsigns select_hunk<CR>', 'select-hunk'},
      ['u'] = {':Gitsigns detach_all<CR>', 'detach-all'},
      ['U'] = {':Gitsigns reset_hunk<CR>', 'reset-hunk'}
    },
    ['m'] = {':Gitsigns blame_line<CR>', 'blame-line'},
    ['o'] = {
      ['name'] = '+octo.nvim',
      ['a'] = {
        ['name'] = '+reaction',
        ['c'] = {':Octo reaction confused<CR>', 'react-confused'},
        ['d'] = {':Octo reaction thumbs_down<CR>', 'react-thumbs_down'},
        ['e'] = {':Octo reaction eyes<CR>', 'react-eyes'},
        ['h'] = {':Octo reaction heart<CR>', 'react-heart'},
        ['l'] = {':Octo reaction laugh<CR>', 'react-laugh'},
        ['r'] = {':Octo reaction rocket<CR>', 'react-rocket'},
        ['t'] = {':Octo reaction tada<CR>', 'react-tada'},
        ['u'] = {':Octo reaction thumbs_up<CR>', 'react-thumbs_up'}
      },
      ['A'] = {':Octo reviewer add<CR>', 'add-reviewer'},
      ['c'] = {
        ['name'] = '+comment',
        ['a'] = {':Octo comment add<CR>', 'add'},
        ['d'] = {':Octo comment delete<CR>', 'delete'}
      },
      ['g'] = {':Octo gist list<CR>', 'list-gist'},
      ['i'] = {
        ['name'] = '+issues',
        ['a'] = {':Octo issue create<CR>', 'create'},
        ['b'] = {':Octo issue browser<CR>', 'browser'},
        ['c'] = {':Octo issue close<CR>', 'close'},
        ['e'] = {':Octo issue edit<CR>', 'edit'},
        ['l'] = {':Octo issue list<CR>', 'list'},
        ['o'] = {':Octo issue reopen<CR>', 'reopen'},
        ['r'] = {':Octo issue reload<CR>', 'reload'},
        ['s'] = {':Octo issue search<CR>', 'search'},
        ['u'] = {':Octo issue url<CR>', 'url'}
      },
      ['l'] = {
        ['name'] = '+label',
        ['a'] = {':Octo label add<CR>', 'add'},
        ['c'] = {':Octo label create<CR>', 'create'},
        ['r'] = {':Octo label remove<CR>', 'remove'}
      },
      ['p'] = {
        ['name'] = '+pull-requests',
        ['a'] = {':Octo pr create<CR>', 'create'},
        ['b'] = {':Octo pr browser<CR>', 'browser'},
        ['c'] = {':Octo pr checkout<CR>', 'checkout'},
        ['C'] = {':Octo pr close<CR>', 'close'},
        ['d'] = {':Octo pr diff<CR>', 'diff'},
        ['D'] = {':Octo pr checks<CR>', 'checks'},
        ['e'] = {':Octo pr edit<CR>', 'edit'},
        ['g'] = {':Octo pr commits<CR>', 'commits'},
        ['h'] = {':Octo pr changes<CR>', 'changes'},
        ['l'] = {':Octo pr list<CR>', 'list'},
        ['m'] = {':Octo pr merge<CR>', 'merge'},
        ['o'] = {':Octo pr reopen<CR>', 'reopen'},
        ['r'] = {':Octo pr reload<CR>', 'reload'},
        ['R'] = {':Octo pr ready<CR>', 'ready'},
        ['s'] = {':Octo pr search<CR>', 'search'},
        ['u'] = {':Octo pr url<CR>', 'url'}
      },
      ['r'] = {
        ['name'] = '+repositories',
        ['b'] = {':Octo repo browser<CR>', 'browser'},
        ['f'] = {':Octo repo fork<CR>', 'fork'},
        ['l'] = {':Octo repo list<CR>', 'list'},
        ['u'] = {':Octo repo url<CR>', 'url'}
      },
      ['R'] = {
        ['name'] = '+review',
        ['b'] = {':Octo review start<CR>', 'start-review'},
        ['c'] = {':Octo review comments<CR>', 'comments-review'},
        ['d'] = {':Octo review discard<CR>', 'discard-review'},
        ['r'] = {':Octo review resume<CR>', 'resume-review'},
        ['s'] = {':Octo review submit<CR>', 'submit-review'}
      },
      ['t'] = {
        ['name'] = '+thread',
        ['r'] = {':Octo thread resolve<CR>', 'resolve'},
        ['u'] = {':Octo thread unresolve<CR>', 'unresolve'}
      }
    },
    ['s'] = {':Neogit<CR>', 'status'},
    ['S'] = {':GGrep<CR>', 'git-grep'},
    ['y'] = {'git-linker'},
    ['Y'] = {':lua require"gitlinker".get_repo_url()<CR>', 'copy-repo-url'},
    ['w'] = {
      ['name'] = '+git-worktree',
      ['c'] = {':Telescope git_worktree create_git_worktree<CR>', 'create-worktree'},
      ['l'] = {':Telescope git_worktree git_worktrees<CR>', 'list-worktrees'}
    }
  },

  ['G'] = {
    ['name'] = '+goneovim',
    ['a'] = {':GonvimFuzzyAg<CR>', 'fuzzy-ag'},
    ['b'] = {':GonvimFuzzyBuffers<CR>', 'fuzzy-buffers'},
    ['f'] = {':GonvimFuzzyFiles<CR>', 'fuzzy-files'},
    ['F'] = {':GonvimFilerOpen<CR>', 'external-file-explorer'},
    ['l'] = {':GonvimFuzzyBLines<CR>', 'fuzzy-buffer-lines'},
    ['m'] = {':GonvimMarkdown<CR>', 'markdown-preview'},
    ['M'] = {':GonvimMiniMap<CR>', 'toggle-minimap'},
    ['n'] = {':GonvimWorkspaceNext<CR>', 'next-workspace'},
    ['N'] = {':GonvimWorkspaceNew<CR>', 'create-new-workspace'},
    ['p'] = {':GonvimWorkspacePrevious<CR>', 'previous-workspace'},
    ['r'] = {':GonvimFuzzyResume<CR>', 'resume-previous-search'},
    ['s'] = {':GonvimWorkspaceSwitch <CR>', 'switch-workspace'},
    ['w'] = {':GonvimFuzzyAgCword<CR>', 'fuzzy-word'}
  },

  -- NOTE: h is for highlight
  ['h'] = {
    ['name'] = '+highlight',
    ['c'] = {'<Plug>(InYoFace_Toggle)<CR>', 'highlight-comments'},
    ['t'] = {
      ['name'] = '+todo-comments',
      ['q'] = {':TodoQuickFix<CR>', 'todos-quickfix'},
      ['t'] = {':TodoTelescope<CR>', 'todos-telescope'},
      ['b'] = {':TodoTrouble<CR>', 'todos-trouble'}
    }
  },

  -- NOTE: j is for jumping
  ['j'] = {
    ['name'] = '+jumping',
    ['c'] = {':HopChar1<CR>', 'hop-char-1'},
    ['d'] = {':HopChar2<CR>', 'hop-char-2'},
    ['h'] = {':AnyJumpLastResults<CR>', 'anyjump-last-results'},
    ['l'] = {':HopLine<CR>', 'hop-line'},
    ['p'] = {':HopPattern<CR>', 'hop-pattern'},
    ['s'] = {':AnyJump<CR>', 'anyjump'},
    ['S'] = {':AnyJumpBack<CR>', 'anyjump-back'},
    ['w'] = {':HopWord<CR>', 'hop-word'}
  },

  -- NOTE: l is for lsp with lspconfig
  ['l'] = {
    ['name'] = '+Lspsaga',
    ['a'] = {':Lspsaga code_action<CR>', 'code-action'},
    ['A'] = {':Lspsaga range_code_action<CR>', 'range-code-action'},
    ['d'] = {':Lspsaga hover_doc<CR>', 'hover-doc'},
    ['e'] = {
      ['name'] = '+diagnostics',
      ['l'] = {':Lspsaga show_line_diagnostics<CR>', 'show-line-diagnostics'},
      ['n'] = {':Lspsaga diagnostic_jump_next<CR>', 'next-diagnostic'},
      ['p'] = {':Lspsaga diagnostic_jump_prev<CR>', 'prev-diagnostic'}
    },
    ['i'] = {':LspInfo<CR>', 'lsp-info'},
    ['l'] = {':Lspsaga lsp_finder<CR>', 'finder'},
    ['p'] = {':Lspsaga preview_definition<CR>', 'preview-definition'},
    ['r'] = {':LspRename<CR>', 'rename'},
    ['s'] = {':Lspsaga signature_help<CR>', 'signature-help'},
    ['t'] = {':Lspsaga open_floatterm<CR>', 'open-floatterm'},
    ['T'] = {':Lspsaga close_floatterm<CR>', 'close-floatterm'},
    ['v'] = {
      ['name'] = '+vista',
      ['a'] = {':Vista ale<CR>', 'ale'},
      ['A'] = {':Vista finder fzf:ale<CR>', 'fzf:ale'},
      ['c'] = {':Vista coc<CR>', 'coc'},
      ['C'] = {':Vista finder fzf:coc<CR>', 'fzf:coc'},
      ['f'] = {':Vista finder<CR>', 'finder'},
      ['F'] = {':Vista finder!<CR>', 'finder!'},
      ['g'] = {':Vista ctags<CR>', 'ctags'},
      ['G'] = {':Vista finder skim:ctags<CR>', 'skim:ctags'},
      ['i'] = {':Vista info<CR>', 'info'},
      ['I'] = {':Vista info+<CR>', 'info+'},
      ['j'] = {':Vista focus<CR>', 'focus'},
      ['n'] = {':Vista nvim_lsp<CR>', 'nvim-lsp'},
      ['N'] = {':Vista finder fzf:nvim_lsp<CR>', 'fzf:nvim_lsp'},
      ['s'] = {':Vista show<CR>', 'show'},
      ['t'] = {':Vista!!<CR>', 'toggle-vista'},
      ['u'] = {':Vista vim_lsc<CR>', 'vim_lsc'},
      ['v'] = {':Vista vim_lsp<CR>', 'vim_lsp'}
    },
    ['w'] = {
      ['name'] = '+workspace',
      ['a'] = {':LspAddToWorkspaceFolder<CR>', 'add-folder-to-workspace'},
      ['l'] = {':LspListWorkspaceFolders<CR>', 'list-workspace-folders'},
      ['r'] = {':LspRemoveWorkspaceFolder<CR>', 'remove-workspace-folder'},
      ['s'] = {':LspWorkspaceSymbols<CR>', 'workspace-symbols'}
    }
  },

  -- NOTE: l is for lsp with coc.nvim
  -- ['l'] = {
  --   ['name'] = '+lsp',
  --   ['.'] = { ':CocConfig<CR>', 'config' },
  --   [';'] = { '<Plug>(coc-refactor)', 'refactor' },
  --   ['A'] = { '<Plug>(coc-codeaction-selected)', 'selected-action' },
  --   ['B'] = { ':CocPrev<CR>', 'prev-action' },
  --   ['D'] = { '<Plug>(coc-declaration)', 'declaration' },
  --   ['F'] = { '<Plug>(coc-format)', 'format' },
  --   ['I'] = { ':CocList diagnostics<CR>', 'diagnostics' },
  --   ['N'] = { '<Plug>(coc-diagnostic-next-error)', 'next-error' },
  --   ['O'] = { ':CocList outline<CR>', 'outline' },
  --   ['P'] = { '<Plug>(coc-diagnostic-prev-error)', 'prev-error' },
  --   ['R'] = { '<Plug>(coc-references)', 'references' },
  --   ['S'] = { ':CocList snippets<CR>', 'snippets' },
  --   ['U'] = { ':CocUpdate<CR>', 'update-CoC' },
  --   ['a'] = { '<Plug>(coc-codeaction)', 'line-action' },
  --   ['b'] = { ':CocNext<CR>', 'next-action' },
  --   ['c'] = { ':CocList commands<CR>', 'commands' },
  --   ['d'] = { '<Plug>(coc-definition)', 'definition' },
  --   ['e'] = { ':CocList extensions<CR>', 'extensions' },
  --   ['f'] = { '<Plug>(coc-format-selected)', 'format-selected' },
  --   ['h'] = { '<Plug>(coc-float-hide)', 'hide' },
  --   ['i'] = { '<Plug>(coc-implementation)', 'implementation' },
  --   ['j'] = { '<Plug>(coc-float-jump)', 'float-jump' },
  --   ['l'] = { '<Plug>(coc-codelens-action)', 'code-lens' },
  --   ['n'] = { '<Plug>(coc-diagnostic-next)', 'next-diagnostic' },
  --   ['o'] = { ':Vista!!<CR>', 'outline' },
  --   ['p'] = { '<Plug>(coc-diagnostic-prev)', 'prev-diagnostic' },
  --   ['q'] = { '<Plug>(coc-fix-current)', 'quickfix' },
  --   ['r'] = { '<Plug>(coc-rename)', 'rename-symbol' },
  --   ['s'] = { ':CocList -I symbols<CR>', 'symbols' },
  --   ['t'] = { '<Plug>(coc-type-definition)', 'type-definition' },
  --   ['u'] = { ':CocListResume<CR>', 'resume-list' },
  --   ['v'] = {
  --     ['name'] = '+vista',
  --     ['c'] = { ':Vista coc<CR>', 'coc' },
  --     ['C'] = { ':Vista finder fzf:coc<CR>', 'fzf:coc' },
  --     ['f'] = { ':Vista finder<CR>', 'finder' },
  --     ['F'] = { ':Vista finder!<CR>', 'finder!' },
  --     ['g'] = { ':Vista ctags<CR>', 'ctags' },
  --     ['G'] = { ':Vista finder skim:ctags<CR>', 'skim:ctags' },
  --     ['i'] = { ':Vista info<CR>', 'info' },
  --     ['I'] = { ':Vista info+<CR>', 'info+' },
  --     ['j'] = { ':Vista focus<CR>', 'focus' },
  --     ['s'] = { ':Vista show<CR>', 'show' },
  --     ['t'] = { ':Vista!!<CR>', 'toggle-vista' },
  --   },
  --   ['z'] = { ':CocDisable<CR>', 'disable-CoC' },
  --   ['Z'] = { ':CocEnable<CR>', 'enable-CoC' },
  -- },

  -- NOTE: L is for lspconfig
  ['L'] = {
    ['name'] = '+builtin-lsp',
    ['a'] = {':LspCodeActions<CR>', 'code-action'},
    ['A'] = {':LspRangeCodeActions<CR>', 'range-code-action'},
    ['e'] = {
      ['name'] = '+diagnostics',
      ['a'] = {':LspGetAllDiagnostics<CR>', 'all-diagnostics'},
      ['l'] = {':LspShowLineDiagnostics<CR>', 'show-line-diagnostics'},
      ['n'] = {':LspGotoNextDiagnostic<CR>', 'next-diagnostic'},
      ['N'] = {':LspGetNextDiagnostic<CR>', 'get-next-diagnostic'},
      ['p'] = {':LspGotoPrevDiagnostic<CR>', 'prev-diagnostic'},
      ['P'] = {':LspGetPrevDiagnostic<CR>', 'get-prev-diagnostic'}
    },
    ['f'] = {
      ['name'] = '+formatting',
      ['f'] = {':LspFormatting<CR>', 'formatting'},
      ['r'] = {':LspRangeFormatting<CR>', 'range-formatting'},
      ['s'] = {':LspFormattingSync<CR>', 'formatting-sync'}
    },
    ['g'] = {
      ['name'] = '+definitions/references',
      ['c'] = {':LspClearReferences<CR>', 'clear-references'},
      ['d'] = {':LspDefinition<CR>', 'definition'},
      ['i'] = {':LspDeclaration<CR>', 'declaration'},
      ['r'] = {':LspReferences<CR>', 'references'},
      ['t'] = {':LspTypeDefinition<CR>', 'type-definition'}
    },
    ['h'] = {':LspHover<CR>', 'hover-doc'},
    ['H'] = {':LspDocumentHighlight<CR>', 'document-highlight'},
    ['i'] = {':LspIncomingCalls<CR>', 'incoming-calls'},
    ['o'] = {':LspOutGoingCalls<CR>', 'outgoing-calls'},
    ['r'] = {':LspRename<CR>', 'rename'},
    ['s'] = {':LspDocumentSymbols<CR>', 'document-symbols'},
    ['S'] = {':LspWorkspaceSymbols<CR>', 'document-symbols'},
    ['w'] = {
      ['name'] = '+workspace',
      ['a'] = {':LspAddToWorkspaceFolder<CR>', 'add-folder-to-workspace'},
      ['l'] = {':LspListWorkspaceFolders<CR>', 'list-workspace-folders'},
      ['r'] = {':LspRemoveWorkspaceFolder<CR>', 'remove-workspace-folder'},
      ['s'] = {':LspWorkspaceSymbols<CR>', 'workspace-symbols'}
    },
    ['y'] = {':LspImplementation<CR>', 'implementation'}
  },

  -- NOTE: m is for major mode for lspconfig
  ['m'] = {
    ['name'] = '+major-mode',
    ['a'] = {':Telescope lsp_code_actions<CR>', 'code-actions'},
    ['b'] = {':Telescope lsp_range_code_actions<CR>', 'range-code-actions'},
    ['c'] = {':MakeTags<CR>', 'make-ctags'},
    ['d'] = {':Telescope lsp_document_diagnostics<CR>', 'document-diagnostics'},
    ['D'] = {':Telescope lsp_workspace_diagnostics<CR>', 'workspace-diagnostics'},
    ['f'] = {':Telescope lsp_references<CR>', 'references'},
    ['j'] = {':Telescope lsp_workspace_symbols<CR>', 'workspace-symbols'},
    ['r'] = {':lua MyLspRename()<CR>', 'rename-symbol'},
    ['s'] = {':Telescope lsp_document_symbols<CR>', 'buffer-symbols'}
  },

  -- NOTE: m is for major mode for coc
  -- ['m'] = {
  --   ['name'] = '+major-mode',
  --   ['a'] = { ':Telescope coc code_actions<CR>', 'code-actions' },
  --   ['A'] = { ':Telescope coc line_code_actions<CR>', 'line-code-actions' },
  --   ['c'] = { ':Telescope coc commands<CR>', 'commands' },
  --   ['d'] = { ':Telescope coc definitions<CR>', 'definitions' },
  --   ['D'] = { ':Telescope coc declarations<CR>', 'declarations' },
  --   ['e'] = { ':Telescope coc diagnostics<CR>', 'document-diagnostics' },
  --   ['E'] = {
  --     ':Telescope coc workspace_diagnostics<CR>',
  --     'workspace-diagnostics',
  --   },
  --   ['f'] = { ':Telescope coc references<CR>', 'references' },
  --   ['F'] = { ':Telescope coc file_code_actions<CR>', 'file-code-actions' },
  --   ['i'] = { ':Telescope coc implementations<CR>', 'implementations' },
  --   ['j'] = { ':Telescope coc locations<CR>', 'locations' },
  --   ['l'] = { '<Plug>(JsConsoleLog)', 'console-log' },
  --   ['L'] = { ':Telescope coc links<CR>', 'links' },
  --   ['h'] = { ':Telescope coc mru<CR>', 'most-recent' },
  --   ['r'] = { '<Plug>(coc-rename)', 'rename-symbol' },
  --   ['s'] = { ':Telescope coc document_symbols<CR>', 'buffer-symbols' },
  --   ['S'] = { ':Telescope coc workspace_symbols<CR>', 'workspace-symbols' },
  --   ['t'] = { ':Telescope coc type_definitions<CR>', 'type_definitions' },
  -- },

  -- NOTE: n is for neovim
  ['n'] = {
    ['name'] = '+neovim',
    ['c'] = {':PackerCompile<CR>', 'packer-compile'},
    ['d'] = {':PackerClean<CR>', 'clean-packages'},
    ['e'] = {':e $HOME/.config/nvim/init.lua<CR>', 'edit-config'},
    ['h'] = 'tj-help-tags',
    ['H'] = {':checkhealth<CR>', 'check-health'},
    ['i'] = {':PackerInstall<CR>', 'packer-install'},
    ['l'] = 'source-current',
    ['p'] = 'tj-installed-plugins',
    ['P'] = {':PackerProfile<CR>', 'packer-profile'},
    ['r'] = {':luafile $HOME/.config/nvim/init.lua<CR>', 'source-config'},
    ['s'] = {':PackerSync<CR>', 'packer-sync'},
    ['S'] = {':PackerStatus<CR>', 'packages-status'},
    ['u'] = {':PackerUpdate<CR>', 'packer-update'}
  },

  -- NOTE: N is for notes
  ['N'] = {
    ['name'] = '+notes',
    ['a'] = {':lua require"neuron/cmd".new_edit(require"neuron".config.neuron_dir)<CR>', 'create-new-note'},
    ['b'] = {':lua require"neuron/telescope".find_backlinks()<CR>', 'find-backlinks'},
    ['B'] = {':lua require"neuron/telescope".find_backlinks{ insert = true }<CR>', 'find-backlinks-insert'},
    ['e'] = {':lua require"neuron".enter_link()<CR>', 'enter-link'},
    ['i'] = {':lua require"neuron/telescope".find_zettels {insert = true}<CR>', 'insert-note-id'},
    ['n'] = {':lua require"neuron".goto_next_extmark()<CR>', 'next'},
    ['p'] = {':lua require"neuron".goto_next_extmark()<CR>', 'prev'},
    ['s'] = {':lua require"neuron".rib {address = "127.0.0.1:8200", verbose = true}<CR>', 'serve-notes'},
    ['t'] = {':lua require"neuron/telescope".find_tags()<CR>', 'find-tags'},
    ['z'] = {':lua require"neuron/telescope".find_zettels()<CR>', 'search-notes'}
  },

  -- NOTE: o is for telescope
  ['o'] = {
    ['name'] = '+Telescope',
    ['a'] = {[[:lua require('telescope.builtin').symbols{sources = {'emoji'}}<cr>]], 'emojis'},
    ['b'] = {
      ['name'] = '+buffers',
      ['a'] = {':Telescope lsp_code_actions<CR>', 'code-actions'},
      ['b'] = {':Telescope buffers<CR>', 'buffers'},
      ['B'] = {':Telescope tele_tabby list<CR>', 'tele-tabby-buffers'},
      ['c'] = {':Telescope lsp_range_code_actions<CR>', 'range-code-actions'},
      ['d'] = {':Telescope lsp_document_symbols<CR>', 'buffer-symbols'},
      ['f'] = {[[:lua require('telescope.builtin').buffers({ entry_maker = require('lk.plugins.telescope.my_make_entry').gen_from_buffer_like_leaderf() })<cr>]],
               'find-buffers'},
      ['j'] = {':Telescope lsp_workspace_symbols<CR>', 'workspace-symbols'},
      ['l'] = {':Telescope current_buffer_fuzzy_find<CR>', 'buffer-lines'},
      ['o'] = 'buffer-lines-dropdown-theme',
      ['r'] = {':Telescope lsp_references<CR>', 'references'},
      ['s'] = {':Telescope spell_suggest<CR>', 'spell_suggest'},
      ['t'] = {':Telescope current_buffer_tags<CR>', 'buffer-tags'}
    },
    ['c'] = {
      ['name'] = '+cheat.sh',
      ['f'] = {':Telescope cheat fd<CR>', 'cheat-find'},
      ['r'] = {':Telescope cheat readcache<CR>', 'read-cache'}
    },
    ['d'] = {
      ['name'] = '+dap',
      ['b'] = {':Telescope dap lsp_breakpoints<CR>', 'lsp-breakpoints'},
      ['c'] = {':Telescope dap configurations<CR>', 'configurations'},
      ['f'] = {':Telescope dap frames<CR>', 'frames'},
      ['o'] = {':Telescope dap commands<CR>', 'commands'},
      ['v'] = {':Telescope dap variables<CR>', 'variables'}
    },
    ['e'] = {':Telescope emoji search<CR>', 'emoji-search'},
    ['f'] = {
      ['name'] = '+files',
      ['a'] = 'tj-search-all-files',
      ['c'] = 'dotfiles',
      ['d'] = {[[:lua require('lk.plugins.telescope.finders').fd_files_dropdown()<cr>]], 'with-dropdown'},
      ['e'] = {':Telescope file_browser<CR>', 'file-browser'},
      ['f'] = {'<cmd>lua require"telescope.builtin".find_files({ find_command = {"rg", "--files", "--hidden", "-g", "!.git" }})<cr>',
               'find-files'},

      ['F'] = {':Telescope find_files<CR>', 'find-files'},
      ['g'] = {':Telescope git_files<CR>', 'git-files'},
      ['h'] = {':Telescope frecency<CR>', 'telescope-frecency'},
      ['i'] = {'ivy-theme-files'},
      ['l'] = {'find-files'},
      ['m'] = {':Telescope media_files<CR>', 'media-files'},
      ['n'] = 'nvim-config',
      ['o'] = {':Telescope find_files<CR>', 'find-files'},
      ['r'] = {':Telescope oldfiles<CR>', 'recent-files'},
      ['z'] = {':Telescope filetypes<CR>', 'filetypes'}
    },
    ['g'] = {
      ['name'] = '+git',
      ['a'] = {':Telescope git_commits<CR>', 'git-commits'},
      ['b'] = {':Telescope git_bcommits<CR>', 'git-buffer-commits'},
      ['c'] = {':Telescope git_branches<CR>', 'git-branches'},
      ['f'] = {':Telescope git_files<CR>', 'git-files'},
      ['g'] = {':Telescope git_status<CR>', 'git-status'},
      ['s'] = {':Telescope git_stash<CR>', 'git-stash'}
    },
    ['i'] = {':Telescope snippets snippets<CR>', 'snippets'},
    ['j'] = {':Telescope jumps jumps<CR>', 'jumps'},
    ['l'] = {':Telescope loclist<CR>', 'loclist'},
    ['m'] = {':Telescope man_pages<CR>', 'man-pages'},
    ['n'] = {
      ['name'] = '+navigation/jumps',
      ['j'] = {':Telescope jumps jumps<CR>', 'jumps'},
      ['h'] = {':Telescope harpoon marks<CR>', 'harpoon marks'}
    },
    ['o'] = {
      ['name'] = '+open',
      ['o'] = {':Telescope openbrowser list<CR>', 'openbrowser'},
      ['b'] = {':Telescope bookmarks<CR>', 'bookmarks'}
    },
    ['s'] = {
      ['name'] = '+search',
      ['b'] = {':Telescope current_buffer_fuzzy_find<CR>', 'buffer-lines'},
      ['s'] = {':Telescope live_grep<CR>', 'live-grep'},
      ['S'] = {':Telescope live_grep<CR>', 'live-grep'},
      ['u'] = {':Telescope grep_string<CR>', 'grep-string'},
      ['w'] = {[[:lua require("telescope").extensions.arecibo.websearch()<CR>]], 'search-web'}
    },
    ['t'] = {
      ['name'] = '+telescope',
      ['b'] = {':Telescope builtin<CR>', 'builtins'},
      ['p'] = {':Telescope planets<CR>', 'planets'},
      ['r'] = {':Telescope reloader<CR>', 'reloaders'},
      ['t'] = {':Telescope treesitter<CR>', 'reloaders'},
      ['w'] = 'change-background'
    },
    ['u'] = {':Telescope ultisnips ultisnips<CR>', 'ultisnips'},
    ['v'] = {
      ['name'] = '+vim',
      [';'] = {':Telescope commands<CR>', 'commands'},
      ['a'] = {':Telescope autocommands<CR>', 'autocommands'},
      ['c'] = {':Telescope colorscheme<CR>', 'colorschemes'},
      ['h'] = {':Telescope command_history<CR>', 'commands-history'},
      ['H'] = {':Telescope highlights<CR>', 'highlights'},
      ['k'] = {':Telescope keymaps<CR>', 'keymaps'},
      ['m'] = {':Telescope marks<CR>', 'marks'},
      ['r'] = {':Telescope registers<CR>', 'vim-registers'},
      ['t'] = {':Telescope help_tags<CR>', 'help-tags'},
      ['v'] = {':Telescope vim_options<CR>', 'vim-options'}
    },
    ['w'] = {':Telescope grep_string<CR>', 'grep-words'}
  },

  -- NOTE: p is for project
  ['p'] = {
    ['name'] = '+project',
    ['b'] = {':Telescope buffers<CR>', 'find-buffers'},
    ['f'] = {'<cmd>lua require"telescope.builtin".find_files({ find_command = {"rg", "--files", "--hidden", "-g", "!.git" }})<cr>',
             'find-files'},
    ['F'] = {':Telescope find_files<CR>', 'find-files'},
    ['g'] = {':Telescope git_files<CR>', 'find-git-files'},
    ['m'] = {
      ['name'] = '+node-modules',
      ['c'] = {':lua require("package-info").change_version()<CR>', 'change-version'},
      ['d'] = {':lua require("package-info").delete()<CR>', 'delete-package'},
      ['h'] = {':lua require("package-info").hide()<CR>', 'hide-status'},
      ['i'] = {':lua require("package-info").install()<CR>', 'install-package'},
      ['r'] = {':lua require("package-info").reinstall()<CR>', 'reinstall-dependencies'},
      ['s'] = {':lua require("package-info").show()<CR>', 'show-status'},
      ['u'] = {':lua require("package-info").update()<CR>', 'update-package'}
    },
    ['p'] = {':Telescope project project display_type=full<CR>', 'switch-project'},
    ['h'] = {':Telescope frecency<CR>', 'old-files'},
    ['r'] = {':Telescope resume<CR>', 'resume-search'},
    ['s'] = {':Telescope live_grep<CR>', 'project-search'},
    ['w'] = {':Telescope grep_string<CR>', 'string-search'},
    ['W'] = {':Tgrep<CR>', 'tj-grep'}
  },

  -- NOTE: P is for CocCommand fzf-preview using CocCommand
  -- ['P'] = {
  --   ['name'] = '+fzf-preview',
  --   ['b'] = {
  --     ['name'] = '+buffers',
  --     ['a'] = { ':CocCommand fzf-preview.AllBuffers<CR>', 'all-buffers' },
  --     ['b'] = { ':CocCommand fzf-preview.Buffers<CR>', 'buffers' },
  --     ['l'] = { ':CocCommand fzf-preview.BufferLines<CR>', 'buffer-lines' },
  --     ['t'] = { ':CocCommand fzf-preview.BufferTags<CR>', 'buffer-tags' },
  --     ['v'] = {
  --       ':CocCommand fzf-preview.VistaBufferCtags<CR>',
  --       'vista-buffer-ctags',
  --     },
  --   },
  --   ['c'] = { ':CocCommand fzf-preview.CommandPalette<CR>', 'commands-history' },
  --   ['f'] = {
  --     ['name'] = '+files',
  --     ['p'] = { ':CocCommand fzf-preview.ProjectFiles<CR>', 'project-files' },
  --     ['g'] = { ':CocCommand fzf-preview.GitFiles<CR>', 'git-files' },
  --     ['d'] = { ':CocCommand fzf-preview.DirectoryFiles<CR>', 'directory-files' },
  --     ['o'] = {
  --       ':CocCommand fzf-preview.ProjectOldFiles<CR>',
  --       'project-old-files',
  --     },
  --     ['O'] = { ':CocCommand fzf-preview.OldFiles<CR>', 'old-files' },
  --     ['r'] = {
  --       ':CocCommand fzf-preview.ProjectMruFiles<CR>',
  --       'project-mru-files',
  --     },
  --     ['R'] = { ':CocCommand fzf-preview.MruFiles<CR>', 'mru-files' },
  --     ['w'] = {
  --       ':CocCommand fzf-preview.ProjectMrwFiles<CR>',
  --       'project-mrw-files',
  --     },
  --     ['W'] = { ':CocCommand fzf-preview.MrwFiles<CR>', 'mrw-files' },
  --   },
  --   ['g'] = {
  --     ['name'] = '+git',
  --     ['a'] = { ':CocCommand fzf-preview.GitActions', 'git-actions' },
  --     ['b'] = { ':CocCommand fzf-preview.GitBranches', 'git-branches' },
  --     ['B'] = {
  --       ':CocCommand fzf-preview.GitBrancheActions',
  --       'git-branch-actions',
  --     },
  --     ['c'] = { ':CocCommand fzf-preview.Changes<CR>', 'changes' },
  --     ['f'] = { ':CocCommand fzf-preview.GitFiles<CR>', 'git-files' },
  --     ['s'] = { ':CocCommand fzf-preview.GitStatus', 'git-status' },
  --     ['S'] = { ':CocCommand fzf-preview.GitStatusActions',
  --               'git-status-actions' },
  --     ['l'] = { ':CocCommand fzf-preview.GitLogs', 'git-logs' },
  --     ['L'] = { ':CocCommand fzf-preview.GitCurrentLogs', 'git-current-logs' },
  --     ['h'] = { ':CocCommand fzf-preview.GitStashes', 'git-stashes' },
  --     ['H'] = { ':CocCommand fzf-preview.GitStashActions', 'git-stash-actions' },
  --     ['g'] = { ':CocCommand fzf-preview.GitLogActions', 'git-log-actions' },
  --   },
  --   ['j'] = { ':CocCommand fzf-preview.Jumps<CR>', 'jumps' },
  --   ['l'] = { ':CocCommand fzf-preview.LocationList<CR>', 'location-list' },
  --   ['m'] = { ':CocCommand fzf-preview.Marks<CR>', 'marks' },
  --   ['M'] = { ':CocCommand fzf-preview.BlamePR<CR>', 'blame-pr' },
  --   ['p'] = {
  --     ['name'] = '+project',
  --     ['f'] = { ':CocCommand fzf-preview.ProjectFiles<CR>', 'project-files' },
  --     ['o'] = {
  --       ':CocCommand fzf-preview.ProjectOldFiles<CR>',
  --       'project-old-files',
  --     },
  --     ['r'] = {
  --       ':CocCommand fzf-preview.ProjectMruFiles<CR>',
  --       'project-mru-files',
  --     },
  --     ['s'] = { ':CocCommand fzf-preview.ProjectGrep<CR>', 'project-grep' },
  --     ['S'] = {
  --       ':CocCommand fzf-preview.ProjectGrepRecall<CR>',
  --       'project-grep-recall',
  --     },
  --     ['w'] = {
  --       ':CocCommand fzf-preview.ProjectMrwFiles<CR>',
  --       'project-mrw-files',
  --     },
  --   },
  --   ['q'] = { ':CocCommand fzf-preview.QuickFix<CR>', 'quick-fix' },
  --   ['t'] = { ':CocCommand fzf-preview.TodoComments<CR>', 'todo-comments' },
  --   ['v'] = { ':CocCommand fzf-preview.VistCtags<CR>', 'vista-ctags' },
  -- },

  -- NOTE: q is for quickfix and quit
  ['q'] = {
    ['name'] = '+sessions',
    ['c'] = {':SClose<CR>', 'close-session'},
    ['d'] = {':SDelete<CR>', 'delete-session'},
    ['l'] = {':SLoad<CR>', 'load-session'},
    ['q'] = {':qall<CR>', 'quit-session'},
    ['s'] = {':SSave<CR>', 'save-session'}

  },

  -- NOTE: r is for refactor
  -- mappings lies in `lua/lk/plugins/refactoring.lua`
  ['r'] = {
    ['name'] = '+refactor',
    ['e'] = {'extract function'},
    ['f'] = {'extract function to a file'},
    ['r'] = {'refactors'}
  },

  -- NOTE: s is for search
  ['s'] = {
    ['name'] = '+search',
    ['/'] = {':Telescope command_history<CR>', 'history'},
    [';'] = {':Telescope commands<CR>', 'commands'},
    ['a'] = {':Telescope live_grep<CR>', 'live-grep'},
    ['b'] = {':Telescope buffers<CR>', 'buffers'},
    ['c'] = {':Telescope git_commits<CR>', 'commits'},
    ['C'] = {':Telescope git_bcommits<CR>', 'buffer-commits'},
    ['d'] = {':Telescope git_files<CR>', 'git-files'},
    ['f'] = {':Telescope find_files<CR>', 'files'},
    ['g'] = {':Telescope git_status<CR>', 'modified-git-files'},
    ['h'] = {':Telescope help_tags<CR>', 'help-tags'},
    ['H'] = {':Telescope command_history<CR>', 'command-history'},
    ['l'] = {':Telescope current_buffer_fuzzy_find<CR>', 'telescope-buffer-lines'},
    ['m'] = {':Telescope marks<CR>', 'marks'},
    ['M'] = {':Telescope keymaps<CR>', 'keymaps'},
    ['o'] = {':Telescope oldfiles<CR>', 'old-files'},
    ['p'] = {':Telescope live_grep<CR>', 'live-grep'},
    ['r'] = {':Telescope resume<CR>', 'resume-search'},
    ['R'] = {':Telescope registers<CR>', 'registers'},
    ['s'] = {':Telescope ultisnips ultisnips<CR>', 'snippets'},
    ['S'] = {':Telescope colorscheme<CR>', 'color-schemes'},
    ['t'] = {':Telescope tags<CR>', 'project-tags'},
    ['v'] = {':Telescope vim_options<CR>', 'vim-options'},
    ['y'] = {':Telescope filetypes<CR>', 'file-types'}
  },

  -- NOTE: t is for toggle
  ['t'] = {
    ['name'] = '+tabs/terminal/toggle',
    ['c'] = {
      ['name'] = '+colors',
      ['c'] = {':ColorizerToggle<CR>', 'colorizer'},
      ['l'] = {':Twilight<CR>', 'twilight'},
      ['t'] = {':lua require("material.functions").toggle_style()<CR>', 'toggle-material-style'}
    },
    ['e'] = {':NvimTreeToggle<CR>', 'nvim-tree-exlporer'},
    ['f'] = {
      ['name'] = '+floaterm',
      ['G'] = {':lua Tig()<CR>', 'tig'},
      ['a'] = {':lua Terminal_Velocity()<CR>', 'terminal_velocity'},
      ['d'] = {':lua LazyDocker()<CR>', 'docker'},
      ['f'] = {':lua Fzf()<CR>', 'fzf'},
      ['g'] = {':lua LazyGit()<CR>', 'lazygit'},
      ['n'] = {':lua Node()<CR>', 'node'},
      ['p'] = {':lua Python()<CR>', 'python'},
      ['r'] = {':lua Ranger()<CR>', 'ranger'},
      ['s'] = {':lua Ncdu()<CR>', 'ncdu'},
      ['t'] = {':ToggleTerm<CR>', 'toggle'},
      ['v'] = {':lua Grv()<CR>', 'grv'},
      ['w'] = {':lua Wt()<CR>', 'weather'},
      ['y'] = {':lua Btm()<CR>', 'ytop'}
    },
    ['g'] = {
      ['name'] = '+git',
      ['b'] = {':Gitsigns toggle_current_line_blame<CR>', 'toggle-blame'},
      ['l'] = {':Gitsigns toggle_linehl<CR>', 'toggle-linehl'},
      ['n'] = {':Gitsigns toggle_numhl<CR>', 'toggle-numhl'},
      ['s'] = {':Gitsigns toggle_signs<CR>', 'toggle-signs'},
      ['w'] = {':Gitsigns toggle_word_diff<CR>', 'toggle-word-diff'}
    },
    ['h'] = {':sp | te<CR>', 'horizontal-split-terminal'},
    ['s'] = {
      ['name'] = '+scrolloff',
      ['t'] = {':set scrolloff=10<CR>', 'scrolloff=10'},
      ['h'] = {':set scrolloff=5<CR>', 'scrolloff=5'},
      ['n'] = {':set scrolloff=999<CR>', 'scrolloff=999'}
    },
    ['t'] = {':ToggleTerm<CR>', 'terminal'},
    ['v'] = {':vs | te<CR>', 'vertical-split-terminal'},
    ['w'] = {
      ['name'] = '+tabs',
      ['c'] = {':tabclose<CR>', 'close-tab'},
      ['f'] = {':tabfirst<CR>', 'first-tab'},
      ['l'] = {':tablast<CR>', 'last-tab'},
      ['n'] = {':tabnext<CR>', 'next-tab'},
      ['N'] = {':tabnew<CR>', 'new-tab'},
      ['p'] = {':tabprevious<CR>', 'previous-tab'}
    }
  },

  -- NOTE: T is for tmux-runner
  ['T'] = {
    ['name'] = '+tmux-runner',
    ['a'] = {':VtrAttachToPane<CR>', 'attach-pane'},
    ['c'] = {':VtrClearRunner<CR>', 'clear-runner'},
    ['d'] = {':VtrDetachRunner<CR>', 'detach-runner'},
    ['f'] = {':VtrFocusRunner<CR>', 'focus-runner'},
    ['F'] = {':VtrFlushCommand<CR>', 'flush-command'},
    ['k'] = {':VtrKillRunner<CR>', 'kill-runner'},
    ['o'] = {':VtrOpenRunner<CR>', 'open-runner'},
    ['r'] = {':VtrReattachRunner<CR>', 'open-runner'},
    ['R'] = {':VtrReorientRunner<CR>', 'reorient-runner'},
    ['s'] = {
      ['name'] = '+send-command',
      ['c'] = {':VtrSendCtrlC<CR>', 'send-ctrl-c'},
      ['d'] = {':VtrSendCtrlD<CR>', 'send-ctrl-d'},
      ['f'] = {':VtrSendFile<CR>', 'send-file'},
      ['k'] = {':VtrSendKeysRaw<CR>', 'send-keys-raw'},
      ['l'] = {':VtrSendLinesToRunner<CR>', 'send-lines-to-runner'},
      ['s'] = {':VtrSendCommandToRunner<CR>', 'send-command-to-runner'}
    }
  },

  -- NOTE: u is for undo
  ['u'] = {
    ['name'] = '+ui/toggle',
    ['u'] = {':MundoToggle<CR>', 'mundo-tree'}
  },

  -- NOTE: v is for vim
  ['v'] = {
    ['name'] = '+vim',
    [':'] = {':Telescope commands<CR>', 'commands'},
    ['h'] = {':Telescope help_tags<CR>', 'help-tags'},
    ['H'] = {':Telescope command_history<CR>', 'commands-history'},
    ['k'] = {':Telescope keymaps<CR>', 'telescope-keymaps'},
    ['o'] = {':Telescope vim_options<CR>', 'options'},
    ['p'] = {
      ['name'] = '+vim-plug',
      ['c'] = {':PackerClean<CR>', 'clean'},
      ['i'] = {':PackerInstall<CR>', 'install'},
      ['r'] = {':PackerCompile<CR>', 'complie'},
      ['s'] = {':PackerSync<CR>', 'sync'},
      ['S'] = {':PackerStatus<CR>', 'status'},
      ['u'] = {':PackerUpdate<CR>', 'update'}
    }
  },

  -- NOTE: w is for windows
  ['w'] = {
    ['name'] = '+windows',
    ['2'] = {'<C-W>v', 'layout-double-columns'},
    [';'] = {'<C-W>L', 'move-window-far-right'},
    ['='] = {'<C-W>=', 'balance-windows'},
    ['a'] = {'<C-W>H', 'move-window-far-left'},
    ['d'] = {'<C-W>c', 'delete-window'},
    ['f'] = {
      ['name'] = '+harpoon',
      ['c'] = {':lua require("harpoon.mark").clear_all()<CR>', 'clear-all'},
      ['f'] = {
        ['name'] = '+files',
        ['1'] = {':lua require("harpoon.ui").nav_file(1)<CR>', 'goto-file-4'},
        ['2'] = {':lua require("harpoon.ui").nav_file(2)<CR>', 'goto-file-1'},
        ['3'] = {':lua require("harpoon.ui").nav_file(3)<CR>', 'goto-file-2'},
        ['4'] = {':lua require("harpoon.ui").nav_file(4)<CR>', 'goto-file-3'},
        ['5'] = {':lua require("harpoon.ui").nav_file(5)<CR>', 'goto-file-4'},
        ['6'] = {':lua require("harpoon.ui").nav_file(6)<CR>', 'goto-file-6'},
        ['a'] = {':lua require("harpoon.mark").add_file()<CR>', 'add-file'},
        ['r'] = {':lua require("harpoon.mark").rm_file()<CR>', 'remove-file'}
      },
      ['m'] = {':lua require("harpoon.ui").toggle_quick_menu()<CR>', 'quick-menu'},
      ['p'] = {':lua require("harpoon.mark").promote()<CR>', 'promote'},
      ['s'] = {':lua require("harpoon.mark").shorten_list()<CR>', 'shorten-list'},
      ['t'] = {
        ['name'] = '+terminals',
        ['f'] = {':lua require("harpoon.term").sendCommand(1, 2)<CR>', 'goto-terminal-1'},
        ['s'] = {':lua require("harpoon.term").gotoTerminal(1)<CR>', 'send-command-terminal-1'},
        ['S'] = {':lua require("harpoon.term").sendCommand(1, 1)<CR>', 'send-command-terminal-2'},
        ['t'] = {':lua require("harpoon.term").gotoTerminal(2)<CR>', 'goto-terminal-2'}
      }
    },
    ['h'] = {':lua require("Navigator").left()<CR>', 'window-left'},
    ['H'] = {'<C-W>5<', 'expand-window-left'},
    ['i'] = {'<C-W>K', 'move-window-far-top'},
    ['j'] = {':lua require("Navigator").down()<CR>', 'window-down'},
    ['J'] = {':resize +5<CR>', 'expand-window-below'},
    ['k'] = {':lua require("Navigator").up()<CR>', 'window-up'},
    ['K'] = {':resize  5<CR>', 'expand-window-up'},
    ['l'] = {':lua require("Navigator").right()<CR>', 'window-right'},
    ['L'] = {'<C-W>5>', 'expand-window-right'},
    ['m'] = {':MaximizerToggle<CR>', 'maximize-windows'},
    ['n'] = {'<C-W>J', 'move-window-far-down'},
    ['p'] = {':lua require("Navigator").previous()<CR>', 'window-previous'},
    ['s'] = {'<C-W>s', 'split-window-below'},
    ['t'] = {'<C-W>T', 'move-split-to-tab'},
    ['u'] = {'<C-W>x', 'swap-window-next'},
    ['v'] = {'<C-W>v', 'split-window-right'},
    ['x'] = {':call WindowSwap#EasyWindowSwap()<CR>', 'window-swap'}
  }
}

local local_leader_key_maps = {
  [']'] = 'replace-all',
  ['['] = 'replace-current',
  [','] = {':term <CR> emacsclient -nw -e "(magit-status)" <CR>', 'emacs-magit'},
  ['g'] = {
    ['name'] = '+fugitive',
    ['b'] = {
      ['name'] = '+blame',
      ['l'] = {'blame'}
    },
    ['c'] = {
      ['name'] = '+commit/checkout',
      ['a'] = {'commit'},
      ['b'] = {'create-checkout-branch'},
      ['l'] = {'commit-log'},
      ['m'] = {'checkout-master'},
      ['o'] = {'checkout-branch'}
    },
    ['d'] = {
      ['name'] = '+diff',
      ['a'] = {'diff-tool'},
      ['b'] = {'diff-split'},
      ['t'] = {'diff-tool+'}
    },
    ['s'] = {
      ['name'] = '+status',
      ['t'] = {'status'}
    },
    ['m'] = {'merge-tool'},
    ['p'] = {'push'}
  },
  ['l'] = {
    ['name'] = '+loclist',
    ['c'] = {':lclose<CR>', 'close'},
    ['l'] = {':Telescope loclist<CR>', 'fuzzy-loclist'},
    ['n'] = {':lnext<CR>', 'next'},
    ['o'] = {':lopen<CR>', 'open'},
    ['p'] = {':lprev<CR>', 'prev'}
  },
  ['p'] = {'"+p', 'better-paste'},
  ['q'] = {
    ['name'] = '+quickfix',
    ['c'] = {':cclose<CR>', 'close'},
    ['l'] = {':Telescope quickfix<CR>', 'fuzzy-quickfix'},
    ['n'] = {':cnext<CR>', 'next'},
    ['o'] = {':copen<CR>', 'open'},
    ['p'] = {':cprev<CR>', 'prev'}
  },
  ['s'] = {
    ['name'] = '+snap',
    ['b'] = {'buffers'},
    ['f'] = {'files'},
    ['g'] = {'git-files'},
    ['s'] = {'grep'},
    ['S'] = {
      ['name'] = '+sideways',
      ['i'] = {'<Plug>(SidewaysArgumentInsertBefore)', 'insert-before'},
      ['a'] = {'<Plug>(SidewaysArgumentAppendAfter)', 'append-after'},
      ['I'] = {'<Plug>(SidewaysArgumentInsertFirst)', 'insert-first'},
      ['A'] = {'<Plug>(SidewaysArgumentAppendLast)', 'append-last'}
    }
  },
  ['t'] = {
    ['name'] = '+treesitter',
    ['c'] = 'doc-node-at-cursor',
    ['d'] = 'goto-definition',
    ['D'] = 'goto-definition-fallback',
    ['l'] = 'list-definitions',
    ['n'] = 'goto-next-usage',
    ['o'] = 'list-definitions-toc',
    ['p'] = 'goto-previous-usage',
    ['r'] = 'smart-rename',
    ['v'] = 'visual-selection',
    ['t'] = {':TSPlaygroundToggle<CR>', 'playground'}
  },
  ['v'] = {
    ['name'] = '+vim',
    ['a'] = {':Telescope autocommands<CR>', 'autocommands'},
    ['c'] = {':Telescope commands<CR>', 'commands'},
    ['C'] = {':Telescope command_history<CR>', 'commands-history'},
    ['h'] = {':Telescope help_tags<CR>', 'help-tags'},
    ['H'] = {':Telescope highlights<CR>', 'highlights'},
    ['m'] = {':Telescope keymaps<CR>', 'keymaps'},
    ['M'] = {':Telescope marks<CR>', 'marks'},
    ['o'] = {':Telescope vim_options<CR>', 'vim-options'},
    ['r'] = {':Telescope registers<CR>', 'vim-registers'},
    ['s'] = {':Telescope colorscheme<CR>', 'colorschemes'}
  },
  ['y'] = {'"+y', 'better-copy'}
}

wk.register(local_leader_key_maps, {
  prefix = '<localleader>'
})
wk.register(leader_key_maps, {
  prefix = '<leader>'
})
