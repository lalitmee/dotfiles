local fn = vim.fn
vim.g.ORIGINAL_KITTY_BG_COLOR = nil

local get_kitty_background = function()
  local Job = require("plenary.job")

  if vim.g.ORIGINAL_KITTY_BG_COLOR == nil then
    -- HACK: getting background color
    Job
      :new({
        command = "kitty",
        args = { "@", "get-colors" },
        cwd = "/usr/bin/",
        on_exit = function(j, _)
          local color = vim.split(j:result()[4], "%s+")[2]
          vim.g.ORIGINAL_KITTY_BG_COLOR = color
        end,
      })
      :start()
  end
end

local function get_color(group, attr)
  return fn.synIDattr(fn.synIDtrans(fn.hlID(group)), attr)
end

local change_background = function(color)
  local arg = 'background="' .. color .. '"'
  local command = "kitty @ set-colors " .. arg

  vim.schedule(function()
    local handle = io.popen(command)
    if handle ~= nil then
      handle:close()
    end
  end)
end

local autocmd = vim.api.nvim_create_autocmd
local autogroup = vim.api.nvim_create_augroup
local bg_change = autogroup("BackgroundChange", { clear = true })

autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    get_kitty_background()
    local color = get_color("Normal", "bg")
    change_background(color)
  end,
  group = bg_change,
})

autocmd("User", {
  pattern = "NvChadThemeReload",
  callback = function()
    get_kitty_background()
    local color = get_color("Normal", "bg")
    change_background(color)
  end,
  group = bg_change,
})

autocmd("VimLeavePre", {
  callback = function()
    if vim.g.ORIGINAL_KITTY_BG_COLOR ~= nil then
      change_background(vim.g.ORIGINAL_KITTY_BG_COLOR)
    end
  end,
  group = autogroup("BackgroundRestore", { clear = true }),
})
