local M = {
    "yamatsum/nvim-nonicons",
    dependencies = { "kyazdani42/nvim-web-devicons" },
}

function M.config()
    local nvim_web_icons = require("nvim-web-devicons")
    nvim_web_icons.setup({ get_icons = require("nvim-nonicons") })
end

return M
