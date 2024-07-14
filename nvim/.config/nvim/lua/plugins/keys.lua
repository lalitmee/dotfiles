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

            wk.add({
                { "<leader>:", ":Telescope commands<CR>", "commands" },
                { "<leader><leader>", ":Telescope find_files<CR>", "find-files" },
                { "<leader>/", ":Telescope live_grep<CR>", "search-project" },

                { "<leader>a", group = "actions" },
                { "<leader>aa", ":FzfLua<space>", "fzf-lua-builtin" },
                { "<leader>ac", ":ColorizerToggle<CR>", "toggle-colorizer" },
                { "<leader>ak", ":WorkingDirectory<CR>", "current-working-directory" },
                { "<leader>an", ":!playerctl previous -p spotify<CR>", "spotify-prev" },
                { "<leader>ap", ":!playerctl next -p spotify<CR>", "spotify-next" },
                { "<leader>aq", ":Telescope macros<CR>", "macros" },
                { "<leader>as", ":!playerctl play-pause -p spotify<CR>", "spotify-play-pause" },
                { "<leader>aw", ":SetWallpaper<CR>", "change-system-background" },

                { "<leader>b", group = "buffers" },
                { "<leader>ba", ":bfirst<CR>", "first-buffer" },
                { "<leader>bb", ":Telescope buffers<CR>", "telescope-buffers" },
                { "<leader>bB", ":FzfLua buffers<CR>", "fzf-buffers" },
                { "<leader>bc", ":vnew<CR>", "new-empty-buffer-vert" },
                { "<leader>bd", ":Bdelete<CR>", "delete-buffer" },
                { "<leader>bD", ":Bdelete!<CR>", "delete-buffer-without-prompt" },
                { "<leader>bl", ":Telescope current_buffer_fuzzy_find<CR>", "telescope-buffer-lines" },
                { "<leader>bL", ":FzfLua blines<CR>", "fzf-buffer-lines" },
                { "<leader>bM", ":delm!<CR>", "delete-marks" },
                { "<leader>bn", ":bn<CR>", "next-buffer" },
                { "<leader>bo", ":BufOnly<CR>", "close-all-but-current" },
                { "<leader>bp", ":bp<CR>", "prev-buffer" },
                { "<leader>br", ":e<CR>", "refresh-buffer" },
                { "<leader>bR", ":bufdo :e<CR>", "refresh-loaded-buffers" },
                { "<leader>bv", ":vnew<CR>", "new-empty-buffer-vertically" },
                { "<leader>bw", ":Bwipeout<CR>", "close-buffer-and-window" },
                { "<leader>bz", ":blast<CR>", "first-buffer" },

                { "<leader>e", group = "+errors" },
                {
                    "<leader>ed",
                    function()
                        vim.diagnostic.disable()
                        vim.notify("LSP diagnostics disabled", vim.log.levels.INFO)
                    end,
                    "disable-diagnostic",
                },
                {
                    "<leader>ee",
                    function()
                        vim.diagnostic.enable()
                        vim.notify("LSP diagnostics enabled", vim.log.levels.INFO)
                    end,
                    "enable-diagnostic",
                },
                { "<leader>el", ":Telescope diagnostics<CR>", "workspace-diagnostics" },
                {
                    "<leader>en",
                    function()
                        vim.diagnostic.goto_next({
                            severity = lk.get_highest_error_severity(),
                            wrap = true,
                            float = true,
                        })
                    end,
                    "next-diagnostics",
                },
                {
                    "<leader>ep",
                    function()
                        vim.diagnostic.goto_prev({
                            severity = lk.get_highest_error_severity(),
                            wrap = true,
                            float = true,
                        })
                    end,
                    "prev-diagnostics",
                },
                { "<leader>eq", ":LspDiagnostics<CR>", "quickfix-diagnostics" },
                {
                    "<leader>ev",
                    function()
                        vim.diagnostic.open_float({ scope = "line" })
                    end,
                    "diagnostic-float-preview",
                },

                { "<leader>f", group = "+files" },
                { "<leader>fc", ":TelescopeEditDotfiles<CR>", "dotfiles" },
                { "<leader>fd", ":Telescope find_files theme=dropdown<CR>", "with-dropdown" },
                { "<leader>fe", ":TelescopeEditNeovim<CR>", "neovim-config" },
                { "<leader>ff", ":Telescope find_files<CR>", "files" },
                { "<leader>fF", ":FzfLua files<CR>", "files" },
                { "<leader>fg", ":Telescope git_files<CR>", "git-files" },
                { "<leader>fi", ":Telescope find_files theme=ivy<CR>", "ivy-theme-files" },
                { "<leader>fo", ":Telescope oldfiles<CR>", "old-files" },
                { "<leader>fs", ":w<CR>", "save-buffer" },
                { "<leader>fS", ":wa<CR>", "save-all-buffers" },
                { "<leader>ft", ":Telescope filetypes<CR>", "file-types" },
                { "<leader>fw", ":noau w<CR>", "save-buffer-no-format" },
                { "<leader>fq", ":wq<CR>", "save-and-quit" },

                { "<leader>g", group = "+git" },
                { "<leader>g/", ":Telescope git_status<CR>", "git-status" },
                { "<leader>gb", ":Telescope git_branches<CR>", "checkout" },

                { "<leader>gc", group = "+commit" },
                { "<leader>gcc", ":Telescope git_commits<CR>", "git-commits" },
                { "<leader>gcb", ":Telescope git_bcommits<CR>", "git-buffer-commits" },

                { "<leader>gd", group = "+diff" },
                { "<leader>gdc", ":DiffviewClose<CR>", "diffview-close" },
                { "<leader>gdd", ":Gitsigns diffthis<CR>", "diffthis" },
                { "<leader>gdf", ":DiffviewFileHistory %<CR>", "current-file-history" },
                { "<leader>gdF", ":DiffviewFileHistory<CR>", "diffview-file-history" },
                { "<leader>gdo", ":DiffviewOpen<CR>", "diffview-open" },
                { "<leader>gdw", ":Gitsigns toggle_word_diff<CR>", "toggle-word-diff" },

                { "<leader>gj", group = "+git-jump" },
                { "<leader>gjd", ":Jump diff<cr>", "diff" },
                { "<leader>gjm", ":Jump merge<cr>", "merge" },
                { "<leader>gjs", ":Jump grep<space>", "grep" },

                { "<leader>gm", ":Gitsigns blame_line<CR>", "blame-line" },
                { "<leader>gn", ":GitHunks<CR>", "git-hunks" },
                {
                    "<leader>gO",
                    function()
                        vim.cmd([[silent !gh repo view --web]])
                    end,
                    "open-repo",
                },
                { "<leader>gz", ":Telescope git_stash<CR>", "git-stash" },

                { "<leader>i", group = "+insert-text" },
                { "<leader>ic", ":Colortils<CR>", "color-picker" },
                { "<leader>id", ":DeleteDebugPrints<CR>", "delete-debug-prints" },
                { "<leader>ie", ":LuaSnipEdit<CR>", "edit-snippets" },
                { "<leader>is", ":Telescope spell_suggest<CR>", "spell_suggest" },

                -- stylua: ignore
            {"<leader>l" , group = "+lsp"},
                { "<leader>l/", ":Telescope tags<CR>", "project-tags" },
                {
                    "<leader>la",
                    function()
                        vim.lsp.buf.code_action()
                    end,
                    "code-action",
                },
                {
                    "<leader>ld",
                    function()
                        vim.lsp.buf.definition()
                    end,
                    "definition",
                },
                {
                    "<leader>lD",
                    function()
                        vim.lsp.buf.declaration()
                    end,
                    "declaration",
                },
                {
                    "<leader>lh",
                    function()
                        vim.lsp.buf.hover()
                    end,
                    "hover-doc",
                },
                { "<leader>li", ":LspInfo<CR>", "lsp-info" },
                {
                    "<leader>lI",
                    function()
                        vim.lsp.buf.implementation()
                    end,
                    "implementation",
                },
                {
                    "<leader>ll",
                    function()
                        vim.cmd("edit " .. vim.lsp.get_log_path())
                    end,
                    "lsp-log",
                },
                { "<leader>lm", ":Mason<CR>", "lsp-installer-info" },
                {
                    "<leader>lr",
                    function()
                        vim.lsp.buf.rename()
                    end,
                    "rename",
                },
                {
                    "<leader>lR",
                    function()
                        vim.lsp.buf.references()
                    end,
                    "references",
                },
                {
                    "<leader>ls",
                    function()
                        vim.lsp.buf.document_symbol()
                    end,
                    "document-symbols",
                },
                {
                    "<leader>lt",
                    function()
                        vim.lsp.buf.type_definition()
                    end,
                    "type-definition",
                },
                { "<leader>lT", ":Telescope treesitter<CR>", "treesitter-symbols" },
                {
                    "<leader>lw",
                    function()
                        vim.lsp.buf.workspace_symbol()
                    end,
                    "workspace-symbols",
                },

                { "<leader>n", group = "+neovim" },
                { "<leader>n/", ":TelescopeNotifyHistory<CR>", "notify-history" },
                { "<leader>nc", ":Lazy clean<CR>", "clean-packages" },
                { "<leader>nd", ":NotifyDismiss<CR>", "notify-dismiss" },
                { "<leader>nh", ":checkhealth<CR>", "check-health" },
                { "<leader>ni", ":Lazy install<CR>", "lazy-install" },
                {
                    "<leader>nl",
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
                { "<leader>nm", ":ReloadModule<space>", "realod-module" },
                { "<leader>nn", ":Notifications<CR>", "notifications" },
                { "<leader>no", ":Lazy<CR>", "packages-status" },
                { "<leader>np", ":Lazy profile<CR>", "lazy-profile" },
                { "<leader>nr", ":Redir Notifications<CR>", "redir-notifications" },
                { "<leader>ns", ":Lazy sync<CR>", "lazy-sync" },
                { "<leader>nt", ":ReloadConfigTelescope<CR>", "realod-modules" },
                { "<leader>nu", ":Lazy update<CR>", "lazy-update" },
                { "<leader>nx", ":Telescope reloader<CR>", "reloaders" },

                { "<leader>o", group = "+org-mode" },

                { "<leader>p", group = "+project" },

                { "<leader>q", group = "+quickfix" },
                { "<leader>qt", ":Telescope quickfix<CR>", "telescope-quickfix" },

                { "<leader>r", group = "+build-and-run" },
                { "<leader>rc", ":CompileAndRun<CR>", "compile-and-run" },

                { "<leader>s", group = "+search-and-replace" },
                { "<leader>sa", ":TelescopeFuzzyLiveGrep<CR>", "fuzzy-live-grep" },
                { "<leader>sr", ":Telescope resume<CR>", "live-grep-resume" },

                { "<leader>t", group = "+toggle" },

                { "<leader>v", group = "+vim" },
                { "<leader>v/", ":Telescope search_history<CR>", "search-history" },
                { "<leader>v:", ":Telescope commands<CR>", "commands" },
                { "<leader>va", ":Telescope autocommands<CR>", "autocommands" },
                { "<leader>vc", ":Telescope colorscheme<CR>", "colorschemes" },
                { "<leader>vC", ":Telescope command_history<CR>", "command-history" },
                { "<leader>vd", ":Messages<CR>", "messages" },
                { "<leader>vf", ":Telescope filetypes<CR>", "filetypes" },
                { "<leader>vg", ":Telescope helpgrep<CR>", "help-grep" },
                { "<leader>vh", ":Telescope help_tags<CR>", "help-tags" },
                { "<leader>vH", ":Telescope highlights<CR>", "highlights" },
                { "<leader>vj", ":Telescope jumplist<CR>", "jumplist" },
                { "<leader>vk", ":Telescope keymaps<CR>", "keymaps" },
                { "<leader>vl", ":Telescope loclist<CR>", "loclist" },
                { "<leader>vm", ":Telescope marks<CR>", "marks" },
                { "<leader>vM", ":Telescope man_pages<CR>", "man-pages" },
                { "<leader>vr", ":Telescope registers<CR>", "vim-registers" },
                { "<leader>vt", ":Telescope tagstack<CR>", "tag-stack" },
                { "<leader>vv", ":Telescope vim_options<CR>", "vim-options" },

                { "<leader>w", group = "+windows" },
                { "<leader>w2", "<C-W>v", "layout-double-columns" },
                { "<leader>w<", "<C-W>H", "move-window-far-left" },
                { "<leader>w=", "<C-W>=", "balance-windows" },
                { "<leader>w>", "<C-W>L", "move-window-far-right" },
                { "<leader>wH", "<C-W>10<", "expand-window-left" },
                { "<leader>wJ", "<C-W>J", "move-window-far-down" },
                { "<leader>wK", "<C-W>K", "move-window-far-top" },
                { "<leader>wL", "<C-W>10>", "expand-window-right" },
                { "<leader>wa", ":tabnew<CR>", "new-tab" },
                { "<leader>wc", ":tabclose<CR>", "close-tab" },
                { "<leader>wd", "<C-W>c", "delete-window" },
                { "<leader>we", ":AutoResize<CR>", "auto-resize" },
                { "<leader>wf", ":tabfirst<CR>", "first-tab" },
                { "<leader>w-", ":-tabmove<CR>", "move-tab-to-previous-position" },
                { "<leader>w+", ":+tabmove<CR>", "move-tab-to-next-position" },
                { "<leader>wT", ":tablast<CR>", "last-tab" },
                { "<leader>wm", ":NeoZoomToggle<CR>", "maximize-window" },
                { "<leader>wn", ":tabnext<CR>", "next-tab" },
                { "<leader>wo", ":only<CR>", "close-other-windows-except-this" },
                { "<leader>wp", ":tabprevious<CR>", "previous-tab" },
                { "<leader>ws", "<C-W>s", "split-window-below" },
                { "<leader>wt", "<C-W>T", "move-split-to-tab" },
                { "<leader>wu", "<C-W>x", "swap-window-next" },
                { "<leader>wv", "<C-W>v", "split-window-right" },
                { "<leader>ww", "<C-W>r", "window-swap" },
            })
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
