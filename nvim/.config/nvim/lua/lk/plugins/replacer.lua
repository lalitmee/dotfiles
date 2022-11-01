local ok, replacer = lk.require("replacer")
if not ok then
    return
end

----------------------------------------------------------------------
-- NOTE: replacer.nvim commands {{{
----------------------------------------------------------------------
local command = lk.command

-- this can rename or replace everything in quickfix
command("ReplacerFiles", function()
    replacer.run()
end, {})

-- this will not rename or move file names
command("Replacer", function()
    replacer.run({ rename_files = false })
end, {})
-- }}}
----------------------------------------------------------------------
