local ok, mind = lk.require("mind")
if not ok then
    return
end

mind.setup({
    ui = { width = 80 },
})
