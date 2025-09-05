-- CodeCompanion Plugin Configuration
--
-- This file contains all configuration for the CodeCompanion AI plugin.
-- It is designed for extensibility and maintainability:
--   - Each adapter can be enabled/disabled and assigned a custom API key name.
--   - API keys are loaded from environment variables.
--   - Default models and agent preferences are set here.
--   - Health check utility is provided to diagnose configuration issues.
--
-- To add a new adapter:
--   1. Add an entry to the M.adapters table below.
--   2. Set 'enabled = true' and specify 'api_key' if needed.
--   3. Add the API key to M.api_keys if not already present.
--   4. Optionally, add a default model to M.default_models.
--
-- To check configuration health, run :CodeCompanionCheckHealth in Neovim.

local M = {}

-- Adapters table: Add new adapters here to enable/disable them and set custom API key names if needed.
-- Example:
--   myadapter = { enabled = true, api_key = "MY_ADAPTER_API_KEY" }
M.adapters = {
    copilot = { enabled = true },
    copilot_4o = { enabled = true },
    bigmodel = { enabled = false },
    openrouter = { enabled = false },
    openai = { enabled = true },
    tavily = { enabled = false },
    gemini = { enabled = true },
    anthropic = { enabled = true },
}

-- API keys: Loaded from environment variables. Add new keys here if needed.
M.api_keys = {
    openai = os.getenv("OPENAI_API_KEY"),
    anthropic = os.getenv("ANTHROPIC_API_KEY"),
    gemini = os.getenv("GEMINI_API_KEY"),
    openrouter = os.getenv("OPENROUTER_API_KEY"),
    tavily = os.getenv("TAVILY_API_KEY"),
    ai_key = os.getenv("AI_KEY"),
}

-- Default models for each adapter/provider.
M.default_models = {
    copilot = "claude-sonnet-4",
    openai = "gpt-4.1",
    anthropic = "claude-3.5-sonnet",
    gemini = "gemini-2.5-pro",
    openrouter = "openrouter/horizon-alpha",
    bigmodel = "glm-4.5",
}

-- Agent preferences: Set preferred adapter/model or leave nil for dynamic selection.
M.agent_preferences = {
    preferred_adapter = "copilot_4o",
    preferred_model = "gpt-4.1",
}

-- Utility: Check config health and notify user of issues.
-- Usage: :CodeCompanionCheckHealth
function M.check_health()
    local health = require("plugins.ai.utils.health")
    local notify = require("plugins.ai.utils.notifications")

    -- Special cases that don't require API keys
    local special_cases = {
        copilot = true,
        copilot_4o = true,
    }

    local result = health.check_providers("CodeCompanion", M.adapters, M.api_keys, special_cases)

    -- Additional validation
    health.validate_config("CodeCompanion", M)

    return result
end

return M
