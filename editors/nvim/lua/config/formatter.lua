require('formatter').setup({
    logging = false,
    filetype = {
        -- javascript = {
        --     -- prettier
        --    function()
        --       return {
        --         exe = "prettier",
        --         args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote'},
        --         stdin = true
        --       }
        --     end
        -- },
        rust = {
            -- Rustfmt
            function()
                return {exe = "rustfmt", args = {"--emit=stdout"}, stdin = true}
            end
        },
        vim = {
            -- luafmt
            function() vim.api.nvim_exec([[ LuaFormat() ]], true) end
        },
        lua = {
            -- luafmt
            function() vim.api.nvim_exec([[ LuaFormat() ]], true) end
        }
        -- json = {
        -- -- prettier
        -- function()
        --   return {
        --     exe = "prettier",
        --     stdin = true
        --   }
        -- end
        -- }
    }
})

vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.rs,*.lua FormatWrite
  autocmd BufWrite *.lua call LuaFormat()
augroup END
]], true)
