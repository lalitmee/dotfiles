local M = {
    "stevearc/overseer.nvim",
}

function M.config()
    local ok, overseer = lk.require("overseer")
    if not ok then
        return
    end

    overseer.setup({
        templates = {
            { "builtin", { "user.cpp_build", "user.run_script" } },
        },
    })
end

return M
