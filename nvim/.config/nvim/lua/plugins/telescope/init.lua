return {
    { --[[ telescope.nvim ]]
        "nvim-telescope/telescope.nvim",
        -- tag = "0.1.8",
        cmd = { "Telescope" },
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<leader>v", group = "vim" },
            })
        end,
        -- stylua: ignore
        keys = {
            { "<leader>:", ":Telescope commands<CR>", desc = "Commands", silent = true },
            { "<leader><leader>", ":Telescope find_files<CR>", desc = "Find Files", silent = true },
            { "<leader>/", ":Telescope live_grep_args<CR>", desc = "Search Project", silent = true },
            { "<leader>bb", ":Telescope buffers<CR>", desc = "Telescope Buffers", silent = true },
            { "<leader>bl", ":Telescope current_buffer_fuzzy_find<CR>", desc = "Telescope Buffer Lines", silent = true },
            { "<leader>el", ":Telescope diagnostics<CR>", desc = "Workspace Diagnostics", silent = true },
            { "<leader>fc", ":Telescope find_files theme=dropdown<CR>", desc = "With Dropdown", silent = true },
            { "<leader>fd", ":TelescopeEditDotfiles<CR>", desc = "Dotfiles", silent = true },
            { "<leader>ff", ":TelescopeProjectFiles<CR>", desc = "Files", silent = true },
            { "<leader>fg", ":Telescope git_files<CR>", desc = "Git Files", silent = true },
            { "<leader>fi", ":Telescope find_files theme=ivy<CR>", desc = "Ivy Theme Files", silent = true },
            { "<leader>fo", ":Telescope oldfiles<CR>", desc = "Old Files", silent = true },
            { "<leader>ft", ":Telescope filetypes<CR>", desc = "File Types", silent = true },
            { "<leader>gb", ":Telescope git_branches<CR>", desc = "Checkout", silent = true },
            { "<leader>gcc", ":Telescope git_commits<CR>", desc = "Git Commits", silent = true },
            { "<leader>gcb", ":Telescope git_bcommits<CR>", desc = "Git Buffer Commits", silent = true },
            { "<leader>gz", ":Telescope git_stash<CR>", desc = "Git Stash", silent = true },
            { "<leader>is", ":Telescope spell_suggest<CR>", desc = "Spell_suggest", silent = true },
            { "<leader>l/", ":Telescope tags<CR>", desc = "Project Tags", silent = true },
            { "<leader>lT", ":Telescope treesitter<CR>", desc = "Treesitter Symbols", silent = true },
            { "<leader>ne", ":TelescopeEditNeovim<CR>", desc = "Edit Neovim Config", silent = true },
            { "<leader>nt", ":ReloadConfigTelescope<CR>", desc = "Realod Modules", silent = true },
            { "<leader>nx", ":Telescope reloader<CR>", desc = "Reloaders", silent = true },
            { "<leader>q/", ":Telescope quickfix<CR>", desc = "Telescope Quickfix", silent = true },
            { "<leader>sa", ":TelescopeFuzzyLiveGrep<CR>", desc = "Fuzzy Live Grep", silent = true },
            { "<leader>sr", ":Telescope resume<CR>", desc = "Live Grep Resume", silent = true },

            -- vim
            { "<leader>v/", ":Telescope search_history<CR>", desc = "Search History", silent = true },
            { "<leader>v:", ":Telescope commands<CR>", desc = "Commands", silent = true },
            { "<leader>va", ":Telescope autocommands<CR>", desc = "Autocommands", silent = true },
            { "<leader>vc", ":Telescope colorscheme<CR>", desc = "Colorschemes", silent = true },
            { "<leader>vC", ":Telescope command_history<CR>", desc = "Command History", silent = true },
            { "<leader>vf", ":Telescope filetypes<CR>", desc = "Filetypes", silent = true },
            { "<leader>vg", ":Telescope helpgrep<CR>", desc = "Help Grep", silent = true },
            { "<leader>vh", ":Telescope help_tags<CR>", desc = "Help Tags", silent = true },
            { "<leader>vH", ":Telescope highlights<CR>", desc = "Highlights", silent = true },
            { "<leader>vj", ":Telescope jumplist<CR>", desc = "Jumplist", silent = true },
            { "<leader>vk", ":Telescope keymaps<CR>", desc = "Keymaps", silent = true },
            { "<leader>vl", ":Telescope loclist<CR>", desc = "Loclist", silent = true },
            { "<leader>vm", ":Telescope marks<CR>", desc = "Marks", silent = true },
            { "<leader>vM", ":Telescope man_pages<CR>", desc = "Man Pages", silent = true },
            { "<leader>vr", ":Telescope registers<CR>", desc = "Vim Registers", silent = true },
            { "<leader>vt", ":Telescope tagstack<CR>", desc = "Tag Stack", silent = true },
            { "<leader>vv", ":Telescope vim_options<CR>", desc = "Vim Options", silent = true },

            -- project
            { "<leader>pf", ":Telescope find_files<cr>", desc = "Find Files", silent = true },
            { "<leader>pg", ":Telescope git_files<CR>", desc = "Git Files", silent = true },
            { "<leader>ps", ":Telescope live_grep<CR>", desc = "Live Grep", silent = true },
            { "<leader>pw", ":Telescope grep_string<CR>", desc = "Grep String", silent = true, mode = { "n", "v" } },
            { "<leader>pm", function() require("telescope.multi-ripgrep")() end, desc = "Multi Ripgrep", silent = true },
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
        },
        config = function()
            require("custom.telescope").setup()
            require("custom.telescope").custom_extensions()
        end,
    },

    { --[[ telescope-frecency.nvim ]]
        enabled = false,
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
        opts = {
            extensions = {
                smart_open = {
                    match_algorithm = "fzf",
                },
            },
        },
        config = function(_, opts)
            require("telescope").setup(opts)
            require("telescope").load_extension("smart_open")
        end,
        dependencies = {
            "kkharji/sqlite.lua",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
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
            { "<leader>au", ":Telescope undo<CR>", desc = "Telescope Undo", silent = true },
        },
        opts = {
            extensions = {
                undo = {
                    side_by_side = true,
                    layout_strategy = "vertical",
                    layout_config = { preview_height = 0.8 },
                },
            },
        },
        config = function(_, opts)
            require("telescope").setup(opts)
            require("telescope").load_extension("undo")
        end,
    },
}
