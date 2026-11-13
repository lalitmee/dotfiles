-- Run from the repository root; no real apps or compositor state are changed.
local config = "omarchy/.config/hypr/autostart.lua"
local classes = {
    [21] = "brave-browser", [11] = "com.mitchellh.ghostty", [1] = "slack",
    [22] = "herdr-app", [23] = "com.t3tools.T3Code",
    [2] = "brave-discord.com__channels_@me-Default",
    [12] = "brave-gemini.google.com__-Default",
    [3] = "brave-music.youtube.com__-Default",
}

local function scenario(restored)
    local hooks, timers, launches, rules, windows = {}, {}, {}, {}, {}
    local now = 0
    hl = {
        on = function(event, fn) hooks[event] = fn end,
        workspace_rule = function(rule) rules[tonumber(rule.workspace)] = rule.monitor end,
        get_windows = function() return windows end,
        timer = function(fn, opts)
            assert(opts.type == "oneshot")
            timers[#timers + 1] = { fn = fn, at = now + opts.timeout }
        end,
        exec_cmd = function(command, opts)
            local id = tonumber(opts.workspace:match("^%d+"))
            launches[#launches + 1] = { command = command, id = id, at = now }
        end,
    }
    o = {
        window = function() end,
        launch = function(cmd) return "uwsm-app -- " .. cmd end,
        launch_webapp = function(url) return "omarchy-launch-webapp '" .. url .. "'" end,
    }
    dofile(config)
    hooks["hyprland.start"]()
    assert(#launches == 1 and launches[1].id == 21, "only Brave may start immediately")
    -- Session restoration happens after the first browser launch.
    if restored then
        for _, id in ipairs({ 2, 12, 3 }) do
            windows[#windows + 1] = { class = classes[id] }
        end
    end
    hooks["hyprland.start"]()
    assert(#launches == 1, "repeated startup must not schedule a second queue")
    while #timers > 0 do
        local timer = table.remove(timers, 1)
        now = timer.at
        timer.fn()
        assert(now < 120000, "startup queue must finish")
    end
    assert(#launches == (restored and 5 or 8), "restored apps must not be relaunched")
    for i = 2, #launches do
        assert(launches[i].at - launches[i - 1].at >= 5000, "launches must be spaced")
    end
    assert(launches[2].at >= 20000, "allow browser session restoration before other apps")
    for _, id in ipairs({ 21, 22, 23 }) do
        assert(rules[id] == "desc:BNQ BenQ GW2480 C6K0150601Q", "middle workspace must bind to middle monitor")
    end
    for _, id in ipairs({ 11, 12 }) do
        assert(rules[id] == "desc:BNQ BenQ GW2480 ETD7L03841SL0", "portrait workspace must bind to portrait monitor")
    end
    for _, id in ipairs({ 1, 2, 3 }) do
        assert(rules[id] == "eDP-1", "laptop workspace must bind to laptop monitor")
    end
end

scenario(false)
scenario(true)
print("Autostart: pacing, restoration skips, monitor bindings, and repeat-start guard passed")
