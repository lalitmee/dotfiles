local wk = require("which-key")

vim.o.timeoutlen = 500

local presets = require("which-key.plugins.presets")
presets.objects["a("] = nil
presets.operators["g"] = nil

wk.setup({
  show_help = true,
  triggers = "auto",
  plugins = { spelling = true, marks = true, registers = true },
  key_labels = { ["<leader>"] = "SPC" },
  layout = { spacing = 10 },
})

----------------------------------------------------------------------
-- NOTE: leader key mappings {{{
----------------------------------------------------------------------
local leader_key_maps = {
  ----------------------------------------------------------------------
  -- NOTE: direct mappings {{{
  ----------------------------------------------------------------------
  ["*"] = "vimgrep-under-cursor",
  [":"] = { ":Telescope commands<CR>", "commands" },
  ["<leader>"] = {
    '<cmd>lua require"telescope.builtin".find_files({ find_command = {"rg", "--files", "--hidden", "-g", "!.git" }})<cr>',
    "find-files",
  },
  ["/"] = { ":RG<CR>", "search-project" },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: a is for actions {{{
  ----------------------------------------------------------------------
  ["a"] = {
    ["name"] = "+actions",
    ["a"] = { ":CheatList<CR>", "cheatsheet" },
    ["c"] = { ":Telescope neoclip<CR>", "clipboard" },
    ["o"] = { ":NvimTreeToggle<CR>", "nvim-tree-toggle" },
    ["f"] = { ":NvimTreeFindFile<CR>", "nvim-tree-find-file" },
    ["i"] = { ":ISwapWith<CR>", "iswap-with" },
    ["I"] = { ":ISwap<CR>", "iswap" },
    ["m"] = { ":MarkdownPreviewToggle<CR>", "markdown-preview-toggle" },
    ["g"] = { ":Glow<CR>", "markdown-glow" },
    ["r"] = { ":NvimTreeRefresh<CR>", "nvim-tree-refresh" },
    ["s"] = { ":StartupTime<CR>", "run-startup-time" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: b is for buffers {{{
  ----------------------------------------------------------------------

  ["b"] = {
    ["name"] = "+buffers",
    ["["] = { ":bp<CR>", "prev-buffer" },
    ["]"] = { ":bn<CR>", "next-buffer" },
    ["a"] = { ":JABSOpen<CR>", "beautiful-buffer-switcher" },
    ["b"] = { ":Telescope buffers<CR>", "telescope-buffers" },
    ["c"] = { ":vnew<CR>", "new-empty-buffer-vert" },
    ["C"] = { ":BDelete other<CR>", "close-all-but-current" },
    ["d"] = { ":BDelete this<CR>", "delete-buffer" },
    ["D"] = { ":BDelete all<CR>", "delete-all-buffers" },
    ["f"] = { ":bfirst<CR>", "first-buffer" },
    ["g"] = { ":BufferLinePick<CR>", "goto-buffer" },
    ["h"] = { ":Startify<CR>", "home-buffer" },
    ["l"] = { ":Telescope current_buffer_fuzzy_find<CR>", "search-buffer-lines" },
    ["L"] = { ":blast<CR>", "first-buffer" },
    ["m"] = { ":delm!<CR>", "delete-marks" },
    ["n"] = { ":BufferLineCycleNext<CR>", "next-buffer" },
    ["N"] = { ":BufferLineMoveNext<CR>", "move-next-buffer" },
    ["o"] = { ":BufferLineSorByDirectory<CR>", "order-by-direcoty" },
    ["O"] = { ":BufferLineSortByExtension<CR>", "order-by-language" },
    ["p"] = { ":BufferLineCyclePrev<CR>", "previous-buffer" },
    ["P"] = { ":BufferLineMovePrev<CR>", "move-previous-buffer" },
    ["r"] = { ":e<CR>", "refresh-buffer" },
    ["R"] = { ":bufdo :e<CR>", "refresh-loaded-buffers" },
    ["s"] = { ":new<CR>", "new-empty-buffer" },
    ["u"] = { ":BDelete nameless<CR>", "delete-nameless-buffers" },
    ["w"] = { ":BDelete all<CR>", "close-buffer-and-window" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: c is for lspsaga with lspconfig {{{
  ----------------------------------------------------------------------
  ["c"] = {
    ["name"] = "lspsaga",
    ["a"] = { ":Lspsaga ranger_code_action<CR>", "range-code-action" },
    ["c"] = { ":Lspsaga code_action<CR>", "code-action" },
    ["d"] = { ":Lspsaga preview_definition<CR>", "preview-definition" },
    ["f"] = { ":Lspsaga lsp_finder<CR>", "lsp-finder" },
    ["h"] = { ":Lspsaga signature_help<CR>", "signature-help" },
    ["i"] = { ":Lspsaga implement<CR>", "implementation" },
    ["k"] = { ":Lspsaga hover_doc<CR>", "hover-doc" },
    ["l"] = { ":Lspsaga show_line_diagnostics<CR>", "show-line-diagnostics" },
    ["n"] = { ":Lspsaga diagnotic_jump_next<CR>", "next-diagnostic" },
    ["o"] = { ":Lspsaga open_floaterm<CR>", "open-floaterm" },
    ["O"] = { ":Lspsaga close_floaterm<CR>", "close-floaterm" },
    ["p"] = { ":Lspsaga diagnotic_jump_prev<CR>", "prev-diagnostic" },
    ["r"] = { ":Lspsaga rename<CR>", "rename" },
    ["t"] = { ":Lspsaga toggle_virtual_text<CR>", "toggle-virtual-text" },
    ["y"] = { ":Lspsaga yank_line_diagnostics<CR>", "yank-line-diagnostics" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: c is for coc.nvim {{{
  ----------------------------------------------------------------------
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
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: e is for error/warnings using lspconfig {{{
  ----------------------------------------------------------------------
  ["e"] = {
    ["name"] = "+errors/warnings",
    ["a"] = { ":DiagListAll<CR>", "quickfix-diagnostics" },
    ["b"] = { ":DiagList<CR>", "quickfix-buffer-diagnostics" },
    ["l"] = { ":Telescope diagnostics<CR>", "workspace-diagnosticss" },
    ["n"] = { ":LspGotoNextDiagnostic<CR>", "next-diagnosticss" },
    ["p"] = { ":LspGotoPrevDiagnostic<CR>", "prev-diagnosticss" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: f is for files {{{
  ----------------------------------------------------------------------
  ["f"] = {
    ["name"] = "+files",
    ["b"] = { ":Telescope file_browser<CR>", "file-browser" },
    ["f"] = { ":Telescope find_files<CR>", "files" },
    ["g"] = { ":Telescope git_files<CR>", "git-files" },
    ["r"] = { ":Telescope frecency<CR>", "telescope-frecency" },
    ["s"] = { ":w<CR>", "save-buffer" },
    ["S"] = { ":wa<CR>", "save-all-buffers" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: F is for find and replace {{{
  ----------------------------------------------------------------------
  ["F"] = {
    ["name"] = "+search/replace",
    ["g"] = { ":LGrep<CR>", "grep" },
    ["o"] = { ":SpectreOpen<CR>", "spectre-open" },
    ["v"] = { ':lua require("spectre").open_visual()<CR>', "search-and-replace-selected" },
    ["w"] = { 'viw:lua require("spectre").open_file_search()<cr>', "search-and-replace-in-current-buffer" },
    ["W"] = { ':lua require("spectre").open_visual({select_word=true})<CR>', "search-and-replace-current-word" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: g is for git {{{
  ----------------------------------------------------------------------
  ["g"] = {
    ["name"] = "+git",
    ["b"] = {
      ':lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<CR>',
      "open-repo-browser",
    },
    ["c"] = { ":Telescope git_branches<CR>", "checkout" },
    ["d"] = { ":DiffviewOpen<CR>", "diffview-open" },
    ["D"] = { ":DiffviewClose<CR>", "diffview-close" },
    ["h"] = {
      ["name"] = "+gitsigns-hunks",
      ["a"] = { ":Gitsigns attach<CR>", "attach" },
      ["b"] = { ":Gitsigns stage_buffer<CR>", "stage-buffer" },
      ["c"] = { ":Gitsigns change_base<CR>", "change-base" },
      ["d"] = { ":Gitsigns diffthis<CR>", "diffthis" },
      ["i"] = { ":Gitsigns reset_buffer_index<CR>", "reset-buffer-index" },
      ["l"] = { ":Gitsigns blame_line<CR>", "blame-line" },
      ["n"] = { ":Gitsigns next_hunk<CR>", "next-hunk" },
      ["p"] = { ":Gitsigns prev_hunk<CR>", "prev-hunk" },
      ["r"] = { ":Gitsigns refresh<CR>", "refresh" },
      ["R"] = { ":Gitsigns reset_buffer<CR>", "reset-buffer" },
      ["s"] = { ":Gitsigns stage_hunk<CR>", "stage-hunk" },
      ["S"] = { ":Gitsigns select_hunk<CR>", "select-hunk" },
      ["u"] = { ":Gitsigns detach<CR>", "detach" },
      ["U"] = { ":Gitsigns detach_all<CR>", "detach-all" },
      ["v"] = { ":Gitsigns preview_hunk<CR>", "preview-hunk" },
      ["x"] = { ":Gitsigns reset_hunk<CR>", "reset-hunk" },
    },
    ["m"] = { ":Gitsigns blame_line<CR>", "blame-line" },
    ["o"] = {
      ["name"] = "+octo.nvim",
      ["a"] = {
        ["name"] = "+reaction",
        ["c"] = { ":Octo reaction confused<CR>", "react-confused" },
        ["d"] = { ":Octo reaction thumbs_down<CR>", "react-thumbs_down" },
        ["e"] = { ":Octo reaction eyes<CR>", "react-eyes" },
        ["h"] = { ":Octo reaction heart<CR>", "react-heart" },
        ["l"] = { ":Octo reaction laugh<CR>", "react-laugh" },
        ["r"] = { ":Octo reaction rocket<CR>", "react-rocket" },
        ["t"] = { ":Octo reaction tada<CR>", "react-tada" },
        ["u"] = { ":Octo reaction thumbs_up<CR>", "react-thumbs_up" },
      },
      ["A"] = { ":Octo reviewer add<CR>", "add-reviewer" },
      ["c"] = {
        ["name"] = "+comment",
        ["a"] = { ":Octo comment add<CR>", "add" },
        ["d"] = { ":Octo comment delete<CR>", "delete" },
      },
      ["g"] = { ":Octo gist list<CR>", "list-gist" },
      ["i"] = {
        ["name"] = "+issues",
        ["a"] = { ":Octo issue create<CR>", "create" },
        ["b"] = { ":Octo issue browser<CR>", "browser" },
        ["c"] = { ":Octo issue close<CR>", "close" },
        ["e"] = { ":Octo issue edit<CR>", "edit" },
        ["l"] = { ":Octo issue list<CR>", "list" },
        ["o"] = { ":Octo issue reopen<CR>", "reopen" },
        ["r"] = { ":Octo issue reload<CR>", "reload" },
        ["s"] = { ":Octo issue search<CR>", "search" },
        ["u"] = { ":Octo issue url<CR>", "url" },
      },
      ["l"] = {
        ["name"] = "+label",
        ["a"] = { ":Octo label add<CR>", "add" },
        ["c"] = { ":Octo label create<CR>", "create" },
        ["r"] = { ":Octo label remove<CR>", "remove" },
      },
      ["p"] = {
        ["name"] = "+pull-requests",
        ["a"] = { ":Octo pr create<CR>", "create" },
        ["b"] = { ":Octo pr browser<CR>", "browser" },
        ["c"] = { ":Octo pr checkout<CR>", "checkout" },
        ["C"] = { ":Octo pr close<CR>", "close" },
        ["d"] = { ":Octo pr diff<CR>", "diff" },
        ["D"] = { ":Octo pr checks<CR>", "checks" },
        ["e"] = { ":Octo pr edit<CR>", "edit" },
        ["g"] = { ":Octo pr commits<CR>", "commits" },
        ["h"] = { ":Octo pr changes<CR>", "changes" },
        ["l"] = { ":Octo pr list<CR>", "list" },
        ["m"] = { ":Octo pr merge<CR>", "merge" },
        ["o"] = { ":Octo pr reopen<CR>", "reopen" },
        ["r"] = { ":Octo pr reload<CR>", "reload" },
        ["R"] = { ":Octo pr ready<CR>", "ready" },
        ["s"] = { ":Octo pr search<CR>", "search" },
        ["u"] = { ":Octo pr url<CR>", "url" },
      },
      ["r"] = {
        ["name"] = "+repositories",
        ["b"] = { ":Octo repo browser<CR>", "browser" },
        ["f"] = { ":Octo repo fork<CR>", "fork" },
        ["l"] = { ":Octo repo list<CR>", "list" },
        ["u"] = { ":Octo repo url<CR>", "url" },
      },
      ["R"] = {
        ["name"] = "+review",
        ["b"] = { ":Octo review start<CR>", "start-review" },
        ["c"] = { ":Octo review comments<CR>", "comments-review" },
        ["d"] = { ":Octo review discard<CR>", "discard-review" },
        ["r"] = { ":Octo review resume<CR>", "resume-review" },
        ["s"] = { ":Octo review submit<CR>", "submit-review" },
      },
      ["t"] = {
        ["name"] = "+thread",
        ["r"] = { ":Octo thread resolve<CR>", "resolve" },
        ["u"] = { ":Octo thread unresolve<CR>", "unresolve" },
      },
    },
    ["s"] = { ":Neogit<CR>", "status" },
    ["S"] = { ":GGrep<CR>", "git-grep" },
    ["y"] = { "git-linker" },
    ["Y"] = { ':lua require"gitlinker".get_repo_url()<CR>', "copy-repo-url" },
    ["w"] = {
      ["name"] = "+git-worktree",
      ["c"] = {
        ":Telescope git_worktree create_git_worktree<CR>",
        "create-worktree",
      },
      ["l"] = { ":Telescope git_worktree git_worktrees<CR>", "list-worktrees" },
    },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: h is for highlight {{{
  ----------------------------------------------------------------------
  ["h"] = {
    ["name"] = "+highlight",
    ["t"] = {
      ["name"] = "+todo-comments",
      ["q"] = { ":TodoQuickFix<CR>", "todos-quickfix" },
      ["t"] = { ":TodoTelescope<CR>", "todos-telescope" },
    },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: i is for tmux {{{
  ----------------------------------------------------------------------
  ["i"] = {
    ["name"] = "+tmux",
    ["c"] = { ":Telescope tmux pane_contents<CR>", "pane-contents" },
    ["p"] = { ":TmuxinatorProjects<CR>", "tmuxnator-projects" },
    ["s"] = { ":Telescope tmux sessions<CR>", "sessions" },
    ["w"] = { ":Telescope tmux windows<CR>", "windows" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: j is for jupming {{{
  ----------------------------------------------------------------------
  ["j"] = {
    ["name"] = "+jumping",
    ["c"] = { ":HopChar1<CR>", "hop-char-1" },
    ["d"] = { ":HopChar2<CR>", "hop-char-2" },
    ["l"] = { ":HopLine<CR>", "hop-line" },
    ["p"] = { ":HopPattern<CR>", "hop-pattern" },
    ["w"] = { ":HopWord<CR>", "hop-word" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: l is for lspconfig {{{
  ----------------------------------------------------------------------
  ["l"] = {
    ["a"] = { ":LspCodeActions<CR>", "code-action" },
    ["A"] = { ":LspRangeCodeActions<CR>", "range-code-action" },
    ["e"] = {
      ["name"] = "+diagnostics",
      ["a"] = { ":LspGetAllDiagnostics<CR>", "all-diagnostics" },
      ["l"] = { ":LspShowLineDiagnostics<CR>", "show-line-diagnostics" },
      ["n"] = { ":LspGotoNextDiagnostic<CR>", "next-diagnostic" },
      ["N"] = { ":LspGetNextDiagnostic<CR>", "get-next-diagnostic" },
      ["p"] = { ":LspGotoPrevDiagnostic<CR>", "prev-diagnostic" },
      ["P"] = { ":LspGetPrevDiagnostic<CR>", "get-prev-diagnostic" },
    },
    ["f"] = {
      ["name"] = "+formatting",
      ["f"] = { ":LspFormatting<CR>", "formatting" },
      ["r"] = { ":LspRangeFormatting<CR>", "range-formatting" },
      ["s"] = { ":LspFormattingSync<CR>", "formatting-sync" },
    },
    ["g"] = {
      ["name"] = "+definitions/references",
      ["c"] = { ":LspClearReferences<CR>", "clear-references" },
      ["d"] = { ":LspDefinition<CR>", "definition" },
      ["i"] = { ":LspDeclaration<CR>", "declaration" },
      ["r"] = { ":LspReferences<CR>", "references" },
      ["t"] = { ":LspTypeDefinition<CR>", "type-definition" },
    },
    ["h"] = { ":LspHover<CR>", "hover-doc" },
    ["H"] = { ":LspDocumentHighlight<CR>", "document-highlight" },
    ["o"] = { ":LspOutGoingCalls<CR>", "outgoing-calls" },
    ["i"] = { ":LspInfo<CR>", "lsp-info" },
    ["I"] = { ":LspInstallInfo<CR>", "lsp-installer-info" },
    ["r"] = { ":LspRename<CR>", "rename" },
    ["v"] = {
      ["name"] = "+vista",
      ["f"] = { ":Vista finder<CR>", "finder" },
      ["F"] = { ":Vista finder!<CR>", "finder!" },
      ["g"] = { ":Vista ctags<CR>", "ctags" },
      ["G"] = { ":Vista finder skim:ctags<CR>", "skim:ctags" },
      ["i"] = { ":Vista info<CR>", "info" },
      ["I"] = { ":Vista info+<CR>", "info+" },
      ["j"] = { ":Vista focus<CR>", "focus" },
      ["n"] = { ":Vista nvim_lsp<CR>", "nvim-lsp" },
      ["s"] = { ":Vista show<CR>", "show" },
      ["t"] = { ":Vista!!<CR>", "toggle-vista" },
    },
    ["s"] = { ":LspDocumentSymbols<CR>", "document-symbols" },
    ["S"] = { ":LspWorkspaceSymbols<CR>", "document-symbols" },
    ["y"] = { ":LspImplementation<CR>", "implementation" },
    ["w"] = {
      ["name"] = "+workspace",
      ["a"] = { ":LspAddToWorkspaceFolder<CR>", "add-folder-to-workspace" },
      ["l"] = { ":LspListWorkspaceFolders<CR>", "list-workspace-folders" },
      ["r"] = { ":LspRemoveWorkspaceFolder<CR>", "remove-workspace-folder" },
      ["s"] = { ":LspWorkspaceSymbols<CR>", "workspace-symbols" },
    },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: l is for coc.nvim {{{
  ----------------------------------------------------------------------
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
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: m is for major mode using lspconfig {{{
  ----------------------------------------------------------------------
  ["m"] = {
    ["name"] = "+major-mode",
    ["a"] = { ":Telescope lsp_code_actions<CR>", "code-actions" },
    ["A"] = { ":Telescope lsp_range_code_actions<CR>", "lsp-range-code-actions" },
    ["b"] = { ":Telescope lsp_range_code_actions<CR>", "range-code-actions" },
    ["c"] = { ":MakeTags<CR>", "make-ctags" },
    ["d"] = { ":Telescope lsp_definitions<CR>", "lsp-definitions" },
    ["e"] = { ":Telescope diagnostics<CR>", "lsp-diagnostics" },
    ["f"] = { ":Telescope lsp_references<CR>", "references" },
    ["j"] = { ":Telescope lsp_workspace_symbols<CR>", "workspace-symbols" },
    ["l"] = { "<Plug>(JsConsoleLog)", "console-log" },
    ["r"] = { ":LspRename<CR>", "rename-symbol" },
    ["t"] = { ":Telescope treesitter<CR>", "treesitter-symbols" },
    ["w"] = { ":Telescope lsp_document_symbols<CR>", "buffer-symbols" },
    ["W"] = { ":Telescope lsp_dynamic_workspace_symbols<CR>", "workspace-symbols" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: m is for major mode using coc.nvim {{{
  ----------------------------------------------------------------------
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
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: n is for neovim {{{
  ----------------------------------------------------------------------
  ["n"] = {
    ["name"] = "+neovim",
    ["a"] = { ":Telescope packer packer<CR>", "packer-plugins" },
    ["c"] = { ":PackerCompile<CR>", "packer-compile" },
    ["d"] = { ":PackerClean<CR>", "clean-packages" },
    ["e"] = { ":e $HOME/.config/nvim/init.lua<CR>", "edit-config" },
    ["g"] = { ":e ~/.config/nvim/ginit.vim<CR>", "edit-gui" },
    ["G"] = { ":so ~/.config/nvim/ginit.vim<CR>", "reload-gui" },
    ["h"] = "tj-help-tags",
    ["H"] = { ":checkhealth<CR>", "check-health" },
    ["i"] = { ":PackerInstall<CR>", "packer-install" },
    ["l"] = "source-current",
    ["p"] = "tj-installed-plugins",
    ["P"] = { ":PackerProfile<CR>", "packer-profile" },
    ["r"] = { ":luafile $HOME/.config/nvim/init.lua<CR>", "source-config" },
    ["s"] = { ":PackerSync<CR>", "packer-sync" },
    ["S"] = { ":PackerStatus<CR>", "packages-status" },
    ["u"] = { ":PackerUpdate<CR>", "packer-update" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: N is for notes {{{
  ----------------------------------------------------------------------
  ["N"] = {
    ["name"] = "+notes",
    ["a"] = { ':lua require"neuron/cmd".new_edit(require"neuron".config.neuron_dir)<CR>', "create-new-note" },
    ["b"] = { ':lua require"neuron/telescope".find_backlinks()<CR>', "find-backlinks" },
    ["B"] = { ':lua require"neuron/telescope".find_backlinks{ insert = true }<CR>', "find-backlinks-insert" },
    ["e"] = { ':lua require"neuron".enter_link()<CR>', "enter-link" },
    ["i"] = { ':lua require"neuron/telescope".find_zettels {insert = true}<CR>', "insert-note-id" },
    ["n"] = { ':lua require"neuron".goto_next_extmark()<CR>', "next" },
    ["p"] = { ':lua require"neuron".goto_next_extmark()<CR>', "prev" },
    ["s"] = { ':lua require"neuron".rib {address = "127.0.0.1:8200", verbose = true}<CR>', "serve-notes" },
    ["t"] = { ':lua require"neuron/telescope".find_tags()<CR>', "find-tags" },
    ["z"] = { ':lua require"neuron/telescope".find_zettels()<CR>', "search-notes" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: o is for telescope.nvim {{{
  ----------------------------------------------------------------------
  ["o"] = {
    ["name"] = "+Telescope",
    ["b"] = {
      ["name"] = "+buffers",
      ["a"] = { ":Telescope lsp_code_actions<CR>", "code-actions" },
      ["b"] = { ":Telescope buffers<CR>", "buffers" },
      ["B"] = { ":Telescope tele_tabby list<CR>", "tele-tabby-buffers" },
      ["c"] = { ":Telescope lsp_range_code_actions<CR>", "range-code-actions" },
      ["d"] = { ":Telescope lsp_document_symbols<CR>", "buffer-symbols" },
      ["j"] = { ":Telescope lsp_workspace_symbols<CR>", "workspace-symbols" },
      ["l"] = { ":Telescope current_buffer_fuzzy_find<CR>", "buffer-lines" },
      ["o"] = "buffer-lines-dropdown-theme",
      ["r"] = { ":Telescope lsp_references<CR>", "references" },
      ["p"] = { ":Telescope spell_suggest<CR>", "spell_suggest" },
      ["t"] = { ":Telescope current_buffer_tags<CR>", "buffer-tags" },
    },
    ["e"] = { ":Telescope emoji search<CR>", "emoji-search" },
    ["f"] = {
      ["name"] = "+files",
      ["F"] = { ":Telescope find_files<CR>", "find-files" },
      ["a"] = "tj-search-all-files",
      ["c"] = "dotfiles",
      ["d"] = {
        [[:lua require('lk.plugins.telescope.finders').fd_files_dropdown()<cr>]],
        "with-dropdown",
      },
      ["e"] = { ":Telescope file_browser<CR>", "file-browser" },
      ["f"] = {
        '<cmd>lua require"telescope.builtin".find_files({ find_command = {"rg", "--files", "--hidden", "-g", "!.git" }})<cr>',
        "find-files",
      },
      ["g"] = { ":Telescope git_files<CR>", "git-files" },
      ["h"] = { ":Telescope frecency<CR>", "telescope-frecency" },
      ["i"] = { "ivy-theme-files" },
      ["l"] = { "find-files" },
      ["m"] = { ":Telescope media_files<CR>", "media-files" },
      ["n"] = "nvim-config",
      ["o"] = { ":Telescope find_files<CR>", "find-files" },
      ["r"] = { ":Telescope oldfiles<CR>", "recent-files" },
      ["z"] = { ":Telescope filetypes<CR>", "filetypes" },
    },
    ["g"] = {
      ["name"] = "+git",
      ["a"] = { ":Telescope git_commits<CR>", "git-commits" },
      ["b"] = { ":Telescope git_bcommits<CR>", "git-buffer-commits" },
      ["c"] = { ":Telescope git_branches<CR>", "git-branches" },
      ["f"] = { ":Telescope git_files<CR>", "git-files" },
      ["g"] = { ":Telescope git_status<CR>", "git-status" },
      ["s"] = { ":Telescope git_stash<CR>", "git-stash" },
    },
    ["h"] = { ":TelescopeNotifyHistory<CR>", "notify-history" },
    ["i"] = { ":Telescope snippets snippets<CR>", "snippets" },
    ["j"] = { ":Telescope jumps jumps<CR>", "jumps" },
    ["l"] = { ":Telescope loclist<CR>", "loclist" },
    ["m"] = { ":Telescope man_pages<CR>", "man-pages" },
    ["n"] = {
      ["name"] = "+navigation/jumps",
      ["j"] = { ":Telescope jumps jumps<CR>", "jumps" },
      ["h"] = { ":Telescope harpoon marks<CR>", "harpoon marks" },
    },
    ["o"] = {
      ["name"] = "+open",
      ["o"] = { ":Telescope openbrowser list<CR>", "openbrowser" },
      ["b"] = { ":Telescope bookmarks<CR>", "bookmarks" },
    },
    ["s"] = {
      ["name"] = "+search",
      ["b"] = { ":Telescope current_buffer_fuzzy_find<CR>", "buffer-lines" },
      ["s"] = { ":Telescope live_grep<CR>", "live-grep" },
      ["S"] = { ":Telescope live_grep<CR>", "live-grep" },
      ["u"] = { ":Telescope grep_string<CR>", "grep-string" },
      ["w"] = {
        [[:lua require("telescope").extensions.arecibo.websearch()<CR>]],
        "search-web",
      },
    },
    ["t"] = {
      ["name"] = "+telescope",
      ["b"] = { ":Telescope builtin<CR>", "builtins" },
      ["p"] = { ":Telescope planets<CR>", "planets" },
      ["r"] = { ":Telescope reloader<CR>", "reloaders" },
      ["t"] = { ":Telescope treesitter<CR>", "treesitter" },
      ["w"] = "change-background",
    },
    ["u"] = { ":Telescope ultisnips ultisnips<CR>", "ultisnips" },
    ["v"] = {
      ["name"] = "+vim",
      [";"] = { ":Telescope commands<CR>", "commands" },
      ["a"] = { ":Telescope autocommands<CR>", "autocommands" },
      ["c"] = { ":Telescope colorscheme<CR>", "colorschemes" },
      ["h"] = { ":Telescope command_history<CR>", "commands-history" },
      ["H"] = { ":Telescope highlights<CR>", "highlights" },
      ["k"] = { ":Telescope keymaps<CR>", "keymaps" },
      ["m"] = { ":Telescope marks<CR>", "marks" },
      ["r"] = { ":Telescope registers<CR>", "vim-registers" },
      ["t"] = { ":Telescope help_tags<CR>", "help-tags" },
      ["v"] = { ":Telescope vim_options<CR>", "vim-options" },
    },
    ["w"] = { ":Telescope grep_string<CR>", "grep-words" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: p is for project {{{
  ----------------------------------------------------------------------
  ["p"] = {
    ["name"] = "+project",
    ["b"] = { ":Telescope buffers<CR>", "find-buffers" },
    ["f"] = {
      '<cmd>lua require"telescope.builtin".find_files({ find_command = {"rg", "--files", "--hidden", "-g", "!.git" }})<cr>',
      "find-files",
    },
    ["F"] = { ":Telescope find_files<CR>", "find-files" },
    ["g"] = { ":Telescope git_files<CR>", "find-git-files" },
    ["m"] = {
      ["name"] = "+node-modules",
      ["c"] = {
        ':lua require("package-info").change_version()<CR>',
        "change-version",
      },
      ["d"] = { ':lua require("package-info").delete()<CR>', "delete-package" },
      ["h"] = { ':lua require("package-info").hide()<CR>', "hide-status" },
      ["i"] = { ':lua require("package-info").install()<CR>', "install-package" },
      ["r"] = {
        ':lua require("package-info").reinstall()<CR>',
        "reinstall-dependencies",
      },
      ["s"] = { ':lua require("package-info").show()<CR>', "show-status" },
      ["u"] = { ':lua require("package-info").update()<CR>', "update-package" },
    },
    ["p"] = {
      ":Telescope project project display_type=full<CR>",
      "switch-project",
    },
    ["P"] = { ":Telescope projects<CR>", "switch-projects" },
    ["h"] = { ":Telescope frecency<CR>", "old-files" },
    ["r"] = { ":Telescope repo list shorten_path=true<CR>", "reops-list" },
    ["s"] = { ":Telescope live_grep<CR>", "project-search" },
    ["w"] = { ":Telescope grep_string<CR>", "string-search" },
    ["W"] = { ":Tgrep<CR>", "tj-grep" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: q is for quit/close {{{
  ----------------------------------------------------------------------
  ["q"] = {
    ["name"] = "+quit/+reload",
    ["q"] = { ":qall<CR>", "quit-neovim" },
    ["t"] = { ":ReloadConfigTelescope<CR>", "realod-modules" },
    ["r"] = { ":ReloadConfig<CR>", "realod-config" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: r is for refactor {{{
  -- mappings lies in `lua/lk/plugins/refactoring.lua`
  ----------------------------------------------------------------------
  ["r"] = {
    ["name"] = "+refactor",
    ["b"] = { "print-var-below" },
    ["f"] = { "print-var" },
    ["g"] = { "printf" },
    ["h"] = { "print-debug-path" },
    ["i"] = { "inline-variable" },
    ["m"] = { "printf-below" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: s is for search {{{
  ----------------------------------------------------------------------
  ["s"] = {
    ["name"] = "+search",
    ["/"] = { ":Telescope command_history<CR>", "history" },
    [":"] = { ":Telescope commands<CR>", "commands" },
    ["a"] = { ":Telescope live_grep<CR>", "live-grep" },
    ["b"] = { ":Telescope buffers<CR>", "buffers" },
    ["c"] = { ":Telescope git_commits<CR>", "commits" },
    ["C"] = { ":Telescope git_bcommits<CR>", "buffer-commits" },
    ["d"] = { ":Telescope git_files<CR>", "git-files" },
    ["f"] = { ":Telescope find_files<CR>", "files" },
    ["F"] = { ":Telescope filetypes<CR>", "file-types" },
    ["g"] = { ":Telescope git_status<CR>", "modified-git-files" },
    ["h"] = { ":Telescope help_tags<CR>", "help-tags" },
    ["H"] = { ":Telescope command_history<CR>", "command-history" },
    ["l"] = { ":Telescope current_buffer_fuzzy_find<CR>", "telescope-buffer-lines" },
    ["m"] = { ":Telescope marks<CR>", "marks" },
    ["M"] = { ":Telescope keymaps<CR>", "keymaps" },
    ["o"] = { ":Telescope oldfiles<CR>", "old-files" },
    ["p"] = { ":Telescope live_grep<CR>", "live-grep" },
    ["r"] = { ":Telescope resume<CR>", "resume-search" },
    ["s"] = { ":TelescopeLiveGrepRaw<CR>", "raw-grep" },
    ["S"] = { ":Telescope colorscheme<CR>", "color-schemes" },
    ["t"] = { ":Telescope current_buffer_tags<CR>", "buffer-tags" },
    ["T"] = { ":Telescope tags<CR>", "project-tags" },
    ["v"] = { ":Telescope vim_options<CR>", "vim-options" },
    ['"'] = { ":Telescope registers<CR>", "registers" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: S is for sessions {{{
  ----------------------------------------------------------------------
  ["S"] = {
    ["name"] = "+sessions",
    ["c"] = { ":SClose<CR>", "close-session" },
    ["d"] = { ":SDelete<CR>", "delete-session" },
    ["l"] = { ":SLoad<CR>", "load-session" },
    ["s"] = { ":SSave<CR>", "save-session" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: t is for toggle {{{
  ----------------------------------------------------------------------
  ["t"] = {
    ["name"] = "+tabs/terminal/toggle",
    ["c"] = {
      ["name"] = "+colors",
      ["c"] = { ":ColorizerToggle<CR>", "colorizer" },
      ["l"] = { ":Twilight<CR>", "twilight" },
      ["t"] = {
        ':lua require("material.functions").toggle_style()<CR>',
        "toggle-material-style",
      },
    },
    ["e"] = { ":NvimTreeToggle<CR>", "nvim-tree-exlporer" },
    ["f"] = {
      ["name"] = "+floaterm",
      ["G"] = { ":lua Tig()<CR>", "tig" },
      ["a"] = { ":lua Terminal_Velocity()<CR>", "terminal_velocity" },
      ["d"] = { ":lua LazyDocker()<CR>", "docker" },
      ["g"] = { ":lua LazyGit()<CR>", "lazygit" },
      ["n"] = { ":lua Node()<CR>", "node" },
      ["p"] = { ":lua Python()<CR>", "python" },
      ["r"] = { ":lua Ranger()<CR>", "ranger" },
      ["s"] = { ":lua Ncdu()<CR>", "ncdu" },
      ["t"] = { ":ToggleTerm<CR>", "toggle" },
      ["v"] = { ":lua Grv()<CR>", "grv" },
      ["w"] = { ":lua Wt()<CR>", "weather" },
      ["y"] = { ":lua Btm()<CR>", "ytop" },
    },
    ["g"] = {
      ["name"] = "+git",
      ["b"] = { ":Gitsigns toggle_current_line_blame<CR>", "toggle-blame" },
      ["l"] = { ":Gitsigns toggle_linehl<CR>", "toggle-linehl" },
      ["n"] = { ":Gitsigns toggle_numhl<CR>", "toggle-numhl" },
      ["s"] = { ":Gitsigns toggle_signs<CR>", "toggle-signs" },
      ["w"] = { ":Gitsigns toggle_word_diff<CR>", "toggle-word-diff" },
    },
    ["h"] = { ":sp | te<CR>", "horizontal-split-terminal" },
    ["s"] = {
      ["name"] = "+scrolloff",
      ["t"] = { ":set scrolloff=10<CR>", "scrolloff=10" },
      ["h"] = { ":set scrolloff=5<CR>", "scrolloff=5" },
      ["n"] = { ":set scrolloff=999<CR>", "scrolloff=999" },
    },
    ["v"] = { ":vs | te<CR>", "vertical-split-terminal" },
    ["n"] = {
      ["name"] = "+nvim-tree",
      ["t"] = { ":NvimTreeToggle<CR>", "toggle" },
      ["f"] = { ":NvimTreeFindFile<CR>", "find-file" },
      ["r"] = { ":NvimTreeRefresh<CR>", "refresh" },
    },
    ["u"] = { ":UndotreeToggle<CR>", "undo-tree" },
    ["w"] = {
      ["name"] = "+tabs",
      ["c"] = { ":tabclose<CR>", "close-tab" },
      ["f"] = { ":tabfirst<CR>", "first-tab" },
      ["l"] = { ":tablast<CR>", "last-tab" },
      ["n"] = { ":tabnext<CR>", "next-tab" },
      ["N"] = { ":tabnew<CR>", "new-tab" },
      ["p"] = { ":tabprevious<CR>", "previous-tab" },
    },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: u is for undo {{{
  ----------------------------------------------------------------------
  ["u"] = {
    ["name"] = "+ui/toggle",
    ["u"] = { ":UndotreeToggle<CR>", "undo-tree" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: v is for vim/neovim {{{
  ----------------------------------------------------------------------
  ["v"] = {
    ["name"] = "+vim",
    ["/"] = { ":Telescope command_history<CR>", "commands-history" },
    [":"] = { ":Telescope commands<CR>", "commands" },
    ["c"] = { ":Telescope colorscheme<CR>", "colorschemes" },
    ["h"] = { ":Telescope help_tags<CR>", "help-tags" },
    ["H"] = { ":Telescope highlights<CR>", "highlights" },
    ["j"] = { ":Telescope jumplist<CR>", "jumplist" },
    ["k"] = { ":Telescope keymaps<CR>", "telescope-keymaps" },
    ["l"] = { ":Telescope loclist<CR>", "loclist" },
    ["m"] = { ":Telescope marks<CR>", "marks" },
    ["o"] = { ":Telescope vim_options<CR>", "options" },
    ["r"] = { ":Random<CR>", "random-vim-tag" },
    ["R"] = { ":Random!<CR>", "random-vim-tag-!" },
    ["t"] = { ":Telescope tagstack<CR>", "tag-stack" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: w is for window {{{
  ----------------------------------------------------------------------
  ["w"] = {
    ["name"] = "+windows",
    ["2"] = { "<C-W>v", "layout-double-columns" },
    [";"] = { "<C-W>L", "move-window-far-right" },
    ["="] = { "<C-W>=", "balance-windows" },
    ["a"] = { "<C-W>H", "move-window-far-left" },
    ["d"] = { "<C-W>c", "delete-window" },
    ["h"] = { ":NavigateLeft<CR>", "window-left" },
    ["H"] = { "<C-W>5<", "expand-window-left" },
    ["i"] = { "<C-W>K", "move-window-far-top" },
    ["j"] = { ":NavigateDown<CR>", "window-down" },
    ["J"] = { ":resize +5<CR>", "expand-window-below" },
    ["k"] = { ":NavigateUp<CR>", "window-up" },
    ["K"] = { ":resize  5<CR>", "expand-window-up" },
    ["l"] = { ":NavigateRight<CR>", "window-right" },
    ["L"] = { "<C-W>5>", "expand-window-right" },
    ["m"] = { ":MaximizerToggle<CR>", "maximize-windows" },
    ["n"] = { "<C-W>J", "move-window-far-down" },
    ["p"] = { ":NavigatePrevious<CR>", "window-previous" },
    ["s"] = { "<C-W>s", "split-window-below" },
    ["t"] = { "<C-W>T", "move-split-to-tab" },
    ["u"] = { "<C-W>x", "swap-window-next" },
    ["v"] = { "<C-W>v", "split-window-right" },
    ["x"] = { ":call WindowSwap#EasyWindowSwap()<CR>", "window-swap" },
  },
}
-- }}}
----------------------------------------------------------------------
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: local leader key mappings {{{
----------------------------------------------------------------------
local local_leader_key_maps = {
  ----------------------------------------------------------------------
  -- NOTE: harpoon go to file {{{
  ----------------------------------------------------------------------
  ["1"] = { ":HarpoonGoToFile1<CR>", "goto-file-4" },
  ["2"] = { ":HarpoonGoToFile2<CR>", "goto-file-1" },
  ["3"] = { ":HarpoonGoToFile3<CR>", "goto-file-2" },
  ["4"] = { ":HarpoonGoToFile4<CR>", "goto-file-3" },
  ["5"] = { ":HarpoonGoToFile5<CR>", "goto-file-4" },
  ["6"] = { ":HarpoonGoToFile6<CR>", "goto-file-6" },
  ["7"] = { ":HarpoonGoToFile7<CR>", "goto-file-7" },
  ["8"] = { ":HarpoonGoToFile8<CR>", "goto-file-8" },
  ["9"] = { ":HarpoonGoToFile9<CR>", "goto-file-9" },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: buffers  {{{
  ----------------------------------------------------------------------
  ["b"] = {
    ["name"] = "+buffers",
    ["r"] = { ":RecentBuffers<CR>", "recent-buffers" },
    ["c"] = { ":ClearRecentBuffers<CR>", "clear-recent-buffers" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: cheat.sh {{{
  ----------------------------------------------------------------------
  ["c"] = {
    ["name"] = "+cheat.sh",
    ["r"] = { ":Cheat<CR>", "cht.sh" },
    ["R"] = { ":CheatWithoutComments<CR>", "cht.sh-no-comments" },
    ["l"] = { ":Cheatlist<CR>", "cheat-lists" },
    ["L"] = { ":CheatListWithoutComments<CR>", "cheat-lists-no-comments" },
  },
  -- }}}
  ----------------------------------------------------------------------
  ["e"] = { ":Dirbuf<CR>", "open-dirbuf" },

  ----------------------------------------------------------------------
  -- NOTE: files {{{
  ----------------------------------------------------------------------

  ["f"] = {
    ["name"] = "+files",
    ["a"] = { ":HarpoonAddFile<CR>", "add-file" },
    ["r"] = { ":HarpoonRemoveFile<CR>", "remove-file" },
    ["m"] = { ":ToggleHarpoonMenu<CR>", "quick-menu" },
  },
  -- }}}
  ----------------------------------------------------------------------
  ["]"] = "replace-all", -- coming from  `plugins/abolish.lua`
  ["["] = "replace-current", -- coming from `plugins/abolish.lua`
  ["d"] = { ":Neogen<CR>", "doc-this" },

  ----------------------------------------------------------------------
  -- NOTE: loclist {{{
  ----------------------------------------------------------------------
  ["l"] = {
    ["name"] = "+loclist",
    ["c"] = { ":lclose<CR>", "close" },
    ["l"] = { ":Telescope loclist<CR>", "fuzzy-loclist" },
    ["n"] = { ":lnext<CR>", "next" },
    ["o"] = { ":lopen<CR>", "open" },
    ["p"] = { ":lprev<CR>", "prev" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: marks.nvim {{{
  ----------------------------------------------------------------------
  ["m"] = {
    ["name"] = "+marks",
    ["a"] = { ":MarksListAll<CR>", "list-all-marks" },
    ["b"] = { ":MarksListBuf<CR>", "list-buf-marks" },
    ["q"] = { ":MarksQFListBuf<CR>", "qf-buf-marks" },
    ["Q"] = { ":MarksQFListAll<CR>", "qf-all-marks" },
    ["g"] = { ":MarksListGlobal<CR>", "list-global-marks" },
    ["G"] = { ":MarksQFListGlobal<CR>", "qf-global-marks" },
    ["t"] = { ":MarksToggleSigns<CR>", "toggle-marks-signs" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ["p"] = { '"+p', "better-paste" },

  ----------------------------------------------------------------------
  -- NOTE: quickfix {{{
  ----------------------------------------------------------------------
  ["q"] = {
    ["name"] = "+quickfix",
    ["c"] = { ":cclose<CR>", "close" },
    ["l"] = { ":Telescope quickfix<CR>", "fuzzy-quickfix" },
    ["n"] = { ":cnext<CR>", "next" },
    ["o"] = { ":copen<CR>", "open" },
    ["p"] = { ":cprev<CR>", "prev" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: system {{{
  ----------------------------------------------------------------------
  ["s"] = {
    ["name"] = "+system",
    ["r"] = { ":SnipRun<CR>", "run-code" },
    ["t"] = { ':lua require("lk.functions").notify_current_datetime()<CR>', "current-date-time" },
    ["y"] = { ':lua require("lk.functions").yank_current_file_name()<CR>', "yank-current-file-name" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: treesitter {{{
  ----------------------------------------------------------------------
  ["t"] = {
    ["name"] = "+treesitter",
    ["c"] = "doc-node-at-cursor",
    ["d"] = "goto-definition",
    ["D"] = "goto-definition-fallback",
    ["l"] = "list-definitions",
    ["n"] = "goto-next-usage",
    ["o"] = "list-definitions-toc",
    ["p"] = "goto-previous-usage",
    ["r"] = "smart-rename",
    ["v"] = "visual-selection",
    ["t"] = { ":TSPlaygroundToggle<CR>", "playground" },
  },
  -- }}}
  ----------------------------------------------------------------------
  ["y"] = { '"+y', "better-copy" },
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: visual mode keymaps {{{
----------------------------------------------------------------------
local visual_mode_leader_key_maps = {
  ["r"] = {
    ["name"] = "+refactor",
    ["e"] = { "extract-function" },
    ["r"] = { "refactors-list" },
  },
}
-- }}}
----------------------------------------------------------------------

wk.register(local_leader_key_maps, { prefix = "<localleader>" })
wk.register(leader_key_maps, { prefix = "<leader>" })
wk.register(visual_mode_leader_key_maps, { prefix = "<leader>", mode = "v" })

-- vim:foldmethod=marker