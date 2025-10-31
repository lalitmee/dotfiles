local leet_arg = "leetcode.nvim"

return {

    { --[[ python-indent ]]
        "NMAC427/guess-indent.nvim",
        event = { "BufReadPre" },
        cmd = { "GuessIndent" },
        opts = {},
    },

    { --[[ markdown-preview ]]
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        ft = { "markdown" },
        keys = {
            { "<leader>am", "<cmd>MarkdownPreview<cr>", desc = "Markdown Preview", silent = true },
        },
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
    },

    { --[[ markdown.nvim: making markdown files beautiful ]]
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ft = { "markdown", "codecompanion" },
        cmd = { "RenderMarkdown" },
        keys = {
            { "<leader>tm", ":RenderMarkdown toggle<CR>", desc = "Render Markdown Toggle" },
        },
        opts = {
            render_modes = true,
            sign = {
                enabled = false,
            },
            latex = { enabled = false },
            overrides = {
                filetype = {
                    codecompanion = {
                        html = {
                            tag = {
                                buf = { icon = " ", highlight = "CodeCompanionChatIcon" },
                                file = { icon = " ", highlight = "CodeCompanionChatIcon" },
                                group = { icon = " ", highlight = "CodeCompanionChatIcon" },
                                help = { icon = "󰘥 ", highlight = "CodeCompanionChatIcon" },
                                image = { icon = " ", highlight = "CodeCompanionChatIcon" },
                                symbols = { icon = " ", highlight = "CodeCompanionChatIcon" },
                                tool = { icon = "󰯠 ", highlight = "CodeCompanionChatIcon" },
                                url = { icon = "󰌹 ", highlight = "CodeCompanionChatIcon" },
                            },
                        },
                    },
                },
            },
        },
    },

    { --[[ go ]]
        "ray-x/go.nvim",
        ft = "go",
    },

    { --[[ neogen ]]
        "danymat/neogen",
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<leader>d", group = "doc" },
            })
        end,
        keys = {
            { "<leader>dd", "<cmd>Neogen<CR>", desc = "Doc This", silent = true },
            { "<leader>dc", "<cmd>Neogen class<cr>", desc = "Doc This Class", silent = true },
            { "<leader>df", "<cmd>Neogen func<cr>", desc = "Doc This Function", silent = true },
            { "<leader>dt", "<cmd>Neogen type<cr>", desc = "Doc This Type", silent = true },
        },
        opts = {
            snippet_engine = "luasnip",
            enabled = true,
            languages = {
                lua = {
                    template = {
                        annotation_convention = "ldoc",
                    },
                },
                python = {
                    template = {
                        annotation_convention = "google_docstrings",
                    },
                },
                rust = {
                    template = {
                        annotation_convention = "rustdoc",
                    },
                },
                javascript = {
                    template = {
                        annotation_convention = "jsdoc",
                    },
                },
                typescript = {
                    template = {
                        annotation_convention = "tsdoc",
                    },
                },
                typescriptreact = {
                    template = {
                        annotation_convention = "tsdoc",
                    },
                },
            },
        },
    },

    { --[[ refactoring ]]
        "ThePrimeagen/refactoring.nvim",
        branch = "master",
        keys = {
            {
                "<leader>rp",
                function()
                    require("refactoring").debug.print_var()
                end,
                mode = { "n", "v" },
                desc = "Print Var",
            },
            {
                "<leader>rd",
                function()
                    require("refactoring").debug.cleanup()
                end,
                mode = { "n", "v" },
                desc = "Delete Print Var",
            },
            {
                "<leader>rj",
                function()
                    require("refactoring").debug.printf()
                end,
                mode = { "n", "v" },
                desc = "Printf Below",
            },
            {
                "<leader>rk",
                function()
                    require("refactoring").debug.printf({ below = false })
                end,
                mode = { "n", "v" },
                desc = "Printf Above",
            },
            {
                "<leader>rr",
                function()
                    require("refactoring").select_refactor()
                end,
                mode = { "n", "v" },
                desc = "List Refactors",
            },
        },
        opts = {
            print_var_statements = {
                javascript = {
                    "console.log('%s', %s)",
                    "console.log('%s', { %s })",
                    "console.log('%s', prettyDOM(%s))",
                },
                javascriptreact = {
                    "console.log('%s', %s)",
                    "console.log('%s', { %s })",
                    "console.log('%s', prettyDOM(%s))",
                },
                typescript = {
                    "console.log('%s', %s)",
                    "console.log('%s', { %s })",
                    "console.log('%s', prettyDOM(%s))",
                },
                typescriptreact = {
                    "console.log('%s', %s)",
                    "console.log('%s', { %s })",
                    "console.log('%s', prettyDOM(%s))",
                },
            },
        },
    },

    { --[[ oversser.nvim ]]
        "stevearc/overseer.nvim",
        tag = "v1.6.0",
        cmd = {
            "OverseerBuild",
            "OverseerClose",
            "OverseerDeleteBundle",
            "OverseerLoadBundle",
            "OverseerOpen",
            "OverseerQuickAction",
            "OverseerRun",
            "OverseerTaskAction",
            "OverseerToggle",
        },
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<leader>ro", group = "overseer" },
            })
        end,
        keys = {
            { "<leader>ro<leader>", ":OverseerQuickAction<CR>", desc = "Quick Action", silent = true },
            { "<leader>roa", ":OverseerTaskAction<CR>", desc = "Task Action", silent = true },
            { "<leader>rob", ":OverseerBuild<CR>", desc = "Build", silent = true },
            { "<leader>roc", ":OverseerRunCmd<CR>", desc = "Run Cmd", silent = true },
            { "<leader>rod", ":OverseerDeleteBundle<CR>", desc = "Delete Bundle", silent = true },
            { "<leader>rol", ":OverseerLoadBundle<CR>", desc = "Load Bundle", silent = true },
            { "<leader>roo", ":OverseerOpen<CR>", desc = "Open", silent = true },
            { "<leader>roq", ":OverseerClose<CR>", desc = "Close", silent = true },
            { "<leader>ror", ":OverseerRun<CR>", desc = "Run", silent = true },
            { "<leader>ros", ":OverseerSaveBundle ", desc = "Save Bundle", silent = true },
            { "<leader>roj", ":OverseerToggle bottom<CR>", desc = "Toggle On Bottom", silent = true },
            { "<leader>roh", ":OverseerToggle left<CR>", desc = "Toggle On Left", silent = true },
            { "<leader>ro;", ":OverseerToggle right<CR>", desc = "Toggle On Right", silent = true },
        },
        opts = {
            templates = { "tasks" },
        },
    },

    { --[[ neotest ]]
        "nvim-neotest/neotest",
        dependencies = {
            "rcarriga/neotest-plenary",
            "haydenmeade/neotest-jest",
        },
        cmd = { "Neotest" },
        keys = {
            {
                "<leader>rf",
                function()
                    require("neotest").run.run(vim.fn.expand("%"))
                end,
                desc = "Run File",
                silent = true,
            },
            {
                "<leader>rF",
                function()
                    require("neotest").run.run({ vim.fn.expand("%"), concurrent = false })
                end,
                desc = "Run File Sync",
                silent = true,
            },
            {
                "<leader>rn",
                function()
                    require("neotest").jump.prev({ status = "failed" })
                end,
                desc = "Next Failed",
                silent = true,
            },
            {
                "<leader>rO",
                function()
                    require("neotest").output.open({ enter = true, short = false })
                end,
                desc = "Open Neotest Output",
                silent = true,
            },
            {
                "<leader>rp",
                function()
                    require("neotest").jump.next({ status = "failed" })
                end,
                desc = "Prev Failed",
                silent = true,
            },
            {
                "<leader>rq",
                function()
                    require("neotest").run.stop({ interactive = true })
                end,
                desc = "Cancel",
                silent = true,
            },
            {
                "<leader>rr",
                function()
                    require("neotest").run.run()
                end,
                desc = "Nearest",
                silent = true,
            },
            {
                "<leader>rt",
                function()
                    require("neotest").summary.toggle()
                end,
                desc = "Toggle Summary",
                silent = true,
            },
        },
        config = function()
            local namespace = vim.api.nvim_create_namespace("neotest")
            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        return diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                    end,
                },
            }, namespace)
            require("neotest").setup({
                discovery = { enabled = true },
                diagnostic = { enabled = true },
                floating = { border = lk.style.border.rounded },
                quickfix = { enabled = true, open = true },
                adapters = {
                    require("neotest-jest")({
                        jestCommand = "npm run test",
                        env = { CI = true },
                        cwd = function()
                            return vim.fn.getcwd()
                        end,
                    }),
                },
                consumers = {
                    overseer = require("neotest.consumers.overseer"),
                },
            })
        end,
    },

    { --[[ vim-sxhkdrc ]]
        "baskerville/vim-sxhkdrc",
        event = "BufRead sxhkdrc",
    },

    { --[[ rest.nvim ]]
        "rest-nvim/rest.nvim",
        dependencies = {
            { "j-hui/fidget.nvim", opts = {} },
        },
        ft = { "http" },
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<leader>rh", group = "http" },
            })
        end,
        -- stylua: ignore
        keys = {
            { "<leader>rhr", ":Rest run<CR>", silent = true, desc = "Run Request" },
            { "<leader>rhl", ":Rest run last<CR>", silent = true, desc = "Run Last Request" },
            { "<leader>rhe", ":Rest env<CR>", silent = true, desc = "Env" },
            { "<leader>rhL", ":Rest logs<CR>", silent = true, desc = "Logs" },
        },
        config = function() end,
    },

    { --[[ leetcode.nvim ]]
        "kawre/leetcode.nvim",
        lazy = leet_arg ~= vim.fn.argv()[1],
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<leader>cl", group = "leetcode" },
            })
        end,
        keys = {
            { "<leader>cla", "<cmd>Leet<cr>", silent = true, mode = { "n" }, desc = "Leet menu" },
            { "<leader>clb", "<cmd>Leet lang<cr>", silent = true, mode = { "n" }, desc = "Leet lang" },
            { "<leader>clc", "<cmd>Leet console<cr>", silent = true, mode = { "n" }, desc = "Leet console" },
            { "<leader>cld", "<cmd>Leet desc toggle<cr>", silent = true, mode = { "n" }, desc = "Leet desc toggle" },
            { "<leader>cle", "<cmd>Leet desc status<cr>", silent = true, mode = { "n" }, desc = "Leet desc status" },
            { "<leader>cli", "<cmd>Leet info<cr>", silent = true, mode = { "n" }, desc = "Leet info" },
            { "<leader>clj", "<cmd>Leet random<cr>", silent = true, mode = { "n" }, desc = "Leet random" },
            { "<leader>clk", "<cmd>Leet daily<cr>", silent = true, mode = { "n" }, desc = "Leet daily" },
            { "<leader>cll", "<cmd>Leet list<cr>", silent = true, mode = { "n" }, desc = "Leet list" },
            {
                "<leader>clo",
                "<cmd>Leet cookie delete<cr>",
                silent = true,
                mode = { "n" },
                desc = "Leet cookie delete",
            },
            { "<leader>clr", "<cmd>Leet run<cr>", silent = true, mode = { "n" }, desc = "Leet run" },
            { "<leader>cls", "<cmd>Leet submit<cr>", silent = true, mode = { "n" }, desc = "Leet submit" },
            { "<leader>clf", "<cmd>Leet tabs<cr>", silent = true, mode = { "n" }, desc = "Leet tabs" },
            { "<leader>clt", "<cmd>Leet test<cr>", silent = true, mode = { "n" }, desc = "Leet test" },
            {
                "<leader>clu",
                "<cmd>Leet cookie update<cr>",
                silent = true,
                mode = { "n" },
                desc = "Leet cookie update",
            },
            { "<leader>clU", "<cmd>Leet cache update<cr>", silent = true, mode = { "n" }, desc = "Leet cache update" },
        },
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            arg = leet_arg,
            lang = "python3",
            theme = {
                ["normal"] = {
                    fg = "#EA4AAA",
                },
            },
        },
        -- enabled = false,
    },

    { --[[ json-to-types.nvim ]]
        "Redoxahmii/json-to-types.nvim",
        build = "sh install.sh npm",
        ft = "json",
        keys = {
            {
                "<leader>cU",
                "<CMD>ConvertJSONtoLang typescript<CR>",
                desc = "Convert JSON to TS",
                mode = { "n", "v" },
            },
            {
                "<leader>ct",
                "<CMD>ConvertJSONtoLangBuffer typescript<CR>",
                desc = "Convert JSON to TS Buffer",
                mode = { "n", "v" },
            },
        },
    },
}
