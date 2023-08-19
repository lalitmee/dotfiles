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
            local neogit_notify = function(msg, type)
                local msg_type = type or "info"
                vim.notify(msg, msg_type, { title = " Neogit" })
            end

            augroup("neogit_au", {
                {
                    event = { "FileType" },
                    pattern = { "NeogitCommitMessage" },
                    command = function()
                        vim.cmd([[set ft=gitcommit]])
                    end,
                },
                {
                    event = { "User" },
                    pattern = { "NeogitCommitComplete" },
                    command = function()
                        neogit_notify("Commited Successfully")
                    end,
                },
                {
                    event = { "User" },
                    pattern = { "NeogitPushComplete" },
                    command = function()
                        neogit_notify("Pushed Successfully")
                    end,
                },
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
        config = true,
        keys = {
            -- action
            { "<leader>gac", ":Octo reaction confused<CR>", desc = "react-confused", silent = true },
            { "<leader>gad", ":Octo reaction thumbs_down<CR>", desc = "react-thumbs_down", silent = true },
            { "<leader>gae", ":Octo reaction eyes<CR>", desc = "react-eyes", silent = true },
            { "<leader>gah", ":Octo reaction heart<CR>", desc = "react-heart", silent = true },
            { "<leader>gal", ":Octo reaction laugh<CR>", desc = "react-laugh", silent = true },
            { "<leader>gar", ":Octo reaction rocket<CR>", desc = "react-rocket", silent = true },
            { "<leader>gat", ":Octo reaction tada<CR>", desc = "react-tada", silent = true },
            { "<leader>gau", ":Octo reaction thumbs_up<CR>", desc = "react-thumbs_up", silent = true },

            -- comment
            { "<leader>gCa", ":Octo comment add<CR>", desc = "add", silent = true },
            { "<leader>gCd", ":Octo comment delete<CR>", desc = "delete", silent = true },

            -- gist
            { "<leader>gg", ":Octo gist list<CR>", desc = "list-gist", silent = true },

            -- issues
            { "<leader>gia", ":Octo issue create<CR>", desc = "create", silent = true },
            { "<leader>gib", ":Octo issue browser<CR>", desc = "browser", silent = true },
            { "<leader>gic", ":Octo issue close<CR>", desc = "close", silent = true },
            { "<leader>gie", ":Octo issue edit<CR>", desc = "edit", silent = true },
            { "<leader>gil", ":Octo issue list<CR>", desc = "list", silent = true },
            { "<leader>gio", ":Octo issue reopen<CR>", desc = "reopen", silent = true },
            { "<leader>gir", ":Octo issue reload<CR>", desc = "reload", silent = true },
            { "<leader>gis", ":Octo issue search<CR>", desc = "search", silent = true },
            { "<leader>giu", ":Octo issue url<CR>", desc = "url", silent = true },

            -- label
            { "<leader>gla", ":Octo label add<CR>", desc = "add", silent = true },
            { "<leader>glc", ":Octo label create<CR>", desc = "create", silent = true },
            { "<leader>glr", ":Octo label remove<CR>", desc = "remove", silent = true },

            -- pull request
            { "<leader>gpa", ":Octo pr create<CR>", desc = "create", silent = true },
            { "<leader>gpb", ":Octo pr browser<CR>", desc = "browser", silent = true },
            { "<leader>gpc", ":Octo pr checkout<CR>", desc = "checkout", silent = true },
            { "<leader>gpC", ":Octo pr close<CR>", desc = "close", silent = true },
            { "<leader>gpd", ":Octo pr diff<CR>", desc = "diff", silent = true },
            { "<leader>gpD", ":Octo pr checks<CR>", desc = "checks", silent = true },
            { "<leader>gpe", ":Octo pr edit<CR>", desc = "edit", silent = true },
            { "<leader>gpg", ":Octo pr commits<CR>", desc = "commits", silent = true },
            { "<leader>gph", ":Octo pr changes<CR>", desc = "changes", silent = true },
            { "<leader>gpl", ":Octo pr list<CR>", desc = "list", silent = true },
            { "<leader>gpm", ":Octo pr merge<CR>", desc = "merge", silent = true },
            { "<leader>gpo", ":Octo pr reopen<CR>", desc = "reopen", silent = true },
            { "<leader>gpr", ":Octo pr reload<CR>", desc = "reload", silent = true },
            { "<leader>gpR", ":Octo pr ready<CR>", desc = "ready", silent = true },
            { "<leader>gps", ":Octo pr search<CR>", desc = "search", silent = true },
            { "<leader>gpu", ":Octo pr url<CR>", desc = "url", silent = true },

            -- review
            { "<leader>gra", ":Octo reviewer add<CR>", desc = "add-reviewer", silent = true },
            { "<leader>grb", ":Octo review start<CR>", desc = "start-review", silent = true },
            { "<leader>grc", ":Octo review comments<CR>", desc = "comments-review", silent = true },
            { "<leader>grd", ":Octo review discard<CR>", desc = "discard-review", silent = true },
            { "<leader>grr", ":Octo review resume<CR>", desc = "resume-review", silent = true },
            { "<leader>grs", ":Octo review submit<CR>", desc = "submit-review", silent = true },

            -- repo
            { "<leader>gRb", ":Octo repo browser<CR>", desc = "browser", silent = true },
            { "<leader>gRf", ":Octo repo fork<CR>", desc = "fork", silent = true },
            { "<leader>gRl", ":Octo repo list<CR>", desc = "list", silent = true },
            { "<leader>gRu", ":Octo repo url<CR>", desc = "url", silent = true },

            -- thread
            { "<leader>gtr", ":Octo thread resolve<CR>", desc = "resolve", silent = true },
            { "<leader>gtu", ":Octo thread unresolve<CR>", desc = "unresolve", silent = true },
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
}
