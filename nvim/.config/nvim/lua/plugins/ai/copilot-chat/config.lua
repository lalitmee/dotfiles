-- CopilotChat.nvim Plugin Configuration
--
-- This file contains all configuration for the CopilotChat AI plugin.
-- It extends the shared AI configuration base for consistency and maintainability:
--   - Uses shared API keys, models, and common settings
--   - Each provider can be enabled/disabled
--   - Health check utility is provided to diagnose configuration issues
--
-- To add a new provider:
--   1. Add an entry to the M.providers table below.
--   2. Set 'enabled = true' and specify 'api_key' if needed.
--   3. The API key will be automatically loaded from the shared config.
--   4. Default models are inherited from shared config.
--
-- To check configuration health, run :CopilotChatCheckHealth in Neovim.

local shared = require("plugins.ai.shared.config")

local M = shared.create_agent_config({
    name = "CopilotChat",

    -- Providers table: Add new providers here to enable/disable them
    providers = {
        openai = { enabled = true },
        gemini = { enabled = true },
        github_models = { enabled = false },
    },

    -- Agent preferences: Set preferred provider/model or leave nil for dynamic selection.
    preferences = {
        preferred_provider = "openai",
        preferred_model = "gpt-4.1",
    },
})

-- Health check utility
function M.check_health()
    local health = require("plugins.ai.utils.health")
    local notify = require("plugins.ai.utils.notifications")

    local result = health.check_providers("CopilotChat", M.providers, M.api_keys, M.special_providers)

    -- Additional validation using shared validation
    local validation_issues = M.validate()
    if #validation_issues > 0 then
        notify.warn("CopilotChat", "Configuration validation issues:", table.concat(validation_issues, "\n"))
    end

    -- Additional validation from health utils
    health.validate_config("CopilotChat", M)

    return result
end

return M
