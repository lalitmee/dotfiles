local map = lk_utils.map

local opts = { noremap = true, silent = true }
local map_opts = { noremap = true }

-- behave vim
map('n', 'Y', [[y$]], map_opts)

-- keeping it centered
map('n', 'n', [[nzzzv]], map_opts)
map('n', 'N', [[Nzzzv]], map_opts)
map('n', 'J', [[mzJ`zmz]], map_opts)

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
map('v', 'L', [[g<C-g>]], opts)

-- circular window movements
map('n', '<tab>', [[<C-w>w]])
map('n', '<s-tab>', [[<C-w>W]])

map('c', '<C-n>', [[<Down>]], map_opts)
map('c', '<C-p>', [[<Up>]], map_opts)

-- Allow saving of files as sudo when I forgot to start vim using sudo.
-- http://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
map('c', 'w!!', [[%!sudo tee > /dev/null %]], opts)

-- clear highlighted search
map('n', '<CR>', [[:noh<CR>]], opts)

-- resize panes
map('n', '<Right>', [[:vertical resize +5<cr>]], opts)
map('n', '<Left>', [[:vertical resize -5<cr>]], opts)
map('n', '<Up>', [[:resize +5<cr>]], opts)
map('n', '<Down>', [[:resize -5<cr>]], opts)

-- Visually select the text that was last edited/pasted
map('n', 'gV', [[`[v`]], opts)

-- I hate escape more than anything else
map('i', 'jk', [[<Esc>]], opts)
map('i', 'kj', [[<Esc>]], opts)

-- " Easy CAPS
-- map('n', '<c-u>', [[<ESC>viwUi]], opts)
-- map('n', '<c-l>', [[viwl<Esc>]], opts)

-- repeat `n.` after editing the searched word
map('n', 'Q', [[@='n.'<CR>]], opts)

-- NOTE: terminal mappings
-- turn terminal to normal mode with escape
map('t', '<Esc>', [[<C-\><C-n>]], opts)
map('t', '<<C-[><C-[>>', [[<C-\><C-n>]], opts)
map('t', '<C-d>', [[<C-\><C-n>:q!<CR>]], opts)
map('t', '<M-[>', [[<Esc>]], opts)
map('t', '<C-v><Esc>', [[<Esc>]], opts)
-- Terminal mode:
map('t', '<M-h>', [[<c-\><c-n><c-w>h]], opts)
map('t', '<M-j>', [[<c-\><c-n><c-w>j]], opts)
map('t', '<M-k>', [[<c-\><c-n><c-w>k]], opts)
map('t', '<M-l>', [[<c-\><c-n><c-w>l]], opts)
-- Insert mode:
map('i', '<M-h>', [[<Esc><c-w>h]], opts)
map('i', '<M-j>', [[<Esc><c-w>j]], opts)
map('i', '<M-k>', [[<Esc><c-w>k]], opts)
map('i', '<M-l>', [[<Esc><c-w>l]], opts)
-- Visual mode:
map('v', '<M-h>', [[<Esc><c-w>h]], opts)
map('v', '<M-j>', [[<Esc><c-w>j]], opts)
map('v', '<M-k>', [[<Esc><c-w>k]], opts)
map('v', '<M-l>', [[<Esc><c-w>l]], opts)
-- Normal mode:
map('n', '<M-h>', [[<c-w>h]], opts)
map('n', '<M-j>', [[<c-w>j]], opts)
map('n', '<M-k>', [[<c-w>k]], opts)
map('n', '<M-l>', [[<c-w>l]], opts)
-- pasting from registers in terminal
map('t', '<expr>', [[<A-r> '<C-\><C-N>"'.nr2char(getchar()).'pi']], opts)

-- NOTE: Transpose characters xp {{{
-- picked from http://vimcasts.org/episodes/creating-repeatable-mappings-with-repeat-vim/
map('n', '<Plug>TransposeCharacters xp',
    [[:call repeat#set("\<Plug>TransposeCharacters")<CR>]], opts)
map('n', 'cp', [[<Plug>TransposeCharacters]])

-- }}}

-- incsearch
-- map('n', '<Esc><Esc>', [[:<C-u>nohlsearch<CR>]], opts)

-- NOTE: folds mappings
-- if there is a fold under cursor open it by pressing <CR> otherwise do
-- what <CR> does
map('n', '<CR>', [[@=(foldlevel('.')?'za':"\<Space>")<CR>]], opts)
-- create folds using visual select and then press <CR>
map('v', '<CR>', [[zf]], opts)

-- Complextras.nvim configuration
map('i', '<C-x><C-m>',
    [[<c-r>=luaeval("require('complextras').complete_matching_line()")<CR>]],
    opts)
map('i', '<C-x><C-d>',
    [[<c-r>=luaeval("require('complextras').complete_line_from_cwd()")<CR>]],
    opts)
