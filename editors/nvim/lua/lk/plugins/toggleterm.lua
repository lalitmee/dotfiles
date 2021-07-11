local toggleterm = require('toggleterm')
local Terminal = require('toggleterm.terminal').Terminal

toggleterm.setup {
  size = 30,
  open_mapping = '<c-t>',
  shade_filetypes = {},
  shade_terminals = true,
  start_in_insert = true,
  persist_size = true,
  direction = 'float'
}

-- commands
vim.cmd [[command! -count=1 TermGitPushSet lua require'toggleterm'.exec("gpsup", <count>, 12)]]
vim.cmd [[command! -count=1 TermGitPush lua require'toggleterm'.exec("gp", <count>, 12)]]
vim.cmd [[command! -count=1 TermGitPushF lua require'toggleterm'.exec("gpf", <count>, 12)]]

local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true })
local tig = Terminal:new({ cmd = 'tig', hidden = true })
local terminal_velocity = Terminal:new({
  cmd = 'terminal_velocity',
  hidden = true
})
local lazydocker = Terminal:new({ cmd = 'lazydocker', hidden = true })
local fzf = Terminal:new({ cmd = 'fzf', hidden = true })
local node = Terminal:new({ cmd = 'node', hidden = true })
local python = Terminal:new({ cmd = 'python3', hidden = true })
local ranger = Terminal:new({ cmd = 'ranger', hidden = true })
local ncdu = Terminal:new({ cmd = 'ncdu', hidden = true })
local grv = Terminal:new({ cmd = 'grv', hidden = true })
local wt = Terminal:new({ cmd = 'wt', hidden = true })
local btm = Terminal:new({ cmd = 'btm', hidden = true })

-- lazygit
function LazyGit()
  lazygit:toggle()
end

-- tig
function Tig()
  tig:toggle()
end

-- terminal_velocity
function Terminal_Velocity()
  terminal_velocity:toggle()
end

-- lazydocker
function LazyDocker()
  lazydocker:toggle()
end

-- fzf
function Fzf()
  fzf:toggle()
end

-- node
function Node()
  node:toggle()
end

-- python3
function Python3()
  python:toggle()
end

-- ranger
function Ranger()
  ranger:toggle()
end

-- ncdu
function Ncdu()
  ncdu:toggle()
end

-- grv
function Grv()
  grv:toggle()
end

-- wt
function Wt()
  wt:toggle()
end

-- btm
function Btm()
  btm:toggle()
end
