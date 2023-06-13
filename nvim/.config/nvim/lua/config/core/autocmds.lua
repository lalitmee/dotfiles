local augroup = lk.augroup

augroup("yank_au", {
    {
        -- don't execute silently in case of errors
        event = { "TextYankPost" },
        command = function()
            vim.highlight.on_yank({
                timeout = 40,
                on_visual = false,
                higroup = "IncSearch",
            })
        end,
    },
})

augroup("ginit_au", {
    {
        event = { "BufWritePost" },
        pattern = { "ginit.vim" },
        command = function()
            vim.cmd([[so %]])
        end,
    },
})

-- telescope and dressing input are doing this right now
-- Prevent entering buffers in insert mode.
--------------------------------------------------------------------------------
augroup("insert_au", {
    {
        event = { "WinLeave" },
        pattern = { "TelescopePrompt", "DressingInput" },
        command = function()
            if vim.fn.mode() == "i" then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
            end
        end,
    },
    {
        event = { "WinEnter" },
        pattern = { "*" },
        command = function()
            if vim.fn.mode() == "i" then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
            end
        end,
    },
})
