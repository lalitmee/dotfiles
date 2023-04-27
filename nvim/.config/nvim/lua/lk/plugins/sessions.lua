local M = {
    "rmagatti/auto-session",
    event = { "VimEnter" },
}

M.config = function()
    require("auto-session").setup({
        auto_save_enabled = true,
        auto_restore_enabled = true,
        auto_session_use_git_branch = true,
    })
end

return M
