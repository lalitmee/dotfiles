local augroup = lk.augroup
local tnoremap = lk.tnoremap
local fn = vim.fn

----------------------------------------------------------------------
-- NOTE: command line autocommands {{{
----------------------------------------------------------------------
--- automatically clear commandline messages after a few seconds delay
--- source: http://unix.stackexchange.com/a/613645
---@return function
local function clear_commandline()
    --- Track the timer object and stop any previous timers before setting
    --- a new one so that each change waits for 10secs and that 10secs is
    --- deferred each time
    local timer
    return function()
        if timer then
            timer:stop()
        end
        timer = vim.defer_fn(function()
            if fn.mode() == "n" then
                vim.cmd([[echon '']])
            end
        end, 10000)
    end
end

augroup("commandline_au", {
    {
        event = { "CmdlineLeave", "CmdlineChanged" },
        pattern = { ":" },
        command = clear_commandline(),
    },
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: terminal autocommands {{{
----------------------------------------------------------------------
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
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: highlight on yank {{{
----------------------------------------------------------------------
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
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: cursor line {{{
----------------------------------------------------------------------
local group = vim.api.nvim_create_augroup("cursor_line_au", { clear = true })
local set_cursorline = function(event, value, pattern)
    vim.api.nvim_create_autocmd(event, {
        group = group,
        pattern = pattern,
        callback = function()
            vim.opt_local.cursorline = value
        end,
    })
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")
-- }}}
----------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: kitty config reload {{{
--------------------------------------------------------------------------------
augroup("kitty_au", {
    {
        event = { "BufWritePost" },
        pattern = { "kitty.conf" },
        command = function()
            vim.cmd([[:silent !kill -SIGUSR1 $(pgrep kitty)]])
            vim.notify("config reloaded", 2, { title = "Kitty Config" })
        end,
    },
})
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: ginit.vim {{{
--------------------------------------------------------------------------------
augroup("ginit_au", {
    {
        event = { "BufWritePost" },
        pattern = { "ginit.vim" },
        command = function()
            vim.cmd([[so %]])
        end,
    },
})
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: quit on q {{{
--------------------------------------------------------------------------------
augroup("quit_q_au", {
    {
        event = { "FileType" },
        pattern = {
            "OverseerForm",
            "OverseerList",
            "checkhealth",
            "floggraph",
            "fugitive",
            "git",
            "gitcommit",
            "help",
            "log",
            "lspinfo",
            "man",
            "neotest-output",
            "neotest-summary",
            "oil",
            "qf",
            "query",
            "spectre_panel",
            "startuptime",
            "toggleterm",
            "tsplayground",
            "vim",
        },
        command = function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set(
                "n",
                "q",
                "<cmd>close<cr>",
                { buffer = event.buf, silent = true }
            )
        end,
    },
    {
        event = { "BufEnter" },
        -- buffer = 0,
        pattern = { "scriptease-verbose", "startup-log" },
        command = function()
            lk.nnoremap("q", ":bd<cr>")
        end,
    },
})
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: track buffers to close {{{
--------------------------------------------------------------------------------
local id = vim.api.nvim_create_augroup("startup", {
    clear = false,
})

local persistbuffer = function(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    vim.fn.setbufvar(bufnr, "bufpersist", 1)
end

vim.api.nvim_create_autocmd({ "BufRead" }, {
    group = id,
    pattern = { "*" },
    callback = function()
        vim.api.nvim_create_autocmd({ "InsertEnter", "BufModifiedSet" }, {
            buffer = 0,
            once = true,
            callback = function()
                persistbuffer()
            end,
        })
    end,
})

vim.keymap.set("n", "<leader>bu", function()
    local curbufnr = vim.api.nvim_get_current_buf()
    local buflist = vim.api.nvim_list_bufs()
    for _, bufnr in ipairs(buflist) do
        if
            vim.bo[bufnr].buflisted
            and bufnr ~= curbufnr
            and (vim.fn.getbufvar(bufnr, "bufpersist") ~= 1)
        then
            vim.cmd("bd " .. tostring(bufnr))
        end
    end
end, { silent = true, desc = "Close unused buffers" })
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: go to last location in the buffer {{{
--------------------------------------------------------------------------------
augroup("RestoreCursor_au", {
    {
        event = { "BufReadPost" },
        pattern = { "*" },
        command = function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            local lcount = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= lcount then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
        end,
    },
})
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: format options {{{
--------------------------------------------------------------------------------
augroup("format_options_au", {
    {
        event = "BufWinEnter",
        pattern = { "*" },
        command = function()
            vim.cmd("set formatoptions-=o")
        end,
    },
})
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: prevent opening things in insert mode {{{
-- telescope and dressing input are doing this right now
-- Prevent entering buffers in insert mode.
--------------------------------------------------------------------------------
augroup("insert_au", {
    {
        event = { "WinLeave" },
        pattern = { "TelescopePrompt", "DressingInput" },
        command = function()
            if
                -- vim.bo.ft == "TelescopePrompt"
                -- or vim.bo.ft == "DressingInput" and
                vim.fn.mode() == "i"
            then
                vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
                    "i",
                    false
                )
            end
        end,
    },
    {
        event = { "WinEnter" },
        pattern = { "*" },
        command = function()
            if
                -- vim.bo.ft == "TelescopePrompt"
                -- or vim.bo.ft == "DressingInput" and
                vim.fn.mode() == "i"
            then
                vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
                    "i",
                    false
                )
            end
        end,
    },
})
-- }}}
--------------------------------------------------------------------------------

-- vim:foldmethod=marker
