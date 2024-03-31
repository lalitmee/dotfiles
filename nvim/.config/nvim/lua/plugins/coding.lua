local leet_arg = "leetcode.nvim"

return {
    { --[[ chatgpt ]]
        "jackMort/ChatGPT.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        keys = {
            { "<localleader>ca", ":ChatGPTRun add_tests<CR>", desc = "add-tests", silent = true },
            { "<localleader>cc", ":ChatGPT<CR>", desc = "chatgpt", silent = true },
            { "<localleader>cd", ":ChatGPTRun docstring<CR>", desc = "docstring", silent = true },
            { "<localleader>ce", ":ChatGPTEditWithInstructions<CR>", desc = "edit-instructions", silent = true },
            { "<localleader>cf", ":ChatGPTRun fix_bugs<CR>", desc = "fix-bugs", silent = true },
            { "<localleader>cg", ":ChatGPTRun grammar_correction<CR>", desc = "grammar-correction", silent = true },
            { "<localleader>ch", ":ChatGPTActAs<CR>", desc = "act-as", silent = true },
            { "<localleader>co", ":ChatGPTRun optimize_code<CR>", desc = "optimize-code", silent = true },
            { "<localleader>cr", ":ChatGPTRun<CR>", desc = "chatgpt-run", silent = true },
            { "<localleader>cs", ":ChatGPTRun summarize<CR>", desc = "summarize", silent = true },
            { "<localleader>ct", ":ChatGPTRun translate<CR>", desc = "translate", silent = true },
        },
        init = function()
            local wk = require("which-key")
            wk.register({
                ["c"] = { name = "+chatgpt" },
            }, { mode = "n", prefix = "<localleader>" })
        end,
        opts = {
            popup_input = {
                submit = "<Enter>",
            },
        },
    },

    { --[[ backseat ]]
        "james1236/backseat.nvim",
        keys = {
            { "<localleader>cb", ":Backseat<CR>", desc = "backseat", silent = true },
            { "<localleader>ck", ":BackseatAsk<CR>", desc = "backseat-ask", silent = true },
            { "<localleader>cl", ":BackseatClearLine<CR>", desc = "backseat-clear-line", silent = true },
            { "<localleader>cx", ":BackseatClear<CR>", desc = "backseat-clear", silent = true },
        },
        opts = {
            openai_api_key = os.getenv("OPENAI_API_KEY"),
        },
    },

    { --[[ python-indent ]]
        "NMAC427/guess-indent.nvim",
        event = { "BufReadPre" },
        cmd = { "GuessIndent" },
        opts = {},
    },

    { --[[ markdown-preview ]]
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        keys = {
            { "<leader>am", "<cmd>MarkdownPreview<cr>", desc = "markdown-preview", silent = true },
        },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },

    { --[[ go ]]
        "ray-x/go.nvim",
        ft = "go",
    },

    { --[[ neogen ]]
        "danymat/neogen",
        keys = {
            { "<leader>dd", "<cmd>Neogen<CR>", desc = "doc-this", silent = true },
            { "<leader>dc", "<cmd>Neogen class<cr>", desc = "doc-this-class", silent = true },
            { "<leader>df", "<cmd>Neogen func<cr>", desc = "doc-this-function", silent = true },
            { "<leader>dt", "<cmd>Neogen type<cr>", desc = "doc-this-type", silent = true },
        },
        init = function()
            local wk = require("which-key")
            wk.register({
                ["d"] = { name = "+docstring" },
            }, { mode = "n", prefix = "<leader>" })
        end,
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
        init = function()
            local wk = require("which-key")
            wk.register({
                ["ro"] = { name = "+overseer.nvim" },
            }, { mode = "n", prefix = "<leader>" })
        end,
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
                "<leader>rO",
                function()
                    require("neotest").output.open({ enter = true, short = false })
                end,
                desc = "open-neotest-output",
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
            {
                "<leader>cc",
                function()
                    require("sg.cody.commands").toggle()
                end,
                desc = "cody-chat",
                mode = { "n", "x" },
            },
            {
                "<leader>cN",
                function()
                    local name = vim.fn.input("chat name: ")
                    require("sg.cody.commands").chat(name)
                end,
                desc = "named-cody-chat",
                mode = { "n", "x" },
            },
            { "<leader>ca", ":CodyAsk<space>", desc = "cody-ask", mode = { "n", "x" } },
            { "<leader>cd", ":CodyTask<space>", desc = "cody-task", mode = { "n", "x" } },
            { "<leader>cn", "<cmd>CodyTaskNext<CR>", desc = "cody-task-next", mode = { "n", "x" } },
            { "<leader>cp", "<cmd>CodyTaskPrev<CR>", desc = "cody-task-prev", mode = { "n", "x" } },
            { "<leader>ct", "<cmd>CodyToggle<CR>", desc = "cody-toggle", mode = { "n", "x" } },
            { "<leader>cv", "<cmd>CodyTaskView<CR>", desc = "cody-task-view", mode = { "n", "x" } },
            { "<leader>cy", "<cmd>CodyTaskAccept<CR>", desc = "cody-task-accept", mode = { "n", "x" } },
            { "<leader>sL", "<cmd>SourcegraphLink<CR>", desc = "sourcegraph-link" },
            { "<leader>sg", "<cmd>SourcegraphSearch<CR>", desc = "sourcegraph-search" },
        },
        init = function()
            local wk = require("which-key")
            wk.register({
                ["c"] = { name = "+cody" },
            }, { mode = "n", prefix = "<leader>" })
        end,
        opts = {
            on_attach = require("plugins.lsp.utils").on_attach,
        },
    },

    { --[[ wtf.nvim ]]
        "piersolenski/wtf.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {
            openai_api_key = os.getenv("OPENAI_API_KEY"),
            popup_type = "vertical",
        },
        keys = {
            {
                "<leader>ea",
                mode = { "n", "x" },
                function()
                    require("wtf").ai()
                end,
                desc = "Debug diagnostic with AI",
            },
            {
                "<leader>es",
                mode = { "n" },
                function()
                    require("wtf").search()
                end,
                desc = "Search diagnostic with Google",
            },
        },
    },

    {
        "vhyrro/luarocks.nvim",
        priority = 1000,
        opts = {
            rocks = {
                "nvim-nio",
                "mimetypes",
                "xml2lua",
                "lua-curl",
            },
        },
    },

    { --[[ rest.nvim ]]
        "rest-nvim/rest.nvim",
        ft = { "http" },
        dependencies = { "luarocks.nvim" },
        -- stylua: ignore
        keys = {
            { "<leader>rhr", ":Rest run<CR>", silent = true, desc = "run-request" },
            { "<leader>rhl", ":Rest run last<CR>", silent = true, desc = "run-last-request" },
            { "<leader>rhe", ":Rest env<CR>", silent = true, desc = "env" },
            { "<leader>rhL", ":Rest logs<CR>", silent = true, desc = "logs" },
        },
        init = function()
            local wk = require("which-key")
            wk.register({
                ["rh"] = { name = "+rest.nvim" },
            }, { mode = "n", prefix = "<leader>" })
        end,
        config = function()
            require("rest-nvim").setup()
        end,
    },

    { --[[ leetcode.nvim ]]
        "kawre/leetcode.nvim",
        lazy = leet_arg ~= vim.fn.argv()[1],
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
        init = function()
            local wk = require("which-key")
            wk.register({
                ["cl"] = { name = "+leetcode" },
            }, { mode = "n", prefix = "<leader>" })
        end,
        opts = {
            arg = leet_arg,
        },
        -- enabled = false,
    },
}
