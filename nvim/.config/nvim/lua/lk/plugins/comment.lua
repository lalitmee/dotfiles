local status_ok, comment = lk.require("Comment")
if not status_ok then
    return
end

comment.setup({
    ignore = "^$",
    pre_hook = function(ctx)
        local U = require("Comment.utils")

        local location = nil
        if ctx.ctype == U.ctype.blockwise then
            location = require("ts_context_commentstring.utils").get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require("ts_context_commentstring.utils").get_visual_start_location()
        end

        return require("ts_context_commentstring.internal").calculate_commentstring({
            key = ctx.ctype == U.ctype.linewise and "__default" or "__multiline",
            location = location,
        })
    end,
})

local comment_ft = require("Comment.ft")
comment_ft.set("lua", { "--%s", "--[[%s]]" })
