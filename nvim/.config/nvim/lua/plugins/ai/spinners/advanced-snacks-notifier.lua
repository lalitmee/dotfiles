local M = {}

local state = {
    active = false,
}

-- The core function to show or update a notification.
-- It now accepts custom options for the icon and highlight group.
local function update_notification(message, is_done, custom_opts)
    custom_opts = custom_opts or {}
    local ok, _ = pcall(require, "snacks")
    if not ok then
        return
    end

    local opts = {
        id = "codecompanion_progress",
        title = "CodeCompanion",
        hl_group = custom_opts.hl_group,
    }

    if is_done then
        opts.icon = " "
        opts.timeout = 2000
    -- Use a custom static icon if provided
    elseif custom_opts.icon then
        opts.icon = custom_opts.icon .. " "
        opts.timeout = false
        opts.dismiss = false
    -- Default to the spinner for active states
    else
        opts.timeout = false
        opts.dismiss = false
        opts.opts = function(notif)
            local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
            notif.icon = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1] .. " "
        end
    end

    vim.notify(message, "info", opts)
end

local function reset_state()
    state.active = false
end

-- Data-driven event handlers with new metadata for icons and highlights.
local event_handlers = {
    -- Start states
    ["CodeCompanionRequestStarted"] = { msg = "Thinking...", type = "start" },
    ["CodeCompanionInlineStarted"] = { msg = "Thinking...", type = "start" },
    ["CodeCompanionChatSubmitted"] = { msg = "Thinking...", type = "start" },
    ["CodeCompanionDiffAttached"] = {
        msg = "Action Required: Review Changes",
        type = "start",
        opts = { icon = "", hl_group = "WarningMsg" },
    },

    -- Update states
    ["CodeCompanionToolsStarted"] = { msg = " Running tools...", type = "update" },
    ["CodeCompanionToolStarted"] = {
        msg = function(args)
            local tool_name = (args.data and args.data.tool and args.data.tool.name) or "a tool"
            return (" Running tool: %s..."):format(tool_name)
        end,
        type = "update",
    },
    ["CodeCompanionToolsFinished"] = { msg = "Processing...", type = "update" },
    ["CodeCompanionRequestStreaming"] = { msg = "Receiving response...", type = "update" },
    ["CodeCompanionDiffAccepted"] = {
        msg = "Change accepted.",
        type = "update",
        opts = { icon = "", hl_group = "WarningMsg" },
    },
    ["CodeCompanionDiffRejected"] = {
        msg = "Change rejected.",
        type = "update",
        opts = { icon = "", hl_group = "WarningMsg" },
    },

    -- Finish states
    ["CodeCompanionRequestFinished"] = { msg = "Done!", type = "finish" },
    ["CodeCompanionDiffDetached"] = { msg = "Done!", type = "finish" },
}

function M.setup()
    local group = vim.api.nvim_create_augroup("CodeCompanionAdvancedSnacksHooks", { clear = true })
    vim.api.nvim_create_autocmd("User", {
        pattern = vim.tbl_keys(event_handlers),
        group = group,
        callback = function(args)
            local handler = event_handlers[args.match]
            if not handler then
                return
            end

            if handler.type == "start" then
                state.active = true
            elseif not state.active then
                return -- Ignore updates or finishes if not active
            end

            local message = type(handler.msg) == "function" and handler.msg(args) or handler.msg
            local is_done = handler.type == "finish"

            -- Pass the custom options to the notification function
            update_notification(message, is_done, handler.opts)

            if is_done then
                reset_state()
            end
        end,
    })
end

return M
