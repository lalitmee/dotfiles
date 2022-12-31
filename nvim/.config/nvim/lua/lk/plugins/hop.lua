local M = {
    "phaazon/hop.nvim",
    branch = "v2",
    cmd = { "HopAnywhere" },
}

function M.config()
    require("hop").setup()
end

function M.init()
    local hop = require("hop")
    local directions = require("hop.hint").HintDirection
    local map = lk.map
    map("", "f", function()
        hop.hint_char1({
            direction = directions.AFTER_CURSOR,
            current_line_only = true,
        })
    end, { remap = true })
    map("", "F", function()
        hop.hint_char1({
            direction = directions.BEFORE_CURSOR,
            current_line_only = true,
        })
    end, { remap = true })
    map("", "t", function()
        hop.hint_char1({
            direction = directions.AFTER_CURSOR,
            current_line_only = true,
            hint_offset = -1,
        })
    end, { remap = true })
    map("", "T", function()
        hop.hint_char1({
            direction = directions.BEFORE_CURSOR,
            current_line_only = true,
            hint_offset = 1,
        })
    end, { remap = true })
end

return M
