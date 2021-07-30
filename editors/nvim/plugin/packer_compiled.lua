-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
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
  ["BetterLua.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/BetterLua.vim"
  },
  FastFold = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/FastFold"
  },
  ["FixCursorHold.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim"
  },
  ["JABS.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/JABS.nvim"
  },
  ["Navigator.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14Navigator\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/Navigator.nvim"
  },
  NrrwRgn = {
    commands = { "NarrowRegion", "NarrowWindow" },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/NrrwRgn"
  },
  ["TrueZen.nvim"] = {
    commands = { "TZAtaraxis", "TZAtaraxisOn", "TZFocus", "TZFocusOn", "TZMinimalist", "TZMinimalistOn" },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/TrueZen.nvim"
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
    config = { "\27LJ\2\n�\1\0\0\2\0\b\0\r6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0'\1\a\0=\1\6\0K\0\1\0\17^>>>>>>> .*$\24conflict_marker_end\17^<<<<<<< .*$\26conflict_marker_begin\5$conflict_marker_highlight_group\6g\bvim\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/conflict-marker.vim"
  },
  ["crease.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/crease.vim"
  },
  ["diffview.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/diffview.nvim"
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
  ["git-messenger.vim"] = {
    commands = { "GitMessenger" },
    keys = { { "", "<Plug>(git-messenger)" } },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/git-messenger.vim"
  },
  ["git-worktree.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/git-worktree.nvim"
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
  ["gonvim-fuzzy"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/gonvim-fuzzy"
  },
  gruvbox = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/gruvbox"
  },
  ["gruvbuddy.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/gruvbuddy.nvim"
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
  ["incsearch.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/incsearch.vim"
  },
  ["indent-blankline.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim"
  },
  ["is.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/is.vim"
  },
  ["iswap.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/iswap.nvim"
  },
  ["lazygit.nvim"] = {
    commands = { "LazyGit", "LazyGitConfig", "LazyGitFilter" },
    loaded = false,
    needs_bufread = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/lazygit.nvim"
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
  ["mkdir.nvim"] = {
    config = { "\27LJ\2\n%\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\nmkdir\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/mkdir.nvim"
  },
  ["neco-vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/neco-vim"
  },
  neogit = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/neogit"
  },
  neorg = {
    config = { "\27LJ\2\n�\5\0\0\t\0(\0-6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2&\0005\3\3\0004\4\0\0=\4\4\0035\4\30\0005\5\28\0005\6\f\0005\a\5\0005\b\6\0=\b\a\a5\b\b\0=\b\t\a5\b\n\0=\b\v\a=\a\r\0065\a\14\0=\a\15\0065\a\16\0005\b\17\0=\b\18\a5\b\19\0=\b\20\a5\b\21\0=\b\22\a5\b\23\0=\b\24\a=\a\25\0065\a\26\0=\a\27\6=\6\29\5=\5\31\4=\4 \0035\4$\0005\5\"\0005\6!\0=\6#\5=\5\31\4=\4%\3=\3'\2B\0\2\1K\0\1\0\tload\1\0\0\21core.norg.dirman\1\0\0\15workspaces\1\0\0\1\0\1\17my_workspace\30~/data/Github/Notes/neorg\24core.norg.concealer\vconfig\1\0\0\nicons\1\0\1\19conceal_cursor\5\tlist\1\0\2\ticon\b‑\fenabled\2\fheading\flevel_4\1\0\2\ticon\b◦\fenabled\2\flevel_3\1\0\2\ticon\b•\fenabled\2\flevel_2\1\0\2\ticon\b⦾\fenabled\2\flevel_1\1\0\2\ticon\b⦿\fenabled\2\1\0\1\fenabled\2\nquote\1\0\2\ticon\b∣\fenabled\2\ttodo\1\0\0\vundone\1\0\2\ticon\a×\fenabled\2\fpending\1\0\2\ticon\b\fenabled\2\tdone\1\0\2\ticon\b\fenabled\2\1\0\1\fenabled\2\18core.defaults\1\0\0\nsetup\nneorg\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/neorg"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14neoscroll\frequire\0" },
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
  ["nvim-luadev"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-luadev"
  },
  ["nvim-markdown-preview"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-markdown-preview"
  },
  ["nvim-nonicons"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-nonicons"
  },
  ["nvim-reload"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-reload"
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
  ["nvim-ts-context-commentstring"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-ts-context-commentstring"
  },
  ["nvim-ts-hint-textobject"] = {
    config = { "\27LJ\2\n�\1\0\0\4\0\v\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\1\4\0=\1\3\0006\0\5\0009\0\6\0'\2\a\0'\3\b\0B\0\3\0016\0\5\0009\0\t\0'\2\a\0'\3\n\0B\0\3\1K\0\1\0%:lua require('tsht').nodes()<CR>\rvnoremap*:<C-U>lua require('tsht').nodes()<CR>\6m\tomap\alk\1\n\0\0\6h\6j\6f\6d\6n\6v\6s\6l\6a\14hint_keys\vconfig\ttsht\frequire\0" },
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
  ["nvim-whichkey-setup.lua"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-whichkey-setup.lua"
  },
  ["octo.nvim"] = {
    config = { "\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tocto\frequire\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/octo.nvim"
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
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/packer.nvim"
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
  ["snippets.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/snippets.nvim"
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
  ["telescope-bookmarks.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-bookmarks.nvim"
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
  ["telescope-fzf-writer.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-fzf-writer.nvim"
  },
  ["telescope-fzy-native.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-fzy-native.nvim"
  },
  ["telescope-github.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-github.nvim"
  },
  ["telescope-harpoon.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-harpoon.nvim"
  },
  ["telescope-jumps.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-jumps.nvim"
  },
  ["telescope-lsp-handlers.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-lsp-handlers.nvim"
  },
  ["telescope-openbrowser.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-openbrowser.nvim"
  },
  ["telescope-project.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-project.nvim"
  },
  ["telescope-snippets.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-snippets.nvim"
  },
  ["telescope-symbols.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-symbols.nvim"
  },
  ["telescope-ultisnips.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-ultisnips.nvim"
  },
  ["telescope-zoxide"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope-zoxide"
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
  ["traces.vim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/traces.vim"
  },
  ["train.nvim"] = {
    commands = { "TrainUpDown", "TrainWord", "TrainTextObj" },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/train.nvim"
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
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-autoswap"
  },
  ["vim-better-whitespace"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-better-whitespace"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-context-commentstring"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-context-commentstring"
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
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-fugitive"
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
  ["vim-sayonara"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-sayonara"
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
  ["vim-startuptime"] = {
    commands = { "StartupTime" },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/vim-startuptime"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-tmux-runner"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-tmux-runner"
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
  ["vim-which-key"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-which-key"
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
  }
}

time([[Defining packer_plugins]], false)
-- Config for: numb.nvim
time([[Config for numb.nvim]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tnumb\frequire\0", "config", "numb.nvim")
time([[Config for numb.nvim]], false)
-- Config for: mkdir.nvim
time([[Config for mkdir.nvim]], true)
try_loadstring("\27LJ\2\n%\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\nmkdir\frequire\0", "config", "mkdir.nvim")
time([[Config for mkdir.nvim]], false)
-- Config for: Navigator.nvim
time([[Config for Navigator.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14Navigator\frequire\0", "config", "Navigator.nvim")
time([[Config for Navigator.nvim]], false)
-- Config for: octo.nvim
time([[Config for octo.nvim]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tocto\frequire\0", "config", "octo.nvim")
time([[Config for octo.nvim]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18todo-comments\frequire\0", "config", "todo-comments.nvim")
time([[Config for todo-comments.nvim]], false)
-- Config for: neorg
time([[Config for neorg]], true)
try_loadstring("\27LJ\2\n�\5\0\0\t\0(\0-6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2&\0005\3\3\0004\4\0\0=\4\4\0035\4\30\0005\5\28\0005\6\f\0005\a\5\0005\b\6\0=\b\a\a5\b\b\0=\b\t\a5\b\n\0=\b\v\a=\a\r\0065\a\14\0=\a\15\0065\a\16\0005\b\17\0=\b\18\a5\b\19\0=\b\20\a5\b\21\0=\b\22\a5\b\23\0=\b\24\a=\a\25\0065\a\26\0=\a\27\6=\6\29\5=\5\31\4=\4 \0035\4$\0005\5\"\0005\6!\0=\6#\5=\5\31\4=\4%\3=\3'\2B\0\2\1K\0\1\0\tload\1\0\0\21core.norg.dirman\1\0\0\15workspaces\1\0\0\1\0\1\17my_workspace\30~/data/Github/Notes/neorg\24core.norg.concealer\vconfig\1\0\0\nicons\1\0\1\19conceal_cursor\5\tlist\1\0\2\ticon\b‑\fenabled\2\fheading\flevel_4\1\0\2\ticon\b◦\fenabled\2\flevel_3\1\0\2\ticon\b•\fenabled\2\flevel_2\1\0\2\ticon\b⦾\fenabled\2\flevel_1\1\0\2\ticon\b⦿\fenabled\2\1\0\1\fenabled\2\nquote\1\0\2\ticon\b∣\fenabled\2\ttodo\1\0\0\vundone\1\0\2\ticon\a×\fenabled\2\fpending\1\0\2\ticon\b\fenabled\2\tdone\1\0\2\ticon\b\fenabled\2\1\0\1\fenabled\2\18core.defaults\1\0\0\nsetup\nneorg\frequire\0", "config", "neorg")
time([[Config for neorg]], false)
-- Config for: vim-rooter
time([[Config for vim-rooter]], true)
try_loadstring("\27LJ\2\nZ\0\0\2\0\4\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0K\0\1\0\25rooter_resolve_links\24rooter_silent_chdir\6g\bvim\0", "config", "vim-rooter")
time([[Config for vim-rooter]], false)
-- Config for: neoscroll.nvim
time([[Config for neoscroll.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14neoscroll\frequire\0", "config", "neoscroll.nvim")
time([[Config for neoscroll.nvim]], false)
-- Config for: conflict-marker.vim
time([[Config for conflict-marker.vim]], true)
try_loadstring("\27LJ\2\n�\1\0\0\2\0\b\0\r6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0'\1\a\0=\1\6\0K\0\1\0\17^>>>>>>> .*$\24conflict_marker_end\17^<<<<<<< .*$\26conflict_marker_begin\5$conflict_marker_highlight_group\6g\bvim\0", "config", "conflict-marker.vim")
time([[Config for conflict-marker.vim]], false)
-- Config for: nvim-ts-hint-textobject
time([[Config for nvim-ts-hint-textobject]], true)
try_loadstring("\27LJ\2\n�\1\0\0\4\0\v\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\1\4\0=\1\3\0006\0\5\0009\0\6\0'\2\a\0'\3\b\0B\0\3\0016\0\5\0009\0\t\0'\2\a\0'\3\n\0B\0\3\1K\0\1\0%:lua require('tsht').nodes()<CR>\rvnoremap*:<C-U>lua require('tsht').nodes()<CR>\6m\tomap\alk\1\n\0\0\6h\6j\6f\6d\6n\6v\6s\6l\6a\14hint_keys\vconfig\ttsht\frequire\0", "config", "nvim-ts-hint-textobject")
time([[Config for nvim-ts-hint-textobject]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file OpenGithubProject lua require("packer.load")({'open-browser-github.vim'}, { cmd = "OpenGithubProject", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file OpenGithubPullReq lua require("packer.load")({'open-browser-github.vim'}, { cmd = "OpenGithubPullReq", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Cheat lua require("packer.load")({'nvim-cheat.sh'}, { cmd = "Cheat", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file OpenGithubIssue lua require("packer.load")({'open-browser-github.vim'}, { cmd = "OpenGithubIssue", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CheatList lua require("packer.load")({'nvim-cheat.sh'}, { cmd = "CheatList", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CheatListWithoutComments lua require("packer.load")({'nvim-cheat.sh'}, { cmd = "CheatListWithoutComments", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file LazyGit lua require("packer.load")({'lazygit.nvim'}, { cmd = "LazyGit", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file LazyGitConfig lua require("packer.load")({'lazygit.nvim'}, { cmd = "LazyGitConfig", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file LazyGitFilter lua require("packer.load")({'lazygit.nvim'}, { cmd = "LazyGitFilter", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'vim-startuptime'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file GitMessenger lua require("packer.load")({'git-messenger.vim'}, { cmd = "GitMessenger", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TZAtaraxis lua require("packer.load")({'TrueZen.nvim'}, { cmd = "TZAtaraxis", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TZAtaraxisOn lua require("packer.load")({'TrueZen.nvim'}, { cmd = "TZAtaraxisOn", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TZFocus lua require("packer.load")({'TrueZen.nvim'}, { cmd = "TZFocus", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TZFocusOn lua require("packer.load")({'TrueZen.nvim'}, { cmd = "TZFocusOn", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TZMinimalist lua require("packer.load")({'TrueZen.nvim'}, { cmd = "TZMinimalist", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TZMinimalistOn lua require("packer.load")({'TrueZen.nvim'}, { cmd = "TZMinimalistOn", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Dispatch lua require("packer.load")({'vim-dispatch'}, { cmd = "Dispatch", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Make lua require("packer.load")({'vim-dispatch'}, { cmd = "Make", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Focus lua require("packer.load")({'vim-dispatch'}, { cmd = "Focus", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Start lua require("packer.load")({'vim-dispatch'}, { cmd = "Start", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSPlaygroundToggle lua require("packer.load")({'playground'}, { cmd = "TSPlaygroundToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Messages lua require("packer.load")({'vim-scriptease'}, { cmd = "Messages", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Verbose lua require("packer.load")({'vim-scriptease'}, { cmd = "Verbose", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Time lua require("packer.load")({'vim-scriptease'}, { cmd = "Time", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TrainUpDown lua require("packer.load")({'train.nvim'}, { cmd = "TrainUpDown", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NarrowRegion lua require("packer.load")({'NrrwRgn'}, { cmd = "NarrowRegion", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NarrowWindow lua require("packer.load")({'NrrwRgn'}, { cmd = "NarrowWindow", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Vista lua require("packer.load")({'vista.vim'}, { cmd = "Vista", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CheatWithouComments lua require("packer.load")({'nvim-cheat.sh'}, { cmd = "CheatWithouComments", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TrainWord lua require("packer.load")({'train.nvim'}, { cmd = "TrainWord", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TrainTextObj lua require("packer.load")({'train.nvim'}, { cmd = "TrainTextObj", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Glow lua require("packer.load")({'glow.nvim'}, { cmd = "Glow", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file OpenGithubCommit lua require("packer.load")({'open-browser-github.vim'}, { cmd = "OpenGithubCommit", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file OpenGithubFile lua require("packer.load")({'open-browser-github.vim'}, { cmd = "OpenGithubFile", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> <Plug>(git-messenger) <cmd>lua require("packer.load")({'git-messenger.vim'}, { keys = "<lt>Plug>(git-messenger)", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> gS <cmd>lua require("packer.load")({'splitjoin.vim'}, { keys = "gS", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <Plug>(InYoFace_Toggle) <cmd>lua require("packer.load")({'vim-inyoface'}, { keys = "<lt>Plug>(InYoFace_Toggle)", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> gJ <cmd>lua require("packer.load")({'splitjoin.vim'}, { keys = "gJ", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
