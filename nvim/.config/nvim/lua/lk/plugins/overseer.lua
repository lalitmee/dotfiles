local M = {
    "stevearc/overseer.nvim",
    cmd = {
        "OverseerBuild",
        "OverseerDeleteBundle",
        "OverseerLoadBundle",
        "OverseerOpen",
        "OverseerQuickAction",
        "OverseerRun",
        "OverseerRunCmd",
        "OverseerSaveBundle",
        "OverseerTaskAction",
        "OverseerToggle",
    },
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
