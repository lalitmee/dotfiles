----------------------------------------------------------------------
-- NOTE: options {{{
----------------------------------------------------------------------

local fn = vim.fn
local api = vim.api
local opt = vim.opt
local o = vim.o
local g = vim.g
local executable = lk.executable

----------------------------------------------------------------------
-- NOTE: filetypes for lspconfig and treesitter {{{
----------------------------------------------------------------------
-- NOTE: lspconfig
g.enable_lspconfig_ft = {
    "bash",
    "css",
    "dockerfile",
    "go",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "lua",
    "markdown",
    "typescript",
    "typescriptreact",
    "vim",
    "yaml",
}

-- NOTE: treesitter
g.enable_treesitter_ft = {
    "bash",
    "c",
    "comment",
    "cpp",
    "css",
    "diff",
    "dockerfile",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "kdl",
    "lua",
    "markdown",
    "markdown_inline",
    "org",
    "python",
    "regex",
    "rust",
    "scss",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: python hosts {{{
----------------------------------------------------------------------
g.python3_host_prog = "/home/lalitmee/.pyenv/versions/neovim3/bin/python"
g.python_host_prog = "/home/lalitmee/.pyenv/versions/neovim2/bin/python"
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

    -- NOTE: this breaks autocommand messages
    F = true, -- Don't give file info when editing a file,
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
o.updatetime = 300
o.timeout = true
o.timeoutlen = 500
o.ttimeoutlen = 10
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: window splitting and buffers {{{
----------------------------------------------------------------------
o.number = true
o.relativenumber = true
o.hidden = true
o.splitbelow = true
o.splitright = true
o.splitkeep = "screen"
o.eadirection = "hor"
-- exclude usetab as we do not want to jump to buffers in already open tabs
-- do not use split or vsplit to ensure we don't open any new windows
o.switchbuf = "useopen,uselast"
opt.fillchars = {
    diff = "╱", -- alternatives = ⣿ ░ ─
    eob = " ",
    fold = " ",
    foldclose = "",
    foldopen = "",
    foldsep = " ",
    msgsep = "‾",
    vert = "│", -- alternatives ▕ ┃
    horiz = "─", -- ━
    verthoriz = "┼", -- ╋
    vertleft = "┤", -- ┫
    vertright = "├", -- ┣
    horizdown = "┬", -- ┳
    horizup = "┴", -- ┻
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: diff {{{
----------------------------------------------------------------------
-- Use in vertical diff mode, blank lines to keep sides aligned,
-- Ignore whitespace changes
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
-- TODO: w, {v, b, l}
opt.formatoptions = opt.formatoptions
    + "c" -- In general, I like it when comments respect textwidth
    + "j" -- Auto-remove comments if possible.
    + "n" -- Indent past the formatlistpat, not underneath it.
    + "q" -- Allow formatting comments w/ gq
    + "r" -- But do continue when pressing enter.
    - "2" -- I'm not in gradeschool anymore
    - "a" -- Auto formatting is BAD.
    - "o" -- O and o, don't continue comments
    - "t" -- Don't auto format my code. I got linters for that.
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: folds {{{
----------------------------------------------------------------------
-- opt.foldtext = 'v:lua.as.folds()'
opt.foldopen = opt.foldopen + "search"
o.foldlevel = 99
o.foldmethod = "manual"
-- o.foldexpr = "nvim_treesitter#foldexpr()"
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: greprg {{{
----------------------------------------------------------------------
-- Use faster grep alternatives if possible
if executable("rg") then
    o.grepprg = [[rg --hidden --glob "!*{.git,node_modules,build,tags}"
    --no-heading --vimgrep --follow $*]]
    opt.grepformat = opt.grepformat ^ { "%f:%l:%c:%m" }
elseif executable("ag") then
    o.grepprg = [[ag --hidden --nogroup --nocolor --vimgrep]]
    opt.grepformat = opt.grepformat ^ { "%f:%l:%c:%m" }
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: Wild and file globbing stuff in command mode {{{
----------------------------------------------------------------------
-- NOTE: I don't know the use of this yet, but it's a nice feature
-- o.wildcharm =
-- fn.char2nr(api.nvim_replace_termcodes([[<C-Z>]], true, true, true))
-- Shows a menu bar as opposed to an enormous list
o.wildmode = "longest:full,full"
-- Ignore case when completing file names and directories
o.wildignorecase = true
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
o.wildoptions = "pum"
o.pumblend = 3 -- Make popup window translucent
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: display {{{
----------------------------------------------------------------------
o.inccommand = "split"
-- This is from the help docs, it enables mode shapes,
-- "Cursor" highlight, and blinking
o.cursorline = true
o.cursorcolumn = false
o.conceallevel = 2
o.breakindentopt = "sbr"
o.linebreak = true -- lines wrap at words rather than random characters
o.synmaxcol = 1024 -- don't syntax highlight long lines
o.signcolumn = "yes:2"
o.ruler = false
o.cmdheight = 1 -- Set command line height to two lines
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
o.list = true -- invisible chars
opt.listchars = {
    eol = nil,
    tab = "» ",
    extends = "›", -- Alternatives: … »
    precedes = "‹", -- Alternatives: … «
    trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: indentation {{{
----------------------------------------------------------------------
o.wrap = true
o.wrapmargin = 2
o.textwidth = 80
o.autoindent = true
o.smartindent = true
o.shiftround = true
o.expandtab = true
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: general {{{
----------------------------------------------------------------------
-- opt.debug = "msg"
o.joinspaces = false
o.gdefault = true
o.pumheight = 15
o.confirm = true -- make vim prompt me to save before doing destructive things
opt.completeopt = {
    "menu",
    "menuone",
    "noselect",
    "noinsert",
}
o.hlsearch = true
-- automatically :write before running commands and changing files
o.autowriteall = true
opt.clipboard = { "unnamedplus" }
o.laststatus = 3
o.showtabline = 0
o.tgc = true
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: emoji {{{
----------------------------------------------------------------------
-- emoji is true by default but makes (n)vim treat all emoji as double width
-- which breaks rendering so we turn this off.
-- CREDIT: https://www.youtube.com/watch?v=F91VWOelFNE
o.emoji = false
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: title {{{
----------------------------------------------------------------------
o.titleold = fn.fnamemodify(vim.loop.os_getenv("SHELL"), ":t")
o.title = true
o.titlelen = 70
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: utilities {{{
----------------------------------------------------------------------
o.lazyredraw = false
o.showmode = false
o.showmatch = true
o.showcmd = true
opt.sessionoptions = {
    "buffers",
    "curdir",
    "folds",
    "globals",
    "help",
    "help",
    "localoptions",
    "tabpages",
    "terminal",
    "winpos",
    "winpos",
    "winsize",
}
-- save/restore just these (with `:{mk,load}view`)
opt.viewoptions = { "cursor", "folds" }
-- allow cursor to move where there is no text in visual block mode
opt.virtualedit = { "block" }
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
o.maxmempattern = 5000
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: backup and swaps {{{
----------------------------------------------------------------------
o.backup = false
o.writebackup = false
if fn.isdirectory(o.undodir) == 0 then
    fn.mkdir(o.undodir, "p")
end
o.undofile = true
o.swapfile = false
-- The // at the end tells Vim to use the absolute path to the file to create
-- the swap file. This will ensure that swap file name is unique, so there are
-- no collisions between files with the same name from different directories.
o.directory = fn.stdpath("data") .. "/swap//"
if fn.isdirectory(o.directory) == 0 then
    fn.mkdir(o.directory, "p")
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: match and search {{{
----------------------------------------------------------------------
o.ignorecase = true
o.smartcase = true
o.wrapscan = true -- Searches wrap around the end of the file
-- opt.scrolloff = 999
o.scrolloff = 10
o.visualbell = false
o.errorbells = false
-- opt.colorcolumn = "80"
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: spell {{{
----------------------------------------------------------------------
opt.spellsuggest:prepend({ 12 })
opt.spelloptions = { "camel" }
o.spellcapcheck = "" -- don't check for capital letters at start of sentence
opt.fileformats = { "unix", "mac", "dos" }
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: mouse {{{
----------------------------------------------------------------------
o.mouse = "a"
o.mousefocus = true
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: vim {{{
----------------------------------------------------------------------
-- these only read ".vim" files
o.secure = true -- Disable autocmd etc for project local vimrc files.
o.exrc = true -- Allow project local vimrc files example .nvimrc see :h exrc
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: vim cmds {{{
----------------------------------------------------------------------
opt.path:append("**")
o.regexpengine = 1
-- vim.cmd([[
--   set t_vb=
--   let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
--   let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
--   set t_ZH=[3m
--   set t_ZR=[23m
--   set t_ut=
-- ]])
-- }}}
----------------------------------------------------------------------

-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
