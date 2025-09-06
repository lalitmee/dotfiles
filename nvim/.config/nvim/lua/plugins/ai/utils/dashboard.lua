-- AI Plugins Status Dashboard
--
-- This module provides a unified status dashboard for all AI plugins.
-- It shows the health status, enabled providers/adapters, and configuration summary.
--
-- Usage:
--   :AIStatus - Show status of all AI plugins
--   :AICheckHealth - Check health of all AI plugins

local M = {}
local notify = require("plugins.ai.utils.notifications")

-- List of AI plugins to check
local AI_PLUGINS = {
    {
        name = "CodeCompanion",
        config_module = "plugins.ai.codecompanion.config",
        health_command = "CodeCompanionCheckHealth",
        config_type = "providers",
    },
    {
        name = "Avante",
        config_module = "plugins.ai.avante.config",
        health_command = "AvanteCheckHealth",
        config_type = "providers",
    },
    {
        name = "CopilotChat",
        config_module = "plugins.ai.copilot-chat.config",
        health_command = "CopilotChatCheckHealth",
        config_type = "providers",
    },
}

-- Get status of a single plugin
local function get_plugin_status(plugin)
    local ok, config = pcall(require, plugin.config_module)
    if not ok then
        return {
            name = plugin.name,
            status = "error",
            message = "Failed to load configuration",
            providers = {},
        }
    end

    -- Get the correct config table (adapters or providers)
    local config_table = config[plugin.config_type] or {}
    local api_keys = config.api_keys or {}
    local enabled_count = 0
    local total_count = 0
    local provider_status = {}

    for name, opts in pairs(config_table) do
        total_count = total_count + 1
        if opts.enabled then
            local api_key = api_keys[name] or api_keys[opts.api_key or name]
            -- Use shared special providers list if available, fallback to hardcoded
            local special_providers = config.special_providers or {
                copilot = true,
                copilot_4o = true,
                github_models = true,
            }
            local is_configured = api_key and api_key ~= "" or special_providers[name]

            if is_configured then
                enabled_count = enabled_count + 1
                provider_status[name] = "enabled"
            else
                provider_status[name] = "missing_key"
            end
        else
            provider_status[name] = "disabled"
        end
    end

    local status = enabled_count > 0 and "healthy" or "warning"
    local message = string.format("%d/%d providers enabled", enabled_count, total_count)

    return {
        name = plugin.name,
        status = status,
        message = message,
        providers = provider_status,
        config_type = plugin.config_type,
    }
end

-- Show status dashboard
function M.show_status()
    local statuses = {}
    local shared_config = require("plugins.ai.shared.config")

    -- Add environment validation
    local env_status = shared_config.validate_environment()

    for _, plugin in ipairs(AI_PLUGINS) do
        table.insert(statuses, get_plugin_status(plugin))
    end

    -- Create status report
    local report = { "🤖 AI Plugins Status Dashboard", "=" .. string.rep("=", 60) }
    
    -- Environment status section
    table.insert(report, "")
    table.insert(report, "🌍 Environment Status:")
    if env_status.is_valid then
        table.insert(report, "  ✅ All required API keys are configured")
    else
        table.insert(report, "  ❌ Missing API keys: " .. table.concat(env_status.missing_keys, ", "))
    end
    
    if #env_status.warnings > 0 then
        for _, warning in ipairs(env_status.warnings) do
            table.insert(report, "  ⚠️ " .. warning)
        end
    end

    -- Model versions section
    table.insert(report, "")
    table.insert(report, "📋 Current Model Versions:")
    for provider, model in pairs(shared_config.default_models) do
        if provider ~= "tavily" and provider ~= "openrouter" and provider ~= "bigmodel" then
            table.insert(report, string.format("  • %s: %s", provider, model))
        end
    end

    -- Plugins section
    table.insert(report, "")
    table.insert(report, "🔌 Plugin Status:")

    for _, status in ipairs(statuses) do
        local icon = status.status == "healthy" and "✅" or status.status == "warning" and "⚠️" or "❌"
        table.insert(report, string.format("  %s %s: %s", icon, status.name, status.message))

        -- Show provider details
        for provider, provider_status in pairs(status.providers) do
            local provider_icon = provider_status == "enabled" and "    ✅"
                or provider_status == "disabled" and "    ⚪"
                or "    ❌"
            local model = shared_config.default_models[provider] or "default"
            table.insert(report, string.format("%s %s (%s)", provider_icon, provider, model))
        end
        table.insert(report, "")
    end

    -- Show report
    local report_text = table.concat(report, "\n")
    vim.notify(report_text, vim.log.levels.INFO, { title = "AI Status Dashboard" })
end

-- Check health of all plugins
function M.check_all_health()
    notify.info("AI Dashboard", "Checking health of all AI plugins...")

    for _, plugin in ipairs(AI_PLUGINS) do
        local ok, _ = pcall(vim.cmd, ":" .. plugin.health_command)
        if not ok then
            notify.error("AI Dashboard", string.format("Failed to run health check for %s", plugin.name))
        end
    end

    notify.info("AI Dashboard", "Health check complete for all plugins.")
end

-- Setup dashboard commands
function M.setup()
    vim.api.nvim_create_user_command("AIStatus", M.show_status, {
        desc = "Show status dashboard for all AI plugins",
    })

    vim.api.nvim_create_user_command("AICheckHealth", M.check_all_health, {
        desc = "Check health of all AI plugins",
    })
    
    -- New command for environment validation
    vim.api.nvim_create_user_command("AIValidateEnv", function()
        local shared_config = require("plugins.ai.shared.config")
        local env_status = shared_config.validate_environment()
        
        if env_status.is_valid then
            notify.info("AI Environment", "All required API keys are configured ✅")
        else
            notify.warn("AI Environment", 
                "Missing API keys: " .. table.concat(env_status.missing_keys, ", "))
        end
        
        for _, warning in ipairs(env_status.warnings) do
            notify.warn("AI Environment", warning)
        end
    end, {
        desc = "Validate AI environment variables and API keys",
    })
    
    -- New command for model information
    vim.api.nvim_create_user_command("AIModels", function()
        local shared_config = require("plugins.ai.shared.config")
        local report = { "📋 AI Model Configuration", "=" .. string.rep("=", 40) }
        
        table.insert(report, "")
        table.insert(report, "🎯 Current Models:")
        for provider, model in pairs(shared_config.default_models) do
            table.insert(report, string.format("  • %s: %s", provider, model))
        end
        
        table.insert(report, "")
        table.insert(report, "📚 Alternative Models:")
        for provider, models in pairs(shared_config.alternative_models) do
            table.insert(report, string.format("  • %s:", provider))
            for _, model in ipairs(models) do
                table.insert(report, string.format("    - %s", model))
            end
        end
        
        local report_text = table.concat(report, "\n")
        vim.notify(report_text, vim.log.levels.INFO, { title = "AI Models" })
    end, {
        desc = "Show available AI models and current configuration",
    })
end

return M
