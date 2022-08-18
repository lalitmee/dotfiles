local ok, replacer = lk.safe_require("replacer")
if not ok then
  return
end

----------------------------------------------------------------------
-- NOTE: replacer.nvim commands {{{
----------------------------------------------------------------------
local command = lk.command

command("ReplacerRunFiles", function()
  replacer.run()
end, {})

command("ReplacerRun", function()
  replacer.run({ rename_files = false })
end, {})

command("ReplacerRunF", function()
  replacer.run()
end, {})
-- }}}
----------------------------------------------------------------------
