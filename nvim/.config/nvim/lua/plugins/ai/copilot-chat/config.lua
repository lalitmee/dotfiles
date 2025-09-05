-- CopilotChat.nvim Plugin Configuration
--
-- This file contains all configuration for the CopilotChat AI plugin.
-- It is designed for extensibility and maintainability:
--   - Each provider can be enabled/disabled and assigned a custom API key name.
--   - API keys are loaded from environment variables.
--   - Default models and agent preferences are set here.
--   - Health check utility is provided to diagnose configuration issues.
--
-- To add a new provider:
--   1. Add an entry to the M.providers table below.
--   2. Set 'enabled = true' and specify 'api_key' if needed.
--   3. Add the API key to M.api_keys if not already present.
--   4. Optionally, add a default model to M.default_models.
--
-- To check configuration health, run :CopilotChatCheckHealth in Neovim.

local M = {}

-- Providers table: Add new providers here to enable/disable them and set custom API key names if needed.
-- Example:
--   myprovider = { enabled = true, api_key = "MY_PROVIDER_API_KEY" }
M.providers = {
    openai = { enabled = true },
    gemini = { enabled = true },
    github_models = { enabled = false },
}

-- API keys: Loaded from environment variables. Add new keys here if needed.
M.api_keys = {
    openai = os.getenv("OPENAI_API_KEY"),
    gemini = os.getenv("GEMINI_API_KEY"),
}

-- Default models for each provider.
M.default_models = {
    openai = "gpt-4.1",
    gemini = "gemini-2.5-pro",
    github = "gpt-4.1-copilot",
}

-- Agent preferences: Set preferred provider/model or leave nil for dynamic selection.
M.preferences = {
    preferred_provider = "openai",
    preferred_model = "gpt-4.1",
}

-- Health check utility
function M.check_health()
    local health = require("plugins.ai.utils.health")
    local notify = require("plugins.ai.utils.notifications")

    -- Special cases that don't require API keys
    local special_cases = {
        github_models = true,
    }

    local result = health.check_providers("CopilotChat", M.providers, M.api_keys, special_cases)

    -- Additional validation
    health.validate_config("CopilotChat", M)

    return result
end

return M
