return {
    { --[[ which-key ]]
        "folke/which-key.nvim",
        event = { "VeryLazy" },
        opts = {
            preset = "helix",
            delay = 500,
            icons = {
                mappings = false,
            },
        },
        init = function()
            local wk = require("which-key")

            wk.add({

                --------------------------------------------------------------------------------
                --  NOTE: <leader>a -> actions {{{
                --------------------------------------------------------------------------------
                { "<leader>a", group = "actions" },
                { "<leader>ak", ":WorkingDirectory<CR>", desc = "Current Working Directory" },
                { "<leader>an", ":!playerctl previous -p spotify<CR>", desc = "Spotify Prev" },
                { "<leader>ap", ":!playerctl next -p spotify<CR>", desc = "Spotify Next" },
                { "<leader>as", ":!playerctl play-pause -p spotify<CR>", desc = "Spotify Play Pause" },
                { "<leader>aw", ":SetWallpaper<CR>", desc = "Change System Background" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>b -> buffers {{{
                --------------------------------------------------------------------------------
                { "<leader>b", group = "buffers" },
                { "<leader>ba", ":bfirst<CR>", desc = "First Buffer" },
                { "<leader>bc", ":vnew<CR>", desc = "New Empty Buffer Vert" },
                { "<leader>bM", ":delm!<CR>", desc = "Delete Marks" },
                { "<leader>bn", ":bn<CR>", desc = "Next Buffer" },
                { "<leader>bp", ":bp<CR>", desc = "Prev Buffer" },
                { "<leader>br", ":e<CR>", desc = "Refresh Buffer" },
                { "<leader>bR", ":bufdo :e<CR>", desc = "Refresh Loaded Buffers" },
                { "<leader>bv", ":vnew<CR>", desc = "New Empty Buffer Vertically" },
                { "<leader>bz", ":blast<CR>", desc = "First Buffer" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>f -> files {{{
                --------------------------------------------------------------------------------
                { "<leader>f", group = "files" },
                { "<leader>fs", ":w<CR>", desc = "Save" },
                { "<leader>fS", ":wa<CR>", desc = "Save All" },
                { "<leader>fw", ":noau w<CR>", desc = "Save Without Formatting" },
                { "<leader>fW", ":noau wa<CR>", desc = "Save All Without Formatting" },
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
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>n -> neovim {{{
                --------------------------------------------------------------------------------
                { "<leader>n", group = "neovim" },
                { "<leader>nc", ":Lazy clean<CR>", desc = "Clean Packages" },
                { "<leader>nh", ":checkhealth<CR>", desc = "Check Health" },
                { "<leader>ni", ":Lazy install<CR>", desc = "Lazy Install" },
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
                    desc = "Save And Execute",
                },
                { "<leader>nm", ":ReloadModule<space>", desc = "Realod Module" },
                { "<leader>no", ":Lazy<CR>", desc = "Packages Status" },
                { "<leader>np", ":Lazy profile<CR>", desc = "Lazy Profile" },
                { "<leader>nr", ":Redir Notifications<CR>", desc = "Redir Notifications" },
                { "<leader>ns", ":Lazy sync<CR>", desc = "Lazy Sync" },
                { "<leader>nu", ":Lazy update<CR>", desc = "Lazy Update" },

                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>p -> project {{{
                --------------------------------------------------------------------------------
                { "<leader>p", group = "project", mode = { "n", "v" } },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>q -> quickfix {{{
                --------------------------------------------------------------------------------
                { "<leader>q", group = "quickfix" },

                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>r -> run {{{
                --------------------------------------------------------------------------------
                { "<leader>r", group = "run", mode = { "n", "v" } },
                { "<leader>rc", ":CompileAndRun<CR>", desc = "Compile And Run" },

                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>s -> search-and-replace {{{
                --------------------------------------------------------------------------------
                { "<leader>s", group = "search-and-replace", mode = { "n", "v" } },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>t -> toggle {{{
                --------------------------------------------------------------------------------
                { "<leader>t", group = "toggle" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>w -> windows {{{
                --------------------------------------------------------------------------------
                { "<leader>w", group = "windows" },
                { "<leader>w2", "<C-W>v", desc = "Layout Double Columns" },
                { "<leader>w<", "<C-W>H", desc = "Move Window Far Left" },
                { "<leader>w=", "<C-W>=", desc = "Balance Windows" },
                { "<leader>w>", "<C-W>L", desc = "Move Window Far Right" },
                { "<leader>wH", "<C-W>10<", desc = "Expand Window Left" },
                { "<leader>wJ", "<C-W>J", desc = "Move Window Far Down" },
                { "<leader>wK", "<C-W>K", desc = "Move Window Far Top" },
                { "<leader>wL", "<C-W>10>", desc = "Expand Window Right" },
                { "<leader>wa", ":tabnew<CR>", desc = "New Tab" },
                { "<leader>wc", ":tabclose<CR>", desc = "Close Tab" },
                { "<leader>wd", "<C-W>c", desc = "Delete Window" },
                { "<leader>we", ":AutoResize<CR>", desc = "Auto Resize" },
                { "<leader>wf", ":tabfirst<CR>", desc = "First Tab" },
                { "<leader>w-", ":-tabmove<CR>", desc = "Move Tab To Previous Position" },
                { "<leader>w+", ":+tabmove<CR>", desc = "Move Tab To Next Position" },
                { "<leader>wT", ":tablast<CR>", desc = "Last Tab" },
                { "<leader>wn", ":tabnext<CR>", desc = "Next Tab" },
                { "<leader>wo", ":only<CR>", desc = "Close Other Windows Except This" },
                { "<leader>wp", ":tabprevious<CR>", desc = "Previous Tab" },
                { "<leader>ws", "<C-W>s", desc = "Split Window Below" },
                { "<leader>wt", "<C-W>T", desc = "Move Split To Tab" },
                { "<leader>wu", "<C-W>x", desc = "Swap Window Next" },
                { "<leader>wv", "<C-W>v", desc = "Split Window Right" },
                { "<leader>ww", "<C-W>r", desc = "Window Swap" },
                -- }}}
                --------------------------------------------------------------------------------

                { "<leader>e", group = "errors" },
                { "<leader>g", group = "git" },
                { "<leader>gc", group = "commit" },
                { "<leader>gd", group = "diff" },
                { "<leader>gj", group = "git-jump" },
                { "<leader>gjd", ":Jump diff<cr>", desc = "Diff" },
                { "<leader>gjm", ":Jump merge<cr>", desc = "Merge" },
                { "<leader>gjs", ":Jump grep<space>", desc = "Grep" },
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
