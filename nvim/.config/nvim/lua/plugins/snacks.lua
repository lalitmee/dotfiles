return { --[[ snacks.nvim ]]
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    -- stylua: ignore
    keys = {
        -- bufdelete
        { "<leader>bd", function()Snacks.bufdelete()end, desc = "delete-buffer", silent = true,  },
        { "<leader>bD", function() Snacks.bufdelete.all() end, desc = "delete-all-buffers", silent = true },
        { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "delete-other-buffers", silent = true },

        -- git
        { "<leader>ge", function() Snacks.git.blame_line() end, desc = "git-blame", silent = true },
        { "<leader>gr", function() Snacks.git.get_root() end, desc = "git-root", silent = true },

        -- gitbrowse, lazygit
        { "<leader>ga", function() Snacks.gitbrowse() end, desc = "git-browse", silent = true },
        { "<leader>gl", function() Snacks.lazygit.open() end, desc = "lazygit", silent = true },
        { "<leader>gL", function() Snacks.lazygit.log() end, desc = "lazygit-log-view", silent = true },
        { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "lazygit-log-file", silent = true },

        -- notifier
        { "<leader>nd", function() Snacks.notifier.hide() end, desc = "hide-notifier", silent = true },
        { "<leader>nn", function() Snacks.notifier.show_history() end, desc = "show-notifier-history", silent = true },

        -- scratch
        { "<leader>k.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
        { "<leader>k/", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
        { "<leader>kc", function() Snacks.scratch.open({ ft = "markdown", name = "notes" }) end, desc = "Notes Scratch Buffer" },

        -- neovim news
        {
            "<leader>N",
            desc = "Neovim News",
            function()
                Snacks.win({
                    style = {},
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
        -- scroll = {},
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command

                -- Create some toggle mappings
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
                Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
                Snacks.toggle.diagnostics():map("<leader>td")
                Snacks.toggle.line_number():map("<leader>tl")
                Snacks.toggle
                    .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                    :map("<leader>tc")
                Snacks.toggle.treesitter():map("<leader>tt")
                Snacks.toggle
                    .option("background", { off = "light", on = "dark", name = "Dark Background" })
                    :map("<leader>tb")
                Snacks.toggle.inlay_hints():map("<leader>th")
                Snacks.toggle.indent():map("<leader>ti")
                Snacks.toggle.dim():map("<leader>tD")
            end,
        })
    end,
}
