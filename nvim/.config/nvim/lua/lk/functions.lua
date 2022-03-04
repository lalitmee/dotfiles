local Job = require("plenary.job")

local fn = vim.fn

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
  local yanker = Job:new({ writer = input_pipe, command = "pbcopy" })
  yanker:start()
  input_pipe:write(file_name)
  input_pipe:close()
  yanker:shutdown()
  vim.notify("Yanked: " .. file_name, "info", { title = "File Name Yanker", timeout = 1000 })
end
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--- NOTE: clear messages {{{

-- automatically clear commandline messages after a few seconds delay
--- source: https://unix.stackexchange.com/a/613645
--------------------------------------------------------------------------------
function M.clear_messages()
  local id
  return function()
    if id then
      fn.timer_stop(id)
    end
    id = fn.timer_start(2000, function()
      if fn.mode() == "n" then
        vim.cmd([[echon '']])
      end
    end)
  end
end
--}}}
--------------------------------------------------------------------------------

return M

-- vim:foldmethod=marker
