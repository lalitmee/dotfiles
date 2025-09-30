-- AI Plugins Configuration
--
-- Simplified structure for AI tools:
-- 1. CodeCompanion - Main AI coding assistant
-- 2. Miscellaneous AI tools (Copilot, ChatGPT, WTF, MCPHub)
-- 3. Shared configuration for API keys and common settings

return {
    -- Main AI assistant
    require("plugins.ai.codecompanion"),

    -- folke's sidekick for enhanced AI interactions
    require("plugins.ai.sidekick"),

    -- Additional AI tools
    require("plugins.ai.misc"),
}
