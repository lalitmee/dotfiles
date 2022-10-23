local ok, leap = lk.require("leap")
if not ok then
    return
end

leap.add_default_mappings()
