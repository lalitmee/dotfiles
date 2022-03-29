local fn = vim.fn
local api = vim.api
local opt = vim.opt
local g = vim.g
local executable = lk.executable

----------------------------------------------------------------------
-- NOTE: python hosts {{{
----------------------------------------------------------------------
g.python3_host_prog = "/home/lalitmee/.pyenv/versions/neovim3/bin/python"
g.python_host_prog = "/home/lalitmee/.pyenv/versions/neovim2/bin/python"
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: filetypes for lspconfig and treesitter {{{
----------------------------------------------------------------------
-- enable treesitter for what filetype?
g.enable_treesitter_ft = {
  "bash",
  "css",
  "dockerfile",
  "go",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "norg",
  "typescript",
  "vim",
  "yaml",
}

-- enable lsp for what filetype
g.enable_lspconfig_ft = {
  "bash",
  "css",
  "dockerfile",
  "go",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "typescript",
  "vim",
  "yaml",
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: messages output {{{
----------------------------------------------------------------------
opt.shortmess = {
  t = true, -- truncate file messages at start
  A = true, -- ignore annoying swap file messages
  o = true, -- file-read message overwrites previous
  O = true, -- file-read message overwrites previous
  T = true, -- truncate non-file messages in middle
  f = true, -- (file x of x) instead of just (x of x
  F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
  s = true,
  S = false,
  c = true,
  W = true, -- Dont show [w] or written when writing
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: timings {{{
----------------------------------------------------------------------
opt.updatetime = 300
opt.timeout = true
opt.timeoutlen = 500
opt.ttimeoutlen = 10
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: window splitting and buffers {{{
----------------------------------------------------------------------
opt.number = true
opt.relativenumber = true
opt.hidden = true
opt.splitbelow = true
opt.splitright = true
opt.eadirection = "hor"
-- exclude usetab as we do not want to jump to buffers in already open tabs
-- do not use split or vsplit to ensure we don't open any new windows
vim.o.switchbuf = "useopen,uselast"
opt.fillchars = {
  -- vert = "▕", -- alternatives │
  eob = "~", -- suppress ~ at EndOfBuffer
  diff = "╱", -- alternatives = ⣿ ░ ─
  msgsep = "‾",
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: diff {{{
----------------------------------------------------------------------
-- Use in vertical diff mode, blank lines to keep sides aligned, Ignore whitespace changes
opt.diffopt = opt.diffopt
  + {
    "vertical",
    "iwhite",
    "hiddenoff",
    "foldcolumn:0",
    "context:4",
    "algorithm:histogram",
    "indent-heuristic",
  }
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: format options {{{
----------------------------------------------------------------------
opt.formatoptions = {
  ["1"] = true,
  ["2"] = true, -- Use indent from 2nd line of a paragraph
  q = true, -- continue comments with gq"
  c = true, -- Auto-wrap comments using textwidth
  r = true, -- Continue comments when pressing Enter
  n = true, -- Recognize numbered lists
  t = true, -- autowrap lines using text width value
  j = true, -- remove a comment leader when joining lines.
  -- Only break if the line was not longer than 'textwidth' when the insert
  -- started and only at a white character that has been entered during the
  -- current insert command.
  l = true,
  v = true,
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: folds {{{
----------------------------------------------------------------------
-- opt.foldtext = 'v:lua.as.folds()'
opt.foldopen = opt.foldopen + "search"
opt.foldlevelstart = 0
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldmethod = "expr"
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: greprg {{{
----------------------------------------------------------------------
-- Use faster grep alternatives if possible
if executable("rg") then
  vim.o.grepprg = [[rg --hidden --glob "!*{.git,node_modules,build,tags}" --no-heading --vimgrep --follow $*]]
  opt.grepformat = opt.grepformat ^ { "%f:%l:%c:%m" }
elseif executable("ag") then
  vim.o.grepprg = [[ag --hidden --nogroup --nocolor --vimgrep]]
  opt.grepformat = opt.grepformat ^ { "%f:%l:%c:%m" }
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: Wild and file globbing stuff in command mode {{{
----------------------------------------------------------------------
opt.wildcharm = fn.char2nr(api.nvim_replace_termcodes([[<C-Z>]], true, true, true))
opt.wildmode = "longest:full,full" -- Shows a menu bar as opposed to an enormous list
opt.wildignorecase = true -- Ignore case when completing file names and directories
-- Binary
opt.wildignore = {
  "*.aux",
  "*.out",
  "*.toc",
  "*.o",
  "*.obj",
  "*.dll",
  "*.jar",
  "*.pyc",
  "*.rbc",
  "*.class",
  "*.gif",
  "*.ico",
  "*.jpg",
  "*.jpeg",
  "*.png",
  "*.avi",
  "*.wav",
  -- Temp/System
  "*.*~",
  "*~ ",
  "*.swp",
  ".lock",
  ".DS_Store",
  "tags.lock",
}
opt.wildoptions = "pum"
opt.pumblend = 3 -- Make popup window translucent
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: display {{{
----------------------------------------------------------------------
opt.inccommand = "split"
-- This is from the help docs, it enables mode shapes, "Cursor" highlight, and blinking
opt.cursorline = true
opt.cursorcolumn = false
opt.conceallevel = 2
opt.breakindentopt = "sbr"
opt.linebreak = true -- lines wrap at words rather than random characters
opt.synmaxcol = 1024 -- don't syntax highlight long lines
opt.signcolumn = "yes:2"
opt.ruler = false
opt.cmdheight = 2 -- Set command line height to two lines
-- NOTE: it was putting eol characters in dressinginput
-- opt.showbreak = [[↪ ]] -- Options include -> '…', '↳ ', '→','↪ '
--- This is used to handle markdown code blocks where the language might
--- be set to a value that isn't equivalent to a vim filetype
vim.g.markdown_fenced_languages = {
  "bash",
  "css",
  "javascript",
  "lua",
  "python",
  "scss",
  "typescript",
  "vim",
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: list chars {{{
----------------------------------------------------------------------
opt.list = true -- invisible chars
opt.listchars = {
  eol = nil,
  tab = "│ ",
  extends = "›", -- Alternatives: … »
  precedes = "‹", -- Alternatives: … «
  trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: indentation {{{
----------------------------------------------------------------------
opt.wrap = true
opt.wrapmargin = 2
opt.textwidth = 80
opt.autoindent = true
opt.smartindent = true
opt.shiftround = true
opt.expandtab = true
opt.shiftwidth = 2
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: general {{{
----------------------------------------------------------------------
-- vim.o.debug = "msg"
opt.joinspaces = false
opt.gdefault = true
opt.pumheight = 15
opt.confirm = true -- make vim prompt me to save before doing destructive things
opt.completeopt = {
  "menu",
  "menuone",
  "noselect",
  "noinsert",
}
opt.hlsearch = true
opt.autowriteall = true -- automatically :write before running commands and changing files
opt.clipboard = { "unnamedplus" }
opt.laststatus = 3
opt.termguicolors = true
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: emoji {{{
----------------------------------------------------------------------
-- emoji is true by default but makes (n)vim treat all emoji as double width
-- which breaks rendering so we turn this off.
-- CREDIT: https://www.youtube.com/watch?v=F91VWOelFNE
opt.emoji = false
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: title {{{
----------------------------------------------------------------------
opt.titleold = fn.fnamemodify(vim.loop.os_getenv("SHELL"), ":t")
opt.title = true
opt.titlelen = 70
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: utilities {{{
----------------------------------------------------------------------
opt.showmode = false
opt.sessionoptions = {
  "globals",
  "buffers",
  "curdir",
  "help",
  "winpos",
  "tabpages",
  "help",
  "winsize",
  "terminal",
  "winpos",
}
opt.viewoptions = { "cursor", "folds" } -- save/restore just these (with `:{mk,load}view`)
opt.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: shada (shared data) {{{
----------------------------------------------------------------------
-- NOTE: don't store marks as they are currently broke i.e.
-- are incorrectly resurrected after deletion
-- replace '100 with '0 the default which stores 100 marks
-- add f0 so file marks aren't stored
-- @credit: wincent
opt.shada = { "!", "'1000", "<50", "s10", "h" }
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: backup and swaps {{{
----------------------------------------------------------------------
opt.backup = false
opt.writebackup = false
if fn.isdirectory(vim.o.undodir) == 0 then
  fn.mkdir(vim.o.undodir, "p")
end
opt.undofile = true
opt.swapfile = false
-- The // at the end tells Vim to use the absolute path to the file to create the swap file.
-- This will ensure that swap file name is unique, so there are no collisions between files
-- with the same name from different directories.
opt.directory = fn.stdpath("data") .. "/swap//"
if fn.isdirectory(vim.o.directory) == 0 then
  fn.mkdir(vim.o.directory, "p")
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: match and search {{{
----------------------------------------------------------------------
opt.ignorecase = true
opt.smartcase = true
opt.wrapscan = true -- Searches wrap around the end of the file
opt.scrolloff = 999
-- opt.scrolloff = 10
-- opt.sidescrolloff = 10
opt.sidescroll = 1
opt.visualbell = false
opt.errorbells = false
opt.colorcolumn = "80"
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: spell {{{
----------------------------------------------------------------------
opt.spellsuggest:prepend({ 12 })
opt.spelloptions = "camel"
opt.spellcapcheck = "" -- don't check for capital letters at start of sentence
opt.fileformats = { "unix", "mac", "dos" }
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: mouse {{{
----------------------------------------------------------------------
opt.mouse = "a"
opt.mousefocus = true
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: vim {{{
----------------------------------------------------------------------
-- these only read ".vim" files
opt.secure = true -- Disable autocmd etc for project local vimrc files.
opt.exrc = true -- Allow project local vimrc files example .nvimrc see :h exrc
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: vim cmds {{{
----------------------------------------------------------------------
vim.cmd([[set re=1]])
vim.cmd([[set t_ZH=[3m]])
vim.cmd([[set t_ZR=[23m]])
vim.cmd([[set t_ut=]])
vim.api.nvim_exec(
  [[
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  ]],
  true
)
vim.cmd([[set t_vb=]])
vim.cmd([[set path+=**]])
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
