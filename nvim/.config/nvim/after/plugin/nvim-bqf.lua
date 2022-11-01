local ok, bqf = lk.require("bqf")
if not ok then
    return
end

bqf.setup({
    auto_enable = true,
    preview = { auto_previw = true, win_height = 25, win_vheight = 25 },
    filter = {
        fzf = {
            extra_opts = {
                "--bind",
                "ctrl-s:select-all,ctrl-d:deselect-all",
                "--prompt",
                "Filter > ",
            },
        },
    },
})
