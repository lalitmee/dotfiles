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
    ['['] = { ':bp<CR>', 'prev-buffer' },
    [']'] = { ':bn<CR>', 'next-buffer' },
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
    ['name'] = '+harpoon/+dap',
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
    ['h'] = {
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

  -- NOTE: l is for lsp with Lspsaga
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

  -- NOTE: L is for builtin lsp
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
    ['c'] = { ':PackerClean<CR>', 'clean-packages' },
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
      ['F'] = { ':Telescope find_files<CR>', 'find-files' },
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
      ['l'] = 'tj-live-grep',
      ['r'] = 'resume-last-search',
      ['s'] = { ':Telescope fzf_writer grep<CR>', 'fzf-writer-grep' },
      ['S'] = { ':Telescope live_grep<CR>', 'live-grep' },
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
    ['f'] = { ':Telescope fzf_writer files<CR>', 'fzf-writer-find-files' },
    ['F'] = { ':Telescope find_files<CR>', 'find-files' },
    ['g'] = { ':Telescope git_files<CR>', 'find-git-files' },
    ['n'] = 'swap-parameter-next',
    ['N'] = 'swap-parameter-previous',
    ['p'] = { ':Telescope project project<CR>', 'switch-project' },
    ['P'] = 'tj-project-search',
    ['r'] = { ':Telescope frecency<CR>', 'old-files' },
    ['s'] = { ':Telescope fzf_writer grep<CR>', 'project-search' },
    ['S'] = { ':Telescope live_grep<CR>', 'project-search' },
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
    ['p'] = { ':Telescope fzf_writer grep<CR>', 'fzf-live-grep' },
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
    ['h'] = { ':sp | te<CR>', 'horizontal-split-terminal' },
    ['s'] = {
      ['name'] = '+scrolloff',
      ['t'] = { ':set scrolloff=10<CR>', 'scrolloff=10' },
      ['h'] = { ':set scrolloff=5<CR>', 'scrolloff=5' },
      ['n'] = { ':set scrolloff=999<CR>', 'scrolloff=999' }
    },
    ['t'] = { ':FloatermNew<CR>', 'terminal' },
    ['v'] = { ':vs | te<CR>', 'vertical-split-terminal' },
    ['w'] = {
      ['name'] = '+tabs',
      ['c'] = { ':tabclose', 'close-tab' },
      ['f'] = { ':tabfirst', 'first-tab' },
      ['l'] = { ':tablast', 'last-tab' },
      ['n'] = { ':tabnext', 'next-tab' },
      ['N'] = { ':tabnew', 'new-tab' },
      ['p'] = { ':tabprevious', 'previous-tab' }
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
    ['l'] = { '<Plug>(JsConsoleLog)', 'console-log' }
  }
}

wk.register_keymap('localleader', local_leader_key_maps, { silent = true })
wk.register_keymap('localleader', local_leader_plug_keymaps, { noremap = false })
wk.register_keymap('leader', leader_key_maps, { silent = true })
wk.register_keymap('leader', leader_plug_keymaps, { noremap = false })
