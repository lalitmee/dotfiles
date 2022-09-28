local augroup = lk.augroup
local fmt = string.format
local fn = vim.fn

--- packer notify wrapper
---@param msg string to be shown
---@param type number of the vim.log.levels
local packer_notify = function(msg, type)
  local msg_type = type or 2
  vim.notify(msg, msg_type, { title = " Packer" })
end

----------------------------------------------------------------------
-- NOTE: packer autocommands {{{
----------------------------------------------------------------------
augroup("PackerSetupInit", {
  {
    event = { "BufWritePost" },
    description = "Packer Compile after saving plugins.lua",
    pattern = { "plugins.lua" },
    command = function()
      vim.api.nvim_command("luafile %")
      vim.api.nvim_command("PackerCompile")
    end,
  },
  {
    event = { "BufEnter" },
    description = "Open a repository from an authorname/repository string",
    buffer = 0,
    command = function()
      lk.nnoremap("gf", function()
        local repo = fn.expand("<cfile>")
        if not repo or #vim.split(repo, "/") ~= 2 then
          return vim.cmd([[norm! gf]])
        end
        local url = fmt("https://www.github.com/%s", repo)
        fn.jobstart("xdg-open " .. url)
        vim.notify(fmt("Opening %s at %s", repo, url), 2, { title = fmt(" [plugin] %s", repo) })
      end)
    end,
  },
  {
    event = { "User" },
    pattern = { "PackerCompileDone" },
    description = "Notify when packer compile done",
    command = function()
      packer_notify("Packer compile complete", nil)
    end,
  },
  {
    event = { "User" },
    pattern = { "PackerCompelete" },
    description = "Notify when packer completes the job",
    command = function()
      packer_notify("Packer has done the job", nil)
    end,
  },
})
-- }}}
----------------------------------------------------------------------
