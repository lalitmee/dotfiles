local M = {
    "phaazon/hop.nvim",
    branch = "v2",
    cmd = {
        "HopPattern",
        "HopChar1AC",
        "HopChar1BC",
        "HopChar1",
        "HopChar2",
        "HopLineStart",
        "HopLine",
        "HopChar2AC",
        "HopChar2BC",
        "HopWord",
        "HopWordMW",
    },
}

M.config = function()
    require("hop").setup()
end

return M
