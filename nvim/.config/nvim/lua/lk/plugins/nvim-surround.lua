local ok, nvim_surround = lk.safe_require("nvim-surround")
if not ok then
  return
end

nvim_surround.setup()
