return {
    {
        "Vimjas/vim-python-pep8-indent",
        ft = "python",
    },
    {
        "antonk52/markdowny.nvim",
        ft = { "markdown" },
        keys = {
            { "<C-b>", mode = "v" },
            { "<C-k>", mode = "v" },
            { "<C-i>", mode = "v" },
        },
        opts = {},
    },
    {
        "iamcco/markdown-preview.nvim",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        ft = "markdown",
        cmd = { "MarkdownPreview" },
    },
    {
        "ray-x/go.nvim",
        ft = "go",
    },
}
