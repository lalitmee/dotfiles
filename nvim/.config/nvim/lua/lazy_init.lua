-- bootstrap from github
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

-- load lazy
require("lazy").setup("plugins", {
    dev = {
        path = "~/Projects/Personal/Github", -- path to your local plugins
        patterns = { "lalitmee" }, -- For example {"folke"}
        fallback = true, -- Fallback to git when local plugin doesn't exist
    },
    rocks = {
        enabled = true,
        hererocks = true,
    },
    defaults = {
        lazy = true,
    },
    change_detection = {
        notify = false,
    },
    checker = {
        enabled = false,
    },
    performance = {
        cache = {
            enabled = true,
        },
        rtp = {
            disabled_plugins = {
                "2html_plugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "netrw",
                "netrwFileHandlers",
                "netrwPlugin",
                "netrwSettings",
                "rrhelper",
                "spellfile_plugin",
                "tar",
                "tarPlugin",
                "tohtml",
                "tutor",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
            },
        },
    },
    debug = false,
    ui = {
        border = "rounded",
        backdrop = 100,
    },
})

-- load colorscheme
vim.cmd.colorscheme("cobalt2")
