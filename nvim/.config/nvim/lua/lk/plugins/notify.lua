local ok, notify = lk.safe_require("notify")
if not ok then
  return
end

---@type table<string, fun(bufnr: number, notif: table, highlights: table)>
local renderer = require("notify.render")

local notify_icons = lk.style.icons.notify

notify.setup({
  stages = "fade_in_slide_out",
  timeout = 3000,
  render = function(bufnr, notif, highlights)
    local style = notif.title[1] == "" and "minimal" or "default"
    renderer[style](bufnr, notif, highlights)
  end,
  icons = {
    DEBUG = notify_icons.debug,
    ERROR = notify_icons.error,
    INFO = notify_icons.info,
    TRACE = notify_icons.trace,
    WARN = notify_icons.warn,
  },
})
