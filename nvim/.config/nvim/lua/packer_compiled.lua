-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

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
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

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
  ["ChatGPT.nvim"] = {
    config = { "R('lk.plugins.ChatGPT')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/ChatGPT.nvim",
    url = "https://github.com/jackMort/ChatGPT.nvim"
  },
  ["Comment.nvim"] = {
    after = { "nvim-ts-context-commentstring" },
    config = { "R('lk.plugins.comment')" },
    loaded = true,
    only_config = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["Navigator.nvim"] = {
    config = { "R('lk.plugins.navigator')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/Navigator.nvim",
    url = "https://github.com/numToStr/Navigator.nvim"
  },
  ["NeoZoom.lua"] = {
    commands = { "NeoZoomToggle" },
    config = { "R('lk.plugins.neozoom')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/NeoZoom.lua",
    url = "https://github.com/nyngwang/NeoZoom.lua"
  },
  ["attempt.nvim"] = {
    commands = { "AttemptNew", "AttemptNewExtension" },
    config = { "R('lk.plugins.attempt')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/attempt.nvim",
    url = "https://github.com/m-demare/attempt.nvim"
  },
  ["auto-session"] = {
    after = { "session-lens" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/auto-session",
    url = "https://github.com/rmagatti/auto-session"
  },
  ["autolist.nvim"] = {
    config = { "R('lk.plugins.autolist')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/autolist.nvim",
    url = "https://github.com/gaoDean/autolist.nvim"
  },
  ["browse.nvim"] = {
    config = { "R('lk.plugins.browse')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/browse.nvim",
    url = "/home/lalitmee/Desktop/Github/browse.nvim"
  },
  ["bufdelete.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/bufdelete.nvim",
    url = "https://github.com/famiu/bufdelete.nvim"
  },
  ["cmp-buffer"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-buffer/after/plugin/cmp_buffer.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua/after/plugin/cmp_nvim_lua.lua" },
    load_after = {},
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-path/after/plugin/cmp_path.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-tabnine"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-tabnine/after/plugin/cmp-tabnine.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-tabnine",
    url = "https://github.com/tzachar/cmp-tabnine"
  },
  cmp_luasnip = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp_luasnip/after/plugin/cmp_luasnip.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
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
  ["colortils.nvim"] = {
    commands = { "Colortils" },
    config = { "R('lk.plugins.colortils')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/colortils.nvim",
    url = "https://github.com/nvim-colortils/colortils.nvim"
  },
  ["debugprint.nvim"] = {
    config = { "R('lk.plugins.debugprint')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/debugprint.nvim",
    url = "https://github.com/andrewferrier/debugprint.nvim"
  },
  ["diffview.nvim"] = {
    config = { "R('lk.plugins.diffview')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["dirbuf.nvim"] = {
    commands = { "Dirbuf", "DirbufSync" },
    config = { "\27LJ\2\nF\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0'autocmd VimEnter * autocmd! dirbuf\bcmd\bvim\0" },
    keys = { { "n", "-" } },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/dirbuf.nvim",
    url = "https://github.com/elihunter173/dirbuf.nvim"
  },
  ["dressing.nvim"] = {
    config = { "R('lk.plugins.dressing')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/dressing.nvim",
    url = "https://github.com/stevearc/dressing.nvim"
  },
  ["emmet-vim"] = {
    config = { "R('lk.plugins.emmet')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/emmet-vim",
    url = "https://github.com/mattn/emmet-vim"
  },
  ["fidget.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/fidget.nvim",
    url = "https://github.com/j-hui/fidget.nvim"
  },
  ["fold-cycle.nvim"] = {
    config = { "R('lk.plugins.fold-cycle')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/fold-cycle.nvim",
    url = "https://github.com/jghauser/fold-cycle.nvim"
  },
  ["formatter.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/formatter.nvim",
    url = "https://github.com/mhartington/formatter.nvim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["fsread.nvim"] = {
    commands = { "FSToggle" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/fsread.nvim",
    url = "https://github.com/nullchilly/fsread.nvim"
  },
  ["git-worktree.nvim"] = {
    config = { "\27LJ\2\nQ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\17git_worktree\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/git-worktree.nvim",
    url = "https://github.com/ThePrimeagen/git-worktree.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "R('lk.plugins.gitsigns')" },
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
  ["go.nvim"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/go.nvim",
    url = "https://github.com/ray-x/go.nvim"
  },
  harpoon = {
    config = { "R('lk.plugins.harpoon')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/harpoon",
    url = "https://github.com/ThePrimeagen/harpoon"
  },
  ["howdoi.nvim"] = {
    config = { "\27LJ\2\nK\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\vhowdoi\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/howdoi.nvim",
    url = "https://github.com/zane-/howdoi.nvim"
  },
  ["icon-picker.nvim"] = {
    commands = { "PickEverything" },
    config = { "R('lk.plugins.icon-picker')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/icon-picker.nvim",
    url = "https://github.com/ziontee113/icon-picker.nvim"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["iswap.nvim"] = {
    load_after = {
      ["nvim-treesitter"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/iswap.nvim",
    url = "https://github.com/mizlan/iswap.nvim"
  },
  ["lsp-trouble.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/lsp-trouble.nvim",
    url = "https://github.com/folke/lsp-trouble.nvim"
  },
  ["lspkind.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/lspkind.nvim",
    url = "https://github.com/onsails/lspkind.nvim"
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
  ["mason-lspconfig.nvim"] = {
    config = { "R('lk.plugins.mason')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["mind.nvim"] = {
    config = { "R('lk.plugins.mind')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/mind.nvim",
    url = "https://github.com/phaazon/mind.nvim"
  },
  ["neo-tree.nvim"] = {
    config = { "R('lk.plugins.neo-tree')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/neo-tree.nvim",
    url = "https://github.com/nvim-neo-tree/neo-tree.nvim"
  },
  ["neodev.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/neodev.nvim",
    url = "https://github.com/folke/neodev.nvim"
  },
  neogen = {
    commands = { "Neogen" },
    config = { "R('lk.plugins.neogen')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/neogen",
    url = "https://github.com/danymat/neogen"
  },
  neogit = {
    commands = { "Neogit" },
    config = { "R('lk.plugins.neogit')" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/neogit",
    url = "https://github.com/TimUntersberger/neogit"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["null-ls.nvim"] = {
    config = { "R('lk.plugins.lsp.null-ls')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "R('lk.plugins.autopairs')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-bqf"] = {
    config = { "R('lk.plugins.bqf')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-bqf",
    url = "https://github.com/kevinhwang91/nvim-bqf"
  },
  ["nvim-cmp"] = {
    after = { "cmp-buffer", "cmp-nvim-lua", "cmp-path", "cmp-tabnine", "cmp_luasnip" },
    config = { "R('lk.plugins.cmp')" },
    loaded = true,
    only_config = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    commands = { "ColorizerToggle" },
    config = { "R('lk.plugins.colorizer')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-colorizer.lua",
    url = "https://github.com/NvChad/nvim-colorizer.lua"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-ui"] = {
    config = { "R('lk.plugins.dap')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-dap-virtual-text"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-dap-virtual-text",
    url = "https://github.com/theHamsta/nvim-dap-virtual-text"
  },
  ["nvim-lspconfig"] = {
    config = { "R('lk.plugins.lsp')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-navic"] = {
    config = { "R('lk.plugins.navic')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-navic",
    url = "https://github.com/SmiteshP/nvim-navic"
  },
  ["nvim-nonicons"] = {
    config = { "R('lk.plugins.devicons')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-nonicons",
    url = "https://github.com/yamatsum/nvim-nonicons"
  },
  ["nvim-notify"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-pqf.git"] = {
    config = { "R('lk.plugins.pqf')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-pqf.git",
    url = "https://gitlab.com/yorickpeterse/nvim-pqf"
  },
  ["nvim-spectre"] = {
    config = { "R('lk.plugins.spectre')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-spectre",
    url = "https://github.com/nvim-pack/nvim-spectre"
  },
  ["nvim-surround"] = {
    config = { "R('lk.plugins.surround')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-surround",
    url = "https://github.com/kylechui/nvim-surround"
  },
  ["nvim-treesitter"] = {
    after = { "iswap.nvim", "nvim-ts-context-commentstring", "nvim-treesitter-textobjects", "playground", "nvim-treesitter-context", "nvim-ts-rainbow" },
    config = { "R('lk.plugins.treesitter')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    load_after = {
      ["nvim-treesitter"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-context",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-context"
  },
  ["nvim-treesitter-textobjects"] = {
    load_after = {
      ["nvim-treesitter"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-ts-context-commentstring"] = {
    load_after = {
      ["nvim-treesitter"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-ts-context-commentstring",
    url = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring"
  },
  ["nvim-ts-rainbow"] = {
    load_after = {
      ["nvim-treesitter"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-ts-rainbow",
    url = "https://github.com/p00f/nvim-ts-rainbow"
  },
  ["nvim-ufo"] = {
    config = { "R('lk.plugins.ufo')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-ufo",
    url = "https://github.com/kevinhwang91/nvim-ufo"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["nvim-window-picker"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-window-picker",
    url = "https://github.com/s1n7ax/nvim-window-picker"
  },
  ["octo.nvim"] = {
    config = { "R('lk.plugins.octo')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/octo.nvim",
    url = "https://github.com/pwntester/octo.nvim"
  },
  ["one-small-step-for-vimkind"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/one-small-step-for-vimkind",
    url = "https://github.com/jbyuki/one-small-step-for-vimkind"
  },
  ["overseer.nvim"] = {
    config = { "R('lk.plugins.overseer')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/overseer.nvim",
    url = "https://github.com/stevearc/overseer.nvim"
  },
  ["packer.nvim"] = {
    config = { "R('lk.plugins.packer')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    commands = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    load_after = {
      ["nvim-treesitter"] = true
    },
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
  ["pretty-fold.nvim"] = {
    config = { "R('lk.plugins.pretty-fold')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/pretty-fold.nvim",
    url = "https://github.com/anuvyklack/pretty-fold.nvim"
  },
  ["project.nvim"] = {
    config = { "R('lk.plugins.project')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/project.nvim",
    url = "https://github.com/ahmedkhalf/project.nvim"
  },
  ["promise-async"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/promise-async",
    url = "https://github.com/kevinhwang91/promise-async"
  },
  ["replacer.nvim"] = {
    commands = { "Replacer", "ReplacerFiles" },
    config = { "R('lk.plugins.replacer')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/replacer.nvim",
    url = "https://github.com/gabrielpoca/replacer.nvim"
  },
  ["scope.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/scope.nvim",
    url = "https://github.com/tiagovla/scope.nvim"
  },
  ["session-lens"] = {
    commands = { "SearchSession" },
    config = { "R('lk.plugins.sessions')" },
    load_after = {
      ["auto-session"] = true
    },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/session-lens",
    url = "https://github.com/rmagatti/session-lens"
  },
  ["silicon.lua"] = {
    commands = { "Silicon", "SiliconCopy", "SiliconBuf" },
    config = { "R('lk.plugins.silicon')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/silicon.lua",
    url = "https://github.com/narutoxy/silicon.lua"
  },
  sniprun = {
    config = { "R('lk.plugins.sniprun')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/sniprun",
    url = "https://github.com/michaelb/sniprun"
  },
  ["sqlite.lua"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/sqlite.lua",
    url = "https://github.com/kkharji/sqlite.lua"
  },
  ["startuptime.vim"] = {
    commands = { "StartupTime" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/startuptime.vim",
    url = "https://github.com/tweekmonster/startuptime.vim"
  },
  ["tabby.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/tabby.nvim",
    url = "https://github.com/nanozuki/tabby.nvim"
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
  ["telescope-dap.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bdap\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-dap.nvim",
    url = "https://github.com/nvim-telescope/telescope-dap.nvim"
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
  ["telescope-github.nvim"] = {
    config = { "\27LJ\2\nG\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\agh\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-github.nvim",
    url = "https://github.com/nvim-telescope/telescope-github.nvim"
  },
  ["telescope-live-grep-args.nvim"] = {
    config = { "\27LJ\2\nS\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\19live_grep_args\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-live-grep-args.nvim",
    url = "https://github.com/nvim-telescope/telescope-live-grep-args.nvim"
  },
  ["telescope-ui-select.nvim"] = {
    config = { "\27LJ\2\nN\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\14ui-select\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-ui-select.nvim",
    url = "https://github.com/nvim-telescope/telescope-ui-select.nvim"
  },
  ["telescope-undo.nvim"] = {
    config = { "\27LJ\2\nI\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\tundo\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-undo.nvim",
    url = "https://github.com/debugloop/telescope-undo.nvim"
  },
  ["telescope.nvim"] = {
    after = { "session-lens", "howdoi.nvim", "git-worktree.nvim", "telescope-dap.nvim", "telescope-frecency.nvim", "telescope-fzf-native.nvim", "telescope-github.nvim", "telescope-live-grep-args.nvim", "telescope-ui-select.nvim", "telescope-undo.nvim" },
    config = { "R('lk.plugins.telescope')" },
    loaded = true,
    only_config = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  treesj = {
    commands = { "TSJToggle", "TSJSplit", "TSJJoin" },
    config = { "R('lk.plugins.treesj')" },
    keys = { { "", "gS" }, { "", "gJ" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/treesj",
    url = "https://github.com/Wansmer/treesj"
  },
  undotree = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["vim-abolish"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-abolish",
    url = "https://github.com/tpope/vim-abolish"
  },
  ["vim-be-good"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-be-good",
    url = "https://github.com/ThePrimeagen/vim-be-good"
  },
  ["vim-cool"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-cool",
    url = "https://github.com/romainl/vim-cool"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-scriptease"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-scriptease",
    url = "https://github.com/tpope/vim-scriptease"
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
  ["vim-sxhkdrc"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-sxhkdrc",
    url = "https://github.com/baskerville/vim-sxhkdrc"
  },
  ["vim-wakatime"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/vim-wakatime",
    url = "https://github.com/wakatime/vim-wakatime"
  },
  ["which-key.nvim"] = {
    config = { "R('lk.plugins.which-key')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  },
  ["yanky.nvim"] = {
    config = { "R('lk.plugins.yanky')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/yanky.nvim",
    url = "https://github.com/gbprod/yanky.nvim"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^lspconfig"] = "nvim-lspconfig",
  ["^vim"] = "nvim-notify"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Config for: dressing.nvim
time([[Config for dressing.nvim]], true)
R('lk.plugins.dressing')
time([[Config for dressing.nvim]], false)
-- Config for: mind.nvim
time([[Config for mind.nvim]], true)
R('lk.plugins.mind')
time([[Config for mind.nvim]], false)
-- Config for: autolist.nvim
time([[Config for autolist.nvim]], true)
R('lk.plugins.autolist')
time([[Config for autolist.nvim]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
R('lk.plugins.comment')
time([[Config for Comment.nvim]], false)
-- Config for: nvim-pqf.git
time([[Config for nvim-pqf.git]], true)
R('lk.plugins.pqf')
time([[Config for nvim-pqf.git]], false)
-- Config for: nvim-spectre
time([[Config for nvim-spectre]], true)
R('lk.plugins.spectre')
time([[Config for nvim-spectre]], false)
-- Config for: harpoon
time([[Config for harpoon]], true)
R('lk.plugins.harpoon')
time([[Config for harpoon]], false)
-- Config for: nvim-nonicons
time([[Config for nvim-nonicons]], true)
R('lk.plugins.devicons')
time([[Config for nvim-nonicons]], false)
-- Config for: null-ls.nvim
time([[Config for null-ls.nvim]], true)
R('lk.plugins.lsp.null-ls')
time([[Config for null-ls.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
R('lk.plugins.telescope')
time([[Config for telescope.nvim]], false)
-- Config for: nvim-bqf
time([[Config for nvim-bqf]], true)
R('lk.plugins.bqf')
time([[Config for nvim-bqf]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
R('lk.plugins.gitsigns')
time([[Config for gitsigns.nvim]], false)
-- Config for: yanky.nvim
time([[Config for yanky.nvim]], true)
R('lk.plugins.yanky')
time([[Config for yanky.nvim]], false)
-- Config for: nvim-ufo
time([[Config for nvim-ufo]], true)
R('lk.plugins.ufo')
time([[Config for nvim-ufo]], false)
-- Config for: nvim-dap-ui
time([[Config for nvim-dap-ui]], true)
R('lk.plugins.dap')
time([[Config for nvim-dap-ui]], false)
-- Config for: octo.nvim
time([[Config for octo.nvim]], true)
R('lk.plugins.octo')
time([[Config for octo.nvim]], false)
-- Config for: overseer.nvim
time([[Config for overseer.nvim]], true)
R('lk.plugins.overseer')
time([[Config for overseer.nvim]], false)
-- Config for: ChatGPT.nvim
time([[Config for ChatGPT.nvim]], true)
R('lk.plugins.ChatGPT')
time([[Config for ChatGPT.nvim]], false)
-- Config for: browse.nvim
time([[Config for browse.nvim]], true)
R('lk.plugins.browse')
time([[Config for browse.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
R('lk.plugins.cmp')
time([[Config for nvim-cmp]], false)
-- Config for: neo-tree.nvim
time([[Config for neo-tree.nvim]], true)
R('lk.plugins.neo-tree')
time([[Config for neo-tree.nvim]], false)
-- Config for: nvim-navic
time([[Config for nvim-navic]], true)
R('lk.plugins.navic')
time([[Config for nvim-navic]], false)
-- Config for: packer.nvim
time([[Config for packer.nvim]], true)
R('lk.plugins.packer')
time([[Config for packer.nvim]], false)
-- Config for: sniprun
time([[Config for sniprun]], true)
R('lk.plugins.sniprun')
time([[Config for sniprun]], false)
-- Config for: pretty-fold.nvim
time([[Config for pretty-fold.nvim]], true)
R('lk.plugins.pretty-fold')
time([[Config for pretty-fold.nvim]], false)
-- Config for: debugprint.nvim
time([[Config for debugprint.nvim]], true)
R('lk.plugins.debugprint')
time([[Config for debugprint.nvim]], false)
-- Config for: Navigator.nvim
time([[Config for Navigator.nvim]], true)
R('lk.plugins.navigator')
time([[Config for Navigator.nvim]], false)
-- Config for: project.nvim
time([[Config for project.nvim]], true)
R('lk.plugins.project')
time([[Config for project.nvim]], false)
-- Config for: diffview.nvim
time([[Config for diffview.nvim]], true)
R('lk.plugins.diffview')
time([[Config for diffview.nvim]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
R('lk.plugins.which-key')
time([[Config for which-key.nvim]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
R('lk.plugins.autopairs')
time([[Config for nvim-autopairs]], false)
-- Config for: fold-cycle.nvim
time([[Config for fold-cycle.nvim]], true)
R('lk.plugins.fold-cycle')
time([[Config for fold-cycle.nvim]], false)
-- Config for: mason-lspconfig.nvim
time([[Config for mason-lspconfig.nvim]], true)
R('lk.plugins.mason')
time([[Config for mason-lspconfig.nvim]], false)
-- Config for: nvim-surround
time([[Config for nvim-surround]], true)
R('lk.plugins.surround')
time([[Config for nvim-surround]], false)
-- Config for: emmet-vim
time([[Config for emmet-vim]], true)
R('lk.plugins.emmet')
time([[Config for emmet-vim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd telescope-frecency.nvim ]]

-- Config for: telescope-frecency.nvim
try_loadstring("\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0", "config", "telescope-frecency.nvim")

vim.cmd [[ packadd git-worktree.nvim ]]

-- Config for: git-worktree.nvim
try_loadstring("\27LJ\2\nQ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\17git_worktree\19load_extension\14telescope\frequire\0", "config", "git-worktree.nvim")

vim.cmd [[ packadd telescope-undo.nvim ]]

-- Config for: telescope-undo.nvim
try_loadstring("\27LJ\2\nI\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\tundo\19load_extension\14telescope\frequire\0", "config", "telescope-undo.nvim")

vim.cmd [[ packadd telescope-ui-select.nvim ]]

-- Config for: telescope-ui-select.nvim
try_loadstring("\27LJ\2\nN\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\14ui-select\19load_extension\14telescope\frequire\0", "config", "telescope-ui-select.nvim")

vim.cmd [[ packadd telescope-live-grep-args.nvim ]]

-- Config for: telescope-live-grep-args.nvim
try_loadstring("\27LJ\2\nS\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\19live_grep_args\19load_extension\14telescope\frequire\0", "config", "telescope-live-grep-args.nvim")

vim.cmd [[ packadd telescope-github.nvim ]]

-- Config for: telescope-github.nvim
try_loadstring("\27LJ\2\nG\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\agh\19load_extension\14telescope\frequire\0", "config", "telescope-github.nvim")

vim.cmd [[ packadd howdoi.nvim ]]

-- Config for: howdoi.nvim
try_loadstring("\27LJ\2\nK\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\vhowdoi\19load_extension\14telescope\frequire\0", "config", "howdoi.nvim")

vim.cmd [[ packadd telescope-fzf-native.nvim ]]

-- Config for: telescope-fzf-native.nvim
try_loadstring("\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bfzf\19load_extension\14telescope\frequire\0", "config", "telescope-fzf-native.nvim")

vim.cmd [[ packadd cmp_luasnip ]]
vim.cmd [[ packadd cmp-tabnine ]]
vim.cmd [[ packadd cmp-path ]]
vim.cmd [[ packadd cmp-buffer ]]
vim.cmd [[ packadd nvim-dap ]]
vim.cmd [[ packadd telescope-dap.nvim ]]

-- Config for: telescope-dap.nvim
try_loadstring("\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bdap\19load_extension\14telescope\frequire\0", "config", "telescope-dap.nvim")

time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.api.nvim_create_user_command, 'Silicon', function(cmdargs)
          require('packer.load')({'silicon.lua'}, { cmd = 'Silicon', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'silicon.lua'}, { cmd = 'Silicon' }, _G.packer_plugins)
          return vim.fn.getcompletion('Silicon ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'SiliconCopy', function(cmdargs)
          require('packer.load')({'silicon.lua'}, { cmd = 'SiliconCopy', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'silicon.lua'}, { cmd = 'SiliconCopy' }, _G.packer_plugins)
          return vim.fn.getcompletion('SiliconCopy ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'SiliconBuf', function(cmdargs)
          require('packer.load')({'silicon.lua'}, { cmd = 'SiliconBuf', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'silicon.lua'}, { cmd = 'SiliconBuf' }, _G.packer_plugins)
          return vim.fn.getcompletion('SiliconBuf ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Dirbuf', function(cmdargs)
          require('packer.load')({'dirbuf.nvim'}, { cmd = 'Dirbuf', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'dirbuf.nvim'}, { cmd = 'Dirbuf' }, _G.packer_plugins)
          return vim.fn.getcompletion('Dirbuf ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'DirbufSync', function(cmdargs)
          require('packer.load')({'dirbuf.nvim'}, { cmd = 'DirbufSync', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'dirbuf.nvim'}, { cmd = 'DirbufSync' }, _G.packer_plugins)
          return vim.fn.getcompletion('DirbufSync ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'NeoZoomToggle', function(cmdargs)
          require('packer.load')({'NeoZoom.lua'}, { cmd = 'NeoZoomToggle', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'NeoZoom.lua'}, { cmd = 'NeoZoomToggle' }, _G.packer_plugins)
          return vim.fn.getcompletion('NeoZoomToggle ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'PickEverything', function(cmdargs)
          require('packer.load')({'icon-picker.nvim'}, { cmd = 'PickEverything', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'icon-picker.nvim'}, { cmd = 'PickEverything' }, _G.packer_plugins)
          return vim.fn.getcompletion('PickEverything ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'StartupTime', function(cmdargs)
          require('packer.load')({'startuptime.vim'}, { cmd = 'StartupTime', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'startuptime.vim'}, { cmd = 'StartupTime' }, _G.packer_plugins)
          return vim.fn.getcompletion('StartupTime ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Colortils', function(cmdargs)
          require('packer.load')({'colortils.nvim'}, { cmd = 'Colortils', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'colortils.nvim'}, { cmd = 'Colortils' }, _G.packer_plugins)
          return vim.fn.getcompletion('Colortils ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'AttemptNew', function(cmdargs)
          require('packer.load')({'attempt.nvim'}, { cmd = 'AttemptNew', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'attempt.nvim'}, { cmd = 'AttemptNew' }, _G.packer_plugins)
          return vim.fn.getcompletion('AttemptNew ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'AttemptNewExtension', function(cmdargs)
          require('packer.load')({'attempt.nvim'}, { cmd = 'AttemptNewExtension', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'attempt.nvim'}, { cmd = 'AttemptNewExtension' }, _G.packer_plugins)
          return vim.fn.getcompletion('AttemptNewExtension ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'TSHighlightCapturesUnderCursor', function(cmdargs)
          require('packer.load')({'playground'}, { cmd = 'TSHighlightCapturesUnderCursor', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'playground'}, { cmd = 'TSHighlightCapturesUnderCursor' }, _G.packer_plugins)
          return vim.fn.getcompletion('TSHighlightCapturesUnderCursor ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'TSPlaygroundToggle', function(cmdargs)
          require('packer.load')({'playground'}, { cmd = 'TSPlaygroundToggle', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'playground'}, { cmd = 'TSPlaygroundToggle' }, _G.packer_plugins)
          return vim.fn.getcompletion('TSPlaygroundToggle ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'SearchSession', function(cmdargs)
          require('packer.load')({'session-lens'}, { cmd = 'SearchSession', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'session-lens'}, { cmd = 'SearchSession' }, _G.packer_plugins)
          return vim.fn.getcompletion('SearchSession ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'TSJSplit', function(cmdargs)
          require('packer.load')({'treesj'}, { cmd = 'TSJSplit', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'treesj'}, { cmd = 'TSJSplit' }, _G.packer_plugins)
          return vim.fn.getcompletion('TSJSplit ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'TSJJoin', function(cmdargs)
          require('packer.load')({'treesj'}, { cmd = 'TSJJoin', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'treesj'}, { cmd = 'TSJJoin' }, _G.packer_plugins)
          return vim.fn.getcompletion('TSJJoin ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Neogit', function(cmdargs)
          require('packer.load')({'neogit'}, { cmd = 'Neogit', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'neogit'}, { cmd = 'Neogit' }, _G.packer_plugins)
          return vim.fn.getcompletion('Neogit ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Tabularize', function(cmdargs)
          require('packer.load')({'tabular'}, { cmd = 'Tabularize', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'tabular'}, { cmd = 'Tabularize' }, _G.packer_plugins)
          return vim.fn.getcompletion('Tabularize ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'ColorizerToggle', function(cmdargs)
          require('packer.load')({'nvim-colorizer.lua'}, { cmd = 'ColorizerToggle', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'nvim-colorizer.lua'}, { cmd = 'ColorizerToggle' }, _G.packer_plugins)
          return vim.fn.getcompletion('ColorizerToggle ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'FSToggle', function(cmdargs)
          require('packer.load')({'fsread.nvim'}, { cmd = 'FSToggle', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'fsread.nvim'}, { cmd = 'FSToggle' }, _G.packer_plugins)
          return vim.fn.getcompletion('FSToggle ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Neogen', function(cmdargs)
          require('packer.load')({'neogen'}, { cmd = 'Neogen', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'neogen'}, { cmd = 'Neogen' }, _G.packer_plugins)
          return vim.fn.getcompletion('Neogen ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'TSJToggle', function(cmdargs)
          require('packer.load')({'treesj'}, { cmd = 'TSJToggle', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'treesj'}, { cmd = 'TSJToggle' }, _G.packer_plugins)
          return vim.fn.getcompletion('TSJToggle ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Replacer', function(cmdargs)
          require('packer.load')({'replacer.nvim'}, { cmd = 'Replacer', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'replacer.nvim'}, { cmd = 'Replacer' }, _G.packer_plugins)
          return vim.fn.getcompletion('Replacer ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'ReplacerFiles', function(cmdargs)
          require('packer.load')({'replacer.nvim'}, { cmd = 'ReplacerFiles', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'replacer.nvim'}, { cmd = 'ReplacerFiles' }, _G.packer_plugins)
          return vim.fn.getcompletion('ReplacerFiles ', 'cmdline')
      end})
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> gJ <cmd>lua require("packer.load")({'treesj'}, { keys = "gJ", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> - <cmd>lua require("packer.load")({'dirbuf.nvim'}, { keys = "-", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> gS <cmd>lua require("packer.load")({'treesj'}, { keys = "gS", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType typescript ++once lua require("packer.load")({'nvim-lspconfig'}, { ft = "typescript" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'glow.nvim', 'nvim-lspconfig', 'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType dockerfile ++once lua require("packer.load")({'nvim-lspconfig'}, { ft = "dockerfile" }, _G.packer_plugins)]]
vim.cmd [[au FileType bash ++once lua require("packer.load")({'nvim-lspconfig'}, { ft = "bash" }, _G.packer_plugins)]]
vim.cmd [[au FileType javascript ++once lua require("packer.load")({'nvim-lspconfig'}, { ft = "javascript" }, _G.packer_plugins)]]
vim.cmd [[au FileType yaml ++once lua require("packer.load")({'nvim-lspconfig'}, { ft = "yaml" }, _G.packer_plugins)]]
vim.cmd [[au FileType html ++once lua require("packer.load")({'nvim-lspconfig'}, { ft = "html" }, _G.packer_plugins)]]
vim.cmd [[au FileType vim ++once lua require("packer.load")({'nvim-lspconfig'}, { ft = "vim" }, _G.packer_plugins)]]
vim.cmd [[au FileType json ++once lua require("packer.load")({'nvim-lspconfig'}, { ft = "json" }, _G.packer_plugins)]]
vim.cmd [[au FileType go ++once lua require("packer.load")({'go.nvim', 'nvim-lspconfig'}, { ft = "go" }, _G.packer_plugins)]]
vim.cmd [[au FileType css ++once lua require("packer.load")({'nvim-lspconfig'}, { ft = "css" }, _G.packer_plugins)]]
vim.cmd [[au FileType lua ++once lua require("packer.load")({'cmp-nvim-lua', 'nvim-lspconfig'}, { ft = "lua" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'vim-wakatime', 'nvim-treesitter', 'auto-session'}, { event = "VimEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/go.nvim/ftdetect/go.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/go.nvim/ftdetect/go.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/go.nvim/ftdetect/go.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/go.nvim/ftdetect/gomod.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/go.nvim/ftdetect/gomod.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/go.nvim/ftdetect/gomod.vim]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles(1) end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
