return {
    { --[[ chatgpt ]]
        "jackMort/ChatGPT.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        keys = {
            { "<localleader>ca", ":ChatGPTRun add_tests<CR>", desc = "Add Tests", silent = true },
            { "<localleader>cc", ":ChatGPT<CR>", desc = "Chatgpt", silent = true },
            { "<localleader>cd", ":ChatGPTRun docstring<CR>", desc = "Docstring", silent = true },
            { "<localleader>ce", ":ChatGPTEditWithInstructions<CR>", desc = "Edit Instructions", silent = true },
            { "<localleader>cf", ":ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs", silent = true },
            { "<localleader>cg", ":ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction", silent = true },
            { "<localleader>ch", ":ChatGPTActAs<CR>", desc = "Act As", silent = true },
            { "<localleader>co", ":ChatGPTRun optimize_code<CR>", desc = "Optimize Code", silent = true },
            { "<localleader>cr", ":ChatGPTRun<CR>", desc = "Chatgpt Run", silent = true },
            { "<localleader>cs", ":ChatGPTRun summarize<CR>", desc = "Summarize", silent = true },
            { "<localleader>ct", ":ChatGPTRun translate<CR>", desc = "Translate", silent = true },
        },
        opts = {
            popup_input = {
                submit = "<Enter>",
            },
        },
    },

    { --[[ backseat ]]
        enabled = false,
        "james1236/backseat.nvim",
        keys = {
            { "<localleader>cb", ":Backseat<CR>", desc = "Backseat", silent = true },
            { "<localleader>ck", ":BackseatAsk<space>", desc = "Backseat Ask", silent = true },
            { "<localleader>cl", ":BackseatClearLine<CR>", desc = "Backseat Clear Line", silent = true },
            { "<localleader>cx", ":BackseatClear<CR>", desc = "Backseat Clear", silent = true },
        },
        opts = {
            openai_api_key = os.getenv("OPENAI_API_KEY"),
        },
    },

    { --[[ codeium ]]
        "Exafunction/codeium.vim",
        event = "BufEnter",
        config = function()
            vim.g.codeium_filetypes_disabled_by_default = true
            vim.g.codeium_filetypes = {
                c = true,
                cpp = true,
                gitcommit = true,
                go = true,
                javascript = true,
                javascriptreact = true,
                lua = true,
                python = true,
                rust = true,
                typescript = true,
                typescriptreact = true,
                vim = true,
                yaml = true,
            }
            vim.keymap.set("i", "<Tab>", function()
                return vim.fn["codeium#Accept"]()
            end, { expr = true, silent = true })
        end,
    },

    { --[[ codecompanion.nvim ]]
        "olimorris/codecompanion.nvim",
        cmd = {
            "CodeCompanion",
            "CodeCompanionWithBuffers",
            "CodeCompanionChat",
            "CodeCompanionActions",
        },
        -- stylua: ignore
        keys = {
            { "<leader>ca", ":CodeCompanionActions<CR>", desc = "Code Companion Actions", silent = true, mode = { "n", "v" } },
            { "<leader>cc", ":CodeCompanionChat<CR>", desc = "Code Companion Chat", silent = true, mode = { "n", "v" } },
            { "<leader>cd", ":CodeCompanionCmd<CR>", desc = "Code Companion Cmd", silent = true, mode = { "n", "v" } },
            { "<leader>ci", ":CodeCompanion<CR>", desc = "Code Companion (Inline)", silent = true, mode = { "n", "v" } },
        },
        init = function()
            vim.cmd([[cab cc CodeCompanion]])
        end,
        -- TODO: add config for adapters and use `Gemini` for the default adapter
        opts = {
            strategies = {
                chat = {
                    adapter = "openai",
                },
                inline = {
                    adapter = "openai",
                },
                agent = {
                    adapter = "openai",
                },
            },
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
            {
                "<leader>eh",
                function()
                    require("wtf").history()
                end,
                desc = "Populate the quickfix list with previous chat history",
            },
            {
                "<leader>eg",
                function()
                    require("wtf").grep_history()
                end,
                desc = "Grep previous chat history with Telescope",
            },
        },
    },

    { --[[ avante.nvim ]]
        enabled = false,
        "yetone/avante.nvim",
        dependencies = {
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        build = "make",
        event = "VeryLazy",
        opts = {
            provider = "openai",
        },
    },

    { -- [[ copilot.lua ]]
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "InsertEnter",
        opts = {
            suggestion = {
                enabled = false,
                keymap = {
                    accept = "<Tab>",
                    next = "<C-n>",
                    prev = "<C-p>",
                    dismiss = "<C-]>",
                },
            },
            panel = { enabled = false },
            filetypes = {
                markdown = true,
                help = true,
            },
        },
    },

    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            "zbirenbaum/copilot.lua",
        },
        build = "make tiktoken",
        cmd = {
            "CopilotChat",
            "CopilotChatToggle",
        },
        keys = {
            { "<leader>cg", ":CopilotChatToggle<CR>", desc = "Github Copilot Chat Toggle", silent = true },
        },
        opts = {},
    },
}
