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
        "james1236/backseat.nvim",
        keys = {
            { "<localleader>cb", ":Backseat<CR>", desc = "Backseat", silent = true },
            { "<localleader>ck", ":BackseatAsk<CR>", desc = "Backseat Ask", silent = true },
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

    { --[[ codecompanion ]]
        "olimorris/codecompanion.nvim",
        cmd = {
            "CodeCompanion",
            "CodeCompanionWithBuffers",
            "CodeCompanionChat",
            "CodeCompanionAdd",
            "CodeCompanionToggle",
            "CodeCompanionActions",
        },
        keys = {
            { "<localleader>ac", ":CodeCompanion<CR>", desc = "Code Companion", silent = true },
            { "<localleader>ab", ":CodeCompanionWithBuffers<CR>", desc = "Code Companion With Buffers", silent = true },
            { "<localleader>aw", ":CodeCompanionChat<CR>", desc = "Code Companion Chat", silent = true },
            { "<localleader>aa", ":CodeCompanionAdd<CR>", desc = "Code Companion Add", silent = true },
            { "<localleader>at", ":CodeCompanionToggle<CR>", desc = "Code Companion Toggle", silent = true },
            { "<localleader>as", ":CodeCompanionActions<CR>", desc = "Code Companion Actions", silent = true },
        },
        -- TODO: add config for adapters and use `Gemini` for the default adapter
        opts = {
            strategies = {
                chat = {
                    adapter = "gemini",
                },
                inline = {
                    adapter = "gemini",
                },
                agent = {
                    adapter = "gemini",
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
}
