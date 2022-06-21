local M = {}

local colors_ok, colors = lk.safe_require("cobalt2.palette")
if not colors_ok then
  return
end

vim.api.nvim_set_hl(0, "WinBar", { bg = colors.cobalt_bg, fg = colors.blue })

local separator = ">"

local disabled_filetypes = { "NvimTree", "NeogitStatus", "NeogitCommitMessage" }

-- See :h statusline for %v values
M.eval = function()
  if vim.tbl_contains(disabled_filetypes, vim.bo.filetype) then
    vim.opt_local.winbar = nil
    return
  end
  local file_path = vim.api.nvim_eval_statusline("%f", {}).str
  file_path = file_path:gsub("/", string.format(" %s ", separator))
  local navic_ok, navic = lk.safe_require("nvim-navic")
  if not navic_ok or not navic.is_available() then
    return string.format("     %s", file_path)
  end

  return string.format("     %s %s %s", file_path, separator, navic.get_location())
end

return M