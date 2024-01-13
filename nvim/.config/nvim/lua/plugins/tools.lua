local command = lk.command
local fn = vim.fn

return {
    { --[[ undotree ]]
        "mbbill/undotree",
        cmd = { "UndotreeToggle" },
        keys = {
            { "<leader>au", ":UndotreeToggle<CR>", desc = "undo-tree", silent = true },
        },
    },

    { --[[ genghis ]]
        "chrisgrieser/nvim-genghis",
        keys = {
            { "<leader>fA", ":New<cr>", desc = "create-file", silent = true },
            { "<leader>fD", ":Trash<cr>", desc = "trash-file", silent = true },
            { "<leader>fy", ":CopyFilepath<cr>", desc = "copy-file-path", silent = true },
            { "<leader>fJ", ":Move<cr>", desc = "move-and-rename-file", silent = true },
            { "<leader>fN", ":CopyFilename<cr>", desc = "copy-file-name", silent = true },
            { "<leader>fR", ":Rename<cr>", desc = "rename-file", silent = true },
            { "<leader>fS", ":Duplicate<cr>", desc = "duplicate-file", silent = true },
            { "<leader>fX", ":Chmodx<cr>", desc = "make-executable", silent = true },
            { "<leader>fS", ":NewFromSelection<cr>", desc = "move-selection-to-file", silent = true, mode = "x" },
        },
    },

    { --[[ tabular ]]
        "godlygeek/tabular",
        cmd = { "Tabularize" },
    },

    { --[[ surround ]]
        "kylechui/nvim-surround",
        keys = { "ds", "ys", "cs" },
        opts = {},
    },

    { --[[ iswap ]]
        "mizlan/iswap.nvim",
        keys = {
            { "<leader>ii", ":ISwap<CR>", desc = "iswap", silent = true },
            { "<leader>il", ":ISwapWithLeft<CR>", desc = "swap-with-left", silent = true },
            { "<leader>in", ":ISwapNode<CR>", desc = "swap-nodes", silent = true },
            { "<leader>ir", ":ISwapWithRight<CR>", desc = "swap-with-right", silent = true },
            { "<leader>iw", ":ISwapWith<CR>", desc = "swap-with", silent = true },
        },
    },

    { --[[ nap ]]
        "liangxianzhe/nap.nvim",
        keys = { "]", "[" },
        opts = {
            next_prefix = "]",
            prev_prefix = "[",
            next_repeat = "<C-n>",
            prev_repeat = "<C-p>",
            operators = {
                ["h"] = {
                    next = { rhs = "<cmd>Gitsigns next_hunk", opts = { desc = "Next hunk" } },
                    prev = { rhs = "<cmd>Gitsigns next_hunk", opts = { desc = "Previous hunk" } },
                },
                ["<Tab>"] = {
                    next = { rhs = "<cmd>tabnext<cr>", opts = { desc = "Next tab" } },
                    prev = { rhs = "<cmd>tabprevious<cr>", opts = { desc = "Previous tab" } },
                },
                ["<Space>"] = {
                    next = { rhs = [[<cmd>call append(line("."), [""])<CR>]], opts = { desc = "Empty line below" } },
                    prev = { rhs = [[<cmd>call append(line(".")-1, [""])<CR>]], opts = { desc = "Empty line above" } },
                },
                ["e"] = {
                    next = { rhs = [[<cmd>m .+1<CR>]], opts = { desc = "Move line down" } },
                    prev = { rhs = [[<cmd>m .-2<CR>]], opts = { desc = "Move line up" } },
                },
            },
        },
    },

    { --[[ toggleterm ]]
        "akinsho/toggleterm.nvim",
        keys = {
            [[<C-\>]],
            { "<leader>ab", ":Bottom<CR>", desc = "bottom", silent = true },
            { "<leader>ad", ":LazyDocker<CR>", desc = "lazydocker", silent = true },
            { "<leader>ag", ":LazyGit<CR>", desc = "lazygit", silent = true },
            { "<leader>ah", ":ToggleTerm direction=horizontal<CR>", desc = "horizontal-terminal", silent = true },
            { "<leader>ai", ":ChatGPTSh<CR>", desc = "chatgpt", silent = true },
            { "<leader>af", ":GhDash<CR>", desc = "gh-dash", silent = true },
            { "<leader>av", ":ToggleTerm direction=vertical<CR>", desc = "vertical-terminal", silent = true },
        },
        cmd = { "ToggleTerm" },
        opts = {
            open_mapping = [[<C-\>]],
            direction = "float",
            autochdir = true,
            persist_mode = true,
            insert_mappings = false,
            start_in_insert = true,
            winbar = { enabled = lk.ui.winbar.enable },
            float_opts = {
                border = lk.style.border.rounded,
                winblend = 3,
                width = 240,
                height = 50,
            },
            shade_terminals = false,
            size = function(term)
                if term.direction == "horizontal" then
                    return 20
                elseif term.direction == "vertical" then
                    return math.floor(vim.api.nvim_get_option_value("columns", { scope = "local" }) * 0.5)
                end
            end,
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)

            local float_handler = function(term)
                if not lk.falsy(fn.mapcheck("jk", "t")) then
                    vim.keymap.del("t", "jk", { buffer = term.bufnr })
                    vim.keymap.del("t", "<esc>", { buffer = term.bufnr })
                end
            end

            local Terminal = require("toggleterm.terminal").Terminal

            local float_opts = { width = 240, height = 52 }

            local chatgpt = Terminal:new({
                cmd = "chatgpt -i",
                dir = "git_dir",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_opts,
            })

            local gh_dash = Terminal:new({
                cmd = "gh dash",
                dir = "git_dir",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_opts,
            })

            local lazygit = Terminal:new({
                cmd = "lazygit",
                dir = "git_dir",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_opts,
            })

            local lazydocker = Terminal:new({
                cmd = "lazydocker",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_opts,
            })

            local bottom = Terminal:new({
                cmd = "btm",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_opts,
            })

            command("LazyDocker", function()
                lazydocker:toggle()
            end)
            command("LazyGit", function()
                lazygit:toggle()
            end)
            command("Bottom", function()
                bottom:toggle()
            end)
            command("ChatGPTSh", function()
                chatgpt:toggle()
            end)
            command("GhDash", function()
                gh_dash:toggle()
            end)
        end,
    },

    { --[[ neozoom ]]
        "nyngwang/NeoZoom.lua",
        cmd = { "NeoZoomToggle" },
        config = function()
            require("neo-zoom").setup({
                winopts = {
                    border = "rounded",
                    offset = {
                        height = 0.9,
                        width = 220,
                    },
                },
            })
        end,
    },

    { --[[ orgmode ]]
        enabled = false,
        "nvim-orgmode/orgmode",
        ft = { "org" },
        dependencies = {
            {
                "akinsho/org-bullets.nvim",
                config = true,
            },
        },
        init = function()
            require("orgmode").setup_ts_grammar()
        end,
        opts = {
            org_agenda_files = { "~/org" },
            org_default_notes_file = "~/Desktop/Github/dNotes/notes/index.org",
        },
    },

    { --[[ neorg ]]
        "nvim-neorg/neorg",
        cmd = { "Neorg" },
        ft = "norg",
        build = ":Neorg sync-parsers",
        opts = {
            load = {
                ["core.defaults"] = {},
                ["core.clipboard"] = {},
                ["core.clipboard.code-blocks"] = {},
                ["core.concealer"] = {},
                ["core.keybinds"] = {},
                ["core.integrations.telescope"] = {},
                ["core.completion"] = {
                    config = {
                        engine = "nvim-cmp",
                    },
                },
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            notes = "~/Desktop/Github/notes",
                            ["work-notes"] = "~/Documents/notes",
                        },
                    },
                },
            },
        },
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-neorg/neorg-telescope" },
        },
    },

    { --[[ project ]]
        "ahmedkhalf/project.nvim",
        keys = { "<leader>pp" },
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("project_nvim").setup({
                detection_methods = { "pattern", "lsp" },
                patterns = { ".git" },
                show_hidden = true,
                -- show the message on changing the directory
                silent_chdir = false,
                -- change to the directory of the file in the current tab
                scope_chdir = "tab",
            })
            require("telescope").load_extension("projects")
        end,
        enabled = false,
    },

    { --[[ scretch ]]
        "Sonicfury/scretch.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        -- stylua: ignore
        keys = {
            { "<localleader>sa", function() require("scretch").new() end, desc = "new-scratch" },
            { "<localleader>se", function() require("scretch").explore() end, desc = "scratch-explore" },
            { "<localleader>sf", function() require("scretch").search() end, desc = "search-scratch" },
            { "<localleader>sg", function() require("scretch").grep() end, desc = "scratch-grep" },
            { "<localleader>sl", function() require("scretch").last() end, desc = "last-scratch" },
            { "<localleader>sn", function() require("scretch").new_named() end, desc = "scratch-with-name" },
        },
        opts = {
            scretch_dir = vim.fn.stdpath("data") .. "/scretch/",
        },
    },

    { --[[ fzf-lua ]]
        "ibhagwan/fzf-lua",
        cmd = { "FzfLua" },
        keys = {
            "<C-]>",
            "gd",
            {
                "<leader>o/",
                ":FzfLua live_grep<CR>",
                desc = "fzf-live-grep",
                silent = true,
            },
            {
                "<leader>obL",
                ":FzfLua lines<CR>",
                desc = "fzf-lines",
                silent = true,
            },
            {
                "<leader>obb",
                ":FzfLua buffers<CR>",
                desc = "fzf-buffers",
                silent = true,
            },
            {
                "<leader>obl",
                ":FzfLua blines<CR>",
                desc = "fzf-buffer-lines",
                silent = true,
            },
            {
                "<leader>off",
                ":FzfLua files<CR>",
                desc = "fzf-files",
                silent = true,
            },
            {
                "<leader>ole",
                ":FzfLua lsp_document_diagnostics<CR>",
                desc = "fzf-lsp-document-diagnostics",
                silent = true,
            },
            {
                "<leader>olE",
                ":FzfLua lsp_workspace_diagnostics<CR>",
                desc = "fzf-lsp-workspace-diagnostics",
                silent = true,
            },
            {
                "<leader>oll",
                ":FzfLua lsp_finder<CR>",
                desc = "fzf-lsp-finder",
                silent = true,
            },
            {
                "<leader>olr",
                ":FzfLua lsp_references<CR>",
                desc = "fzf-lsp-references",
                silent = true,
            },
            {
                "<leader>olw",
                ":FzfLua lsp_document_symbols<CR>",
                desc = "fzf-lsp-document-symbols",
                silent = true,
            },
            {
                "<leader>olW",
                ":FzfLua lsp_workspace_symbols<CR>",
                desc = "fzf-lsp-workspace-symbols",
                silent = true,
            },
            {
                "<leader>ols",
                ":FzfLua lsp_live_workspace_symbols<CR>",
                desc = "fzf-lsp-live-workspace-symbols",
                silent = true,
            },
            {
                "<leader>osR",
                ":FzfLua live_grep_resume<CR>",
                desc = "fzf-live-grep-resume",
                silent = true,
            },
            {
                "<leader>osr",
                ":FzfLua resume<CR>",
                desc = "fzf-resume",
                silent = true,
            },
            {
                "<leader>osr",
                ":FzfLua resume<CR>",
                desc = "fzf-resume",
                silent = true,
            },
        },
        opts = {
            winopts = {
                width = 0.95,
                height = 0.95,
                preview = {
                    title_align = "center",
                    scrollbar = "border",
                },
            },
            fzf_opts = {},
            files = { git_icons = false },
            grep = {
                rg_glob = true,
                rg_opts = "--hidden --column --line-number --no-heading" .. " --color=always --smart-case -g '!.git'",
            },
            file_ignore_patterns = { "node_modules", ".git" },
        },
    },

    { --[[ navigator ]]
        "numToStr/Navigator.nvim",
        keys = {
            { "<C-h>", "<cmd>NavigatorLeft<cr>", silent = true },
            { "<C-l>", "<cmd>NavigatorRight<cr>", silent = true },
            { "<C-j>", "<cmd>NavigatorDown<cr>", silent = true },
            { "<C-k>", "<cmd>NavigatorUp<cr>", silent = true },
            { "<leader>wh", ":NavigatorLeft<CR>", desc = "window-left", silent = true },
            { "<leader>wj", ":NavigatorDown<CR>", desc = "window-down", silent = true },
            { "<leader>wk", ":NavigatorUp<CR>", desc = "window-up", silent = true },
            { "<leader>wl", ":NavigatorRight<CR>", desc = "window-right", silent = true },
            { "<leader>wp", ":NavigatorPrevious<CR>", desc = "window-previous", silent = true },
        },
        opts = {
            auto_save = "all",
        },
    },

    { --[[ harpoon ]]
        "ThePrimeagen/harpoon",
        keys = {
            -- terminal
            { "<localleader>1", ":HarpoonGotoTerm 1<CR>", "terminal-1", silent = true },
            { "<localleader>2", ":HarpoonGotoTerm 2<CR>", "terminal-2", silent = true },
            { "<localleader>3", ":HarpoonGotoTerm 3<CR>", "terminal-3", silent = true },
            { "<localleader>4", ":HarpoonGotoTerm 4<CR>", "terminal-4", silent = true },
            { "<localleader>5", ":HarpoonGotoTerm 5<CR>", "terminal-5", silent = true },

            -- file
            { "<leader>1", ":HarpoonGotoFile 1<CR>", desc = "goto-file-1", silent = true },
            { "<leader>2", ":HarpoonGotoFile 2<CR>", desc = "goto-file-2", silent = true },
            { "<leader>3", ":HarpoonGotoFile 3<CR>", desc = "goto-file-3", silent = true },
            { "<leader>4", ":HarpoonGotoFile 4<CR>", desc = "goto-file-4", silent = true },
            { "<leader>5", ":HarpoonGotoFile 5<CR>", desc = "goto-file-5", silent = true },
            { "<leader>6", ":HarpoonGotoFile 6<CR>", desc = "goto-file-6", silent = true },
            { "<leader>7", ":HarpoonGotoFile 7<CR>", desc = "goto-file-7", silent = true },
            { "<leader>8", ":HarpoonGotoFile 8<CR>", desc = "goto-file-8", silent = true },
            { "<leader>9", ":HarpoonGotoFile 9<CR>", desc = "goto-file-9", silent = true },

            {
                "<leader>fa",
                function()
                    require("harpoon.mark").add_file()
                end,
                desc = "add-file",
                silent = true,
            },
            {
                "<leader>fm",
                function()
                    require("harpoon.ui").toggle_quick_menu()
                end,
                desc = "toggle-harpoon",
                silent = true,
            },
            {
                "<leader>fn",
                function()
                    require("harpoon.ui").nav_next()
                end,
                desc = "next-mark",
                silent = true,
            },
            {
                "<leader>fp",
                function()
                    require("harpoon.ui").nav_prev()
                end,
                desc = "prev-mark",
                silent = true,
            },
            {
                "<leader>fr",
                function()
                    require("harpoon.mark").rm_file()
                end,
                desc = "remove-file",
                silent = true,
            },
            {
                "<leader>aj",
                function()
                    require("harpoon.cmd-ui").toggle_quick_menu()
                end,
                desc = "toggle-harpoon-cmd-menu",
                silent = true,
            },

            -- { "<leader>fM", ":Telescope harpoon marks<CR>", desc = "telescope-harpoon", silent = true },
        },
        init = function()
            -- NOTE: slowing the startup time
            -- require("telescope").load_extension("harpoon")

            command("HarpoonGotoFile", function(args)
                local number = tonumber(args["args"])
                require("harpoon.ui").nav_file(number)
            end, {
                nargs = 1,
            })

            command("HarpoonGotoTerm", function(args)
                local number = tonumber(args["args"])
                require("harpoon.term").gotoTerminal(number)
            end, {
                nargs = 1,
            })

            command("HarpoonSendCmdToTerm", function(args)
                local argsString = args["args"]
                local numberAndCmd = vim.split(argsString, " ")
                local number = tonumber(numberAndCmd[1])
                local cmd = numberAndCmd[2]
                require("harpoon.term").sendCommand(number, cmd)
            end, {
                nargs = 1,
            })

            command("HarpoonGotoTmux", function(args)
                local number = tonumber(args["args"])
                require("harpoon.tmux").gotoTerminal(number)
            end, {
                nargs = 1,
            })

            command("HarpoonSendCmdToTmux", function(args)
                local argsString = args["args"]
                local numberAndCmd = vim.split(argsString, " ")
                local number = tonumber(numberAndCmd[1])
                local cmd = numberAndCmd[2]
                require("harpoon.tmux").sendCommand(number, cmd)
            end, {
                nargs = 1,
            })
        end,
        opts = {
            global_settings = {
                menu = {
                    width = vim.api.nvim_win_get_width(0) - 100,
                    height = vim.api.nvim_win_get_height(0) - 25,
                },
                enter_on_sendcmd = true,
                mark_branch = true,
                save_on_toggle = true,
                tmux_autoclose_windows = true,
            },
        },
    },

    { --[[ browse ]]
        "lalitmee/browse.nvim",
        dev = true,
        keys = {
            {
                "<leader>sb",
                function()
                    require("browse").browse()
                end,
                desc = "browse",
                mode = { "n", "x" },
            },
            {
                "<leader>sc",
                function()
                    require("utils.cht").cht()
                end,
                desc = "cheatsheet",
            },
            {
                "<leader>sd",
                function()
                    require("browse").devdocs.search()
                end,
                desc = "devdocs-search",
            },
            {
                "<leader>sf",
                function()
                    require("browse").devdocs.search_with_filetype()
                end,
                desc = "devdocs-filetype-search",
            },
            {
                "<leader>si",
                function()
                    require("browse").input_search()
                end,
                desc = "input-search",
                mode = { "n", "x" },
            },
            {
                "<leader>sl",
                function()
                    require("browse").open_bookmarks()
                end,
                desc = "bookmarks",
                mode = { "n", "x" },
            },
            {
                "<leader>sm",
                function()
                    require("browse").mdn.search()
                end,
                desc = "mdn-search",
                mode = { "n", "x" },
            },
            {
                "<leader>ss",
                function()
                    require("utils.cht").stack_overflow()
                end,
                desc = "stackoverflow",
            },
        },
        config = function()
            -- local bookmarks = {
            --     ["docs"] = {
            --         ["name"] = "docs for everything",
            --         ["cargo"] = "https://doc.rust-lang.org/cargo/index.html?search=%s",
            --         ["devdocs.io"] = "https://devdocs.io/search?q=%s",
            --         ["learnxinyminutes"] = "https://learnxinyminutes.com/docs/%s",
            --         ["mdn"] = "https://developer.mozilla.org/search?q=%s",
            --         ["rust:core"] = "https://doc.rust-lang.org/core/?search=%s",
            --         ["rust:std"] = "https://doc.rust-lang.org/std/?search=%s",
            --     },
            --     ["work"] = {
            --         ["name"] = "work related",
            --         ["github_pulls"] = "https://github.com/pulls",
            --         ["mui"] = "https://mui.com/",
            --         ["mui-icons"] = "https://mui.com/components/material-icons/#material-icons",
            --         ["v4-mui"] = "https://v4.mui.com/",
            --         ["npm_search"] = "https://npmjs.com/search?q=%s",
            --     },
            --     ["lalitmee"] = {
            --         ["name"] = "personal repositories",
            --         ["browse.nvim"] = "https://github.com/lalitmee/browse.nvim",
            --         ["cobalt2.nvim"] = "https://github.com/lalitmee/cobalt2.nvim",
            --         ["dNotes"] = "https://github.com/lalitmee/dNotes",
            --         ["dotfiles"] = "https://github.com/lalitmee/dotfiles",
            --     },
            --     ["neovim"] = {
            --         ["name"] = "most visited repositories for neovim",
            --         ["awesome-neovim"] = "https://github.com/rockerBOO/awesome-neovim",
            --         ["lualine"] = "https://github.com/nvim-lualine/lualine.nvim",
            --         ["neovim"] = "https://github.com/neovim/neovim",
            --         ["nvim-treesitter"] = "https://github.com/nvim-treesitter/nvim-treesitter",
            --         ["telescope"] = "https://github.com/nvim-telescope/telescope.nvim",
            --         ["fzf-lua"] = "https://github.com/ibhagwan/fzf-lua",
            --     },
            --     ["configs"] = {
            --         ["name"] = "dotfiles repositories of my favourites",
            --         ["ThePrimeagen"] = "https://github.com/ThePrimeagen/.dotfiles",
            --         ["akinsho"] = "https://github.com/akinsho/dotfiles",
            --         ["tjdevries"] = "https://github.com/tjdevries/config_manager",
            --         ["whatsthatsmell"] = "https://github.com/whatsthatsmell/dots",
            --     },
            --     ["github"] = {
            --         ["name"] = "search github from neovim",
            --         ["code_search"] = "https://github.com/search?q=%s&type=code",
            --         ["repo_search"] = "https://github.com/search?q=%s&type=repositories",
            --         ["issues_search"] = "https://github.com/search?q=%s&type=issues",
            --         ["pulls_search"] = "https://github.com/search?q=%s&type=pullrequests",
            --     },
            --     ["reddit"] = {
            --         ["name"] = "reddit search",
            --         ["query"] = "https://www.reddit.com/search?q=%s",
            --         ["sr_query"] = "https://www.reddit.com/search?q=%s&type=sr",
            --         ["neovim"] = "https://www.reddit.com/r/neovim",
            --         ["workspaces"] = "https://www.reddit.com/r/workspaces",
            --         ["vim_porn"] = "https://www.reddit.com/r/vimporn",
            --     },
            -- }

            local bookmarks = {
                ["i3wm-docs"] = "https://i3wm.org/docs/",
                ["i3wm-discussions"] = "https://github.com/i3/i3/discussions",
                ["ThePrimeagen"] = "https://github.com/ThePrimeagen/.dotfiles",
                ["akinsho"] = "https://github.com/akinsho/dotfiles",
                ["awesome-neovim"] = "https://github.com/rockerBOO/awesome-neovim",
                ["browse.nvim"] = "https://github.com/lalitmee/browse.nvim",
                ["cargo"] = "https://doc.rust-lang.org/cargo/index.html?search=%s",
                ["cobalt2.nvim"] = "https://github.com/lalitmee/cobalt2.nvim",
                ["code_search"] = "https://github.com/search?q=%s&type=code",
                ["dNotes"] = "https://github.com/lalitmee/dNotes",
                ["devdocs.io"] = "https://devdocs.io/search?q=%s",
                ["dotfiles"] = "https://github.com/lalitmee/dotfiles",
                ["fzf-lua"] = "https://github.com/ibhagwan/fzf-lua",
                ["github_pulls"] = "https://github.com/pulls",
                ["issues_search"] = "https://github.com/search?q=%s&type=issues",
                ["learnxinyminutes"] = "https://learnxinyminutes.com/docs/%s",
                ["lualine"] = "https://github.com/nvim-lualine/lualine.nvim",
                ["mdn"] = "https://developer.mozilla.org/search?q=%s",
                ["mui"] = "https://mui.com/",
                ["mui-icons"] = "https://mui.com/components/material-icons/#material-icons",
                ["neovim_github"] = "https://github.com/neovim/neovim",
                ["neovim_reddit"] = "https://www.reddit.com/r/neovim",
                ["npm_search"] = "https://npmjs.com/search?q=%s",
                ["nvim-treesitter"] = "https://github.com/nvim-treesitter/nvim-treesitter",
                ["pulls_search"] = "https://github.com/search?q=%s&type=pullrequests",
                ["reddit_community_query"] = "https://www.reddit.com/search?q=%s&type=sr",
                ["reddit_query"] = "https://www.reddit.com/search?q=%s",
                ["repo_search"] = "https://github.com/search?q=%s&type=repositories",
                ["rust:core"] = "https://doc.rust-lang.org/core/?search=%s",
                ["rust:std"] = "https://doc.rust-lang.org/std/?search=%s",
                ["telescope"] = "https://github.com/nvim-telescope/telescope.nvim",
                ["tjdevries"] = "https://github.com/tjdevries/config_manager",
                ["v4-mui"] = "https://v4.mui.com/",
                ["vim_porn"] = "https://www.reddit.com/r/vimporn",
                ["whatsthatsmell"] = "https://github.com/whatsthatsmell/dots",
                ["workspaces"] = "https://www.reddit.com/r/workspaces",
                ["bootstrap"] = "https://getbootstrap.com",
            }
            require("browse").setup({
                provider = "duckduckgo", -- google or bing
                bookmarks = bookmarks,
            })
        end,
    },

    { --[[ mini.ai ]]
        "echasnovski/mini.ai",
        keys = {
            { "[f", desc = "Prev function" },
            { "]f", desc = "Next function" },
        },
        opts = function()
            -- add treesitter jumping
            ---@param capture string
            ---@param start boolean
            ---@param down boolean
            local function jump(capture, start, down)
                local rhs = function()
                    local parser = vim.treesitter.get_parser()
                    if not parser then
                        return vim.notify("No treesitter parser for the current buffer", vim.log.levels.ERROR)
                    end

                    local query = vim.treesitter.query.get(vim.bo.filetype, "textobjects")
                    if not query then
                        return vim.notify("No textobjects query for the current buffer", vim.log.levels.ERROR)
                    end

                    local cursor = vim.api.nvim_win_get_cursor(0)

                    ---@type {[1]:number, [2]:number}[]
                    local locs = {}
                    for _, tree in ipairs(parser:trees()) do
                        for capture_id, node, _ in query:iter_captures(tree:root(), 0) do
                            if query.captures[capture_id] == capture then
                                local range = { node:range() } ---@type number[]
                                local row = (start and range[1] or range[3]) + 1
                                local col = (start and range[2] or range[4]) + 1
                                if down and row > cursor[1] or (not down) and row < cursor[1] then
                                    table.insert(locs, { row, col })
                                end
                            end
                        end
                    end
                    return pcall(vim.api.nvim_win_set_cursor, 0, down and locs[1] or locs[#locs])
                end

                local c = capture:sub(1, 1):lower()
                local lhs = (down and "]" or "[") .. (start and c or c:upper())
                local desc = (down and "Next " or "Prev ")
                    .. (start and "start" or "end")
                    .. " of "
                    .. capture:gsub("%..*", "")
                vim.keymap.set("n", lhs, rhs, { desc = desc })
            end

            for _, capture in ipairs({ "function.outer", "class.outer" }) do
                for _, start in ipairs({ true, false }) do
                    for _, down in ipairs({ true, false }) do
                        jump(capture, start, down)
                    end
                end
            end
        end,
    },

    { --[[ hardtime ]]
        "m4xshen/hardtime.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {},
        enabled = false,
    },

    { --[[ text-case ]]
        "johmsalas/text-case.nvim",
        config = function()
            require("textcase").setup({})
            require("telescope").load_extension("textcase")
        end,
        keys = {
            { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "v" }, desc = "Telescope" },
        },
    },

    { --[[ carbon-now ]]
        "ellisonleao/carbon-now.nvim",
        cmd = { "CarbonNow" },
        keys = {
            {
                "<leader>xp",
                ":CarbonNow<CR>",
                mode = { "v" },
                silent = true,
                desc = "carbon-now-visual",
            },
            {
                "<leader>xg",
                ":CarbonNow<space>",
                silent = true,
                mode = { "n" },
                desc = "carbon-from-gist",
            },
        },
        opts = {
            options = {
                bg = "#32597D",
                font_family = "Source Code Pro",
                theme = "vscode",
                window_theme = "boxy",
                drop_shadow = true,
            },
        },
    },

    { --[[ rayso.nvim ]]
        "TobinPalmer/rayso.nvim",
        cmd = { "Rayso" },
        keys = {
            {
                "<leader>xr",
                ":Rayso<CR>",
                silent = true,
                desc = "ray.so",
                mode = { "v" },
            },
        },
        opts = {
            open_cmd = "xdg-open",
            options = {
                theme = "midnight",
            },
        },
    },

    { --[[ silicon.lua ]]
        "narutoxy/silicon.lua",
        keys = {
            {
                "<leader>xv",
                function()
                    require("silicon").visualise_api({ to_clip = true })
                end,
                mode = { "v" },
                desc = "visual selection",
            },
            {
                "<leader>xh",
                function()
                    require("silicon").visualise_api({ to_clip = true, show_buf = true })
                end,
                mode = { "v" },
                desc = "whole buffer with visual selection highlighted",
            },
            {
                "<leader>xb",
                function()
                    require("silicon").visualise_api({ to_clip = true, visible = true })
                end,
                desc = "visible portion of buffer",
            },
            {
                "<leader>xl",
                function()
                    require("silicon").visualise_api({ to_clip = true })
                end,
                desc = "current buffer line",
            },
        },
        config = {
            -- output = "/home/lalitmee/Desktop/Github/code-screenshots/SILICON_$year-$month-$date-$time.png",
            output = "SILICON_$year-$month-$date-$time.png",
            font = "Source Code Pro",
        },
    },

    { --[[ trouble ]]
        "folke/trouble.nvim",
        keys = {
            {
                "<leader>xL",
                function()
                    require("trouble").toggle("loclist")
                end,
                desc = "trouble loclist",
            },
            {
                "<leader>xd",
                function()
                    require("trouble").toggle("document_diagnostics")
                end,
                desc = "trouble document diagnostics",
            },
            {
                "<leader>xq",
                function()
                    require("trouble").toggle("quickfix")
                end,
                desc = "trouble quickfix",
            },
            {
                "<leader>xr",
                function()
                    require("trouble").toggle("lsp_references")
                end,
                desc = "trouble lsp references",
            },
            {
                "<leader>xw",
                function()
                    require("trouble").toggle("workspace_diagnostics")
                end,
                desc = "trouble workspace diagnostics",
            },
            {
                "<leader>xx",
                function()
                    require("trouble").toggle()
                end,
                desc = "trouble toggle",
            },
            {
                "<leader>xn",
                function()
                    require("trouble").next({ skip_groups = true, jump = true })
                end,
                desc = "trouble toggle",
            },
            {
                "<leader>xp",
                function()
                    require("trouble").previous({ skip_groups = true, jump = true })
                end,
                desc = "trouble toggle",
            },
        },
        opts = {
            height = 20,
        },
    },
}
