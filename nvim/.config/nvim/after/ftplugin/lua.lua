local opt = vim.opt
local nnoremap = lk.nnoremap

----------------------------------------------------------------------
-- NOTE: hover doc function {{{
----------------------------------------------------------------------

local function find(word, ...)
  for _, str in ipairs({ ... }) do
    local match_start, match_end = string.find(word, str)
    if match_start then
      return str, match_start, match_end
    end
  end
end

--- Stolen from nlua.nvim this function attempts to open
--- vim help docs if an api or vim.fn function otherwise it
--- shows the lsp hover doc
--- @param word string
--- @param callback function
local function keyword(word, callback)
  local original_iskeyword = vim.bo.iskeyword

  vim.bo.iskeyword = vim.bo.iskeyword .. ",."
  word = word or vim.fn.expand("<cword>")

  vim.bo.iskeyword = original_iskeyword

  -- TODO: This is a sub par work around, since I usually rename `vim.api` -> `api` or similar
  -- consider maybe using treesitter in the future
  local api_match = find(word, "api", "vim.api")
  local fn_match = find(word, "fn", "vim.fn")
  if api_match then
    local _, finish = string.find(word, api_match .. ".")
    local api_function = string.sub(word, finish + 1)

    vim.cmd(string.format("help %s", api_function))
    return
  elseif fn_match then
    local _, finish = string.find(word, fn_match .. ".")
    if not finish then
      return
    end
    local api_function = string.sub(word, finish + 1) .. "()"

    vim.cmd(string.format("help %s", api_function))
    return
  elseif callback then
    callback()
  else
    vim.lsp.buf.hover()
  end
end

local loaded, hover

local function hover_doc()
  loaded, hover = pcall(require, "lspsaga.hover")
  local cb = loaded and hover.render_hover_doc or nil
  keyword(nil, cb)
end

nnoremap("gK", hover_doc, { buffer = 0 })
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: options {{{
----------------------------------------------------------------------
opt.colorcolumn = { "120" }
opt.expandtab = true
opt.formatoptions = opt.formatoptions - "o" -- don't continue comments on `o` and `O`
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.textwidth = 120
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
