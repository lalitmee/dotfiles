return { --[[ snacks.nvim ]]
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    keys = {
        -- bufdelete
        { -- [[ Delete Buffer ]]
            "<leader>bd",
            function()
                Snacks.bufdelete()
            end,
            desc = "Delete Buffer",
            silent = true,
        },
        { -- [[ Delete All Buffers ]]
            "<leader>bD",
            function()
                Snacks.bufdelete.all()
            end,
            desc = "Delete All Buffers",
            silent = true,
        },
        { -- [[ Delete Other Buffers ]]
            "<leader>bo",
            function()
                Snacks.bufdelete.other()
            end,
            desc = "Delete Other Buffers",
            silent = true,
        },

        -- git
        { -- [[ Git Blame Line ]]
            "<leader>ge",
            function()
                Snacks.git.blame_line()
            end,
            desc = "Git Blame",
            silent = true,
        },
        { -- [[ Get Git Root ]]
            "<leader>gr",
            function()
                Snacks.git.get_root()
            end,
            desc = "Git Root",
            silent = true,
        },

        -- gitbrowse, lazygit
        { -- [[ Git Browse ]]
            "<leader>ga",
            function()
                Snacks.gitbrowse()
            end,
            desc = "Git Browse",
            silent = true,
        },
        { -- [[ Open Lazygit ]]
            "<leader>gl",
            function()
                Snacks.lazygit.open()
            end,
            desc = "Lazygit",
            silent = true,
        },
        { -- [[ Lazygit Log View ]]
            "<leader>gL",
            function()
                Snacks.lazygit.log()
            end,
            desc = "Lazygit Log View",
            silent = true,
        },
        { -- [[ Lazygit Log File ]]
            "<leader>gf",
            function()
                Snacks.lazygit.log_file()
            end,
            desc = "Lazygit Log File",
            silent = true,
        },

        -- notifier
        { -- [[ Hide Notifier ]]
            "<leader>nd",
            function()
                Snacks.notifier.hide()
            end,
            desc = "Hide Notifier",
            silent = true,
        },
        { -- [[ Show Notifier History ]]
            "<leader>nn",
            function()
                Snacks.notifier.show_history()
            end,
            desc = "Show Notifier History",
            silent = true,
        },

        -- scratch
        { -- [[ Toggle Scratch Buffer ]]
            "<leader>k.",
            function()
                Snacks.scratch()
            end,
            desc = "Scratch: Toggle Buffer",
        },
        { -- [[ Select Scratch Buffer ]]
            "<leader>k/",
            function()
                Snacks.scratch.select()
            end,
            desc = "Scratch: Select Buffer",
        },
        { -- [[ Scratch Notes Buffer ]]
            "<leader>kn",
            function()
                Snacks.scratch.open({ icon = "󰎞 ", ft = "markdown", name = "Notes" })
            end,
            desc = "Scratch: Notes Buffer",
        },
        { -- [[ Scratch Todos Buffer ]]
            "<leader>kt",
            function()
                Snacks.scratch.open({ icon = " ", ft = "markdown", name = "Todo" })
            end,
            desc = "Scratch: Todos Buffer",
        },

        -- github issues and prs
        { -- [[ Open GitHub Issues (Current Repo) ]]
            "<leader>gi",
            function()
                Snacks.picker.gh_issue()
            end,
            desc = "GitHub Issues (open)",
        },
        { -- [[ Open GitHub Issues (All Repos) ]]
            "<leader>gI",
            function()
                Snacks.picker.gh_issue({ state = "all" })
            end,
            desc = "GitHub Issues (all)",
        },
        { -- [[ Open GitHub Pull Requests (Current Repo) ]]
            "<leader>gp",
            function()
                Snacks.picker.gh_pr()
            end,
            desc = "GitHub Pull Requests (open)",
        },
        { -- [[ Open GitHub Pull Requests (All Repos) ]]
            "<leader>gP",
            function()
                Snacks.picker.gh_pr({ state = "all" })
            end,
            desc = "GitHub Pull Requests (all)",
        },

        -- {
        --     "<leader><leader>",
        --     function()
        --         Snacks.picker.smart()
        --     end,
        --     desc = "Find Files",
        -- },

        { -- [[ Neovim News ]]
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
    },

    opts = {
        scope = { enabled = true },
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
        scroll = {
            -- it has some bug with my setup, when I reach to the bottom of a
            -- file and then try to scroll up, it doesn't work and it seems that
            -- its stuck at the bottom until I press gg to go to the top of the file
            enabled = false,
        },
        styles = {
            notification = {
                wo = { wrap = true }, -- Wrap notifications
            },
            scratch = {
                width = 120,
                height = 30,
                border = "rounded",
            },
        },
        -- scroll = {
        --     enabled = true,
        -- },
        image = {
            enabled = true,
        },
        picker = {
            enabled = true,
            win = {
                input = {
                    keys = {
                        ["<Esc>"] = { "close", mode = { "n", "i" } },
                    },
                },
            },
        },
        gh = {
            enabled = true,
        },
    },

    init = function()
        local wk = require("which-key")
        wk.add({
            { "<leader>k", group = "scratch" },

            {
                "<leader>jn",
                function()
                    Snacks.words.jump(1, true)
                end,
                desc = "Snacks: Jump to Word Reference Next",
            },
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "OilActionsPost",
            callback = function(event)
                if event.data.actions[1].type == "move" then
                    Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
                end
            end,
        })

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
                    :map("<leader>tC")
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
