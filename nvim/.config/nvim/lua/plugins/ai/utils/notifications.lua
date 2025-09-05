-- AI Plugins Notification Utility
--
-- This module provides standardized notification functions for all AI plugins.
-- It ensures consistent notification formatting with proper titles and messages.
--
-- Usage:
--   local notify = require("plugins.ai.utils.notifications")
--   notify.info("CodeCompanion", "Adapter 'openai' is enabled and configured.")
--   notify.warn("Avante", "Provider 'gemini' is enabled but missing API key!")
--   notify.error("CopilotChat", "Failed to initialize provider 'anthropic'")

local M = {}

-- Notification levels with consistent formatting
local levels = {
    info = vim.log.levels.INFO,
    warn = vim.log.levels.WARN,
    error = vim.log.levels.ERROR,
    debug = vim.log.levels.DEBUG,
}

-- Helper function to format notification title
local function format_title(plugin_name, level)
    local icons = {
        info = "ℹ️",
        warn = "⚠️",
        error = "❌",
        debug = "🐛",
    }
    return string.format("%s %s", icons[level] or "ℹ️", plugin_name)
end

-- Helper function to format notification message
local function format_message(message, details)
    if details then
        return string.format("%s\n%s", message, details)
    end
    return message
end

-- Main notification function
local function notify(plugin_name, level, message, details, opts)
    opts = opts or {}

    local title = format_title(plugin_name, level)
    local formatted_message = format_message(message, details)

    -- Add plugin name to opts for better identification
    opts.title = title

    vim.notify(formatted_message, levels[level], opts)
end

-- Convenience functions for each log level
function M.info(plugin_name, message, details, opts)
    notify(plugin_name, "info", message, details, opts)
end

function M.warn(plugin_name, message, details, opts)
    notify(plugin_name, "warn", message, details, opts)
end

function M.error(plugin_name, message, details, opts)
    notify(plugin_name, "error", message, details, opts)
end

function M.debug(plugin_name, message, details, opts)
    notify(plugin_name, "debug", message, details, opts)
end

-- Specialized notification functions for common AI plugin scenarios
function M.provider_enabled(plugin_name, provider_name)
    M.info(plugin_name, string.format("Provider '%s' is enabled and configured.", provider_name))
end

function M.provider_disabled(plugin_name, provider_name)
    M.info(plugin_name, string.format("Provider '%s' is disabled.", provider_name))
end

function M.provider_missing_key(plugin_name, provider_name)
    M.warn(plugin_name, string.format("Provider '%s' is enabled but missing API key!", provider_name))
end

function M.provider_fallback(plugin_name, preferred, fallback)
    M.warn(
        plugin_name,
        string.format("Preferred provider '%s' is not available. Falling back to '%s'.", preferred, fallback)
    )
end

function M.config_loaded(plugin_name, config_file)
    -- Silent config loading - no notification needed
    return
end

function M.config_loaded_verbose(plugin_name, config_file)
    M.info(plugin_name, string.format("Configuration loaded from %s", config_file))
end

function M.health_check_start(plugin_name)
    -- Silent health check start - no notification needed
    return
end

function M.health_check_start_verbose(plugin_name)
    M.info(plugin_name, "Starting health check...")
end

function M.health_check_complete(plugin_name, enabled_count, total_count)
    M.info(plugin_name, string.format("Health check complete. %d/%d providers enabled.", enabled_count, total_count))
end

return M
