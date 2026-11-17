-- Keep only your personal keybinding overrides here. Add new bindings with
-- o.bind or replace defaults with o.rebind.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding. o.rebind takes the same arguments as o.bind.
-- This example replaces the default file manager with Flea.
-- o.rebind("SUPER + SHIFT + F", "File manager", { launch = "flea" })
-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, { panel = "omarchy.emojis" })

-- Personal keybinding overrides.
o.rebind("SUPER + SHIFT + CTRL + SPACE", "omacast launcher", hl.dsp.global("omacast:toggle"))
o.rebind("SUPER + SHIFT + S", "Screenshot", "omarchy-capture-screenshot")
-- Each app owns a special workspace; existing windows are adopted on summon.
local scratchpads = {
    gemini = { key = "G", label = "Gemini web", pattern = "^brave%-gemini%.google%.com", command = o.launch_webapp("https://gemini.google.com") },
    chatgpt = { key = "C", label = "ChatGPT web", pattern = "^brave%-chatgpt%.com", command = o.launch_webapp("https://chatgpt.com") },
    youtube = { key = "Y", label = "YouTube Music", pattern = "^brave%-music%.youtube%.com", command = o.launch_webapp("https://music.youtube.com") },
    spotify = { key = "S", label = "Spotify", pattern = "^[Ss]potify$", command = o.launch("spotify") },
    discord = { key = "I", label = "Discord", pattern = "^brave%-discord%.com", command = o.launch_webapp("https://discord.com/channels/@me") },
    whatsapp = { key = "A", label = "WhatsApp web", pattern = "^brave%-web%.whatsapp%.com", command = o.launch_webapp("https://web.whatsapp.com/") },
    zapfast = { key = "P", label = "ZapFast", pattern = "^[Zz]apfast$", command = o.launch("zapfast") },
    files = { key = "F", label = "Files", pattern = "^org%.gnome%.Nautilus$", command = o.launch("nautilus --new-window") },
}

function toggle_app_scratchpad(name)
    local app = scratchpads[name]
    if not app then
        return
    end
    local workspace = "special:app-" .. name
    local found = false
    for _, window in ipairs(hl.get_windows()) do
        if (window.class or ""):match(app.pattern) then
            found = true
            hl.dispatch(hl.dsp.window.move({ workspace = workspace, follow = false, window = window }))
        end
    end
    if found then
        app.pending = nil
    elseif not app.pending or os.time() - app.pending >= 30 then
        -- Allow retry after a failed launch without duplicating rapid summons.
        app.pending = os.time()
        hl.exec_cmd(app.command, { workspace = workspace .. " silent" })
    end
    return hl.dsp.workspace.toggle_special("app-" .. name)
end

-- Browser singleton processes can ignore exec workspace placement.
hl.on("window.open", function(window)
    for name, app in pairs(scratchpads) do
        if app.pending and (window.class or ""):match(app.pattern) then
            app.pending = nil
            hl.dispatch(hl.dsp.window.move({ workspace = "special:app-" .. name, follow = false, window = window }))
        end
    end
end)

for name, app in pairs(scratchpads) do
    local toggle = function() hl.dispatch(toggle_app_scratchpad(name)) end
    o.bind_expressions[toggle] = string.format("toggle_app_scratchpad(%q)", name)
    -- ChatGPT replaces the former Google Maps shortcut.
    o.rebind("SUPER + CTRL + ALT + " .. app.key, app.label .. " scratchpad", toggle)
end
o.bind("SUPER + Z", "App scratchpads", { menu = "scratchpads" })
