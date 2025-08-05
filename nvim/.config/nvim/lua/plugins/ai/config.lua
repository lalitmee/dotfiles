local M = {}

-- API Keys Management
M.api_keys = {
    openai = os.getenv("OPENAI_API_KEY"),
    anthropic = os.getenv("ANTHROPIC_API_KEY"),
    gemini = os.getenv("GEMINI_API_KEY"),
    github = os.getenv("GITHUB_PERSONAL_ACCESS_TOKEN"),
    tavily = os.getenv("TAVILY_API_KEY"),
    openrouter = os.getenv("OPENROUTER_API_KEY"),
    ai_key = os.getenv("AI_KEY"),
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

-- Default models for each provider
M.default_models = {
    openai = "gpt-4.1",
    anthropic = "claude-3.5-sonnet",
    gemini = "gemini-2.5-pro",
    github = "gpt-4.1-copilot",
    tavily = "tavily-search",
    openrouter = "openrouter/horizon-alpha",
    copilot = "claude-sonnet-4",
    bigmodel = "glm-4.5",
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
        "claude-3.5-haiku",
        "claude-3-opus",
        "claude-3-sonnet",
    },
    gemini = {
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

-- Agent-specific preferences (override dynamic selection)
-- Set to nil to use dynamic selection, or specify your preferred adapter/model
--
-- HOW TO USE:
-- 1. Set preferred_adapter/provider to force a specific provider
-- 2. Set preferred_model to force a specific model
-- 3. Set to nil to use dynamic selection (default behavior)
--
-- EXAMPLES:
-- - preferred_adapter = "copilot" -> Always use Copilot
-- - preferred_adapter = "openai" -> Always use OpenAI
-- - preferred_adapter = nil -> Use dynamic selection (best available)
M.agent_preferences = {
    codecompanion = {
        preferred_adapter = "copilot", -- Best for coding, thinking, and reasoning
        preferred_model = "claude-4-sonnet", -- Claude 3.5 Sonnet is the best coding model
    },
    copilot_chat = {
        preferred_provider = "copilot", -- Force Gemini
        preferred_model = "gemini-2.5-pro", -- Force specific model
    },
    avante = {
        preferred_provider = "openai", -- Original: used "openai" for beast_mode
        preferred_model = "gpt-4.1", -- Original: used "gpt-4.1" for beast_mode
    },
    wtf = {
        preferred_provider = "openai", -- Original: used "openai" provider
    },
}

return M
