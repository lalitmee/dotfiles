return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    -- stylua: ignore
    keys = {
        -- bufdelete
        { "<leader>bd", function() Snacks.bufdelete() end, desc = "delete-buffer", silent = true },
        { "<leader>bD", function() Snacks.bufdelete.all() end, desc = "delete-all-buffers", silent = true },
        { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "delete-other-buffers", silent = true },

        -- git
        { "<leader>ge", function() Snacks.git.blame_line() end, desc = "git-blame", silent = true },
        { "<leader>gr", function() Snacks.git.get_root() end, desc = "git-root", silent = true },

        -- gitbrowse
        { "<leader>ga", function() Snacks.gitbrowse() end, desc = "git-browse", silent = true },

        -- lazygit
        { "<leader>gl", function() Snacks.lazygit.open() end, desc = "lazygit", silent = true },
        { "<leader>gL", function() Snacks.lazygit.log() end, desc = "lazygit-log-view", silent = true },
        { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "lazygit-log-file", silent = true },

        -- notifier
        { "<leader>nd", function() Snacks.notifier.hide() end, desc = "hide-notifier", silent = true },
        { "<leader>n/", function() Snacks.notifier.show_history() end, desc = "show-notifier-history", silent = true },

        { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
        { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    },
    opts = {
        bigfile = { enabled = true },
        dashboard = { enabled = false },
        notifier = {
            enabled = true,
            timeout = 3000,
            style = "compact",
            top_down = false,
            margin = { bottom = 1 },
            icons = {
                -- error = " ",
                -- warn = " ",
                -- info = " ",
                -- debug = " ",
                -- trace = " ",

                debug = " ",
                error = " ",
                info = " ",
                trace = "🖉",
                warn = " ",
            },
        },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        styles = {
            notification = {
                wo = { wrap = true }, -- Wrap notifications
            },
        },
    },
}
