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

M.init = function()
    local wk = require("which-key")
    wk.register({
        ["g"] = {
            ["H"] = {
                ["name"] = "+gh.nvim",
                ["f"] = {
                    ":Telescope gh pull_request_files<CR>",
                    "gh-pr-files",
                },
                ["g"] = { ":Telescope gh gist<CR>", "gh-gist" },
                ["I"] = { ":Telescope gh issues<CR>", "gh-issues" },
                ["P"] = { ":Telescope gh pull_request<CR>", "gh-pr" },
                ["c"] = {
                    ["name"] = "+Commits",
                    ["c"] = { "<cmd>GHCloseCommit<cr>", "Close" },
                    ["e"] = { "<cmd>GHExpandCommit<cr>", "Expand" },
                    ["o"] = { "<cmd>GHOpenToCommit<cr>", "Open To" },
                    ["p"] = { "<cmd>GHPopOutCommit<cr>", "Pop Out" },
                    ["z"] = { "<cmd>GHCollapseCommit<cr>", "Collapse" },
                },
                ["i"] = {
                    ["name"] = "+Issues",
                    ["p"] = { "<cmd>GHPreviewIssue<cr>", "Preview" },
                },
                ["l"] = {
                    ["name"] = "+Litee",
                    ["t"] = { "<cmd>LTPanel<cr>", "Toggle Panel" },
                },
                ["r"] = {
                    ["name"] = "+Review",
                    ["b"] = { "<cmd>GHStartReview<cr>", "Begin" },
                    ["c"] = { "<cmd>GHCloseReview<cr>", "Close" },
                    ["d"] = { "<cmd>GHDeleteReview<cr>", "Delete" },
                    ["e"] = { "<cmd>GHExpandReview<cr>", "Expand" },
                    ["s"] = { "<cmd>GHSubmitReview<cr>", "Submit" },
                    ["z"] = { "<cmd>GHCollapseReview<cr>", "Collapse" },
                },
                ["p"] = {
                    ["name"] = "+Pull Request",
                    ["c"] = { "<cmd>GHClosePR<cr>", "Close" },
                    ["d"] = { "<cmd>GHPRDetails<cr>", "Details" },
                    ["e"] = { "<cmd>GHExpandPR<cr>", "Expand" },
                    ["o"] = { "<cmd>GHOpenPR<cr>", "Open" },
                    ["p"] = { "<cmd>GHPopOutPR<cr>", "PopOut" },
                    ["r"] = { "<cmd>GHRefreshPR<cr>", "Refresh" },
                    ["t"] = { "<cmd>GHOpenToPR<cr>", "Open To" },
                    ["z"] = { "<cmd>GHCollapsePR<cr>", "Collapse" },
                },
                ["t"] = {
                    ["name"] = "+Threads",
                    ["c"] = { "<cmd>GHCreateThread<cr>", "Create" },
                    ["n"] = { "<cmd>GHNextThread<cr>", "Next" },
                    ["t"] = { "<cmd>GHToggleThread<cr>", "Toggle" },
                },
            },
        },
    }, { mode = "n", prefix = "<leader>" })
end

return M
