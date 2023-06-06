local augroup = lk.augroup

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
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
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
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
            end
        end,
    },
})
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  to make `vim-matchup` work in jsx
--------------------------------------------------------------------------------
augroup("vim_matchup_au", {
    {
        event = { "FileType" },
        pattern = { "javascript" },
        command = function()
            vim.cmd([[
                function! JsxHotfix()
                    setlocal matchpairs=(:),{:},[:],<:>
                    let b:match_words = '<\@<=\([^/][^ \t>]*\)\g{hlend}[^>]*\%(/\@<!>\|$\):<\@<=/\1>'
                endfunction
                let g:matchup_hotfix = { 'javascript': 'JsxHotfix' }
            ]])
        end,
    },
})

-- vim:foldmethod=marker
