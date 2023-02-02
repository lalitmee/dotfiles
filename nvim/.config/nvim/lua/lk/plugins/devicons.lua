local M = {
    "yamatsum/nvim-nonicons",
    dependencies = { "kyazdani42/nvim-web-devicons" },
}

function M.config()
    require("nvim-web-devicons").setup({
        get_icons = require("nvim-nonicons"),
    })
end

return M
