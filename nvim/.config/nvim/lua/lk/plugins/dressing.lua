-- improve default neovim UI
local M = {
    "stevearc/dressing.nvim",
}

function M.config()
    local dressing_ok, dressing = lk.require("dressing")
    if not dressing_ok then
        return
    end

    dressing.setup({
        input = {
            insert_only = false,
            win_options = { winblend = 2 },
        },
        select = {
            winblend = 2,
            telescope = require("telescope.themes").get_cursor({
                layout_config = {
                    -- NOTE: the limit is half the max lines because this is the cursor theme so
                    -- unless the cursor is at the top or bottom it realistically most often will
                    -- only have half the screen available
                    height = function(self, _, max_lines)
                        local results = #self.finder.results
                        local PADDING = 4 -- this represents the size of the telescope window
                        local LIMIT = math.floor(max_lines / 2)
                        return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
                    end,
                },
            }),
        },
    })
end

return M
