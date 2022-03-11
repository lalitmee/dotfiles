local ok, Job = lk.safe_require("plenary.job")
if not ok then
  return
end

local M = {}

--------------------------------------------------------------------------------
-- NOTE: notify current date and time {{{
--------------------------------------------------------------------------------
function M.notify_current_datetime()
  local dt = vim.fn.strftime("%c")
  vim.notify("Current Date Time: " .. dt, "info", { title = "Date & Time" })
end
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE:yank current file name {{{
--------------------------------------------------------------------------------
function M.yank_current_file_name()
  local file_name = vim.api.nvim_buf_get_name(0)
  local input_pipe = vim.loop.new_pipe(false)
  local yanker = Job:new({ writer = input_pipe, command = "xclip" })
  yanker:start()
  input_pipe:write(file_name)
  input_pipe:close()
  yanker:shutdown()
  vim.notify("Yanked: " .. file_name, "info", { title = "File Name Yanker", timeout = 1000 })
end
-- }}}
--------------------------------------------------------------------------------

return M

-- vim:foldmethod=marker
