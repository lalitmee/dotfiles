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
        -- templates = {
        --     { "builtin", "tasks" },
        -- },
    })
    overseer.load_template("tasks.rustlings")
    overseer.load_template("tasks.run_script")
    overseer.load_template("tasks.cpp_build")
end

return M
