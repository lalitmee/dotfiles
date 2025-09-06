-- Shared AI Configuration
--
-- This file contains shared configuration used across AI tools:
-- - API key management from environment variables
-- - Default models for each provider
-- - Common exclude patterns and settings

local M = {}

M.icons = {
    USER = "",
    BOT = "",
}

-- Helper function to safely get environment variables
local function get_env_key(key)
    local value = os.getenv(key)
    return value and value ~= "" and value or nil
end

-- API Keys Management - Single source of truth
M.api_keys = {
    openai = get_env_key("OPENAI_API_KEY"),
    anthropic = get_env_key("ANTHROPIC_API_KEY"),
    gemini = get_env_key("GEMINI_API_KEY"),
    github = get_env_key("GITHUB_PERSONAL_ACCESS_TOKEN"),
    tavily = get_env_key("TAVILY_API_KEY"),
    openrouter = get_env_key("OPENROUTER_API_KEY"),
}

-- Default models for each provider
M.default_models = {
    openai = "gpt-4o",
    anthropic = "claude-3-5-sonnet-20241022",
    gemini = "gemini-1.5-pro",
    github = "gpt-4o",
    copilot = "claude-3-5-sonnet-20241022",
    copilot_4o = "gpt-4o",
}

-- Alternative models for fallbacks
M.alternative_models = {
    openai = { "gpt-4o", "gpt-4o-mini", "gpt-4-turbo", "gpt-3.5-turbo" },
    anthropic = { "claude-3-5-sonnet-20241022", "claude-3-5-haiku-20241022", "claude-3-opus-20240229" },
    gemini = { "gemini-1.5-pro", "gemini-1.5-flash", "gemini-1.0-pro" },
}

-- Common exclude patterns for AI tools
M.exclude_files = {
    "*.pb.go",
    "*.min.js",
    "*.min.css",
    "package-lock.json",
    "yarn.lock",
    "*.log",
    "dist/*",
    "build/*",
    ".next/*",
    "node_modules/*",
    "vendor/*",
    "*.generated.*",
    "*gen.go",
}

-- Providers that don't require API keys
M.special_providers = {
    copilot = true,
    copilot_4o = true,
    github_models = true,
    gemini_cli = true,
}

return M
