local M = {
    "stevearc/overseer.nvim",
    event = { "VeryLazy" },
}

M.config = function()
    local overseer = require("overseer")

    overseer.setup({
        templates = { "tasks" },
    })
end

M.init = function()
    local wk = require("which-key")
    wk.register({
        ["r"] = {
            ["o"] = {
                ["name"] = "+overseer",
                ["a"] = { ":OverseerTaskAction<CR>", "task-action" },
                ["b"] = { ":OverseerBuild<CR>", "build" },
                ["c"] = { ":OverseerClose<CR>", "close" },
                ["d"] = { ":OverseerDeleteBundle<CR>", "delete-bundle" },
                ["f"] = { ":OverseerRunCmd<CR>", "run-cmd" },
                ["l"] = { ":OverseerLoadBundle<CR>", "load-bundle" },
                ["o"] = { ":OverseerOpen<CR>", "open" },
                ["q"] = { ":OverseerQuickAction<CR>", "quick-action" },
                ["r"] = { ":OverseerRun<CR>", "run" },
                ["s"] = { ":OverseerSaveBundle ", "save-bundle" },
                ["t"] = { ":OverseerToggle<CR>", "toggle" },
            },
        },
    }, { mode = "n", prefix = "<leader>" })
end

return M
