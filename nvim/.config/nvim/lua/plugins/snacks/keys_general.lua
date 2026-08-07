return {
    -- bufdelete
    {
        "<leader>bd",
        function()
            Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
        silent = true,
    },
    {
        "<leader>bD",
        function()
            Snacks.bufdelete.all()
        end,
        desc = "Delete All Buffers",
        silent = true,
    },
    {
        "<leader>bo",
        function()
            Snacks.bufdelete.other()
        end,
        desc = "Delete Other Buffers",
        silent = true,
    },

    -- git
    {
        "<leader>ge",
        function()
            Snacks.git.blame_line()
        end,
        desc = "Git Blame",
        silent = true,
    },
    {
        "<leader>gr",
        function()
            Snacks.git.get_root()
        end,
        desc = "Git Root",
        silent = true,
    },

    -- gitbrowse, lazygit
    {
        "<leader>ga",
        function()
            Snacks.gitbrowse()
        end,
        desc = "Git Browse",
        silent = true,
    },
    {
        "<leader>gl",
        function()
            Snacks.lazygit.open()
        end,
        desc = "Lazygit",
        silent = true,
    },
    {
        "<leader>gL",
        function()
            Snacks.lazygit.log()
        end,
        desc = "Lazygit Log View",
        silent = true,
    },
    {
        "<leader>gf",
        function()
            Snacks.lazygit.log_file()
        end,
        desc = "Lazygit Log File",
        silent = true,
    },

    -- notifier
    {
        "<leader>nd",
        function()
            Snacks.notifier.hide()
        end,
        desc = "Hide Notifier",
        silent = true,
    },
    {
        "<leader>nn",
        function()
            Snacks.notifier.show_history()
        end,
        desc = "Show Notifier History",
        silent = true,
    },

    -- scratch
    {
        "<leader>k.",
        function()
            Snacks.scratch()
        end,
        desc = "Scratch: Toggle Buffer",
    },
    {
        "<leader>k/",
        function()
            Snacks.scratch.select()
        end,
        desc = "Scratch: Select Buffer",
    },
    {
        "<leader>kn",
        function()
            Snacks.scratch.open({ icon = "󰎞 ", ft = "markdown", name = "Notes" })
        end,
        desc = "Scratch: Notes Buffer",
    },
    {
        "<leader>kt",
        function()
            local todo_file = require("utils.oslib").get_project_todo_path()
            Snacks.scratch.open({ icon = " ", ft = "markdown", name = "Todo", file = todo_file })
        end,
        desc = "Scratch: Todos Buffer",
    },

    -- github issues and prs
    {
        "<leader>gi",
        function()
            Snacks.picker.gh_issue()
        end,
        desc = "GitHub Issues (open)",
    },
    {
        "<leader>gI",
        function()
            Snacks.picker.gh_issue({ state = "all" })
        end,
        desc = "GitHub Issues (all)",
    },
    {
        "<leader>gp",
        function()
            Snacks.picker.gh_pr()
        end,
        desc = "GitHub Pull Requests (open)",
    },
    {
        "<leader>gP",
        function()
            Snacks.picker.gh_pr({ state = "all" })
        end,
        desc = "GitHub Pull Requests (all)",
    },

    -- neovim news
    {
        "<leader>N",
        desc = "Neovim News",
        function()
            Snacks.win({
                style = {
                    border = "rounded",
                },
                file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
                width = 0.6,
                height = 0.6,
                wo = {
                    spell = false,
                    wrap = false,
                    signcolumn = "yes",
                    statuscolumn = " ",
                    conceallevel = 3,
                },
            })
        end,
    },

    -- zen / zoom
    {
        "<leader>tz",
        function()
            Snacks.zen.toggle()
        end,
        desc = "Toggle Zen Mode",
    },
    {
        "<leader>tZ",
        function()
            Snacks.zoom.toggle()
        end,
        desc = "Toggle Zoom",
    },

    -- terminal commands
    {
        "<leader>a/",
        function()
            Snacks.terminal("serpl")
        end,
        desc = "Search and Replace",
        silent = true,
    },
    {
        "<leader>ab",
        function()
            Snacks.terminal("btm")
        end,
        desc = "Bottom",
        silent = true,
    },
    {
        "<leader>ad",
        function()
            Snacks.terminal("lazydocker")
        end,
        desc = "Lazydocker",
        silent = true,
    },
    {
        "<leader>af",
        function()
            Snacks.terminal("gh dash")
        end,
        desc = "GitHub Dashboard",
        silent = true,
    },
    {
        "<leader>ah",
        function()
            Snacks.terminal()
        end,
        desc = "Terminal",
        silent = true,
    },
    {
        "<leader>ai",
        function()
            Snacks.terminal("chatgpt -i")
        end,
        desc = "ChatGPT",
        silent = true,
    },
    {
        "<leader>av",
        function()
            Snacks.terminal(nil, { win = { position = "right" } })
        end,
        desc = "Terminal (right)",
        silent = true,
    },
    {
        "<leader>gt",
        function()
            Snacks.terminal("tig")
        end,
        desc = "Tig",
        silent = true,
    },
}