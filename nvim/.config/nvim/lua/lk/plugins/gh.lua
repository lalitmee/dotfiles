local M = {
    "ldelossa/gh.nvim",
    dependencies = { "ldelossa/litee.nvim" },
    cmd = {
        "GHOpenIssue",
        "GHOpenPR",
        "GHSearchIssues",
        "GHSearchPRs",
    },
}

M.config = function()
    require("litee.lib").setup()
    require("litee.gh").setup()
end

return M
