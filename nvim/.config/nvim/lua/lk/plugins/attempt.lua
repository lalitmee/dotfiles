local ok, attempt = lk.safe_require("attempt")
if not ok then
  return
end

----------------------------------------------------------------------
-- NOTE: attempt setup {{{
----------------------------------------------------------------------
attempt.setup()

----------------------------------------------------------------------
-- NOTE: commands {{{
----------------------------------------------------------------------
local command = lk.command

command("AttemptNew", function()
  attempt.new_select()
end, {})

command("AttemptNewExtension", function()
  attempt.new_input_ext()
end, {})

command("AttemptRun", function()
  attempt.run()
end, {})

command("AttemptDeleteBuf", function()
  attempt.delete_buf()
end, {})

command("AttemptRenameBuf", function()
  attempt.rename_buf()
end, {})

-- }}}
----------------------------------------------------------------------

-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: telescope extension {{{
----------------------------------------------------------------------
require("telescope").load_extension("attempt")
-- }}}
----------------------------------------------------------------------
