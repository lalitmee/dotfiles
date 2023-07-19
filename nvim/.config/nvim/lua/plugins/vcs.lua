local augroup = lk.augroup
local command = lk.command

return {
    { --[[ neogit ]]
        "NeogitOrg/neogit",
        cmd = { "Neogit" },
        init = function()
            -- commands
            command("Neogit", function()
                require("neogit").open()
            end)

            local wk = require("which-key")
            wk.register({
                ["g"] = {
                    ["s"] = { ":Neogit<CR>", "status" },
                },
            }, { mode = "n", prefix = "<leader>" })

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
        enabled = false,
        init = function()
            local wk = require("which-key")
            wk.register({
                ["g"] = {
                    ["s"] = { ":Git<CR>", "git-status" },
                },
            }, { mode = "n", prefix = "<leader>" })
        end,
    },

    { --[[ gitsigns ]]
        "lewis6991/gitsigns.nvim",
        event = { "VeryLazy" },
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
    },

    { --[[ octo ]]
        "pwntester/octo.nvim",
        cmd = { "Octo" },
        config = true,
        init = function()
            local wk = require("which-key")
            wk.register({
                ["g"] = {
                    ["a"] = {
                        ["name"] = "+reaction",
                        ["c"] = {
                            ":Octo reaction confused<CR>",
                            "react-confused",
                        },
                        ["d"] = {
                            ":Octo reaction thumbs_down<CR>",
                            "react-thumbs_down",
                        },
                        ["e"] = { ":Octo reaction eyes<CR>", "react-eyes" },
                        ["h"] = {
                            ":Octo reaction heart<CR>",
                            "react-heart",
                        },
                        ["l"] = {
                            ":Octo reaction laugh<CR>",
                            "react-laugh",
                        },
                        ["r"] = {
                            ":Octo reaction rocket<CR>",
                            "react-rocket",
                        },
                        ["t"] = { ":Octo reaction tada<CR>", "react-tada" },
                        ["u"] = {
                            ":Octo reaction thumbs_up<CR>",
                            "react-thumbs_up",
                        },
                    },
                    ["C"] = {
                        ["name"] = "+comment",
                        ["a"] = { ":Octo comment add<CR>", "add" },
                        ["d"] = { ":Octo comment delete<CR>", "delete" },
                    },
                    ["g"] = { ":Octo gist list<CR>", "list-gist" },
                    ["i"] = {
                        ["name"] = "+issues",
                        ["a"] = { ":Octo issue create<CR>", "create" },
                        ["b"] = { ":Octo issue browser<CR>", "browser" },
                        ["c"] = { ":Octo issue close<CR>", "close" },
                        ["e"] = { ":Octo issue edit<CR>", "edit" },
                        ["l"] = { ":Octo issue list<CR>", "list" },
                        ["o"] = { ":Octo issue reopen<CR>", "reopen" },
                        ["r"] = { ":Octo issue reload<CR>", "reload" },
                        ["s"] = { ":Octo issue search<CR>", "search" },
                        ["u"] = { ":Octo issue url<CR>", "url" },
                    },
                    ["l"] = {
                        ["name"] = "+label",
                        ["a"] = { ":Octo label add<CR>", "add" },
                        ["c"] = { ":Octo label create<CR>", "create" },
                        ["r"] = { ":Octo label remove<CR>", "remove" },
                    },
                    ["p"] = {
                        ["name"] = "+pull-requests",
                        ["a"] = { ":Octo pr create<CR>", "create" },
                        ["b"] = { ":Octo pr browser<CR>", "browser" },
                        ["c"] = { ":Octo pr checkout<CR>", "checkout" },
                        ["C"] = { ":Octo pr close<CR>", "close" },
                        ["d"] = { ":Octo pr diff<CR>", "diff" },
                        ["D"] = { ":Octo pr checks<CR>", "checks" },
                        ["e"] = { ":Octo pr edit<CR>", "edit" },
                        ["g"] = { ":Octo pr commits<CR>", "commits" },
                        ["h"] = { ":Octo pr changes<CR>", "changes" },
                        ["l"] = { ":Octo pr list<CR>", "list" },
                        ["m"] = { ":Octo pr merge<CR>", "merge" },
                        ["o"] = { ":Octo pr reopen<CR>", "reopen" },
                        ["r"] = { ":Octo pr reload<CR>", "reload" },
                        ["R"] = { ":Octo pr ready<CR>", "ready" },
                        ["s"] = { ":Octo pr search<CR>", "search" },
                        ["u"] = { ":Octo pr url<CR>", "url" },
                    },
                    ["r"] = {
                        ["name"] = "+review",
                        ["a"] = { ":Octo reviewer add<CR>", "add-reviewer" },
                        ["b"] = { ":Octo review start<CR>", "start-review" },
                        ["c"] = {
                            ":Octo review comments<CR>",
                            "comments-review",
                        },
                        ["d"] = {
                            ":Octo review discard<CR>",
                            "discard-review",
                        },
                        ["r"] = {
                            ":Octo review resume<CR>",
                            "resume-review",
                        },
                        ["s"] = {
                            ":Octo review submit<CR>",
                            "submit-review",
                        },
                    },
                    ["R"] = {
                        ["name"] = "+repositories",
                        ["b"] = { ":Octo repo browser<CR>", "browser" },
                        ["f"] = { ":Octo repo fork<CR>", "fork" },
                        ["l"] = { ":Octo repo list<CR>", "list" },
                        ["u"] = { ":Octo repo url<CR>", "url" },
                    },
                    ["t"] = {
                        ["name"] = "+thread",
                        ["r"] = { ":Octo thread resolve<CR>", "resolve" },
                        ["u"] = {
                            ":Octo thread unresolve<CR>",
                            "unresolve",
                        },
                    },
                },
            }, { mode = "n", prefix = "<leader>" })
        end,
    },

    { --[[ worktree ]]
        "ThePrimeagen/git-worktree.nvim",
        keys = {
            "<leader>gwa",
            "<leader>gwl",
        },
        init = function()
            require("telescope").load_extension("git_worktree")

            local wk = require("which-key")
            wk.register({
                ["g"] = {
                    ["w"] = {
                        ["name"] = "+worktree",
                        ["a"] = {
                            ":Telescope git_worktree create_git_worktree<CR>",
                            "create-worktree",
                        },
                        ["l"] = {
                            ":Telescope git_worktree git_worktrees<CR>",
                            "list-worktrees",
                        },
                    },
                },
            }, { mode = "n", prefix = "<leader>" })
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
