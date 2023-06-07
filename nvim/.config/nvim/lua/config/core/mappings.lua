----------------------------------------------------------------------
-- NOTE: mappings {{{
----------------------------------------------------------------------
local fmt = string.format
local fn = vim.fn

local map = lk.map
local nmap = lk.nmap
local nnoremap = lk.nnoremap
local xnoremap = lk.xnoremap

local map_opts = { noremap = true, silent = true }

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

-- tmux movements
nmap("<C-h>", [[<cmd>NavigatorLeft<cr>]], map_opts)
nmap("<C-l>", [[<cmd>NavigatorRight<cr>]], map_opts)
nmap("<C-j>", [[<cmd>NavigatorDown<cr>]], map_opts)
nmap("<C-k>", [[<cmd>NavigatorUp<cr>]], map_opts)
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: buffers and tabs {{{
----------------------------------------------------------------------
-- stop that stupid window from popping up
-- map("n", "q:", [[:q]], map_opts) -- NOTE: making q slow

-- tab operations
nnoremap("<M-Right>", vim.cmd.tabnext)
nnoremap("<M-Left>", vim.cmd.tabprevious)

-- from here https://gist.github.com/romainl/0f589e07a079ea4b7a77fd66ef16ebee
nnoremap("gt", [[":tabnext +" . v:count1 . '<CR>']], { silent = true, expr = true })
nnoremap("gT", [[":tabnext -" . v:count1 . '<CR>']], { silent = true, expr = true })

-- buffers next and previous
nnoremap("<C-Right>", vim.cmd.bnext)
nnoremap("<C-Left>", vim.cmd.bprevious)

-- alternate file mapping
map("n", "<BS>", [[:<c-u>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')<cr>]], map_opts)

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
-- map("i", "<C-k>", [[<esc>:m .-2<cr>==]], map_opts)
-- map("i", "<C-j>", [[<esc>:m .+1<cr>==]], map_opts)
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

--------------------------------------------------------------------------------
--  NOTE: scrolling {{{
--------------------------------------------------------------------------------
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")
-- }}}
--------------------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: search {{{
----------------------------------------------------------------------
-- search within selection
-- first select part of the text in which you want to search something and then
-- press the key to start search and it will search only in the selected text
map("x", "/", "<Esc>/\\%V")

-- keeping it centered
map("n", "n", [[nzzzv]], map_opts)
map("n", "N", [[Nzzzv]], map_opts)

-- clear search pressing ESC two times
nnoremap("<Esc><Esc>", ":<C-u>nohlsearch<cr>")

-- go to search and replace mode
map("n", "<C-s>", [[:%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>]], map_opts)

-- clear highlighted search
map("n", "<cr>", [[:noh<cr>]], map_opts)

-- repeat `n.` after editing the searched word
map("n", "Q", [[@='n.'<cr>]], map_opts)

-- <c-l> for syntax highlight and more
nnoremap("<A-S-l>", [[:nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>]])
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
-- nnoremap([[<C-\>]], "<cmd>HarpoonGotoTerm 1<CR>")
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

--------------------------------------------------------------------------------
--  NOTE: macro over a visual range {{{
--------------------------------------------------------------------------------
-- TODO: converting this to lua does not work for some obscure reason.
vim.cmd([[
  function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
  endfunction
]])

xnoremap("@", ":<C-u>call ExecuteMacroOverVisualRange()<CR>", { silent = false })
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: opening links {{{
--------------------------------------------------------------------------------
local function open(path)
    fn.jobstart({ vim.g.open_command, path }, { detach = true })
    vim.notify(fmt("Opening %s", path))
end

--------------------------------------------------------------------------------
--  NOTE: gx - netrw opening links {{{
--------------------------------------------------------------------------------
local function open_link()
    local file = fn.expand("<cfile>")
    if not file or fn.isdirectory(file) > 0 then
        return vim.cmd.edit(file)
    end

    if file:match("http[s]?://") then
        return open(file)
    end

    -- consider anything that looks like string/string a github link
    local plugin_url_regex = "[%a%d%-%.%_]*%/[%a%d%-%.%_]*"
    local link = string.match(file, plugin_url_regex)
    if link then
        return open(fmt("https://www.github.com/%s", link))
    end
end
nnoremap("gx", open_link)
-- }}}
--------------------------------------------------------------------------------
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: auto-indent on going in insert mode {{{
--------------------------------------------------------------------------------
vim.keymap.set("n", "i", function()
    if #vim.fn.getline(".") == 0 then
        return [["_cc]]
    else
        return "i"
    end
end, { expr = true })
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: toggleterm {{{
--------------------------------------------------------------------------------
lk.nnoremap("<C-g>", "<cmd>LazyGit<cr>", { silent = true })
-- }}}
--------------------------------------------------------------------------------

-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
