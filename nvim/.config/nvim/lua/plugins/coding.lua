return {
    { --[[ chatgpt ]]
        "jackMort/ChatGPT.nvim",
        cmd = {
            "ChatGPT",
            "ChatGPTRun",
            "ChatGPTActAs",
            "ChatGPTEditWithInstructions",
        },
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            popup_input = {
                submit = "<Enter>",
            },
        },
    },

    { --[[ backseat ]]
        "james1236/backseat.nvim",
        cmd = {
            "Backseat",
            "BackseatAsk",
            "BackseatClear",
            "BackseatClearLine",
        },
        config = true,
    },

    { --[[ codegpt ]]
        "dpayne/CodeGPT.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        cmd = { "Chat" },
        config = function()
            require("codegpt.config")
        end,
    },

    { --[[ python-indent ]]
        "Vimjas/vim-python-pep8-indent",
        ft = "python",
    },

    { --[[ markdowny ]]
        "antonk52/markdowny.nvim",
        ft = { "markdown" },
        keys = {
            { "<C-b>", mode = { "v", "n" } },
            { "<C-k>", mode = { "v", "n" } },
            { "<C-i>", mode = { "v", "n" } },
        },
        opts = {},
    },

    { --[[ markdown-preview ]]
        "iamcco/markdown-preview.nvim",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        keys = {
            { "<leader>am", ":MarkdownPreview<CR>", desc = "markdown-preview", silent = true },
        },
    },

    { --[[ go ]]
        "ray-x/go.nvim",
        ft = "go",
    },

    { --[[ neogen ]]
        "danymat/neogen",
        keys = {
            {
                "<localleader>dd",
                ":Neogen<CR>",
                desc = "doc-this",
                silent = true,
            },
            {
                "<localleader>dc",
                function()
                    require("neogen").generate({ type = "class" })
                end,
                desc = "doc-this-class",
                silent = true,
            },
            {
                "<localleader>df",
                function()
                    require("neogen").generate({ type = "func" })
                end,
                desc = "doc-this-function",
                silent = true,
            },
            {
                "<localleader>dt",
                function()
                    require("neogen").generate({ type = "type" })
                end,
                desc = "doc-this-type",
                silent = true,
            },
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
        keys = {
            {
                "<leader>rd",
                function()
                    require("refactoring").debug.cleanup()
                end,
                mode = { "n", "v" },
                desc = "delete-print-var",
            },
            {
                "<leader>rk",
                function()
                    require("refactoring").debug.printf({ below = false })
                end,
                mode = { "n", "v" },
                desc = "printf-above",
            },
            {
                "<leader>rj",
                function()
                    require("refactoring").debug.printf()
                end,
                mode = { "n", "v" },
                desc = "printf-below",
            },
            {
                "<leader>rp",
                function()
                    require("refactoring").debug.print_var()
                end,
                mode = { "n", "v" },
                desc = "print-var",
            },
            {
                "<leader>rr",
                function()
                    require("refactoring").select_refactor()
                end,
                mode = { "n", "v" },
                desc = "list-refactors",
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

    { --[[ debugprint ]]
        "andrewferrier/debugprint.nvim",
        keys = {
            "g?",
            { "g?", mode = "v" },
        },
        cmd = { "DeleteDebugPrints" },
        opts = {},
        enabled = false,
    },

    { --[[ oversser ]]
        "stevearc/overseer.nvim",
        keys = {
            { "<leader>roa", ":OverseerTaskAction<CR>", desc = "task-action", silent = true },
            { "<leader>rob", ":OverseerBuild<CR>", desc = "build", silent = true },
            { "<leader>roc", ":OverseerClose<CR>", desc = "close", silent = true },
            { "<leader>rod", ":OverseerDeleteBundle<CR>", desc = "delete-bundle", silent = true },
            { "<leader>rof", ":OverseerRunCmd<CR>", desc = "run-cmd", silent = true },
            { "<leader>rol", ":OverseerLoadBundle<CR>", desc = "load-bundle", silent = true },
            { "<leader>roo", ":OverseerOpen<CR>", desc = "open", silent = true },
            { "<leader>roq", ":OverseerQuickAction<CR>", desc = "quick-action", silent = true },
            { "<leader>ror", ":OverseerRun<CR>", desc = "run", silent = true },
            { "<leader>ros", ":OverseerSaveBundle ", desc = "save-bundle", silent = true },
            { "<leader>rot", ":OverseerToggle<CR>", desc = "toggle", silent = true },
        },
        opts = {
            templates = { "tasks" },
        },
    },

    { --[[ neotest ]]
        "nvim-neotest/neotest",
        dependencies = {
            {
                "rcarriga/neotest-plenary",
                dependencies = "nvim-lua/plenary.nvim",
            },
            "haydenmeade/neotest-jest",
        },
        cmd = { "Neotest" },
        keys = {
            {
                "<leader>rf",
                function()
                    require("neotest").run.run(vim.fn.expand("%"))
                end,
                desc = "run-file",
                silent = true,
            },
            {
                "<leader>rF",
                function()
                    require("neotest").run.run({ vim.fn.expand("%"), concurrent = false })
                end,
                desc = "run-file-sync",
                silent = true,
            },
            {
                "<leader>rn",
                function()
                    require("neotest").jump.prev({ status = "failed" })
                end,
                desc = "next-failed",
                silent = true,
            },
            {
                "<leader>ro",
                function()
                    require("neotest").output.open({ enter = true, short = false })
                end,
                desc = "open",
                silent = true,
            },
            {
                "<leader>rp",
                function()
                    require("neotest").jump.next({ status = "failed" })
                end,
                desc = "prev-failed",
                silent = true,
            },
            {
                "<leader>rq",
                function()
                    require("neotest").run.stop({ interactive = true })
                end,
                desc = "cancel",
                silent = true,
            },
            {
                "<leader>rr",
                function()
                    require("neotest").run.run()
                end,
                desc = "nearest",
                silent = true,
            },
            {
                "<leader>rt",
                function()
                    require("neotest").summary.toggle()
                end,
                desc = "toggle-summary",
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
                quickfix = { enabled = false, open = true },
                adapters = {
                    require("neotest-jest")({
                        jestCommand = "npm test --",
                        env = { CI = true },
                        cwd = function()
                            return vim.fn.getcwd()
                        end,
                    }),
                },
                -- overseer.nvim
                consumers = {
                    overseer = require("neotest.consumers.overseer"),
                },
                overseer = {
                    enabled = true,
                    force_default = true,
                },
            })
        end,
        enabled = false,
    },

    { --[[ vim-sxhkdrc ]]
        "baskerville/vim-sxhkdrc",
        event = "BufRead sxhkdrc",
    },

    { --[[ sg.nvim ]]
        "sourcegraph/sg.nvim",
        keys = {
            {
                "<leader>sF",
                function()
                    require("sg.extensions.telescope").fuzzy_search_results()
                end,
                desc = "sourcegraph-fuzzy-search",
            },
            { "<leader>cC", "<cmd>CodyChat<CR>", desc = "cody-chat", mode = { "n", "x" } },
            { "<leader>ca", ":CodyAsk<space>", desc = "cody-ask", mode = { "n", "x" } },
            { "<leader>cc", "<cmd>CodyContext<CR>", desc = "cody-context", mode = { "n", "x" } },
            { "<leader>cd", ":CodyTask<space>", desc = "cody-task", mode = { "n", "x" } },
            { "<leader>cf", ":CodyFloat<space>", desc = "cody-float", mode = { "n", "x" } },
            { "<leader>cn", "<cmd>CodyTaskNext<CR>", desc = "cody-task-next", mode = { "n", "x" } },
            { "<leader>cp", "<cmd>CodyTaskPrev<CR>", desc = "cody-task-prev", mode = { "n", "x" } },
            { "<leader>ct", "<cmd>CodyToggle<CR>", desc = "cody-toggle", mode = { "n", "x" } },
            { "<leader>cv", "<cmd>CodyTaskView<CR>", desc = "cody-task-view", mode = { "n", "x" } },
            { "<leader>cy", "<cmd>CodyTaskAccept<CR>", desc = "cody-task-accept", mode = { "n", "x" } },
            { "<leader>sL", "<cmd>SourcegraphLink<CR>", desc = "sourcegraph-link" },
            { "<leader>sg", "<cmd>SourcegraphSearch<CR>", desc = "sourcegraph-search" },
        },
        build = "nvim -l build/init.lua",
        opts = {
            on_attach = require("plugins.lsp.utils").on_attach,
        },
    },
}
