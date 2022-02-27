local Job = require("plenary.job")

local M = {}

function M.notify_current_datetime()
  local dt = vim.fn.strftime("%c")
  require("notify")("Current Date Time: " .. dt, "info", { title = "Date & Time" })
end

-- @TODOUA: is this a util? Should it be made into one?
function M.yank_current_file_name()
  local file_name = vim.api.nvim_buf_get_name(0)
  local input_pipe = vim.loop.new_pipe(false)

  local yanker = Job:new({ writer = input_pipe, command = "pbcopy" })

  -- @TODOUA: This works perfectly but double-check if it could be better(less)
  yanker:start()
  input_pipe:write(file_name)
  input_pipe:close()
  yanker:shutdown()

  require("notify")("Yanked: " .. file_name, "info", { title = "File Name Yanker", timeout = 1000 })
end

return M
