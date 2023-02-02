local M = {
    "rmagatti/auto-session",
    event = { "VimEnter" },
    dependencies = {
        "rmagatti/session-lens",
        cmd = { "SearchSession" },
    },
}

function M.config()
    local actions = require("telescope.actions")

    -- session-lens
    require("telescope").load_extension("session-lens")

    require("auto-session").setup({
        auto_save_enabled = true,
        auto_restore_enabled = true,
        auto_session_use_git_branch = true,
    })

    require("session-lens").setup({
        path_display = { "shorten" },
        theme_conf = {
            mappings = {
                i = { ["<esc>"] = actions.close },
            },
        },
    })
end

return M
