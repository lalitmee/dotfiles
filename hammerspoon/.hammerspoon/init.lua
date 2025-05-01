-- Move mouse to the center of the focused window
hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(win)
    if not win then
        return
    end
    local frame = win:frame()
    local center = hs.geometry.rectMidPoint(frame)
    hs.mouse.setAbsolutePosition(center)
end)
