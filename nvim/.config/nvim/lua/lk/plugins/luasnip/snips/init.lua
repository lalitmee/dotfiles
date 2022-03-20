local ls = require("luasnip")

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node
local insert = ls.insert_node
local snippet = ls.snippet
local text = ls.text_node

local fn = vim.fn

ls.snippets = {
  all = {
    snippet({ trig = "td", name = "TODO" }, {
      c(1, {
        text("TODO: "),
        text("FIXME: "),
        text("HACK: "),
        text("BUG: "),
      }),
      insert(0),
    }),
    snippet(
      { trig = "hr", name = "Header" },
      fmt(
        [[
            {1}
            {2} {3}
            {1}
            {4}
          ]],
        {
          f(function()
            local comment = string.format(vim.bo.commentstring:gsub(" ", "") or "#%s", "-")
            local col = vim.bo.textwidth or 80
            return comment .. string.rep("-", col - #comment)
          end),
          f(function()
            return vim.bo.commentstring:gsub("%%s", "")
          end),
          insert(1, "HEADER"),
          insert(0),
        }
      )
    ),
  },
  lua = {
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
          local default = snippet("", { insert(1, "author"), text("/"), insert(2, "plugin") })
          local clip = fn.getreg("*")
          if not vim.startswith(clip, "https://github.com/") then
            return default
          end
          local parts = vim.split(clip, "/")
          if #parts < 2 then
            return default
          end
          local author, project = parts[#parts - 1], parts[#parts]
          return snippet("", { text(author .. "/" .. project) })
        end),
        c(2, {
          fmt(
            [[
              , config = function()
                require("{}").setup()
              end
              ]],
            { insert(1, "module") }
          ),
          text(""),
        }),
      })
    ),

    -- local var
    snippet("loc", fmt("local {} = {}", { insert(1, "name"), insert(2, "module/package") })),

    -- require
    snippet("req", fmt("local {} = require('{}')", { insert(1, "name"), rep(1) })),

    -- note
    snippet("note", fmt("-- NOTE: {}", { insert(1, "description") })),

    -- todo
    snippet("todo", fmt("-- TODO: {}", { insert(1, "description") })),
  },
  javascript = {
    -- todo
    snippet("clg", fmt("console.log({})", { insert(1, "name") })),
  },
}
