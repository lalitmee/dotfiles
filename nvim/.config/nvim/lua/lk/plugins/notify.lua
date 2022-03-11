local ok, notify = lk.safe_require("notify")
if not ok then
  return
end

notify.setup({
  stages = "static",
  timeout = 3000,
  icons = {
    ERROR = lk.style.icons.error,
    WARN = lk.style.icons.warn,
    INFO = lk.style.icons.info,
    DEBUG = lk.style.icons.debug,
    TRACE = lk.style.icons.trace,
  },
})
