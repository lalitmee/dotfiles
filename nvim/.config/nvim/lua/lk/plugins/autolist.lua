local ok, autolist = lk.require("autolist")
if not ok then
  return
end

autolist.setup({
  enable = true,
  enabled_filetypes = { "markdown", "text", "norg" },
})
