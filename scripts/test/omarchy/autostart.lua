-- Run from the repository root; no real apps or compositor state are changed.
local config = "omarchy/.config/hypr/autostart.lua"
local classes = {
    [21] = "co.hyprlab.Hylki", [22] = "brave-browser",
    [11] = "com.mitchellh.ghostty", [1] = "slack",
    [24] = "herdr-app", [23] = "t3code",
    [2] = "vivaldi-stable",
    [12] = "antigravity", [13] = "chatgpt",
}

local function scenario(restored, reload)
    local hooks, timers, launches, rules, windows = {}, {}, {}, {}, {}
    local delayed = {}
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
            if command == "true" then return end
            local seconds, expression = command:match("^sleep (%d+) && hyprctl dispatch '(.+)'$")
            if seconds then
                delayed[#delayed + 1] = { expression = expression, at = now + tonumber(seconds) * 1000 }
                return
            end
            local id = tonumber(opts.workspace:match("^%d+"))
            launches[#launches + 1] = { command = command, id = id, at = now }
        end,
    }
    hl.dsp = { exec_cmd = function(command, opts)
        return function() hl.exec_cmd(command, opts) end
    end }
    o = {
        window = function(_match, _rules) end,
        launch = function(cmd) return "uwsm-app -- " .. cmd end,
        launch_webapp = function(url) return "omarchy-launch-webapp '" .. url .. "'" end,
        launch_on_start = function(command) assert(command == "hyprsunset") end,
    }
    dofile(config)
    hooks["hyprland.start"]()
    assert(#launches == 9, "nine desktop apps start immediately")
    for i, id in ipairs({ 21, 22, 11, 1, 2, 24, 23, 12, 13 }) do
        assert(launches[i].id == id, "desktop startup workspace order")
    end
    assert(launches[1].command:find("APPIMAGE_EXTRACT_AND_RUN=1", 1, true), "Hylki needs AppImage extraction")
    -- Session restoration happens after the first browser launch.
    if restored then
        for _, id in ipairs({ 2 }) do
            windows[#windows + 1] = { class = classes[id] }
        end
    end
    hooks["hyprland.start"]()
    assert(#launches == 9, "repeated startup must not schedule a second queue")
    if reload then
        -- Reload destroys Lua timers, but already spawned shell processes survive.
        timers = {}
        dofile(config)
    end
    while #timers > 0 do
        local timer = table.remove(timers, 1)
        now = timer.at
        timer.fn()
        assert(now < 120000, "startup queue must finish")
    end
    for _, job in ipairs(delayed) do
        now = job.at
        local action = assert(load("return " .. job.expression))()
        if action then action() end
    end
    assert(#launches == 9, "Discord scratchpad must not autostart")
    for _, launch in ipairs(launches) do
        assert(launch.id ~= 3 and launch.id ~= 4 and launch.id ~= 14 and launch.id ~= 15,
            "scratchpads must not autostart")
    end
    for _, id in ipairs({ 21, 22, 23, 24 }) do
        assert(rules[id] == "desc:BNQ BenQ GW2480 C6K0150601Q", "middle workspace must bind to middle monitor")
    end
    for _, id in ipairs({ 11, 12 }) do
        assert(rules[id] == "desc:BNQ BenQ GW2480 ETD7L03841SL0", "portrait workspace must bind to portrait monitor")
    end
    for _, id in ipairs({ 1, 2 }) do
        assert(rules[id] == "eDP-1", "laptop workspace must bind to laptop monitor")
    end
end

scenario(false)
scenario(true)
scenario(false, true)
scenario(true, true)
print("Autostart: scratchpad exclusion, physical-monitor bindings, and repeat-start guard passed")
