local map = lk_utils.map

local opts = { noremap = true, silent = true }

-- count number of lines in visual mode
map('v', 'L', [[g<C-g>]], opts)

map('c', '<C-n>', [[<Down>]], { noremap = true })
map('c', '<C-p>', [[<Up>]], { noremap = true })

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

-- move line up and down using topope vim-unimpaired
-- Bubble single lines
map('n', '<S-Up>', [[[e]], opts)
map('n', '<S-Down>', [[]e]], opts)
-- Bubble multiple lines
map('v', '<C-Up>', [[[egv]], opts)
map('v', '<C-Down>', [[]egv]], opts)

-- Visually select the text that was last edited/pasted
map('n', 'gV', [[`[v`]], opts)

-- I hate escape more than anything else
map('i', 'jk', [[<Esc>]], opts)
map('i', 'kj', [[<Esc>]], opts)

-- " Easy CAPS
map('n', '<c-u>', [[<ESC>viwUi]], opts)
map('n', '<c-l>', [[viwl<Esc>]], opts)

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
map('n', '<Esc><Esc>', [[:<C-u>nohlsearch<CR>]], opts)

-- quickfix navigation
map('n', '<C-k>', [[:cnext<CR>]], opts)
map('n', '<C-j>', [[:cprev<CR>]], opts)
map('n', '<C-q>', [[:copen<CR>]], opts)

-- loclist navigation
map('n', '<A-k>', [[:lnext<CR>]], opts)
map('n', '<A-j>', [[:lprev<CR>]], opts)
map('n', '<A-q>', [[:lopen<CR>]], opts)

-- NOTE: folds mappings
-- if there is a fold under cursor open it by pressing <CR> otherwise do
-- what <CR> does
map('n', '<CR>', [[@=(foldlevel('.')?'za':"\<Space>")<CR>]], opts)
-- create folds using visual select and then press <CR>
map('v', '<CR>', [[zf]], opts)

-- NOTE: auto-pairs mapping <CR> for indentation inside html files
local npairs = require('nvim-autopairs')

vim.g.completion_confirm_key = ''
lk_utils.completion_confirm = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info()['selected'] ~= -1 then
      vim.fn['compe#confirm']()
      return npairs.esc('<c-y>')
    else
      vim.defer_fn(function()
        vim.fn['compe#confirm']('<cr>')
      end, 20)
      return npairs.esc('<c-n>')
    end
  else
    return npairs.check_break_line_char()
  end
end

map('i', '<CR>', 'v:lua.lk_utils.completion_confirm()',
    { expr = true, noremap = true })
