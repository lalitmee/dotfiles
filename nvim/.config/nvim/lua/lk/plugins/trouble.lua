local ok, trouble = lk.safe_require("trouble")
if not ok then
  return
end

trouble.setup()
