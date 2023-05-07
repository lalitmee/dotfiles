return {
    "liangxianzhe/nap.nvim",
    keys = { "]", "[" },
    config = function()
        require("nap").setup({
            next_prefix = "]",
            prev_prefix = "[",
            next_repeat = "]",
            prev_repeat = "[",
        })

        -- gitsigns mapping
        require("nap").operator("h", require("nap").gitsigns())
    end,
}
