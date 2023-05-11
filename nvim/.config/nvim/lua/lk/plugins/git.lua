local command, augroup = lk.command, lk.augroup

local function neogit()
    return {
        "TimUntersberger/neogit",
        cmd = { "Neogit" },
        -- enabled = false,
        config = function()
            local neogit = require("neogit")

            -- setup
            neogit.setup({
                disable_commit_confirmation = true,
                integrations = { diffview = true },
            })

            -- commands
            command("Neogit", function()
                neogit.open()
            end, {})

            -- autocmds
            local neogit_notify = function(msg, type)
                local msg_type = type or "info"
                vim.notify(msg, msg_type, { title = " Neogit" })
            end

            augroup("neogit_au", {
                -- {
                --     event = { "User" },
                --     pattern = { "NeogitStatusRefreshed" },
                --     command = function()
                --         neogit_notify("status has been reloaded")
                --     end,
                -- },
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
    }
end

local function fugitive()
    return {
        "tpope/vim-fugitive",
        cmd = { "Git" },
    }
end

local function advanced_git_search()
    return {
        "aaronhallaert/advanced-git-search.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        init = function()
            local wk = require("which-key")
            wk.register({
                ["g"] = {
                    ["f"] = {
                        ["name"] = "+find-anything",
                        ["c"] = {
                            ":Telescope advanced_git_search diff_commit_file<CR>",
                            "file-commits",
                        },
                        ["f"] = {
                            ":Telescope advanced_git_search search_log_content_file<CR>",
                            "file-log",
                        },
                        ["l"] = {
                            ":Telescope advanced_git_search diff_commit_line<CR>",
                            "line-commits",
                        },
                        ["L"] = {
                            ":Telescope advanced_git_search search_log_content<CR>",
                            "log",
                        },
                    },
                },
            }, { mode = "n", prefix = "<leader>" })
        end,
    }
end

local function igs()
    return {
        "rmagatti/igs.nvim",
        keys = {
            -- quickfix
            "<leader>gqA",
            "<leader>gqD",
            "<leader>gqM",
            "<leader>gqS",
            "<leader>gqa",
            "<leader>gqc",
            "<leader>gqd",
            "<leader>gqm",
            "<leader>gqs",

            -- edit
            "<leader>gea",
            "<leader>gem",
            "<leader>ges",
        },
        config = function()
            require("igs").setup()
        end,
        init = function()
            local wk = require("which-key")
            wk.register({
                ["g"] = {
                    ["q"] = {
                        ["name"] = "+quickfix",
                        ["a"] = {
                            function()
                                require("igs").qf_all()
                            end,
                            "all-files",
                        },
                        ["A"] = {
                            function()
                                require("igs").qf_all({ all_changes = true })
                            end,
                            "all-changes",
                        },
                        ["c"] = {
                            function()
                                require("igs").qf_conflicts()
                            end,
                            "conflicts",
                        },
                        ["d"] = {
                            function()
                                require("igs").qf_diff_branch({
                                    all_changes = true,
                                })
                            end,
                            "diff-branch-changes",
                        },
                        ["D"] = {
                            function()
                                require("igs").qf_diff_branch({
                                    all_changes = false,
                                })
                            end,
                            "diff-branch",
                        },
                        ["m"] = {
                            function()
                                require("igs").qf_modified()
                            end,
                            "modified-files",
                        },
                        ["M"] = {
                            function()
                                require("igs").qf_modified({
                                    all_changes = true,
                                })
                            end,
                            "modified-changes",
                        },
                        ["s"] = {
                            function()
                                require("igs").qf_added()
                            end,
                            "staged-files",
                        },
                        ["S"] = {
                            function()
                                require("igs").qf_added({ all_changes = true })
                            end,
                            "staged-changes",
                        },
                    },
                    ["e"] = {
                        ["name"] = "+edit",
                        ["a"] = {
                            function()
                                require("igs").edit_all()
                            end,
                            "all-files",
                        },
                        ["m"] = {
                            function()
                                require("igs").edit_modified()
                            end,
                            "modifed-files",
                        },
                        ["s"] = {
                            function()
                                require("igs").edit_added()
                            end,
                            "added-files",
                        },
                    },
                },
            }, { mode = "n", prefix = "<leader>" })
        end,
    }
end

local function gitsigns()
    return {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = function()
            require("gitsigns").setup({
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
            })
        end,
    }
end

return {
    neogit(),
    fugitive(),
    advanced_git_search(),
    igs(),
    gitsigns(),
}
