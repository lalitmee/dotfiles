local ok, auto_session = lk.require("auto-session")
if not ok then
  return
end

auto_session.setup({
  auto_save_enabled = true,
  auto_restore_enabled = true,
  auto_session_use_git_branch = true,
})
