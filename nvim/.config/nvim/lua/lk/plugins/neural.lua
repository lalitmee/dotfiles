local M = {
    "dense-analysis/neural",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "ElPiloto/significant.nvim",
    },
}

function M.config()
    require("neural").setup({
        open_ai = {
            api_key = os.getenv("OPENAI_API_KEY"),
        },
    })
end

return M
