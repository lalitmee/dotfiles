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
  local success, result = pcall(loadstring(s))
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
  FastFold = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/FastFold"
  },
  ["Navigator.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14Navigator\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/Navigator.nvim"
  },
  ["any-jump.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/any-jump.vim"
  },
  ["close-buffers.nvim"] = {
    config = { "\27LJ\2\n±\1\0\1\v\0\b\0\0236\1\0\0'\3\1\0B\1\2\0029\1\2\1)\3\1\0B\1\2\0016\1\3\0009\1\4\0019\1\5\1B\1\1\0026\2\6\0\18\4\0\0B\2\2\4X\5\6€6\a\3\0009\a\4\a9\a\a\a\18\t\6\0\18\n\1\0B\a\3\1E\5\3\3R\5øK\0\1\0\21nvim_win_set_buf\vipairs\25nvim_get_current_buf\bapi\bvim\ncycle\15bufferline\frequireŒ\1\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\20next_buffer_cmd\0\27preserve_window_layout\1\0\0\1\3\0\0\tthis\rnameless\nsetup\18close_buffers\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/close-buffers.nvim"
  },
  ["coc-neco"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/coc-neco"
  },
  ["coc.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/coc.nvim"
  },
  ["colorbuddy.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/colorbuddy.nvim"
  },
  ["complextras.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/complextras.nvim"
  },
  ["conflict-marker.vim"] = {
    config = { "\27LJ\2\n¦\1\0\0\2\0\b\0\r6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0'\1\a\0=\1\6\0K\0\1\0\17^>>>>>>> .*$\24conflict_marker_end\17^<<<<<<< .*$\26conflict_marker_begin\5$conflict_marker_highlight_group\6g\bvim\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/conflict-marker.vim"
  },
  ["crease.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/crease.vim"
  },
  ["diffview.nvim"] = {
    config = { "\27LJ\2\n­\1\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\b\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\3=\3\t\2B\0\2\1K\0\1\0\17key_bindings\1\0\0\tview\1\0\1\6q\27<Cmd>DiffviewClose<CR>\15file_panel\1\0\0\1\0\1\6q\27<Cmd>DiffviewClose<CR>\nsetup\rdiffview\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/diffview.nvim"
  },
  ["doom-one.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/doom-one.nvim"
  },
  ["emmet-vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/emmet-vim"
  },
  ["formatter.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/formatter.nvim"
  },
  fzf = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/fzf.vim"
  },
  ["git-worktree.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/git-worktree.nvim"
  },
  ["github-nvim-theme"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/github-nvim-theme"
  },
  ["gitlinker.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/gitlinker.nvim"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["glow.nvim"] = {
    commands = { "Glow" },
    loaded = false,
    needs_bufread = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/glow.nvim"
  },
  ["gruvbuddy.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/gruvbuddy.nvim"
  },
  gruvqueen = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/gruvqueen"
  },
  ["gundo.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/gundo.vim"
  },
  harpoon = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/harpoon"
  },
  ["hop.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/hop.nvim"
  },
  ["indent-blankline.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim"
  },
  ["iswap.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/iswap.nvim"
  },
  ["lir-git-status.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/lir-git-status.nvim"
  },
  ["lir.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/lir.nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/lualine.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim"
  },
  ["material.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/material.nvim"
  },
  ["neco-vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/neco-vim"
  },
  neogit = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/neogit"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\nS\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\24use_local_scrolloff\2\nsetup\14neoscroll\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/neoscroll.nvim"
  },
  ["nlua.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nlua.nvim"
  },
  ["numb.nvim"] = {
    config = { "\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tnumb\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/numb.nvim"
  },
  ["nvim-autopairs"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
  },
  ["nvim-bqf"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-bqf"
  },
  ["nvim-bufferline.lua"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-bufferline.lua"
  },
  ["nvim-cheat.sh"] = {
    commands = { "Cheat", "CheatWithouComments", "CheatList", "CheatListWithoutComments" },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-cheat.sh"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-dap"
  },
  ["nvim-dap-ui"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-dap-ui"
  },
  ["nvim-hlslens"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-hlslens"
  },
  ["nvim-neoclip.lua"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fneoclip\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-neoclip.lua"
  },
  ["nvim-nonicons"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-nonicons"
  },
  ["nvim-spectre"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-spectre"
  },
  ["nvim-toggleterm.lua"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-toggleterm.lua"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-refactor"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-treesitter-refactor"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects"
  },
  ["nvim-treesitter-textsubjects"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textsubjects"
  },
  ["nvim-ts-context-commentstring"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-ts-context-commentstring"
  },
  ["nvim-ts-hint-textobject"] = {
    config = { "\27LJ\2\nÙ\1\0\0\4\0\v\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\1\4\0=\1\3\0006\0\5\0009\0\6\0'\2\a\0'\3\b\0B\0\3\0016\0\5\0009\0\t\0'\2\a\0'\3\n\0B\0\3\1K\0\1\0%:lua require('tsht').nodes()<CR>\rvnoremap*:<C-U>lua require('tsht').nodes()<CR>\6m\tomap\alk\1\n\0\0\6h\6j\6f\6d\6n\6v\6s\6l\6a\14hint_keys\vconfig\ttsht\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-ts-hint-textobject"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["octo.nvim"] = {
    config = { "\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tocto\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/octo.nvim"
  },
  ["onedark.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/onedark.nvim"
  },
  ["open-browser-github.vim"] = {
    commands = { "OpenGithubFile", "OpenGithubProject", "OpenGithubPullReq", "OpenGithubCommit", "OpenGithubIssue" },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/open-browser-github.vim"
  },
  ["open-browser.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/open-browser.vim"
  },
  ["package-info.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17package-info\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/package-info.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["paperplanes.nvim"] = {
    config = { "\27LJ\2\n_\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\rprovider\15dpaste.org\rregister\6+\nsetup\16paperplanes\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/paperplanes.nvim"
  },
  playground = {
    commands = { "TSPlaygroundToggle" },
    loaded = false,
    needs_bufread = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  popfix = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/popfix"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["quick-scope"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/quick-scope"
  },
  ["refactoring.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/refactoring.nvim"
  },
  snap = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/snap"
  },
  ["snippets.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/snippets.nvim"
  },
  ["spaceless.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14spaceless\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/spaceless.nvim"
  },
  ["splitjoin.vim"] = {
    keys = { { "", "gJ" }, { "", "gS" } },
    loaded = false,
    needs_bufread = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/splitjoin.vim"
  },
  ["sql.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/sql.nvim"
  },
  tabular = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/tabular"
  },
  ["tagalong.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/tagalong.vim"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/targets.vim"
  },
  ["telescope-arecibo.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-arecibo.nvim"
  },
  ["telescope-cheat.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-cheat.nvim"
  },
  ["telescope-coc.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-coc.nvim"
  },
  ["telescope-dap.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-dap.nvim"
  },
  ["telescope-emoji.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-emoji.nvim"
  },
  ["telescope-frecency.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-frecency.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim"
  },
  ["telescope-harpoon.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-harpoon.nvim"
  },
  ["telescope-openbrowser.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-openbrowser.nvim"
  },
  ["telescope-project.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-project.nvim"
  },
  ["telescope-ultisnips.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-ultisnips.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18todo-comments\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/todo-comments.nvim"
  },
  ["tokyonight.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/tokyonight.nvim"
  },
  ["train.nvim"] = {
    commands = { "TrainUpDown", "TrainWord", "TrainTextObj" },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/train.nvim"
  },
  ["twilight.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\rtwilight\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/twilight.nvim"
  },
  ultisnips = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/ultisnips"
  },
  ["vim-abolish"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-abolish"
  },
  ["vim-autoswap"] = {
    config = { "\27LJ\2\n6\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\25autoswap_detect_tmux\6g\bvim\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-autoswap"
  },
  ["vim-better-whitespace"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-better-whitespace"
  },
  ["vim-characterize"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-characterize"
  },
  ["vim-code-dark"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-code-dark"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-dispatch"] = {
    commands = { "Dispatch", "Make", "Focus", "Start" },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/vim-dispatch"
  },
  ["vim-dotenv"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-dotenv"
  },
  ["vim-eunuch"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-eunuch"
  },
  ["vim-exchange"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-exchange"
  },
  ["vim-fnr"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-fnr"
  },
  ["vim-inyoface"] = {
    keys = { { "", "<Plug>(InYoFace_Toggle)" } },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/vim-inyoface"
  },
  ["vim-jsx-improve"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-jsx-improve"
  },
  ["vim-matchup"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-matchup"
  },
  ["vim-maximizer"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-maximizer"
  },
  ["vim-move"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-move"
  },
  ["vim-pseudocl"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-pseudocl"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-rooter"] = {
    config = { "\27LJ\2\nZ\0\0\2\0\4\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0K\0\1\0\25rooter_resolve_links\24rooter_silent_chdir\6g\bvim\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-rooter"
  },
  ["vim-scriptease"] = {
    commands = { "Messages", "Verbose", "Time" },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/vim-scriptease"
  },
  ["vim-signature"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-signature"
  },
  ["vim-sleuth"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-sleuth"
  },
  ["vim-snippets"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-snippets"
  },
  ["vim-sort-motion"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-sort-motion"
  },
  ["vim-startify"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-startify"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-unimpaired"
  },
  ["vim-visual-star-search"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-visual-star-search"
  },
  ["vim-wakatime"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-wakatime"
  },
  ["vim-windowswap"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-windowswap"
  },
  ["vista.vim"] = {
    commands = { "Vista" },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/vista.vim"
  },
  ["vscode.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vscode.nvim"
  },
  ["which-key.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: neoscroll.nvim
time([[Config for neoscroll.nvim]], true)
try_loadstring("\27LJ\2\nS\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\24use_local_scrolloff\2\nsetup\14neoscroll\frequire\0", "config", "neoscroll.nvim")
time([[Config for neoscroll.nvim]], false)
-- Config for: vim-rooter
time([[Config for vim-rooter]], true)
try_loadstring("\27LJ\2\nZ\0\0\2\0\4\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0K\0\1\0\25rooter_resolve_links\24rooter_silent_chdir\6g\bvim\0", "config", "vim-rooter")
time([[Config for vim-rooter]], false)
-- Config for: vim-autoswap
time([[Config for vim-autoswap]], true)
try_loadstring("\27LJ\2\n6\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\25autoswap_detect_tmux\6g\bvim\0", "config", "vim-autoswap")
time([[Config for vim-autoswap]], false)
-- Config for: numb.nvim
time([[Config for numb.nvim]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tnumb\frequire\0", "config", "numb.nvim")
time([[Config for numb.nvim]], false)
-- Config for: nvim-neoclip.lua
time([[Config for nvim-neoclip.lua]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fneoclip\frequire\0", "config", "nvim-neoclip.lua")
time([[Config for nvim-neoclip.lua]], false)
-- Config for: conflict-marker.vim
time([[Config for conflict-marker.vim]], true)
try_loadstring("\27LJ\2\n¦\1\0\0\2\0\b\0\r6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0'\1\a\0=\1\6\0K\0\1\0\17^>>>>>>> .*$\24conflict_marker_end\17^<<<<<<< .*$\26conflict_marker_begin\5$conflict_marker_highlight_group\6g\bvim\0", "config", "conflict-marker.vim")
time([[Config for conflict-marker.vim]], false)
-- Config for: close-buffers.nvim
time([[Config for close-buffers.nvim]], true)
try_loadstring("\27LJ\2\n±\1\0\1\v\0\b\0\0236\1\0\0'\3\1\0B\1\2\0029\1\2\1)\3\1\0B\1\2\0016\1\3\0009\1\4\0019\1\5\1B\1\1\0026\2\6\0\18\4\0\0B\2\2\4X\5\6€6\a\3\0009\a\4\a9\a\a\a\18\t\6\0\18\n\1\0B\a\3\1E\5\3\3R\5øK\0\1\0\21nvim_win_set_buf\vipairs\25nvim_get_current_buf\bapi\bvim\ncycle\15bufferline\frequireŒ\1\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\20next_buffer_cmd\0\27preserve_window_layout\1\0\0\1\3\0\0\tthis\rnameless\nsetup\18close_buffers\frequire\0", "config", "close-buffers.nvim")
time([[Config for close-buffers.nvim]], false)
-- Config for: paperplanes.nvim
time([[Config for paperplanes.nvim]], true)
try_loadstring("\27LJ\2\n_\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\rprovider\15dpaste.org\rregister\6+\nsetup\16paperplanes\frequire\0", "config", "paperplanes.nvim")
time([[Config for paperplanes.nvim]], false)
-- Config for: diffview.nvim
time([[Config for diffview.nvim]], true)
try_loadstring("\27LJ\2\n­\1\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\b\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\3=\3\t\2B\0\2\1K\0\1\0\17key_bindings\1\0\0\tview\1\0\1\6q\27<Cmd>DiffviewClose<CR>\15file_panel\1\0\0\1\0\1\6q\27<Cmd>DiffviewClose<CR>\nsetup\rdiffview\frequire\0", "config", "diffview.nvim")
time([[Config for diffview.nvim]], false)
-- Config for: nvim-ts-hint-textobject
time([[Config for nvim-ts-hint-textobject]], true)
try_loadstring("\27LJ\2\nÙ\1\0\0\4\0\v\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\1\4\0=\1\3\0006\0\5\0009\0\6\0'\2\a\0'\3\b\0B\0\3\0016\0\5\0009\0\t\0'\2\a\0'\3\n\0B\0\3\1K\0\1\0%:lua require('tsht').nodes()<CR>\rvnoremap*:<C-U>lua require('tsht').nodes()<CR>\6m\tomap\alk\1\n\0\0\6h\6j\6f\6d\6n\6v\6s\6l\6a\14hint_keys\vconfig\ttsht\frequire\0", "config", "nvim-ts-hint-textobject")
time([[Config for nvim-ts-hint-textobject]], false)
-- Config for: octo.nvim
time([[Config for octo.nvim]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tocto\frequire\0", "config", "octo.nvim")
time([[Config for octo.nvim]], false)
-- Config for: Navigator.nvim
time([[Config for Navigator.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14Navigator\frequire\0", "config", "Navigator.nvim")
time([[Config for Navigator.nvim]], false)
-- Config for: twilight.nvim
time([[Config for twilight.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\rtwilight\frequire\0", "config", "twilight.nvim")
time([[Config for twilight.nvim]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18todo-comments\frequire\0", "config", "todo-comments.nvim")
time([[Config for todo-comments.nvim]], false)
-- Config for: spaceless.nvim
time([[Config for spaceless.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14spaceless\frequire\0", "config", "spaceless.nvim")
time([[Config for spaceless.nvim]], false)
-- Config for: package-info.nvim
time([[Config for package-info.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17package-info\frequire\0", "config", "package-info.nvim")
time([[Config for package-info.nvim]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Dispatch lua require("packer.load")({'vim-dispatch'}, { cmd = "Dispatch", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Make lua require("packer.load")({'vim-dispatch'}, { cmd = "Make", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Focus lua require("packer.load")({'vim-dispatch'}, { cmd = "Focus", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Start lua require("packer.load")({'vim-dispatch'}, { cmd = "Start", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Cheat lua require("packer.load")({'nvim-cheat.sh'}, { cmd = "Cheat", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file CheatWithouComments lua require("packer.load")({'nvim-cheat.sh'}, { cmd = "CheatWithouComments", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file CheatList lua require("packer.load")({'nvim-cheat.sh'}, { cmd = "CheatList", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file CheatListWithoutComments lua require("packer.load")({'nvim-cheat.sh'}, { cmd = "CheatListWithoutComments", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Messages lua require("packer.load")({'vim-scriptease'}, { cmd = "Messages", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Verbose lua require("packer.load")({'vim-scriptease'}, { cmd = "Verbose", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Time lua require("packer.load")({'vim-scriptease'}, { cmd = "Time", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file OpenGithubFile lua require("packer.load")({'open-browser-github.vim'}, { cmd = "OpenGithubFile", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file OpenGithubProject lua require("packer.load")({'open-browser-github.vim'}, { cmd = "OpenGithubProject", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file OpenGithubPullReq lua require("packer.load")({'open-browser-github.vim'}, { cmd = "OpenGithubPullReq", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file OpenGithubCommit lua require("packer.load")({'open-browser-github.vim'}, { cmd = "OpenGithubCommit", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file OpenGithubIssue lua require("packer.load")({'open-browser-github.vim'}, { cmd = "OpenGithubIssue", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file TSPlaygroundToggle lua require("packer.load")({'playground'}, { cmd = "TSPlaygroundToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Vista lua require("packer.load")({'vista.vim'}, { cmd = "Vista", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Glow lua require("packer.load")({'glow.nvim'}, { cmd = "Glow", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file TrainUpDown lua require("packer.load")({'train.nvim'}, { cmd = "TrainUpDown", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file TrainWord lua require("packer.load")({'train.nvim'}, { cmd = "TrainWord", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file TrainTextObj lua require("packer.load")({'train.nvim'}, { cmd = "TrainTextObj", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> gJ <cmd>lua require("packer.load")({'splitjoin.vim'}, { keys = "gJ", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <Plug>(InYoFace_Toggle) <cmd>lua require("packer.load")({'vim-inyoface'}, { keys = "<lt>Plug>(InYoFace_Toggle)", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> gS <cmd>lua require("packer.load")({'splitjoin.vim'}, { keys = "gS", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles(1) end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
