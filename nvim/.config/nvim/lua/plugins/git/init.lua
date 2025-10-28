local augroup = lk.augroup

return {
    { --[[ neogit ]]
        "NeogitOrg/neogit",
        cmd = { "Neogit" },
        keys = {
            { "<leader>gs", ":Neogit<CR>", desc = "Status", silent = true },
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
            signs = {
                -- { CLOSED, OPENED }
                hunk = { "", "" },
                item = { "▷", "▽" }, -- >, ›, », V
                section = { "▷", "▽" }, -- >, ›, », V
            },
        },
    },

    { --[[ vim-fugitive ]]
        enabled = false,
        "tpope/vim-fugitive",
        cmd = { "Git" },
        keys = {
            { "<leader>gs", ":Git<CR>", desc = "Git Status", silent = true },
        },
    },

    { --[[ gitsigns.nvim ]]
        "lewis6991/gitsigns.nvim",
        event = "BufReadPost",
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<localleader>g", group = "git" },
            })
        end,
        keys = {
            { "<leader>gdd", ":Gitsigns diffthis<CR>", desc = "Diffthis" },
            { "<leader>gdw", ":Gitsigns toggle_word_diff<CR>", desc = "Toggle Word Diff" },
            { "<leader>gm", ":Gitsigns blame_line<CR>", desc = "Blame Line" },
            {
                "<leader>gO",
                function()
                    vim.cmd([[silent !gh repo view --web]])
                end,
                desc = "Open Repo",
            },
            { "<localleader>gS", ":Gitsigns stage_hunk<CR>", desc = "stage hunk", silent = true },
            { "<localleader>gu", ":Gitsigns undo_stage_hunk<CR>", desc = "undo stage Hunk", silent = true },
            { "<localleader>gv", ":Gitsigns preview_hunk<CR>", desc = "preview hunk", silent = true },
            { "<localleader>gV", ":Gitsigns preview_hunk_inline<CR>", desc = "preview hunk inline", silent = true },
            { "<localleader>gx", ":Gitsigns reset_hunk<CR>", desc = "discard hunk", silent = true },
            { "<localleader>gX", ":Gitsigns reset_buffer<CR>", desc = "discard buffer", silent = true },
        },
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

    { --[[ octo.nvim ]]
        "pwntester/octo.nvim",
        keys = {
            { "<leader>go", ":Octo<CR>", desc = "Octo", silent = true },
        },
        opts = {
            enable_builtin = true,
        },
    },

    { --[[ git-worktree.nvim ]]
        "polarmutex/git-worktree.nvim",
        version = "^2",
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<leader>gw", group = "git-worktree" },
            })
        end,
        keys = {
            {
                "<leader>gwa",
                function()
                    require("plugins.git.worktree.telescope").create_worktree_picker()
                end,
                desc = "Create Worktree (with Branch Picker)",
                silent = true,
            },
            {
                "<leader>gwl",
                ":Telescope git_worktree git_worktree<CR>",
                desc = "List Worktrees",
                silent = true,
            },
            {
                "<leader>gwd",
                function()
                    require("plugins.git.worktree.telescope").delete_worktree_picker()
                end,
                desc = "Delete Worktree",
            },
        },
        config = function()
            require("telescope").load_extension("git_worktree")
            require("plugins.git.worktree.hooks")
        end,
    },

    { --[[ diffview ]]
        "sindrets/diffview.nvim",
        cmd = {
            "DiffviewOpen",
            "DiffviewFileHistory",
            "DiffviewLog",
        },
        keys = {
            { "<leader>gdc", ":DiffviewClose<CR>", desc = "Diffview Close" },
            { "<leader>gdf", ":DiffviewFileHistory %<CR>", desc = "Current File History" },
            { "<leader>gdF", ":DiffviewFileHistory<CR>", desc = "Diffview File History" },
            { "<leader>gdo", ":DiffviewOpen<CR>", desc = "Diffview Open" },
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
