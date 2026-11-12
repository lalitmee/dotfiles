-- Omarchy workspace IDs: laptop 1-10, portrait 11-20, middle 21-30.
-- Brave and its web apps share a process, so route by class after browser handoff.
o.window("^brave-browser$", { workspace = "21 silent" })
o.window("^brave-discord\\.com__channels_@me-.*$", { workspace = "2 silent" })
o.window("^brave-gemini\\.google\\.com.*$", { workspace = "12 silent" })
o.window("^brave-music\\.youtube\\.com.*$", { workspace = "3 silent" })

hl.on("hyprland.start", function()
    hl.exec_cmd(o.launch("brave"), { workspace = "21 silent" })
    hl.exec_cmd(o.launch("ghostty"), { workspace = "11 silent" })
    hl.exec_cmd(o.launch("slack"), { workspace = "1 silent" })
    hl.exec_cmd('omarchy-launch-webapp "https://discord.com/channels/@me"', { workspace = "2 silent" })
    hl.exec_cmd('omarchy-launch-webapp "https://gemini.google.com"', { workspace = "12 silent" })
    hl.exec_cmd('omarchy-launch-webapp "https://music.youtube.com"', { workspace = "3 silent" })
end)
