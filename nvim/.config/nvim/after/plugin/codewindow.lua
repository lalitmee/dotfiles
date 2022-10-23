local ok, codewindow = lk.require("codewindow")
if not ok then
    return
end

codewindow.setup()

local command = lk.command

command("MinimapToggle", function()
    codewindow.toggle_minimap()
end, {})

command("MinimapOpen", function()
    codewindow.open_minimap()
end, {})

command("MinimapClose", function()
    codewindow.close_minimap()
end, {})

command("MinimapFocus", function()
    codewindow.toggle_focus()
end, {})
