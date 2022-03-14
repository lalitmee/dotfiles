local augroup = lk.augroup
local tnoremap = lk.tnoremap
local fn = vim.fn
local fmt = string.format

----------------------------------------------------------------------
-- NOTE: command line autocommands {{{
----------------------------------------------------------------------
--- automatically clear commandline messages after a few seconds delay
--- source: http://unix.stackexchange.com/a/613645
---@return function
local function clear_commandline()
  --- Track the timer object and stop any previous timers before setting
  --- a new one so that each change waits for 10secs and that 10secs is
  --- deferred each time
  local timer
  return function()
    if timer then
      timer:stop()
    end
    timer = vim.defer_fn(function()
      if fn.mode() == "n" then
        vim.cmd([[echon '']])
      end
    end, 10000)
  end
end

augroup("ClearCommandMessages", {
  {
    event = { "CmdlineLeave", "CmdlineChanged" },
    pattern = { ":" },
    command = clear_commandline(),
  },
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: packer autocommands {{{
----------------------------------------------------------------------
augroup("PackerSetupInit", {
  {
    event = "BufWritePost",
    description = "Packer Compile after saving plugins.lua",
    pattern = { "plugins.lua" },
    command = function()
      vim.api.nvim_command("luafile %")
      vim.api.nvim_command("PackerCompile")
    end,
  },
  {
    event = "BufEnter",
    description = "Open a repository from an authorname/repository string",
    buffer = 0,
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
  -- FIXME: user autocommands are triggered multiple times
  -- {
  -- event = 'User PackerCompileDone',
  -- command = function()
  --   print 'calling compile done'
  --   vim.notify('Packer compile complete', nil, { title = 'Packer' })
  -- end,
  -- },
})

vim.cmd([[autocmd! User PackerCompileDone lua vim.notify('Packer compile complete', 'info', { title = 'Packer' })]])
vim.cmd([[autocmd! User PackerComplete lua vim.notify('Packer has done the job', 'info', { title = 'Packer' })]])
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: terminal autocommands {{{
----------------------------------------------------------------------
augroup("AddTerminalMappings", {
  {
    event = { "TermOpen" },
    pattern = { "term://*" },
    command = function()
      if vim.bo.filetype == "" or vim.bo.filetype == "toggleterm" then
        local opts = { silent = false, buffer = 0 }
        tnoremap("<esc>", [[<C-\><C-n>]], opts)
        tnoremap("jk", [[<C-\><C-n>]], opts)
        tnoremap("<C-h>", [[<C-\><C-n><C-W>h]], opts)
        tnoremap("<C-j>", [[<C-\><C-n><C-W>j]], opts)
        tnoremap("<C-k>", [[<C-\><C-n><C-W>k]], opts)
        tnoremap("<C-l>", [[<C-\><C-n><C-W>l]], opts)
        tnoremap("<BS>", [[<BS>]], opts)
      end
      vim.cmd([[startinsert]])
    end,
  },
  {
    event = { "TermEnter" },
    pattern = { "term://*" },
    command = function()
      vim.cmd([[startinsert]])
    end,
  },
  {
    event = { "TermLeave", "TermClose" },
    pattern = { "term://*" },
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
    -- don't execute silently in case of errors
    event = { "TextYankPost" },
    command = function()
      vim.highlight.on_yank({
        timeout = 500,
        on_visual = false,
        higroup = "IncSearch",
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
    event = { "BufReadPost" },
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
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: formatter {{{
----------------------------------------------------------------------
lk.augroup("FormatterAutogroup", {
  {
    event = "BufWritePost",
    pattern = {
      "*.js",
      "*.jsx",
      "*.mjs",
      "*.ts",
      "*.tsx",
      "*.css",
      "*.less",
      "*.scss",
      "*.json",
      "*.graphql",
      "*.md",
      "*.vue",
      "*.yaml",
      "*.html",
      "*.rs",
      "*.lua",
    },
    command = function()
      vim.cmd("FormatWrite")
    end,
  },
})
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
