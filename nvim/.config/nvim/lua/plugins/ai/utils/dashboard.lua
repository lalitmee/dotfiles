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
        config_type = "adapters", -- CodeCompanion uses adapters
    },
    {
        name = "Avante",
        config_module = "plugins.ai.avante.config",
        health_command = "AvanteCheckHealth",
        config_type = "providers", -- Avante uses providers
    },
    {
        name = "CopilotChat",
        config_module = "plugins.ai.copilot-chat.config",
        health_command = "CopilotChatCheckHealth",
        config_type = "providers", -- CopilotChat uses providers
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
            local is_configured = api_key and api_key ~= ""
                or name == "copilot"
                or name == "copilot_4o"
                or name == "github_models"

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
    local message = string.format("%d/%d %s enabled", enabled_count, total_count, plugin.config_type)

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

    for _, plugin in ipairs(AI_PLUGINS) do
        table.insert(statuses, get_plugin_status(plugin))
    end

    -- Create status report
    local report = { "🤖 AI Plugins Status Dashboard", "=" .. string.rep("=", 50) }

    for _, status in ipairs(statuses) do
        local icon = status.status == "healthy" and "✅" or status.status == "warning" and "⚠️" or "❌"
        table.insert(report, string.format("%s %s: %s", icon, status.name, status.message))

        -- Show provider/adapter details
        for provider, provider_status in pairs(status.providers) do
            local provider_icon = provider_status == "enabled" and "  ✅"
                or provider_status == "disabled" and "  ⚪"
                or "  ❌"
            table.insert(report, string.format("%s %s", provider_icon, provider))
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
end

return M
