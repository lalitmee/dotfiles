local map = lk_utils.map
local nnoremap = lk_utils.nnoremap

local map_opts = { noremap = true, silent = true }
local map_expr_opts = { expr = true }

-- highlight word under cursor but not search
vim.api.nvim_exec([[
    " Clears hlsearch after doing a search, otherwise just does normal <CR> stuff
    nnoremap <expr> <CR> {-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}()
]], false)

-- tab operations
nnoremap('<c-s-Right>', [[gt]])
nnoremap('<c-s-Left>', [[gT]])

-- buffers next and previous
nnoremap('<c-Right>', [[:bn<cr>]])
nnoremap('<c-Left>', [[:bp<cr>]])

-- alternate file mapping
map('n', '<bs>',
    [[:<c-u>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')<cr>]],
    map_opts)

-- behave vim
map('n', 'Y', [[y$]], map_opts)
map('n', 'H', [[0]], map_opts)
map('n', 'L', [[$]], map_opts)

-- keeping it centered
map('n', 'n', [[nzzzv]], map_opts)
map('n', 'N', [[Nzzzv]], map_opts)
map('n', 'J', [[mzJ`z:delmarks z<CR>]], map_opts)

-- undo breakpoints
map('i', ',', [[,<c-g>u]], map_opts)
map('i', '.', [[.<c-g>u]], map_opts)
map('i', '!', [[!<c-g>u]], map_opts)
map('i', '?', [[?<c-g>u]], map_opts)

-- jumplist mutations
map('n', 'j', [[(v:count > 5 ? "m'" . v:count : "") . 'j']],
    { noremap = true, expr = true })
map('n', 'k', [[(v:count > 5 ? "m'" . v:count : "") . 'k']],
    { noremap = true, expr = true })

-- moving text up and down
map('i', '<C-k>', [[<esc>:m .-2<CR>==]], map_opts)
map('i', '<C-j>', [[<esc>:m .+1<CR>==]], map_opts)
map('v', 'J', [[:m '>+1<CR>gv=gv]], map_opts)
map('v', 'K', [[:m '<-2<CR>gv=gv]], map_opts)

-- change all the occurences of a word with dot
map('n', 'cn', [[*``cgn]], map_opts)
map('n', 'cN', [[*``cgN]], map_opts)

-- add quotes around visual selection
map('v', '"', [[<esc>`>a"<esc>`<i"<esc>]], map_opts)

-- count number of lines in visual mode
map('v', 'L', [[g<C-g>]], map_opts)

-- circular window movements
-- map('n', '<c-tab>', [[<C-w>w]], map_opts)
-- map('n', '<s-tab>', [[<C-w>W]])

-- <c-n> and <c-p> in command line mode
map('c', '<C-n>', [[wildmenumode() ? "\<c-n>" : "\<down>"]], map_expr_opts)
map('c', '<C-p>', [[wildmenumode() ? "\<c-p>" : "\<up>"]], map_expr_opts)

-- <c-l> for syntax highlight and more
nnoremap('<c-l>',
         [[:nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>]])

-- Allow saving of files as sudo when I forgot to start vim using sudo.
-- http://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
map('c', 'w!!', [[%!sudo tee > /dev/null %]], map_opts)

-- clear highlighted search
map('n', '<CR>', [[:noh<CR>]], map_opts)

-- resize panes
map('n', '<Right>', [[:vertical resize +5<cr>]], map_opts)
map('n', '<Left>', [[:vertical resize -5<cr>]], map_opts)
map('n', '<Up>', [[:resize +5<cr>]], map_opts)
map('n', '<Down>', [[:resize -5<cr>]], map_opts)

-- Visually select the text that was last edited/pasted
map('n', 'gV', [[`[v`]], map_opts)

-- I hate escape more than anything else
map('i', 'jk', [[<Esc>]], map_opts)
map('i', 'kj', [[<Esc>]], map_opts)

-- " Easy CAPS
-- map('n', '<c-u>', [[<ESC>viwUi]], map_opts)
-- map('n', '<c-l>', [[viwl<Esc>]], map_opts)

-- repeat `n.` after editing the searched word
map('n', 'Q', [[@='n.'<CR>]], map_opts)

-- NOTE: terminal mappings
-- turn terminal to normal mode with escape
map('t', '<Esc>', [[<C-\><C-n>]], map_opts)
map('t', '<<C-[><C-[>>', [[<C-\><C-n>]], map_opts)
map('t', '<C-d>', [[<C-\><C-n>:q!<CR>]], map_opts)
map('t', '<M-[>', [[<Esc>]], map_opts)
map('t', '<C-v><Esc>', [[<Esc>]], map_opts)
-- Terminal mode:
map('t', '<M-h>', [[<c-\><c-n><c-w>h]], map_opts)
map('t', '<M-j>', [[<c-\><c-n><c-w>j]], map_opts)
map('t', '<M-k>', [[<c-\><c-n><c-w>k]], map_opts)
map('t', '<M-l>', [[<c-\><c-n><c-w>l]], map_opts)
-- Insert mode:
map('i', '<M-h>', [[<Esc><c-w>h]], map_opts)
map('i', '<M-j>', [[<Esc><c-w>j]], map_opts)
map('i', '<M-k>', [[<Esc><c-w>k]], map_opts)
map('i', '<M-l>', [[<Esc><c-w>l]], map_opts)
-- Visual mode:
map('v', '<M-h>', [[<Esc><c-w>h]], map_opts)
map('v', '<M-j>', [[<Esc><c-w>j]], map_opts)
map('v', '<M-k>', [[<Esc><c-w>k]], map_opts)
map('v', '<M-l>', [[<Esc><c-w>l]], map_opts)
-- Normal mode:
map('n', '<M-h>', [[<c-w>h]], map_opts)
map('n', '<M-j>', [[<c-w>j]], map_opts)
map('n', '<M-k>', [[<c-w>k]], map_opts)
map('n', '<M-l>', [[<c-w>l]], map_opts)
-- pasting from registers in terminal
map('t', '<expr>', [[<A-r> '<C-\><C-N>"'.nr2char(getchar()).'pi']], map_opts)

-- NOTE: Transpose characters xp {{{
-- picked from http://vimcasts.org/episodes/creating-repeatable-mappings-with-repeat-vim/
map('n', '<Plug>TransposeCharacters xp',
    [[:call repeat#set("\<Plug>TransposeCharacters")<CR>]], map_opts)
map('n', 'cp', [[<Plug>TransposeCharacters]])

-- }}}

-- incsearch
-- map('n', '<Esc><Esc>', [[:<C-u>nohlsearch<CR>]], map_opts)

-- NOTE: folds mappings
-- if there is a fold under cursor open it by pressing <CR> otherwise do
-- what <CR> does
map('n', '<CR>', [[@=(foldlevel('.')?'za':"\<Space>")<CR>]], map_opts)
-- create folds using visual select and then press <CR>
map('v', '<CR>', [[zf]], map_opts)

-- Complextras.nvim configuration
map('i', '<C-x><C-m>',
    [[<c-r>=luaeval("require('complextras').complete_matching_line()")<CR>]],
    map_opts)
map('i', '<C-x><C-d>',
    [[<c-r>=luaeval("require('complextras').complete_line_from_cwd()")<CR>]],
    map_opts)
