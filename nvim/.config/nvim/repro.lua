vim.env.LAZY_STDPATH = ".repro"
vim.g.mapleader = " "

load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()

require("lazy.minit").repro({
    spec = {
        { "folke/snacks.nvim" },
    },
})
