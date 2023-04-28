return {
    "Mofiqul/vscode.nvim",
    event = { "ColorSchemePre" },
    init = function()
        require("vscode").setup({
            transparent = true,
            italic_comments = true,
            disable_nvimtree_bg = true,
        })
        require("vscode").load()
    end,
}
