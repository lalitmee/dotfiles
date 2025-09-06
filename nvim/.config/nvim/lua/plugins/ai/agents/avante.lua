local M = {}
local config = require("plugins.ai.avante.config")
local prompts = require("plugins.ai.prompts")
local notify = require("plugins.ai.utils.notifications")
local health = require("plugins.ai.utils.health")

-- Avante-specific provider management using enable/disable flags
local function get_providers()
    local providers = {}

    for name, opts in pairs(config.providers) do
        if opts.enabled then
            local api_key = config.api_keys[name] or config.api_keys[opts.api_key or name]
            if api_key or name == "copilot" then
                providers[name] = name
            else
                notify.provider_missing_key("Avante", name)
            end
        end
    end

    return providers
end

M.plugins = {
    {
        "yetone/avante.nvim",
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
            {
                -- VectorCode integration for enhanced context
                "Davidyz/VectorCode",
                version = "*",
                dependencies = { "nvim-lua/plenary.nvim" },
                cmd = "VectorCode",
            },
        },
        build = "make",
        version = false,
        cmd = {
            "AvanteAsk",
            "AvanteChat",
            "AvanteInput",
            "AvanteChatNew",
            "AvanteToggle",
            "AvanteCheckHealth",
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
        init = function()
            -- Setup spinner integration
            require("plugins.ai.spinners.snacks-notifier").setup()
            require("plugins.ai.spinners.cursor-relative").setup()
        end,
        opts = function()
            local providers = get_providers()
            local default_provider = "copilot" -- fallback

            -- Preferred provider/model selection logic
            -- 1. Use preferred provider if enabled and configured
            -- 2. If not, fall back to first available provider in priority order
            -- 3. Notify user if preferred provider is set but not enabled/configured
            local preferred = config.preferences.preferred_provider
            if preferred then
                if providers[preferred] then
                    default_provider = preferred
                else
                    notify.provider_fallback("Avante", preferred, "available provider")
                    local priority = { "openai", "anthropic", "gemini", "copilot" }
                    for _, name in ipairs(priority) do
                        if providers[name] then
                            default_provider = name
                            break
                        end
                    end
                end
            else
                local priority = { "openai", "anthropic", "gemini", "copilot" }
                for _, name in ipairs(priority) do
                    if providers[name] then
                        default_provider = name
                        break
                    end
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
                        provider = config.preferences.preferred_provider
                            or (providers.openai and "openai")
                            or (providers.anthropic and "anthropic")
                            or (providers.gemini and "gemini")
                            or default_provider,
                        model = config.preferences.preferred_model
                            or (providers.openai and config.default_models.openai)
                            or (providers.anthropic and config.default_models.anthropic)
                            or (providers.gemini and config.default_models.gemini)
                            or config.default_models.openai,
                    },
                    default = {
                        prompt = "You are a helpful AI assistant.",
                        icon = "🤖",
                    },
                },
            }
        end,
        config = function(_, opts)
            require("avante").setup(opts)
            -- Create health check command
            vim.api.nvim_create_user_command("AvanteCheckHealth", function()
                config.check_health()
            end, { desc = "Check Avante provider configuration health" })
        end,
    },
}

return M.plugins
