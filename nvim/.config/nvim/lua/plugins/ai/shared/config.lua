-- Shared AI Configuration Base
--
-- This file contains shared configuration that is used across all AI agents.
-- It eliminates duplication and provides a single source of truth for:
--   - API key management from environment variables
--   - Default models for each provider
--   - Common exclude patterns and window settings
--   - Utility functions for configuration validation
--
-- Individual agent configs extend this base and add agent-specific settings.

local M = {}

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
    ai_key = get_env_key("AI_KEY"),
    -- Claude Code ACP adapter
    claude_code = get_env_key("ANTHROPIC_API_KEY"),
}

-- Model versions for easier management
M.model_versions = {
    latest = {
        openai = "gpt-5", -- Updated to latest stable model
        anthropic = "claude-sonnet-4-20250514",
        gemini = "gemini-2.5-pro",
        github = "gpt-4o", -- Updated for consistency
        copilot = "claude-sonnet-4",
        copilot_4o = "gpt-4o", -- Updated for consistency
    },
    legacy = {
        openai = "gpt-4o",
        anthropic = "claude-3.5-sonnet",
        gemini = "gemini-1.5-pro",
    },
}

-- Default models for each provider - Single source of truth
M.default_models = {
    openai = M.model_versions.latest.openai,
    anthropic = M.model_versions.latest.anthropic,
    gemini = M.model_versions.latest.gemini,
    github = M.model_versions.latest.github,
    tavily = "tavily-search",
    openrouter = "openrouter/horizon-alpha",
    copilot = M.model_versions.latest.copilot,
    copilot_4o = M.model_versions.latest.copilot_4o,
    bigmodel = "glm-4.5",
    claude_code = M.model_versions.latest.anthropic, -- Uses Anthropic's Claude via ACP
}

-- Alternative models for each provider (useful for fallbacks or different use cases)
M.alternative_models = {
    openai = {
        "gpt-4o",
        "gpt-4o-mini",
        "gpt-4-turbo",
        "gpt-3.5-turbo",
    },
    anthropic = {
        "claude-sonnet-4-20250514",
        "claude-3-5-sonnet-20241022",
        "claude-3-5-haiku-20241022",
        "claude-3-opus-20240229",
    },
    gemini = {
        "gemini-2.5-pro",
        "gemini-2.0-flash",
        "gemini-1.5-pro",
        "gemini-1.5-flash",
    },
    openrouter = {
        "openrouter/mistral-7b-instruct",
        "openrouter/llama-3.1-8b-instruct",
        "openrouter/codellama-34b-instruct",
    },
}

-- Common exclude patterns
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

-- Common window settings
M.window_settings = {
    width = 40,
    popup_type = "vertical",
}

-- Providers that don't require API keys
M.special_providers = {
    copilot = true,
    copilot_4o = true,
    github_models = true,
    gemini_cli = true,
    claude_code = true,
}

-- Environment validation utility
function M.validate_environment()
    local missing = {}
    local warnings = {}

    for provider, key in pairs(M.api_keys) do
        if not M.special_providers[provider] then
            if not key then
                table.insert(missing, provider)
            end
        end
    end

    -- Check for deprecated environment variables
    local deprecated_vars = {
        "AI_KEY", -- Generic key, prefer specific provider keys
    }

    for _, var in ipairs(deprecated_vars) do
        if os.getenv(var) then
            table.insert(warnings, string.format("Environment variable '%s' is deprecated", var))
        end
    end

    return {
        missing_keys = missing,
        warnings = warnings,
        is_valid = #missing == 0,
    }
end

-- Validation utility for agent configurations
function M.validate_agent_config(agent_name, config)
    local issues = {}

    -- Check for required fields
    if not config.providers then
        table.insert(issues, "Missing providers configuration")
    end

    -- Check for API key consistency
    if config.providers then
        for name, opts in pairs(config.providers) do
            if opts.enabled and not M.special_providers[name] then
                local api_key = M.api_keys[name] or M.api_keys[opts.api_key or name]
                if not api_key or api_key == "" then
                    table.insert(issues, string.format("Provider '%s' is enabled but missing API key", name))
                end
            end
        end
    end

    -- Check for preferences consistency
    if config.preferences and config.preferences.preferred_provider then
        local preferred = config.preferences.preferred_provider
        if config.providers and not config.providers[preferred] then
            table.insert(issues, string.format("Preferred provider '%s' is not defined in providers table", preferred))
        end
    end

    return issues
end

-- Helper function to create agent config with shared base
function M.create_agent_config(agent_overrides)
    local config = vim.tbl_deep_extend("force", {
        api_keys = M.api_keys,
        default_models = M.default_models,
        alternative_models = M.alternative_models,
        exclude_files = M.exclude_files,
        window_settings = M.window_settings,
        special_providers = M.special_providers,
    }, agent_overrides or {})

    -- Add validation function
    config.validate = function()
        return M.validate_agent_config(agent_overrides.name or "Unknown", config)
    end

    return config
end

return M
