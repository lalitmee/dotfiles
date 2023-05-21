local tnoremap = lk.tnoremap
local augroup = lk.augroup

local opts = { silent = false, buffer = 0 }

augroup("terminal_au", {
    {
        event = { "TermOpen" },
        pattern = { "term://*" },
        command = function()
            if
                vim.bo.filetype == ""
                or vim.bo.filetype == "toggleterm"
                or vim.bo.filetype == "BufTerm"
            then
                tnoremap("<esc>", [[<C-\><C-n>]], opts)
                tnoremap("jk", [[<C-\><C-n>]], opts)
                tnoremap("<C-h>", [[<C-\><C-n><C-W>h]], opts)
                tnoremap("<C-j>", [[<C-\><C-n><C-W>j]], opts)
                tnoremap("<C-k>", [[<C-\><C-n><C-W>k]], opts)
                tnoremap("<C-l>", [[<C-\><C-n><C-W>l]], opts)
                tnoremap("<BS>", [[<BS>]], opts)
            end
            vim.cmd([[startinsert]])
        end,
    },
    {
        event = { "TermEnter" },
        pattern = { "term://*" },
        command = function()
            vim.cmd([[startinsert]])
        end,
    },
    {
        event = { "TermLeave", "TermClose" },
        pattern = { "term://*" },
        command = function()
            vim.cmd([[stopinsert]])
        end,
    },
    {
        event = { "FileType" },
        pattern = { "fzf" },
        command = function()
            vim.cmd([[tunmap <buffer> <ESC>]])
            tnoremap("<C-j>", "<Down>", opts)
            tnoremap("<C-k>", "<Up>", opts)
        end,
    },
})
