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
        templates = { "tasks" },
    })

    --------------------------------------------------------------------------------
    --  NOTE: recipes {{{
    --------------------------------------------------------------------------------
    -- NOTE: asynchronous :Grep command
    vim.api.nvim_create_user_command("OGrep", function(params)
        local args = vim.fn.expandcmd(params.args)
        -- Insert args at the '$*' in the grepprg
        local cmd, num_subs = vim.o.grepprg:gsub("%$%*", args)
        if num_subs == 0 then
            cmd = cmd .. " " .. args
        end
        local task = overseer.new_task({
            cmd = cmd,
            name = "grep " .. args,
            components = {
                {
                    "on_output_quickfix",
                    errorformat = vim.o.grepformat,
                    open = not params.bang,
                    open_height = 8,
                    items_only = true,
                },
                -- We don't care to keep this around as long as most tasks
                { "on_complete_dispose", timeout = 30 },
                "default",
            },
        })
        task:start()
    end, { nargs = "*", bang = true })
    -- }}}
    --------------------------------------------------------------------------------
end

return M
