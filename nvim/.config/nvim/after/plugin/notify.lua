local api = vim.api

local ok, notify = lk.require("notify")
if not ok then
    return
end

notify.setup({
    background_colour = "ColorColumn",
    timeout = 3000,
    stages = "fade_in_slide_out",
    max_width = function()
        return math.floor(vim.o.columns * 0.8)
    end,
    max_height = function()
        return math.floor(vim.o.lines * 0.8)
    end,
    on_open = function(win)
        if api.nvim_win_is_valid(win) then
            vim.api.nvim_win_set_config(win, { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } })
        end
    end,
    render = function(...)
        local notif = select(2, ...)
        local style = notif.title[1] == "" and "minimal" or "default"
        require("notify.render")[style](...)
    end,
    icons = lk.style.icons.notify,
})
vim.notify = notify

local notify_filter = vim.notify
vim.notify = function(msg, ...)
    if msg:match("warning: multiple different client offset_encodings") then
        return
    end
    if msg:match("character_offset must be called") then
        return
    end

    notify_filter(msg, ...)
end

lk.command("NotifyDismiss", notify.dismiss, {})
