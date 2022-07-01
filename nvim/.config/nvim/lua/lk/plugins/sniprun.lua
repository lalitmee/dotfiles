local ok, sniprun = lk.safe_require("sniprun")
if not ok then
  return
end

sniprun.setup({
  display = { "Terminal" },
  display_options = {
    terminal_width = 100,
  },
})
