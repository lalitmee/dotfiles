local augroup = lk.augroup
local tnoremap = lk.tnoremap

----------------------------------------------------------------------
-- NOTE: command line autocommands {{{
----------------------------------------------------------------------
augroup("ClearCommandMessages", {
  {
    events = { "CmdlineLeave", "CmdlineChanged" },
    targets = { ":" },
    command = "lua require('lk.functions').clear_messages()",
  },
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: packer autocommands {{{
----------------------------------------------------------------------
augroup("PackerSetupInit", {
  {
    events = { "User PackerCompileDone" },
    command = function()
      vim.notify("Packer compiled done", nil, { title = "Packer" })
    end,
  },
  {
    events = { "User PackerComplete" },
    command = function()
      vim.notify("Packer completed the job", nil, { title = "Packer" })
    end,
  },
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: terminal autocommands {{{
----------------------------------------------------------------------
augroup("AddTerminalMappings", {
  {
    events = { "TermOpen" },
    targets = { "term://*" },
    command = function()
      if vim.bo.filetype == "" or vim.bo.filetype == "toggleterm" then
        local opts = { silent = false, buffer = 0 }
        tnoremap("<esc>", [[<C-\><C-n>]], opts)
        tnoremap("jk", [[<C-\><C-n>]], opts)
        tnoremap("<C-h>", [[<C-\><C-n><C-W>h]], opts)
        tnoremap("<C-j>", [[<C-\><C-n><C-W>j]], opts)
        tnoremap("<C-k>", [[<C-\><C-n><C-W>k]], opts)
        tnoremap("<C-l>", [[<C-\><C-n><C-W>l]], opts)
        tnoremap("]t", [[<C-\><C-n>:tablast<CR>]])
        tnoremap("[t", [[<C-\><C-n>:tabnext<CR>]])
        tnoremap("<S-Tab>", [[<C-\><C-n>:bprev<CR>]])
        tnoremap("<leader><Tab>", [[<C-\><C-n>:close \| :bnext<cr>]])
      end
      vim.cmd([[startinsert]])
    end,
  },
  {
    events = { "TermEnter" },
    targets = { "term://*" },
    command = function()
      vim.cmd([[startinsert]])
    end,
  },
  {
    events = { "TermLeave", "TermClose" },
    targets = { "term://*" },
    command = function()
      vim.cmd([[stopinsert]])
    end,
  },
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: markdown autocommands {{{
----------------------------------------------------------------------
augroup("AddTerminalMappings", {
  {
    events = { "FileType" },
    targets = { "markdown" },
    command = "MarkdownPreview",
  },
})

-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: highlight on yank {{{
----------------------------------------------------------------------
augroup("TextYankHighlight", {
  {
    events = { "TextYankPost" },
    targets = { "*" },
    command = function()
      vim.highlight.on_yank({
        higroup = "IncSearch",
        timeout = 500,
      })
    end,
  },
})
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
