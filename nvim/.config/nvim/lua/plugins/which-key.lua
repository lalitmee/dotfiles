local M = {
    "folke/which-key.nvim",
    event = { "VeryLazy" },
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
            winblend = 0,
        },
    })

    local leader_key_maps = {
        [":"] = { ":FzfLua commands<CR>", "commands" },
        ["<leader>"] = { ":FzfLua files<CR>", "find-files" },
        ["/"] = { ":FzfLua live_grep<CR>", "search-project" },
        ["]"] = { ":S/<c-r><c-w>//<left>", "replace-all" },
        ["["] = { ":%S/<c-r><c-w>//c<left><left>", "replace-current" },
        ["1"] = { ":HarpoonGotoTerm 1<CR>", "terminal-1" },
        ["2"] = { ":HarpoonGotoTerm 2<CR>", "terminal-2" },
        ["3"] = { ":HarpoonGotoTerm 3<CR>", "terminal-3" },
        ["4"] = { ":HarpoonGotoTerm 4<CR>", "terminal-4" },

        ["a"] = {
            ["name"] = "+actions",
            ["a"] = { ":FzfLua builtin<CR>", "fzf-lua-builtin" },
            ["c"] = { ":ColorizerToggle<CR>", "toggle-colorizer" },
            ["d"] = { ":NotifyDismiss<CR>", "notify-dismiss" },
            ["h"] = { ":sp | te<CR>", "horizontal-split-terminal" },
            ["l"] = { ":Telescope zoxide list<CR>", "zoxide-list" },
            ["m"] = { ":Telescope messages messages<CR>", "search-messages" },
            ["n"] = { ":Notifications<CR>", "notifications" },
            ["p"] = { ":MarkdownPreview<CR>", "markdown-preview" },
            ["u"] = { ":UndotreeToggle<CR>", "undo-tree" },
            ["v"] = { ":vs | te<CR>", "vertical-split-terminal" },
        },

        ["b"] = {
            ["name"] = "+buffers",
            ["a"] = { ":bfirst<CR>", "first-buffer" },
            ["b"] = { ":FzfLua buffers<CR>", "fzf-buffers" },
            ["B"] = { ":Telescope buffers<CR>", "telescope-buffers" },
            ["c"] = { ":vnew<CR>", "new-empty-buffer-vert" },
            ["d"] = { ":Bdelete<CR>", "delete-buffer" },
            ["D"] = { ":Bdelete!<CR>", "delete-buffer-without-prompt" },
            ["l"] = { ":FzfLua blines<CR>", "fzf-buffer-lines" },
            ["L"] = { ":Telescope current_buffer_fuzzy_find<CR>", "telescope-buffer-lines" },
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
            ["a"] = { ":ChatGPTRun add_tests<CR>", "add-tests" },
            ["b"] = { ":Backseat<CR>", "backseat" },
            ["c"] = { ":ChatGPT<CR>", "chatgpt" },
            ["d"] = { ":ChatGPTRun docstring<CR>", "docstring" },
            ["e"] = { ":ChatGPTEditWithInstructions<CR>", "edit-instructions" },
            ["f"] = { ":ChatGPTRun fix_bugs<CR>", "fix-bugs" },
            ["g"] = { ":ChatGPTRun grammar_correction<CR>", "grammar-correction" },
            ["h"] = { ":ChatGPTActAs<CR>", "act-as" },
            ["k"] = { ":BackseatAsk<CR>", "backseat-ask" },
            ["l"] = { ":BackseatClearLine<CR>", "backseat-clear-line" },
            ["o"] = { ":ChatGPTRun optimize_code<CR>", "optimize-code" },
            ["r"] = { ":ChatGPTRun<CR>", "chatgpt-run" },
            ["s"] = { ":ChatGPTRun summarize<CR>", "summarize" },
            ["t"] = { ":ChatGPTRun translate<CR>", "translate" },
            ["x"] = { ":BackseatClear<CR>", "backseat-clear" },
        },

        ["e"] = {
            ["name"] = "+errors",
            ["d"] = { ":LspDiagnosticDisable<CR>", "disable-diagnostic" },
            ["e"] = { ":LspDiagnosticEnable<CR>", "enable-diagnostic" },
            ["l"] = { ":Telescope diagnostics<CR>", "workspace-diagnostics" },
            ["n"] = { ":LspGotoNextDiagnostic<CR>", "next-diagnostics" },
            ["p"] = { ":LspGotoPrevDiagnostic<CR>", "prev-diagnostics" },
            ["q"] = { ":LspDiagnostics<CR>", "quickfix-diagnostics" },
            ["v"] = {
                ":ShowLineDiagnosticInFloat<CR>",
                "diagnostic-float-preview",
            },
        },

        ["f"] = {
            ["name"] = "+files",
            ["a"] = { ":HarpoonAddFile<CR>", "add-file" },
            ["c"] = { ":TelescopeEditDotfiles<CR>", "dotfiles" },
            ["d"] = {
                ":Telescope find_files theme=dropdown<CR>",
                "with-dropdown",
            },
            ["e"] = { ":TelescopeEditNeovim<CR>", "neovim-config" },
            ["f"] = { ":FzfLua files<CR>", "files" },
            ["g"] = { ":Telescope git_files<CR>", "git-files" },
            ["i"] = {
                ":Telescope find_files theme=ivy<CR>",
                "ivy-theme-files",
            },
            ["m"] = { ":ToggleHarpoonMenu<CR>", "quick-menu" },
            ["M"] = {
                ":Telescope harpoon marks<CR>",
                "telescope-harpoon-marks",
            },
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
            ["b"] = { ":Telescope git_branches<CR>", "checkout" },
            ["c"] = {
                ["name"] = "+commit",
                ["c"] = { ":Telescope git_commits<CR>", "git-commits" },
                ["b"] = { ":Telescope git_bcommits<CR>", "git-buffer-commits" },
            },
            ["d"] = {
                ["name"] = "+diff",
                ["c"] = { ":DiffviewClose<CR>", "diffview-close" },
                ["d"] = { ":Gitsigns diffthis<CR>", "diffthis" },
                ["f"] = { ":DiffviewFileHistory %<CR>", "current-file-history" },
                ["F"] = { ":DiffviewFileHistory<CR>", "diffview-file-history" },
                ["o"] = { ":DiffviewOpen<CR>", "diffview-open" },
                ["w"] = {
                    ":Gitsigns toggle_word_diff<CR>",
                    "toggle-word-diff",
                },
            },
            ["g"] = { ":Neogit<CR>", "status" },
            -- moved to Hydra
            -- ["h"] = {
            --     ["name"] = "+hunks",
            -- },
            ["m"] = { ":Gitsigns blame_line<CR>", "blame-line" },
            ["n"] = { ":GitHunks<CR>", "git-hunks" },
            ["O"] = { ":BrowseRepo<CR>", "open-repo" },
            ["s"] = { ":Git<CR>", "git-status" },
            ["t"] = { ":Telescope git_stash<CR>", "git-stash" },
        },

        ["h"] = {
            ["name"] = "+highlight",
            ["h"] = {
                ":TSHighlightCapturesUnderCursor<CR>",
                "show-highlights-info",
            },
        },

        ["i"] = {
            ["name"] = "+insert-text",
            ["c"] = { ":PickColor<CR>", "color-picker" },
            ["d"] = { ":DeleteDebugPrints<CR>", "delete-debug-prints" },
            ["e"] = { ":LuaSnipEdit<CR>", "edit-snippets" },
            ["i"] = { ":ISwap<CR>", "iswap" },
            ["p"] = { ":PickEverything<CR>", "everything" },
            ["l"] = { ":ISwapWithLeft<CR>", "swap-with-left" },
            ["n"] = { ":ISwapNode<CR>", "swap-nodes" },
            ["r"] = { ":ISwapWithRight<CR>", "swap-with-right" },
            ["s"] = { ":Telescope spell_suggest<CR>", "spell_suggest" },
            ["w"] = { ":ISwapWith<CR>", "swap-with" },
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
            ["a"] = { ":Telescope lazy<CR>", "telescope-lazy" },
            ["h"] = { ":checkhealth<CR>", "check-health" },
            ["p"] = { ":Lazy profile<CR>", "lazy-profile" },
            ["o"] = { ":Lazy<CR>", "packages-status" },
            ["c"] = { ":Lazy clean<CR>", "clean-packages" },
            ["d"] = { ":NotifyDismiss<CR>", "notify-dismiss" },
            ["i"] = { ":Lazy install<CR>", "lazy-install" },
            ["l"] = { ":lua Save_and_execute()<CR>", "save-and-execute" },
            ["m"] = { ":ReloadModule ", "realod-module" },
            ["s"] = { ":Lazy sync<CR>", "lazy-sync" },
            ["t"] = { ":ReloadConfigTelescope<CR>", "realod-modules" },
            ["u"] = { ":Lazy update<CR>", "lazy-update" },
        },

        ["o"] = {
            ["name"] = "+org-mode",
        },

        ["p"] = {
            ["name"] = "+project",
            ["/"] = { ":Telescope live_grep_args<CR>", "live-grep-args" },
            ["b"] = { ":Telescope buffers<CR>", "find-buffers" },
            ["f"] = { ":FzfLua files<cr>", "find-files" },
            ["o"] = { ":Telescope oldfiles<CR>", "old-files" },
            ["g"] = { ":Telescope git_files<CR>", "find-git-files" },
            ["p"] = { ":Telescope projects<CR>", "projects" },
            ["s"] = { ":FzfLua live_grep<CR>", "project-search" },
            ["w"] = { ":Telescope grep_string<CR>", "string-search" },
        },

        ["q"] = {
            ["name"] = "+quickfix",
            ["c"] = { ":cclose<CR>", "close" },
            ["l"] = { ":Telescope quickfix<CR>", "telescope-quickfix" },
            ["n"] = { ":cnext<CR>", "next" },
            ["o"] = { ":copen<CR>", "open" },
            ["p"] = { ":cprev<CR>", "prev" },
            ["q"] = { ":qall<CR>", "quit-neovim" },
        },

        ["r"] = {
            ["name"] = "+build-and-run",
            ["c"] = { ":CompileAndRun<CR>", "compile-and-run" },
            ["r"] = {
                ":Telescope refactoring refactors<CR>",
                "list-refactors",
            },
            ["b"] = {
                "<Cmd>lua require('refactoring').refactor('Extract Block')<CR>",
                "extract-block",
            },
            ["bf"] = {
                "<Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>",
                "extract-block-to-file",
            },
            ["i"] = {
                "<Cmd>lua require('refactoring').refactor('Inline Variable')<CR>",
                "inline-variable",
            },
            ["s"] = { ":SnipRun<CR>", "snip-run" },
            ["S"] = { ":SnipClose<CR>", "snip-close" },
        },

        ["s"] = {
            ["name"] = "+search-and-replace",
            ["f"] = { ":SpectreCurFileSearch<CR>", "file-search" },
            ["r"] = { ":FzfLua resume<CR>", "live-grep-resume" },
            ["s"] = { ":SpectreOpen<CR>", "open" },
            ["w"] = { ":SpectreCurWord<CR>", "current-word-search" },
        },

        ["t"] = {
            ["name"] = "+telescope",
            ["a"] = { ":Telescope<CR>", "telescope-all-options" },
            ["b"] = { ":Telescope current_buffer_tags<CR>", "buffer-tags" },
            ["B"] = { ":Telescope builtin<CR>", "builtins" },
            ["c"] = { ":Telescope git_commits<CR>", "commits" },
            ["C"] = { ":Telescope git_bcommits<CR>", "buffer-commits" },
            ["d"] = { ":Telescope git_files<CR>", "git-files" },
            ["f"] = { ":Telescope find_files<CR>", "files" },
            ["F"] = { ":Telescope filetypes<CR>", "file-types" },
            ["g"] = { ":Telescope git_status<CR>", "modified-git-files" },
            ["h"] = { ":Telescope command_history<CR>", "command-history" },
            ["i"] = { ":Telescope luasnip<CR>", "snippets" },
            ["l"] = {
                ":Telescope current_buffer_fuzzy_find<CR>",
                "telescope-buffer-lines",
            },
            ["m"] = { ":Telescope man_pages<CR>", "man-pages" },
            ["n"] = { ":TelescopeNotifyHistory<CR>", "notify-history" },
            ["s"] = { ":TelescopeFuzzyLiveGrep<CR>", "fuzzy-live-grep" },
            ["o"] = { ":Telescope oldfiles<CR>", "old-files" },
            ["p"] = { ":Telescope live_grep<CR>", "live-grep" },
            ["P"] = { ":Telescope live_grep_args<CR>", "live-grep-args" },
            ["r"] = { ":Telescope resume<CR>", "resume-search" },
            ["R"] = { ":Telescope reloader<CR>", "reloaders" },
            ["t"] = { ":Telescope treesitter<CR>", "treesitter" },
            ["T"] = { ":Telescope tags<CR>", "project-tags" },
            ["y"] = { ":Telescope yank_history<CR>", "yank-history" },
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
            ["H"] = { "<C-W>10<", "expand-window-left" },
            ["i"] = { "<C-W>K", "move-window-far-top" },
            ["J"] = { ":resize +10<CR>", "expand-window-below" },
            ["K"] = { ":resize  10<CR>", "expand-window-up" },
            ["L"] = { "<C-W>10>", "expand-window-right" },
            ["m"] = { ":NeoZoomToggle<CR>", "maximize-window" },
            ["n"] = { "<C-W>J", "move-window-far-down" },
            ["o"] = { ":only<CR>", "close-other-windows-except-this" },
            ["r"] = { "<C-W>r", "window-swap" },
            ["s"] = { "<C-W>s", "split-window-below" },
            ["t"] = { "<C-W>T", "move-split-to-tab" },
            ["u"] = { "<C-W>x", "swap-window-next" },
            ["v"] = { "<C-W>v", "split-window-right" },
        },

        ["y"] = { ":YankyRingHistory<CR>", "yank-ring-history" },
    }

    local local_leader_key_maps = {
        ["/"] = { ":FzfLua live_grep<CR>", "fzf-live-grep" },
        ["1"] = { ":HarpoonGotoFile 1<CR>", "goto-file-1" },
        ["2"] = { ":HarpoonGotoFile 2<CR>", "goto-file-2" },
        ["3"] = { ":HarpoonGotoFile 3<CR>", "goto-file-3" },
        ["4"] = { ":HarpoonGotoFile 4<CR>", "goto-file-4" },
        ["5"] = { ":HarpoonGotoFile 5<CR>", "goto-file-5" },
        ["6"] = { ":HarpoonGotoFile 6<CR>", "goto-file-6" },
        ["7"] = { ":HarpoonGotoFile 7<CR>", "goto-file-7" },
        ["8"] = { ":HarpoonGotoFile 8<CR>", "goto-file-8" },
        ["9"] = { ":HarpoonGotoFile 9<CR>", "goto-file-9" },

        ["a"] = {
            ["name"] = "+system-actions",
            ["b"] = { ":Bottom<CR>", "bottom" },
            ["c"] = { ":WorkingDirectory<CR>", "cwd" },
            ["f"] = { ":FilePath<CR>", "copy-file-path" },
            ["n"] = { "<Plug>(SpotifySkip)", "skip-current-song" },
            ["p"] = { "<Plug>(SpotifyPrev)", "prev-song" },
            ["w"] = { ":SetWallpaper<CR>", "change-system-background" },
        },

        ["c"] = {
            ["name"] = "+toggle",
            ["j"] = { ":TSJToggle<CR>", "treesj-toggle" },
            ["g"] = {
                ["name"] = "+git",
                ["b"] = {
                    ":Gitsigns toggle_current_line_blame<CR>",
                    "toggle-blame",
                },
                ["l"] = { ":Gitsigns toggle_linehl<CR>", "toggle-linehl" },
                ["n"] = { ":Gitsigns toggle_numhl<CR>", "toggle-numhl" },
                ["s"] = { ":Gitsigns toggle_signs<CR>", "toggle-signs" },
            },
            ["m"] = { ":Telescope macros<CR>", "neo-composer-macros" },
            ["s"] = {
                ["name"] = "+scrolloff",
                ["t"] = { ":set scrolloff=10<CR>", "scrolloff=10" },
                ["h"] = { ":set scrolloff=5<CR>", "scrolloff=5" },
                ["n"] = { ":set scrolloff=999<CR>", "scrolloff=999" },
            },
            ["t"] = { ":TSPlaygroundToggle<CR>", "playground" },
            ["u"] = { ":UndotreeToggle<CR>", "undo-tree" },
        },

        ["f"] = {
            ["name"] = "+fzf-lua",
            ["a"] = { ":FzfLua builtin<CR>", "builtins" },
            ["f"] = { ":FzfLua files<CR>", "files" },
            ["r"] = { ":FzfLua live_grep_resume<CR>", "live-grep-resume" },
        },

        ["s"] = {
            ["name"] = "+scratch",
            ["a"] = { ":Scretch<CR>", "new-scratch" },
            ["e"] = { ":ScretchExplore<CR>", "scratch-explore" },
            ["f"] = { ":ScretchSearch<CR>", "search-scratch" },
            ["g"] = { ":ScretchGrep<CR>", "scratch-grep" },
            ["l"] = { ":ScretchLast<CR>", "last-scratch" },
            ["n"] = { ":ScretchNamed<CR>", "scratch-with-name" },
        },

        ["t"] = {
            -- it is reserved for neorg keybindings
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
            ["r"] = { ":TabRename<Space>", "rename-tab" },
        },
    }

    local visual_mode_leader_key_maps = {
        ["r"] = {
            ["name"] = "+refators",
            ["r"] = {
                "<esc>:Telescope refactoring refactors<CR>",
                "list-refactors",
            },
            ["f"] = {
                "<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>",
                "extract-function",
            },
            ["F"] = {
                "<Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>",
                "extract-function-to-file",
            },
            ["v"] = {
                "<Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>",
                "extract-variable",
            },
            ["i"] = {
                "<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>",
                "inline-variable",
            },
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
            ["g"] = {
                ":ChatGPTRun grammar_correction<CR>",
                "chatgpt-grammar-correction",
            },
            ["o"] = {
                ":ChatGPTRun optimize_code<CR>",
                "chatgpt-optimize-code",
            },
            ["s"] = { ":ChatGPTRun summarize<CR>", "chatgpt-summarize" },
            ["t"] = { ":ChatGPTRun translate<CR>", "chatgpt-translate" },
        },

        ["["] = { '"zy:%S/<c-r><c-o>"//c<left><left>', "abolish-replace" },
    }

    wk.register(local_leader_key_maps, { prefix = "<localleader>" })
    wk.register(leader_key_maps, { prefix = "<leader>" })
    wk.register(visual_mode_leader_key_maps, {
        prefix = "<leader>",
        mode = "v",
    })
end

return M
