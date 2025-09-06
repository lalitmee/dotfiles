-- CodeCompanion Plugin Configuration
--
-- This file contains all configuration for the CodeCompanion AI plugin.
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
-- To check configuration health, run :CodeCompanionCheckHealth in Neovim.

local shared = require("plugins.ai.shared.config")

local M = shared.create_agent_config({
    name = "CodeCompanion",

    -- Providers table: Add new providers here to enable/disable them
    -- Note: Standardized from "adapters" to "providers" for consistency
    providers = {
        copilot = { enabled = true },
        copilot_4o = { enabled = true },
        bigmodel = { enabled = false },
        openrouter = { enabled = false },
        openai = { enabled = true },
        tavily = { enabled = false },
        gemini = { enabled = true },
        gemini_cli = { enabled = true }, -- ACP adapter for Gemini CLI
        anthropic = { enabled = true },
        claude_code = { enabled = true }, -- ACP adapter for Claude Code (now properly fixed)
    },

    -- Agent preferences: Set preferred provider/model or leave nil for dynamic selection.
    -- Note: Standardized from "preferred_adapter" to "preferred_provider"
    preferences = {
        -- preferred_provider = "claude_code",
        preferred_model = "claude-sonnet-4-20250514",
        preferred_provider = "anthropic",
        -- preferred_model = "claude-3-5-sonnet-20241022",
        -- preferred_provider = "openai",
        -- preferred_model = "gpt-4.1",
    },
})

-- Expose exclude_files for gitcommit extension
M.exclude_files = shared.exclude_files

-- Utility: Check config health and notify user of issues.
-- Usage: :CodeCompanionCheckHealth
function M.check_health()
    local health = require("plugins.ai.utils.health")
    local notify = require("plugins.ai.utils.notifications")

    local result = health.check_providers("CodeCompanion", M.providers, M.api_keys, M.special_providers)

    -- Additional validation using shared validation
    local validation_issues = M.validate()
    if #validation_issues > 0 then
        notify.warn("CodeCompanion", "Configuration validation issues:", table.concat(validation_issues, "\n"))
    end

    -- Additional validation from health utils
    health.validate_config("CodeCompanion", M)

    return result
end

return M
