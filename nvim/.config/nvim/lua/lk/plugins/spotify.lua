local ok, spotify = lk.require("nvim-spotify")
if not ok then
  return
end

spotify.setup({
  -- default opts
  status = {
    update_interval = 10000, -- the interval (ms) to check for what's currently playing
    format = "%s %t by %a", -- spotify-tui --format argument
  },
})
