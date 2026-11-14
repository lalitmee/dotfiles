-- Omarchy workspace IDs: laptop 1-10, portrait 11-20, middle 21-30.
-- Workspace rules to bind workspace IDs to physical monitors
for _, group in ipairs({
    { monitor = "eDP-1", workspaces = { 1, 2, 3 } },
    { monitor = "desc:BNQ BenQ GW2480 ETD7L03841SL0", workspaces = { 11, 12 } },
    { monitor = "desc:BNQ BenQ GW2480 C6K0150601Q", workspaces = { 21, 22, 23 } },
}) do
    for _, workspace in ipairs(group.workspaces) do
        hl.workspace_rule({ workspace = tostring(workspace), monitor = group.monitor })
    end
end

-- Route windows to designated workspaces
-- Middle monitor: DP-2
o.window("^brave-browser$", { workspace = "21 silent" })
o.window("^herdr-app$", { workspace = "22 silent" })
o.window("^(t3code|com\\.t3tools\\.T3Code)$", { workspace = "23 silent" })

-- Laptop monitor: eDP-1
o.window("^slack$", { workspace = "1 silent" })
o.window("^brave-discord\\.com__channels_@me-.*$", { workspace = "2 silent" })
o.window("^brave-music\\.youtube\\.com.*$", { workspace = "3 silent" })

-- Portrait monitor: DP-1
o.window("^brave-gemini\\.google\\.com.*$", { workspace = "12 silent" })

local started = false
hl.on("hyprland.start", function()
    if started then
        return
    end
    started = true

    local home = os.getenv("HOME") or "/home/lalitmee"

    local function app_is_running(pattern)
        for _, window in ipairs(hl.get_windows()) do
            if window.class and window.class:match(pattern) then
                return true
            end
        end
        return false
    end

    local function launch_if_missing(pattern, command, workspace)
        if not app_is_running(pattern) then
            hl.exec_cmd(command, { workspace = workspace .. " silent" })
        end
    end

    -- Phase 1: Standalone desktop apps (launch immediately)
    launch_if_missing("^brave-browser$", o.launch("brave"), 21)
    launch_if_missing("^com%.mitchellh%.ghostty$", o.launch("ghostty"), 11)
    launch_if_missing("^slack$", o.launch("slack"), 1)
    launch_if_missing("^herdr%-app$", o.launch(home .. "/.local/bin/herdr-app"), 22)
    launch_if_missing("t3code", o.launch(home .. "/.local/share/t3code/T3-Code.AppImage"), 23)

    -- Phase 2: Web apps (staggered slightly after Brave creates its singleton socket)
    hl.timer(function()
        launch_if_missing("^brave%-discord", o.launch_webapp("https://discord.com/channels/@me"), 2)
    end, { type = "oneshot", timeout = 3000 })

    hl.timer(function()
        launch_if_missing("^brave%-gemini", o.launch_webapp("https://gemini.google.com"), 4000)
    end, { type = "oneshot", timeout = 4000 })

    hl.timer(function()
        launch_if_missing("^brave%-music", o.launch_webapp("https://music.youtube.com"), 5000)
    end, { type = "oneshot", timeout = 5000 })
end)
