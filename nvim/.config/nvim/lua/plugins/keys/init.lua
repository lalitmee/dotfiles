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
                { "<leader>aw", ":SetWallpaper<CR>", desc = "Change System Background" },
                -- }}}
                --------------------------------------------------------------------------------

                --------------------------------------------------------------------------------
                --  NOTE: <localleader>s -> spotify {{{
                --------------------------------------------------------------------------------
                { "<localleader>s", group = "spotify" },
                { "<localleader>sp", function() require("core.spotify").previous() end, desc = "Spotify Previous" },
                { "<localleader>sn", function() require("core.spotify").next() end, desc = "Spotify Next" },
                { "<localleader>ss", function() require("core.spotify").play_pause() end, desc = "Spotify Play/Pause" },
                { "<localleader>su", function() require("core.spotify").volume_up() end, desc = "Spotify Volume Up" },
                { "<localleader>sd", function() require("core.spotify").volume_down() end, desc = "Spotify Volume Down" },
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
                { "<leader>nR", ":Redir Notifications<CR>", desc = "Redir Notifications" },
                { "<leader>nr", ":restart<CR>", desc = "Neovim Restart" },
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
        "nvimtools/hydra.nvim",
        keys = { "<leader>gh", "<A-d>" },
        config = function()
            local hydra = require("hydra")
            hydra(require("plugins.keys.hydra.git")())
            hydra(require("plugins.keys.hydra.dap")())
        end,
    },
}
