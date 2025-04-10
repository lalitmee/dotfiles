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
                { "<leader>:", ":Telescope commands<CR>", desc = "Commands" },
                { "<leader><leader>", ":Telescope find_files<CR>", desc = "Find Files" },
                { "<leader>/", ":Telescope live_grep_args<CR>", desc = "Search Project" },

                --------------------------------------------------------------------------------
                --  NOTE: <leader>a -> actions {{{
                --------------------------------------------------------------------------------
                { "<leader>a", group = "actions" },
                { "<leader>aa", ":FzfLua<space>", desc = "Fzf Lua Builtin" },
                { "<leader>ac", ":ColorizerToggle<CR>", desc = "Toggle Colorizer" },
                { "<leader>ak", ":WorkingDirectory<CR>", desc = "Current Working Directory" },
                { "<leader>an", ":!playerctl previous -p spotify<CR>", desc = "Spotify Prev" },
                { "<leader>ap", ":!playerctl next -p spotify<CR>", desc = "Spotify Next" },
                { "<leader>aq", ":Telescope macros<CR>", desc = "Macros" },
                { "<leader>as", ":!playerctl play-pause -p spotify<CR>", desc = "Spotify Play Pause" },
                { "<leader>aw", ":SetWallpaper<CR>", desc = "Change System Background" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>b -> buffers {{{
                --------------------------------------------------------------------------------
                { "<leader>b", group = "buffers" },
                { "<leader>ba", ":bfirst<CR>", desc = "First Buffer" },
                { "<leader>bb", ":Telescope buffers<CR>", desc = "Telescope Buffers" },
                { "<leader>bB", ":FzfLua buffers<CR>", desc = "Fzf Buffers" },
                { "<leader>bc", ":vnew<CR>", desc = "New Empty Buffer Vert" },
                { "<leader>bl", ":Telescope current_buffer_fuzzy_find<CR>", desc = "Telescope Buffer Lines" },
                { "<leader>bL", ":FzfLua blines<CR>", desc = "Fzf Buffer Lines" },
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
                --  NOTE: <leader>c -> code-companion {{{
                --------------------------------------------------------------------------------
                { "<leader>c", group = "code-companion", mode = { "n", "v" } },
                { "<leader>cl", group = "leetcode" },
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
                { "<leader>e", group = "errors", mode = { "n", "v" } },
                {
                    "<leader>ed",
                    function()
                        vim.diagnostic.enable(false)
                        vim.notify("LSP diagnostics disabled", vim.log.levels.INFO)
                    end,
                    desc = "Disable Diagnostic",
                },
                {
                    "<leader>ee",
                    function()
                        vim.diagnostic.enable()
                        vim.notify("LSP diagnostics enabled", vim.log.levels.INFO)
                    end,
                    desc = "Enable Diagnostic",
                },
                { "<leader>el", ":Telescope diagnostics<CR>", desc = "Workspace Diagnostics" },
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
                    desc = "Next Diagnostics",
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
                    desc = "Prev Diagnostics",
                },
                { "<leader>eq", ":LspDiagnostics<CR>", desc = "Quickfix Diagnostics" },
                {
                    "<leader>ev",
                    function()
                        vim.diagnostic.open_float({ scope = "line" })
                    end,
                    desc = "Diagnostic Float Preview",
                },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>f -> files {{{
                --------------------------------------------------------------------------------
                { "<leader>f", group = "files" },
                { "<leader>fc", ":Telescope find_files theme=dropdown<CR>", desc = "With Dropdown" },
                { "<leader>fd", ":TelescopeEditDotfiles<CR>", desc = "Dotfiles" },
                { "<leader>ff", ":TelescopeProjectFiles<CR>", desc = "Files" },
                { "<leader>fF", ":FzfLua files<CR>", desc = "Files" },
                { "<leader>fg", ":Telescope git_files<CR>", desc = "Git Files" },
                { "<leader>fi", ":Telescope find_files theme=ivy<CR>", desc = "Ivy Theme Files" },
                { "<leader>fo", ":Telescope oldfiles<CR>", desc = "Old Files" },
                { "<leader>fs", ":w<CR>", desc = "Save Buffer" },
                { "<leader>fS", ":wa<CR>", desc = "Save All Buffers" },
                { "<leader>ft", ":Telescope filetypes<CR>", desc = "File Types" },
                { "<leader>fw", ":noau w<CR>", desc = "Save Buffer No Format" },
                { "<leader>fq", ":wq<CR>", desc = "Save And Quit" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>F -> fzf {{{
                --------------------------------------------------------------------------------
                { "<leader>F", group = "fzf" },
                { "<leader>Fb", group = "buffers" },
                { "<leader>Ff", group = "files" },
                { "<leader>Fl", group = "lsp" },
                { "<leader>Fs", group = "search" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>g -> git {{{
                --------------------------------------------------------------------------------
                { "<leader>g", group = "git" },
                { "<leader>gb", ":Telescope git_branches<CR>", desc = "Checkout" },

                { "<leader>gc", group = "commit" },
                { "<leader>gcc", ":Telescope git_commits<CR>", desc = "Git Commits" },
                { "<leader>gcb", ":Telescope git_bcommits<CR>", desc = "Git Buffer Commits" },

                { "<leader>gd", group = "diff" },
                { "<leader>gdc", ":DiffviewClose<CR>", desc = "Diffview Close" },
                { "<leader>gdd", ":Gitsigns diffthis<CR>", desc = "Diffthis" },
                { "<leader>gdf", ":DiffviewFileHistory %<CR>", desc = "Current File History" },
                { "<leader>gdF", ":DiffviewFileHistory<CR>", desc = "Diffview File History" },
                { "<leader>gdo", ":DiffviewOpen<CR>", desc = "Diffview Open" },
                { "<leader>gdw", ":Gitsigns toggle_word_diff<CR>", desc = "Toggle Word Diff" },

                { "<leader>gj", group = "git-jump" },
                { "<leader>gjd", ":Jump diff<cr>", desc = "Diff" },
                { "<leader>gjm", ":Jump merge<cr>", desc = "Merge" },
                { "<leader>gjs", ":Jump grep<space>", desc = "Grep" },

                { "<leader>gm", ":Gitsigns blame_line<CR>", desc = "Blame Line" },
                { "<leader>gn", ":GitHunks<CR>", desc = "Git Hunks" },
                {
                    "<leader>gO",
                    function()
                        vim.cmd([[silent !gh repo view --web]])
                    end,
                    desc = "Open Repo",
                },

                { "<leader>gw", group = "git-worktree" },

                { "<leader>gz", ":Telescope git_stash<CR>", desc = "Git Stash" },
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
                { "<leader>ic", ":Colortils<CR>", desc = "Color Picker" },
                { "<leader>id", ":DeleteDebugPrints<CR>", desc = "Delete Debug Prints" },
                { "<leader>ie", ":LuaSnipEdit<CR>", desc = "Edit Snippets" },
                { "<leader>is", ":Telescope spell_suggest<CR>", desc = "Spell_suggest" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>j -> jump {{{
                --------------------------------------------------------------------------------
                { "<leader>j", group = "jump", mode = { "n", "v" } },
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
                { "<leader>l", group = "lsp", mode = { "n", "v" } },
                { "<leader>l/", ":Telescope tags<CR>", desc = "Project Tags" },
                {
                    "<leader>la",
                    function()
                        vim.lsp.buf.code_action()
                    end,
                    desc = "Code Action",
                },
                {
                    "<leader>ld",
                    function()
                        vim.lsp.buf.definition()
                    end,
                    desc = "Definition",
                },
                {
                    "<leader>lD",
                    function()
                        vim.lsp.buf.declaration()
                    end,
                    desc = "Declaration",
                },
                {
                    "<leader>lh",
                    function()
                        vim.lsp.buf.hover()
                    end,
                    desc = "Hover Doc",
                },
                { "<leader>li", ":LspInfo<CR>", desc = "Lsp Info" },
                {
                    "<leader>lI",
                    function()
                        vim.lsp.buf.implementation()
                    end,
                    desc = "Implementation",
                },
                {
                    "<leader>ll",
                    function()
                        vim.cmd("edit " .. vim.lsp.get_log_path())
                    end,
                    desc = "Lsp Log",
                },
                { "<leader>lm", ":Mason<CR>", desc = "Lsp Installer Info" },
                {
                    "<leader>lr",
                    function()
                        vim.lsp.buf.rename()
                    end,
                    desc = "Rename",
                },
                {
                    "<leader>lR",
                    function()
                        vim.lsp.buf.references()
                    end,
                    desc = "References",
                },
                {
                    "<leader>ls",
                    function()
                        vim.lsp.buf.document_symbol()
                    end,
                    desc = "Document Symbols",
                },
                {
                    "<leader>lt",
                    function()
                        vim.lsp.buf.type_definition()
                    end,
                    desc = "Type Definition",
                },
                { "<leader>lT", ":Telescope treesitter<CR>", desc = "Treesitter Symbols" },
                {
                    "<leader>lw",
                    function()
                        vim.lsp.buf.workspace_symbol()
                    end,
                    desc = "Workspace Symbols",
                },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>n -> neovim {{{
                --------------------------------------------------------------------------------

                { "<leader>n", group = "neovim" },
                { "<leader>nc", ":Lazy clean<CR>", desc = "Clean Packages" },
                { "<leader>ne", ":TelescopeEditNeovim<CR>", desc = "Edit Neovim Config" },
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
                { "<leader>nt", ":ReloadConfigTelescope<CR>", desc = "Realod Modules" },
                { "<leader>nu", ":Lazy update<CR>", desc = "Lazy Update" },
                { "<leader>nx", ":Telescope reloader<CR>", desc = "Reloaders" },
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
                { "<leader>p", group = "project", mode = { "n", "v" } },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>q -> quickfix {{{
                --------------------------------------------------------------------------------
                { "<leader>q", group = "quickfix" },
                { "<leader>q/", ":Telescope quickfix<CR>", desc = "Telescope Quickfix" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>r -> run {{{
                --------------------------------------------------------------------------------
                { "<leader>r", group = "run", mode = { "n", "v" } },
                { "<leader>rc", ":CompileAndRun<CR>", desc = "Compile And Run" },

                { "<leader>ro", group = "overseer" },
                { "<leader>rh", group = "http" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>s -> search-and-replace {{{
                --------------------------------------------------------------------------------
                { "<leader>s", group = "search-and-replace", mode = { "n", "v" } },
                { "<leader>sa", ":TelescopeFuzzyLiveGrep<CR>", desc = "Fuzzy Live Grep" },
                { "<leader>sr", ":Telescope resume<CR>", desc = "Live Grep Resume" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                -- NOTE: <leader>sc -> grug-far search  {{{
                --------------------------------------------------------------------------------
                { "<leader>ss", group = "grug-far-sar", mode = { "n", "v" } },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>t -> toggle {{{
                --------------------------------------------------------------------------------
                { "<leader>t", group = "toggle" },
                { "<leader>tm", ":RenderMarkdown toggle<CR>", desc = "Render Markdown Toggle" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <leader>v -> vim {{{
                --------------------------------------------------------------------------------
                { "<leader>v", group = "vim" },
                { "<leader>v/", ":Telescope search_history<CR>", desc = "Search History" },
                { "<leader>v:", ":Telescope commands<CR>", desc = "Commands" },
                { "<leader>va", ":Telescope autocommands<CR>", desc = "Autocommands" },
                { "<leader>vc", ":Telescope colorscheme<CR>", desc = "Colorschemes" },
                { "<leader>vC", ":Telescope command_history<CR>", desc = "Command History" },
                { "<leader>vd", ":Messages<CR>", desc = "Messages" },
                { "<leader>vf", ":Telescope filetypes<CR>", desc = "Filetypes" },
                { "<leader>vg", ":Telescope helpgrep<CR>", desc = "Help Grep" },
                { "<leader>vh", ":Telescope help_tags<CR>", desc = "Help Tags" },
                { "<leader>vH", ":Telescope highlights<CR>", desc = "Highlights" },
                { "<leader>vj", ":Telescope jumplist<CR>", desc = "Jumplist" },
                { "<leader>vk", ":Telescope keymaps<CR>", desc = "Keymaps" },
                { "<leader>vl", ":Telescope loclist<CR>", desc = "Loclist" },
                { "<leader>vm", ":Telescope marks<CR>", desc = "Marks" },
                { "<leader>vM", ":Telescope man_pages<CR>", desc = "Man Pages" },
                { "<leader>vr", ":Telescope registers<CR>", desc = "Vim Registers" },
                { "<leader>vt", ":Telescope tagstack<CR>", desc = "Tag Stack" },
                { "<leader>vv", ":Telescope vim_options<CR>", desc = "Vim Options" },
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
                { "<leader>wm", ":NeoZoomToggle<CR>", desc = "Maximize Window" },
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

                --------------------------------------------------------------------------------
                --  NOTE: <leader>x -> code-shots {{{
                --------------------------------------------------------------------------------
                { "<leader>x", group = "code-shots", mode = { "n", "v" } },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <localleader>a -> cody {{{
                --------------------------------------------------------------------------------
                { "<localleader>a", group = "cody", mode = { "n", "v" } },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <localleader>b -> browse {{{
                --------------------------------------------------------------------------------
                { "<localleader>b", group = "browse", mode = { "n", "x" } },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <localleader>c -> chatgpt {{{
                --------------------------------------------------------------------------------
                { "<localleader>c", group = "chatgpt", mode = { "n", "x" } },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <localleader>s -> treesitter {{{
                --------------------------------------------------------------------------------
                { "<localleader>s", group = "treesitter" },
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
