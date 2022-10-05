local ok, noice = lk.require("noice")
if not ok then
  return
end

noice.setup({
  routes = {
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      opts = { skip = true },
    },
  },
})
