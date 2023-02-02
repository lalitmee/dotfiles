local M = {
    "TimUntersberger/neogit",
    cmd = { "Neogit" },
}

 M.config = function()
    local neogit = require("neogit")

    ----------------------------------------------------------------------
    -- NOTE: setup {{{
    ----------------------------------------------------------------------
    neogit.setup({
        disable_commit_confirmation = true,
        integrations = { diffview = true },
    })
    -- }}}
    ----------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: command {{{
    --------------------------------------------------------------------------------
    local command = lk.command

    command("Neogit", function()
        neogit.open()
    end, {})
    -- }}}
    --------------------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: autocmds {{{
    ----------------------------------------------------------------------
    --[[ local neogit_notify = function(msg, type) ]]
    --[[   local msg_type = type or "info" ]]
    --[[   vim.notify(msg, msg_type, { title = " Neogit" }) ]]
    --[[ end ]]
    --[[]]
    --[[ lk.augroup("neogit_au", { ]]
    --[[   { ]]
    --[[     event = { "User" }, ]]
    --[[     pattern = { "NeogitStatusRefreshed" }, ]]
    --[[     command = function() ]]
    --[[       neogit_notify("status has been reloaded") ]]
    --[[     end, ]]
    --[[   }, ]]
    --[[   { ]]
    --[[     event = { "User" }, ]]
    --[[     pattern = { "NeogitCommitComplete" }, ]]
    --[[     command = function() ]]
    --[[       neogit_notify("commited successfully") ]]
    --[[     end, ]]
    --[[   }, ]]
    --[[   { ]]
    --[[     event = { "User" }, ]]
    --[[     pattern = { "NeogitPushComplete" }, ]]
    --[[     command = function() ]]
    --[[       neogit_notify("pushed successfully") ]]
    --[[     end, ]]
    --[[   }, ]]
    --[[ }) ]]
    -- }}}
    ----------------------------------------------------------------------
end

return M
