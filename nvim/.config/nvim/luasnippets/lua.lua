--- @diagnostic disable: undefined-global

local fn = vim.fn

return {
  -- local var
  snippet("loc", fmt("local {} = {}", { i(1, "name"), i(2, "module/package") })),

  -- require
  snippet("locr", fmt("local {} = require('{}')", { i(1, "name"), r(1) })),

  -- note
  snippet("note", fmt("-- NOTE: {}", { i(1, "description") })),

  -- todo
  snippet("todo", fmt("-- TODO: {}", { i(1, "description") })),

  -- require
  snippet(
    {
      trig = "req",
      name = "require module",
      dscr = "Require a module and set the import to the last word",
    },
    fmt([[local {} = require("{}")]], {
      f(function(import_name)
        local parts = vim.split(import_name[1][1], ".", true)
        return parts[#parts] or ""
      end, { 1 }),
      i(1),
    })
  ),
  snippet(
    {
      trig = "use",
      name = "packer use",
      dscr = {
        "packer use plugin block",
        "e.g.",
        "use {'author/plugin'}",
      },
    },
    fmt([[use {{"{}"{}}}]], {
      d(1, function()
        -- Get the author and URL in the clipboard and auto populate the author and project
        local default = snippet("", { i(1, "author"), t("/"), i(2, "plugin") })
        local clip = fn.getreg("*")
        if not vim.startswith(clip, "https://github.com/") then
          return default
        end
        local parts = vim.split(clip, "/")
        if #parts < 2 then
          return default
        end
        local author, project = parts[#parts - 1], parts[#parts]
        return snippet("", { t(author .. "/" .. project) })
      end),
      c(2, {
        fmt(
          [[
              , config = function()
                require("{}").setup()
              end
          ]],
          { i(1, "module") }
        ),
        t(""),
      }),
    })
  ),
  snippet("sre", fmt('local {}, {} = lk.safe_require("{}")', { i(1, 'ok'), i(2, 'package'), r(2, 'pacakge') })),
}
