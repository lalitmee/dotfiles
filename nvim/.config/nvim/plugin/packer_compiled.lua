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
    after = { "nvim-ts-context-commentstring" },
    config = { "require('lk/plugins/comment')" },
    keys = { { "n", "gcc" }, { "n", "gbc" }, { "v", "gc" }, { "v", "gb" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  FastFold = {
    config = { "require('lk/plugins/fastfold')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/FastFold",
    url = "https://github.com/Konfekt/FastFold"
  },
  ["FixCursorHold.nvim"] = {
    config = { "\27LJ\2\n3\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1è\3=\1\2\0K\0\1\0\22curshold_updatime\6g\bvim\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim",
    url = "https://github.com/antoinemadec/FixCursorHold.nvim"
  },
  LuaSnip = {
    config = { "require('lk/plugins/luasnip')" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["LuaSnip-snippets.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/LuaSnip-snippets.nvim",
    url = "https://github.com/molleweide/LuaSnip-snippets.nvim"
  },
  ["Navigator.nvim"] = {
    commands = { "NavigateLeft", "NavigateRight", "NavigateUp", "NavigateDown", "NavigatePrevious" },
    config = { "require('lk/plugins/navigator')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/Navigator.nvim",
    url = "https://github.com/numToStr/Navigator.nvim"
  },
  ["auto-session"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/auto-session",
    url = "https://github.com/rmagatti/auto-session"
  },
  ["browse.nvim"] = {
    config = { "require('lk/plugins/browse')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/browse.nvim",
    url = "/home/lalitmee/Desktop/Github/browse.nvim"
  },
  ["close-buffers.nvim"] = {
    commands = { "BDelete" },
    config = { "require('lk/plugins/close-buffers')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/close-buffers.nvim",
    url = "https://github.com/kazhala/close-buffers.nvim"
  },
  ["cmp-buffer"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-buffer/after/plugin/cmp_buffer.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-cmdline/after/plugin/cmp_cmdline.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-emoji"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-emoji/after/plugin/cmp_emoji.lua" },
    keys = { { "", "i" }, { "", ":" } },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-emoji",
    url = "https://github.com/hrsh7th/cmp-emoji"
  },
  ["cmp-nvim-lsp"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp/after/plugin/cmp_nvim_lsp.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua/after/plugin/cmp_nvim_lua.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-path/after/plugin/cmp_path.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-tabnine"] = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-tabnine/after/plugin/cmp-tabnine.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp-tabnine",
    url = "https://github.com/tzachar/cmp-tabnine"
  },
  cmp_luasnip = {
    after_files = { "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/cmp_luasnip/after/plugin/cmp_luasnip.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
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
  ["comment-box.nvim"] = {
    commands = { "CBlbox", "CBclbox", "CBcbox", "CBccbox", "CBalbox", "CBaclbox", "CBacbox", "CBaccbox" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/comment-box.nvim",
    url = "https://github.com/LudoPinelli/comment-box.nvim"
  },
  ["copilot.vim"] = {
    config = { "\27LJ\2\ne\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\0\3\18DressingInput\1\14gitcommit\1\24NeogitCommitMessage\1\22copilot_filetypes\6g\bvim\0" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/copilot.vim",
    url = "https://github.com/github/copilot.vim"
  },
  ["diaglist.nvim"] = {
    commands = { "DiagList", "DiagListAll" },
    load_after = {
      ["nvim-lspconfig"] = true
    },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/diaglist.nvim",
    url = "https://github.com/onsails/diaglist.nvim"
  },
  ["dial.nvim"] = {
    config = { "require('lk/plugins/dial')" },
    keys = { { "n", "<C-a>" }, { "n", "<C-x>" }, { "v", "<C-a>" }, { "v", "<C-x>" }, { "v", "g<C-a>" }, { "v", "g<C-x>" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/dial.nvim",
    url = "https://github.com/monaqa/dial.nvim"
  },
  ["diffview.nvim"] = {
    commands = { "DiffviewOpen", "DiffviewFileHistory" },
    config = { "require('lk/plugins/diffview')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["dressing.nvim"] = {
    config = { "require('lk/plugins/dressing')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/dressing.nvim",
    url = "https://github.com/stevearc/dressing.nvim"
  },
  ["emmet-vim"] = {
    config = { "require('lk/plugins/emmet')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/emmet-vim",
    url = "https://github.com/mattn/emmet-vim"
  },
  ["fidget.nvim"] = {
    config = { "require('lk/plugins/fidget')" },
    load_after = {
      ["nvim-lspconfig"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/fidget.nvim",
    url = "https://github.com/j-hui/fidget.nvim"
  },
  ["formatter.nvim"] = {
    config = { "require('lk/plugins/formatter')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/formatter.nvim",
    url = "https://github.com/mhartington/formatter.nvim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["git-worktree.nvim"] = {
    config = { "\27LJ\2\nQ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\17git_worktree\19load_extension\14telescope\frequire\0" },
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/git-worktree.nvim",
    url = "https://github.com/ThePrimeagen/git-worktree.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "require('lk/plugins/gitsigns')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["glow.nvim"] = {
    commands = { "Glow" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/glow.nvim",
    url = "https://github.com/ellisonleao/glow.nvim"
  },
  harpoon = {
    commands = { "HarpoonAddFile", "HarpoonGotoFile1", "HarpoonGotoFile2", "HarpoonGotoFile3", "HarpoonGotoFile4", "HarpoonGotoFile5", "HarpoonGotoFile6", "HarpoonGotoFile7", "HarpoonGotoFile8", "HarpoonGotoFile9", "HarpoonGotoTerm1", "HarpoonGotoTerm2", "HarpoonGotoTerm3", "HarpoonRemoveFile", "ToggleHarpoonMenu" },
    config = { "require('lk/plugins/harpoon')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/harpoon",
    url = "https://github.com/ThePrimeagen/harpoon"
  },
  ["hop.nvim"] = {
    config = { "require('lk/plugins/hop')" },
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
    config = { "require('lk/plugins/indent-blankline')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["iswap.nvim"] = {
    commands = { "ISwap", "ISwapWith" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/iswap.nvim",
    url = "https://github.com/mizlan/iswap.nvim"
  },
  ["legendary.nvim"] = {
    commands = { "Legendary" },
    config = { "require('lk/plugins/legendary')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/legendary.nvim",
    url = "https://github.com/mrjones2014/legendary.nvim"
  },
  ["lir-git-status.nvim"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/lir-git-status.nvim",
    url = "https://github.com/tamago324/lir-git-status.nvim"
  },
  ["lir.nvim"] = {
    commands = { "LirFloatToggle", "LirFloatInit" },
    config = { "require('lk/plugins/lir')" },
    keys = { { "", "n" }, { "", "-" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/lir.nvim",
    url = "https://github.com/tamago324/lir.nvim"
  },
  ["lsp_signature.nvim"] = {
    config = { "require('lk/plugins/lsp/signature')" },
    load_after = {
      ["nvim-lspconfig"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/lsp_signature.nvim",
    url = "https://github.com/ray-x/lsp_signature.nvim"
  },
  ["lspkind-nvim"] = {
    load_after = {
      ["nvim-lspconfig"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["lua-dev.nvim"] = {
    load_after = {
      ["nvim-lspconfig"] = true
    },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/lua-dev.nvim",
    url = "https://github.com/folke/lua-dev.nvim"
  },
  ["lualine.nvim"] = {
    config = { "require('lk/plugins/lualine')" },
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
  neogen = {
    commands = { "Neogen" },
    config = { "require('lk/plugins/neogen')" },
    load_after = {
      ["nvim-treesitter"] = true
    },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/neogen",
    url = "https://github.com/danymat/neogen"
  },
  neogit = {
    commands = { "Neogit" },
    config = { "require('lk/plugins/neogit')" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/neogit",
    url = "https://github.com/TimUntersberger/neogit"
  },
  ["neoscroll.nvim"] = {
    config = { "require('lk/plugins/neoscroll')" },
    keys = { { "n", "<C-u>" }, { "n", "<C-d>" }, { "n", "<C-b>" }, { "n", "<C-f>" }, { "n", "<C-y>" }, { "n", "<C-e>" }, { "n", "zt" }, { "n", "zz" }, { "n", "zb" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/neoscroll.nvim",
    url = "https://github.com/karb94/neoscroll.nvim"
  },
  ["numb.nvim"] = {
    config = { "require('lk/plugins/numb')" },
    keys = { { "", "c" }, { "", ":" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/numb.nvim",
    url = "https://github.com/nacro90/numb.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "require('lk/plugins/autopairs')" },
    keys = { { "i", "(" }, { "i", "{" }, { "i", "[" }, { "i", "'" }, { "i", '"' }, { "i", "`" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-bqf"] = {
    config = { "require('lk/plugins/nvim-bqf')" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-bqf",
    url = "https://github.com/kevinhwang91/nvim-bqf"
  },
  ["nvim-bufferline.lua"] = {
    config = { "require('lk/plugins/bufferline')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-bufferline.lua",
    url = "https://github.com/akinsho/nvim-bufferline.lua"
  },
  ["nvim-cmp"] = {
    after = { "cmp-buffer", "cmp-path", "cmp-emoji", "LuaSnip", "cmp-nvim-lsp", "cmp-tabnine", "cmp-cmdline", "cmp-nvim-lua", "cmp_luasnip" },
    config = { "require('lk/plugins/nvim-cmp')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    commands = { "ColorizerToggle", "ColorizerAttachToBuffer" },
    config = { "require('lk/plugins/colorizer')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-gomove"] = {
    config = { "require('lk/plugins/gomove')" },
    keys = { { "n", "<M-h>" }, { "n", "<M-j>" }, { "n", "<M-k>" }, { "n", "<M-l>" }, { "v", "<M-h>" }, { "v", "<M-j>" }, { "v", "<M-k>" }, { "v", "<M-l>" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-gomove",
    url = "https://github.com/booperlv/nvim-gomove"
  },
  ["nvim-hlslens"] = {
    config = { "require('lk/plugins/hlslens')" },
    keys = { { "n", "/" }, { "n", "?" }, { "n", "*" }, { "n", "g*" }, { "n", "#" }, { "n", "g#" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-hlslens",
    url = "https://github.com/kevinhwang91/nvim-hlslens"
  },
  ["nvim-lsp-installer"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    after = { "diaglist.nvim", "lspkind-nvim", "lua-dev.nvim", "fidget.nvim", "lsp_signature.nvim" },
    config = { "require('lk/plugins/lsp')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-nonicons"] = {
    config = { "require('lk/plugins/devicons')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-nonicons",
    url = "https://github.com/yamatsum/nvim-nonicons"
  },
  ["nvim-notify"] = {
    config = { "require('lk/plugins/notify')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-pqf.git"] = {
    config = { "require('lk/plugins/nvim-pqf')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-pqf.git",
    url = "https://gitlab.com/yorickpeterse/nvim-pqf"
  },
  ["nvim-terminal.lua"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-terminal.lua",
    url = "https://github.com/norcalli/nvim-terminal.lua"
  },
  ["nvim-toggleterm.lua"] = {
    config = { "require('lk/plugins/toggleterm')" },
    keys = { { "", "n" }, { "", "<C-\\>" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-toggleterm.lua",
    url = "https://github.com/akinsho/nvim-toggleterm.lua"
  },
  ["nvim-tree.lua"] = {
    commands = { "NvimTreeToggle", "NvimTreeRefresh", "NvimTreeFindFile" },
    config = { "require('lk/plugins/nvim-tree')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    after = { "neogen", "refactoring.nvim", "playground", "nvim-treesitter-textobjects", "nvim-ts-context-commentstring" },
    config = { "require('lk/plugins/treesitter')" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
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
      ["Comment.nvim"] = true,
      ["nvim-treesitter"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-ts-context-commentstring",
    url = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["octo.nvim"] = {
    config = { "require('lk/plugins/octo')" },
    keys = { { "", "n" }, { "", "<leader>go" } },
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/octo.nvim",
    url = "https://github.com/pwntester/octo.nvim"
  },
  ["packer.nvim"] = {
    config = { "require('lk/plugins/packer')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    commands = { "TSPlaygroundToggle" },
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
    config = { "require('lk/plugins/pretty-fold')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/pretty-fold.nvim",
    url = "https://github.com/anuvyklack/pretty-fold.nvim"
  },
  ["project.nvim"] = {
    config = { "require('lk/plugins/project')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/project.nvim",
    url = "https://github.com/ahmedkhalf/project.nvim"
  },
  ["quick-scope"] = {
    config = { "require('lk/plugins/quick-scope')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/quick-scope",
    url = "https://github.com/unblevable/quick-scope"
  },
  ["reach.nvim"] = {
    commands = { "ReachOpen" },
    config = { "require('lk/plugins/reach')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/reach.nvim",
    url = "https://github.com/toppair/reach.nvim"
  },
  ["refactoring.nvim"] = {
    commands = { "ExtractSelectedFunc", "RefactorDebugPath", "RefactorDebugPrintVarAbove", "RefactorDebugPrintVarBelow", "RefactorDebugPrintfAbove", "RefactorDebugPrintfBelow", "RefactorExtractFunc", "RefactorExtractVar", "RefactorInlineVar", "Refactors", "RefactorsList" },
    config = { "require('lk/plugins/refactoring')" },
    load_after = {
      ["nvim-treesitter"] = true,
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/refactoring.nvim",
    url = "https://github.com/ThePrimeagen/refactoring.nvim"
  },
  ["replacer.nvim"] = {
    commands = { "ReplacerRun", "ReplacerRunFiles" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/replacer.nvim",
    url = "https://github.com/gabrielpoca/replacer.nvim"
  },
  ["session-lens"] = {
    commands = { "SearchSession" },
    config = { "require('lk/plugins/session-lens')" },
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/session-lens",
    url = "https://github.com/rmagatti/session-lens"
  },
  sniprun = {
    commands = { "SnipRun" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/sniprun",
    url = "https://github.com/michaelb/sniprun"
  },
  ["splitjoin.vim"] = {
    keys = { { "n", "gJ" }, { "n", "gS" } },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/splitjoin.vim",
    url = "https://github.com/AndrewRadev/splitjoin.vim"
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
  ["substitute.nvim"] = {
    config = { "require('lk/plugins/substitute')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/substitute.nvim",
    url = "https://github.com/gbprod/substitute.nvim"
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
  ["telescope-emoji.nvim"] = {
    config = { "\27LJ\2\nJ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\nemoji\19load_extension\14telescope\frequire\0" },
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-emoji.nvim",
    url = "https://github.com/xiyaowong/telescope-emoji.nvim"
  },
  ["telescope-file-browser.nvim"] = {
    config = { "\27LJ\2\nQ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\17file_browser\19load_extension\14telescope\frequire\0" },
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-file-browser.nvim",
    url = "https://github.com/nvim-telescope/telescope-file-browser.nvim"
  },
  ["telescope-frecency.nvim"] = {
    config = { "\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0" },
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-frecency.nvim",
    url = "https://github.com/nvim-telescope/telescope-frecency.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bfzf\19load_extension\14telescope\frequire\0" },
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-hop.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bhop\19load_extension\14telescope\frequire\0" },
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-hop.nvim",
    url = "https://github.com/nvim-telescope/telescope-hop.nvim"
  },
  ["telescope-media-files.nvim"] = {
    config = { "\27LJ\2\nP\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\16media_files\19load_extension\14telescope\frequire\0" },
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-media-files.nvim",
    url = "https://github.com/nvim-telescope/telescope-media-files.nvim"
  },
  ["telescope-smart-history.nvim"] = {
    config = { "\27LJ\2\nR\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\18smart_history\19load_extension\14telescope\frequire\0" },
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-smart-history.nvim",
    url = "https://github.com/nvim-telescope/telescope-smart-history.nvim"
  },
  ["telescope-tmux.nvim"] = {
    config = { "\27LJ\2\nI\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\ttmux\19load_extension\14telescope\frequire\0" },
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-tmux.nvim",
    url = "https://github.com/camgraff/telescope-tmux.nvim"
  },
  ["telescope-ui-select.nvim"] = {
    config = { "\27LJ\2\nN\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\14ui-select\19load_extension\14telescope\frequire\0" },
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope-ui-select.nvim",
    url = "https://github.com/nvim-telescope/telescope-ui-select.nvim"
  },
  ["telescope.nvim"] = {
    after = { "session-lens", "telescope-tmux.nvim", "telescope-hop.nvim", "telescope-media-files.nvim", "git-worktree.nvim", "octo.nvim", "telescope-ui-select.nvim", "telescope-frecency.nvim", "telescope-emoji.nvim", "telescope-file-browser.nvim", "refactoring.nvim", "telescope-fzf-native.nvim", "telescope-smart-history.nvim" },
    commands = { "Telescope" },
    config = { "require('lk/plugins/telescope')" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["tidy.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/tidy.nvim",
    url = "https://github.com/McAuleyPenney/tidy.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "require('lk/plugins/todo-comments')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  ["vim-abolish"] = {
    config = { "require('lk/plugins/abolish')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-abolish",
    url = "https://github.com/tpope/vim-abolish"
  },
  ["vim-bufsurf"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-bufsurf",
    url = "https://github.com/ton/vim-bufsurf"
  },
  ["vim-cool"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-cool",
    url = "https://github.com/romainl/vim-cool"
  },
  ["vim-matchup"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-matchup",
    url = "https://github.com/andymass/vim-matchup"
  },
  ["vim-repeat"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/vim-repeat",
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
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/vim-sleuth",
    url = "https://github.com/tpope/vim-sleuth"
  },
  ["vim-snippets"] = {
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-snippets",
    url = "https://github.com/honza/vim-snippets"
  },
  ["vim-sort-motion"] = {
    keys = { { "v", "gs" }, { "n", "gs" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/vim-sort-motion",
    url = "https://github.com/christoomey/vim-sort-motion"
  },
  ["vim-surround"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-visual-star-search"] = {
    keys = { { "", "v" }, { "", "*" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/vim-visual-star-search",
    url = "https://github.com/nelstrom/vim-visual-star-search"
  },
  ["vim-wakatime"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/opt/vim-wakatime",
    url = "https://github.com/wakatime/vim-wakatime"
  },
  ["vim-yoink"] = {
    config = { "require('lk/plugins/vim-yoink')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/vim-yoink",
    url = "https://github.com/svermeulen/vim-yoink"
  },
  ["which-key.nvim"] = {
    config = { "require('lk/plugins/which-key')" },
    loaded = true,
    path = "/home/lalitmee/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^repeat"] = "vim-repeat",
  ["^vim"] = "nvim-notify",
  ["^vim%.ui"] = "dressing.nvim"
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

-- Config for: formatter.nvim
time([[Config for formatter.nvim]], true)
require('lk/plugins/formatter')
time([[Config for formatter.nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
require('lk/plugins/lualine')
time([[Config for lualine.nvim]], false)
-- Config for: copilot.vim
time([[Config for copilot.vim]], true)
try_loadstring("\27LJ\2\ne\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\0\3\18DressingInput\1\14gitcommit\1\24NeogitCommitMessage\1\22copilot_filetypes\6g\bvim\0", "config", "copilot.vim")
time([[Config for copilot.vim]], false)
-- Config for: vim-abolish
time([[Config for vim-abolish]], true)
require('lk/plugins/abolish')
time([[Config for vim-abolish]], false)
-- Config for: emmet-vim
time([[Config for emmet-vim]], true)
require('lk/plugins/emmet')
time([[Config for emmet-vim]], false)
-- Config for: packer.nvim
time([[Config for packer.nvim]], true)
require('lk/plugins/packer')
time([[Config for packer.nvim]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
require('lk/plugins/todo-comments')
time([[Config for todo-comments.nvim]], false)
-- Config for: substitute.nvim
time([[Config for substitute.nvim]], true)
require('lk/plugins/substitute')
time([[Config for substitute.nvim]], false)
-- Config for: project.nvim
time([[Config for project.nvim]], true)
require('lk/plugins/project')
time([[Config for project.nvim]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
require('lk/plugins/which-key')
time([[Config for which-key.nvim]], false)
-- Config for: FixCursorHold.nvim
time([[Config for FixCursorHold.nvim]], true)
try_loadstring("\27LJ\2\n3\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1è\3=\1\2\0K\0\1\0\22curshold_updatime\6g\bvim\0", "config", "FixCursorHold.nvim")
time([[Config for FixCursorHold.nvim]], false)
-- Config for: vim-yoink
time([[Config for vim-yoink]], true)
require('lk/plugins/vim-yoink')
time([[Config for vim-yoink]], false)
-- Config for: browse.nvim
time([[Config for browse.nvim]], true)
require('lk/plugins/browse')
time([[Config for browse.nvim]], false)
-- Config for: quick-scope
time([[Config for quick-scope]], true)
require('lk/plugins/quick-scope')
time([[Config for quick-scope]], false)
-- Config for: hop.nvim
time([[Config for hop.nvim]], true)
require('lk/plugins/hop')
time([[Config for hop.nvim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd auto-session ]]
time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file ISwap lua require("packer.load")({'iswap.nvim'}, { cmd = "ISwap", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file ISwapWith lua require("packer.load")({'iswap.nvim'}, { cmd = "ISwapWith", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file ReplacerRun lua require("packer.load")({'replacer.nvim'}, { cmd = "ReplacerRun", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file ReplacerRunFiles lua require("packer.load")({'replacer.nvim'}, { cmd = "ReplacerRunFiles", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SnipRun lua require("packer.load")({'sniprun'}, { cmd = "SnipRun", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file ColorizerToggle lua require("packer.load")({'nvim-colorizer.lua'}, { cmd = "ColorizerToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file ColorizerAttachToBuffer lua require("packer.load")({'nvim-colorizer.lua'}, { cmd = "ColorizerAttachToBuffer", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CBlbox lua require("packer.load")({'comment-box.nvim'}, { cmd = "CBlbox", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CBclbox lua require("packer.load")({'comment-box.nvim'}, { cmd = "CBclbox", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CBcbox lua require("packer.load")({'comment-box.nvim'}, { cmd = "CBcbox", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CBccbox lua require("packer.load")({'comment-box.nvim'}, { cmd = "CBccbox", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CBalbox lua require("packer.load")({'comment-box.nvim'}, { cmd = "CBalbox", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CBaclbox lua require("packer.load")({'comment-box.nvim'}, { cmd = "CBaclbox", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CBacbox lua require("packer.load")({'comment-box.nvim'}, { cmd = "CBacbox", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CBaccbox lua require("packer.load")({'comment-box.nvim'}, { cmd = "CBaccbox", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'startuptime.vim'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NavigateLeft lua require("packer.load")({'Navigator.nvim'}, { cmd = "NavigateLeft", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NavigateRight lua require("packer.load")({'Navigator.nvim'}, { cmd = "NavigateRight", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NavigateUp lua require("packer.load")({'Navigator.nvim'}, { cmd = "NavigateUp", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NavigateDown lua require("packer.load")({'Navigator.nvim'}, { cmd = "NavigateDown", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NavigatePrevious lua require("packer.load")({'Navigator.nvim'}, { cmd = "NavigatePrevious", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file LirFloatToggle lua require("packer.load")({'lir.nvim'}, { cmd = "LirFloatToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file LirFloatInit lua require("packer.load")({'lir.nvim'}, { cmd = "LirFloatInit", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NvimTreeToggle lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NvimTreeRefresh lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeRefresh", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NvimTreeFindFile lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeFindFile", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Messages lua require("packer.load")({'vim-scriptease'}, { cmd = "Messages", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Verbose lua require("packer.load")({'vim-scriptease'}, { cmd = "Verbose", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file BDelete lua require("packer.load")({'close-buffers.nvim'}, { cmd = "BDelete", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file RefactorExtractVar lua require("packer.load")({'refactoring.nvim'}, { cmd = "RefactorExtractVar", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file RefactorInlineVar lua require("packer.load")({'refactoring.nvim'}, { cmd = "RefactorInlineVar", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Refactors lua require("packer.load")({'refactoring.nvim'}, { cmd = "Refactors", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file DiffviewOpen lua require("packer.load")({'diffview.nvim'}, { cmd = "DiffviewOpen", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file DiffviewFileHistory lua require("packer.load")({'diffview.nvim'}, { cmd = "DiffviewFileHistory", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Neogen lua require("packer.load")({'neogen'}, { cmd = "Neogen", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Neogit lua require("packer.load")({'neogit'}, { cmd = "Neogit", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSPlaygroundToggle lua require("packer.load")({'playground'}, { cmd = "TSPlaygroundToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file HarpoonGotoFile2 lua require("packer.load")({'harpoon'}, { cmd = "HarpoonGotoFile2", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file DiagList lua require("packer.load")({'diaglist.nvim'}, { cmd = "DiagList", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Legendary lua require("packer.load")({'legendary.nvim'}, { cmd = "Legendary", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SearchSession lua require("packer.load")({'session-lens'}, { cmd = "SearchSession", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file HarpoonAddFile lua require("packer.load")({'harpoon'}, { cmd = "HarpoonAddFile", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file HarpoonGotoFile1 lua require("packer.load")({'harpoon'}, { cmd = "HarpoonGotoFile1", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Glow lua require("packer.load")({'glow.nvim'}, { cmd = "Glow", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Time lua require("packer.load")({'vim-scriptease'}, { cmd = "Time", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file DiagListAll lua require("packer.load")({'diaglist.nvim'}, { cmd = "DiagListAll", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file HarpoonGotoFile3 lua require("packer.load")({'harpoon'}, { cmd = "HarpoonGotoFile3", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file ExtractSelectedFunc lua require("packer.load")({'refactoring.nvim'}, { cmd = "ExtractSelectedFunc", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file RefactorDebugPath lua require("packer.load")({'refactoring.nvim'}, { cmd = "RefactorDebugPath", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Telescope lua require("packer.load")({'telescope.nvim'}, { cmd = "Telescope", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file RefactorDebugPrintVarBelow lua require("packer.load")({'refactoring.nvim'}, { cmd = "RefactorDebugPrintVarBelow", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file RefactorDebugPrintfAbove lua require("packer.load")({'refactoring.nvim'}, { cmd = "RefactorDebugPrintfAbove", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file RefactorDebugPrintfBelow lua require("packer.load")({'refactoring.nvim'}, { cmd = "RefactorDebugPrintfBelow", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file RefactorExtractFunc lua require("packer.load")({'refactoring.nvim'}, { cmd = "RefactorExtractFunc", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file HarpoonGotoFile4 lua require("packer.load")({'harpoon'}, { cmd = "HarpoonGotoFile4", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file HarpoonGotoFile5 lua require("packer.load")({'harpoon'}, { cmd = "HarpoonGotoFile5", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file HarpoonGotoFile6 lua require("packer.load")({'harpoon'}, { cmd = "HarpoonGotoFile6", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file HarpoonGotoFile7 lua require("packer.load")({'harpoon'}, { cmd = "HarpoonGotoFile7", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file HarpoonGotoFile8 lua require("packer.load")({'harpoon'}, { cmd = "HarpoonGotoFile8", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file HarpoonGotoFile9 lua require("packer.load")({'harpoon'}, { cmd = "HarpoonGotoFile9", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file HarpoonGotoTerm1 lua require("packer.load")({'harpoon'}, { cmd = "HarpoonGotoTerm1", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file HarpoonGotoTerm2 lua require("packer.load")({'harpoon'}, { cmd = "HarpoonGotoTerm2", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file HarpoonGotoTerm3 lua require("packer.load")({'harpoon'}, { cmd = "HarpoonGotoTerm3", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file HarpoonRemoveFile lua require("packer.load")({'harpoon'}, { cmd = "HarpoonRemoveFile", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file ToggleHarpoonMenu lua require("packer.load")({'harpoon'}, { cmd = "ToggleHarpoonMenu", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file RefactorDebugPrintVarAbove lua require("packer.load")({'refactoring.nvim'}, { cmd = "RefactorDebugPrintVarAbove", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Tabularize lua require("packer.load")({'tabular'}, { cmd = "Tabularize", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file RefactorsList lua require("packer.load")({'refactoring.nvim'}, { cmd = "RefactorsList", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file ReachOpen lua require("packer.load")({'reach.nvim'}, { cmd = "ReachOpen", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> : <cmd>lua require("packer.load")({'cmp-emoji'}, { keys = ":", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> n <cmd>lua require("packer.load")({'octo.nvim'}, { keys = "n", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[vnoremap <silent> <M-k> <cmd>lua require("packer.load")({'nvim-gomove'}, { keys = "<lt>M-k>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> zt <cmd>lua require("packer.load")({'neoscroll.nvim'}, { keys = "zt", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[vnoremap <silent> <C-a> <cmd>lua require("packer.load")({'dial.nvim'}, { keys = "<lt>C-a>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> n <cmd>lua require("packer.load")({'nvim-toggleterm.lua'}, { keys = "n", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> ? <cmd>lua require("packer.load")({'nvim-hlslens'}, { keys = "?", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> <M-j> <cmd>lua require("packer.load")({'nvim-gomove'}, { keys = "<lt>M-j>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[vnoremap <silent> <M-l> <cmd>lua require("packer.load")({'nvim-gomove'}, { keys = "<lt>M-l>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <C-\> <cmd>lua require("packer.load")({'nvim-toggleterm.lua'}, { keys = "<lt>C-\\>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> <M-k> <cmd>lua require("packer.load")({'nvim-gomove'}, { keys = "<lt>M-k>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> <C-b> <cmd>lua require("packer.load")({'neoscroll.nvim'}, { keys = "<lt>C-b>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> - <cmd>lua require("packer.load")({'lir.nvim'}, { keys = "-", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> <C-a> <cmd>lua require("packer.load")({'dial.nvim'}, { keys = "<lt>C-a>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> <C-d> <cmd>lua require("packer.load")({'neoscroll.nvim'}, { keys = "<lt>C-d>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[inoremap <silent> ' <cmd>lua require("packer.load")({'nvim-autopairs'}, { keys = "'" }, _G.packer_plugins)<cr>]]
vim.cmd [[vnoremap <silent> gs <cmd>lua require("packer.load")({'vim-sort-motion'}, { keys = "gs", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[vnoremap <silent> g<C-x> <cmd>lua require("packer.load")({'dial.nvim'}, { keys = "g<lt>C-x>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[vnoremap <silent> <M-j> <cmd>lua require("packer.load")({'nvim-gomove'}, { keys = "<lt>M-j>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> <C-f> <cmd>lua require("packer.load")({'neoscroll.nvim'}, { keys = "<lt>C-f>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> <C-e> <cmd>lua require("packer.load")({'neoscroll.nvim'}, { keys = "<lt>C-e>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> g# <cmd>lua require("packer.load")({'nvim-hlslens'}, { keys = "g#", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> gs <cmd>lua require("packer.load")({'vim-sort-motion'}, { keys = "gs", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> * <cmd>lua require("packer.load")({'vim-visual-star-search'}, { keys = "*", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> # <cmd>lua require("packer.load")({'nvim-hlslens'}, { keys = "#", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <leader>go <cmd>lua require("packer.load")({'octo.nvim'}, { keys = "<lt>leader>go", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[vnoremap <silent> <M-h> <cmd>lua require("packer.load")({'nvim-gomove'}, { keys = "<lt>M-h>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> gS <cmd>lua require("packer.load")({'splitjoin.vim'}, { keys = "gS", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[inoremap <silent> " <cmd>lua require("packer.load")({'nvim-autopairs'}, { keys = "\"" }, _G.packer_plugins)<cr>]]
vim.cmd [[inoremap <silent> ` <cmd>lua require("packer.load")({'nvim-autopairs'}, { keys = "`" }, _G.packer_plugins)<cr>]]
vim.cmd [[inoremap <silent> [ <cmd>lua require("packer.load")({'nvim-autopairs'}, { keys = "[" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> <C-u> <cmd>lua require("packer.load")({'neoscroll.nvim'}, { keys = "<lt>C-u>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[inoremap <silent> { <cmd>lua require("packer.load")({'nvim-autopairs'}, { keys = "{" }, _G.packer_plugins)<cr>]]
vim.cmd [[inoremap <silent> ( <cmd>lua require("packer.load")({'nvim-autopairs'}, { keys = "(" }, _G.packer_plugins)<cr>]]
vim.cmd [[vnoremap <silent> gb <cmd>lua require("packer.load")({'Comment.nvim'}, { keys = "gb", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> zz <cmd>lua require("packer.load")({'neoscroll.nvim'}, { keys = "zz", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[vnoremap <silent> gc <cmd>lua require("packer.load")({'Comment.nvim'}, { keys = "gc", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[vnoremap <silent> <C-x> <cmd>lua require("packer.load")({'dial.nvim'}, { keys = "<lt>C-x>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> gbc <cmd>lua require("packer.load")({'Comment.nvim'}, { keys = "gbc", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> gcc <cmd>lua require("packer.load")({'Comment.nvim'}, { keys = "gcc", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> * <cmd>lua require("packer.load")({'nvim-hlslens'}, { keys = "*", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[vnoremap <silent> g<C-a> <cmd>lua require("packer.load")({'dial.nvim'}, { keys = "g<lt>C-a>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> v <cmd>lua require("packer.load")({'vim-visual-star-search'}, { keys = "v", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> zb <cmd>lua require("packer.load")({'neoscroll.nvim'}, { keys = "zb", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> n <cmd>lua require("packer.load")({'lir.nvim'}, { keys = "n", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> : <cmd>lua require("packer.load")({'numb.nvim'}, { keys = ":", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> / <cmd>lua require("packer.load")({'nvim-hlslens'}, { keys = "/", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> i <cmd>lua require("packer.load")({'cmp-emoji'}, { keys = "i", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> g* <cmd>lua require("packer.load")({'nvim-hlslens'}, { keys = "g*", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> c <cmd>lua require("packer.load")({'numb.nvim'}, { keys = "c", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> <M-l> <cmd>lua require("packer.load")({'nvim-gomove'}, { keys = "<lt>M-l>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> <M-h> <cmd>lua require("packer.load")({'nvim-gomove'}, { keys = "<lt>M-h>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> <C-y> <cmd>lua require("packer.load")({'neoscroll.nvim'}, { keys = "<lt>C-y>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> <C-x> <cmd>lua require("packer.load")({'dial.nvim'}, { keys = "<lt>C-x>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> gJ <cmd>lua require("packer.load")({'splitjoin.vim'}, { keys = "gJ", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType json ++once lua require("packer.load")({'nvim-lspconfig', 'nvim-treesitter'}, { ft = "json" }, _G.packer_plugins)]]
vim.cmd [[au FileType typescript ++once lua require("packer.load")({'nvim-lspconfig', 'nvim-treesitter'}, { ft = "typescript" }, _G.packer_plugins)]]
vim.cmd [[au FileType yaml ++once lua require("packer.load")({'nvim-lspconfig', 'nvim-treesitter'}, { ft = "yaml" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim', 'glow.nvim', 'nvim-lspconfig', 'nvim-treesitter'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType css ++once lua require("packer.load")({'nvim-lspconfig', 'nvim-treesitter'}, { ft = "css" }, _G.packer_plugins)]]
vim.cmd [[au FileType dockerfile ++once lua require("packer.load")({'nvim-lspconfig', 'nvim-treesitter'}, { ft = "dockerfile" }, _G.packer_plugins)]]
vim.cmd [[au FileType vim ++once lua require("packer.load")({'nvim-lspconfig', 'nvim-treesitter'}, { ft = "vim" }, _G.packer_plugins)]]
vim.cmd [[au FileType bash ++once lua require("packer.load")({'nvim-lspconfig', 'nvim-treesitter'}, { ft = "bash" }, _G.packer_plugins)]]
vim.cmd [[au FileType lua ++once lua require("packer.load")({'nvim-lspconfig', 'nvim-treesitter', 'cmp-nvim-lua', 'lua-dev.nvim'}, { ft = "lua" }, _G.packer_plugins)]]
vim.cmd [[au FileType javascript ++once lua require("packer.load")({'nvim-lspconfig', 'nvim-treesitter'}, { ft = "javascript" }, _G.packer_plugins)]]
vim.cmd [[au FileType qf ++once lua require("packer.load")({'nvim-bqf', 'nvim-pqf.git'}, { ft = "qf" }, _G.packer_plugins)]]
vim.cmd [[au FileType html ++once lua require("packer.load")({'nvim-lspconfig', 'nvim-treesitter'}, { ft = "html" }, _G.packer_plugins)]]
vim.cmd [[au FileType help ++once lua require("packer.load")({'vim-scriptease'}, { ft = "help" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufWritePre * ++once lua require("packer.load")({'tidy.nvim'}, { event = "BufWritePre *" }, _G.packer_plugins)]]
vim.cmd [[au BufRead * ++once lua require("packer.load")({'vim-sleuth', 'nvim-nonicons', 'vim-surround', 'indent-blankline.nvim', 'gitsigns.nvim', 'FastFold', 'nvim-bufferline.lua'}, { event = "BufRead *" }, _G.packer_plugins)]]
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'vim-wakatime'}, { event = "VimEnter *" }, _G.packer_plugins)]]
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'nvim-cmp'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufEnter * ++once lua require("packer.load")({'pretty-fold.nvim'}, { event = "BufEnter *" }, _G.packer_plugins)]]
vim.cmd [[au CmdlineEnter * ++once lua require("packer.load")({'cmp-cmdline', 'nvim-cmp'}, { event = "CmdlineEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/cooklang.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/cooklang.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/cooklang.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/fusion.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/fusion.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/fusion.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/gdresource.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/gdresource.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/gdresource.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/gdscript.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/gdscript.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/gdscript.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/glimmer.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/glimmer.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/glimmer.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/glsl.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/glsl.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/glsl.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/gowork.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/gowork.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/gowork.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/graphql.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/graphql.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/graphql.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/hack.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/hack.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/hack.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/hcl.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/hcl.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/hcl.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/heex.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/heex.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/heex.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/hjson.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/hjson.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/hjson.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/json5.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/json5.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/json5.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/ledger.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/ledger.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/ledger.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/nix.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/nix.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/nix.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/prisma.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/prisma.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/prisma.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/pug.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/pug.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/pug.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/ql.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/ql.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/ql.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/query.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/query.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/query.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/surface.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/surface.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/surface.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/teal.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/teal.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/teal.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/tlaplus.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/tlaplus.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/tlaplus.vim]], false)
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/yang.vim]], true)
vim.cmd [[source /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/yang.vim]]
time([[Sourcing ftdetect script at: /home/lalitmee/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/ftdetect/yang.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles(1) end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
