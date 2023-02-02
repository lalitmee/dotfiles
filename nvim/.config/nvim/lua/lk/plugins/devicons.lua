local M = {
    "yamatsum/nvim-nonicons",
    dependencies = { "kyazdani42/nvim-web-devicons" },
}

 M.config = function()
    require("nvim-web-devicons").setup({
        get_icons = require("nvim-nonicons"),
    })
end

return M
