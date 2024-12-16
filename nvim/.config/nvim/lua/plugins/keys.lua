return {
    { --[[ which-key ]]
        "folke/which-key.nvim",
        -- version = "v2.1.0",
        event = { "VeryLazy" },
        opts = {},
        init = function()
            local wk = require("which-key")

            wk.add({
                { "<leader>:", ":Telescope commands<CR>", desc = "Commands" },
                { "<leader><leader>", ":Telescope find_files<CR>", desc = "find-files" },
                { "<leader>/", ":Telescope live_grep<CR>", desc = "search-project" },

                --------------------------------------------------------------------------------
                --  NOTE: <leader>a -> actions {{{
                --------------------------------------------------------------------------------
                { "<leader>a", group = "actions" },
                { "<leader>aa", ":FzfLua<space>", desc = "fzf-lua-builtin" },
                { "<leader>ac", ":ColorizerToggle<CR>", desc = "toggle-colorizer" },
                { "<leader>ak", ":WorkingDirectory<CR>", desc = "current-working-directory" },
                { "<leader>an", ":!playerctl previous -p spotify<CR>", desc = "spotify-prev" },
                { "<leader>ap", ":!playerctl next -p spotify<CR>", desc = "spotify-next" },
                { "<leader>aq", ":Telescope macros<CR>", desc = "macros" },
                { "<leader>as", ":!playerctl play-pause -p spotify<CR>", desc = "spotify-play-pause" },
                { "<leader>aw", ":SetWallpaper<CR>", desc = "change-system-background" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>b -> buffers {{{
                --------------------------------------------------------------------------------
                { "<leader>b", group = "buffers" },
                { "<leader>ba", ":bfirst<CR>", desc = "first-buffer" },
                { "<leader>bb", ":Telescope buffers<CR>", desc = "telescope-buffers" },
                { "<leader>bB", ":FzfLua buffers<CR>", desc = "fzf-buffers" },
                { "<leader>bc", ":vnew<CR>", desc = "new-empty-buffer-vert" },
                { "<leader>bl", ":Telescope current_buffer_fuzzy_find<CR>", desc = "telescope-buffer-lines" },
                { "<leader>bL", ":FzfLua blines<CR>", desc = "fzf-buffer-lines" },
                { "<leader>bM", ":delm!<CR>", desc = "delete-marks" },
                { "<leader>bn", ":bn<CR>", desc = "next-buffer" },
                { "<leader>bp", ":bp<CR>", desc = "prev-buffer" },
                { "<leader>br", ":e<CR>", desc = "refresh-buffer" },
                { "<leader>bR", ":bufdo :e<CR>", desc = "refresh-loaded-buffers" },
                { "<leader>bv", ":vnew<CR>", desc = "new-empty-buffer-vertically" },
                { "<leader>bz", ":blast<CR>", desc = "first-buffer" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>c -> cody {{{
                --------------------------------------------------------------------------------
                { "<leader>c", group = "cody" },
                -- }}}
                ------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>d -> doc {{{
                --------------------------------------------------------------------------------
                { "<leader>d", group = "doc" },
                -- }}}
                ------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>e -> errors {{{
                --------------------------------------------------------------------------------
                { "<leader>e", group = "errors" },
                {
                    "<leader>ed",
                    function()
                        vim.diagnostic.enable(false)
                        vim.notify("LSP diagnostics disabled", vim.log.levels.INFO)
                    end,
                    desc = "disable-diagnostic",
                },
                {
                    "<leader>ee",
                    function()
                        vim.diagnostic.enable()
                        vim.notify("LSP diagnostics enabled", vim.log.levels.INFO)
                    end,
                    desc = "enable-diagnostic",
                },
                { "<leader>el", ":Telescope diagnostics<CR>", desc = "workspace-diagnostics" },
                {
                    "<leader>en",
                    function()
                        vim.diagnostic.jump({
                            count = 1,
                            severity = lk.get_highest_error_severity(),
                            wrap = true,
                            float = true,
                        })
                    end,
                    desc = "next-diagnostics",
                },
                {
                    "<leader>ep",
                    function()
                        vim.diagnostic.jump({
                            count = -1,
                            severity = lk.get_highest_error_severity(),
                            wrap = true,
                            float = true,
                        })
                    end,
                    desc = "prev-diagnostics",
                },
                { "<leader>eq", ":LspDiagnostics<CR>", desc = "quickfix-diagnostics" },
                {
                    "<leader>ev",
                    function()
                        vim.diagnostic.open_float({ scope = "line" })
                    end,
                    desc = "diagnostic-float-preview",
                },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>f -> files {{{
                --------------------------------------------------------------------------------
                { "<leader>f", group = "files" },
                { "<leader>fc", ":Telescope find_files theme=dropdown<CR>", desc = "with-dropdown" },
                { "<leader>fd", ":TelescopeEditDotfiles<CR>", desc = "dotfiles" },
                { "<leader>ff", ":TelescopeProjectFiles<CR>", desc = "files" },
                { "<leader>fF", ":FzfLua files<CR>", desc = "files" },
                { "<leader>fg", ":Telescope git_files<CR>", desc = "git-files" },
                { "<leader>fi", ":Telescope find_files theme=ivy<CR>", desc = "ivy-theme-files" },
                { "<leader>fo", ":Telescope oldfiles<CR>", desc = "old-files" },
                { "<leader>fs", ":w<CR>", desc = "save-buffer" },
                { "<leader>fS", ":wa<CR>", desc = "save-all-buffers" },
                { "<leader>ft", ":Telescope filetypes<CR>", desc = "file-types" },
                { "<leader>fw", ":noau w<CR>", desc = "save-buffer-no-format" },
                { "<leader>fq", ":wq<CR>", desc = "save-and-quit" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>F -> fzf {{{
                --------------------------------------------------------------------------------
                { "<leader>F", group = "fzf" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>g -> git {{{
                --------------------------------------------------------------------------------
                { "<leader>g", group = "git" },
                { "<leader>g/", ":Telescope git_status<CR>", desc = "git-status" },
                { "<leader>gb", ":Telescope git_branches<CR>", desc = "checkout" },

                { "<leader>gc", group = "commit" },
                { "<leader>gcc", ":Telescope git_commits<CR>", desc = "git-commits" },
                { "<leader>gcb", ":Telescope git_bcommits<CR>", desc = "git-buffer-commits" },

                { "<leader>gd", group = "diff" },
                { "<leader>gdc", ":DiffviewClose<CR>", desc = "diffview-close" },
                { "<leader>gdd", ":Gitsigns diffthis<CR>", desc = "diffthis" },
                { "<leader>gdf", ":DiffviewFileHistory %<CR>", desc = "current-file-history" },
                { "<leader>gdF", ":DiffviewFileHistory<CR>", desc = "diffview-file-history" },
                { "<leader>gdo", ":DiffviewOpen<CR>", desc = "diffview-open" },
                { "<leader>gdw", ":Gitsigns toggle_word_diff<CR>", desc = "toggle-word-diff" },

                { "<leader>gj", group = "git-jump" },
                { "<leader>gjd", ":Jump diff<cr>", desc = "diff" },
                { "<leader>gjm", ":Jump merge<cr>", desc = "merge" },
                { "<leader>gjs", ":Jump grep<space>", desc = "grep" },

                { "<leader>gm", ":Gitsigns blame_line<CR>", desc = "blame-line" },
                { "<leader>gn", ":GitHunks<CR>", desc = "git-hunks" },
                {
                    "<leader>gO",
                    function()
                        vim.cmd([[silent !gh repo view --web]])
                    end,
                    desc = "open-repo",
                },
                { "<leader>gz", ":Telescope git_stash<CR>", desc = "git-stash" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>h -> help {{{
                --------------------------------------------------------------------------------
                { "<leader>h", group = "help" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>i -> insert {{{
                --------------------------------------------------------------------------------
                { "<leader>i", group = "insert" },
                { "<leader>ic", ":Colortils<CR>", desc = "color-picker" },
                { "<leader>id", ":DeleteDebugPrints<CR>", desc = "delete-debug-prints" },
                { "<leader>ie", ":LuaSnipEdit<CR>", desc = "edit-snippets" },
                { "<leader>is", ":Telescope spell_suggest<CR>", desc = "spell_suggest" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>j -> jump {{{
                --------------------------------------------------------------------------------
                { "<leader>j", group = "jump" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>k -> scratch {{{
                --------------------------------------------------------------------------------
                { "<leader>k", group = "scratch" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>l -> lsp {{{
                --------------------------------------------------------------------------------
                { "<leader>l", group = "lsp" },
                { "<leader>l/", ":Telescope tags<CR>", desc = "project-tags" },
                {
                    "<leader>la",
                    function()
                        vim.lsp.buf.code_action()
                    end,
                    desc = "code-action",
                },
                {
                    "<leader>ld",
                    function()
                        vim.lsp.buf.definition()
                    end,
                    desc = "definition",
                },
                {
                    "<leader>lD",
                    function()
                        vim.lsp.buf.declaration()
                    end,
                    desc = "declaration",
                },
                {
                    "<leader>lh",
                    function()
                        vim.lsp.buf.hover()
                    end,
                    desc = "hover-doc",
                },
                { "<leader>li", ":LspInfo<CR>", desc = "lsp-info" },
                {
                    "<leader>lI",
                    function()
                        vim.lsp.buf.implementation()
                    end,
                    desc = "implementation",
                },
                {
                    "<leader>ll",
                    function()
                        vim.cmd("edit " .. vim.lsp.get_log_path())
                    end,
                    desc = "lsp-log",
                },
                { "<leader>lm", ":Mason<CR>", desc = "lsp-installer-info" },
                {
                    "<leader>lr",
                    function()
                        vim.lsp.buf.rename()
                    end,
                    desc = "rename",
                },
                {
                    "<leader>lR",
                    function()
                        vim.lsp.buf.references()
                    end,
                    desc = "references",
                },
                {
                    "<leader>ls",
                    function()
                        vim.lsp.buf.document_symbol()
                    end,
                    desc = "document-symbols",
                },
                {
                    "<leader>lt",
                    function()
                        vim.lsp.buf.type_definition()
                    end,
                    desc = "type-definition",
                },
                { "<leader>lT", ":Telescope treesitter<CR>", desc = "treesitter-symbols" },
                {
                    "<leader>lw",
                    function()
                        vim.lsp.buf.workspace_symbol()
                    end,
                    desc = "workspace-symbols",
                },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>n -> neovim {{{
                --------------------------------------------------------------------------------

                { "<leader>n", group = "neovim" },
                { "<leader>nc", ":Lazy clean<CR>", desc = "clean-packages" },
                { "<leader>ne", ":TelescopeEditNeovim<CR>", desc = "edit-neovim-config" },
                { "<leader>nh", ":checkhealth<CR>", desc = "check-health" },
                { "<leader>ni", ":Lazy install<CR>", desc = "lazy-install" },
                {
                    "<leader>nl",
                    function()
                        local filetype = vim.bo.filetype
                        local filepath = vim.fn.expand("%")
                        if filetype == "lua" then
                            vim.cmd([[ silent! write luafile % ]])
                        elseif filetype == "vim" then
                            vim.cmd([[ silent! write source % ]])
                        else
                            vim.cmd([[ silent! write ]])
                        end
                        vim.notify(filepath, 2, { title = " Save and Execute" })
                    end,
                    desc = "save-and-execute",
                },
                { "<leader>nm", ":ReloadModule<space>", desc = "realod-module" },
                { "<leader>nn", ":Notifications<CR>", desc = "notifications" },
                { "<leader>no", ":Lazy<CR>", desc = "packages-status" },
                { "<leader>np", ":Lazy profile<CR>", desc = "lazy-profile" },
                { "<leader>nr", ":Redir Notifications<CR>", desc = "redir-notifications" },
                { "<leader>ns", ":Lazy sync<CR>", desc = "lazy-sync" },
                { "<leader>nt", ":ReloadConfigTelescope<CR>", desc = "realod-modules" },
                { "<leader>nu", ":Lazy update<CR>", desc = "lazy-update" },
                { "<leader>nx", ":Telescope reloader<CR>", desc = "reloaders" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>o -> org {{{
                --------------------------------------------------------------------------------
                { "<leader>o", group = "org-mode" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>p -> project {{{
                --------------------------------------------------------------------------------
                { "<leader>p", group = "project" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>q -> quickfix {{{
                --------------------------------------------------------------------------------
                { "<leader>q", group = "quickfix" },
                { "<leader>qt", ":Telescope quickfix<CR>", desc = "telescope-quickfix" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>r -> run {{{
                --------------------------------------------------------------------------------
                { "<leader>r", group = "run" },
                { "<leader>rc", ":CompileAndRun<CR>", desc = "compile-and-run" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>s -> search-and-replace {{{
                --------------------------------------------------------------------------------
                { "<leader>s", group = "search-and-replace" },
                { "<leader>sa", ":TelescopeFuzzyLiveGrep<CR>", desc = "fuzzy-live-grep" },
                { "<leader>sr", ":Telescope resume<CR>", desc = "live-grep-resume" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>t -> toggle {{{
                --------------------------------------------------------------------------------
                { "<leader>t", group = "toggle" },
                { "<leader>tm", ":RenderMarkdown toggle<CR>", desc = "render-markdown-toggle" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>v -> vim {{{
                --------------------------------------------------------------------------------
                { "<leader>v", group = "vim" },
                { "<leader>v/", ":Telescope search_history<CR>", desc = "search-history" },
                { "<leader>v:", ":Telescope commands<CR>", desc = "commands" },
                { "<leader>va", ":Telescope autocommands<CR>", desc = "autocommands" },
                { "<leader>vc", ":Telescope colorscheme<CR>", desc = "colorschemes" },
                { "<leader>vC", ":Telescope command_history<CR>", desc = "command-history" },
                { "<leader>vd", ":Messages<CR>", desc = "messages" },
                { "<leader>vf", ":Telescope filetypes<CR>", desc = "filetypes" },
                { "<leader>vg", ":Telescope helpgrep<CR>", desc = "help-grep" },
                { "<leader>vh", ":Telescope help_tags<CR>", desc = "help-tags" },
                { "<leader>vH", ":Telescope highlights<CR>", desc = "highlights" },
                { "<leader>vj", ":Telescope jumplist<CR>", desc = "jumplist" },
                { "<leader>vk", ":Telescope keymaps<CR>", desc = "keymaps" },
                { "<leader>vl", ":Telescope loclist<CR>", desc = "loclist" },
                { "<leader>vm", ":Telescope marks<CR>", desc = "marks" },
                { "<leader>vM", ":Telescope man_pages<CR>", desc = "man-pages" },
                { "<leader>vr", ":Telescope registers<CR>", desc = "vim-registers" },
                { "<leader>vt", ":Telescope tagstack<CR>", desc = "tag-stack" },
                { "<leader>vv", ":Telescope vim_options<CR>", desc = "vim-options" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>w -> windows {{{
                --------------------------------------------------------------------------------
                { "<leader>w", group = "windows" },
                { "<leader>w2", "<C-W>v", desc = "layout-double-columns" },
                { "<leader>w<", "<C-W>H", desc = "move-window-far-left" },
                { "<leader>w=", "<C-W>=", desc = "balance-windows" },
                { "<leader>w>", "<C-W>L", desc = "move-window-far-right" },
                { "<leader>wH", "<C-W>10<", desc = "expand-window-left" },
                { "<leader>wJ", "<C-W>J", desc = "move-window-far-down" },
                { "<leader>wK", "<C-W>K", desc = "move-window-far-top" },
                { "<leader>wL", "<C-W>10>", desc = "expand-window-right" },
                { "<leader>wa", ":tabnew<CR>", desc = "new-tab" },
                { "<leader>wc", ":tabclose<CR>", desc = "close-tab" },
                { "<leader>wd", "<C-W>c", desc = "delete-window" },
                { "<leader>we", ":AutoResize<CR>", desc = "auto-resize" },
                { "<leader>wf", ":tabfirst<CR>", desc = "first-tab" },
                { "<leader>w-", ":-tabmove<CR>", desc = "move-tab-to-previous-position" },
                { "<leader>w+", ":+tabmove<CR>", desc = "move-tab-to-next-position" },
                { "<leader>wT", ":tablast<CR>", desc = "last-tab" },
                { "<leader>wm", ":NeoZoomToggle<CR>", desc = "maximize-window" },
                { "<leader>wn", ":tabnext<CR>", desc = "next-tab" },
                { "<leader>wo", ":only<CR>", desc = "close-other-windows-except-this" },
                { "<leader>wp", ":tabprevious<CR>", desc = "previous-tab" },
                { "<leader>ws", "<C-W>s", desc = "split-window-below" },
                { "<leader>wt", "<C-W>T", desc = "move-split-to-tab" },
                { "<leader>wu", "<C-W>x", desc = "swap-window-next" },
                { "<leader>wv", "<C-W>v", desc = "split-window-right" },
                { "<leader>ww", "<C-W>r", desc = "window-swap" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>x -> code-shots {{{
                --------------------------------------------------------------------------------
                { "<leader>x", group = "+code-shots" },
                -- }}}
                --------------------------------------------------------------------------------
            })
        end,
    },

    { --[[ hydra ]]
        enabled = false,
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

    {
        "meznaric/key-analyzer.nvim",
        cmd = "KeyAnalyzer",
        opts = {},
    },
}
