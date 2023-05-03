return {
    dir = "~/Desktop/Github/cobalt2.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "tjdevries/colorbuddy.nvim" },
    init = function()
        require("colorbuddy").colorscheme("cobalt2")
    end,
    dev = true,
}
