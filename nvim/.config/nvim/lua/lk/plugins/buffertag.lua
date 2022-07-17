local ok, buffertag = lk.safe_require("buffertag")

if not ok then
  return
end

buffertag.enable()

----------------------------------------------------------------------
-- NOTE: commands {{{
----------------------------------------------------------------------
local command = lk.command

command("BuffertagEnable", function()
  buffertag.enable()
end, {})

command("BuffertagDisable", function()
  buffertag.disable()
end, {})
-- }}}
----------------------------------------------------------------------
