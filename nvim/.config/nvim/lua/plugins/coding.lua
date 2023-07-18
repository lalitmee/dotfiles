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

    { --[[ code-explain ]]
        "mthbernardes/codeexplain.nvim",
        cmd = { "CodeExplain" },
        build = function()
            vim.cmd([[silent UpdateRemotePlugins]])
        end,
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
            { "<C-b>", mode = "v" },
            { "<C-k>", mode = "v" },
            { "<C-i>", mode = "v" },
        },
        opts = {},
    },

    { --[[ markdown-preview ]]
        "iamcco/markdown-preview.nvim",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        ft = "markdown",
        cmd = { "MarkdownPreview" },
    },

    { --[[ go ]]
        "ray-x/go.nvim",
        ft = "go",
    },

    { --[[ neogen ]]
        "danymat/neogen",
        cmd = { "Neogen" },
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
        init = function()
            local neogen = require("neogen")
            local wk = require("which-key")
            wk.register({
            -- stylua: ignore
            ["d"] = {
                ["name"] = "+docstrings",
                ["d"] = { ":Neogen<CR>", "doc-this" },
                ["c"] = { function() neogen.generate({ type = "class" }) end, "doc-this-class" },
                ["f"] = { function() neogen.generate({ type = "func" }) end, "doc-this-function" },
                ["t"] = { function() neogen.generate({ type = "type" }) end, "doc-this-type" },
            },
            }, { mode = "n", prefix = "<localleader>" })
        end,
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
                },
                javascriptreact = {
                    "console.log('%s', %s)",
                    "console.log('%s', { %s })",
                },
                typescript = {
                    "console.log('%s', %s)",
                    "console.log('%s', { %s })",
                },
                typescriptreact = {
                    "console.log('%s', %s)",
                    "console.log('%s', { %s })",
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
    },

    { --[[ oversser ]]
        "stevearc/overseer.nvim",
        cmd = {
            "OverseerTaskAction",
            "OverseerBuild",
            "OverseerClose",
            "OverseerDeleteBundle",
            "OverseerRunCmd",
            "OverseerLoadBundle",
            "OverseerOpen",
            "OverseerQuickAction",
            "OverseerRun",
            "OverseerSaveBundle",
            "OverseerToggle",
        },
        init = function()
            local wk = require("which-key")
            wk.register({
                ["r"] = {
                    ["o"] = {
                        ["name"] = "+overseer",
                        ["a"] = { ":OverseerTaskAction<CR>", "task-action" },
                        ["b"] = { ":OverseerBuild<CR>", "build" },
                        ["c"] = { ":OverseerClose<CR>", "close" },
                        ["d"] = { ":OverseerDeleteBundle<CR>", "delete-bundle" },
                        ["f"] = { ":OverseerRunCmd<CR>", "run-cmd" },
                        ["l"] = { ":OverseerLoadBundle<CR>", "load-bundle" },
                        ["o"] = { ":OverseerOpen<CR>", "open" },
                        ["q"] = { ":OverseerQuickAction<CR>", "quick-action" },
                        ["r"] = { ":OverseerRun<CR>", "run" },
                        ["s"] = { ":OverseerSaveBundle ", "save-bundle" },
                        ["t"] = { ":OverseerToggle<CR>", "toggle" },
                    },
                },
            }, { mode = "n", prefix = "<leader>" })
        end,
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
        init = function()
            local function neotest()
                return require("neotest")
            end
            local function open()
                neotest().output.open({ enter = true, short = false })
            end
            local function run_file()
                neotest().run.run(vim.fn.expand("%"))
            end
            local function run_file_sync()
                neotest().run.run({ vim.fn.expand("%"), concurrent = false })
            end
            local function nearest()
                neotest().run.run()
            end
            local function next_failed()
                neotest().jump.prev({ status = "failed" })
            end
            local function prev_failed()
                neotest().jump.next({ status = "failed" })
            end
            local function toggle_summary()
                neotest().summary.toggle()
            end
            local function cancel()
                neotest().run.stop({ interactive = true })
            end

            local wk = require("which-key")
            wk.register({
                ["n"] = {
                    ["name"] = "+neotest",
                    ["f"] = { run_file, "run-file" },
                    ["F"] = { run_file_sync, "run-file-sync" },
                    ["n"] = { next_failed, "next-failed" },
                    ["o"] = { open, "open" },
                    ["p"] = { prev_failed, "prev-failed" },
                    ["q"] = { cancel, "cancel" },
                    ["r"] = { nearest, "nearest" },
                    ["t"] = { toggle_summary, "toggle-summary" },
                },
            }, { mode = "n", prefix = "<localleader>" })
        end,
        enabled = false,
    },

    { --[[ vim-sxhkdrc ]]
        "baskerville/vim-sxhkdrc",
        event = "BufRead sxhkdrc",
    },

    { --[[ sg.nvim ]]
        "sourcegraph/sg.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>sg",
                function()
                    require("sg.telescope").fuzzy_search_results()
                end,
                desc = "sg-fuzzy-search",
            },
            {
                "<leader>sR",
                function()
                    require("sg.telescope").sg_references()
                end,
                desc = "sg-references-search",
            },
        },
        build = "cargo build --workspace && cargo build --bin sg-cody",
        opts = {
            on_attach = require("plugins.lsp.utils").on_attach,
        },
        enabled = false,
    },
}
