local M = {}

----------------------------------------------------------------------
-- NOTE: relaod using telescope {{{
----------------------------------------------------------------------
function M.reload()
  -- Telescope will give us something like lk/colors.lua,
  -- so this function convert the selected entry to
  -- the module name: ju.colors
  local function get_module_name(s)
    local module_name

    module_name = s:gsub("%.lua", "")
    module_name = module_name:gsub("%/", ".")
    module_name = module_name:gsub("%.init", "")

    return module_name
  end

  local prompt_title = "~ neovim modules ~"

  -- sets the path to the lua folder
  local path = "~/.config/nvim/lua"

  local opts = {
    prompt_title = prompt_title,
    cwd = path,

    attach_mappings = function(_, map)
      -- Adds a new map to ctrl+e.
      map("i", "<c-e>", function(_)
        -- these two a very self-explanatory
        local entry = require("telescope.actions.state").get_selected_entry()
        local name = get_module_name(entry.value)

        -- call the helper method to reload the module
        -- and give some feedback
        R(name)
        vim.notify(name, "info", { title = "RELOADED" })
      end)

      return true
    end,
  }

  -- call the builtin method to list files
  require("telescope.builtin").find_files(opts)
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
--- NOTE: reload using namesapce {{{
----------------------------------------------------------------------
function M.reload_config()
  for name, _ in pairs(package.loaded) do
    if name:match("^lk") then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
  vim.notify("Config Reloaded", "info", { title = "[config] reload" })
end
-- }}}
----------------------------------------------------------------------

return M

-- vim:foldmethod=marker
