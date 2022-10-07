local ok, neodim = lk.require("neodim")
if not ok then
    return
end

neodim.setup({
    alpha = 0.6,
})
