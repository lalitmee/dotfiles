local M = {}

local state = {
    active = false,
    request_count = 0,
    tools_count = 0,
    diff_count = 0,
    last_message = nil,
    close_token = 0,
}

local function is_active()
    return (state.request_count > 0) or (state.tools_count > 0) or (state.diff_count > 0)
end

local function get_status_message()
    if state.diff_count > 0 then
        return " Action Required: Review Changes", nil
    end
    if state.tools_count > 0 then
        return " Running tools...", nil
    end
    if state.request_count > 0 then
        return "🤖 Thinking...", nil
    end
    return "Done!", nil
end

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
    elseif custom_opts.icon then
        opts.icon = custom_opts.icon .. " "
        opts.timeout = 0
        opts.dismiss = false
    else
        opts.timeout = 0
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
    state.request_count = 0
    state.tools_count = 0
    state.diff_count = 0
    state.last_message = nil
    state.close_token = state.close_token + 1
end

local event_handlers = {
    -- Chat lifecycle (updates only)
    ["CodeCompanionChatCreated"] = { type = "update", msg = "Chat ready" },
    ["CodeCompanionChatOpened"] = { type = "update", msg = "Chat opened" },
    ["CodeCompanionChatHidden"] = { type = "update", msg = "Chat hidden" },
    ["CodeCompanionChatClosed"] = { type = "update", msg = "Chat closed" },
    ["CodeCompanionChatSubmitted"] = { type = "update", msg = "Thinking..." },
    ["CodeCompanionChatDone"] = { type = "finish_chat", msg = "Done!" },
    ["CodeCompanionChatStopped"] = { type = "finish_chat", msg = "Stopped" },
    ["CodeCompanionChatCleared"] = { type = "update", msg = "Chat cleared" },
    ["CodeCompanionChatAdapter"] = { type = "update" },
    ["CodeCompanionChatModel"] = { type = "update" },
    ["CodeCompanionChatPin"] = { type = "update" },
    ["CodeCompanionContextChanged"] = { type = "update" },

    -- Tools lifecycle
    ["CodeCompanionToolsStarted"] = { type = "tools_start", msg = " Running tools..." },
    ["CodeCompanionToolsFinished"] = { type = "tools_finish", msg = "Processing..." },
    ["CodeCompanionToolAdded"] = { type = "update" },
    ["CodeCompanionToolStarted"] = { type = "update" },
    ["CodeCompanionToolFinished"] = { type = "update" },

    -- Inline strategy (treat as updates; request events will cover long-running states)
    ["CodeCompanionInlineStarted"] = { type = "update", msg = "Inline..." },
    ["CodeCompanionInlineFinished"] = { type = "update", msg = "Inline done" },

    -- Request lifecycle
    ["CodeCompanionRequestStarted"] = { type = "request_start", msg = "Thinking..." },
    ["CodeCompanionRequestStreaming"] = { type = "update", msg = "Receiving response..." },
    ["CodeCompanionRequestFinished"] = { type = "request_finish", msg = "Done!" },

    -- Diff lifecycle
    ["CodeCompanionDiffAttached"] = {
        type = "diff_start",
        msg = "Action Required: Review Changes",
        opts = { icon = "", hl_group = "WarningMsg" },
    },
    ["CodeCompanionDiffDetached"] = { type = "diff_finish", msg = "Done!" },
    ["CodeCompanionDiffAccepted"] = { type = "update", msg = "Change accepted." },
    ["CodeCompanionDiffRejected"] = { type = "update", msg = "Change rejected." },
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

            -- Counters
            if handler.type == "request_start" then
                state.request_count = state.request_count + 1
                state.active = true
                state.close_token = state.close_token + 1 -- cancel any pending close
            elseif handler.type == "request_finish" then
                state.request_count = math.max(0, state.request_count - 1)
            elseif handler.type == "tools_start" then
                state.tools_count = state.tools_count + 1
                state.active = true
                state.close_token = state.close_token + 1 -- cancel any pending close
            elseif handler.type == "tools_finish" then
                state.tools_count = math.max(0, state.tools_count - 1)
            elseif handler.type == "diff_start" then
                state.diff_count = state.diff_count + 1
                state.active = true
                state.close_token = state.close_token + 1 -- cancel any pending close
            elseif handler.type == "diff_finish" then
                state.diff_count = math.max(0, state.diff_count - 1)
            elseif handler.type == "finish_chat" then
                -- Ensure no lingering spinner if chat declares done/stopped
                state.request_count = 0
            end

            local active_now = is_active()
            local source_is_true_finish = (handler.type == "request_finish" or handler.type == "finish_chat")
            local can_close = source_is_true_finish and not active_now

            -- Do not show notifications for non-active updates or non-request finishes when nothing is active
            if not active_now then
                if handler.type == "update" then
                    return
                end
                if handler.type ~= "request_finish" and handler.type ~= "finish_chat" then
                    return
                end
            end

            -- True finish: only on request/chat finish and all counters zero
            if can_close then
                local this_token = state.close_token + 1
                state.close_token = this_token
                vim.defer_fn(function()
                    if state.close_token == this_token and not is_active() then
                        update_notification("Done!", true, nil)
                        reset_state()
                    end
                end, 200)
                return
            end

            -- Compute base status first
            local message, opts = get_status_message()

            -- Hard precedence: if diff is active, always show diff message
            if state.diff_count > 0 then
                update_notification(message, false, opts or handler.opts)
                return
            end

            -- For updates, prefer explicit message
            if handler.type == "update" and handler.msg then
                message = type(handler.msg) == "function" and handler.msg(args) or handler.msg
            end

            -- For start events, allow explicit message to surface
            if
                (handler.type == "tools_start" or handler.type == "diff_start" or handler.type == "request_start")
                and handler.msg
            then
                message = type(handler.msg) == "function" and handler.msg(args) or handler.msg
            end

            -- For non-closing finish events (tools_finish/diff_finish/request_finish while others active),
            -- keep the base computed status; do NOT show "Done!"
            update_notification(message, false, opts or handler.opts)
        end,
    })
end

return M
