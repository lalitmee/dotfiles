local M = {
    "ahmedkhalf/project.nvim",
}

 M.config = function()
    require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" },
        show_hidden = true,
        silent_chdir = false,
    })
end

return M
