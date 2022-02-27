local terminal = require("nvim-terminal").Terminal
local window = require("nvim-terminal").Window

Window = window:new({ pos = "vertical", split = "vsp" })

Terminal = terminal:new(window)

function Window:change_height(by)
  local _, height = Window:get_size()
  Window.height = height + by
  Window:update_size()
end
