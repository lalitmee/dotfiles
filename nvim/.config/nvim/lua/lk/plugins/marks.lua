local ok, marks = lk.safe_require("marks")
if not ok then
  return
end

marks.setup()
