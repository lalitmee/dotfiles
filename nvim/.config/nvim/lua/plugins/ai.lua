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
            { "<localleader>ac", ":CodeCompanion<CR>", desc = "code-companion", silent = true },
            { "<localleader>ab", ":CodeCompanionWithBuffers<CR>", desc = "code-companion-with-buffers", silent = true },
            { "<localleader>aw", ":CodeCompanionChat<CR>", desc = "code-companion-chat", silent = true },
            { "<localleader>aa", ":CodeCompanionAdd<CR>", desc = "code-companion-add", silent = true },
            { "<localleader>at", ":CodeCompanionToggle<CR>", desc = "code-companion-toggle", silent = true },
            { "<localleader>as", ":CodeCompanionActions<CR>", desc = "code-companion-actions", silent = true },
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
