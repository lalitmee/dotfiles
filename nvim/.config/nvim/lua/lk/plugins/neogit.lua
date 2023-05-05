local command = lk.command
local augroup = lk.augroup

return {
    "TimUntersberger/neogit",
    cmd = { "Neogit" },
    enabled = false,
    config = function()
        local neogit = require("neogit")

        -- setup
        neogit.setup({
            disable_commit_confirmation = true,
            integrations = { diffview = true },
        })

        -- commands
        command("Neogit", function()
            neogit.open()
        end, {})

        -- autocmds
        local neogit_notify = function(msg, type)
            local msg_type = type or "info"
            vim.notify(msg, msg_type, { title = " Neogit" })
        end

        augroup("neogit_au", {
            {
                event = { "User" },
                pattern = { "NeogitStatusRefreshed" },
                command = function()
                    neogit_notify("status has been reloaded")
                end,
            },
            {
                event = { "User" },
                pattern = { "NeogitCommitComplete" },
                command = function()
                    neogit_notify("commited successfully")
                end,
            },
            {
                event = { "User" },
                pattern = { "NeogitPushComplete" },
                command = function()
                    neogit_notify("pushed successfully")
                end,
            },
            {
                event = { "User" },
                pattern = { "NeogitPushComplete" },
                command = function()
                    require("neogit").close()
                end,
            },
        })
    end,
}
