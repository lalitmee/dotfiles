local augroup = lk.augroup
local command = lk.command

-- local Job = require("plenary.job")

local neogit = {
    "TimUntersberger/neogit",
    cmd = { "Neogit" },
    -- enabled = false,
    config = function()
        -- setup
        require("neogit").setup({
            disable_commit_confirmation = true,
            integrations = { diffview = true },
        })

        -- commands
        command("Neogit", function()
            require("neogit").open()
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

local fugitive = {
    "tpope/vim-fugitive",
    cmd = { "Git" },
}

local gitsigns = {
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
}

local octo = {
    "pwntester/octo.nvim",
    cmd = { "Octo" },
    config = true,
    init = function()
        local wk = require("which-key")
        wk.register({
            ["g"] = {
                ["o"] = {
                    ["name"] = "+octo.nvim",
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
                    ["c"] = {
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
                        ["name"] = "+repositories",
                        ["b"] = { ":Octo repo browser<CR>", "browser" },
                        ["f"] = { ":Octo repo fork<CR>", "fork" },
                        ["l"] = { ":Octo repo list<CR>", "list" },
                        ["u"] = { ":Octo repo url<CR>", "url" },
                    },
                    ["R"] = {
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
                    ["t"] = {
                        ["name"] = "+thread",
                        ["r"] = { ":Octo thread resolve<CR>", "resolve" },
                        ["u"] = {
                            ":Octo thread unresolve<CR>",
                            "unresolve",
                        },
                    },
                },
            },
        }, { mode = "n", prefix = "<leader>" })
    end,
}

local gh_nvim = {
    "ldelossa/gh.nvim",
    dependencies = { "ldelossa/litee.nvim" },
    cmd = {
        "GHOpenIssue",
        "GHOpenPR",
        "GHSearchIssues",
        "GHSearchPRs",
    },
    config = function()
        require("litee.lib").setup()
        require("litee.gh").setup()
    end,
    init = function()
        local wk = require("which-key")
        wk.register({
            ["g"] = {
                ["a"] = {
                    ["name"] = "+gh.nvim",
                    ["c"] = {
                        ["name"] = "+Commits",
                        ["c"] = { "<cmd>GHCloseCommit<cr>", "Close" },
                        ["e"] = { "<cmd>GHExpandCommit<cr>", "Expand" },
                        ["o"] = { "<cmd>GHOpenToCommit<cr>", "Open To" },
                        ["p"] = { "<cmd>GHPopOutCommit<cr>", "Pop Out" },
                        ["z"] = { "<cmd>GHCollapseCommit<cr>", "Collapse" },
                    },
                    ["i"] = {
                        ["name"] = "+Issues",
                        ["p"] = { "<cmd>GHPreviewIssue<cr>", "Preview" },
                    },
                    ["l"] = {
                        ["name"] = "+Litee",
                        ["t"] = { "<cmd>LTPanel<cr>", "Toggle Panel" },
                    },
                    ["r"] = {
                        ["name"] = "+Review",
                        ["b"] = { "<cmd>GHStartReview<cr>", "Begin" },
                        ["c"] = { "<cmd>GHCloseReview<cr>", "Close" },
                        ["d"] = { "<cmd>GHDeleteReview<cr>", "Delete" },
                        ["e"] = { "<cmd>GHExpandReview<cr>", "Expand" },
                        ["s"] = { "<cmd>GHSubmitReview<cr>", "Submit" },
                        ["z"] = { "<cmd>GHCollapseReview<cr>", "Collapse" },
                    },
                    ["p"] = {
                        ["name"] = "+Pull Request",
                        ["c"] = { "<cmd>GHClosePR<cr>", "Close" },
                        ["d"] = { "<cmd>GHPRDetails<cr>", "Details" },
                        ["e"] = { "<cmd>GHExpandPR<cr>", "Expand" },
                        ["o"] = { "<cmd>GHOpenPR<cr>", "Open" },
                        ["p"] = { "<cmd>GHPopOutPR<cr>", "PopOut" },
                        ["r"] = { "<cmd>GHRefreshPR<cr>", "Refresh" },
                        ["t"] = { "<cmd>GHOpenToPR<cr>", "Open To" },
                        ["z"] = { "<cmd>GHCollapsePR<cr>", "Collapse" },
                    },
                    ["t"] = {
                        ["name"] = "+Threads",
                        ["c"] = { "<cmd>GHCreateThread<cr>", "Create" },
                        ["n"] = { "<cmd>GHNextThread<cr>", "Next" },
                        ["t"] = { "<cmd>GHToggleThread<cr>", "Toggle" },
                    },
                },
            },
        }, { mode = "n", prefix = "<leader>" })
    end,
}

local worktrees = {
    "ThePrimeagen/git-worktree.nvim",
    keys = {
        "<leader>gwa",
        "<leader>gwl",
    },
    -- cmd = {
    --     "CreateWorktree",
    -- },
    init = function()
        require("telescope").load_extension("git_worktree")

        -- lk.command("CreateWorktree", function(args)
        --     local path = args["fargs"][1]
        --     local branch = args["fargs"][2]
        --     local from = args["fargs"][3]
        --     require("git-worktree").create_worktree(path, branch, from)
        -- end, {
        --     nargs = "*",
        --     complete = function(_, line)
        --         local l = vim.split(line, "%s+")
        --         print("DEBUGPRINT[3]: init.lua:486: line=" .. vim.inspect(line))
        --         print("DEBUGPRINT[2]: init.lua:486: l=" .. vim.inspect(l))
        --         local n = #l - 3
        --         print("DEBUGPRINT[1]: init.lua:487: n=" .. vim.inspect(n))
        --         if n == 3 then
        --             local stdout, _ = Job
        --                 :new({
        --                     command = "git",
        --                     args = { "branch", "--format", "%(refname:short)" },
        --                     cwd = vim.fn.getcwd(),
        --                 })
        --                 :sync()
        --             local branches = {}
        --             for _, branch in ipairs(stdout) do
        --                 table.insert(branches, branch)
        --             end
        --             return branches
        --         end
        --     end,
        -- })

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
}

local diffview = {
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
}

return {
    diffview,
    fugitive,
    gh_nvim,
    gitsigns,
    neogit,
    octo,
    worktrees,
}
