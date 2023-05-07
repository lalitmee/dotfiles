local M = {
    "ahmedkhalf/project.nvim",
    key = { "<leader>pp" },
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    init = function()
        require("telescope").load_extension("projects")
    end,
}

M.config = function()
    require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" },
        show_hidden = true,
        -- show the message on changing the directory
        silent_chdir = false,
        -- change to the directory of the file in the current tab
        scope_chdir = "tab",
    })
end

return M
