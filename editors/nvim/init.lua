-- -- https://github.com/lalitmee/dotfiles
-- -- NOTE: Created By: Lalit Kumar
-- vim.cmd [[ source $HOME/.config/nvim/vim-plug/plugins.vim]]
-- require('lk')
-- Install packer
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute(
      '!git clone https://github.com/wbthomason/packer.nvim ' .. install_path
  )
end

-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]
vim.api.nvim_exec(
    [[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua PackerCompile
  augroup end
]], false
)

local use = require('packer').use
require('packer').startup(
    function()
      -- Packer can manage itself as an optional plugin
      use { 'wbthomason/packer.nvim', opt = true }

      -- use {'nvim-treesitter/nvim-treesitter'}

      use 'tpope/vim-vinegar'
      use 'tpope/vim-surround'
      use 'tpope/vim-fugitive'
      use 'tpope/vim-rhubarb'
      use 'tpope/vim-dispatch'
      use 'tpope/vim-repeat'
      use 'tpope/vim-sleuth'
      use 'tpope/vim-eunuch'
      use 'tpope/vim-unimpaired'
      use 'tpope/vim-commentary'
      use 'norcalli/snippets.nvim'
      use { 'glacambre/firenvim', run = ':call firenvim#install(0)' }
      use 'AndrewRadev/splitjoin.vim'
      use 'ludovicchabant/vim-gutentags'
      use 'junegunn/vim-easy-align'
      use {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } }
      }
      use 'justinmk/vim-dirvish'
      use 'joshdick/onedark.vim'
      use{ 'tjdevries/gruvbuddy.nvim', requires ={'tjdevries/colorbuddy.vim'} }
      use 'itchyny/lightline.vim'
      -- use {
      -- 'glepnir/galaxyline.nvim',
      --   branch = 'main',
      --   -- your statusline
      --   -- config = function() require'my_statusline' end,
      --   -- some optional icons
      --   requires = {'kyazdani42/nvim-web-devicons', opt = true}
      -- }
      use 'christoomey/vim-tmux-navigator'
      use { 'lervag/vimtex', ft = { 'tex' } }
      use 'mhinz/neovim-remote'
      use { 'lukas-reineke/indent-blankline.nvim', branch = 'lua' }
      use 'sheerun/vim-polyglot'
      use 'jpalardy/vim-slime'
      use 'hkupty/iron.nvim.git'
      use 'lewis6991/gitsigns.nvim'
      use 'neovim/nvim-lspconfig'
      use 'bfredl/nvim-luadev'
      use 'hrsh7th/nvim-compe'
      use 'sbdchd/neoformat'
      -- use 'Olical/aniseed'
      -- use 'Olical/conjure'
    end
)

-- Expand tab to spaces
vim.o.expandtab = true
vim.o.clipboard = 'unnamedplus'

-- Incremental live completion
vim.o.inccommand = 'nosplit'

-- Set tab options for vim
vim.o.tabstop = 8
vim.o.softtabstop = 4

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Do not save when switching buffers
vim.o.hidden = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.cmd [[ set undofile ]]

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.g.onedark_terminal_italics = 2
vim.cmd [[colorscheme onedark]]

-- Set statusbar
vim.g.lightline = {
  colorscheme = 'onedark',
  active = {
    left = {
      { 'mode', 'paste' },
      { 'gitbranch', 'readonly', 'filename', 'modified' }
    }
  },
  component_function = { gitbranch = 'fugitive#head' }
}

-- Fire, walk with me
vim.cmd [[set guifont="Monaco:h18"]]
vim.g.firenvim_config = { localSettings = { ['.*'] = { takeover = 'never' } } }

-- Remap space as leader key
vim.api.nvim_set_keymap(
    '', '<Space>', '<Nop>', { noremap = true, silent = true }
)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Remap for dealing with word wrap
vim.api.nvim_set_keymap(
    'n', 'k', 'v:count == 0 ? \'gk\' : \'k\'',
    { noremap = true, expr = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', 'j', 'v:count == 0 ? \'gj\' : \'j\'',
    { noremap = true, expr = true, silent = true }
)

-- Add move line shortcuts
vim.api.nvim_set_keymap('n', '<A-j>', ':m .+1<CR>==', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-k>', ':m .-2<CR>==', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { noremap = true })
vim.api.nvim_set_keymap('v', '<A-j>', ':m \'>+1<CR>gv=gv', { noremap = true })
vim.api.nvim_set_keymap('v', '<A-k>', ':m \'<-2<CR>gv=gv', { noremap = true })

-- Remap escape to leave terminal mode
vim.api.nvim_exec(
    [[
  augroup Terminal
    autocmd!
    au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    au TermOpen * set nonu
  augroup end
]], false
)

-- Add map to enter paste mode
vim.o.pastetoggle = '<F3>'

vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_char_highlight = 'LineNr'

-- Toggle to disable mouse mode and indentlines for easier paste
ToggleMouse = function()
  if vim.o.mouse == 'a' then
    vim.cmd [[IndentBlanklineDisable]]
    vim.wo.signcolumn = 'no'
    vim.o.mouse = 'v'
    vim.wo.number = false
    print('Mouse disabled')
  else
    vim.cmd [[IndentBlanklineEnable]]
    vim.wo.signcolumn = 'yes'
    vim.o.mouse = 'a'
    vim.wo.number = true
    print('Mouse enabled')
  end
end

vim.api.nvim_set_keymap(
    'n', '<F10>', '<cmd>lua ToggleMouse()<cr>', { noremap = true }
)

-- Start interactive EasyAlign in visual mode (e.g. vipga)
vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', {})

-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', {})

-- Add neovim remote for vimtex
vim.g.vimtex_compiler_progname = 'nvr'
vim.g.tex_flavor = 'latex'

-- Gitsigns
require('gitsigns').setup(
    {
      signs = {
        add = { hl = 'GitGutterAdd', text = '+' },
        change = { hl = 'GitGutterChange', text = '~' },
        delete = { hl = 'GitGutterDelete', text = '_' },
        topdelete = { hl = 'GitGutterDelete', text = '‾' },
        changedelete = { hl = 'GitGutterChange', text = '~' }
      }
    }
)

-- Telescope
require('telescope').setup {
  defaults = {
    mappings = { i = { ['<C-u>'] = false, ['<C-d>'] = false } },
    generic_sorter = require'telescope.sorters'.get_fzy_sorter,
    file_sorter = require'telescope.sorters'.get_fzy_sorter
  }
}
-- Add leader shortcuts
vim.api.nvim_set_keymap(
    'n', '<leader>f',
    [[<cmd>lua require('telescope.builtin').find_files()<cr>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader><space>',
    [[<cmd>lua require('telescope.builtin').buffers()<cr>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>l',
    [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>t', [[<cmd>lua require('telescope.builtin').tags()<cr>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<cr>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>sd',
    [[<cmd>lua require('telescope.builtin').grep_string()<cr>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>sp',
    [[<cmd>lua require('telescope.builtin').live_grep()<cr>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>o',
    [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<cr>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>gc',
    [[<cmd>lua require('telescope.builtin').git_commits()<cr>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>gb',
    [[<cmd>lua require('telescope.builtin').git_branches()<cr>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>gs',
    [[<cmd>lua require('telescope.builtin').git_status()<cr>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>gp',
    [[<cmd>lua require('telescope.builtin').git_bcommits()<cr>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>wb',
    [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>]],
    { noremap = true, silent = true }
)

-- Fugitive shortcuts
vim.api.nvim_set_keymap(
    'n', '<leader>ga', ':Git add %:p<CR><CR>', { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>gd', ':Gdiff<CR>', { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>ge', ':Gedit<CR>', { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>gr', ':Gread<CR>', { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>gw', ':Gwrite<CR><CR>', { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>gl', ':silent! Glog<CR>:bot copen<CR>',
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>gm', ':Gmove<Space>', { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>go', ':Git checkout<Space>', { noremap = true, silent = true }
)

-- alternative shorcuts without fzf
vim.api.nvim_set_keymap('n', '<leader>,', ':buffer *', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>.', ':e<space>**/', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>T', ':tjump *', { noremap = true })

-- Make gutentags use ripgrep
-- --python-kinds=-iv
-- --exclude=build
-- --exclude=dist
vim.g.gutentags_file_list_command = 'fd'
vim.g.gutentags_ctags_extra_args = { '--python-kinds=-iv' }

-- remove conceal on markdown files
vim.g.markdown_syntax_conceal = 0

-- Configure vim slime to use tmux
vim.g.slime_target = 'tmux'
vim.g.slime_python_ipython = 1
vim.g.slime_dont_ask_default = 1
vim.g.slime_default_config = {
  socket_name = 'default',
  target_pane = '{right-of}'
}

-- Change preview window location
vim.g.splitbelow = true

-- Remap number increment to alt
vim.api.nvim_set_keymap('n', '<A-a>', '<C-a>', { noremap = true })
vim.api.nvim_set_keymap('v', '<A-a>', '<C-a>', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-x>', '<C-x>', { noremap = true })
vim.api.nvim_set_keymap('v', '<A-x>', '<C-x>', { noremap = true })

-- n always goes forward
vim.api.nvim_set_keymap(
    'n', 'n', '\'Nn\'[v:searchforward]', { noremap = true, expr = true }
)
vim.api.nvim_set_keymap(
    'x', 'n', '\'Nn\'[v:searchforward]', { noremap = true, expr = true }
)
vim.api.nvim_set_keymap(
    'o', 'n', '\'Nn\'[v:searchforward]', { noremap = true, expr = true }
)
vim.api.nvim_set_keymap(
    'n', 'N', '\'nN\'[v:searchforward]', { noremap = true, expr = true }
)
vim.api.nvim_set_keymap(
    'x', 'N', '\'nN\'[v:searchforward]', { noremap = true, expr = true }
)
vim.api.nvim_set_keymap(
    'o', 'N', '\'nN\'[v:searchforward]', { noremap = true, expr = true }
)

-- Neovim python support
vim.g.loaded_python_provider = 0

-- Highlight on yank
vim.api.nvim_exec(
    [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false
)

-- Y yank until the end of line
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

-- Clear white space on empty lines and end of line
vim.api.nvim_set_keymap(
    'n', '<F6>',
    [[:let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>]],
    { noremap = true, silent = true }
)

-- Nerdtree like sidepanel
-- absolute width of netrw window
vim.g.netrw_winsize = -28

-- do not display info on the top of window
vim.g.netrw_banner = 0

-- sort is affecting only: directories on the top, files below
-- vim.g.netrw_sort_sequence = '[\/]$,*'

-- variable for use by ToggleNetrw function
vim.g.NetrwIsOpen = 0

-- Lexplore toggle function
ToggleNetrw = function()
  if vim.g.NetrwIsOpen == 1 then
    local i = vim.api.nvim_get_current_buf()
    while i >= 1 do
      if vim.bo.filetype == 'netrw' then
        vim.cmd([[ silent exe "bwipeout " . ]] .. i)
      end
      i = i - 1
    end
    vim.g.NetrwIsOpen = 0
    vim.g.netrw_liststyle = 0
    vim.g.netrw_chgwin = -1
  else
    vim.g.NetrwIsOpen = 1
    vim.g.netrw_liststyle = 3
    vim.cmd([[silent Lexplore]])
  end
end

vim.api.nvim_set_keymap(
    'n', '<leader>d', ':lua ToggleNetrw()<cr><paste>',
    { noremap = true, silent = true }
)

-- Function to open preview of file under netrw
vim.api.nvim_exec(
    [[
  augroup Netrw
    autocmd!
    autocmd filetype netrw nmap <leader>; <cr>:wincmd W<cr>
  augroup end
]], false
)

-- directory managmeent, including autochdir
vim.cmd [[nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>]]

vim.api.nvim_exec(
    [[
  augroup BufferCD
    autocmd!
    autocmd BufEnter * silent! Glcd
  augroup end
]], false
)
-- vim.cmd([[ autocmd ColorScheme * :lua require('vim.lsp.diagnostic')._define_default_signs_and_highlights() ]])
vim.api.nvim_exec(
    [[
  augroup nvim-luadev
    autocmd!
    function! SetLuaDevOptions()
      nmap <buffer> <C-c><C-c> <Plug>(Luadev-RunLine)
      vmap <buffer> <C-c><C-c> <Plug>(Luadev-Run)
      nmap <buffer> <C-c><C-k> <Plug>(Luadev-RunWord)
      map  <buffer> <C-x><C-p> <Plug>(Luadev-Complete)
      set filetype=lua
    endfunction
    autocmd BufEnter \[nvim-lua\] call SetLuaDevOptions()
  augroup end
]], false
)

-- Vim polyglot language specific settings
vim.g.python_highlight_space_errors = 0

-- LSP settings
-- log file location: /Users/michael/.local/share/nvim/lsp.log
-- Add nvim-lspconfig plugin
local nvim_lsp = require('lspconfig')
-- vim.lsp.set_log_level("debug")
local on_attach = function(_client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.lsp.handlers['textDocument/publishDiagnostics'] =
      vim.lsp.with(
          vim.lsp.diagnostic.on_publish_diagnostics, {
            -- disable virtual text
            virtual_text = false,

            -- show signs
            signs = true,

            -- delay update diagnostics
            update_in_insert = true
          }
      )

  -- Override to add
  vim.lsp.handlers['textDocument/hover'] =
      function(_, method, result)
        vim.lsp.util.focusable_float(
            method, function()
              if not (result and result.contents) then
                -- return { 'No information available' }
                return
              end
              local markdown_lines = vim.lsp.util
                                         .convert_input_to_markdown_lines(
                                         result.contents
                                     )
              markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
              if vim.tbl_isempty(markdown_lines) then
                -- return { 'No information available' }
                return
              end
              local bufnr, winnr = vim.lsp.util.fancy_floating_markdown(
                                       markdown_lines,
                                       { pad_left = 1, pad_right = 1 }
                                   )
              vim.api.nvim_buf_set_keymap(
                  bufnr, 'n', 'K', '<Cmd>wincmd p<CR>',
                  { noremap = true, silent = true }
              )
              vim.lsp.util.close_preview_autocmd(
                  { 'CursorMoved', 'BufHidden', 'InsertCharPre' }, winnr
              )
              return bufnr, winnr
            end
        )
      end

  -- Mappings.
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(
      bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts
  )
  vim.api.nvim_buf_set_keymap(
      bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts
  )
  vim.api.nvim_buf_set_keymap(
      bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts
  )
  vim.api.nvim_buf_set_keymap(
      bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts
  )
  vim.api.nvim_buf_set_keymap(
      bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts
  )
  vim.api.nvim_buf_set_keymap(
      bufnr, 'n', '<leader>wa',
      '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts
  )
  vim.api.nvim_buf_set_keymap(
      bufnr, 'n', '<leader>wr',
      '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts
  )
  vim.api.nvim_buf_set_keymap(
      bufnr, 'n', '<leader>wl',
      '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
      opts
  )
  vim.api.nvim_buf_set_keymap(
      bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>',
      opts
  )
  vim.api.nvim_buf_set_keymap(
      bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts
  )
  vim.api.nvim_buf_set_keymap(
      bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts
  )
  vim.api.nvim_buf_set_keymap(
      bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts
  )
  vim.api.nvim_buf_set_keymap(
      bufnr, 'n', '<leader>e',
      '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts
  )
  vim.api.nvim_buf_set_keymap(
      bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts
  )
  vim.api.nvim_buf_set_keymap(
      bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts
  )
  vim.api.nvim_buf_set_keymap(
      bufnr, 'n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',
      opts
  )
end

local servers = { 'pyright', 'clangd', 'rust_analyzer', 'hls', 'zls', 'tsserver' }
-- local servers = {
--  'gopls', 'clangd', 'vuels', 'hls', 'solargraph', 'rnix', 'ocamllsp',
--  'dartls', 'tsserver', 'solargraph', 'pyright', 'als'
-- }

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end

nvim_lsp.texlab.setup {
  on_attach = on_attach,
  settings = {
    latex = {
      rootDirectory = '.',
      build = {
        args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '-pvc' },
        forwardSearchAfter = true,
        onSave = true
      },
      forwardSearch = {
        executable = 'zathura',
        args = { '--synctex-forward', '%l:1:%f', '%p' },
        onSave = true
      }
    }
  }
}

nvim_lsp.jsonls.setup {
  commands = {
    Format = {
      function()
        vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line('$'), 0 })
      end
    }
  }
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true;
require'snippets'.use_suggested_mappings()

nvim_lsp.html.setup { capabilities = capabilities, on_attach = on_attach }

local sumneko_cmd
if vim.fn.executable('lua-language-server') == 1 then
  sumneko_cmd = { 'lua-language-server' }
else
  local sumneko_root_path = vim.fn.getenv('HOME') .. '/data/Github/lua-language-server'
  sumneko_cmd = {
    sumneko_root_path .. '/bin/Linux/lua-language-server',
    '-E',
    sumneko_root_path .. '/main.lua'
  }
end

nvim_lsp.sumneko_lua.setup {
  cmd = sumneko_cmd,
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';')
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' }
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
        }
      }
    }
  }
}

FormatRange = function()
  local start_pos = vim.api.nvim_buf_get_mark(0, '<')
  local end_pos = vim.api.nvim_buf_get_mark(0, '>')
  vim.lsp.buf.range_formatting({}, start_pos, end_pos)
end

vim.cmd(
    [[
  command! -range FormatRange  execute 'lua FormatRange()'
]]
)

vim.cmd(
    [[
  command! Format execute 'lua vim.lsp.buf.formatting()'
]]
)

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noinsert,noselect'

-- Compe setup
require'compe'.setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'enable',
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,

  source = {
    path = true,
    buffer = false,
    calc = true,
    vsnip = false,
    nvim_lsp = true,
    nvim_lua = true,
    spell = true,
    tags = false,
    snippets_nvim = true,
    treesitter = true
  }
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-n>'
    -- elseif vim.fn.call("vsnip#available", {1}) == 1 then
    --   return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t '<Tab>'
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-p>'
    -- elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    -- me-
    --   return t "<Plug>(vsnip-jump-prev)"
  else
    return t '<S-Tab>'
  end
end

vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap(
    'i', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true }
)
vim.api.nvim_set_keymap(
    's', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true }
)

-- vim.api.nvim_set_keymap("i", "<C-Space>", "v:lua.tab_complete()", {expr = true, silent = true})
-- vim.api.nvim_set_keymap("i", "<CR>", "v:lua.tab_complete()", {expr = true, silent = true})
-- vim.api.nvim_set_keymap("i", "<C-e>", "v:lua.s_tab_complete()", {expr = true, silent = true})
-- vim.api.nvim_set_keymap("i", "<C-f>", "v:lua.s_tab_complete()", {expr = true, silent = true})
-- vim.api.nvim_set_keymap("i", "<C-d>", "v:lua.s_tab_complete()", {expr = true, silent = true})

-- inoremap <silent><expr> <C-Space> compe#complete()
-- inoremap <silent><expr> <CR>      compe#confirm('<CR>')
-- inoremap <silent><expr> <C-e>     compe#close('<C-e>')
-- inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
-- inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

-- require'nvim-treesitter.configs'.setup {
--   ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
--   highlight = {
--     enable = true,              -- false will disable the whole extension
--   },
--   incremental_selection = {
--     enable = true,
--     keymaps = {
--       init_selection = "gnn",
--       node_incremental = "grn",
--       scope_incremental = "grc",
--       node_decremental = "grm",
--     },
--   },
--   indent = {
--     enable = true
--   }
-- }

-- Formatters
vim.g.neoformat_enabled_python = { 'black' }

local iron = require('iron')

iron.core.set_config { preferred = { python = 'ipython' } }
