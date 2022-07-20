local ok, stay_in_place = lk.safe_require("stay-in-place")
if not ok then
  return
end

stay_in_place.setup()
