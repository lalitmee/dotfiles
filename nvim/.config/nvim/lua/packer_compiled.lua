-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = true
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/lalitmee/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/lalitmee/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/lalitmee/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/lalitmee/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/lalitmee/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  FastFold = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/FastFold",
    url = "https://github.com/Konfekt/FastFold"
  },
  ["Navigator.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14Navigator\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/Navigator.nvim",
    url = "https://github.com/numToStr/Navigator.nvim"
  },
  ["close-buffers.nvim"] = {
    config = { "\27LJ\2\n�\1\0\1\v\0\5\0\0176\1\0\0009\1\1\0019\1\2\1B\1\1\0026\2\3\0\18\4\0\0B\2\2\4X\5\6�6\a\0\0009\a\1\a9\a\4\a\18\t\6\0\18\n\1\0B\a\3\1E\5\3\3R\5�K\0\1\0\21nvim_win_set_buf\vipairs\25nvim_get_current_buf\bapi\bvim�\1\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\20next_buffer_cmd\0\27preserve_window_layout\1\0\0\1\3\0\0\tthis\rnameless\nsetup\18close_buffers\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/close-buffers.nvim",
    url = "https://github.com/kazhala/close-buffers.nvim"
  },
  ["cmp-buffer"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-buffer/after/plugin/cmp_buffer.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-cmdline/after/plugin/cmp_cmdline.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-emoji"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-emoji/after/plugin/cmp_emoji.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-emoji",
    url = "https://github.com/hrsh7th/cmp-emoji"
  },
  ["cmp-nvim-lsp"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp/after/plugin/cmp_nvim_lsp.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua/after/plugin/cmp_nvim_lua.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-nvim-ultisnips"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-nvim-ultisnips/after/plugin/cmp_nvim_ultisnips.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-nvim-ultisnips",
    url = "https://github.com/quangnguyen30192/cmp-nvim-ultisnips"
  },
  ["cmp-path"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-path/after/plugin/cmp_path.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-spell"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-spell/after/plugin/cmp-spell.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-spell",
    url = "https://github.com/f3fora/cmp-spell"
  },
  ["cmp-tabnine"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-tabnine/after/plugin/cmp-tabnine.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-tabnine",
    url = "https://github.com/tzachar/cmp-tabnine"
  },
  ["cobalt2.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/cobalt2.nvim",
    url = "/home/lalitmee/Desktop/Github/cobalt2.nvim"
  },
  ["colorbuddy.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/colorbuddy.nvim",
    url = "https://github.com/tjdevries/colorbuddy.nvim"
  },
  ["comment-box.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/comment-box.nvim",
    url = "https://github.com/LudoPinelli/comment-box.nvim"
  },
  ["complextras.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/complextras.nvim",
    url = "https://github.com/tjdevries/complextras.nvim"
  },
  ["conflict-marker.vim"] = {
    config = { "\27LJ\2\n�\1\0\0\2\0\b\0\r6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0'\1\a\0=\1\6\0K\0\1\0\17^>>>>>>> .*$\24conflict_marker_end\17^<<<<<<< .*$\26conflict_marker_begin\5$conflict_marker_highlight_group\6g\bvim\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/conflict-marker.vim",
    url = "https://github.com/rhysd/conflict-marker.vim"
  },
  ["copilot.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/copilot.vim",
    url = "https://github.com/github/copilot.vim"
  },
  ["crease.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/crease.vim",
    url = "https://github.com/scr1pt0r/crease.vim"
  },
  ["diaglist.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/diaglist.nvim",
    url = "https://github.com/onsails/diaglist.nvim"
  },
  ["dial.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/dial.nvim",
    url = "https://github.com/monaqa/dial.nvim"
  },
  ["diffview.nvim"] = {
    config = { "\27LJ\2\n�\1\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\b\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\3=\3\t\2B\0\2\1K\0\1\0\17key_bindings\1\0\0\tview\1\0\1\6q\27<Cmd>DiffviewClose<CR>\15file_panel\1\0\0\1\0\1\6q\27<Cmd>DiffviewClose<CR>\nsetup\rdiffview\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["dim.lua"] = {
    config = { "\27LJ\2\n1\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\bdim\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/dim.lua",
    url = "https://github.com/narutoxy/dim.lua"
  },
  ["dirbuf.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/dirbuf.nvim",
    url = "https://github.com/elihunter173/dirbuf.nvim"
  },
  ["doorboy.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/doorboy.vim",
    url = "https://github.com/itmammoth/doorboy.vim"
  },
  ["filetype.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/filetype.nvim",
    url = "https://github.com/nathom/filetype.nvim"
  },
  ["formatter.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/formatter.nvim",
    url = "https://github.com/mhartington/formatter.nvim"
  },
  ["git-worktree.nvim"] = {
    config = { "\27LJ\2\nQ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\17git_worktree\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/git-worktree.nvim",
    url = "https://github.com/ThePrimeagen/git-worktree.nvim"
  },
  ["github-notifications.nvim"] = {
    cond = { "\27LJ\2\n(\0\0\3\0\3\0\0046\0\0\0009\0\1\0'\2\2\0D\0\2\0\agh\15executable\alk\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/github-notifications.nvim",
    url = "https://github.com/rlch/github-notifications.nvim"
  },
  ["gitlinker.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/gitlinker.nvim",
    url = "https://github.com/ruifm/gitlinker.nvim"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["glow.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/glow.nvim",
    url = "https://github.com/ellisonleao/glow.nvim"
  },
  harpoon = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/harpoon",
    url = "https://github.com/ThePrimeagen/harpoon"
  },
  ["headlines.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14headlines\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/headlines.nvim",
    url = "https://github.com/lukas-reineke/headlines.nvim"
  },
  ["hop.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/hop.nvim",
    url = "https://github.com/phaazon/hop.nvim"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["incsearch.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/incsearch.vim",
    url = "https://github.com/haya14busa/incsearch.vim"
  },
  ["indent-blankline.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["inline_edit.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/inline_edit.vim",
    url = "https://github.com/AndrewRadev/inline_edit.vim"
  },
  ["iswap.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/iswap.nvim",
    url = "https://github.com/mizlan/iswap.nvim"
  },
  ["lsp-colors.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/lsp-colors.nvim",
    url = "https://github.com/folke/lsp-colors.nvim"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/lsp-status.nvim",
    url = "https://github.com/nvim-lua/lsp-status.nvim"
  },
  ["lsp_extensions.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/lsp_extensions.nvim",
    url = "https://github.com/tjdevries/lsp_extensions.nvim"
  },
  ["lsp_signature.nvim"] = {
    config = { "\27LJ\2\n�\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\1K\0\1\0\17handler_opts\1\0\1\vborder\frounded\1\0\4\21auto_close_after\3\15\16hint_enable\1\tbind\2\ffix_pos\1\nsetup\18lsp_signature\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim",
    url = "https://github.com/ray-x/lsp_signature.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["lspsaga.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/lspsaga.nvim",
    url = "https://github.com/tami5/lspsaga.nvim"
  },
  ["lua-dev.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/lua-dev.nvim",
    url = "https://github.com/folke/lua-dev.nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["marks.nvim"] = {
    config = { "\27LJ\2\nZ\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\rmappings\1\0\0\1\0\1\rset_next\am,\nsetup\nmarks\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/marks.nvim",
    url = "https://github.com/chentau/marks.nvim"
  },
  ["memento.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/memento.nvim",
    url = "https://github.com/gaborvecsei/memento.nvim"
  },
  neogen = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vneogen\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/neogen",
    url = "https://github.com/danymat/neogen"
  },
  neogit = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/neogit",
    url = "https://github.com/TimUntersberger/neogit"
  },
  neorg = {
    config = { "\27LJ\2\n�\1\0\0\6\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\b\0005\3\6\0005\4\4\0005\5\3\0=\5\5\4=\4\a\3=\3\t\2B\0\2\1K\0\1\0\21core.norg.dirman\1\0\0\vconfig\1\0\0\15workspaces\1\0\0\1\0\1\twork!~/Desktop/Github/Notes/neorg\nsetup\nneorg\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/neorg",
    url = "https://github.com/nvim-neorg/neorg"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\nS\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\24use_local_scrolloff\2\nsetup\14neoscroll\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/neoscroll.nvim",
    url = "https://github.com/karb94/neoscroll.nvim"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["numb.nvim"] = {
    config = { "\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tnumb\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/numb.nvim",
    url = "https://github.com/nacro90/numb.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\nt\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\21disable_filetype\1\0\0\1\3\0\0\20TelescopePrompt\bvim\nsetup\19nvim-autopairs\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-bqf"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-bqf",
    url = "https://github.com/kevinhwang91/nvim-bqf"
  },
  ["nvim-bufferline.lua"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-bufferline.lua",
    url = "https://github.com/akinsho/nvim-bufferline.lua"
  },
  ["nvim-cheat.sh"] = {
    commands = { "Cheat", "CheatWithouComments", "CheatList", "CheatListWithoutComments" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-cheat.sh",
    url = "https://github.com/RishabhRD/nvim-cheat.sh"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-ui"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-gomove"] = {
    config = { "\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\vgomove\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-gomove",
    url = "https://github.com/booperlv/nvim-gomove"
  },
  ["nvim-hclipboard"] = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nstart\15hclipboard\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-hclipboard",
    url = "https://github.com/kevinhwang91/nvim-hclipboard"
  },
  ["nvim-hlslens"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-hlslens",
    url = "https://github.com/kevinhwang91/nvim-hlslens"
  },
  ["nvim-lsp-installer"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-neoclip.lua"] = {
    config = { "\27LJ\2\n�\1\0\0\6\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\t\0005\4\5\0005\5\4\0=\5\6\0045\5\a\0=\5\b\4=\4\n\3=\3\v\2B\0\2\1K\0\1\0\tkeys\14telescope\1\0\0\6n\1\0\3\17paste_behind\6P\npaste\t<CR>\vselect\6p\6i\1\0\0\1\0\3\17paste_behind\n<c-k>\npaste\t<CR>\vselect\n<c-p>\1\0\1\30enable_persistent_history\2\nsetup\fneoclip\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-neoclip.lua",
    url = "https://github.com/AckslD/nvim-neoclip.lua"
  },
  ["nvim-nonicons"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-nonicons",
    url = "https://github.com/yamatsum/nvim-nonicons"
  },
  ["nvim-notify"] = {
    config = { "\27LJ\2\n�\2\0\0\5\0\21\0(6\0\0\0009\0\1\0009\0\2\0\15\0\0\0X\1\1�K\0\1\0006\0\3\0'\2\4\0B\0\2\0029\0\5\0005\2\6\0005\3\v\0006\4\a\0009\4\b\0049\4\t\0049\4\n\4=\4\f\0036\4\a\0009\4\b\0049\4\t\0049\4\r\4=\4\14\0036\4\a\0009\4\b\0049\4\t\0049\4\15\4=\4\16\0036\4\a\0009\4\b\0049\4\t\0049\4\17\4=\4\18\0036\4\a\0009\4\b\0049\4\t\0049\4\19\4=\4\20\3=\3\t\2B\0\2\1K\0\1\0\nTRACE\ntrace\nDEBUG\ndebug\tINFO\tinfo\tWARN\twarn\nERROR\1\0\0\nerror\nicons\nstyle\alk\1\0\2\ftimeout\3�\15\vstages\vstatic\nsetup\vnotify\frequire\27packer_compiled_loaded\6g\bvim\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-pqf.git"] = {
    config = { "\27LJ\2\n1\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\bpqf\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-pqf.git",
    url = "https://gitlab.com/yorickpeterse/nvim-pqf"
  },
  ["nvim-regexplainer"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17regexplainer\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-regexplainer",
    url = "https://github.com/bennypowers/nvim-regexplainer"
  },
  ["nvim-spectre"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-spectre",
    url = "https://github.com/windwp/nvim-spectre"
  },
  ["nvim-terminal.lua"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-terminal.lua",
    url = "https://github.com/norcalli/nvim-terminal.lua"
  },
  ["nvim-toggleterm.lua"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-toggleterm.lua",
    url = "https://github.com/akinsho/nvim-toggleterm.lua"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-refactor"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-refactor",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-refactor"
  },
  ["nvim-treesitter-textobjects"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-treesitter-textsubjects"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-textsubjects",
    url = "https://github.com/RRethy/nvim-treesitter-textsubjects"
  },
  ["nvim-ts-context-commentstring"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-ts-context-commentstring",
    url = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring"
  },
  ["nvim-ts-rainbow"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-ts-rainbow",
    url = "https://github.com/p00f/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["octo.nvim"] = {
    config = { "\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tocto\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/octo.nvim",
    url = "https://github.com/pwntester/octo.nvim"
  },
  ["open-browser.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/open-browser.vim",
    url = "https://github.com/tyru/open-browser.vim"
  },
  ["org-bullets.nvim"] = {
    config = { "\27LJ\2\nd\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\fsymbols\1\0\0\1\5\0\0\b◉\b○\b✸\b✿\nsetup\16org-bullets\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/org-bullets.nvim",
    url = "https://github.com/akinsho/org-bullets.nvim"
  },
  ["orgmode.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/orgmode.nvim",
    url = "https://github.com/nvim-orgmode/orgmode.nvim"
  },
  ["package-info.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17package-info\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/package-info.nvim",
    url = "https://github.com/vuki656/package-info.nvim"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["paperplanes.nvim"] = {
    config = { "\27LJ\2\n_\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\rprovider\15dpaste.org\rregister\6+\nsetup\16paperplanes\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/paperplanes.nvim",
    url = "https://github.com/rktjmp/paperplanes.nvim"
  },
  playground = {
    commands = { "TSPlaygroundToggle" },
    load_after = {},
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  popfix = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/popfix",
    url = "https://github.com/RishabhRD/popfix"
  },
  ["project.nvim"] = {
    config = { "\27LJ\2\n�\1\0\0\3\0\a\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\0016\0\0\0'\2\4\0B\0\2\0029\0\5\0005\2\6\0B\0\2\1K\0\1\0\1\0\1\16show_hidden\2\nsetup\17project_nvim\rprojects\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/project.nvim",
    url = "https://github.com/ahmedkhalf/project.nvim"
  },
  ["quick-scope"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/quick-scope",
    url = "https://github.com/unblevable/quick-scope"
  },
  ["refactoring.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/refactoring.nvim",
    url = "https://github.com/ThePrimeagen/refactoring.nvim"
  },
  ["registers.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/registers.nvim",
    url = "https://github.com/tversteeg/registers.nvim"
  },
  ["replacer.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/replacer.nvim",
    url = "https://github.com/gabrielpoca/replacer.nvim"
  },
  ["scratch.nvim"] = {
    config = { "\27LJ\2\nL\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\fscratch\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/scratch.nvim",
    url = "https://github.com/shift-d/scratch.nvim"
  },
  sniprun = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/sniprun",
    url = "https://github.com/michaelb/sniprun"
  },
  ["splitjoin.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/splitjoin.vim",
    url = "https://github.com/AndrewRadev/splitjoin.vim"
  },
  ["sql.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/sql.nvim",
    url = "https://github.com/tami5/sql.nvim"
  },
  ["sqlite.lua"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/sqlite.lua",
    url = "https://github.com/tami5/sqlite.lua"
  },
  ["startuptime.vim"] = {
    commands = { "StartupTime" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/startuptime.vim",
    url = "https://github.com/tweekmonster/startuptime.vim"
  },
  ["symbols-outline.nvim"] = {
    commands = { "SymbolsOutline", "SymbolsOutlineClose", "SymbolsOutlineOpen" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/symbols-outline.nvim",
    url = "https://github.com/simrat39/symbols-outline.nvim"
  },
  tabular = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/tabular/after/plugin/TabularMaps.vim" },
    commands = { "Tabularize" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/tabular",
    url = "https://github.com/godlygeek/tabular"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/targets.vim",
    url = "https://github.com/wellle/targets.vim"
  },
  ["telescope-arglist.nvim"] = {
    config = { "\27LJ\2\nL\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\farglist\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-arglist.nvim",
    url = "https://github.com/jgvw/telescope-arglist.nvim"
  },
  ["telescope-dap.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bdap\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-dap.nvim",
    url = "https://github.com/nvim-telescope/telescope-dap.nvim"
  },
  ["telescope-emoji.nvim"] = {
    config = { "\27LJ\2\nJ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\nemoji\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-emoji.nvim",
    url = "https://github.com/xiyaowong/telescope-emoji.nvim"
  },
  ["telescope-file-browser.nvim"] = {
    config = { "\27LJ\2\nQ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\17file_browser\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-file-browser.nvim",
    url = "https://github.com/nvim-telescope/telescope-file-browser.nvim"
  },
  ["telescope-frecency.nvim"] = {
    config = { "\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-frecency.nvim",
    url = "https://github.com/nvim-telescope/telescope-frecency.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bfzf\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-harpoon.nvim"] = {
    config = { "\27LJ\2\nL\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\fharpoon\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-harpoon.nvim",
    url = "https://github.com/brandoncc/telescope-harpoon.nvim"
  },
  ["telescope-hop.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bhop\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-hop.nvim",
    url = "https://github.com/nvim-telescope/telescope-hop.nvim"
  },
  ["telescope-live-grep-raw.nvim"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-live-grep-raw.nvim",
    url = "https://github.com/nvim-telescope/telescope-live-grep-raw.nvim"
  },
  ["telescope-media-files.nvim"] = {
    config = { "\27LJ\2\nP\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\16media_files\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-media-files.nvim",
    url = "https://github.com/nvim-telescope/telescope-media-files.nvim"
  },
  ["telescope-openbrowser.nvim"] = {
    config = { "\27LJ\2\nP\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\16openbrowser\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-openbrowser.nvim",
    url = "https://github.com/tamago324/telescope-openbrowser.nvim"
  },
  ["telescope-project.nvim"] = {
    config = { "\27LJ\2\nL\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\fproject\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-project.nvim",
    url = "https://github.com/nvim-telescope/telescope-project.nvim"
  },
  ["telescope-repo.nvim"] = {
    config = { "\27LJ\2\nI\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\trepo\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-repo.nvim",
    url = "https://github.com/cljoly/telescope-repo.nvim"
  },
  ["telescope-smart-history.nvim"] = {
    config = { "\27LJ\2\nR\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\18smart_history\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-smart-history.nvim",
    url = "https://github.com/nvim-telescope/telescope-smart-history.nvim"
  },
  ["telescope-tmux.nvim"] = {
    config = { "\27LJ\2\nI\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\ttmux\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-tmux.nvim",
    url = "https://github.com/camgraff/telescope-tmux.nvim"
  },
  ["telescope-tmuxinator.nvim"] = {
    config = { "\27LJ\2\nO\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\15tmuxinator\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-tmuxinator.nvim",
    url = "https://github.com/danielpieper/telescope-tmuxinator.nvim"
  },
  ["telescope-ui-select.nvim"] = {
    config = { "\27LJ\2\nN\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\14ui-select\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-ui-select.nvim",
    url = "https://github.com/nvim-telescope/telescope-ui-select.nvim"
  },
  ["telescope-windowizer.nvim"] = {
    config = { "\27LJ\2\nO\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\15windowizer\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-windowizer.nvim",
    url = "https://github.com/wesleimp/telescope-windowizer.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["themer.lua"] = {
    config = { "\27LJ\2\nm\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\vstyles\1\0\0\fcomment\1\0\0\1\0\1\nstyle\vitalic\nsetup\vthemer\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/themer.lua",
    url = "https://github.com/themercorp/themer.lua"
  },
  ["tidy.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/tidy.nvim",
    url = "https://github.com/McAuleyPenney/tidy.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\2\nt\0\0\3\0\6\0\r6\0\0\0009\0\1\0009\0\2\0\15\0\0\0X\1\1�K\0\1\0006\0\3\0'\2\4\0B\0\2\0029\0\5\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18todo-comments\frequire\27packer_compiled_loaded\6g\bvim\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ultisnips = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/ultisnips",
    url = "https://github.com/SirVer/ultisnips"
  },
  undotree = {
    commands = { "UndotreeToggle" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["vim-abolish"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-abolish",
    url = "https://github.com/tpope/vim-abolish"
  },
  ["vim-autoswap"] = {
    config = { "\27LJ\2\n6\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\25autoswap_detect_tmux\6g\bvim\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-autoswap",
    url = "https://github.com/gioele/vim-autoswap"
  },
  ["vim-carbon-now-sh"] = {
    commands = { "CarbonNowSh" },
    config = { "\27LJ\2\nF\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\0\1\afm\rMonoLisa\26carbon_now_sh_options\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/vim-carbon-now-sh",
    url = "https://github.com/kristijanhusak/vim-carbon-now-sh"
  },
  ["vim-characterize"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-characterize",
    url = "https://github.com/tpope/vim-characterize"
  },
  ["vim-cool"] = {
    config = { "\27LJ\2\n2\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\21CoolTotalMatches\6g\bvim\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-cool",
    url = "https://github.com/romainl/vim-cool"
  },
  ["vim-cycle"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-cycle",
    url = "https://github.com/zef/vim-cycle"
  },
  ["vim-dispatch"] = {
    commands = { "Dispatch", "Make", "Focus", "Start" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/vim-dispatch",
    url = "https://github.com/tpope/vim-dispatch"
  },
  ["vim-dotenv"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-dotenv",
    url = "https://github.com/tpope/vim-dotenv"
  },
  ["vim-eunuch"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-eunuch",
    url = "https://github.com/tpope/vim-eunuch"
  },
  ["vim-exchange"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-exchange",
    url = "https://github.com/tommcdo/vim-exchange"
  },
  ["vim-fnr"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-fnr",
    url = "https://github.com/junegunn/vim-fnr"
  },
  ["vim-matchup"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-matchup",
    url = "https://github.com/andymass/vim-matchup"
  },
  ["vim-maximizer"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-maximizer",
    url = "https://github.com/szw/vim-maximizer"
  },
  ["vim-pseudocl"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-pseudocl",
    url = "https://github.com/junegunn/vim-pseudocl"
  },
  ["vim-randomtag"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-randomtag",
    url = "https://github.com/mhinz/vim-randomtag"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-scriptease"] = {
    commands = { "Messages", "Verbose", "Time" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/vim-scriptease",
    url = "https://github.com/tpope/vim-scriptease"
  },
  ["vim-sleuth"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-sleuth",
    url = "https://github.com/tpope/vim-sleuth"
  },
  ["vim-snippets"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-snippets",
    url = "https://github.com/honza/vim-snippets"
  },
  ["vim-sort-motion"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-sort-motion",
    url = "https://github.com/christoomey/vim-sort-motion"
  },
  ["vim-startify"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-startify",
    url = "https://github.com/mhinz/vim-startify"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-table-mode"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-table-mode",
    url = "https://github.com/dhruvasagar/vim-table-mode"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-unimpaired",
    url = "https://github.com/tpope/vim-unimpaired"
  },
  ["vim-visual-star-search"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-visual-star-search",
    url = "https://github.com/nelstrom/vim-visual-star-search"
  },
  ["vim-wakatime"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-wakatime",
    url = "https://github.com/wakatime/vim-wakatime"
  },
  ["vim-windowswap"] = {
    config = { "\27LJ\2\n5\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\0\0=\1\2\0K\0\1\0\24windowswap_map_keys\6g\bvim\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-windowswap",
    url = "https://github.com/wesQ3/vim-windowswap"
  },
  ["vim-yoink"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-yoink",
    url = "https://github.com/svermeulen/vim-yoink"
  },
  ["which-key.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: numb.nvim
time([[Config for numb.nvim]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tnumb\frequire\0", "config", "numb.nvim")
time([[Config for numb.nvim]], false)
-- Config for: org-bullets.nvim
time([[Config for org-bullets.nvim]], true)
try_loadstring("\27LJ\2\nd\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\fsymbols\1\0\0\1\5\0\0\b◉\b○\b✸\b✿\nsetup\16org-bullets\frequire\0", "config", "org-bullets.nvim")
time([[Config for org-bullets.nvim]], false)
-- Config for: vim-autoswap
time([[Config for vim-autoswap]], true)
try_loadstring("\27LJ\2\n6\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\25autoswap_detect_tmux\6g\bvim\0", "config", "vim-autoswap")
time([[Config for vim-autoswap]], false)
-- Config for: Navigator.nvim
time([[Config for Navigator.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14Navigator\frequire\0", "config", "Navigator.nvim")
time([[Config for Navigator.nvim]], false)
-- Config for: git-worktree.nvim
time([[Config for git-worktree.nvim]], true)
try_loadstring("\27LJ\2\nQ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\17git_worktree\19load_extension\14telescope\frequire\0", "config", "git-worktree.nvim")
time([[Config for git-worktree.nvim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: package-info.nvim
time([[Config for package-info.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17package-info\frequire\0", "config", "package-info.nvim")
time([[Config for package-info.nvim]], false)
-- Config for: scratch.nvim
time([[Config for scratch.nvim]], true)
try_loadstring("\27LJ\2\nL\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\fscratch\19load_extension\14telescope\frequire\0", "config", "scratch.nvim")
time([[Config for scratch.nvim]], false)
-- Config for: marks.nvim
time([[Config for marks.nvim]], true)
try_loadstring("\27LJ\2\nZ\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\rmappings\1\0\0\1\0\1\rset_next\am,\nsetup\nmarks\frequire\0", "config", "marks.nvim")
time([[Config for marks.nvim]], false)
-- Config for: themer.lua
time([[Config for themer.lua]], true)
try_loadstring("\27LJ\2\nm\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\vstyles\1\0\0\fcomment\1\0\0\1\0\1\nstyle\vitalic\nsetup\vthemer\frequire\0", "config", "themer.lua")
time([[Config for themer.lua]], false)
-- Config for: diffview.nvim
time([[Config for diffview.nvim]], true)
try_loadstring("\27LJ\2\n�\1\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\b\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\3=\3\t\2B\0\2\1K\0\1\0\17key_bindings\1\0\0\tview\1\0\1\6q\27<Cmd>DiffviewClose<CR>\15file_panel\1\0\0\1\0\1\6q\27<Cmd>DiffviewClose<CR>\nsetup\rdiffview\frequire\0", "config", "diffview.nvim")
time([[Config for diffview.nvim]], false)
-- Config for: paperplanes.nvim
time([[Config for paperplanes.nvim]], true)
try_loadstring("\27LJ\2\n_\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\rprovider\15dpaste.org\rregister\6+\nsetup\16paperplanes\frequire\0", "config", "paperplanes.nvim")
time([[Config for paperplanes.nvim]], false)
-- Config for: neorg
time([[Config for neorg]], true)
try_loadstring("\27LJ\2\n�\1\0\0\6\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\b\0005\3\6\0005\4\4\0005\5\3\0=\5\5\4=\4\a\3=\3\t\2B\0\2\1K\0\1\0\21core.norg.dirman\1\0\0\vconfig\1\0\0\15workspaces\1\0\0\1\0\1\twork!~/Desktop/Github/Notes/neorg\nsetup\nneorg\frequire\0", "config", "neorg")
time([[Config for neorg]], false)
-- Config for: nvim-neoclip.lua
time([[Config for nvim-neoclip.lua]], true)
try_loadstring("\27LJ\2\n�\1\0\0\6\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\t\0005\4\5\0005\5\4\0=\5\6\0045\5\a\0=\5\b\4=\4\n\3=\3\v\2B\0\2\1K\0\1\0\tkeys\14telescope\1\0\0\6n\1\0\3\17paste_behind\6P\npaste\t<CR>\vselect\6p\6i\1\0\0\1\0\3\17paste_behind\n<c-k>\npaste\t<CR>\vselect\n<c-p>\1\0\1\30enable_persistent_history\2\nsetup\fneoclip\frequire\0", "config", "nvim-neoclip.lua")
time([[Config for nvim-neoclip.lua]], false)
-- Config for: nvim-notify
time([[Config for nvim-notify]], true)
try_loadstring("\27LJ\2\n�\2\0\0\5\0\21\0(6\0\0\0009\0\1\0009\0\2\0\15\0\0\0X\1\1�K\0\1\0006\0\3\0'\2\4\0B\0\2\0029\0\5\0005\2\6\0005\3\v\0006\4\a\0009\4\b\0049\4\t\0049\4\n\4=\4\f\0036\4\a\0009\4\b\0049\4\t\0049\4\r\4=\4\14\0036\4\a\0009\4\b\0049\4\t\0049\4\15\4=\4\16\0036\4\a\0009\4\b\0049\4\t\0049\4\17\4=\4\18\0036\4\a\0009\4\b\0049\4\t\0049\4\19\4=\4\20\3=\3\t\2B\0\2\1K\0\1\0\nTRACE\ntrace\nDEBUG\ndebug\tINFO\tinfo\tWARN\twarn\nERROR\1\0\0\nerror\nicons\nstyle\alk\1\0\2\ftimeout\3�\15\vstages\vstatic\nsetup\vnotify\frequire\27packer_compiled_loaded\6g\bvim\0", "config", "nvim-notify")
time([[Config for nvim-notify]], false)
-- Config for: octo.nvim
time([[Config for octo.nvim]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tocto\frequire\0", "config", "octo.nvim")
time([[Config for octo.nvim]], false)
-- Config for: nvim-pqf.git
time([[Config for nvim-pqf.git]], true)
try_loadstring("\27LJ\2\n1\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\bpqf\frequire\0", "config", "nvim-pqf.git")
time([[Config for nvim-pqf.git]], false)
-- Config for: neoscroll.nvim
time([[Config for neoscroll.nvim]], true)
try_loadstring("\27LJ\2\nS\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\24use_local_scrolloff\2\nsetup\14neoscroll\frequire\0", "config", "neoscroll.nvim")
time([[Config for neoscroll.nvim]], false)
-- Config for: vim-cool
time([[Config for vim-cool]], true)
try_loadstring("\27LJ\2\n2\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\21CoolTotalMatches\6g\bvim\0", "config", "vim-cool")
time([[Config for vim-cool]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
try_loadstring("\27LJ\2\nt\0\0\3\0\6\0\r6\0\0\0009\0\1\0009\0\2\0\15\0\0\0X\1\1�K\0\1\0006\0\3\0'\2\4\0B\0\2\0029\0\5\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18todo-comments\frequire\27packer_compiled_loaded\6g\bvim\0", "config", "todo-comments.nvim")
time([[Config for todo-comments.nvim]], false)
-- Config for: nvim-regexplainer
time([[Config for nvim-regexplainer]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17regexplainer\frequire\0", "config", "nvim-regexplainer")
time([[Config for nvim-regexplainer]], false)
-- Config for: headlines.nvim
time([[Config for headlines.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14headlines\frequire\0", "config", "headlines.nvim")
time([[Config for headlines.nvim]], false)
-- Config for: lsp_signature.nvim
time([[Config for lsp_signature.nvim]], true)
try_loadstring("\27LJ\2\n�\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\1K\0\1\0\17handler_opts\1\0\1\vborder\frounded\1\0\4\21auto_close_after\3\15\16hint_enable\1\tbind\2\ffix_pos\1\nsetup\18lsp_signature\frequire\0", "config", "lsp_signature.nvim")
time([[Config for lsp_signature.nvim]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\2\nt\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\21disable_filetype\1\0\0\1\3\0\0\20TelescopePrompt\bvim\nsetup\19nvim-autopairs\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: vim-windowswap
time([[Config for vim-windowswap]], true)
try_loadstring("\27LJ\2\n5\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\0\0=\1\2\0K\0\1\0\24windowswap_map_keys\6g\bvim\0", "config", "vim-windowswap")
time([[Config for vim-windowswap]], false)
-- Config for: nvim-gomove
time([[Config for nvim-gomove]], true)
try_loadstring("\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\vgomove\frequire\0", "config", "nvim-gomove")
time([[Config for nvim-gomove]], false)
-- Config for: conflict-marker.vim
time([[Config for conflict-marker.vim]], true)
try_loadstring("\27LJ\2\n�\1\0\0\2\0\b\0\r6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0'\1\a\0=\1\6\0K\0\1\0\17^>>>>>>> .*$\24conflict_marker_end\17^<<<<<<< .*$\26conflict_marker_begin\5$conflict_marker_highlight_group\6g\bvim\0", "config", "conflict-marker.vim")
time([[Config for conflict-marker.vim]], false)
-- Config for: close-buffers.nvim
time([[Config for close-buffers.nvim]], true)
try_loadstring("\27LJ\2\n�\1\0\1\v\0\5\0\0176\1\0\0009\1\1\0019\1\2\1B\1\1\0026\2\3\0\18\4\0\0B\2\2\4X\5\6�6\a\0\0009\a\1\a9\a\4\a\18\t\6\0\18\n\1\0B\a\3\1E\5\3\3R\5�K\0\1\0\21nvim_win_set_buf\vipairs\25nvim_get_current_buf\bapi\bvim�\1\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\20next_buffer_cmd\0\27preserve_window_layout\1\0\0\1\3\0\0\tthis\rnameless\nsetup\18close_buffers\frequire\0", "config", "close-buffers.nvim")
time([[Config for close-buffers.nvim]], false)
-- Config for: neogen
time([[Config for neogen]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vneogen\frequire\0", "config", "neogen")
time([[Config for neogen]], false)
-- Conditional loads
time([[Conditional loading of github-notifications.nvim]], true)
  require("packer.load")({"github-notifications.nvim"}, {}, _G.packer_plugins)
time([[Conditional loading of github-notifications.nvim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd nvim-cmp ]]
vim.cmd [[ packadd cmp-path ]]
vim.cmd [[ packadd cmp-emoji ]]
vim.cmd [[ packadd cmp-tabnine ]]
vim.cmd [[ packadd cmp-spell ]]
vim.cmd [[ packadd cmp-nvim-ultisnips ]]
vim.cmd [[ packadd cmp-nvim-lua ]]
vim.cmd [[ packadd cmp-nvim-lsp ]]
vim.cmd [[ packadd cmp-cmdline ]]
vim.cmd [[ packadd cmp-buffer ]]
vim.cmd [[ packadd nvim-lspconfig ]]
vim.cmd [[ packadd dim.lua ]]

-- Config for: dim.lua
try_loadstring("\27LJ\2\n1\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\bdim\frequire\0", "config", "dim.lua")

vim.cmd [[ packadd telescope.nvim ]]
vim.cmd [[ packadd telescope-harpoon.nvim ]]

-- Config for: telescope-harpoon.nvim
try_loadstring("\27LJ\2\nL\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\fharpoon\19load_extension\14telescope\frequire\0", "config", "telescope-harpoon.nvim")

vim.cmd [[ packadd telescope-windowizer.nvim ]]

-- Config for: telescope-windowizer.nvim
try_loadstring("\27LJ\2\nO\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\15windowizer\19load_extension\14telescope\frequire\0", "config", "telescope-windowizer.nvim")

vim.cmd [[ packadd telescope-ui-select.nvim ]]

-- Config for: telescope-ui-select.nvim
try_loadstring("\27LJ\2\nN\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\14ui-select\19load_extension\14telescope\frequire\0", "config", "telescope-ui-select.nvim")

vim.cmd [[ packadd project.nvim ]]

-- Config for: project.nvim
try_loadstring("\27LJ\2\n�\1\0\0\3\0\a\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\0016\0\0\0'\2\4\0B\0\2\0029\0\5\0005\2\6\0B\0\2\1K\0\1\0\1\0\1\16show_hidden\2\nsetup\17project_nvim\rprojects\19load_extension\14telescope\frequire\0", "config", "project.nvim")

vim.cmd [[ packadd telescope-fzf-native.nvim ]]

-- Config for: telescope-fzf-native.nvim
try_loadstring("\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bfzf\19load_extension\14telescope\frequire\0", "config", "telescope-fzf-native.nvim")

vim.cmd [[ packadd telescope-tmuxinator.nvim ]]

-- Config for: telescope-tmuxinator.nvim
try_loadstring("\27LJ\2\nO\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\15tmuxinator\19load_extension\14telescope\frequire\0", "config", "telescope-tmuxinator.nvim")

vim.cmd [[ packadd telescope-frecency.nvim ]]

-- Config for: telescope-frecency.nvim
try_loadstring("\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0", "config", "telescope-frecency.nvim")

vim.cmd [[ packadd telescope-dap.nvim ]]

-- Config for: telescope-dap.nvim
try_loadstring("\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bdap\19load_extension\14telescope\frequire\0", "config", "telescope-dap.nvim")

vim.cmd [[ packadd telescope-file-browser.nvim ]]

-- Config for: telescope-file-browser.nvim
try_loadstring("\27LJ\2\nQ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\17file_browser\19load_extension\14telescope\frequire\0", "config", "telescope-file-browser.nvim")

vim.cmd [[ packadd telescope-emoji.nvim ]]

-- Config for: telescope-emoji.nvim
try_loadstring("\27LJ\2\nJ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\nemoji\19load_extension\14telescope\frequire\0", "config", "telescope-emoji.nvim")

vim.cmd [[ packadd telescope-arglist.nvim ]]

-- Config for: telescope-arglist.nvim
try_loadstring("\27LJ\2\nL\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\farglist\19load_extension\14telescope\frequire\0", "config", "telescope-arglist.nvim")

vim.cmd [[ packadd telescope-tmux.nvim ]]

-- Config for: telescope-tmux.nvim
try_loadstring("\27LJ\2\nI\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\ttmux\19load_extension\14telescope\frequire\0", "config", "telescope-tmux.nvim")

vim.cmd [[ packadd telescope-smart-history.nvim ]]

-- Config for: telescope-smart-history.nvim
try_loadstring("\27LJ\2\nR\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\18smart_history\19load_extension\14telescope\frequire\0", "config", "telescope-smart-history.nvim")

vim.cmd [[ packadd telescope-repo.nvim ]]

-- Config for: telescope-repo.nvim
try_loadstring("\27LJ\2\nI\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\trepo\19load_extension\14telescope\frequire\0", "config", "telescope-repo.nvim")

vim.cmd [[ packadd telescope-project.nvim ]]

-- Config for: telescope-project.nvim
try_loadstring("\27LJ\2\nL\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\fproject\19load_extension\14telescope\frequire\0", "config", "telescope-project.nvim")

vim.cmd [[ packadd telescope-openbrowser.nvim ]]

-- Config for: telescope-openbrowser.nvim
try_loadstring("\27LJ\2\nP\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\16openbrowser\19load_extension\14telescope\frequire\0", "config", "telescope-openbrowser.nvim")

vim.cmd [[ packadd telescope-media-files.nvim ]]

-- Config for: telescope-media-files.nvim
try_loadstring("\27LJ\2\nP\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\16media_files\19load_extension\14telescope\frequire\0", "config", "telescope-media-files.nvim")

vim.cmd [[ packadd telescope-live-grep-raw.nvim ]]
vim.cmd [[ packadd telescope-hop.nvim ]]

-- Config for: telescope-hop.nvim
try_loadstring("\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bhop\19load_extension\14telescope\frequire\0", "config", "telescope-hop.nvim")

vim.cmd [[ packadd nvim-treesitter ]]
vim.cmd [[ packadd nvim-ts-context-commentstring ]]
vim.cmd [[ packadd nvim-treesitter-textsubjects ]]
vim.cmd [[ packadd nvim-treesitter-textobjects ]]
vim.cmd [[ packadd nvim-treesitter-refactor ]]
vim.cmd [[ packadd nvim-ts-rainbow ]]
time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file UndotreeToggle lua require("packer.load")({'undotree'}, { cmd = "UndotreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Time lua require("packer.load")({'vim-scriptease'}, { cmd = "Time", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Tabularize lua require("packer.load")({'tabular'}, { cmd = "Tabularize", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'startuptime.vim'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Cheat lua require("packer.load")({'nvim-cheat.sh'}, { cmd = "Cheat", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CheatWithouComments lua require("packer.load")({'nvim-cheat.sh'}, { cmd = "CheatWithouComments", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CheatList lua require("packer.load")({'nvim-cheat.sh'}, { cmd = "CheatList", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CheatListWithoutComments lua require("packer.load")({'nvim-cheat.sh'}, { cmd = "CheatListWithoutComments", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Messages lua require("packer.load")({'vim-scriptease'}, { cmd = "Messages", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Verbose lua require("packer.load")({'vim-scriptease'}, { cmd = "Verbose", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CarbonNowSh lua require("packer.load")({'vim-carbon-now-sh'}, { cmd = "CarbonNowSh", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SymbolsOutlineClose lua require("packer.load")({'symbols-outline.nvim'}, { cmd = "SymbolsOutlineClose", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Dispatch lua require("packer.load")({'vim-dispatch'}, { cmd = "Dispatch", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Make lua require("packer.load")({'vim-dispatch'}, { cmd = "Make", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Focus lua require("packer.load")({'vim-dispatch'}, { cmd = "Focus", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Start lua require("packer.load")({'vim-dispatch'}, { cmd = "Start", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SymbolsOutlineOpen lua require("packer.load")({'symbols-outline.nvim'}, { cmd = "SymbolsOutlineOpen", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SymbolsOutline lua require("packer.load")({'symbols-outline.nvim'}, { cmd = "SymbolsOutline", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSPlaygroundToggle lua require("packer.load")({'playground'}, { cmd = "TSPlaygroundToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim', 'glow.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au InsertCharPre * ++once lua require("packer.load")({'nvim-hclipboard'}, { event = "InsertCharPre *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles(1) end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
