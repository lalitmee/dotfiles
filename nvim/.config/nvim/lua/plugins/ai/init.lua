-- AI Agents Configuration
--
-- This file serves as the main entry point for configuring and loading all AI agents.
-- Instead of manually importing each agent, it dynamically scans the `lua/plugins/ai/agents`
-- directory and loads all Lua modules it finds. This approach offers several advantages:
--
-- 1.  **Maintainability**: You no longer need to manually update this file every time you
--     add, remove, or rename an agent. The system automatically detects and loads them.
--
-- 2.  **Scalability**: As you add more agents, the configuration remains clean and concise,
--     without a growing list of `require` statements.
--
-- 3.  **Reduced Merge Conflicts**: Since this file rarely needs to be changed, the likelihood
--     of merge conflicts in a multi-person project is significantly reduced.
--
-- How it works:
-- The script constructs the full path to the `agents` directory and iterates over all `.lua`
-- files within it. Each file is then dynamically required as a module, and the resulting
-- agent configuration is added to a list, which is then returned to the plugin manager.

local agents = {}
local path = "plugins.ai.agents"

-- To get the full path, we need to find it on the runtimepath
local agents_dir_candidates = vim.api.nvim_get_runtime_file("lua/" .. path:gsub("%.", "/"), true)

if #agents_dir_candidates > 0 then
    local agents_dir = agents_dir_candidates[1]
    for file in vim.fs.dir(agents_dir) do
        if file:match("%.lua$") and file ~= "init.lua" then
            local module_name = file:gsub("%.lua", "")
            table.insert(agents, require(path .. "." .. module_name))
        end
    end
end

-- Setup AI Dashboard commands after all agents are loaded
vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    callback = function()
        local dashboard = require("plugins.ai.utils.dashboard")
        dashboard.setup()
    end,
})

return agents
