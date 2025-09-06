-- Legacy AI Configuration (Compatibility Layer)
--
-- This file provides backward compatibility for any code that still references
-- the old global AI configuration. New code should use individual agent configs
-- or the shared configuration base directly.
--
-- DEPRECATED: This file is maintained for backward compatibility only.
-- Use plugins.ai.shared.config for new implementations.

local shared = require("plugins.ai.shared.config")

-- Re-export shared configuration for backward compatibility
local M = {
    api_keys = shared.api_keys,
    exclude_files = shared.exclude_files,
    window_settings = shared.window_settings,
    default_models = shared.default_models,
    alternative_models = shared.alternative_models,
}

-- Legacy agent preferences mapping (for backward compatibility)
-- These map to the new standardized agent configurations
M.agent_preferences = {
    codecompanion = {
        preferred_provider = "copilot_4o", -- Standardized from preferred_adapter
        preferred_model = shared.default_models.copilot_4o,
    },
    copilot_chat = {
        preferred_provider = "openai", -- Standardized naming
        preferred_model = shared.default_models.openai,   -- Updated to use shared config
    },
    avante = {
        preferred_provider = "openai",
        preferred_model = shared.default_models.openai,
    },
    wtf = {
        preferred_provider = "openai",
        preferred_model = shared.default_models.openai,
    },
}

return M
