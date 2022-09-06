local ok, buffertag = lk.require("buffertag")

if not ok then
  return
end

require("buffertag.config").config.border = "rounded"

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
