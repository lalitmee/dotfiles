return {
    "glacambre/firenvim",
    lazy = false,
    cond = not not vim.g.started_by_firenvim,
    build = function()
        require("lazy").load({ plugins = "firenvim", wait = true })
        vim.fn["firenvim#install"](0)
    end,
    config = function()
        vim.api.nvim_create_autocmd({ "UIEnter" }, {
            callback = function()
                local client =
                    vim.api.nvim_get_chan_info(vim.v.event.chan).client
                if client ~= nil and client.name == "Firenvim" then
                    vim.o.laststatus = 0
                    vim.o.showtabline = 0
                    vim.o.number = false
                end
            end,
        })
    end,
    enabled = false,
}
