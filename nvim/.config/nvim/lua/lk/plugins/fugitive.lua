local fn = vim.fn

function _G.__fugitive_create_new_branch()
  -- TODO: add a new line at the end of the input
  -- consider highlighting for bonus point
  local branch = fn.input('Enter new branch name: ')
  if branch and #branch > 0 then
    vim.cmd 'redraw' -- clear the input message we just added
    vim.cmd(string.format([[execute 'Git checkout -b %s']], branch))
  end
end

local nnoremap = lk_utils.nnoremap
local vnoremap = lk_utils.vnoremap
local command = lk_utils.command

command { 'Gcm', [[<cmd>G checkout master]], nargs = 0 }
command { 'Gcb', [[<cmd>G checkout -b <q-args>]], nargs = 1 }

-- Fugitive bindings
nnoremap('<localleader>gbl', '<cmd>Git blame --date=short<CR>')
nnoremap('<localleader>gca', '<cmd>Git commit<CR>')
nnoremap('<localleader>gcb', '<cmd>lua __fugitive_create_new_branch()<CR>')
nnoremap('<localleader>gcl', '<cmd>Gclog!<CR>')
nnoremap('<localleader>gcm', '<cmd>Gcm<CR>')
nnoremap('<localleader>gco', ':Git checkout<space><C-Z>')
nnoremap('<localleader>gda', '<cmd>G difftool -y<CR>')
nnoremap('<localleader>gdb', '<cmd>Gdiffsplit<CR>')
nnoremap('<localleader>gdc', '<cmd>call fugitive#DiffClose()<CR>')
nnoremap('<localleader>gdt', '<cmd>G difftool<CR>')
nnoremap('<localleader>gm', '<cmd>Git mergetool<CR>')
nnoremap('<localleader>gp', '<cmd>Git push<CR>')
nnoremap('<localleader>gre', '<cmd>Gread<CR>')
nnoremap('<localleader>grm', '<cmd>GRemove<CR>')
nnoremap('<localleader>gst', '<cmd>Git<CR>')
nnoremap('<localleader>gw', '<cmd>Gwrite<CR>')
