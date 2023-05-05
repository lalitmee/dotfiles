local g = vim.g
local api = vim.api
local option = api.nvim_buf_get_option
local fmt = string.format

----------------------------------------------------------------------
-- NOTE: save and execute {{{
----------------------------------------------------------------------
function Save_and_execute()
    local filetype = vim.bo.filetype
    local filepath = vim.fn.expand("%")
    if filetype == "lua" then
        vim.cmd([[
      silent! write
      luafile %
    ]])
    elseif filetype == "vim" then
        vim.cmd([[
      silent! write
      source %
    ]])
    else
        vim.cmd([[
      silent! write
    ]])
    end
    vim.notify(filepath, 2, { title = " Save and Execute" })
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: smart dd {{{
----------------------------------------------------------------------
local function smart_dd()
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
    else
        return "dd"
    end
end

lk.map("n", "dd", smart_dd, { noremap = true, expr = true })
-- }}}
----------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: BufOnly {{{
--------------------------------------------------------------------------------
local function buf_only()
    local del_non_modifiable = g.bufonly_delete_non_modifiable or false
    local cur = api.nvim_get_current_buf()
    local deleted, modified = 0, 0
    for _, n in ipairs(api.nvim_list_bufs()) do
        -- If the iter buffer is modified one, then don't do anything
        if option(n, "modified") then
            -- iter is not equal to current buffer
            -- iter is modifiable or del_non_modifiable == true
            -- `modifiable` check is needed as it will prevent closing file tree ie. NERD_tree
            modified = modified + 1
        elseif n ~= cur and (option(n, "modifiable") or del_non_modifiable) then
            api.nvim_buf_delete(n, {})
            deleted = deleted + 1
        end
    end
    vim.notify(
        fmt("%s deleted buffer(s), %s modified buffer(s)", deleted, modified),
        2,
        {
            title = " BufOnly",
        }
    )
end

lk.command("BufOnly", buf_only, {})
-- }}}
--------------------------------------------------------------------------------

-- vim:foldmethod=marker
