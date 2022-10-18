local ok, codewindow = lk.require("codewindow")
if not ok then
    return
end

-- setup
codewindow.setup()

-- commands
local command = lk.command

command("MinimapOpen", function()
    codewindow.open_minimap()
end, {})

command("MinimapClose", function()
    codewindow.close_minimap()
end, {})

command("MinimapToggle", function()
    codewindow.toggle_focus()
end, {})
