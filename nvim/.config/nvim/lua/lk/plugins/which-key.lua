local M = {
    "folke/which-key.nvim",
    keys = { " ", "," },
}

M.config = function()
    local wk = require("which-key")

    vim.o.timeoutlen = 500

    local presets = require("which-key.plugins.presets")
    presets.objects["a("] = nil
    presets.operators["g"] = nil

    wk.setup({
        show_help = false,
        triggers = "auto",
        plugins = {
            spelling = true,
            marks = false,
            registers = false,
        },
        key_labels = {
            ["<space>"] = "SPC",
            ["<cr>"] = "RET",
            ["<tab>"] = "TAB",
        },
        layout = { spacing = 10 },
        window = {
            border = "rounded",
            winblend = 10,
        },
    })

    local leader_key_maps = {
        [":"] = { ":Telescope commands<CR>", "commands" },
        ["<leader>"] = { ":Telescope find_files<CR>", "find-files" },
        ["/"] = { ":Telescope live_grep<CR>", "search-project" },
        ["]"] = { ":S/<c-r><c-w>//<left>", "replace-all" },
        ["["] = { ":%S/<c-r><c-w>//c<left><left>", "replace-current" },
        ["1"] = { ":HarpoonGotoTerm 1<CR>", "terminal-1" },
        ["2"] = { ":HarpoonGotoTerm 2<CR>", "terminal-2" },
        ["3"] = { ":HarpoonGotoTerm 3<CR>", "terminal-3" },
        ["4"] = { ":HarpoonGotoTerm 4<CR>", "terminal-4" },

        ["a"] = {
            ["name"] = "+actions",
            ["/"] = { ":SpectreOpen<CR>", "spectre-open" },
            ["a"] = { ":SaveSession<CR>", "save-session" },
            ["c"] = { ":ColorizerToggle<CR>", "toggle-colorizer" },
            ["d"] = { ":DeleteSession<CR>", "delete-session" },
            ["e"] = { ":Oil<CR>", "oil" },
            ["f"] = { ":SpectreCurFileSearch<CR>", "spectre-file-search" },
            ["g"] = { ":Glow<CR>", "markdown-glow" },
            ["h"] = { ":ChatGPT<CR>", "chatgpt" },
            ["i"] = { ":ISwapWith<CR>", "iswap-with" },
            ["I"] = { ":ISwap<CR>", "iswap" },
            ["l"] = { ":SearchSession<CR>", "search-sessions" },
            ["m"] = { ":ChatGPTActAs<CR>", "chatgp-act-as" },
            ["n"] = { ":NeuralPrompt<CR>", "neural-prompt" },
            ["o"] = { ":OilFloat<CR>", "oil-float" },
            ["p"] = { ":MarkdownPreviewToggle<CR>", "markdown-preview-toggle" },
            ["r"] = { ":ChatGPTEditWithInstructions<CR>", "chatgpt-edit-instruction" },
            ["s"] = { ":StartupTime<CR>", "run-startup-time" },
            ["w"] = { ":SpectreCurWord<CR>", "spectre-current-word-search" },
        },
        ["b"] = {
            ["name"] = "+buffers",
            ["a"] = { ":bfirst<CR>", "first-buffer" },
            ["b"] = { ":Telescope buffers<CR>", "telescope-buffers" },
            ["c"] = { ":vnew<CR>", "new-empty-buffer-vert" },
            ["d"] = { ":Bdelete<CR>", "delete-buffer" },
            ["D"] = { ":Bdelete!<CR>", "delete-buffer-without-prompt" },
            ["l"] = { ":Telescope current_buffer_fuzzy_find<CR>", "search-buffer-lines" },
            ["m"] = { ":Telescope marks<CR>", "telescope-marks" },
            ["M"] = { ":delm!<CR>", "delete-marks" },
            ["n"] = { ":bn<CR>", "next-buffer" },
            ["o"] = { ":BufOnly<CR>", "close-all-but-current" },
            ["p"] = { ":bp<CR>", "prev-buffer" },
            ["r"] = { ":e<CR>", "refresh-buffer" },
            ["R"] = { ":bufdo :e<CR>", "refresh-loaded-buffers" },
            ["v"] = { ":vnew<CR>", "new-empty-buffer-vertically" },
            ["w"] = { ":Bwipeout<CR>", "close-buffer-and-window" },
            ["z"] = { ":blast<CR>", "first-buffer" },
        },
        ["c"] = {
            ["name"] = "+ChatGPT",
            ["a"] = { ":ChatGPTRun add_tests<CR>", "chatgpt-add-tests" },
            ["d"] = { ":ChatGPTRun docstring<CR>", "chatgpt-docstring" },
            ["f"] = { ":ChatGPTRun fix_bugs<CR>", "chatgpt-fix-bugs" },
            ["g"] = { ":ChatGPTRun grammar_correction<CR>", "chatgpt-grammar-correction" },
            ["o"] = { ":ChatGPTRun optimize_code<CR>", "chatgpt-optimize-code" },
            ["s"] = { ":ChatGPTRun summarize<CR>", "chatgpt-summarize" },
            ["t"] = { ":ChatGPTRun translate<CR>", "chatgpt-translate" },
        },
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
        ["e"] = {
            ["name"] = "+errors",
            ["b"] = { ":TroubleToggle document_diagnostics<CR>", "buffer-diagnostics-quickfix" },
            ["d"] = { ":LspDiagnosticDisable<CR>", "disable-diagnostic" },
            ["e"] = { ":LspDiagnosticEnable<CR>", "enable-diagnostic" },
            ["l"] = { ":Telescope diagnostics<CR>", "workspace-diagnostics" },
            ["n"] = { ":LspGotoNextDiagnostic<CR>", "next-diagnostics" },
            ["p"] = { ":LspGotoPrevDiagnostic<CR>", "prev-diagnostics" },
            ["q"] = { ":LspDiagnostics<CR>", "quickfix-diagnostics" },
            ["v"] = { ":ShowLineDiagnosticInFlot<CR>", "diagnostic-float-preview" },
            ["w"] = { ":TroubleToggle workspace_diagnostics<CR>", "workspace-diagnostics-quickfix" },
        },
        ["f"] = {
            ["name"] = "+files",
            ["a"] = { ":HarpoonAddFile<CR>", "add-file" },
            ["c"] = { ":TelescopeEditDotfiles<CR>", "dotfiles" },
            ["d"] = { ":Telescope find_files theme=dropdown<CR>", "with-dropdown" },
            ["e"] = { ":TelescopeEditNeovim<CR>", "neovim-config" },
            ["f"] = { ":Telescope find_files<CR>", "files" },
            ["g"] = { ":Telescope git_files<CR>", "git-files" },
            ["h"] = { ":Telescope frecency<CR>", "frecency" },
            ["i"] = { ":Telescope find_files theme=ivy<CR>", "ivy-theme-files" },
            ["m"] = { ":ToggleHarpoonMenu<CR>", "quick-menu" },
            ["M"] = { ":Telescope harpoon marks<CR>", "telescope-harpoon-marks" },
            ["n"] = { ":HarpoonNextMark<CR>", "next-mark" },
            ["o"] = { ":Telescope oldfiles<CR>", "old-files" },
            ["p"] = { ":HarpoonPrevMark<CR>", "prev-mark" },
            ["r"] = { ":HarpoonRemoveFile<CR>", "remove-file" },
            ["s"] = { ":w<CR>", "save-buffer" },
            ["S"] = { ":wa<CR>", "save-all-buffers" },
            ["t"] = { ":Telescope filetypes<CR>", "file-types" },
            ["q"] = { ":wq<CR>", "save-and-quit" },
        },
        ["g"] = {
            ["name"] = "+git",
            ["/"] = { ":Telescope git_status<CR>", "git-status" },
            [";"] = { ":Gitsigns diffthis<CR>", "diffthis" },
            ["a"] = { ":Telescope git_worktree create_git_worktree<CR>", "create-worktree" },
            ["b"] = { ":Telescope git_branches<CR>", "checkout" },
            ["c"] = { ":Telescope git_commits<CR>", "git-commits" },
            ["C"] = { ":Telescope git_bcommits<CR>", "git-buffer-commits" },
            ["d"] = { ":DiffviewOpen<CR>", "diffview-open" },
            ["D"] = { ":DiffviewClose<CR>", "diffview-close" },
            ["e"] = { ":Gitsigns stage_hunk<CR>", "stage-hunk" },
            ["f"] = { ":DiffviewFileHistory<CR>", "diffview-file-history" },
            ["g"] = { ":Git<CR>", "git-status" },
            ["h"] = {
                ["name"] = "+gh",
                ["f"] = { ":Telescope gh pull_request_files<CR>", "gh-pr-files" },
                ["g"] = { ":Telescope gh gist<CR>", "gh-gist" },
                ["I"] = { ":Telescope gh issues<CR>", "gh-issues" },
                ["P"] = { ":Telescope gh pull_request<CR>", "gh-pr" },
                ["c"] = {
                    ["name"] = "+Commits",
                    ["c"] = { "<cmd>GHCloseCommit<cr>", "Close" },
                    ["e"] = { "<cmd>GHExpandCommit<cr>", "Expand" },
                    ["o"] = { "<cmd>GHOpenToCommit<cr>", "Open To" },
                    ["p"] = { "<cmd>GHPopOutCommit<cr>", "Pop Out" },
                    ["z"] = { "<cmd>GHCollapseCommit<cr>", "Collapse" },
                },
                ["i"] = {
                    ["name"] = "+Issues",
                    ["p"] = { "<cmd>GHPreviewIssue<cr>", "Preview" },
                },
                ["l"] = {
                    ["name"] = "+Litee",
                    ["t"] = { "<cmd>LTPanel<cr>", "Toggle Panel" },
                },
                ["r"] = {
                    ["name"] = "+Review",
                    ["b"] = { "<cmd>GHStartReview<cr>", "Begin" },
                    ["c"] = { "<cmd>GHCloseReview<cr>", "Close" },
                    ["d"] = { "<cmd>GHDeleteReview<cr>", "Delete" },
                    ["e"] = { "<cmd>GHExpandReview<cr>", "Expand" },
                    ["s"] = { "<cmd>GHSubmitReview<cr>", "Submit" },
                    ["z"] = { "<cmd>GHCollapseReview<cr>", "Collapse" },
                },
                ["p"] = {
                    ["name"] = "+Pull Request",
                    ["c"] = { "<cmd>GHClosePR<cr>", "Close" },
                    ["d"] = { "<cmd>GHPRDetails<cr>", "Details" },
                    ["e"] = { "<cmd>GHExpandPR<cr>", "Expand" },
                    ["o"] = { "<cmd>GHOpenPR<cr>", "Open" },
                    ["p"] = { "<cmd>GHPopOutPR<cr>", "PopOut" },
                    ["r"] = { "<cmd>GHRefreshPR<cr>", "Refresh" },
                    ["t"] = { "<cmd>GHOpenToPR<cr>", "Open To" },
                    ["z"] = { "<cmd>GHCollapsePR<cr>", "Collapse" },
                },
                ["t"] = {
                    ["name"] = "+Threads",
                    ["c"] = { "<cmd>GHCreateThread<cr>", "Create" },
                    ["n"] = { "<cmd>GHNextThread<cr>", "Next" },
                    ["t"] = { "<cmd>GHToggleThread<cr>", "Toggle" },
                },
            },
            ["l"] = { ":Telescope git_worktree git_worktrees<CR>", "list-worktrees" },
            ["m"] = { ":Gitsigns blame_line<CR>", "blame-line" },
            ["n"] = { ":Gitsigns next_hunk<CR>", "next-hunk" },
            ["o"] = { ":BrowseRepo<CR>", "open-repo" },
            ["p"] = { ":Gitsigns prev_hunk<CR>", "prev-hunk" },
            ["r"] = { ":Gitsigns refresh<CR>", "refresh" },
            ["S"] = { ":Gitsigns select_hunk<CR>", "select-hunk" },
            ["s"] = { ":Neogit<CR>", "status" },
            ["t"] = { ":Telescope git_stash<CR>", "git-stash" },
            ["u"] = { ":Gitsigns reset_buffer<CR>", "reset-buffer" },
            ["v"] = { ":Gitsigns preview_hunk<CR>", "preview-hunk" },
            ["w"] = { ":Gitsigns stage_buffer<CR>", "stage-buffer" },
            ["x"] = { ":Gitsigns reset_hunk<CR>", "reset-hunk" },
        },
        ["h"] = {
            ["name"] = "+highlight",
            ["h"] = { ":TSHighlightCapturesUnderCursor<CR>", "show-highlights-info" },
        },
        ["i"] = {
            ["name"] = "+insert-text",
            ["a"] = { ":AttemptNew<CR>", "new-scratch-buffer" },
            ["b"] = { ":AttemptRenameBuf<CR>", "rename-scratch-buffer" },
            ["c"] = { ":PickColor<CR>", "color-picker" },
            ["d"] = { ":AttemptDeleteBuf<CR>", "delete-scratch-buffer" },
            ["D"] = { ":DeleteDebugPrints<CR>", "delete-debug-prints" },
            ["e"] = { ":LuaSnipEdit<CR>", "edit-snippets" },
            ["E"] = { ":AttemptNewExtension<CR>", "new-extension-scratch-buffer" },
            ["f"] = { ":Telescope attempt<CR>", "find-scratch-buffers" },
            ["i"] = { ":PickEverything<CR>", "everything" },
            ["r"] = { ":AttemptRun<CR>", "run-scratch-buffer" },
            ["w"] = { ":Telescope spell_suggest<CR>", "spell_suggest" },
        },
        ["j"] = {
            ["name"] = "+jump",
            ["/"] = { ":HopPattern<CR>", "pattern" },
            ["a"] = { ":HopAnywhere<CR>", "anywhere" },
            ["f"] = { ":HopChar1AC<CR>", "char1-ac" },
            ["F"] = { ":HopChar1BC<CR>", "char1-bc" },
            ["j"] = { ":HopChar1<CR>", "char1" },
            ["k"] = { ":HopChar2<CR>", "char2" },
            ["l"] = { ":HopLineStart<CR>", "line-start" },
            ["L"] = { ":HopLine<CR>", "line" },
            ["t"] = { ":HopChar2AC<CR>", "char2-ac" },
            ["T"] = { ":HopChar2BC<CR>", "char2-bc" },
            ["w"] = { ":HopWord<CR>", "word" },
            ["W"] = { ":HopWordMW<CR>", "word-mw" },
        },
        ["k"] = {
            require("ts-node-action").node_action,
            "Trigger Node Action",
        },
        ["l"] = {
            ["name"] = "+lsp",
            ["a"] = { ":LspCodeActions<CR>", "code-action" },
            ["d"] = { ":LspDefinition<CR>", "definition" },
            ["D"] = { ":LspDeclaration<CR>", "declaration" },
            ["h"] = { ":LspHover<CR>", "hover-doc" },
            ["i"] = { ":LspInfo<CR>", "lsp-info" },
            ["I"] = { ":LspImplementation<CR>", "implementation" },
            ["m"] = { ":Mason<CR>", "lsp-installer-info" },
            ["r"] = { ":LspRename<CR>", "rename" },
            ["R"] = { ":LspReferences<CR>", "references" },
            ["s"] = { ":LspDocumentSymbols<CR>", "document-symbols" },
            ["t"] = { ":LspTypeDefinition<CR>", "type-definition" },
            ["w"] = { ":LspWorkspaceSymbols<CR>", "workspace-symbols" },
        },
        ["m"] = {
            ["name"] = "+mind.nvim",
            ["a"] = { ":MindCreateInSmart", "create-in-smart" },
            ["A"] = { ":MindCreateInMain<CR>", "create-in-main" },
            ["c"] = { ":MindCopyFromSmart", "copy-from-smart" },
            ["C"] = { ":MindCopyFromMain<CR>", "copy-from-main" },
            ["i"] = { ":MindInitializeProject<CR>", "initialize-project" },
            ["j"] = { ":MindJournal<CR>", "jorunal" },
            ["m"] = { ":MindOpenMain<CR>", "mind-open" },
            ["O"] = { ":MindOpenFromSmart", "open-from-smart" },
            ["o"] = { ":MindOpenFromMain<CR>", "open-from-main" },
            ["p"] = { ":MindOpenProject<CR>", "mind-project" },
            ["q"] = { ":MindClose<CR>", "mind-close" },
            ["r"] = { ":MindReloadState<CR>", "mind-reload-state" },
            ["s"] = { ":MindOpenSmartProject<CR>", "mind-smart-project" },
        },
        ["n"] = {
            ["name"] = "+neovim",
            ["d"] = { ":Lazy clean<CR>", "clean-packages" },
            ["e"] = { ":e $HOME/.config/nvim/init.lua<CR>", "edit-config" },
            ["g"] = { ":e ~/.config/nvim/ginit.vim<CR>", "edit-gui" },
            ["G"] = { ":so ~/.config/nvim/ginit.vim<CR>", "reload-gui" },
            ["H"] = { ":checkhealth<CR>", "check-health" },
            ["i"] = { ":Lazy install<CR>", "lazy-install" },
            ["l"] = { ":lua Save_and_execute()<CR>", "save-and-execute" },
            ["m"] = { ":ReloadModule ", "realod-module" },
            ["p"] = { ":Telescope lazy<CR>", "telescope-lazy" },
            ["P"] = { ":Lazy profile<CR>", "lazy-profile" },
            ["t"] = { ":ReloadConfigTelescope<CR>", "realod-modules" },
            ["r"] = { ":ReloadConfig<CR>", "realod-config" },
            ["s"] = { ":Lazy sync<CR>", "lazy-sync" },
            ["S"] = { ":Lazy<CR>", "packages-status" },
            ["u"] = { ":Lazy update<CR>", "lazy-update" },
        },
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
                ["a"] = { ":Octo reviewer add<CR>", "add-reviewer" },
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
        ["p"] = {
            ["name"] = "+project",
            ["b"] = { ":Telescope buffers<CR>", "find-buffers" },
            ["f"] = { ":Telescope find_files<cr>", "find-files" },
            ["l"] = { ":Telescope smart_open<cr>", "smart-open-files" },
            ["o"] = { ":Telescope oldfiles<CR>", "old-files" },
            ["g"] = { ":Telescope git_files<CR>", "find-git-files" },
            ["h"] = { ":Telescope frecency workspace=CWD<CR>", "cwd-frecency" },
            ["p"] = { ":Telescope projects<CR>", "projects" },
            ["s"] = { ":Telescope live_grep<CR>", "project-search" },
            ["w"] = { ":Telescope grep_string<CR>", "string-search" },
        },
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
            ["r"] = { ":Telescope refactoring refactors<CR>", "list-refactors" },
            ["s"] = { ":SnipRun<CR>", "snip-run" },
            ["S"] = { ":SnipClose<CR>", "snip-close" },
        },
        ["s"] = {
            ["name"] = "+search",
            ["/"] = { ":Telescope search_history<CR>", "search-history" },
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
            ["s"] = { ":TelescopeFuzzyLiveGrep<CR>", "fuzzy-live-grep" },
            ["S"] = { ":Telescope colorscheme<CR>", "color-schemes" },
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
        ["S"] = {
            ["name"] = "+system",
            ["b"] = { ":ChangeSystemBackground<CR>", "change-system-background" },
            ["c"] = { ":lua Get_current_working_directory()<CR>", "current-working-directory" },
            ["f"] = { ":lua Show_current_file_path()<CR>", "show-current-file-path" },
            ["n"] = { "<Plug>(SpotifySkip)", "skip-current-song" },
            ["p"] = { "<Plug>(SpotifyPrev)", "prev-song" },
            ["t"] = { ":lua Notify_current_datetime()<CR>", "current-date-time" },
            ["y"] = { ":lua Yank_current_file_name()<CR>", "yank-current-file-name" },
        },
        ["t"] = {
            ["name"] = "+toggle",
            ["j"] = { ":TSJToggle<CR>", "treesj-toggle" },
            ["g"] = {
                ["name"] = "+git",
                ["b"] = { ":Gitsigns toggle_current_line_blame<CR>", "toggle-blame" },
                ["l"] = { ":Gitsigns toggle_linehl<CR>", "toggle-linehl" },
                ["n"] = { ":Gitsigns toggle_numhl<CR>", "toggle-numhl" },
                ["s"] = { ":Gitsigns toggle_signs<CR>", "toggle-signs" },
                ["w"] = { ":Gitsigns toggle_word_diff<CR>", "toggle-word-diff" },
            },
            ["h"] = { ":sp | te<CR>", "horizontal-split-terminal" },
            ["p"] = { ":NotifyDismiss<CR>", "notify-dismiss" },
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
        ["u"] = {
            ["name"] = "+undo",
            ["u"] = { ":UndotreeToggle<CR>", "undo-tree" },
            ["t"] = { ":Telescope undo<CR>", "telescope-undo" },
        },
        ["v"] = {
            ["name"] = "+vim",
            ["/"] = { ":Telescope search_history<CR>", "search-history" },
            [":"] = { ":Telescope commands<CR>", "commands" },
            ["a"] = { ":Telescope autocommands<CR>", "autocommands" },
            ["c"] = { ":Telescope colorscheme<CR>", "colorschemes" },
            ["C"] = { ":Telescope command_history<CR>", "command-history" },
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

    local local_leader_key_maps = {
        ["1"] = { ":HarpoonGotoFile 1<CR>", "goto-file-1" },
        ["2"] = { ":HarpoonGotoFile 2<CR>", "goto-file-2" },
        ["3"] = { ":HarpoonGotoFile 3<CR>", "goto-file-3" },
        ["4"] = { ":HarpoonGotoFile 4<CR>", "goto-file-4" },
        ["5"] = { ":HarpoonGotoFile 5<CR>", "goto-file-5" },
        ["6"] = { ":HarpoonGotoFile 6<CR>", "goto-file-6" },
        ["7"] = { ":HarpoonGotoFile 7<CR>", "goto-file-7" },
        ["8"] = { ":HarpoonGotoFile 8<CR>", "goto-file-8" },
        ["9"] = { ":HarpoonGotoFile 9<CR>", "goto-file-9" },
        ["b"] = {
            ["name"] = "+browse",
            ["b"] = { ":Browse<CR>", "browse" },
            ["l"] = { ":BrowseBookmarks<CR>", "bookmarks" },
            ["d"] = { ":BrowseDevdocsFiletypeSearch<CR>", "devdocs-filetype-search" },
            ["D"] = { ":BrowseDevdocsSearch<CR>", "devdocs-search" },
            ["i"] = { ":BrowseInputSearch<CR>", "input-search" },
            ["m"] = { ":BrowseMdnSearch<CR>", "mdn-search" },
        },
        ["d"] = { ":Neogen<CR>", "doc-this" },
        ["l"] = {
            ["name"] = "+loclist",
            ["c"] = { ":lclose<CR>", "close" },
            ["l"] = { ":Telescope loclist<CR>", "fuzzy-loclist" },
            ["n"] = { ":lnext<CR>", "next" },
            ["o"] = { ":lopen<CR>", "open" },
            ["p"] = { ":lprev<CR>", "prev" },
        },
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
    }

    local visual_mode_leader_key_maps = {
        ["r"] = {
            ["name"] = "+refators",
            ["r"] = { "<esc>:Telescope refactoring refactors<CR>", "list-refactors" },
        },
        ["s"] = { ":SpectreVisual<CR>", "spectre-visual-search" },
        ["a"] = {
            ["name"] = "+actions",
            ["n"] = { ":NeuralPrompt<CR>", "neural-prompt" },
        },
        ["c"] = {
            ["name"] = "+ChatGPT",
            ["a"] = { ":ChatGPTRun add_tests<CR>", "chatgpt-add-tests" },
            ["d"] = { ":ChatGPTRun docstring<CR>", "chatgpt-docstring" },
            ["f"] = { ":ChatGPTRun fix_bugs<CR>", "chatgpt-fix-bugs" },
            ["g"] = { ":ChatGPTRun grammar_correction<CR>", "chatgpt-grammar-correction" },
            ["o"] = { ":ChatGPTRun optimize_code<CR>", "chatgpt-optimize-code" },
            ["s"] = { ":ChatGPTRun summarize<CR>", "chatgpt-summarize" },
            ["t"] = { ":ChatGPTRun translate<CR>", "chatgpt-translate" },
        },
        ["["] = { '"zy:%S/<c-r><c-o>"//c<left><left>', "abolish-replace" },
    }

    wk.register(local_leader_key_maps, { prefix = "<localleader>" })
    wk.register(leader_key_maps, { prefix = "<leader>" })
    wk.register(visual_mode_leader_key_maps, { prefix = "<leader>", mode = "v" })
end

return M
