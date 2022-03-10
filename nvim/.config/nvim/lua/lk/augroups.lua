local augroup = lk.augroup
local tnoremap = lk.tnoremap
local fn = vim.fn
local fmt = string.format

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
    events = { "BufWritePost" },
    targets = { "plugins.lua" },
    command = function()
      vim.api.nvim_command("luafile %")
      vim.api.nvim_command("PackerCompile")
    end,
  },
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

----------------------------------------------------------------------
-- NOTE: extend vim {{{
----------------------------------------------------------------------
augroup("OpenLastPlace", {
  {
    -- When editing a file, always jump to the last known cursor position.
    -- Don't do it for commit messages, when the position is invalid, or when
    -- inside an event handler (happens when dropping a file on gvim).
    events = { "BufReadPost" },
    targets = { "*" },
    command = function()
      vim.api.nvim_exec(
        [[
          if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
            exe "normal g`\"" |
          endif
        ]],
        true
      )
    end,
  },
  {
    events = { "BufEnter" },
    targets = { "<buffer>" },
    --- Open a repository from an authorname/repository string
    --- e.g. 'akinso/example-repo'
    command = function()
      lk.nnoremap("gf", function()
        local repo = fn.expand("<cfile>")
        if not repo or #vim.split(repo, "/") ~= 2 then
          return vim.cmd("norm! gf")
        end
        local url = fmt("https://www.github.com/%s", repo)
        fn.jobstart("xdg-open " .. url)
        vim.notify(fmt("Opening %s at %s", repo, url), "info", { title = fmt("[plugin] %s", repo) })
      end)
    end,
  },
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: filetype specific {{{
-- Set syntax highlighting for specific file types
----------------------------------------------------------------------
augroup("FileTypeSpecific", {
  {
    events = { "BufRead", "BufNewFile" },
    targets = { "*.md" },
    command = function()
      vim.bo.filetype = "markdown"
    end,
  },
  {
    events = { "BufRead", "BufNewFile" },
    targets = { ".{jscs,jshint,eslint,babel}rc" },
    command = function()
      vim.bo.filetype = "json"
    end,
  },
  {
    events = { "BufRead", "BufNewFile" },
    targets = {
      "aliases.local",
      "zshenv.local",
      "zlogin.local",
      "zlogout.local",
      "zprofile.local",
      "zshenv",
      "zlogin",
      "zlogout",
      "zprofile",
      "*/zsh/configs/*",
    },
    command = function()
      vim.bo.filetype = "sh"
    end,
  },
  {
    events = { "BufRead", "BufNewFile" },
    targets = { "gitconfig.local" },
    command = function()
      vim.bo.filetype = "gitconfig"
    end,
  },
  {
    events = { "BufRead", "BufNewFile" },
    targets = { "tmux.conf.local" },
    command = function()
      vim.bo.filetype = "tmux"
    end,
  },
  {
    events = { "BufRead", "BufNewFile" },
    targets = { "*.conf", "Caddyfile" },
    command = function()
      vim.bo.filetype = "conf"
    end,
  },
})
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
