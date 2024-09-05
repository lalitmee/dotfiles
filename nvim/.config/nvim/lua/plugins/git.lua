local augroup = lk.augroup

return {
    { --[[ neogit ]]
        "NeogitOrg/neogit",
        cmd = { "Neogit" },
        keys = {
            { "<leader>gs", ":Neogit<CR>", desc = "status", silent = true },
        },
        init = function()
            -- autocmds
            -- local neogit_notify = function(msg, type)
            --     local msg_type = type or "info"
            --     vim.notify(msg, msg_type, { title = " Neogit" })
            -- end

            augroup("neogit_au", {
                {
                    event = { "FileType" },
                    pattern = { "NeogitCommitMessage" },
                    command = function()
                        vim.cmd([[set ft=gitcommit]])
                    end,
                },
                -- {
                --     event = { "User" },
                --     pattern = { "NeogitCommitComplete" },
                --     command = function()
                --         neogit_notify("Commited Successfully")
                --     end,
                -- },
                -- {
                --     event = { "User" },
                --     pattern = { "NeogitPushComplete" },
                --     command = function()
                --         neogit_notify("Pushed Successfully")
                --     end,
                -- },
                {
                    event = { "User" },
                    pattern = { "NeogitPushComplete" },
                    command = function()
                        require("neogit").close()
                    end,
                },
            })
        end,
        opts = {
            disable_commit_confirmation = true,
            integrations = {
                telescope = true,
                diffview = true,
            },
        },
    },

    { --[[ gitlinker.nvim ]]
        "linrongbin16/gitlinker.nvim",
        -- stylua: ignore
        keys = {
            { "<leader>gl", "<cmd>GitLink<cr>", mode = { "n", "v" }, silent = true, desc = "Copy git permlink to clipboard" },
            { "<leader>gL", "<cmd>GitLink!<cr>", mode = { "n", "v" }, silent = true, desc = "Open git permlink in browser" },
            { "<leader>ga", "<cmd>GitLink blame<cr>", mode = { "n", "v" }, silent = true, desc = "Copy git blame link to clipboard" },
            { "<leader>gA", "<cmd>GitLink! blame<cr>", mode = { "n", "v" }, silent = true, desc = "Open git blame link in browser" },
        },
        opts = {},
    },

    { --[[ fugitive ]]
        "tpope/vim-fugitive",
        cmd = { "Git" },
        keys = {
            { "<leader>gs", ":Git<CR>", desc = "git-status", silent = true },
        },
        enabled = false,
    },

    { --[[ gitsigns ]]
        "lewis6991/gitsigns.nvim",
        event = "BufReadPost",
        opts = {
            signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            numhl = true,
            linehl = false,
            watch_gitdir = { interval = 1000 },
            sign_priority = 6,
            update_debounce = 200,
            status_formatter = nil,
            current_line_blame = false,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 500,
            },
            preview_config = {
                border = "rounded",
            },
            current_line_blame_formatter = "   <author>, <author_time:%R> - <summary>",
        },
    },

    { --[[ octo ]]
        "pwntester/octo.nvim",
        keys = {
            { "<leader>go", ":Octo<CR>", desc = "octo", silent = true },
        },
        opts = {
            enable_builtin = true,
        },
    },

    { --[[ git-worktree.nvim ]]
        enabled = false,
        "polarmutex/git-worktree.nvim",
        version = "^2",
        keys = {
            {
                "<leader>gwa",
                ":Telescope git_worktree create_git_worktree<CR>",
                desc = "create-worktree",
                silent = true,
            },
            {
                "<leader>gwl",
                ":Telescope git_worktree git_worktree<CR>",
                desc = "list-worktrees",
                silent = true,
            },
        },
        init = function()
            local wk = require("which-key")
            wk.register({
                ["gw"] = { name = "+worktree" },
            }, { mode = "n", prefix = "<leader>" })
        end,
        config = function()
            require("telescope").load_extension("git_worktree")
        end,
    },

    { --[[ g-worktree.nvim ]]
        "Mohanbarman/g-worktree.nvim",
        keys = {
            {
                "<leader>gwa",
                ":Telescope g_worktree create<CR>",
                desc = "create-worktree",
                silent = true,
            },
            {
                "<leader>gwl",
                ":Telescope g_worktree list<CR>",
                desc = "list-worktrees",
                silent = true,
            },
        },
        init = function()
            local wk = require("which-key")
            wk.register({
                ["gw"] = { name = "+worktree" },
            }, { mode = "n", prefix = "<leader>" })
        end,
        config = function()
            require("g-worktree").setup({
                base_dir_pattern = "../{git_dir_name}-worktrees/{branch_name}",
                post_create_cmd = "",
            })

            require("telescope").load_extension("g_worktree")
        end,
    },

    { --[[ diffview ]]
        "sindrets/diffview.nvim",
        cmd = {
            "DiffviewOpen",
            "DiffviewFileHistory",
            "DiffviewLog",
        },
        opts = {
            enhanced_diff_hl = true,
            key_bindings = {
                file_panel = { q = "<Cmd>DiffviewClose<CR>" },
                view = { q = "<Cmd>DiffviewClose<CR>" },
            },
        },
    },
}
