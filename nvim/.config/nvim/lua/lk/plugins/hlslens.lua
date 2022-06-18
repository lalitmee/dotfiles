local ok, hlslens = lk.safe_require("hlslens")
if not ok then
  return
end

----------------------------------------------------------------------
-- NOTE: setup {{{
----------------------------------------------------------------------
hlslens.setup({ calm_down = true })
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: mappings {{{
----------------------------------------------------------------------
local nmap = lk.nmap
local opts = { noremap = true, silent = true }

nmap("n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
nmap("N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
nmap("*", [[*<Cmd>lua require('hlslens').start()<CR>]], opts)
nmap("#", [[#<Cmd>lua require('hlslens').start()<CR>]], opts)
nmap("g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], opts)
nmap("g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], opts)
-- }}}
----------------------------------------------------------------------
