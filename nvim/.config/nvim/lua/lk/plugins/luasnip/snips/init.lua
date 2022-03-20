local ls = require("luasnip")

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local c = ls.choice_node
local f = ls.function_node
local insert = ls.insert_node
local snippet = ls.snippet
local text = ls.text_node

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
