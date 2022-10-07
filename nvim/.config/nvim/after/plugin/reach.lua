local ok, reach = lk.require("reach")
if not ok then
  return
end

reach.setup({
  notifications = true,
})
