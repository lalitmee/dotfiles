local auto_session_ok, auto_session = lk.require("auto-session")
local telescope_ok, telescope = lk.require("telescope")
if not auto_session_ok and telescope_ok then
    return
end

-- auto-session
auto_session.setup({
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_use_git_branch = true,
})

-- session-lens
telescope.load_extension("session-lens")
local actions = require("telescope.actions")

require("session-lens").setup({
  theme_conf = {
    mappings = {
      i = { ["<esc>"] = actions.close },
    },
  },
})
