local ok, symbols_outline = lk.safe_require("symbols-outline")
if not ok then
  return
end

symbols_outline.setup({
  auto_close = true,
  show_numbers = true,
})
