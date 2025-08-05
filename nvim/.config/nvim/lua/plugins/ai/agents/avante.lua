local M = {}
local config = require("plugins.ai.config")
local prompts = require("plugins.ai.prompts")

-- Avante-specific provider management
local function get_providers()
    local providers = {
        copilot = "copilot",
    }

    -- Add OpenAI provider if API key is available
    if config.api_keys.openai and config.api_keys.openai ~= "" then
        providers.openai = "openai"
    end

    -- Add Anthropic provider if API key is available
    if config.api_keys.anthropic and config.api_keys.anthropic ~= "" then
        providers.anthropic = "anthropic"
    end

    -- Add Gemini provider if API key is available
    if config.api_keys.gemini and config.api_keys.gemini ~= "" then
        providers.gemini = "gemini"
    end

    return providers
end

M.plugins = {
    {
        "yetone/avante.nvim",
        build = "make",
        version = false,
        cmd = {
            "AvanteAsk",
            "AvanteChat",
            "AvanteInput",
            "AvanteChatNew",
            "AvanteToggle",
        },
        -- stylua: ignore
        keys = {
            { "<localleader>aI", ":AvanteSwitchInputProvider<CR>", desc = "Avante Switch Input Provider", silent = true, mode = { "n", "v" } },
            { "<localleader>aM", ":AvanteModels<CR>",              desc = "Avante Models",                silent = true, mode = { "n", "v" } },
            { "<localleader>aP", ":AvanteSwitchProvider<CR>",      desc = "Avante Switch Provider",       silent = true, mode = { "n", "v" } },
            { "<localleader>aa", ":AvanteAsk<CR>",                 desc = "Avante Ask",                   silent = true, mode = { "n", "v" } },
            { "<localleader>ab", ":AvanteBuild<CR>",               desc = "Avante Build",                 silent = true, mode = { "n", "v" } },
            { "<localleader>ac", ":AvanteChat<CR>",                desc = "Avante Chat",                  silent = true, mode = { "n", "v" } },
            { "<localleader>ah", ":AvanteHistory<CR>",             desc = "Avante History",               silent = true, mode = { "n", "v" } },
            { "<localleader>ai", ":AvanteInput<CR>",               desc = "Avante Input",                 silent = true, mode = { "n", "v" } },
            { "<localleader>an", ":AvanteChatNew<CR>",             desc = "Avante Chat New",              silent = true, mode = { "n", "v" } },
            { "<localleader>ar", ":AvanteClear<CR>",               desc = "Avante Clear",                 silent = true, mode = { "n", "v" } },
            { "<localleader>as", ":AvanteShowRepoMap<CR>",         desc = "Avante Show Repo Map",         silent = true, mode = { "n", "v" } },
            { "<localleader>at", ":AvanteToggle<CR>",              desc = "Avante Toggle",                silent = true, mode = { "n", "v" } },
            { "<localleader>ax", ":AvanteStop<CR>",                desc = "Avante Stop",                  silent = true, mode = { "n", "v" } },
        },
        opts = function()
            local providers = get_providers()
            local default_provider = "copilot" -- fallback

            -- Check if user has a preferred provider
            if config.agent_preferences.avante.preferred_provider then
                default_provider = config.agent_preferences.avante.preferred_provider
            else
                -- Use dynamic selection: Prefer OpenAI if available, then Anthropic, then Gemini, otherwise use copilot
                if providers.openai then
                    default_provider = "openai"
                elseif providers.anthropic then
                    default_provider = "anthropic"
                elseif providers.gemini then
                    default_provider = "gemini"
                end
            end

            return {
                provider = default_provider,
                selector = {
                    provider = "telescope",
                    provider_opts = {},
                    exclude_auto_select = {},
                },
                input = {
                    provider = "dressing",
                    provider_opts = {},
                },
                windows = {
                    width = config.window_settings.width,
                },
                personas = {
                    beast_mode = {
                        prompt = prompts.beast_mode,
                        icon = "🔥",
                        provider = config.agent_preferences.avante.preferred_provider
                            or (providers.openai and "openai")
                            or (providers.anthropic and "anthropic")
                            or default_provider,
                        model = config.agent_preferences.avante.preferred_model
                            or (providers.openai and config.default_models.openai)
                            or (providers.anthropic and config.default_models.anthropic)
                            or config.default_models.openai,
                    },
                    default = {
                        prompt = "You are a helpful AI assistant.",
                        icon = "🤖",
                    },
                },
            }
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
        },
    },
}

return M.plugins
