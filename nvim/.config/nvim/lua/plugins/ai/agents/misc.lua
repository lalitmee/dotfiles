local M = {}
local config = require("plugins.ai.config")

-- WTF.nvim-specific provider management
local function get_wtf_providers()
    local providers = {}

    -- Add OpenAI provider if API key is available
    if config.api_keys.openai and config.api_keys.openai ~= "" then
        providers.openai = {
            api_key = config.api_keys.openai,
        }
    end

    -- Add Anthropic provider if API key is available
    if config.api_keys.anthropic and config.api_keys.anthropic ~= "" then
        providers.anthropic = {
            api_key = config.api_keys.anthropic,
        }
    end

    -- Add Gemini provider if API key is available
    if config.api_keys.gemini and config.api_keys.gemini ~= "" then
        providers.gemini = {
            api_key = config.api_keys.gemini,
        }
    end

    return providers
end

M.plugins = {
    -- ChatGPT.nvim
    {
        "jackMort/ChatGPT.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        keys = {
            { "<localleader>ca", ":ChatGPTRun add_tests<CR>",          desc = "Add Tests",          silent = true },
            { "<localleader>cc", ":ChatGPT<CR>",                       desc = "Chatgpt",            silent = true },
            { "<localleader>cd", ":ChatGPTRun docstring<CR>",          desc = "Docstring",          silent = true },
            { "<localleader>ce", ":ChatGPTEditWithInstructions<CR>",   desc = "Edit Instructions",  silent = true },
            { "<localleader>cf", ":ChatGPTRun fix_bugs<CR>",           desc = "Fix Bugs",           silent = true },
            { "<localleader>cg", ":ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction", silent = true },
            { "<localleader>ch", ":ChatGPTActAs<CR>",                  desc = "Act As",             silent = true },
            { "<localleader>co", ":ChatGPTRun optimize_code<CR>",      desc = "Optimize Code",      silent = true },
            { "<localleader>cr", ":ChatGPTRun<CR>",                    desc = "Chatgpt Run",        silent = true },
            { "<localleader>cs", ":ChatGPTRun summarize<CR>",          desc = "Summarize",          silent = true },
            { "<localleader>ct", ":ChatGPTRun translate<CR>",          desc = "Translate",          silent = true },
        },
        opts = {
            popup_input = {
                submit = "<Enter>",
            },
        },
    },

    -- WTF.nvim
    {
        "piersolenski/wtf.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = function()
            local providers = get_wtf_providers()

            -- Check if user has a preferred provider
            if config.agent_preferences.wtf.preferred_provider then
                -- Filter to only include the preferred provider
                local preferred_providers = {}
                if providers[config.agent_preferences.wtf.preferred_provider] then
                    preferred_providers[config.agent_preferences.wtf.preferred_provider] = providers
                    [config.agent_preferences.wtf.preferred_provider]
                end
                providers = preferred_providers
            end

            return {
                providers = providers,
                popup_type = config.window_settings.popup_type,
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

    -- MCPHub.nvim
    {
        "ravitemer/mcphub.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        build = "npm install -g mcp-hub@latest",
        cmd = {
            "MCPHub",
        },
        keys = {
            { "<localleader>am", ":MCPHub<CR>", desc = "MCP Hub", silent = true, mode = { "n", "v" } },
        },
        opts = {},
    },
}

return M.plugins
