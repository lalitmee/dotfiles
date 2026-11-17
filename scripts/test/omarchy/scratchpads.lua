-- Run from the repository root; does not launch apps or alter the compositor.
local windows, launches, moves, toggles, hooks, binds = {}, {}, {}, {}, {}, {}
hl = {
    on = function(event, fn) hooks[event] = fn end,
    get_windows = function() return windows end,
    exec_cmd = function(command, options) launches[#launches + 1] = { command, options } end,
    dispatch = function(action) action() end,
    dsp = {
        global = function() return function() end end,
        window = { move = function(options) return function() moves[#moves + 1] = options end end },
        workspace = { toggle_special = function(name) return function() toggles[#toggles + 1] = name end end },
    },
}
o = {
    bind_expressions = {},
    bind = function(key, _, action) binds[key] = action end,
    launch = function(command) return command end,
    launch_webapp = function(url) return url end,
}
o.rebind = o.bind
dofile("omarchy/.config/hypr/bindings.lua")
assert(#launches == 0, "configuration must not launch scratchpads")
for _, name in ipairs({ "gemini", "chatgpt", "youtube", "spotify", "discord", "whatsapp", "zapfast", "files" }) do
    local before = #launches
    local action = toggle_app_scratchpad(name)
    assert(#launches == before + 1, name .. " must launch on first summon")
    hl.dispatch(action)
    assert(launches[#launches][2].workspace == "special:app-" .. name .. " silent")
    local count = #launches
    hl.dispatch(toggle_app_scratchpad(name))
    assert(#launches == count, "rapid summon must not duplicate launch")
end
local web = { class = "brave-chatgpt.com__-Default" }
hooks["window.open"](web)
assert(moves[#moves].workspace == "special:app-chatgpt")
windows = { web, { class = "chatgpt" }, { class = "antigravity" } }
local count, moved = #launches, #moves
binds["SUPER + CTRL + ALT + C"]()
assert(#launches == count and #moves == moved + 1, "adopt web only; leave desktop apps alone")
assert(moves[#moves].window == web and moves[#moves].follow == false)
assert(toggles[#toggles] == "app-chatgpt")
assert(binds["SUPER + Z"].menu == "scratchpads")
for _, app in ipairs({
    { name = "discord", key = "I", class = "brave-discord.com__channels_@me-Default" },
    { name = "whatsapp", key = "A", class = "brave-web.whatsapp.com__-Default" },
    { name = "zapfast", key = "P", class = "zapfast" },
    { name = "files", key = "F", class = "org.gnome.Nautilus" },
}) do
    local window = { class = app.class }
    hooks["window.open"](window)
    assert(moves[#moves].workspace == "special:app-" .. app.name, "route new " .. app.name)
    windows = { window }
    local before = #launches
    binds["SUPER + CTRL + ALT + " .. app.key]()
    assert(#launches == before, "adopt existing " .. app.name)
    assert(moves[#moves].window == window)
    assert(toggles[#toggles] == "app-" .. app.name)
end
count = #launches
toggle_app_scratchpad("unknown")
assert(#launches == count, "unknown names must do nothing")
print("Scratchpads: lazy launch, duplicate guard, browser routing, adoption, and bindings passed")
