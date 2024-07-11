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

    { --[[ codeium ]]
        "Exafunction/codeium.vim",
        event = "BufEnter",
        config = function()
            -- Change '<C-g>' here to any keycode you like.
            vim.keymap.set("i", "<Tab>", function()
                return vim.fn["codeium#Accept"]()
            end, { expr = true, silent = true })
            vim.keymap.set("i", "<c-;>", function()
                return vim.fn["codeium#CycleCompletions"](1)
            end, { expr = true, silent = true })
            vim.keymap.set("i", "<c-,>", function()
                return vim.fn["codeium#CycleCompletions"](-1)
            end, { expr = true, silent = true })
            vim.keymap.set("i", "<c-x>", function()
                return vim.fn["codeium#Clear"]()
            end, { expr = true, silent = true })

            vim.g.codeium_filetypes = {
                TelescopePrompt = false,
                DressingInput = false,
                ["chatgpt-input"] = false,
            }
        end,
    },

    { --[[ codecompanion ]]
        "olimorris/codecompanion.nvim",
        init = function()
            local wk = require("which-key")
            wk.register({
                ["a"] = { name = "+code-companion" },
            }, { mode = "n", prefix = "<localleader>" })
        end,
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
        opts = {},
    },
}
