return {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    init = function()
        require("vscode").setup({
            transparent = true,
            italic_comments = true,
            disable_nvimtree_bg = true,
        })
        require("vscode").load()
    end,
}
