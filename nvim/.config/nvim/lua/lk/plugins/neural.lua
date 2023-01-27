local M = {
    "dense-analysis/neural",
    keys = {
        "<leader>x",
        "<localleader>x",
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "ElPiloto/significant.nvim",
    },
}

function M.config()
    require("neural").setup({
        mappings = {
            swift = "<leader>x",
            prompt = "<localleader>x",
        },
        open_ai = {
            api_key = os.getenv("OPENAI_API_KEY"),
        },
    })
end

return M
