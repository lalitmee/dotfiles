-- AI Plugins Health Check Utility
--
-- This module provides standardized health check functions for all AI plugins.
-- It ensures consistent health checking with proper reporting and validation.
--
-- Usage:
--   local health = require("plugins.ai.utils.health")
--   health.check_providers("Avante", config.providers, config.api_keys)

local M = {}
local notify = require("plugins.ai.utils.notifications")

-- Check if a provider is properly configured
local function is_provider_configured(provider_name, api_key, special_cases)
    special_cases = special_cases or {}

    -- Check if this provider is in special cases (like copilot that doesn't need API key)
    if special_cases[provider_name] then
        return true
    end

    -- For other providers, check if API key exists and is not empty
    return api_key and api_key ~= ""
end

-- Main health check function for providers
function M.check_providers(plugin_name, providers, api_keys, special_cases)
    special_cases = special_cases or {}

    notify.health_check_start(plugin_name)

    local enabled_count = 0
    local total_count = 0
    local issues = {}

    for name, opts in pairs(providers) do
        total_count = total_count + 1

        if opts.enabled then
            local api_key = api_keys[name] or api_keys[opts.api_key or name]

            if is_provider_configured(name, api_key, special_cases) then
                notify.provider_enabled(plugin_name, name)
                enabled_count = enabled_count + 1
            else
                notify.provider_missing_key(plugin_name, name)
                table.insert(issues, name)
            end
        else
            notify.provider_disabled(plugin_name, name)
        end
    end

    -- Report summary
    notify.health_check_complete(plugin_name, enabled_count, total_count)

    -- Report issues if any
    if #issues > 0 then
        local issue_list = table.concat(issues, ", ")
        notify.warn(plugin_name, string.format("Issues found with providers: %s", issue_list))
    end

    return {
        enabled_count = enabled_count,
        total_count = total_count,
        issues = issues,
        healthy = #issues == 0,
    }
end

-- Check if a specific provider is available
function M.is_provider_available(plugin_name, provider_name, providers, api_keys, special_cases)
    special_cases = special_cases or {}

    local provider = providers[provider_name]
    if not provider or not provider.enabled then
        return false
    end

    local api_key = api_keys[provider_name] or api_keys[provider.api_key or provider_name]
    return is_provider_configured(provider_name, api_key, special_cases)
end

-- Get list of available providers
function M.get_available_providers(plugin_name, providers, api_keys, special_cases)
    special_cases = special_cases or {}
    local available = {}

    for name, opts in pairs(providers) do
        if opts.enabled then
            local api_key = api_keys[name] or api_keys[opts.api_key or name]
            if is_provider_configured(name, api_key, special_cases) then
                table.insert(available, name)
            end
        end
    end

    return available
end

-- Validate configuration and suggest fixes
function M.validate_config(plugin_name, config)
    local suggestions = {}

    -- Check if any providers are enabled
    local has_enabled = false
    for _, opts in pairs(config.providers or {}) do
        if opts.enabled then
            has_enabled = true
            break
        end
    end

    if not has_enabled then
        table.insert(suggestions, "No providers are enabled. Consider enabling at least one provider.")
    end

    -- Check for missing API keys
    for name, opts in pairs(config.providers or {}) do
        if opts.enabled and name ~= "copilot" and name ~= "copilot_4o" then
            local api_key = config.api_keys[name] or config.api_keys[opts.api_key or name]
            if not api_key or api_key == "" then
                table.insert(
                    suggestions,
                    string.format(
                        "Provider '%s' is enabled but missing API key. Set environment variable or disable provider.",
                        name
                    )
                )
            end
        end
    end

    -- Report suggestions
    if #suggestions > 0 then
        notify.warn(plugin_name, "Configuration validation found issues:", table.concat(suggestions, "\n"))
    else
        notify.info(plugin_name, "Configuration validation passed.")
    end

    return suggestions
end

return M
