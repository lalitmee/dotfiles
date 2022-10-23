----------------------------------------------------------------------
-- NOTE: which-key mappings {{{
----------------------------------------------------------------------
local wk = require("which-key")

vim.o.timeoutlen = 500

local presets = require("which-key.plugins.presets")
presets.objects["a("] = nil
presets.operators["g"] = nil

wk.setup({
    show_help = false,
    triggers = "auto",
    plugins = { spelling = true, marks = false, registers = false },
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
    [":"] = { ":Telescope commands<CR>", "commands" },
    ["<leader>"] = { ":Telescope find_files<CR>", "find-files" },
    ["<TAB>"] = { ":tabnext<CR>", "next-tab" },
    ["/"] = { ":Telescope live_grep<CR>", "search-project" },
    ["1"] = { ":HarpoonGotoTerm 1<CR>", "terminal-1" },
    ["2"] = { ":HarpoonGotoTerm 2<CR>", "terminal-2" },
    ["3"] = { ":HarpoonGotoTerm 3<CR>", "terminal-3" },
    ["4"] = { ":HarpoonGotoTerm 4<CR>", "terminal-4" },
    ["x"] = { ":q<CR>", "close-window" },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: a is for actions {{{
    ----------------------------------------------------------------------
    ["a"] = {
        ["name"] = "+actions",
        ["/"] = { ":SpectreOpen<CR>", "spectre-open" },
        ["c"] = { ":ColorizerToggle<CR>", "toggle-colorizer" },
        ["e"] = { ":NeoTreeFocusToggle<CR>", "neo-tree-toggle" },
        ["f"] = { ":SpectreCurFileSearch<CR>", "spectre-file-search" },
        ["g"] = { ":Glow<CR>", "markdown-glow" },
        ["i"] = { ":ISwapWith<CR>", "iswap-with" },
        ["I"] = { ":ISwap<CR>", "iswap" },
        ["m"] = { ":MinimapToggle<CR>", "toggle-minimap" },
        ["o"] = { ":NeoTreeRevealToggle<CR>", "neo-tree-toggle" },
        ["p"] = { ":MarkdownPreviewToggle<CR>", "markdown-preview-toggle" },
        ["s"] = { ":StartupTime<CR>", "run-startup-time" },
        ["w"] = { ":SpectreCurWord<CR>", "spectre-current-word-search" },
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: b is for buffers {{{
    ----------------------------------------------------------------------
    ["b"] = {
        ["name"] = "+buffers",
        ["a"] = { ":bfirst<CR>", "first-buffer" },
        ["b"] = { ":Telescope buffers<CR>", "telescope-buffers" },
        ["c"] = { ":vnew<CR>", "new-empty-buffer-vert" },
        ["C"] = { ":BufOnly<CR>", "close-all-but-current" },
        ["d"] = { ":Bdelete<CR>", "delete-buffer" },
        ["f"] = { ":ReachOpen buffers<CR>", "reach-buffers" },
        ["l"] = { ":Telescope current_buffer_fuzzy_find<CR>", "search-buffer-lines" },
        ["m"] = { ":ReachOpen marks<CR>", "reach-marks" },
        ["M"] = { ":delm!<CR>", "delete-marks" },
        ["n"] = { ":bn<CR>", "next-buffer" },
        ["p"] = { ":bp<CR>", "prev-buffer" },
        ["r"] = { ":e<CR>", "refresh-buffer" },
        ["R"] = { ":bufdo :e<CR>", "refresh-loaded-buffers" },
        ["t"] = { ":ReachOpen tabpages<CR>", "reach-tabpages" },
        ["v"] = { ":vnew<CR>", "new-empty-buffer-vertically" },
        ["w"] = { ":Bwipeout<CR>", "close-buffer-and-window" },
        ["z"] = { ":blast<CR>", "first-buffer" },
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: c is for code with lspconfig {{{
    ----------------------------------------------------------------------
    ["c"] = {
        ["name"] = "+telescope-lsp",
        ["a"] = { ":LspCodeActions<CR>", "code-action" },
        ["d"] = { ":Telescope lsp_definitions<CR>", "definitions" },
        ["e"] = { ":Telescope diagnostic<CR>", "diagnostic" },
        ["f"] = { ":Telescope lsp_references<CR>", "references" },
        ["i"] = { ":Telescope lsp_implementations<CR>", "implementations" },
        ["s"] = { ":Telescope lsp_dynamic_workspace_symbols<CR>", "dynamic-workspace-symbols" },
        ["t"] = { ":Telescope lsp_type_definitions<CR>", "type-definitions" },
        ["w"] = { ":Telescope lsp_document_symbols<CR>", "document-symbols" },
        ["W"] = { ":Telescope lsp_workspace_symbols<CR>", "workspace-symbols" },
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: d is for dap {{{
    ----------------------------------------------------------------------
    ["d"] = {
        ["name"] = "+dap",
        ["a"] = { ":DapStepOut<CR>", "step-out" },
        ["c"] = { ":DapContinue<CR>", "continue" },
        ["d"] = { ":DapToggleBreakpoint<CR>", "toggle-breakpoint" },
        ["i"] = { ":DapStepInto<CR>", "step-into" },
        ["l"] = { ":DapSetLogpoint<CR>", "log-point" },
        ["o"] = { ":DapStepOver<CR>", "step-over" },
        ["r"] = { ":DapReplOpen<CR>", "open-repl" },
        ["s"] = { ":DapRunLast<CR>", "run-last" },
        ["t"] = { ":DapToggleBreakpointCond<CR>", "breakpoint-condition" },
        ["j"] = { ":OsvLaunch<CR>", "lua-launch" },
        ["k"] = { ":OsvRunThis<CR>", "lua-run-this" },
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: e is for error/warnings using lspconfig {{{
    ----------------------------------------------------------------------
    ["e"] = {
        ["name"] = "+errors",
        ["d"] = { ":DiagList<CR>", "buffer-diagnostics-quickfix" },
        ["D"] = { ":DiagListAll<CR>", "workspace-diagnostics-quickfix" },
        ["l"] = { ":Telescope diagnostics<CR>", "workspace-diagnostics" },
        ["n"] = { ":LspGotoNextDiagnostic<CR>", "next-diagnostics" },
        ["o"] = { ":LspDiagnostics<CR>", "quickfix-diagnostics" },
        ["p"] = { ":LspGotoPrevDiagnostic<CR>", "prev-diagnostics" },
        ["v"] = { ":ShowLineDiagnosticInFlot<CR>", "diagnostic-float-preview" },
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: f is for files {{{
    ----------------------------------------------------------------------
    ["f"] = {
        ["name"] = "+files",
        ["a"] = { ":HarpoonAddFile<CR>", "add-file" },
        ["c"] = { ":TelescopeEditDotfiles<CR>", "dotfiles" },
        ["d"] = { ":Telescope find_files theme=dropdown<CR>", "with-dropdown" },
        ["e"] = { ":TelescopeEditNeovim<CR>", "neovim-config" },
        ["f"] = { ":Telescope find_files<CR>", "files" },
        ["g"] = { ":Telescope git_files<CR>", "git-files" },
        ["h"] = { ":Telescope frecency<CR>", "telescope-frecency" },
        ["i"] = { ":Telescope find_files theme=ivy<CR>", "ivy-theme-files" },
        ["m"] = { ":ToggleHarpoonMenu<CR>", "quick-menu" },
        ["n"] = { ":HarpoonNextMark<CR>", "next-mark" },
        ["o"] = { ":Telescope oldfiles<CR>", "old-files" },
        ["p"] = { ":HarpoonPrevMark<CR>", "prev-mark" },
        ["r"] = { ":HarpoonRemoveFile<CR>", "remove-file" },
        ["s"] = { ":w<CR>", "save-buffer" },
        ["S"] = { ":wa<CR>", "save-all-buffers" },
        ["t"] = { ":Telescope filetypes<CR>", "file-types" },
        ["q"] = { ":wq<CR>", "save-and-quit" },
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: g is for git {{{
    ----------------------------------------------------------------------
    ["g"] = {
        ["name"] = "+git",
        ["b"] = { ":BrowseRepo<CR>", "open-repo" },
        ["c"] = { ":Telescope git_branches<CR>", "checkout" },
        ["d"] = { ":DiffviewOpen<CR>", "diffview-open" },
        ["D"] = { ":DiffviewClose<CR>", "diffview-close" },
        ["f"] = { ":DiffviewFileHistory<CR>", "diffview-file-history" },
        ["g"] = {
            ["name"] = "+git",
            ["a"] = { ":Telescope git_commits<CR>", "git-commits" },
            ["b"] = { ":Telescope git_bcommits<CR>", "git-buffer-commits" },
            ["c"] = { ":Telescope git_branches<CR>", "git-branches" },
            ["f"] = { ":Telescope git_files<CR>", "git-files" },
            ["g"] = { ":Telescope git_status<CR>", "git-status" },
            ["s"] = { ":Telescope git_stash<CR>", "git-stash" },
        },
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
        ["s"] = { ":Neogit<CR>", "status" },
        ["w"] = {
            ["name"] = "+git-worktree",
            ["c"] = { ":Telescope git_worktree create_git_worktree<CR>", "create-worktree" },
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
        ["h"] = { ":TSHighlightCapturesUnderCursor<CR>", "show-highlights-info" },
        ["t"] = {
            ["name"] = "+todo-comments",
            ["q"] = { ":TodoQuickFix<CR>", "todos-quickfix" },
            ["t"] = { ":TodoTelescope<CR>", "todos-telescope" },
        },
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: i is for insert {{{
    ----------------------------------------------------------------------
    ["i"] = {
        ["name"] = "+insert-text",
        ["c"] = { ":PickColor<CR>", "color-picker" },
        ["e"] = { ":LuaSnipEdit<CR>", "edit-snippets" },
        ["i"] = { ":PickEverything<CR>", "everything" },
        ["m"] = { ":MindOpenMain<CR>", "mind-open" },
        ["p"] = { ":MindOpenProject<CR>", "mind-project" },
        ["r"] = { ":MindReloadState<CR>", "mind-reload-state" },
        ["s"] = { ":MindOpenSmartProject<CR>", "mind-smart-project" },
        ["w"] = { ":Telescope spell_suggest<CR>", "spell_suggest" },
        -- }}}
        ----------------------------------------------------------------------
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: j is for jupming {{{
    ----------------------------------------------------------------------
    ["j"] = {
        ["name"] = "+jumping",
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: NOTE: k is for scratch buffers {{{
    ----------------------------------------------------------------------
    ["k"] = {
        ["name"] = "+scratch-buffers",
        ["a"] = { ":AttemptNew<CR>", "new-scratch-buffer" },
        ["c"] = { ":AttemptRenameBuf<CR>", "rename-scratch-buffer" },
        ["d"] = { ":AttemptDeleteBuf<CR>", "delete-scratch-buffer" },
        ["e"] = { ":AttemptNewExtension<CR>", "new-extension-scratch-buffer" },
        ["f"] = { ":Telescope attempt<CR>", "find-scratch-buffers" },
        ["r"] = { ":AttemptRun<CR>", "run-scratch-buffer" },
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: l is for lspconfig {{{
    ----------------------------------------------------------------------
    ["l"] = {
        ["name"] = "+lsp",
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
        ["I"] = { ":Mason<CR>", "lsp-installer-info" },
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
    -- NOTE: m is for major mode using lspconfig {{{
    ----------------------------------------------------------------------
    ["m"] = {
        ["name"] = "+major-mode",
        ["a"] = { ":LspCodeActions<CR>", "code-actions" },
        ["c"] = { ":MakeTags<CR>", "make-ctags" },
        ["d"] = { ":Telescope lsp_definitions<CR>", "lsp-definitions" },
        ["e"] = { ":Telescope diagnostics<CR>", "lsp-diagnostics" },
        ["f"] = { ":Telescope lsp_references<CR>", "references" },
        ["j"] = { ":Telescope lsp_workspace_symbols<CR>", "workspace-symbols" },
        ["l"] = { ":LogVariable<CR>", "log-var" },
        ["r"] = { ":LspRename<CR>", "rename-symbol" },
        ["t"] = { ":Telescope treesitter<CR>", "treesitter-symbols" },
        ["w"] = { ":Telescope lsp_document_symbols<CR>", "buffer-symbols" },
        ["W"] = { ":Telescope lsp_dynamic_workspace_symbols<CR>", "workspace-symbols" },
    },
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
        ["H"] = { ":checkhealth<CR>", "check-health" },
        ["i"] = { ":PackerInstall<CR>", "packer-install" },
        ["l"] = { ":lua Save_and_execute()<CR>", "save-and-execute" },
        ["m"] = { ":ReloadModule ", "realod-module" },
        ["p"] = { ":TelescopeInstalledPlugins<CR>", "installed-plugins" },
        ["P"] = { ":PackerProfile<CR>", "packer-profile" },
        ["t"] = { ":ReloadConfigTelescope<CR>", "realod-modules" },
        ["r"] = { ":ReloadConfig<CR>", "realod-config" },
        ["s"] = { ":PackerSync<CR>", "packer-sync" },
        ["S"] = { ":PackerStatus<CR>", "packages-status" },
        ["u"] = { ":PackerUpdate<CR>", "packer-update" },
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: o is for telescope.nvim {{{
    ----------------------------------------------------------------------
    ["o"] = {
        ["name"] = "+org-mode",
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: p is for project {{{
    ----------------------------------------------------------------------
    ["p"] = {
        ["name"] = "+project",
        ["b"] = { ":Telescope buffers<CR>", "find-buffers" },
        ["f"] = { ":Telescope find_files<cr>", "find-files" },
        ["o"] = { ":Telescope oldfiles<CR>", "old-files" },
        ["g"] = { ":Telescope git_files<CR>", "find-git-files" },
        ["h"] = { ":Telescope frecency<CR>", "old-files" },
        ["p"] = { ":Telescope projects<CR>", "projects" },
        ["s"] = { ":Telescope live_grep<CR>", "project-search" },
        ["w"] = { ":Telescope grep_string<CR>", "string-search" },
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: q is for quit/close {{{
    ----------------------------------------------------------------------
    ["q"] = {
        ["name"] = "+quickfix",
        ["c"] = { ":cclose<CR>", "close" },
        ["f"] = { ":ReplacerFiles<CR>", "replacer-files" },
        ["l"] = { ":Telescope quickfix<CR>", "telescope-quickfix" },
        ["n"] = { ":cnext<CR>", "next" },
        ["o"] = { ":copen<CR>", "open" },
        ["p"] = { ":cprev<CR>", "prev" },
        ["q"] = { ":qall<CR>", "quit-neovim" },
        ["r"] = { ":Replacer<CR>", "replacer" },
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: r is for runner {{{
    ----------------------------------------------------------------------
    ["r"] = {
        ["name"] = "+build-and-run",
        ["c"] = { ":CompileAndRun<CR>", "compile-and-run" },
        ["o"] = {
            ["name"] = "+overseer",
            ["a"] = { ":OverseerTaskAction<CR>", "task-action" },
            ["b"] = { ":OverseerBuild<CR>", "build" },
            ["c"] = { ":OverseerClose<CR>", "close" },
            ["d"] = { ":OverseerDeleteBundle<CR>", "delete-bundle" },
            ["f"] = { ":OverseerRunCmd<CR>", "run-cmd" },
            ["l"] = { ":OverseerLoadBundle<CR>", "load-bundle" },
            ["o"] = { ":OverseerOpen<CR>", "open" },
            ["q"] = { ":OverseerQuickAction<CR>", "quick-action" },
            ["r"] = { ":OverseerRun<CR>", "run" },
            ["s"] = { ":OverseerSaveBundle ", "save-bundle" },
            ["t"] = { ":OverseerToggle<CR>", "toggle" },
        },
        ["s"] = { ":SnipRun<CR>", "snip-run" },
        ["S"] = { ":SnipClose<CR>", "snip-close" },
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
        ["a"] = { ":Telescope<CR>", "telescope-all-options" },
        ["b"] = { ":Telescope current_buffer_tags<CR>", "buffer-tags" },
        ["B"] = { ":Telescope builtin<CR>", "builtins" },
        ["c"] = { ":Telescope git_commits<CR>", "commits" },
        ["C"] = { ":Telescope git_bcommits<CR>", "buffer-commits" },
        ["d"] = { ":Telescope git_files<CR>", "git-files" },
        ["f"] = { ":Telescope find_files<CR>", "files" },
        ["F"] = { ":Telescope filetypes<CR>", "file-types" },
        ["g"] = { ":Telescope git_status<CR>", "modified-git-files" },
        ["h"] = { ":Telescope howdoi<CR>", "howdoi" },
        ["H"] = { ":Telescope command_history<CR>", "command-history" },
        ["i"] = { ":Telescope luasnip<CR>", "snippets" },
        ["l"] = { ":Telescope current_buffer_fuzzy_find<CR>", "telescope-buffer-lines" },
        ["m"] = { ":Telescope man_pages<CR>", "man-pages" },
        ["M"] = { ":Telescope keymaps<CR>", "keymaps" },
        ["n"] = { ":TelescopeNotifyHistory<CR>", "notify-history" },
        ["s"] = { ":Telescope colorscheme<CR>", "color-schemes" },
        ["o"] = { ":Telescope oldfiles<CR>", "old-files" },
        ["p"] = { ":Telescope live_grep<CR>", "live-grep" },
        ["P"] = { ":Telescope planets<CR>", "planets" },
        ["r"] = { ":Telescope resume<CR>", "resume-search" },
        ["R"] = { ":Telescope reloader<CR>", "reloaders" },
        ["t"] = { ":Telescope treesitter<CR>", "treesitter" },
        ["T"] = { ":Telescope tags<CR>", "project-tags" },
        ["v"] = { ":Telescope vim_options<CR>", "vim-options" },
        ["y"] = { ":Telescope yank_history<CR>", "yank-history" },
        ['"'] = { ":Telescope registers<CR>", "registers" },
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: S is for sessions {{{
    ----------------------------------------------------------------------
    ["S"] = {
        ["name"] = "+sessions",
        ["b"] = { ":ChangeSystemBackground<CR>", "change-system-background" },
        ["c"] = { ":lua Get_current_working_directory()<CR>", "current-working-directory" },
        ["d"] = { ":DeleteSession<CR>", "delete-session" },
        ["f"] = { ":lua Show_current_file_path()<CR>", "show-current-file-path" },
        ["l"] = { ":SearchSession<CR>", "search-sessions" },
        ["n"] = { "<Plug>(SpotifySkip)", "skip-current-song" },
        ["p"] = { "<Plug>(SpotifyPrev)", "prev-song" },
        ["s"] = { ":SaveSession<CR>", "save-session" },
        ["t"] = { ":lua Notify_current_datetime()<CR>", "current-date-time" },
        ["y"] = { ":lua Yank_current_file_name()<CR>", "yank-current-file-name" },
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: t is for toggle/tabs/terminal {{{
    ----------------------------------------------------------------------
    ["t"] = {
        ["name"] = "+toggle",
        ["g"] = {
            ["name"] = "+git",
            ["b"] = { ":Gitsigns toggle_current_line_blame<CR>", "toggle-blame" },
            ["l"] = { ":Gitsigns toggle_linehl<CR>", "toggle-linehl" },
            ["n"] = { ":Gitsigns toggle_numhl<CR>", "toggle-numhl" },
            ["s"] = { ":Gitsigns toggle_signs<CR>", "toggle-signs" },
            ["w"] = { ":Gitsigns toggle_word_diff<CR>", "toggle-word-diff" },
        },
        ["h"] = { ":sp | te<CR>", "horizontal-split-terminal" },
        ["n"] = {
            ["name"] = "+nvim-tree",
            ["f"] = { ":NeoTreeFocusToggle<CR>", "focus-toggle" },
            ["e"] = { ":NeoTreeRevealToggle<CR>", "reveal-toggle" },
            ["v"] = { ":NeoTreeRevealInSplitToggle<CR>", "split-toggle" },
        },
        ["s"] = {
            ["name"] = "+scrolloff",
            ["t"] = { ":set scrolloff=10<CR>", "scrolloff=10" },
            ["h"] = { ":set scrolloff=5<CR>", "scrolloff=5" },
            ["n"] = { ":set scrolloff=999<CR>", "scrolloff=999" },
        },
        ["t"] = { ":TSPlaygroundToggle<CR>", "playground" },
        ["u"] = { ":UndotreeToggle<CR>", "undo-tree" },
        ["v"] = { ":vs | te<CR>", "vertical-split-terminal" },
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: u is for undo {{{
    ----------------------------------------------------------------------
    ["u"] = {
        ["name"] = "+undo",
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
        ["a"] = { ":Telescope autocommands<CR>", "autocommands" },
        ["c"] = { ":Telescope colorscheme<CR>", "colorschemes" },
        ["d"] = { ":Messages<CR>", "messages" },
        ["f"] = { ":Telescope filetypes<CR>", "filetypes" },
        ["h"] = { ":Telescope help_tags<CR>", "help-tags" },
        ["H"] = { ":Telescope highlights<CR>", "highlights" },
        ["j"] = { ":Telescope jumplist<CR>", "jumplist" },
        ["k"] = { ":Telescope keymaps<CR>", "keymaps" },
        ["l"] = { ":Telescope loclist<CR>", "loclist" },
        ["m"] = { ":Telescope marks<CR>", "marks" },
        ["o"] = { ":Telescope vim_options<CR>", "options" },
        ["r"] = { ":Telescope registers<CR>", "vim-registers" },
        ["t"] = { ":Telescope tagstack<CR>", "tag-stack" },
        ["v"] = { ":Telescope vim_options<CR>", "vim-options" },
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
        ["e"] = { ":AutoResize<CR>", "auto-resize" },
        ["h"] = { ":NavigateLeft<CR>", "window-left" },
        ["H"] = { "<C-W>10<", "expand-window-left" },
        ["i"] = { "<C-W>K", "move-window-far-top" },
        ["j"] = { ":NavigateDown<CR>", "window-down" },
        ["J"] = { ":resize +10<CR>", "expand-window-below" },
        ["k"] = { ":NavigateUp<CR>", "window-up" },
        ["K"] = { ":resize  10<CR>", "expand-window-up" },
        ["l"] = { ":NavigateRight<CR>", "window-right" },
        ["L"] = { "<C-W>10>", "expand-window-right" },
        ["m"] = { ":NeoZoomToggle<CR>", "maximize-window" },
        ["n"] = { "<C-W>J", "move-window-far-down" },
        ["p"] = { ":NavigatePrevious<CR>", "window-previous" },
        ["r"] = { "<C-W>r", "window-swap" },
        ["s"] = { "<C-W>s", "split-window-below" },
        ["t"] = { "<C-W>T", "move-split-to-tab" },
        ["u"] = { "<C-W>x", "swap-window-next" },
        ["v"] = { "<C-W>v", "split-window-right" },
    },
    ["y"] = { ":YankyRingHistory<CR>", "yank-ring-history" },
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
    ["1"] = { ":HarpoonGotoFile 1<CR>", "goto-file-1" },
    ["2"] = { ":HarpoonGotoFile 2<CR>", "goto-file-2" },
    ["3"] = { ":HarpoonGotoFile 3<CR>", "goto-file-3" },
    ["4"] = { ":HarpoonGotoFile 4<CR>", "goto-file-4" },
    ["5"] = { ":HarpoonGotoFile 5<CR>", "goto-file-5" },
    ["6"] = { ":HarpoonGotoFile 6<CR>", "goto-file-6" },
    ["7"] = { ":HarpoonGotoFile 7<CR>", "goto-file-7" },
    ["8"] = { ":HarpoonGotoFile 8<CR>", "goto-file-8" },
    ["9"] = { ":HarpoonGotoFile 9<CR>", "goto-file-9" },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: browse  {{{
    ----------------------------------------------------------------------
    ["b"] = {
        ["name"] = "+browse",
        ["b"] = { ":Browse<CR>", "browse" },
        ["l"] = { ":BrowseBookmarks<CR>", "bookmarks" },
        ["d"] = { ":BrowseDevdocsFiletypeSearch<CR>", "devdocs-filetype-search" },
        ["D"] = { ":BrowseDevdocsSearch<CR>", "devdocs-search" },
        ["i"] = { ":BrowseInputSearch<CR>", "input-search" },
        ["m"] = { ":BrowseMdnSearch<CR>", "mdn-search" },
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
    -- NOTE: treesitter {{{
    ----------------------------------------------------------------------
    ["t"] = {
        ["name"] = "+treesitter",
        ["c"] = "doc-node-at-cursor",
        ["v"] = "visual-selection",
    },
    ["w"] = {
        ["name"] = "+tabs",
        ["a"] = { ":tabnew<CR>", "new-tab" },
        ["c"] = { ":tabclose<CR>", "close-tab" },
        ["f"] = { ":tabfirst<CR>", "first-tab" },
        ["j"] = { ":-tabmove<CR>", "move-tab-to-previous-position" },
        ["k"] = { ":+tabmove<CR>", "move-tab-to-next-position" },
        ["l"] = { ":tablast<CR>", "last-tab" },
        ["n"] = { ":tabnext<CR>", "next-tab" },
        ["p"] = { ":tabprevious<CR>", "previous-tab" },
    },
    -- }}}
    ----------------------------------------------------------------------
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: visual mode keymaps {{{
----------------------------------------------------------------------
local visual_mode_leader_key_maps = {
    ["s"] = { ":SpectreVisual<CR>", "spectre-visual-search" },
    ["r"] = {
        ["name"] = "+refactor",
        ["f"] = { ":ExtractSelectedFunc<CR>", "extract-function" },
        ["r"] = { ":RefactorsList", "refactors-list" },
        ["v"] = { ":DebugPrintVarBelow", "print-var-below" },
        ["V"] = { ":DebugPrintVarAbove", "print-var-above" },
    },
    ["z"] = { ":TZNarrow<CR>", "narrow-code" },
}
-- }}}
----------------------------------------------------------------------

wk.register(local_leader_key_maps, { prefix = "<localleader>" })
wk.register(leader_key_maps, { prefix = "<leader>" })
wk.register(visual_mode_leader_key_maps, { prefix = "<leader>", mode = "v" })
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
