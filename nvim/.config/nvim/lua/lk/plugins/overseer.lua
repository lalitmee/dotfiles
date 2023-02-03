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

M.config = function()
    local overseer = require("overseer")

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
