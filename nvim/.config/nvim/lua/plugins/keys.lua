return {
    { --[[ which-key ]]
        "folke/which-key.nvim",
        event = { "VeryLazy" },
        config = function()
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
                    ["name"] = "+actions",
                    ["a"] = { ":FzfLua builtin<CR>", "fzf-lua-builtin" },
                    ["b"] = { ":Bottom<CR>", "bottom" },
                    ["c"] = { ":ColorizerToggle<CR>", "toggle-colorizer" },
                    ["d"] = { ":NotifyDismiss<CR>", "notify-dismiss" },
                    ["D"] = { ":LazyDocker<CR>", "docker" },
                    ["f"] = { ":Notifications<CR>", "notifications" },
                    ["h"] = { ":sp | te<CR>", "horizontal-split-terminal" },
                    ["k"] = { ":WorkingDirectory<CR>", "cwd" },
                    ["l"] = { ":Telescope zoxide list<CR>", "zoxide-list" },
                    ["m"] = { ":MarkdownPreview<CR>", "markdown-preview" },
                    ["n"] = { ":!playerctl previous -p spotify<CR>", "spotify-prev" },
                    ["o"] = { ":Telescope messages messages<CR>", "search-messages" },
                    ["p"] = { ":!playerctl next -p spotify<CR>", "spotify-next" },
                    ["s"] = { ":!playerctl play-pause -p spotify<CR>", "spotify-play-pause" },
                    ["u"] = { ":UndotreeToggle<CR>", "undo-tree" },
                    ["v"] = { ":vs | te<CR>", "vertical-split-terminal" },
                    ["w"] = { ":SetWallpaper<CR>", "change-system-background" },
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
                    -- moved to Hydra
                    -- ["h"] = {
                    --     ["name"] = "+hunks",
                    -- },
                    ["j"] = {
                        ["name"] = "+git-jump",
                        ["d"] = { ":Jump diff<cr>", "diff" },
                        ["m"] = { ":Jump merge<cr>", "merge" },
                        ["s"] = { ":Jump grep<space>", "grep" },
                    },
                    ["m"] = { ":Gitsigns blame_line<CR>", "blame-line" },
                    ["n"] = { ":GitHunks<CR>", "git-hunks" },
                    ["O"] = {
                        function()
                            vim.cmd([[silent !gh o]])
                        end,
                        "open-repo",
                    },
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
                    ["l"] = {
                        function()
                            local filetype = vim.bo.filetype
                            local filepath = vim.fn.expand("%")
                            if filetype == "lua" then
                                vim.cmd([[
                                    silent! write
                                    luafile %
                                ]])
                            elseif filetype == "vim" then
                                vim.cmd([[
                                    silent! write
                                    source %
                                ]])
                            else
                                vim.cmd([[
                                    silent! write
                                ]])
                            end
                            vim.notify(filepath, 2, { title = " Save and Execute" })
                        end,
                        "save-and-execute",
                    },
                    ["m"] = { ":ReloadModule<space>", "realod-module" },
                    ["r"] = { ":Redir Notifications<CR>", "redir-notifications" },
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
                    ["/"] = { ":SpectreCurFileSearch<CR>", "file-search" },
                    ["r"] = { ":FzfLua resume<CR>", "live-grep-resume" },
                    ["o"] = { ":SpectreOpen<CR>", "open" },
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

                -- x is occupied by possession

                ["y"] = { ":YankyRingHistory<CR>", "yank-ring-history" },
            }

            local local_leader_key_maps = {
                ["/"] = { ":FzfLua live_grep<CR>", "fzf-live-grep" },
                ["1"] = { ":HarpoonGotoTerm 1<CR>", "terminal-1" },
                ["2"] = { ":HarpoonGotoTerm 2<CR>", "terminal-2" },
                ["3"] = { ":HarpoonGotoTerm 3<CR>", "terminal-3" },
                ["4"] = { ":HarpoonGotoTerm 4<CR>", "terminal-4" },

                ["a"] = {
                    ["name"] = "+system-actions",
                    ["n"] = { "<Plug>(SpotifySkip)", "skip-current-song" },
                    ["p"] = { "<Plug>(SpotifyPrev)", "prev-song" },
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
            }

            wk.register(local_leader_key_maps, { prefix = "<localleader>" })
            wk.register(leader_key_maps, { prefix = "<leader>" })
            wk.register(visual_mode_leader_key_maps, {
                prefix = "<leader>",
                mode = "v",
            })
        end,
    },

    { --[[ hydra ]]
        "anuvyklack/hydra.nvim",
        event = { "VeryLazy" },
        init = function()
            local border = lk.style.border.rounded
            local hint_opts = {
                border = border,
                position = "bottom",
            }

            local function gitsigns_menu()
                local gitsigns = require("gitsigns")

                local hint = [[
 _J_: Next hunk   _s_: Stage Hunk        _d_: Show Deleted   _b_: Blame Line
 _K_: Prev hunk   _u_: Undo Last Stage   _p_: Preview Hunk   _B_: Blame Show Full
 _X_: Reset Hunk  _S_: Stage Buffer      _f_: Select Hunk    _r_: Refresh
 ^ ^              _U_: Reset Buffer      _/_: Show Base File
 ^
 ^ ^              _<Enter>_: Neogit              _q_: Exit
]]

                return {
                    name = "Git",
                    hint = hint,
                    config = {
                        color = "pink",
                        invoke_on_body = true,
                        hint = hint_opts,
                        on_enter = function()
                            vim.cmd("mkview")
                            vim.cmd("silent! %foldopen!")
                            vim.bo.modifiable = true
                            gitsigns.toggle_signs(true)
                            gitsigns.toggle_linehl(true)
                        end,
                        on_exit = function()
                            local cursor_pos = vim.api.nvim_win_get_cursor(0)
                            vim.cmd("loadview")
                            vim.api.nvim_win_set_cursor(0, cursor_pos)
                            vim.cmd("normal zv")
                            gitsigns.toggle_signs(true)
                            gitsigns.toggle_linehl(false)
                        end,
                    },
                    body = "<leader>gh",
                    heads = {
                        { "/", gitsigns.show, { exit = true, desc = "Show Base File" } }, -- show the base of the file
                        { "<Enter>", "<Cmd>Neogit<CR>", { exit = true, desc = "Neogit" } },
                        {
                            "B",
                            function()
                                gitsigns.blame_line({ full = true })
                            end,
                            { desc = "Blame Show Full" },
                        },
                        {
                            "J",
                            function()
                                if vim.wo.diff then
                                    return "]c"
                                end
                                vim.schedule(function()
                                    gitsigns.next_hunk()
                                end)
                                return "<Ignore>"
                            end,
                            { expr = true, desc = "Next Hunk" },
                        },
                        {
                            "K",
                            function()
                                if vim.wo.diff then
                                    return "[c"
                                end
                                vim.schedule(function()
                                    gitsigns.prev_hunk()
                                end)
                                return "<Ignore>"
                            end,
                            { expr = true, desc = "Prev Hunk" },
                        },
                        { "S", gitsigns.stage_buffer, { desc = "Stage Buffer" } },
                        { "U", gitsigns.reset_buffer, { desc = "Reset Buffer" } },
                        { "X", gitsigns.reset_hunk, { desc = "Reset Hunk" } }, -- show the base of the file
                        { "b", gitsigns.blame_line, { desc = "Blame" } },
                        {
                            "d",
                            gitsigns.toggle_deleted,
                            { nowait = true, desc = "Toggle Deleted" },
                        },
                        { "f", gitsigns.select_hunk, { desc = "Select Hunk" } },
                        { "p", gitsigns.preview_hunk, { desc = "Preview Hunk" } },
                        { "q", nil, { exit = true, nowait = true, desc = "Exit" } },
                        { "r", gitsigns.refresh, { desc = "Refresh" } },
                        {
                            "s",
                            ":Gitsigns stage_hunk<CR>",
                            { silent = true, desc = "Stage Hunk" },
                        },
                        { "u", gitsigns.undo_stage_hunk, { desc = "Undo Last Stage" } },
                    },
                }
            end

            local function dap_menu()
                local dap = require("dap")
                local dapui = require("dapui")
                local dap_widgets = require("dap.ui.widgets")

                local hint = [[
 _t_: Toggle Breakpoint             _R_: Run to Cursor
 _s_: Start                         _E_: Evaluate Input
 _c_: Continue                      _C_: Conditional Breakpoint
 _b_: Step Back                     _U_: Toggle UI
 _d_: Disconnect                    _S_: Scopes
 _e_: Evaluate                      _X_: Close
 _g_: Get Session                   _i_: Step Into
 _h_: Hover Variables               _o_: Step Over
 _r_: Toggle REPL                   _u_: Step Out
 _x_: Terminate                     _p_: Pause
 ^ ^               _q_: Quit
]]

                return {
                    name = "Debug",
                    hint = hint,
                    config = {
                        color = "pink",
                        invoke_on_body = true,
                        hint = {
                            border = "rounded",
                            position = "middle-right",
                        },
                    },
                    mode = "n",
                    body = "<A-d>",
                    heads = {
                        {
                            "C",
                            function()
                                dap.set_breakpoint(vim.fn.input("[Condition] > "))
                            end,
                            desc = "Conditional Breakpoint",
                        },
                        {
                            "E",
                            function()
                                dapui.eval(vim.fn.input("[Expression] > "))
                            end,
                            desc = "Evaluate Input",
                        },
                        {
                            "R",
                            function()
                                dap.run_to_cursor()
                            end,
                            desc = "Run to Cursor",
                        },
                        {
                            "S",
                            function()
                                dap_widgets.scopes()
                            end,
                            desc = "Scopes",
                        },
                        {
                            "U",
                            function()
                                dapui.toggle()
                            end,
                            desc = "Toggle UI",
                        },
                        {
                            "X",
                            function()
                                dap.close()
                            end,
                            desc = "Quit",
                        },
                        {
                            "b",
                            function()
                                dap.step_back()
                            end,
                            desc = "Step Back",
                        },
                        {
                            "c",
                            function()
                                dap.continue()
                            end,
                            desc = "Continue",
                        },
                        {
                            "d",
                            function()
                                dap.disconnect()
                            end,
                            desc = "Disconnect",
                        },
                        {
                            "e",
                            function()
                                dapui.eval()
                            end,
                            mode = { "n", "v" },
                            desc = "Evaluate",
                        },
                        {
                            "g",
                            function()
                                dap.session()
                            end,
                            desc = "Get Session",
                        },
                        {
                            "h",
                            function()
                                dap_widgets.hover()
                            end,
                            desc = "Hover Variables",
                        },
                        {
                            "i",
                            function()
                                dap.step_into()
                            end,
                            desc = "Step Into",
                        },
                        {
                            "o",
                            function()
                                dap.step_over()
                            end,
                            desc = "Step Over",
                        },
                        {
                            "p",
                            function()
                                dap.pause.toggle()
                            end,
                            desc = "Pause",
                        },
                        {
                            "r",
                            function()
                                dap.repl.toggle()
                            end,
                            desc = "Toggle REPL",
                        },
                        {
                            "s",
                            function()
                                dap.continue()
                            end,
                            desc = "Start",
                        },
                        {
                            "t",
                            function()
                                dap.toggle_breakpoint()
                            end,
                            desc = "Toggle Breakpoint",
                        },
                        {
                            "u",
                            function()
                                dap.step_out()
                            end,
                            desc = "Step Out",
                        },
                        {
                            "x",
                            function()
                                dap.terminate()
                            end,
                            desc = "Terminate",
                        },
                        { "q", nil, { exit = true, nowait = true, desc = "Exit" } },
                    },
                }
            end

            local function lsp_menu()
                return {
                    name = "LSP Mode",
                    mode = { "n" },
                    config = {
                        color = "pink",
                        invoke_on_body = true,
                        hint = {
                            type = "window",
                            position = "bottom-right",
                            border = "rounded",
                            show_name = true,
                        },
                    },
                    hint = [[
    LSP
^
Common Actions
- _h_: Show Hover Doc
- _f_: Format Buffer
- _a_: Code Actions
- _s_: Jump to Definition
- _d_: Show Diagnostics
- _w_: Show Workspace Diagnostics
^
Help
- _e_: Show Declarations
- _D_: Show Type Definition
- _j_: Show Sig Help
- _o_: Show Implementation
- _r_: Show References
^
_;_/_q_/_<Esc>_: Exit Hydra
]],
                    body = "<A-l>",
                    heads = {
                        {
                            "s",
                            vim.lsp.buf.definition,
                            { desc = "Jump to Definition", silent = true },
                        },
                        {
                            "h",
                            vim.lsp.buf.hover,
                            { desc = "Show Hover Doc", silent = true },
                        },
                        {
                            "o",
                            vim.lsp.buf.implementation,
                            { desc = "Show Implementations", silent = true },
                        },
                        {
                            "j",
                            vim.lsp.buf.signature_help,
                            { desc = "Show Sig Help", silent = true },
                        },
                        {
                            "r",
                            vim.lsp.buf.references,
                            { desc = "Show References", silent = true },
                        },
                        {
                            "f",
                            function()
                                vim.lsp.buf.format({ async = true })
                            end,
                            { desc = "Format Buffer", silent = true },
                        },
                        {
                            "a",
                            vim.lsp.buf.code_action,
                            { desc = "Show Code Actions", silent = true },
                        },
                        {
                            "d",
                            vim.diagnostic.open_float,
                            { desc = "Show Diagnostics", silent = true },
                        },
                        {
                            "w",
                            vim.diagnostic.show,
                            { desc = "Show Workspace Diagnostics", silent = true },
                        },
                        {
                            "D",
                            vim.lsp.buf.definition,
                            { desc = "Show Type Definition", silent = true },
                        },
                        {
                            "e",
                            vim.lsp.buf.declaration,
                            { desc = "Show Declaration", silent = true },
                        },
                        { ";", nil, { desc = "quit", exit = true, nowait = true } },
                        { "q", nil, { desc = "quit", exit = true, nowait = true } },
                        { "<Esc>", nil, { desc = "quit", exit = true, nowait = true } },
                    },
                }
            end

            local function quick_menu()
                local cmd = require("hydra.keymap-util").cmd
                return {
                    name = "Quick Menu",
                    mode = { "n" },
                    hint = [[
                                        Quick Menu
^
_f_: Show Terminal (float)      _v_: Open Terminal (vertical)       _h_: Open Terminal (horizontal)

_q_: Open Quickfix              _l_: Open Loaction List        ^ ^
^
^ ^                                 _<Esc>_: Exit Hydra
    ]],
                    config = {
                        color = "pink",
                        invoke_on_body = true,
                        hint = {
                            type = "window",
                            position = "bottom",
                            border = "rounded",
                            show_name = true,
                        },
                    },
                    body = "<A-M>",
                    heads = {
                        {
                            "t",
                            cmd("Telescope help_tags"),
                            { desc = "Open Help Tags", silent = true },
                        },
                        {
                            "k",
                            require("telescope.builtin").keymaps,
                            { desc = "Open Neovim Keymaps", silent = true },
                        },
                        {
                            "c",
                            cmd("Telescope commands"),
                            { desc = "Open Available Telescope Commands", silent = true },
                        },
                        {
                            "m",
                            cmd("Telescope man_pages"),
                            { desc = "Opens Man Pages", silent = true },
                        },

                        {
                            "q",
                            cmd("Telescope quickfix"),
                            { desc = "Opens Quickfix", silent = true },
                        },
                        {
                            "l",
                            cmd("Telescope loclist"),
                            { desc = "Opens Location List", silent = true },
                        },

                        {
                            "f",
                            cmd("ToggleTerm direction=float"),
                            { desc = "Floating Terminal", silent = true },
                        },
                        {
                            "v",
                            cmd("ToggleTerm direction=vertical"),
                            { desc = "Vertical Terminal", silent = true },
                        },
                        {
                            "h",
                            cmd("ToggleTerm direction=horizontal"),
                            { desc = "Horizontal Terminal", silent = true },
                        },
                        { "<Esc>", nil, { desc = "quit", exit = true, nowait = true } },
                    },
                }
            end

            local function folds_menu()
                return {
                    name = "Folds",
                    mode = "n",
                    hint = [[
Folds
------

_j_: Next Fold
_k_: Previous Fold
_l_: Open All Folds
_h_: Close All Folds

_q_/_<Esc>_: Exit Hydra

]],
                    body = "<A-f>",
                    color = "pink",
                    config = {
                        invoke_on_body = true,
                        hint = {
                            border = "rounded",
                            position = "middle-right",
                        },
                    },
                    heads = {
                        { "j", "zj", { desc = "next fold" } },
                        { "k", "zk", { desc = "previous fold" } },
                        { "l", "zr", { desc = "open folds underneath" } },
                        { "h", "zm", { desc = "close folds underneath" } },
                        { "q", nil, { desc = "quit", exit = true, nowait = true } },
                        { "<Esc>", nil, { desc = "quit", exit = true, nowait = true } },
                    },
                }
            end

            local function window_menu()
                return {
                    name = "Window management",
                    config = {
                        color = "pink",
                        invoke_on_body = true,
                        hint = {
                            border = "rounded",
                            position = "bottom",
                        },
                    },
                    mode = "n",
                    hint = [[
                                      Windows

layout:      _2_: Two Columns
move:        _a_: Far Left         _;_: Far Right        _i_: Far Up        _n_: Far Down
             _t_: Split to Tab
split:       _s_: Horizontally     _v_: Vertically
resize:      _J_: Down             _K_: Up               _H_: Left            _L_: Right
             _e_: Auto Resize      _=_: Equalize         _m_: Maximize        _o_: Only
swap:        _r_: Swap             _u_: Next Window
height:      _j_: Increase         _k_: Decrease
width:       _h_: Increase         _l_: Decrease
^ ^          _d_: Close Window     _<Esc>_: Exit Hydra
    ]],
                    body = "<A-w>",
                    heads = {
                        {
                            "2",
                            "<C-W>v",
                            { desc = "layout-double-columns", nowait = true },
                        },
                        {
                            ";",
                            "<C-W>L",
                            { desc = "move-window-far-right", nowait = true },
                        },
                        { "=", "<C-W>=", { desc = "balance-windows", nowait = true } },
                        { "a", "<C-W>H", { desc = "move-window-far-left", nowait = true } },
                        { "d", "<C-W>c", { desc = "delete-window", nowait = true } },
                        { "e", ":AutoResize<CR>", { desc = "auto-resize", nowait = true } },
                        { "H", "<C-W>10<", { desc = "expand-window-left", nowait = true } },
                        { "i", "<C-W>K", { desc = "move-window-far-top", nowait = true } },
                        {
                            "J",
                            ":resize +10<CR>",
                            { desc = "expand-window-below", nowait = true },
                        },
                        {
                            "K",
                            ":resize  10<CR>",
                            { desc = "expand-window-up", nowait = true },
                        },
                        {
                            "L",
                            "<C-W>10>",
                            { desc = "expand-window-right", nowait = true },
                        },
                        {
                            "m",
                            ":NeoZoomToggle<CR>",
                            { desc = "maximize-window", nowait = true },
                        },
                        { "n", "<C-W>J", { desc = "move-window-far-down", nowait = true } },
                        {
                            "o",
                            ":only<CR>",
                            { desc = "close-other-windows-except-this", nowait = true },
                        },
                        { "r", "<C-W>r", { desc = "window-swap", nowait = true } },
                        { "t", "<C-W>T", { desc = "move-split-to-tab", nowait = true } },
                        { "u", "<C-W>x", { desc = "swap-window-next", nowait = true } },
                        { "v", "<C-W>v", { desc = "split-window-right", nowait = true } },
                        -- Split
                        { "s", "<C-w>s", { desc = "split horizontally", nowait = true } },
                        { "v", "<C-w>v", { desc = "split vertically", nowait = true } },
                        -- Size
                        { "j", "2<C-w>+", { desc = "increase height", nowait = true } },
                        { "k", "2<C-w>-", { desc = "decrease height", nowait = true } },
                        { "h", "5<C-w>>", { desc = "increase width", nowait = true } },
                        { "l", "5<C-w><", { desc = "decrease width", nowait = true } },
                        { "=", "<C-w>=", { desc = "equalize", nowait = true } },
                        --
                        { "<Esc>", nil, { desc = "quit", exit = true, nowait = true } },
                    },
                }
            end

            local hydra = require("hydra")

            hydra(dap_menu())
            hydra(folds_menu())
            hydra(gitsigns_menu())
            hydra(lsp_menu())
            hydra(quick_menu())
            hydra(window_menu())
        end,
    },
}
