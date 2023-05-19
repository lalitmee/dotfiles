local chatgpt_nvim = {
    "jackMort/ChatGPT.nvim",
    cmd = {
        "ChatGPT",
        "ChatGPTRun",
        "ChatGPTActAs",
        "ChatGPTEditWithInstructions",
    },
    dependencies = { "MunifTanjim/nui.nvim" },
    init = function()
        lk.command("ChatGPTRun", function(opts)
            require("chatgpt").run_action(opts)
        end, {
            nargs = "*",
            range = true,
            complete = function()
                local match = {
                    "add_tests",
                    "docstring",
                    "fix_bugs",
                    "grammar_correction",
                    "optimize_code",
                    "summarize",
                    "translate",
                }
                return match
            end,
        })
    end,
    config = function()
        require("chatgpt").setup({
            popup_input = {
                submit = "<Enter>",
            },
        })
    end,
    enabled = false,
}

local neoai = {
    "Bryley/neoai.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    cmd = {
        "NeoAI",
        "NeoAIOpen",
        "NeoAIClose",
        "NeoAIToggle",
        "NeoAIContext",
        "NeoAIContextOpen",
        "NeoAIContextClose",
        "NeoAIInject",
        "NeoAIInjectCode",
        "NeoAIInjectContext",
        "NeoAIInjectContextCode",
        "NeoAIShortcut",
    },
    keys = {
        { "<leader>as", desc = "Summarize Text" },
        { "<leader>ag", desc = "Generate Git Message" },
    },
    opts = {
        open_api_key_env = vim.env.OPEN_API_KEY,
    },
    enabled = false,
}

local backseat = {
    "james1236/backseat.nvim",
    cmd = {
        "Backseat",
        "BackseatAsk",
        "BackseatClear",
        "BackseatClearLine",
    },
    config = true,
    enabled = false,
}

return {
    backseat,
    chatgpt_nvim,
    neoai,
}
