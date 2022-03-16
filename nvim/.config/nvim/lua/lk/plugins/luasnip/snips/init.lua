local ls = require("luasnip")
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local rep = require("luasnip.extras").rep

ls.snippets = {
  all = {
    -- ls.parser.parse_snippet("expand", "-- this is just expanded thing"),
  },
  lua = {
    -- local var
    s("loc", fmt("local {} = {}", { i(1, "name"), i(2, "module/package") })),

    -- require
    s("req", fmt("local {} = require('{}')", { i(1, "name"), rep(1) })),

    -- note
    s("note", fmt("-- NOTE: {}", { i(1, "description") })),

    -- todo
    s("todo", fmt("-- TODO: {}", { i(1, "description") })),
  },
}
