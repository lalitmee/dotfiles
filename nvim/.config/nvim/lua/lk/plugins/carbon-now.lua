local ok, carbonnow = lk.safe_require("carbonnow")
if not ok then
  return
end

-- setup
carbonnow.setup({
  theme = "cobalt",
})

----------------------------------------------------------------------
-- NOTE: command {{{
----------------------------------------------------------------------
lk.command("CarbonNow", function()
  carbonnow.capture()
end, { range = "%" })

-- }}}
----------------------------------------------------------------------
