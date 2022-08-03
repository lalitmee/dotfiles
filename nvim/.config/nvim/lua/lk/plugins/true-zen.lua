local ok, true_zen = lk.safe_require("true-zen")
if not ok then
  return
end

true_zen.setup()
