local M = {
    "ahmedkhalf/project.nvim",
}

function M.config()
    local ok, project = lk.require("project_nvim")
    if not ok then
        return
    end

    -- setup
    project.setup({
        detection_methods = { "pattern", "lsp" },
        show_hidden = true,
        silent_chdir = false,
    })
end

return M
