vim.g.startify_lists = {
  { ['type'] = 'sessions', header = { '   😸 Sessions' } },
  { ['type'] = 'files', header = { '   ⌚ Recent' } },
  {
    ['type'] = 'dir',
    header = {
      '   ⏲️ Recently opened in ' ..
          vim.fn.fnamemodify(vim.fn.getcwd(), '=t')
    }
  },
  { ['type'] = 'bookmarks', header = { '   🔖 Bookmarks' } },
  { ['type'] = 'commands', header = { '   🧰 Commands' } }
}

vim.g.startify_session_dir = '~/.local/share/nvim/sessions'
vim.g.startify_change_to_dir = 1
vim.g.startify_session_autoload = 1
vim.g.startify_session_delete_buffers = 1
vim.g.startify_change_to_vcs_root = 1
vim.g.startify_fortune_use_unicode = 1
vim.g.startify_session_persistence = 1
vim.g.startify_update_oldfiles = 1
vim.g.webdevicons_enable_startify = 1
vim.g.startify_session_sort = 1
vim.g.startify_bookmarks = {
  { be = '~/.config/bat/config' },
  { ge = '~/.goneovim/setting.toml' },
  { ne = '~/.config/nvim/init.lua' },
  { ze = '~/.zshrc' }
}

vim.g.startify_commands = {
  { h = { 'Help', ':help' } },
  { u = { 'Packer Update', ':PackerUpdate' } }
}

function _G.webDevIcons(path)
  local filename = vim.fn.fnamemodify(path, ':t')
  local extension = vim.fn.fnamemodify(path, ':e')
  return require'nvim-web-devicons'.get_icon(filename, extension,
                                             { default = true })
end

vim.api.nvim_exec([[
      function! GetUniqueSessionName()
        let path = fnamemodify(getcwd(), ':~:t')
        let path = empty(path) ? 'no-project' : path
        let branch = get(b:,'gitsigns_head','')
        let branch = empty(branch) ? '' : '-' . branch
        return substitute(path . branch, '/', '-', 'g')
      endfunction

      autocmd! VimLeavePre * silent execute 'SSave! ' . GetUniqueSessionName()

      " icons in startify using nvim-web-devicons
      function! StartifyEntryFormat() abort
        return 'v:lua.webDevIcons(absolute_path) . "  " . entry_path'
      endfunction
  ]], true)
