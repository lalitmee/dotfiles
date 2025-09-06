local M = {}

local state = {
    active = false,
    request_count = 0,
    tools_count = 0,
    diff_count = 0,
    last_message = nil,
    close_token = 0,
}

local EventHandlerType = {
    UPDATE = "update",
    REQUEST_START = "request_start",
    REQUEST_FINISH = "request_finish",
    TOOLS_INCREMENT = "tools_inc",
    TOOLS_DECREMENT = "tools_dec",
    TOOLS_FLUSH = "tools_flush",
    DIFF_START = "diff_start",
    DIFF_FINISH = "diff_finish",
    FINISH_CHAT = "finish_chat",
}

local StatusIcon = {
    DONE = "",
    THINKING = lk.style.icons.ui.Bot,
    RUNNING_TOOLS = "",
    REVIEW_CHANGES = lk.style.icons.ui.User,
    RECEIVING = "",
    CHAT_READY = "",
    CHAT_OPENED = "",
    CHAT_HIDDEN = "",
    CHAT_CLOSED = "",
    STOPPED = "",
    CHANGE_ACCEPTED = "",
    CHANGE_REJECTED = "",
    CLEARED = "",
}

local StatusMessage = {
    DONE = "Done!",
    THINKING = "Thinking...",
    RUNNING_TOOLS = "Running tools...",
    REVIEW_CHANGES = "Action Required: Review Changes",
    RECEIVING = "Receiving response...",
    PROCESSING = "Processing...",
    CHAT_READY = "Chat ready",
    CHAT_OPENED = "Chat opened",
    CHAT_HIDDEN = "Chat hidden",
    CHAT_CLOSED = "Chat closed",
    STOPPED = "Stopped",
    CLEARED = "Chat cleared",
    INLINE = "Inline...",
    INLINE_DONE = "Inline done",
    CHANGE_ACCEPTED = "Change accepted.",
    CHANGE_REJECTED = "Change rejected.",
}

local function is_active()
    return (state.request_count > 0) or (state.tools_count > 0) or (state.diff_count > 0)
end

local function with_icon(icon, msg)
    return string.format("%s  %s", icon, msg)
end

local function get_status_message()
    if state.diff_count > 0 then
        return with_icon(StatusIcon.REVIEW_CHANGES, StatusMessage.REVIEW_CHANGES), nil
    end
    if state.tools_count > 0 then
        return with_icon(StatusIcon.RUNNING_TOOLS, StatusMessage.RUNNING_TOOLS), nil
    end
    if state.request_count > 0 then
        return with_icon(StatusIcon.THINKING, StatusMessage.THINKING), nil
    end
    return with_icon(StatusIcon.DONE, StatusMessage.DONE), nil
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
        opts.icon = ""
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

local function handler(type, icon, msg, opts)
    return { type = type, msg = icon and with_icon(icon, msg) or nil, opts = opts }
end

local event_handlers = {
    -- Chat lifecycle (updates only)
    ["CodeCompanionChatCreated"] = handler(EventHandlerType.UPDATE, StatusIcon.CHAT_READY, StatusMessage.CHAT_READY),
    ["CodeCompanionChatOpened"] = handler(EventHandlerType.UPDATE, StatusIcon.CHAT_OPENED, StatusMessage.CHAT_OPENED),
    ["CodeCompanionChatHidden"] = handler(EventHandlerType.UPDATE, StatusIcon.CHAT_HIDDEN, StatusMessage.CHAT_HIDDEN),
    ["CodeCompanionChatClosed"] = handler(EventHandlerType.UPDATE, StatusIcon.CHAT_CLOSED, StatusMessage.CHAT_CLOSED),
    ["CodeCompanionChatSubmitted"] = handler(EventHandlerType.UPDATE, StatusIcon.THINKING, StatusMessage.THINKING),
    ["CodeCompanionChatDone"] = handler(EventHandlerType.FINISH_CHAT, StatusIcon.DONE, StatusMessage.DONE),
    ["CodeCompanionChatStopped"] = handler(EventHandlerType.FINISH_CHAT, StatusIcon.STOPPED, StatusMessage.STOPPED),
    ["CodeCompanionChatCleared"] = handler(EventHandlerType.UPDATE, StatusIcon.CLEARED, StatusMessage.CLEARED),
    ["CodeCompanionChatAdapter"] = handler(EventHandlerType.UPDATE),
    ["CodeCompanionChatModel"] = handler(EventHandlerType.UPDATE),
    ["CodeCompanionChatPin"] = handler(EventHandlerType.UPDATE),
    ["CodeCompanionContextChanged"] = handler(EventHandlerType.UPDATE),

    -- Tools lifecycle
    ["CodeCompanionToolsStarted"] = handler(
        EventHandlerType.UPDATE,
        StatusIcon.RUNNING_TOOLS,
        StatusMessage.RUNNING_TOOLS
    ),
    ["CodeCompanionToolsFinished"] = handler(
        EventHandlerType.TOOLS_FLUSH,
        StatusIcon.RECEIVING,
        StatusMessage.PROCESSING
    ),
    ["CodeCompanionToolAdded"] = handler(EventHandlerType.UPDATE),
    ["CodeCompanionToolStarted"] = handler(
        EventHandlerType.TOOLS_INCREMENT,
        StatusIcon.RUNNING_TOOLS,
        StatusMessage.RUNNING_TOOLS
    ),
    ["CodeCompanionToolFinished"] = handler(
        EventHandlerType.TOOLS_DECREMENT,
        StatusIcon.RECEIVING,
        StatusMessage.PROCESSING
    ),

    -- Inline strategy (treat as updates; request events will cover long-running states)
    ["CodeCompanionInlineStarted"] = handler(EventHandlerType.UPDATE, StatusIcon.THINKING, StatusMessage.INLINE),
    ["CodeCompanionInlineFinished"] = handler(EventHandlerType.UPDATE, StatusIcon.DONE, StatusMessage.INLINE_DONE),

    -- Request lifecycle
    ["CodeCompanionRequestStarted"] = handler(
        EventHandlerType.REQUEST_START,
        StatusIcon.THINKING,
        StatusMessage.THINKING
    ),
    ["CodeCompanionRequestStreaming"] = handler(EventHandlerType.UPDATE, StatusIcon.RECEIVING, StatusMessage.RECEIVING),
    ["CodeCompanionRequestFinished"] = handler(EventHandlerType.REQUEST_FINISH, StatusIcon.DONE, StatusMessage.DONE),

    -- Diff lifecycle
    ["CodeCompanionDiffAttached"] = handler(
        EventHandlerType.DIFF_START,
        StatusIcon.REVIEW_CHANGES,
        StatusMessage.REVIEW_CHANGES,
        { icon = StatusIcon.REVIEW_CHANGES, hl_group = "WarningMsg" }
    ),
    ["CodeCompanionDiffDetached"] = handler(EventHandlerType.DIFF_FINISH, StatusIcon.DONE, StatusMessage.DONE),
    ["CodeCompanionDiffAccepted"] = handler(
        EventHandlerType.UPDATE,
        StatusIcon.CHANGE_ACCEPTED,
        StatusMessage.CHANGE_ACCEPTED
    ),
    ["CodeCompanionDiffRejected"] = handler(
        EventHandlerType.UPDATE,
        StatusIcon.CHANGE_REJECTED,
        StatusMessage.CHANGE_REJECTED
    ),
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

            -- Track whether we were active before applying this event
            local was_active = is_active()

            -- Counters
            if handler.type == EventHandlerType.REQUEST_START then
                state.request_count = state.request_count + 1
                state.active = true
                state.close_token = state.close_token + 1 -- cancel any pending close
            elseif handler.type == EventHandlerType.REQUEST_FINISH then
                state.request_count = math.max(0, state.request_count - 1)
            elseif handler.type == EventHandlerType.TOOLS_INCREMENT then
                state.tools_count = state.tools_count + 1
                state.active = true
                state.close_token = state.close_token + 1 -- cancel any pending close
            elseif handler.type == EventHandlerType.TOOLS_DECREMENT then
                state.tools_count = math.max(0, state.tools_count - 1)
            elseif handler.type == EventHandlerType.TOOLS_FLUSH then
                state.tools_count = 0
            elseif handler.type == EventHandlerType.DIFF_START then
                state.diff_count = state.diff_count + 1
                state.active = true
                state.close_token = state.close_token + 1 -- cancel any pending close
            elseif handler.type == EventHandlerType.DIFF_FINISH then
                state.diff_count = math.max(0, state.diff_count - 1)
            elseif handler.type == EventHandlerType.FINISH_CHAT then
                -- Ensure no lingering spinner if chat declares done/stopped
                state.request_count = 0
                state.tools_count = 0
                state.diff_count = 0
            end

            local active_now = is_active()

            -- If we transitioned from active to inactive on this event, close now regardless of event type
            if was_active and not active_now then
                update_notification(with_icon(StatusIcon.DONE, StatusMessage.DONE), true, nil)
                reset_state()
                return
            end
            local source_is_true_finish = (
                handler.type == EventHandlerType.REQUEST_FINISH or handler.type == EventHandlerType.FINISH_CHAT
            )
            local can_close = source_is_true_finish and not active_now

            -- Do not show notifications for non-active updates or non-request finishes when nothing is active
            if not active_now then
                if handler.type == EventHandlerType.UPDATE then
                    return
                end
                if handler.type ~= EventHandlerType.REQUEST_FINISH and handler.type ~= EventHandlerType.FINISH_CHAT then
                    return
                end
            end

            -- True finish: only on request/chat finish and all counters zero
            if can_close then
                local this_token = state.close_token + 1
                state.close_token = this_token
                vim.defer_fn(function()
                    if state.close_token == this_token and not is_active() then
                        update_notification(with_icon(StatusIcon.DONE, StatusMessage.DONE), true, nil)
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

            -- For non-closing finish events or updates, show current status; do NOT show "Done!"
            update_notification(message, false, opts or handler.opts)
        end,
    })

    -- local debug_group = vim.api.nvim_create_augroup("CodeCompanionHooks", { clear = true })
    --
    -- vim.api.nvim_create_autocmd({ "User" }, {
    --     pattern = "CodeCompanion*",
    --     group = debug_group,
    --     callback = function(request)
    --         vim.notify(
    --             string.format(
    --                 "Event: %s | Requests: %d | Tools: %d | Diffs: %d",
    --                 request.match,
    --                 state.request_count,
    --                 state.tools_count,
    --                 state.diff_count
    --             ),
    --             vim.log.levels.DEBUG,
    --             { title = "CodeCompanion Event Debug" }
    --         )
    --     end,
    -- })
end

return M
