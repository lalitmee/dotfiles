return {
    { --[[ telescope.nvim ]]
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        cmd = { "Telescope" },
        keys = {
            -- project
            { "<leader>pf", ":Telescope find_files<cr>", desc = "Find Files", silent = true },
            { "<leader>pg", ":Telescope git_files<CR>", desc = "Git Files", silent = true },
            { "<leader>ps", ":Telescope live_grep<CR>", desc = "Live Grep", silent = true },
            { "<leader>pw", ":Telescope grep_string<CR>", desc = "Grep String", silent = true, mode = { "n", "v" } },
            {
                "<leader>pm",
                function()
                    require("telescope.multi-ripgrep")()
                end,
                desc = "Multi Ripgrep",
                silent = true,
            },
            {
                "<leader>nf",
                function()
                    require("telescope.builtin").find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
                end,
                desc = "Files of Installed Plugins",
                silent = true,
            },
        },
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                config = function()
                    require("telescope").load_extension("fzf")
                end,
            },
            { "nvim-treesitter/nvim-treesitter" },
        },
        config = function()
            require("custom.telescope").setup()
            require("custom.telescope").custom_extensions()
        end,
    },

    { --[[ telescope-frecency.nvim ]]
        "nvim-telescope/telescope-frecency.nvim",
        keys = {
            { "<leader>pr", ":Telescope frecency<CR>", desc = "Frecency", silent = true },
        },
        config = function()
            require("telescope").load_extension("frecency")
        end,
    },

    { --[[ smart-open.nvim ]]
        "danielfalk/smart-open.nvim",
        branch = "0.2.x",
        keys = {
            { "<leader>pl", ":Telescope smart_open<CR>", desc = "Smart Open", silent = true },
        },
        config = function()
            require("telescope").load_extension("smart_open")
        end,
        dependencies = {
            "kkharji/sqlite.lua",
            "nvim-telescope/telescope-fzy-native.nvim",
        },
    },

    { --[[ telescope-smart-history.nvim ]]
        enabled = false,
        "nvim-telescope/telescope-smart-history.nvim",
        dependencies = { "kkharji/sqlite.lua" },
        event = "VeryLazy",
        config = function()
            require("telescope").load_extension("smart_history")
        end,
    },

    { --[[ telescope-lazy.nvim ]]
        "tsakirist/telescope-lazy.nvim",
        keys = {
            { "<leader>na", ":Telescope lazy<CR>", desc = "Telescope Lazy", silent = true },
        },
        config = function()
            require("telescope").load_extension("lazy")
        end,
    },

    { --[[ telescope-zoxide ]]
        "jvgrootveld/telescope-zoxide",
        keys = {
            { "<leader>al", ":Telescope zoxide list<CR>", desc = "Zoxide List", silent = true },
        },
        config = function()
            require("telescope").load_extension("zoxide")
        end,
    },

    { --[[ telescope-live-grep-args.nvim ]]
        "nvim-telescope/telescope-live-grep-args.nvim",
        keys = {
            { "<leader>p/", ":Telescope live_grep_args<CR>", desc = "Live Grep Args", silent = true },
        },
        config = function()
            require("telescope").load_extension("live_grep_args")
        end,
    },

    { --[[ telescope-luasnip.nvim ]]
        "benfowler/telescope-luasnip.nvim",
        keys = {
            { "<leader>ia", ":Telescope luasnip<CR>", desc = "Luasnip Snippets", silent = true },
        },
        config = function()
            require("telescope").load_extension("luasnip")
        end,
    },

    { --[[ telescope-import.nvim ]]
        "piersolenski/telescope-import.nvim",
        keys = {
            { "<leader>pi", ":Telescope import<CR>", desc = "Telescope Import", silent = true },
        },
        config = function()
            require("telescope").load_extension("import")
        end,
    },

    { --[[ telescope-helpgrep.nvim ]]
        "catgoose/telescope-helpgrep.nvim",
        keys = {
            { "<leader>vg", ":Telescope helpgrep<CR>", desc = "Helpgrep", silent = true },
        },
        config = function()
            require("telescope").load_extension("helpgrep")
        end,
    },

    { --[[ toggleterm-manager.nvim ]]
        "ryanmsnyder/toggleterm-manager.nvim",
        dependencies = { "akinsho/toggleterm.nvim" },
        keys = {
            { "<leader>at", ":Telescope toggleterm_manager<CR>", desc = "Toggleterm Manager", silent = true },
        },
        config = true,
    },

    { --[[ telescope-project.nvim ]]
        "nvim-telescope/telescope-project.nvim",
        keys = {
            { "<leader>pp", ":Telescope project<CR>", desc = "Projects", silent = true },
        },
        config = function()
            require("telescope").load_extension("project")
        end,
    },

    { --[[ telescope-undo.nvim ]]
        "debugloop/telescope-undo.nvim",
        keys = {
            { "<leader>au", ":Telescope undo<cr>", desc = "Telescope Undo", silent = true },
        },
        config = function()
            require("telescope").load_extension("undo")
        end,
    },

    { --[[ search.nvim ]]
        "FabianWirth/search.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        keys = {
            {
                "<leader>st",
                function()
                    require("search").open()
                end,
                desc = "Telescope Search (Tabs Mode)",
                silent = true,
            },
            {
                "<leader>g/",
                function()
                    require("search").open({ collection = "git" })
                end,
                desc = "Telescope Git Collection Search",
                silent = true,
            },
            {
                "<leader>pa",
                function()
                    require("search").open({ collection = "grep" })
                end,
                desc = "Telescope Grep Collection Search",
                silent = true,
            },
        },
        opts = {
            mappings = {
                next = { { "L", "n" }, { "<Tab>", "n" }, { "<Tab>", "i" } },
                prev = { { "H", "n" }, { "<S-Tab>", "n" }, { "<S-Tab>", "i" } },
            },
            append_tabs = {
                {
                    name = "Commits",
                    tele_func = require("telescope.builtin").git_commits,
                    available = function()
                        return vim.fn.isdirectory(".git") == 1
                    end,
                },
            },
            collections = {
                git = {
                    initial_tab = 1,
                    tabs = {
                        { name = "Status", tele_func = require("telescope.builtin").git_status },
                        { name = "Branches", tele_func = require("telescope.builtin").git_branches },
                        { name = "Commits", tele_func = require("telescope.builtin").git_commits },
                        { name = "Buffer Commits", tele_func = require("telescope.builtin").git_bcommits },
                        { name = "Stashes", tele_func = require("telescope.builtin").git_stash },
                    },
                },

                grep = {
                    initial_tab = 1,
                    tabs = {
                        { name = "Grep", tele_func = require("telescope.builtin").live_grep },
                        -- {
                        --     name = "Grep Args",
                        --     tele_func = require("telescope").extensions.live_grep_args.live_grep_args,
                        -- },
                    },
                },

                vim = {
                    initial_tab = 1,
                    tabs = {
                        { name = "Options", tele_func = require("telescope.builtin").vim_options },
                    },
                },
            },
        },
    },
}
