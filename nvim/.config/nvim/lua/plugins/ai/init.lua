-- AI Agents Configuration
-- Main entry point that imports and combines all AI agent configurations

-- Import all agent configurations
local codecompanion = require("plugins.ai.agents.codecompanion")
local copilot_chat = require("plugins.ai.agents.copilot-chat")
local avante = require("plugins.ai.agents.avante")
local misc = require("plugins.ai.agents.misc")

-- Combine all agents into a single plugin specification
return vim.list_extend({}, {
    codecompanion,
    copilot_chat,
    avante,
    misc,
})
