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
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0" },
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
  catppuccin = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/catppuccin",
    url = "https://github.com/catppuccin/nvim"
  },
  ["close-buffers.nvim"] = {
    config = { "\27LJ\2\n±\1\0\1\v\0\b\0\0236\1\0\0'\3\1\0B\1\2\0029\1\2\1)\3\1\0B\1\2\0016\1\3\0009\1\4\0019\1\5\1B\1\1\0026\2\6\0\18\4\0\0B\2\2\4X\5\6Ä6\a\3\0009\a\4\a9\a\a\a\18\t\6\0\18\n\1\0B\a\3\1E\5\3\3R\5¯K\0\1\0\21nvim_win_set_buf\vipairs\25nvim_get_current_buf\bapi\bvim\ncycle\15bufferline\frequireå\1\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\20next_buffer_cmd\0\27preserve_window_layout\1\0\0\1\3\0\0\tthis\rnameless\nsetup\18close_buffers\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/close-buffers.nvim",
    url = "https://github.com/kazhala/close-buffers.nvim"
  },
  ["cobalt2.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/cobalt2.nvim",
    url = "https://github.com/lalitmee/cobalt2.nvim"
  },
  ["coc-neco"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/coc-neco",
    url = "https://github.com/neoclide/coc-neco"
  },
  ["coc.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/coc.nvim",
    url = "https://github.com/neoclide/coc.nvim"
  },
  ["colorbuddy.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/colorbuddy.nvim",
    url = "https://github.com/tjdevries/colorbuddy.nvim"
  },
  ["complextras.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/complextras.nvim",
    url = "https://github.com/tjdevries/complextras.nvim"
  },
  ["conflict-marker.vim"] = {
    config = { "\27LJ\2\n¶\1\0\0\2\0\b\0\r6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0'\1\a\0=\1\6\0K\0\1\0\17^>>>>>>> .*$\24conflict_marker_end\17^<<<<<<< .*$\26conflict_marker_begin\5$conflict_marker_highlight_group\6g\bvim\0" },
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
  ["diffview.nvim"] = {
    config = { "\27LJ\2\n≠\1\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\b\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\3=\3\t\2B\0\2\1K\0\1\0\17key_bindings\1\0\0\tview\1\0\1\6q\27<Cmd>DiffviewClose<CR>\15file_panel\1\0\0\1\0\1\6q\27<Cmd>DiffviewClose<CR>\nsetup\rdiffview\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
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
  ["emmet-vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/emmet-vim",
    url = "https://github.com/mattn/emmet-vim"
  },
  ["formatter.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/formatter.nvim",
    url = "https://github.com/mhartington/formatter.nvim"
  },
  fzf = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/fzf",
    url = "https://github.com/junegunn/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["git-worktree.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/git-worktree.nvim",
    url = "https://github.com/ThePrimeagen/git-worktree.nvim"
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
    commands = { "Glow" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/glow.nvim",
    url = "https://github.com/npxbr/glow.nvim"
  },
  ["go.vim"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/go.vim",
    url = "https://github.com/fannheyward/go.vim"
  },
  ["gonvim-fuzzy"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/gonvim-fuzzy",
    url = "https://github.com/akiyosi/gonvim-fuzzy"
  },
  ["gruvbox-baby"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/gruvbox-baby",
    url = "https://github.com/luisiacc/gruvbox-baby"
  },
  ["gruvbuddy.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/gruvbuddy.nvim",
    url = "https://github.com/tjdevries/gruvbuddy.nvim"
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
  ["kanagawa.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/kanagawa.nvim",
    url = "https://github.com/rebelot/kanagawa.nvim"
  },
  ["lir-git-status.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/lir-git-status.nvim",
    url = "https://github.com/tamago324/lir-git-status.nvim"
  },
  ["lir.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/lir.nvim",
    url = "https://github.com/tamago324/lir.nvim"
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
  ["material.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/material.nvim",
    url = "https://github.com/marko-cerovac/material.nvim"
  },
  ["neco-vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/neco-vim",
    url = "https://github.com/Shougo/neco-vim"
  },
  neogit = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/neogit",
    url = "https://github.com/TimUntersberger/neogit"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\nS\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\24use_local_scrolloff\2\nsetup\14neoscroll\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/neoscroll.nvim",
    url = "https://github.com/karb94/neoscroll.nvim"
  },
  ["nightfox.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nightfox.nvim",
    url = "https://github.com/EdenEast/nightfox.nvim"
  },
  ["nlua.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nlua.nvim",
    url = "https://github.com/tjdevries/nlua.nvim"
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
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-hlslens"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-hlslens",
    url = "https://github.com/kevinhwang91/nvim-hlslens"
  },
  ["nvim-neoclip.lua"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fneoclip\frequire\0" },
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
    config = { "\27LJ\2\n∂\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\1K\0\1\0\nicons\1\0\5\nERROR\tÔÅó \tWARN\tÔÅ± \nTRACE\b‚úé\nDEBUG\bÔÜà\tINFO\tÔÅö \1\0\3\22background_colour\18BufferCurrent\ftimeout\3–\15\vstages\tfade\nsetup\vnotify\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-palenight.lua"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-palenight.lua",
    url = "https://github.com/kyazdani42/nvim-palenight.lua"
  },
  ["nvim-pqf.git"] = {
    config = { "\27LJ\2\n1\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\bpqf\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-pqf.git",
    url = "https://gitlab.com/yorickpeterse/nvim-pqf"
  },
  ["nvim-spectre"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-spectre",
    url = "https://github.com/windwp/nvim-spectre"
  },
  ["nvim-terminal"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18nvim-terminal\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-terminal",
    url = "https://github.com/s1n7ax/nvim-terminal"
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
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-treesitter-refactor",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-refactor"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-treesitter-textsubjects"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textsubjects",
    url = "https://github.com/RRethy/nvim-treesitter-textsubjects"
  },
  ["nvim-ts-context-commentstring"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-ts-context-commentstring",
    url = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring"
  },
  ["nvim-ts-hint-textobject"] = {
    config = { "\27LJ\2\nﬂ\1\0\0\4\0\v\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\1\4\0=\1\3\0006\0\5\0009\0\6\0'\2\a\0'\3\b\0B\0\3\0016\0\5\0009\0\t\0'\2\a\0'\3\n\0B\0\3\1K\0\1\0%:lua require('tsht').nodes()<CR>\rvnoremap*:<C-U>lua require('tsht').nodes()<CR>\6m\tomap\rlk_utils\1\n\0\0\6h\6j\6f\6d\6n\6v\6s\6l\6a\14hint_keys\vconfig\ttsht\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-ts-hint-textobject",
    url = "https://github.com/mfussenegger/nvim-ts-hint-textobject"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow",
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
  ["onenord.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/onenord.nvim",
    url = "https://github.com/rmehri01/onenord.nvim"
  },
  ["open-browser.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/open-browser.vim",
    url = "https://github.com/tyru/open-browser.vim"
  },
  ["org-bullets.nvim"] = {
    config = { "\27LJ\2\nd\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\fsymbols\1\0\0\1\5\0\0\b‚óâ\b‚óã\b‚ú∏\b‚úø\nsetup\16org-bullets\frequire\0" },
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
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/packer.nvim",
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
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ["pounce.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/pounce.nvim",
    url = "https://github.com/rlane/pounce.nvim"
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
  ["scratch.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/scratch.nvim",
    url = "https://github.com/shift-d/scratch.nvim"
  },
  ["sidebar.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17sidebar-nvim\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/sidebar.nvim",
    url = "https://github.com/sidebar-nvim/sidebar.nvim"
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
  tabular = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/tabular",
    url = "https://github.com/godlygeek/tabular"
  },
  ["tagalong.vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/tagalong.vim",
    url = "https://github.com/AndrewRadev/tagalong.vim"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/targets.vim",
    url = "https://github.com/wellle/targets.vim"
  },
  ["telescope-arecibo.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-arecibo.nvim",
    url = "https://github.com/nvim-telescope/telescope-arecibo.nvim"
  },
  ["telescope-bookmarks.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-bookmarks.nvim",
    url = "https://github.com/dhruvmanila/telescope-bookmarks.nvim"
  },
  ["telescope-coc.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-coc.nvim",
    url = "https://github.com/fannheyward/telescope-coc.nvim"
  },
  ["telescope-dap.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-dap.nvim",
    url = "https://github.com/nvim-telescope/telescope-dap.nvim"
  },
  ["telescope-emoji.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-emoji.nvim",
    url = "https://github.com/xiyaowong/telescope-emoji.nvim"
  },
  ["telescope-file-browser.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-file-browser.nvim",
    url = "https://github.com/nvim-telescope/telescope-file-browser.nvim"
  },
  ["telescope-frecency.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-frecency.nvim",
    url = "https://github.com/nvim-telescope/telescope-frecency.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-harpoon.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-harpoon.nvim",
    url = "https://github.com/brandoncc/telescope-harpoon.nvim"
  },
  ["telescope-openbrowser.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-openbrowser.nvim",
    url = "https://github.com/tamago324/telescope-openbrowser.nvim"
  },
  ["telescope-packer.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-packer.nvim",
    url = "https://github.com/nvim-telescope/telescope-packer.nvim"
  },
  ["telescope-project.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-project.nvim",
    url = "https://github.com/nvim-telescope/telescope-project.nvim"
  },
  ["telescope-smart-history.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-smart-history.nvim",
    url = "https://github.com/nvim-telescope/telescope-smart-history.nvim"
  },
  ["telescope-ui-select.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-ui-select.nvim",
    url = "https://github.com/nvim-telescope/telescope-ui-select.nvim"
  },
  ["telescope-ultisnips.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-ultisnips.nvim",
    url = "https://github.com/fhill2/telescope-ultisnips.nvim"
  },
  ["telescope-zoxide"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-zoxide",
    url = "https://github.com/jvgrootveld/telescope-zoxide"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["tidy.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/tidy.nvim",
    url = "https://github.com/McAuleyPenney/tidy.nvim"
  },
  ["tokyonight.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/tokyonight.nvim",
    url = "https://github.com/folke/tokyonight.nvim"
  },
  ["train.nvim"] = {
    commands = { "TrainUpDown", "TrainWord", "TrainTextObj" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/train.nvim",
    url = "https://github.com/tjdevries/train.nvim"
  },
  ultisnips = {
    config = { "\27LJ\2\nC\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\0\0=\1\2\0K\0\1\0&UltiSnipsRemoveSelectModeMappings\6g\bvim\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/ultisnips",
    url = "https://github.com/SirVer/ultisnips"
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
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-inyoface"] = {
    keys = { { "", "<Plug>(InYoFace_Toggle)" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/vim-inyoface",
    url = "https://github.com/tjdevries/vim-inyoface"
  },
  ["vim-jsx-improve"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-jsx-improve",
    url = "https://github.com/neoclide/vim-jsx-improve"
  },
  ["vim-man"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-man",
    url = "https://github.com/vim-utils/vim-man"
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
  ["vim-move"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-move",
    url = "https://github.com/matze/vim-move"
  },
  ["vim-mundo"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-mundo",
    url = "https://github.com/simnalamburt/vim-mundo"
  },
  ["vim-pseudocl"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-pseudocl",
    url = "https://github.com/junegunn/vim-pseudocl"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-rooter"] = {
    config = { "\27LJ\2\nZ\0\0\2\0\4\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0K\0\1\0\25rooter_resolve_links\24rooter_silent_chdir\6g\bvim\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-rooter",
    url = "https://github.com/airblade/vim-rooter"
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
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-windowswap",
    url = "https://github.com/wesQ3/vim-windowswap"
  },
  ["vista.vim"] = {
    commands = { "Vista" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/vista.vim",
    url = "https://github.com/liuchengxu/vista.vim"
  },
  ["vscode.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vscode.nvim",
    url = "https://github.com/Mofiqul/vscode.nvim"
  },
  ["which-key.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: diffview.nvim
time([[Config for diffview.nvim]], true)
try_loadstring("\27LJ\2\n≠\1\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\b\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\3=\3\t\2B\0\2\1K\0\1\0\17key_bindings\1\0\0\tview\1\0\1\6q\27<Cmd>DiffviewClose<CR>\15file_panel\1\0\0\1\0\1\6q\27<Cmd>DiffviewClose<CR>\nsetup\rdiffview\frequire\0", "config", "diffview.nvim")
time([[Config for diffview.nvim]], false)
-- Config for: octo.nvim
time([[Config for octo.nvim]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tocto\frequire\0", "config", "octo.nvim")
time([[Config for octo.nvim]], false)
-- Config for: org-bullets.nvim
time([[Config for org-bullets.nvim]], true)
try_loadstring("\27LJ\2\nd\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\fsymbols\1\0\0\1\5\0\0\b‚óâ\b‚óã\b‚ú∏\b‚úø\nsetup\16org-bullets\frequire\0", "config", "org-bullets.nvim")
time([[Config for org-bullets.nvim]], false)
-- Config for: numb.nvim
time([[Config for numb.nvim]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tnumb\frequire\0", "config", "numb.nvim")
time([[Config for numb.nvim]], false)
-- Config for: close-buffers.nvim
time([[Config for close-buffers.nvim]], true)
try_loadstring("\27LJ\2\n±\1\0\1\v\0\b\0\0236\1\0\0'\3\1\0B\1\2\0029\1\2\1)\3\1\0B\1\2\0016\1\3\0009\1\4\0019\1\5\1B\1\1\0026\2\6\0\18\4\0\0B\2\2\4X\5\6Ä6\a\3\0009\a\4\a9\a\a\a\18\t\6\0\18\n\1\0B\a\3\1E\5\3\3R\5¯K\0\1\0\21nvim_win_set_buf\vipairs\25nvim_get_current_buf\bapi\bvim\ncycle\15bufferline\frequireå\1\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\20next_buffer_cmd\0\27preserve_window_layout\1\0\0\1\3\0\0\tthis\rnameless\nsetup\18close_buffers\frequire\0", "config", "close-buffers.nvim")
time([[Config for close-buffers.nvim]], false)
-- Config for: nvim-terminal
time([[Config for nvim-terminal]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18nvim-terminal\frequire\0", "config", "nvim-terminal")
time([[Config for nvim-terminal]], false)
-- Config for: vim-cool
time([[Config for vim-cool]], true)
try_loadstring("\27LJ\2\n2\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\21CoolTotalMatches\6g\bvim\0", "config", "vim-cool")
time([[Config for vim-cool]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\2\nt\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\21disable_filetype\1\0\0\1\3\0\0\20TelescopePrompt\bvim\nsetup\19nvim-autopairs\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: ultisnips
time([[Config for ultisnips]], true)
try_loadstring("\27LJ\2\nC\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\0\0=\1\2\0K\0\1\0&UltiSnipsRemoveSelectModeMappings\6g\bvim\0", "config", "ultisnips")
time([[Config for ultisnips]], false)
-- Config for: Navigator.nvim
time([[Config for Navigator.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14Navigator\frequire\0", "config", "Navigator.nvim")
time([[Config for Navigator.nvim]], false)
-- Config for: nvim-neoclip.lua
time([[Config for nvim-neoclip.lua]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fneoclip\frequire\0", "config", "nvim-neoclip.lua")
time([[Config for nvim-neoclip.lua]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
-- Config for: vim-rooter
time([[Config for vim-rooter]], true)
try_loadstring("\27LJ\2\nZ\0\0\2\0\4\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0K\0\1\0\25rooter_resolve_links\24rooter_silent_chdir\6g\bvim\0", "config", "vim-rooter")
time([[Config for vim-rooter]], false)
-- Config for: nvim-notify
time([[Config for nvim-notify]], true)
try_loadstring("\27LJ\2\n∂\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\1K\0\1\0\nicons\1\0\5\nERROR\tÔÅó \tWARN\tÔÅ± \nTRACE\b‚úé\nDEBUG\bÔÜà\tINFO\tÔÅö \1\0\3\22background_colour\18BufferCurrent\ftimeout\3–\15\vstages\tfade\nsetup\vnotify\frequire\0", "config", "nvim-notify")
time([[Config for nvim-notify]], false)
-- Config for: nvim-pqf.git
time([[Config for nvim-pqf.git]], true)
try_loadstring("\27LJ\2\n1\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\bpqf\frequire\0", "config", "nvim-pqf.git")
time([[Config for nvim-pqf.git]], false)
-- Config for: neoscroll.nvim
time([[Config for neoscroll.nvim]], true)
try_loadstring("\27LJ\2\nS\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\24use_local_scrolloff\2\nsetup\14neoscroll\frequire\0", "config", "neoscroll.nvim")
time([[Config for neoscroll.nvim]], false)
-- Config for: conflict-marker.vim
time([[Config for conflict-marker.vim]], true)
try_loadstring("\27LJ\2\n¶\1\0\0\2\0\b\0\r6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0'\1\a\0=\1\6\0K\0\1\0\17^>>>>>>> .*$\24conflict_marker_end\17^<<<<<<< .*$\26conflict_marker_begin\5$conflict_marker_highlight_group\6g\bvim\0", "config", "conflict-marker.vim")
time([[Config for conflict-marker.vim]], false)
-- Config for: nvim-ts-hint-textobject
time([[Config for nvim-ts-hint-textobject]], true)
try_loadstring("\27LJ\2\nﬂ\1\0\0\4\0\v\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\1\4\0=\1\3\0006\0\5\0009\0\6\0'\2\a\0'\3\b\0B\0\3\0016\0\5\0009\0\t\0'\2\a\0'\3\n\0B\0\3\1K\0\1\0%:lua require('tsht').nodes()<CR>\rvnoremap*:<C-U>lua require('tsht').nodes()<CR>\6m\tomap\rlk_utils\1\n\0\0\6h\6j\6f\6d\6n\6v\6s\6l\6a\14hint_keys\vconfig\ttsht\frequire\0", "config", "nvim-ts-hint-textobject")
time([[Config for nvim-ts-hint-textobject]], false)
-- Config for: sidebar.nvim
time([[Config for sidebar.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17sidebar-nvim\frequire\0", "config", "sidebar.nvim")
time([[Config for sidebar.nvim]], false)
-- Config for: vim-autoswap
time([[Config for vim-autoswap]], true)
try_loadstring("\27LJ\2\n6\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\25autoswap_detect_tmux\6g\bvim\0", "config", "vim-autoswap")
time([[Config for vim-autoswap]], false)
-- Config for: paperplanes.nvim
time([[Config for paperplanes.nvim]], true)
try_loadstring("\27LJ\2\n_\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\rprovider\15dpaste.org\rregister\6+\nsetup\16paperplanes\frequire\0", "config", "paperplanes.nvim")
time([[Config for paperplanes.nvim]], false)
-- Config for: package-info.nvim
time([[Config for package-info.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17package-info\frequire\0", "config", "package-info.nvim")
time([[Config for package-info.nvim]], false)
-- Config for: headlines.nvim
time([[Config for headlines.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14headlines\frequire\0", "config", "headlines.nvim")
time([[Config for headlines.nvim]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Dispatch lua require("packer.load")({'vim-dispatch'}, { cmd = "Dispatch", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Make lua require("packer.load")({'vim-dispatch'}, { cmd = "Make", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Glow lua require("packer.load")({'glow.nvim'}, { cmd = "Glow", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Start lua require("packer.load")({'vim-dispatch'}, { cmd = "Start", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSPlaygroundToggle lua require("packer.load")({'playground'}, { cmd = "TSPlaygroundToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Cheat lua require("packer.load")({'nvim-cheat.sh'}, { cmd = "Cheat", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CheatWithouComments lua require("packer.load")({'nvim-cheat.sh'}, { cmd = "CheatWithouComments", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CheatList lua require("packer.load")({'nvim-cheat.sh'}, { cmd = "CheatList", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CheatListWithoutComments lua require("packer.load")({'nvim-cheat.sh'}, { cmd = "CheatListWithoutComments", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Messages lua require("packer.load")({'vim-scriptease'}, { cmd = "Messages", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Verbose lua require("packer.load")({'vim-scriptease'}, { cmd = "Verbose", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Time lua require("packer.load")({'vim-scriptease'}, { cmd = "Time", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TrainUpDown lua require("packer.load")({'train.nvim'}, { cmd = "TrainUpDown", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TrainWord lua require("packer.load")({'train.nvim'}, { cmd = "TrainWord", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TrainTextObj lua require("packer.load")({'train.nvim'}, { cmd = "TrainTextObj", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Vista lua require("packer.load")({'vista.vim'}, { cmd = "Vista", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Focus lua require("packer.load")({'vim-dispatch'}, { cmd = "Focus", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> <Plug>(InYoFace_Toggle) <cmd>lua require("packer.load")({'vim-inyoface'}, { keys = "<lt>Plug>(InYoFace_Toggle)", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType xml ++once lua require("packer.load")({'tagalong.vim'}, { ft = "xml" }, _G.packer_plugins)]]
vim.cmd [[au FileType go ++once lua require("packer.load")({'go.vim'}, { ft = "go" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType html ++once lua require("packer.load")({'tagalong.vim'}, { ft = "html" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles(1) end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
