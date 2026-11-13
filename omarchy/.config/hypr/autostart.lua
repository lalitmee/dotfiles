-- Omarchy workspace IDs: laptop 1-10, portrait 11-20, middle 21-30.
-- A silent workspace number alone does not select its physical monitor.
for _, group in ipairs({
    { monitor = "eDP-1", workspaces = { 1, 2, 3 } },
    { monitor = "desc:BNQ BenQ GW2480 ETD7L03841SL0", workspaces = { 11, 12 } },
    { monitor = "desc:BNQ BenQ GW2480 C6K0150601Q", workspaces = { 21, 22, 23 } },
}) do
    for _, workspace in ipairs(group.workspaces) do
        hl.workspace_rule({ workspace = tostring(workspace), monitor = group.monitor })
    end
end

-- Brave and its web apps share a process, so route by class after browser handoff.
o.window("^brave-browser$", { workspace = "21 silent" })
o.window("^brave-discord\\.com__channels_@me-.*$", { workspace = "2 silent" })
o.window("^brave-gemini\\.google\\.com.*$", { workspace = "12 silent" })
o.window("^brave-music\\.youtube\\.com.*$", { workspace = "3 silent" })

local apps = {
    { class = "brave-browser", workspace = 21, command = o.launch("brave") },
    { class = "com.mitchellh.ghostty", workspace = 11, command = o.launch("ghostty") },
    { class = "slack", workspace = 1, command = o.launch("slack") },
    { class = "herdr-app", workspace = 22, command = o.launch('"$HOME/.local/bin/herdr-app"') },
    {
        class = "com.t3tools.T3Code",
        workspace = 23,
        command = o.launch('"$HOME/.local/share/t3code/T3-Code.AppImage"'),
    },
    {
        class = "brave-discord.com__channels_@me-Default",
        workspace = 2,
        command = o.launch_webapp("https://discord.com/channels/@me"),
    },
    {
        class = "brave-gemini.google.com__-Default",
        workspace = 12,
        command = o.launch_webapp("https://gemini.google.com"),
    },
    {
        class = "brave-music.youtube.com__-Default",
        workspace = 3,
        command = o.launch_webapp("https://music.youtube.com"),
    },
}

local started = false
hl.on("hyprland.start", function()
    if started then
        return
    end
    started = true

    local function launch_next(index)
        local app = apps[index]
        if not app then
            return
        end

        local exists = false
        for _, window in ipairs(hl.get_windows()) do
            if window.class == app.class then
                exists = true
                break
            end
        end
        if not exists then
            hl.exec_cmd(app.command, { workspace = app.workspace .. " silent" })
        end

        if apps[index + 1] then
            -- shortcut: allow 20s for browser restore; increase if slow boots still race.
            hl.timer(function()
                launch_next(index + 1)
            end, { type = "oneshot", timeout = index == 1 and 20000 or 5000 })
        end
    end

    launch_next(1)
end)
