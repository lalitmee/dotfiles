local fn = vim.fn
local api = vim.api
local autocommands = require('lk.autocommands')
local executable = function(e)
  return fn.executable(e) > 0
end

local opts_info = vim.api.nvim_get_all_options_info()

local opt = setmetatable({}, {
  __newindex = function(_, key, value)
    vim.o[key] = value
    local scope = opts_info[key].scope
    if scope == 'win' then
      vim.wo[key] = value
    elseif scope == 'buf' then
      vim.bo[key] = value
    end
  end
})

local function add(value, str, sep)
  sep = sep or ','
  str = str or ''
  value = type(value) == 'table' and table.concat(value, sep) or value
  return str ~= '' and table.concat({ value, str }, sep) or value
end

-- Numbers {{{

-- vim.go.number = true
-- vim.go.relativenumber = true

-- }}}

-- Message output on vim actions {{{

vim.o.shortmess = table.concat({
  't', -- truncate file messages at start
  'A', -- ignore annoying swap file messages
  'o', -- file-read message overwrites previous
  'O', -- file-read message overwrites previous
  'T', -- truncate non-file messages in middle
  'f', -- (file x of x) instead of just (x of x
  'F', -- Don't give file info when editing a file
  's',
  'c',
  'W' -- Dont show [w] or written when writing
})

-- }}}

-- Timings {{{

vim.go.updatetime = 1000
vim.go.timeout = true
vim.go.timeoutlen = 500
vim.go.ttimeoutlen = 10

-- }}}

-- Window splitting and buffers {{{

opt.ruler = true
vim.go.hidden = true
vim.go.encoding = 'utf-8'
vim.bo.fileencoding = 'utf-8'
vim.go.splitbelow = true
vim.go.splitright = true
vim.go.eadirection = 'hor'
-- vim.go.t_Co = '256'
-- exclude usetab as we do not want to jump to buffers in already open tabs
-- do not use split or vsplit to ensure we don't open any new windows
vim.go.switchbuf = 'useopen,uselast'
vim.go.fillchars = add {
  'vert:▕', -- alternatives │
  'fold:━',
  'eob: ', -- suppress ~ at EndOfBuffer
  'diff:─', -- alternatives: ⣿ ░
  'msgsep:‾',
  'foldopen:▾',
  'foldsep:│',
  'foldclose:▸'
}

-- }}}

-- Diff {{{

-- Use in vertical diff mode, blank lines to keep sides aligned, Ignore whitespace changes
vim.go.diffopt = add({
  'vertical',
  'iwhite',
  'hiddenoff',
  'foldcolumn:0',
  'context:4',
  'algorithm:histogram',
  'indent-heuristic'
}, vim.go.diffopt)

-- }}}

-- Format Options {{{

opt.formatoptions = table.concat({
  '1',
  'q', -- continue comments with gq"
  'c', -- Auto-wrap comments using textwidth
  'r', -- Continue comments when pressing Enter
  'n', -- Recognize numbered lists
  '2', -- Use indent from 2nd line of a paragraph
  't', -- autowrap lines using text width value
  'j', -- remove a comment leader when joining lines.
  -- Only break if the line was not longer than 'textwidth' when the insert
  -- started and only at a white character that has been entered during the
  -- current insert command.
  'lv'
})

-- }}}

-- Folds {{{

vim.wo.foldtext = 'v:lua.folds()'
vim.go.foldopen = add(vim.go.foldopen, 'search')
vim.wo.foldlevel = 99
vim.go.foldlevelstart = 10
-- opt.foldmethod = 'syntax'

-- }}}

-- Grepprg {{{

-- Use faster grep alternatives if possible
if executable('rg') then
  vim.go.grepprg =
      [[rg --hidden --glob "!.git" --no-heading --smart-case --vimgrep --follow $*]]
  vim.go.grepformat = add('%f:%l:%c:%m', vim.go.grepformat)
elseif executable('ag') then
  vim.go.grepprg = [[ag --nogroup --nocolor --vimgrep]]
  vim.go.grepformat = add('%f:%l:%c:%m', vim.go.grepformat)
end

-- }}}

-- Wild and file globbing stuff in command mode {{{

vim.go.wildcharm = api.nvim_eval([[char2nr("\<C-Z>")]]) -- FIXME: what's the correct way to do this?
vim.go.wildmenu = true
vim.go.wildmode = 'full' -- Shows a menu bar as opposed to an enormous list
vim.go.wildignorecase = true -- Ignore case when completing file names and directories
-- Binary
vim.go.wildignore = add {
  '*.aux,*.out,*.toc',
  '*.o,*.obj,*.dll,*.jar,*.pyc,*.rbc,*.class',
  '*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp',
  '*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm',
  '*.eot,*.otf,*.ttf,*.woff',
  '*.doc,*.pdf',
  '*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz',
  '.sass-cache',
  '*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*.gem',
  '*.*~,*~ ',
  '*.swp,.lock,.DS_Store,._*,tags.lock'
}
vim.go.wildoptions = 'pum'
vim.go.pumblend = 3 -- Make popup window translucent

-- }}}

-- Display {{{

opt.conceallevel = 2
opt.breakindentopt = 'sbr'
opt.linebreak = true -- lines wrap at words rather than random characters
opt.synmaxcol = 1024 -- don't syntax highlight long lines
opt.signcolumn = 'yes:2'
vim.go.colorcolumn = '+1' -- Set the colour column to highlight one column after the 'textwidth'
vim.go.cmdheight = 2 -- Set command line height to two lines
vim.go.showbreak = [[↪ ]] -- Options include -> '…', '↳ ', '→','↪ '
vim.g.vimsyn_embed = 'lPr' -- allow embedded syntax highlighting for lua,python and ruby

-- }}}

-- List chars {{{

vim.go.list = true -- invisible chars
vim.go.listchars = add {
  'eol: ',
  'tab:│ ',
  'extends:›', -- Alternatives: … »
  'precedes:‹', -- Alternatives: … «
  'trail:•' -- BULLET (U+2022, UTF-8: E2 80 A2)
}

-- }}}

-- Indentation {{{

opt.wrap = true
opt.wrapmargin = 2
opt.softtabstop = 2
opt.textwidth = 80
opt.shiftwidth = 2
opt.expandtab = true
opt.smarttab = true
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true
vim.go.shiftround = true

vim.go.joinspaces = false
vim.go.gdefault = true
vim.go.pumheight = 15
vim.go.confirm = true -- make vim prompt me to save before doing destructive things
vim.go.completeopt = add { 'menuone', 'noinsert', 'noselect' }
vim.go.hlsearch = true
vim.go.autowriteall = true -- automatically :write before running commands and changing files
vim.go.clipboard = 'unnamedplus'
vim.go.lazyredraw = true
vim.go.laststatus = 2
vim.go.showtabline = 2
vim.go.cursorline = true
vim.go.ttyfast = true
vim.go.belloff = 'all'
vim.go.termguicolors = true
vim.go.background = 'dark'
vim.go.showmode = false
vim.go.showcmd = false
vim.go.backup = false
vim.go.writebackup = false
vim.go.visualbell = true
vim.go.errorbells = false

-- }}}

-- Emoji {{{1

-- emoji is true by default but makes (n)vim treat all emoji as double width
-- which breaks rendering so we turn this off.
-- CREDIT: https://www.youtube.com/watch?v=F91VWOelFNE
vim.go.emoji = false

-- }}}

-- Title {{{

vim.go.titlestring = ' ❐ %t %r %m'
vim.go.titleold = '%{fnamemodify(getcwd(), ":t")}'
vim.go.title = true
vim.go.titlelen = 70

-- }}}

-- Utilities {{{

vim.go.showmode = false
vim.go.sessionoptions = add {
  'globals',
  'buffers',
  'curdir',
  'tabpages',
  'help',
  'winpos'
}
vim.go.viewoptions = add { 'cursor', 'folds', 'slash', 'unix' } -- save/restore just these (with `:{mk,load}view`)
vim.go.virtualedit = 'block' -- allow cursor to move where there is no text in visual block mode
vim.go.dictionary = '/usr/share/dict/words'
vim.go.inccommand = 'split'
-- This is from the help docs, it enables mode shapes, "Cursor" highlight, and blinking
vim.go.guicursor = table.concat({
  [[n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50]],
  [[a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor]],
  [[sm:block-blinkwait175-blinkoff150-blinkon175]]
}, ',')
vim.go.autoread = true
vim.go.mat = 2
vim.go.history = 1000
vim.go.swapfile = false
vim.go.backspace = add { 'indent', 'eol', 'start' }
vim.go.path = table.concat({ '**' })
vim.go.tags = table.concat({ './tags', 'tags:$HOME' })

-- }}}

-- BACKUP AND SWAPS {{{

vim.go.swapfile = false
vim.go.backup = false
vim.go.writebackup = false
if fn.isdirectory(vim.go.undodir) == 0 then
  fn.mkdir(vim.go.undodir, 'p')
end
opt.undofile = true

-- }}}

-- Match and search {{{

vim.go.showmatch = true
vim.go.magic = true
vim.go.ignorecase = true
vim.go.smartcase = true
vim.go.incsearch = true
vim.go.wrapscan = true -- Searches wrap around the end of the file
vim.go.scrolloff = 9
vim.go.sidescrolloff = 10
vim.go.sidescroll = 1

-- }}}

-- Spelling {{{

vim.go.spellsuggest = add(12, vim.go.spellsuggest)
vim.go.spelloptions = 'camel'
vim.go.spellcapcheck = '' -- don't check for capital letters at start of sentence
vim.go.fileformats = 'unix,mac,dos'
vim.go.complete = add('kspell', vim.go.complete)

-- }}}

-- Mouse {{{

vim.go.mouse = 'a'
vim.go.mousefocus = true
-- FIXME - these don't work in lua
-- vim.go.mousehide = true -- Raise issue on Neovim as this errors

-- }}}

-- these only read ".vim" files {{{

vim.go.secure = true -- Disable autocmd etc for project local vimrc files.
vim.go.exrc = true -- Allow project local vimrc files example .nvimrc see :h exrc

-- }}}

-- -- Git editor {{{

-- if executable('nvr') then
--   vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait +\'set bufhidden=wipe\''
--   vim.env.EDITOR = 'nvr -cc split --remote-wait +\'set bufhidden=wipe\''
-- end

-- -- }}}

-- vim.cmd {{{

vim.cmd([[syntax enable]])
vim.cmd([[filetype plugin indent on]])
vim.cmd([[set re=1]])
vim.cmd([[set shada=!,'1000,<50,s10,h]])
vim.cmd([[set t_ZH=[3m]])
vim.cmd([[set t_ZR=[23m]])
vim.cmd([[set t_ut=]])

-- }}}

-- vim.nvim_api {{{

vim.api.nvim_exec([[
      " True color support
      if (has("nvim"))
        "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
      endif

      " set true colors
      if has('termguicolors')
        set t_8f=\[[38;2;%lu;%lu;%lum
        set t_8b=\[[48;2;%lu;%lu;%lum
        set termguicolors
      endif

      " Trim Whitespaces
      fun! TrimWhitespace()
        let l:save = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:save)
      endfun

      autocmd BufWritePre * :call TrimWhitespace()

      " Faster Startup time (disable default plugins loading)
      let g:did_install_default_menus = 1
      let g:did_install_syntax_menu = 1
      set guioptions=M
      let g:loaded_vimball           = 1
      let g:loaded_vimballPlugin     = 1
      let g:loaded_getscript         = 1
      let g:loaded_getscriptPlugin   = 1
      " let g:loaded_netrw             = 1
      " let g:loaded_netrwPlugin       = 1
      " let g:loaded_netrwSettings     = 1
      " let g:loaded_netrwFileHandlers = 1
      " let g:netrw_banner=0

      " python hosts
      let g:python3_host_prog = '/home/lalitmee/.pyenv/versions/neovim3/bin/python'
      let g:python_host_prog = '/home/lalitmee/.pyenv/versions/neovim2/bin/python'
  ]], true)

-- }}}

-- autocommands {{{

-- Neovim terminal
autocommands.create({
  Terminal = {
    { 'TermOpen', '*', [[startinsert]] },
    { 'TermEnter', '*', [[startinsert]] },
    { 'TermLeave', '*', [[stopinsert]] },
    { 'TermClose', '*', [[stopinsert]] },
    {
      'TermClose',
      'term://*',
      [[if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") | call nvim_input('<CR>')  | endif]]
    },
    { 'FileType', 'markdown', [[MarkdownPreview]] },
    -- for showing the highlight on yanking
    {
      'TextYankPost',
      '*',
      [[lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}]]
    }
  }
})

-- }}}

-- vim:foldmethod=marker
