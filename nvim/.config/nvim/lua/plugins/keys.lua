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
                [":"] = { ":Telescope commands<CR>", "commands" },
                ["<leader>"] = { ":Telescope find_files<CR>", "find-files" },
                ["/"] = { ":Telescope live_grep<CR>", "search-project" },

                ["a"] = {
                    ["name"] = "+actions",
                    ["a"] = { ":FzfLua<space>", "fzf-lua-builtin" },
                    ["c"] = { ":ColorizerToggle<CR>", "toggle-colorizer" },
                    ["k"] = { ":WorkingDirectory<CR>", "current-working-directory" },
                    ["n"] = { ":!playerctl previous -p spotify<CR>", "spotify-prev" },
                    ["p"] = { ":!playerctl next -p spotify<CR>", "spotify-next" },
                    ["q"] = { ":Telescope macros<CR>", "macros" },
                    ["s"] = { ":!playerctl play-pause -p spotify<CR>", "spotify-play-pause" },
                    ["w"] = { ":SetWallpaper<CR>", "change-system-background" },
                },

                ["b"] = {
                    ["name"] = "+buffers",
                    ["a"] = { ":bfirst<CR>", "first-buffer" },
                    ["b"] = { ":Telescope buffers<CR>", "telescope-buffers" },
                    ["B"] = { ":FzfLua buffers<CR>", "fzf-buffers" },
                    ["c"] = { ":vnew<CR>", "new-empty-buffer-vert" },
                    ["d"] = { ":Bdelete<CR>", "delete-buffer" },
                    ["D"] = { ":Bdelete!<CR>", "delete-buffer-without-prompt" },
                    ["l"] = { ":Telescope current_buffer_fuzzy_find<CR>", "telescope-buffer-lines" },
                    ["L"] = { ":FzfLua blines<CR>", "fzf-buffer-lines" },
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

                ["e"] = {
                    ["name"] = "+errors",
                    ["d"] = {
                        function()
                            vim.diagnostic.disable()
                            vim.notify("LSP diagnostics disabled", vim.log.levels.INFO)
                        end,
                        "disable-diagnostic",
                    },
                    ["e"] = {
                        function()
                            vim.diagnostic.enable()
                            vim.notify("LSP diagnostics enabled", vim.log.levels.INFO)
                        end,
                        "enable-diagnostic",
                    },
                    ["l"] = { ":Telescope diagnostics<CR>", "workspace-diagnostics" },
                    ["n"] = {
                        function()
                            vim.diagnostic.goto_next({
                                severity = lk.get_highest_error_severity(),
                                wrap = true,
                                float = true,
                            })
                        end,
                        "next-diagnostics",
                    },
                    ["p"] = {
                        function()
                            vim.diagnostic.goto_prev({
                                severity = lk.get_highest_error_severity(),
                                wrap = true,
                                float = true,
                            })
                        end,
                        "prev-diagnostics",
                    },
                    ["q"] = { ":LspDiagnostics<CR>", "quickfix-diagnostics" },
                    ["v"] = {
                        function()
                            vim.diagnostic.open_float({ scope = "line" })
                        end,
                        "diagnostic-float-preview",
                    },
                },

                ["f"] = {
                    ["name"] = "+files",
                    ["c"] = { ":TelescopeEditDotfiles<CR>", "dotfiles" },
                    ["d"] = {
                        ":Telescope find_files theme=dropdown<CR>",
                        "with-dropdown",
                    },
                    ["e"] = { ":TelescopeEditNeovim<CR>", "neovim-config" },
                    ["f"] = { ":Telescope find_files<CR>", "files" },
                    ["F"] = { ":FzfLua files<CR>", "files" },
                    ["g"] = { ":Telescope git_files<CR>", "git-files" },
                    ["i"] = {
                        ":Telescope find_files theme=ivy<CR>",
                        "ivy-theme-files",
                    },
                    ["o"] = { ":Telescope oldfiles<CR>", "old-files" },
                    ["s"] = { ":w<CR>", "save-buffer" },
                    ["S"] = { ":wa<CR>", "save-all-buffers" },
                    ["t"] = { ":Telescope filetypes<CR>", "file-types" },
                    ["w"] = { ":noau w<CR>", "save-buffer-no-format" },
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
                    ["z"] = { ":Telescope git_stash<CR>", "git-stash" },
                },

                ["h"] = {
                    ["name"] = "+help",
                },

                ["i"] = {
                    ["name"] = "+insert-text",
                    ["c"] = { ":Colortils<CR>", "color-picker" },
                    ["d"] = { ":DeleteDebugPrints<CR>", "delete-debug-prints" },
                    ["e"] = { ":LuaSnipEdit<CR>", "edit-snippets" },
                    ["s"] = { ":Telescope spell_suggest<CR>", "spell_suggest" },
                },

                -- stylua: ignore
                ["l"] = {
                    ["name"] = "+lsp",
                    ["/"] = { ":Telescope tags<CR>", "project-tags" },
                    ["a"] = { function() vim.lsp.buf.code_action() end, "code-action" },
                    ["d"] = { function() vim.lsp.buf.definition() end, "definition" },
                    ["D"] = { function() vim.lsp.buf.declaration() end, "declaration" },
                    ["h"] = { function() vim.lsp.buf.hover() end, "hover-doc" },
                    ["i"] = { ":LspInfo<CR>", "lsp-info" },
                    ["I"] = { function() vim.lsp.buf.implementation() end, "implementation" },
                    ["l"] = { function()  vim.cmd("edit " .. vim.lsp.get_log_path()) end, "lsp-log" },
                    ["m"] = { ":Mason<CR>", "lsp-installer-info" },
                    ["r"] = { function() vim.lsp.buf.rename() end, "rename" },
                    ["R"] = { function() vim.lsp.buf.references() end, "references" },
                    ["s"] = { function() vim.lsp.buf.document_symbol() end, "document-symbols" },
                    ["t"] = { function() vim.lsp.buf.type_definition() end, "type-definition" },
                    ["T"] = { ":Telescope treesitter<CR>", "treesitter-symbols" },
                    ["w"] = { function() vim.lsp.buf.workspace_symbol() end, "workspace-symbols" },
                },

                ["n"] = {
                    ["name"] = "+neovim",
                    ["/"] = { ":TelescopeNotifyHistory<CR>", "notify-history" },
                    ["c"] = { ":Lazy clean<CR>", "clean-packages" },
                    ["d"] = { ":NotifyDismiss<CR>", "notify-dismiss" },
                    ["h"] = { ":checkhealth<CR>", "check-health" },
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
                    ["n"] = { ":Notifications<CR>", "notifications" },
                    ["o"] = { ":Lazy<CR>", "packages-status" },
                    ["p"] = { ":Lazy profile<CR>", "lazy-profile" },
                    ["r"] = { ":Redir Notifications<CR>", "redir-notifications" },
                    ["s"] = { ":Lazy sync<CR>", "lazy-sync" },
                    ["t"] = { ":ReloadConfigTelescope<CR>", "realod-modules" },
                    ["u"] = { ":Lazy update<CR>", "lazy-update" },
                    ["x"] = { ":Telescope reloader<CR>", "reloaders" },
                },

                ["o"] = {
                    ["name"] = "+org-mode",
                },

                ["p"] = {
                    ["name"] = "+project",
                },

                ["q"] = {
                    ["name"] = "+quickfix",
                    ["t"] = { ":Telescope quickfix<CR>", "telescope-quickfix" },
                },

                ["r"] = {
                    ["name"] = "+build-and-run",
                    ["c"] = { ":CompileAndRun<CR>", "compile-and-run" },
                },

                ["s"] = {
                    ["name"] = "+search-and-replace",
                    ["a"] = { ":TelescopeFuzzyLiveGrep<CR>", "fuzzy-live-grep" },
                    ["r"] = { ":Telescope resume<CR>", "live-grep-resume" },
                },

                ["t"] = {
                    ["name"] = "+toggle",
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
                    ["g"] = { ":Telescope helpgrep<CR>", "help-grep" },
                    ["h"] = { ":Telescope help_tags<CR>", "help-tags" },
                    ["H"] = { ":Telescope highlights<CR>", "highlights" },
                    ["j"] = { ":Telescope jumplist<CR>", "jumplist" },
                    ["k"] = { ":Telescope keymaps<CR>", "keymaps" },
                    ["l"] = { ":Telescope loclist<CR>", "loclist" },
                    ["m"] = { ":Telescope marks<CR>", "marks" },
                    ["M"] = { ":Telescope man_pages<CR>", "man-pages" },
                    ["r"] = { ":Telescope registers<CR>", "vim-registers" },
                    ["t"] = { ":Telescope tagstack<CR>", "tag-stack" },
                    ["v"] = { ":Telescope vim_options<CR>", "vim-options" },
                },

                ["w"] = {
                    ["name"] = "+windows",
                    ["2"] = { "<C-W>v", "layout-double-columns" },
                    ["<"] = { "<C-W>H", "move-window-far-left" },
                    ["="] = { "<C-W>=", "balance-windows" },
                    [">"] = { "<C-W>L", "move-window-far-right" },
                    ["H"] = { "<C-W>10<", "expand-window-left" },
                    ["J"] = { "<C-W>J", "move-window-far-down" },
                    ["K"] = { "<C-W>K", "move-window-far-top" },
                    ["L"] = { "<C-W>10>", "expand-window-right" },
                    ["a"] = { ":tabnew<CR>", "new-tab" },
                    ["c"] = { ":tabclose<CR>", "close-tab" },
                    ["d"] = { "<C-W>c", "delete-window" },
                    ["e"] = { ":AutoResize<CR>", "auto-resize" },
                    ["f"] = { ":tabfirst<CR>", "first-tab" },
                    ["-"] = { ":-tabmove<CR>", "move-tab-to-previous-position" },
                    ["+"] = { ":+tabmove<CR>", "move-tab-to-next-position" },
                    ["T"] = { ":tablast<CR>", "last-tab" },
                    ["m"] = { ":NeoZoomToggle<CR>", "maximize-window" },
                    ["n"] = { ":tabnext<CR>", "next-tab" },
                    ["o"] = { ":only<CR>", "close-other-windows-except-this" },
                    ["p"] = { ":tabprevious<CR>", "previous-tab" },
                    ["s"] = { "<C-W>s", "split-window-below" },
                    ["t"] = { "<C-W>T", "move-split-to-tab" },
                    ["u"] = { "<C-W>x", "swap-window-next" },
                    ["v"] = { "<C-W>v", "split-window-right" },
                    ["w"] = { "<C-W>r", "window-swap" },
                },

                -- x is occupied by possession
            }

            local local_leader_key_maps = {
                ["t"] = {
                    -- it is reserved for neorg keybindings
                },
            }

            wk.register(local_leader_key_maps, { prefix = "<localleader>", mode = { "n", "v" } })
            wk.register(leader_key_maps, { prefix = "<leader>", mode = { "n", "v" } })
        end,
    },

    { --[[ hydra ]]
        "anuvyklack/hydra.nvim",
        keys = { "<leader>gh" },
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
                    name = "gitsigns",
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

            --             local function dap_menu()
            --                 local dap = require("dap")
            --                 local dapui = require("dapui")
            --                 local dap_widgets = require("dap.ui.widgets")

            --                 local hint = [[
            --  _t_: Toggle Breakpoint             _R_: Run to Cursor
            --  _s_: Start                         _E_: Evaluate Input
            --  _c_: Continue                      _C_: Conditional Breakpoint
            --  _b_: Step Back                     _U_: Toggle UI
            --  _d_: Disconnect                    _S_: Scopes
            --  _e_: Evaluate                      _X_: Close
            --  _g_: Get Session                   _i_: Step Into
            --  _h_: Hover Variables               _o_: Step Over
            --  _r_: Toggle REPL                   _u_: Step Out
            --  _x_: Terminate                     _p_: Pause
            --  ^ ^               _q_: Quit
            -- ]]

            --                 return {
            --                     name = "Debug",
            --                     hint = hint,
            --                     config = {
            --                         color = "pink",
            --                         invoke_on_body = true,
            --                         hint = {
            --                             border = "rounded",
            --                             position = "middle-right",
            --                         },
            --                     },
            --                     mode = "n",
            --                     body = "<A-d>",
            --                     heads = {
            --                         {
            --                             "C",
            --                             function()
            --                                 dap.set_breakpoint(vim.fn.input("[Condition] > "))
            --                             end,
            --                             desc = "Conditional Breakpoint",
            --                         },
            --                         {
            --                             "E",
            --                             function()
            --                                 dapui.eval(vim.fn.input("[Expression] > "))
            --                             end,
            --                             desc = "Evaluate Input",
            --                         },
            --                         {
            --                             "R",
            --                             function()
            --                                 dap.run_to_cursor()
            --                             end,
            --                             desc = "Run to Cursor",
            --                         },
            --                         {
            --                             "S",
            --                             function()
            --                                 dap_widgets.scopes()
            --                             end,
            --                             desc = "Scopes",
            --                         },
            --                         {
            --                             "U",
            --                             function()
            --                                 dapui.toggle()
            --                             end,
            --                             desc = "Toggle UI",
            --                         },
            --                         {
            --                             "X",
            --                             function()
            --                                 dap.close()
            --                             end,
            --                             desc = "Quit",
            --                         },
            --                         {
            --                             "b",
            --                             function()
            --                                 dap.step_back()
            --                             end,
            --                             desc = "Step Back",
            --                         },
            --                         {
            --                             "c",
            --                             function()
            --                                 dap.continue()
            --                             end,
            --                             desc = "Continue",
            --                         },
            --                         {
            --                             "d",
            --                             function()
            --                                 dap.disconnect()
            --                             end,
            --                             desc = "Disconnect",
            --                         },
            --                         {
            --                             "e",
            --                             function()
            --                                 dapui.eval()
            --                             end,
            --                             mode = { "n", "v" },
            --                             desc = "Evaluate",
            --                         },
            --                         {
            --                             "g",
            --                             function()
            --                                 dap.session()
            --                             end,
            --                             desc = "Get Session",
            --                         },
            --                         {
            --                             "h",
            --                             function()
            --                                 dap_widgets.hover()
            --                             end,
            --                             desc = "Hover Variables",
            --                         },
            --                         {
            --                             "i",
            --                             function()
            --                                 dap.step_into()
            --                             end,
            --                             desc = "Step Into",
            --                         },
            --                         {
            --                             "o",
            --                             function()
            --                                 dap.step_over()
            --                             end,
            --                             desc = "Step Over",
            --                         },
            --                         {
            --                             "p",
            --                             function()
            --                                 dap.pause.toggle()
            --                             end,
            --                             desc = "Pause",
            --                         },
            --                         {
            --                             "r",
            --                             function()
            --                                 dap.repl.toggle()
            --                             end,
            --                             desc = "Toggle REPL",
            --                         },
            --                         {
            --                             "s",
            --                             function()
            --                                 dap.continue()
            --                             end,
            --                             desc = "Start",
            --                         },
            --                         {
            --                             "t",
            --                             function()
            --                                 dap.toggle_breakpoint()
            --                             end,
            --                             desc = "Toggle Breakpoint",
            --                         },
            --                         {
            --                             "u",
            --                             function()
            --                                 dap.step_out()
            --                             end,
            --                             desc = "Step Out",
            --                         },
            --                         {
            --                             "x",
            --                             function()
            --                                 dap.terminate()
            --                             end,
            --                             desc = "Terminate",
            --                         },
            --                         { "q", nil, { exit = true, nowait = true, desc = "Exit" } },
            --                     },
            --                 }
            --             end

            local hydra = require("hydra")

            -- hydra(dap_menu())
            hydra(gitsigns_menu())
        end,
    },
}
