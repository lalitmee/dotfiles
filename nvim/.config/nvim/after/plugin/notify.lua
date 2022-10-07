local ok, notify = lk.require("notify")
if not ok then
  return
end

local api = vim.api
local notify_icons = lk.style.icons.notify

-- NOTE: vim.log.levels
-- {
--   DEBUG = 1,
--   ERROR = 4,
--   INFO = 2,
--   OFF = 5,
--   TRACE = 0,
--   WARN = 3
-- }

notify.setup({
  background_colour = "ColorColumn",
  timeout = 3000,
  stages = "fade_in_slide_out",
  max_width = function()
    return math.floor(vim.o.columns * 0.8)
  end,
  max_height = function()
    return math.floor(vim.o.lines * 0.8)
  end,
  on_open = function(win)
    if api.nvim_win_is_valid(win) then
      vim.api.nvim_win_set_config(win, { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } })
    end
  end,
  render = function(...)
    local notif = select(2, ...)
    local style = notif.title[1] == "" and "minimal" or "default"
    require("notify.render")[style](...)
  end,
  icons = {
    DEBUG = notify_icons.debug,
    ERROR = notify_icons.error,
    INFO = notify_icons.info,
    TRACE = notify_icons.trace,
    WARN = notify_icons.warn,
  },
})
vim.notify = notify

local notify_filter = vim.notify
vim.notify = function(msg, ...)
  if msg:match("warning: multiple different client offset_encodings") then
    return
  end
  if msg:match("character_offset must be called") then
    return
  end

  notify_filter(msg, ...)
end
