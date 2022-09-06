local ok, nvim_surround = lk.require("nvim-surround")
if not ok then
  return
end

nvim_surround.setup()
