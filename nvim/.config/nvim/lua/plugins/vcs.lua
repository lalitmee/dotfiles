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

    { --[[ worktree ]]
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
            require("telescope").load_extension("git_worktree")
        end,
        enabled = false,
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
        "ldelossa/gh.nvim",
        dependencies = { "ldelossa/litee.nvim" },
        keys = {
            { "<leader>gecc", "<cmd>GHCloseCommit<cr>", desc = "commit-Close", silent = true },
            { "<leader>gece", "<cmd>GHExpandCommit<cr>", desc = "commit-Expand", silent = true },
            { "<leader>geco", "<cmd>GHOpenToCommit<cr>", desc = "commit-Open To", silent = true },
            { "<leader>gecp", "<cmd>GHPopOutCommit<cr>", desc = "commit-Pop Out", silent = true },
            { "<leader>gecz", "<cmd>GHCollapseCommit<cr>", desc = "commit-Collapse", silent = true },
            { "<leader>geip", "<cmd>GHPreviewIssue<cr>", desc = "issue-Preview", silent = true },
            { "<leader>gelt", "<cmd>LTPanel<cr>", desc = "Toggle Panel", silent = true },
            { "<leader>gerb", "<cmd>GHStartReview<cr>", desc = "review-Begin", silent = true },
            { "<leader>gerc", "<cmd>GHCloseReview<cr>", desc = "review-Close", silent = true },
            { "<leader>gerd", "<cmd>GHDeleteReview<cr>", desc = "review-Delete", silent = true },
            { "<leader>gere", "<cmd>GHExpandReview<cr>", desc = "review-Expand", silent = true },
            { "<leader>gers", "<cmd>GHSubmitReview<cr>", desc = "review-Submit", silent = true },
            { "<leader>gerz", "<cmd>GHCollapseReview<cr>", desc = "review-Collapse", silent = true },
            { "<leader>gepc", "<cmd>GHClosePR<cr>", desc = "pr-Close", silent = true },
            { "<leader>gepd", "<cmd>GHPRDetails<cr>", desc = "pr-Details", silent = true },
            { "<leader>gepe", "<cmd>GHExpandPR<cr>", desc = "pr-Expand", silent = true },
            { "<leader>gepo", "<cmd>GHOpenPR<cr>", desc = "pr-Open", silent = true },
            { "<leader>gepp", "<cmd>GHPopOutPR<cr>", desc = "pr-PopOut", silent = true },
            { "<leader>gepr", "<cmd>GHRefreshPR<cr>", desc = "pr-Refresh", silent = true },
            { "<leader>gept", "<cmd>GHOpenToPR<cr>", desc = "pr-Open To", silent = true },
            { "<leader>gepz", "<cmd>GHCollapsePR<cr>", desc = "pr-Collapse", silent = true },
            { "<leader>getc", "<cmd>GHCreateThread<cr>", desc = "thread-Create", silent = true },
            { "<leader>getn", "<cmd>GHNextThread<cr>", desc = "thread-Next", silent = true },
            { "<leader>gett", "<cmd>GHToggleThread<cr>", desc = "thread-Toggle", silent = true },
        },
        config = function()
            require("litee.lib").setup()
            require("litee.gh").setup()
        end,
    },
}
