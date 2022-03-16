local ok, Job = lk.safe_require("plenary.job")
if not ok then
  return
end

--------------------------------------------------------------------------------
-- NOTE: notify current date and time {{{
--------------------------------------------------------------------------------
function Notify_current_datetime()
  local dt = vim.fn.strftime("%c")
  vim.notify("Current Date Time: " .. dt, "info", { title = "Date & Time" })
end
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE:yank current file name {{{
--------------------------------------------------------------------------------
function Yank_current_file_name()
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

function Log_var()
  local word_under_cursor = vim.fn.expand("<cword>")
  local filetype = vim.fn.expand("%:p:e")
  if filetype == "lua" then
    vim.cmd(string.format("norm!oprint('%s', %s)", word_under_cursor, word_under_cursor))
  elseif filetype == "js" then
    vim.cmd(string.format("norm!oconsole.log({%s})", word_under_cursor))
  end
end

-- vim:foldmethod=marker
