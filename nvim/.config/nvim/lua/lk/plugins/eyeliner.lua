local ok, eyeliner = lk.safe_require("eyeliner")
if not ok then
  return
end

eyeliner.setup({
  -- bold = true,
  underline = true,
})
