-- Omarchy workspace IDs: laptop 1-10, portrait 11-20, middle 21-30.
-- Workspace rules to bind workspace IDs to physical monitors
for _, group in ipairs({
    { monitor = "eDP-1", workspaces = { 1, 2 } },
    { monitor = "desc:BNQ BenQ GW2480 ETD7L03841SL0", workspaces = { 11, 12, 13 } },
    { monitor = "desc:BNQ BenQ GW2480 C6K0150601Q", workspaces = { 21, 22, 23, 24 } },
}) do
    for _, workspace in ipairs(group.workspaces) do
        hl.workspace_rule({ workspace = tostring(workspace), monitor = group.monitor })
    end
end

-- Route windows to designated workspaces
-- Middle monitor: DP-2
o.window("^co\\.hyprlab\\.Hylki$", { workspace = "21 silent" })
o.window("^brave-browser$", { workspace = "22 silent" })
o.window("^herdr-app$", { workspace = "24 silent" })
o.window("^(t3code|com\\.t3tools\\.T3Code)$", { workspace = "23 silent" })

-- Laptop monitor: eDP-1
o.window("^slack$", { workspace = "1 silent" })
o.window("^brave-discord\\.com__channels_@me-.*$", { workspace = "2 silent" })

-- Portrait monitor: DP-1
o.window("^[Aa]ntigravity$", { workspace = "12 silent" })
o.window("^chatgpt$", { workspace = "13 silent" })

-- Auto-start hyprsunset for automated night light scheduling
o.launch_on_start("hyprsunset")

-- Called by the delayed shell after any startup-time config reloads.
function autostart_discord()
    for _, window in ipairs(hl.get_windows()) do
        if (window.class or ""):match("^brave%-discord") then
            return hl.dsp.exec_cmd("true")
        end
    end
    return hl.dsp.exec_cmd(o.launch_webapp("https://discord.com/channels/@me"), { workspace = "2 silent" })
end

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
    launch_if_missing("^co%.hyprlab%.Hylki$", o.launch("env APPIMAGE_EXTRACT_AND_RUN=1 " .. home .. "/Applications/Hylki-x86_64.AppImage"), 21)
    launch_if_missing("^brave-browser$", o.launch("brave"), 22)
    launch_if_missing("^com%.mitchellh%.ghostty$", o.launch("ghostty"), 11)
    launch_if_missing("^slack$", o.launch("slack"), 1)
    launch_if_missing("^herdr%-app$", o.launch(home .. "/.local/bin/herdr-app"), 24)
    launch_if_missing("t3code", o.launch(home .. "/.local/share/t3code/T3-Code.AppImage"), 23)
    launch_if_missing("^[Aa]ntigravity$", o.launch(home .. "/.local/bin/antigravity"), 12)
    launch_if_missing("^chatgpt$", o.launch("chatgpt"), 13)

    -- A shell delay survives config reloads, which cancel pending Lua timers.
    hl.exec_cmd("sleep 3 && hyprctl dispatch 'autostart_discord()'")
end)
