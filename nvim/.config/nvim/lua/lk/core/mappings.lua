----------------------------------------------------------------------
-- NOTE: mappings {{{
----------------------------------------------------------------------
local map = lk.map
local nmap = lk.nmap
local nnoremap = lk.nnoremap

local map_opts = { noremap = true, silent = true }
local map_expr_opts = { expr = true }

----------------------------------------------------------------------
-- NOTE: movements {{{
----------------------------------------------------------------------
nnoremap("0", "^")
nnoremap("^", "0")

-- behave vim
map("n", "Y", [[y$]], map_opts)
map("n", "H", [[0]], map_opts)
map("n", "L", [[$]], map_opts)

-- jumplist mutations
map("n", "j", [[(v:count > 5 ? "m'" . v:count : "") . 'j']], { noremap = true, expr = true })
map("n", "k", [[(v:count > 5 ? "m'" . v:count : "") . 'k']], { noremap = true, expr = true })

-- <c-n> and <c-p> in command line mode
map("c", "<C-n>", [[wildmenumode() ? "\<c-n>" : "\<down>"]], map_expr_opts)
map("c", "<C-p>", [[wildmenumode() ? "\<c-p>" : "\<up>"]], map_expr_opts)

-- tmux movements
nmap("<C-h>", [[<cmd>NavigateLeft<cr>]], map_opts)
nmap("<C-l>", [[<cmd>NavigateRight<cr>]], map_opts)
nmap("<C-j>", [[<cmd>NavigateDown<cr>]], map_opts)
nmap("<C-k>", [[<cmd>NavigateUp<cr>]], map_opts)
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: buffers and tabs {{{
----------------------------------------------------------------------
-- stop that stupid window from popping up
-- map("n", "q:", [[:q]], map_opts) -- NOTE: making q slow

-- tab operations
nnoremap("<M-Right>", [[:tabnext<CR>]])
nnoremap("<M-Left>", [[:tabprevious<CR>]])

-- from here https://gist.github.com/romainl/0f589e07a079ea4b7a77fd66ef16ebee
vim.cmd([[
  nnoremap <silent> <expr> gt ":tabnext +" . v:count1 . '<CR>'
  nnoremap <silent> <expr> gT ":tabnext -" . v:count1 . '<CR>'
]])

-- buffers next and previous
nnoremap("<C-Right>", [[:bn<cr>]])
nnoremap("<C-Left>", [[:bp<cr>]])

-- alternate file mapping
map("n", "<bs>", [[:<c-u>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')<cr>]], map_opts)

-- NOTE: this was creating problem with <C-I>
-- circular window movements
-- map('n', '<c-tab>', [[<C-w>w]], map_opts)
-- map('n', '<s-tab>', [[<C-w>W]])
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: copy and paste {{{
----------------------------------------------------------------------
-- copy and pasting made easy
map("n", "<localleader>y", [["+y]], { noremap = true })
map("n", "<localleader>p", [["+p]], { noremap = true })
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: text edits {{{
----------------------------------------------------------------------
-- repeat n number of times
vim.cmd([[nnoremap <silent> . :<C-u>execute "norm! " . repeat(".", v:count1)<CR>]])

-- keep cursor in same position while using `J`
map("n", "J", [[:let p=getpos('.')<bar>join<bar>call setpos('.', p)<cr>]], map_opts)

-- undo breakpoints
map("i", ",", [[,<c-g>u]], map_opts)
map("i", ".", [[.<c-g>u]], map_opts)
map("i", "!", [[!<c-g>u]], map_opts)
map("i", "?", [[?<c-g>u]], map_opts)

-- moving text up and down
map("i", "<C-k>", [[<esc>:m .-2<cr>==]], map_opts)
map("i", "<C-j>", [[<esc>:m .+1<cr>==]], map_opts)
map("v", "J", [[:m '>+1<cr>gv=gv]], map_opts)
map("v", "K", [[:m '<-2<cr>gv=gv]], map_opts)

-- change all the occurences of a word with dot
map("n", "cn", [[*``cgn]], map_opts)
map("n", "cN", [[*``cgN]], map_opts)

-- Allow saving of files as sudo when I forgot to start vim using sudo.
-- http://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
map("c", "w!!", [[%!sudo tee > /dev/null %]], map_opts)
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: search {{{
----------------------------------------------------------------------
-- keeping it centered
map("n", "n", [[nzzzv]], map_opts)
map("n", "N", [[Nzzzv]], map_opts)

-- clear search pressing ESC two times
nnoremap("<Esc><Esc>", ":<C-u>nohlsearch<cr>")

-- go to search and replace mode
map("n", "<C-s>", [[:%s/]], map_opts)

-- clear highlighted search
map("n", "<cr>", [[:noh<cr>]], map_opts)

-- repeat `n.` after editing the searched word
map("n", "Q", [[@='n.'<cr>]], map_opts)

-- <c-l> for syntax highlight and more
nnoremap("<c-l>", [[:nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>]])
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: resize panes {{{
----------------------------------------------------------------------
map("n", "<Right>", [[:vertical resize +5<cr>]], map_opts)
map("n", "<Left>", [[:vertical resize -5<cr>]], map_opts)
map("n", "<Up>", [[:resize +5<cr>]], map_opts)
map("n", "<Down>", [[:resize -5<cr>]], map_opts)
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: selection {{{
----------------------------------------------------------------------
-- Visually select the text that was last edited/pasted
map("n", "gV", [[`[v`]], map_opts)
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: escape using `jk` or `kj` {{{
-- handy in some use cases where pressing escape closes the window
----------------------------------------------------------------------
map("i", "jk", [[<Esc>]], map_opts)
map("i", "kj", [[<Esc>]], map_opts)
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: terminal {{{
----------------------------------------------------------------------
-- pasting from registers in terminal
map("t", "<expr>", [[<A-r> '<C-\><C-N>"'.nr2char(getchar()).'pi']], map_opts)
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: transpose characters `xp` {{{
-- picked from http://vimcasts.org/episodes/creating-repeatable-mappings-with-repeat-vim/
----------------------------------------------------------------------
map("n", "<Plug>TransposeCharacters xp", [[:call repeat#set("\<Plug>TransposeCharacters")<cr>]], map_opts)
map("n", "cp", [[<Plug>TransposeCharacters]])
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: folds {{{
----------------------------------------------------------------------
-- if there is a fold under cursor open it by pressing <cr> otherwise do
-- what <cr> does
map("n", "<cr>", [[@=(foldlevel('.')?'za':"\<Space>")<cr>]], map_opts)
-- create folds using visual select and then press <cr>
map("v", "<cr>", [[zf]], map_opts)
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: shortcuts {{{
----------------------------------------------------------------------
-- -- count number of lines in visual mode
-- map('v', 'L', [[g<C-g>]], map_opts)
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: external {{{
----------------------------------------------------------------------
-- -- Complextras.nvim configuration
-- map("i", "<C-x><C-m>", [[<c-r>=luaeval("require('complextras').complete_matching_line()")<cr>]], map_opts)
-- map("i", "<C-x><C-d>", [[<c-r>=luaeval("require('complextras').complete_line_from_cwd()")<cr>]], map_opts)
-- }}}
----------------------------------------------------------------------

-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
