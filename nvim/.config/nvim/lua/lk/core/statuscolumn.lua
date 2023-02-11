-- -- NOTE: from here https://github.com/akinsho/dotfiles
-- if not vim.o.statuscolumn then
--     return
-- end

-- local fn, v = vim.fn, vim.v

-- lk.statuscolumn = {
--     separator = "│",
-- }

-- function lk.statuscolumn.fdm()
--     local is_folded = fn.foldlevel(v.lnum) > fn.foldlevel(v.lnum - 1)
--     return is_folded and (fn.foldclosed(v.lnum) == -1 and "" or "") or " "
-- end

-- function lk.statuscolumn.nr()
--     local num = (not lk.empty(v.relnum) and v.relnum or v.lnum)
--     return fn.substitute(num, "\\d\\zs\\ze\\" .. "%(\\d\\d\\d\\)\\+$", ",", "g")
-- end

-- local excluded = {
--     "neo-tree",
--     "NeogitStatus",
--     "NeogitCommitMessage",
--     "undotree",
--     "log",
--     "man",
--     "dap-repl",
--     "markdown",
--     "vimwiki",
--     "vim-plug",
--     "gitcommit",
--     "toggleterm",
--     "fugitive",
--     "list",
--     "NvimTree",
--     "startify",
--     "help",
--     "orgagenda",
--     "org",
--     "himalaya",
--     "Trouble",
--     "NeogitCommitMessage",
--     "NeogitRebaseTodo",
-- }

-- vim.o.statuscolumn = " %=%{v:lua.lk.statuscolumn.nr()} │ %s%{v:lua.lk.statuscolumn.fdm()} " -- %C for folds

-- lk.augroup("StatusCol", {
--     {
--         event = { "BufEnter", "FileType" },
--         command = function(args)
--             local buf = vim.bo[args.buf]
--             if buf.bt ~= "" or vim.tbl_contains(excluded, buf.ft) then
--                 vim.opt_local.statuscolumn = ""
--             end
--         end,
--     },
-- })
