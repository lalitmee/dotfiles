local ok, zen_mode = lk.safe_require("zen-mode")

if ok then
  return
end

zen_mode.setup()
