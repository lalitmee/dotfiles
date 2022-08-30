local ok, neogit = lk.safe_require("neogit")
if not ok then
  return
end

----------------------------------------------------------------------
-- NOTE: setup {{{
----------------------------------------------------------------------
neogit.setup({
  disable_commit_confirmation = true,
  integrations = { diffview = true },
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: autocmds {{{
----------------------------------------------------------------------
local neogit_notify = function(msg, type)
  local msg_type = type or "info"
  vim.notify(msg, msg_type, { title = " Neogit" })
end

lk.augroup("neogit_au", {
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
})
-- }}}
----------------------------------------------------------------------
