local ok, hop = lk.require("hop")
if not ok then
    return
end

hop.setup({ winblend = 100 })
