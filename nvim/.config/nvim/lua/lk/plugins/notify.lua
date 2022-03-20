local ok, notify = lk.safe_require("notify")
if not ok then
  return
end

---@type table<string, fun(bufnr: number, notif: table, highlights: table)>
local renderer = require("notify.render")

notify.setup({
  stages = "fade_in_slide_out",
  timeout = 3000,
  render = function(bufnr, notif, highlights)
    local style = notif.title[1] == "" and "minimal" or "default"
    renderer[style](bufnr, notif, highlights)
  end,
  icons = {
    ERROR = lk.style.icons.error,
    WARN = lk.style.icons.warn,
    INFO = lk.style.icons.info,
    DEBUG = lk.style.icons.debug,
    TRACE = lk.style.icons.trace,
  },
})
