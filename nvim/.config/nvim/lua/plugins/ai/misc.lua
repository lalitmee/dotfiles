-- Miscellaneous AI Tools
--
-- This file contains additional AI tools that complement CodeCompanion:
-- - GitHub Copilot for inline completions
-- - ChatGPT.nvim for additional chat functionality
-- - WTF.nvim for error diagnosis
-- - MCPHub.nvim for MCP protocol integration

local config = require("plugins.ai.config")

-- WTF.nvim provider configuration
local function get_wtf_providers()
    local providers = {}

    if config.api_keys.openai and config.api_keys.openai ~= "" then
        providers.openai = {
            api_key = config.api_keys.openai,
        }
    end

    if config.api_keys.anthropic and config.api_keys.anthropic ~= "" then
        providers.anthropic = {
            api_key = config.api_keys.anthropic,
        }
    end

    if config.api_keys.gemini and config.api_keys.gemini ~= "" then
        providers.gemini = {
            api_key = config.api_keys.gemini,
        }
    end

    return providers
end

return {
    { -- [[ copilot.lua ]]
        enabled = false,
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "InsertEnter",
        opts = {
            suggestion = {
                enabled = false,
                auto_trigger = true,
                hide_during_completion = true,
                keymap = {
                    accept = "<Tab>",
                    next = "<C-n>",
                    prev = "<C-p>",
                    dismiss = "<C-c>",
                },
            },
            panel = { enabled = false },
            filetypes = {
                markdown = true,
                help = true,
            },
        },
        config = function(_, opts)
            require("copilot").setup(opts)
            vim.g.copilot_settings = { selectedCompletionModel = "gpt-5" }
        end,
    },

    -- ChatGPT.nvim for additional chat functionality
    {
        "jackMort/ChatGPT.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        keys = {
            {
                "<localleader>ca",
                ":ChatGPTRun add_tests<CR>",
                desc = "Add Tests",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>cc",
                ":ChatGPT<CR>",
                desc = "Chatgpt",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>cd",
                ":ChatGPTRun docstring<CR>",
                desc = "Docstring",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>ce",
                ":ChatGPTEditWithInstructions<CR>",
                desc = "Edit Instructions",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>cf",
                ":ChatGPTRun fix_bugs<CR>",
                desc = "Fix Bugs",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>cg",
                ":ChatGPTRun grammar_correction<CR>",
                desc = "Grammar Correction",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>ch",
                ":ChatGPTActAs<CR>",
                desc = "Act As",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>co",
                ":ChatGPTRun optimize_code<CR>",
                desc = "Optimize Code",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>cr",
                ":ChatGPTRun<CR>",
                desc = "Chatgpt Run",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>cs",
                ":ChatGPTRun summarize<CR>",
                desc = "Summarize",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>ct",
                ":ChatGPTRun translate<CR>",
                desc = "Translate",
                silent = true,
                mode = { "n", "v" },
            },
        },
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<localleader>c", group = "chatgpt", mode = { "n", "x" } },
            })
        end,
        opts = {
            popup_input = {
                submit = "<Enter>",
            },
        },
    },

    -- WTF.nvim for error diagnosis and fixing
    {
        "piersolenski/wtf.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = function()
            return {
                providers = get_wtf_providers(),
                popup_type = "vertical",
            }
        end,
        keys = {
            {
                "<leader>ea",
                function()
                    require("wtf").diagnose()
                end,
                desc = "Debug diagnostic with AI",
                mode = { "n", "x" },
            },
            {
                "<leader>ef",
                function()
                    require("wtf").fix()
                end,
                desc = "Fix diagnostic with AI",
                mode = { "n", "x" },
            },
            {
                "<leader>es",
                function()
                    require("wtf").search()
                end,
                desc = "Search diagnostic with Google",
            },
            {
                "<leader>em",
                function()
                    require("wtf").pick_provider()
                end,
                desc = "Pick provider",
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

    { -- [[ mcphub.nvim ]]
        "ravitemer/mcphub.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        build = "npm install -g mcp-hub@latest",
        cmd = {
            "MCPHub",
        },
        keys = {
            { "<leader>cm", ":MCPHub<CR>", desc = "MCP Hub", silent = true, mode = { "n", "v" } },
        },
        opts = {},
    },
}
