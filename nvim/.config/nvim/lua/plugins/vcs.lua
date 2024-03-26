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
                add = {
                    hl = "GitSignsAdd",
                    text = "│",
                    numhl = "GitSignsAddNr",
                    linehl = "GitSignsAddLn",
                },
                change = {
                    hl = "GitSignsChange",
                    text = "│",
                    numhl = "GitSignsChangeNr",
                    linehl = "GitSignsChangeLn",
                },
                delete = {
                    hl = "GitSignsDelete",
                    text = "_",
                    numhl = "GitSignsDeleteNr",
                    linehl = "GitSignsDeleteLn",
                },
                topdelete = {
                    hl = "GitSignsDelete",
                    text = "‾",
                    numhl = "GitSignsDeleteNr",
                    linehl = "GitSignsDeleteLn",
                },
                changedelete = {
                    hl = "GitSignsChange",
                    text = "~",
                    numhl = "GitSignsChangeNr",
                    linehl = "GitSignsChangeLn",
                },
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
        "ThePrimeagen/git-worktree.nvim",
        keys = {
            {
                "<leader>gwa",
                ":Telescope git_worktree create_git_worktree<CR>",
                desc = "create-worktree",
                silent = true,
            },
            {
                "<leader>gwl",
                ":Telescope git_worktree git_worktrees<CR>",
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
            local Job = require("plenary.job")
            local Worktree = require("git-worktree")

            Worktree.setup()

            Worktree.on_tree_change(function(op, path, upstream)
                if op == Worktree.Operations.Switch then
                    Job:new({ "yarn", "dev" }):start()
                end

                if op == Worktree.Operations.Create then
                    local install = Job:new({
                        "yarn",
                    })
                    local run = Job:new({
                        "yarn",
                        "dev",
                    })
                    install:and_then_on_success(run)
                    install:start()
                end
            end)

            require("telescope").load_extension("git_worktree")
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

    {
        "towry/commit-msg-sg.nvim",
        dependencies = { "sourcegraph/sg.nvim" },
        cmd = { "WriteGitCommitMessage" },
        ft = "gitcommit",
        keys = {
            {
                "<leader>gcr",
                "<cmd>WriteGitCommitMessage<cr>",
                silent = true,
                desc = "write git commit using Cody",
            },
        },
        opts = {},
    },
}
