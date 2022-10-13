local ok, eyeliner = lk.require("eyeliner")
if not ok then
  return
end

eyeliner.setup({
  highlight_on_key = true,
  -- bold = true,
  underline = true,
})
