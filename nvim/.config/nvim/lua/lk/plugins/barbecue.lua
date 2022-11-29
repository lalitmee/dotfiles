local ok, barbecue = lk.require("barbecue")
if not ok then
    return
end

barbecue.setup({
    exclude_filetypes = {
        "NeogitCommitMessage",
        "NeogitCommitPopup",
        "NeogitHelpPopup",
        "NeogitPopup",
        "NeogitStatus",
    },
    truncation = {
        enabled = false,
    },
    symbols = {
        modified = "[+]",
        separator = "",
    },
})
